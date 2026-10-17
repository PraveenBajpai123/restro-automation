-- =============================================================================
-- Unified Restaurant QR Ordering & Loyalty Platform — core schema (Supabase / Postgres 15+)
--
-- Conventions
--   * Money is stored as INTEGER PAISE (₹1 = 100 paise). Never floats.
--   * Rates are stored in BASIS POINTS (250 bp = 2.5%).
--   * 1 Store Coin = ₹1 = 100 paise. Coins are whole integers.
--   * Customers never write tables directly. All writes go through SECURITY DEFINER
--     functions (place_order, set_order_status, ...) that re-price everything server-side.
-- =============================================================================

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------
create type staff_role         as enum ('owner', 'manager', 'cashier', 'kitchen');
create type order_mode         as enum ('dine_in', 'takeaway');
create type order_status       as enum (
  'awaiting_payment',   -- Razorpay checkout opened, waiting for webhook
  'awaiting_approval',  -- Pay-at-counter / UPI-intent: staff must approve on KDS before kitchen sees it
  'placed',             -- fired to kitchen  (customer sees "Placed")
  'preparing',          --                   (customer sees "Preparing")
  'ready',              --                   (customer sees "Ready for Pickup" / "Being served")
  'completed',          -- picked up / served -> loyalty coins credited
  'cancelled',
  'rejected'            -- staff declined an awaiting_approval order
);
create type payment_method     as enum ('razorpay', 'upi_intent', 'pay_at_counter');
create type payment_status     as enum ('unpaid', 'pending_verification', 'paid', 'failed', 'refunded');
create type ledger_entry_type  as enum ('earn', 'burn', 'reversal', 'adjustment', 'expiry');

-- ---------------------------------------------------------------------------
-- Outlet (replaces DMO `settings/app` doc + ngachoan hardcoded header)
-- ---------------------------------------------------------------------------
create table outlets (
  id                      uuid primary key default gen_random_uuid(),
  slug                    text not null unique check (slug ~ '^[a-z0-9-]{2,40}$'),
  name                    text not null,
  legal_name              text,
  gstin                   text check (gstin is null or gstin ~ '^[0-9]{2}[A-Z0-9]{10}[0-9A-Z]{3}$'),
  fssai_license           text,
  address                 text,
  phone                   text,
  logo_url                text,
  timezone                text not null default 'Asia/Kolkata',
  -- GST: restaurant service @5% without ITC = CGST 2.5% + SGST 2.5%
  cgst_rate_bp            int  not null default 250 check (cgst_rate_bp between 0 and 1400),
  sgst_rate_bp            int  not null default 250 check (sgst_rate_bp between 0 and 1400),
  invoice_prefix          text not null default 'INV' check (length(invoice_prefix) between 1 and 4),
  -- Loyalty "Earn & Burn"
  loyalty_enabled         boolean not null default true,
  loyalty_earn_bp         int  not null default 500  check (loyalty_earn_bp between 0 and 10000),  -- 5% back
  loyalty_max_redeem_bp   int  not null default 5000 check (loyalty_max_redeem_bp between 0 and 10000), -- max 50% of subtotal
  loyalty_min_redeem_coins int not null default 0   check (loyalty_min_redeem_coins >= 0),
  -- Payments (Razorpay key_secret lives in Edge Function secrets, NEVER here: this table is public-readable)
  upi_vpa                 text,          -- merchant VPA for upi:// intent links
  upi_payee_name          text,
  razorpay_enabled        boolean not null default false,
  upi_intent_enabled      boolean not null default false,
  pay_at_counter_enabled  boolean not null default true,
  -- Order modes & tokens
  dine_in_enabled         boolean not null default true,
  takeaway_enabled        boolean not null default true,
  require_table_key       boolean not null default false, -- if true, QR must carry &k=<qr_key>
  token_start             int  not null default 101,
  token_end               int  not null default 999,
  is_open                 boolean not null default true,
  created_at              timestamptz not null default now(),
  updated_at              timestamptz not null default now(),
  check (token_start > 0 and token_end > token_start)
);

-- ---------------------------------------------------------------------------
-- Staff (replaces ngachoan hardcoded emails + DMO `staff/{uid}` docs)
-- ---------------------------------------------------------------------------
create table staff_profiles (
  user_id       uuid primary key references auth.users(id) on delete cascade,
  outlet_id     uuid not null references outlets(id) on delete cascade,
  display_name  text not null,
  role          staff_role not null,
  is_active     boolean not null default true,
  created_at    timestamptz not null default now()
);

-- ---------------------------------------------------------------------------
-- Tables (QR targets)  ->  /menu?table=5[&k=<qr_key>]
-- ---------------------------------------------------------------------------
create table dining_tables (
  id          uuid primary key default gen_random_uuid(),
  outlet_id   uuid not null references outlets(id) on delete cascade,
  label       text not null,                                   -- "5", "T12", "Patio-2"
  qr_key      text not null default substr(md5(gen_random_uuid()::text), 1, 8),
  seats       smallint,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now(),
  unique (outlet_id, label)
);

-- ---------------------------------------------------------------------------
-- Menu
-- ---------------------------------------------------------------------------
create table menu_categories (
  id          uuid primary key default gen_random_uuid(),
  outlet_id   uuid not null references outlets(id) on delete cascade,
  name        text not null,
  sort_order  int  not null default 0,
  is_active   boolean not null default true,
  unique (outlet_id, name)
);

create table menu_items (
  id                uuid primary key default gen_random_uuid(),
  outlet_id         uuid not null references outlets(id) on delete cascade,
  category_id       uuid references menu_categories(id) on delete set null,
  name              text not null,
  description       text,
  image_url         text,
  base_price_paise  int  not null check (base_price_paise >= 0),
  is_veg            boolean,                 -- FSSAI veg / non-veg mark; null = not food (e.g. merch)
  is_bestseller     boolean not null default false,
  hsn_sac           text not null default '996331', -- SAC for restaurant services
  is_available      boolean not null default true,  -- "86" toggle (temporarily out)
  is_active         boolean not null default true,  -- soft delete
  sort_order        int  not null default 0,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

-- A group is either a required VARIATION (min=1,max=1: Size Regular/Large)
-- or OPTIONAL ADD-ONS (min=0,max=N: Extra Shot, Cheese Dip). UI: max_select=1 -> radio, else checkboxes.
create table modifier_groups (
  id          uuid primary key default gen_random_uuid(),
  outlet_id   uuid not null references outlets(id) on delete cascade,
  name        text not null,                 -- "Size", "Coffee Add-ons", "Dips"
  min_select  int  not null default 0 check (min_select >= 0),
  max_select  int  check (max_select is null or max_select >= 1),
  sort_order  int  not null default 0,
  is_active   boolean not null default true,
  check (max_select is null or max_select >= min_select)
);

create table modifier_options (
  id                 uuid primary key default gen_random_uuid(),
  group_id           uuid not null references modifier_groups(id) on delete cascade,
  name               text not null,          -- "Large", "Extra Shot"
  price_delta_paise  int  not null default 0 check (price_delta_paise >= 0),  -- +₹40 = 4000
  is_default         boolean not null default false,
  is_veg             boolean,
  is_available       boolean not null default true,
  sort_order         int  not null default 0
);

-- Groups are reusable: "Coffee Add-ons" can attach to every coffee.
create table menu_item_modifier_groups (
  menu_item_id  uuid not null references menu_items(id) on delete cascade,
  group_id      uuid not null references modifier_groups(id) on delete cascade,
  sort_order    int  not null default 0,
  primary key (menu_item_id, group_id)
);

-- ---------------------------------------------------------------------------
-- Customers & Loyalty wallet
-- ---------------------------------------------------------------------------
create table customers (
  id                     uuid primary key default gen_random_uuid(),
  auth_user_id           uuid unique references auth.users(id) on delete set null, -- Supabase phone-OTP user
  phone                  text not null unique check (phone ~ '^\+[1-9][0-9]{7,14}$'), -- E.164, e.g. +919876543210
  name                   text,
  coin_balance           int  not null default 0 check (coin_balance >= 0), -- cache of ledger; only post_loyalty_entry writes it
  lifetime_coins_earned  int  not null default 0,
  total_orders           int  not null default 0,
  total_spent_paise      bigint not null default 0,
  marketing_opt_in       boolean not null default false,
  created_at             timestamptz not null default now(),
  last_order_at          timestamptz
);

-- ---------------------------------------------------------------------------
-- Orders (replaces ngachoan `orders` row with JSON items + DMO `orders` docs)
-- ---------------------------------------------------------------------------
create table orders (
  id                  uuid primary key default gen_random_uuid(),
  outlet_id           uuid not null references outlets(id),
  tracking_key        text not null unique default replace(gen_random_uuid()::text, '-', ''), -- unguessable, for customer status page
  mode                order_mode not null,
  table_id            uuid references dining_tables(id),
  token_number        int  not null,                 -- #104, resets daily, shown for both modes
  business_date       date not null,                 -- IST date, used for tokens & reports
  invoice_number      text unique,                   -- GST Rule 46 consecutive serial, assigned when paid
  customer_id         uuid references customers(id),
  customer_name       text,
  status              order_status   not null,
  payment_method      payment_method not null,
  payment_status      payment_status not null default 'unpaid',
  -- Bill (all paise)
  subtotal_paise      int not null check (subtotal_paise >= 0),         -- Σ line totals incl. modifiers
  coins_redeemed      int not null default 0 check (coins_redeemed >= 0),
  taxable_paise       int not null check (taxable_paise >= 0),          -- subtotal − coins×100
  cgst_rate_bp        int not null,
  sgst_rate_bp        int not null,
  cgst_paise          int not null,
  sgst_paise          int not null,
  round_off_paise     int not null default 0 check (round_off_paise between -50 and 50),
  grand_total_paise   int not null check (grand_total_paise >= 0),
  coins_earned        int not null default 0 check (coins_earned >= 0), -- projected at placement, credited on completion
  notes               text,
  approved_by         uuid references auth.users(id),
  approved_at         timestamptz,
  placed_at           timestamptz,
  preparing_at        timestamptz,
  ready_at            timestamptz,
  completed_at        timestamptz,
  cancelled_at        timestamptz,
  cancel_reason       text,
  created_at          timestamptz not null default now(),
  updated_at          timestamptz not null default now(),
  check (mode <> 'dine_in' or table_id is not null),
  check (taxable_paise = subtotal_paise - coins_redeemed * 100),
  check (grand_total_paise = taxable_paise + cgst_paise + sgst_paise + round_off_paise),
  check (status not in ('placed','preparing','ready','completed') or payment_status = 'paid')
);

create table order_items (
  id                uuid primary key default gen_random_uuid(),
  order_id          uuid not null references orders(id) on delete cascade,
  menu_item_id      uuid references menu_items(id) on delete set null,
  item_name         text not null,             -- snapshot: menu edits never rewrite history
  is_veg            boolean,
  base_price_paise  int  not null,
  modifiers_paise   int  not null default 0,   -- Σ option deltas for ONE unit
  unit_price_paise  int  generated always as (base_price_paise + modifiers_paise) stored,
  quantity          int  not null check (quantity between 1 and 50),
  line_total_paise  int  generated always as ((base_price_paise + modifiers_paise) * quantity) stored,
  notes             text,
  created_at        timestamptz not null default now()
);

create table order_item_modifiers (
  id                  uuid primary key default gen_random_uuid(),
  order_item_id       uuid not null references order_items(id) on delete cascade,
  modifier_option_id  uuid references modifier_options(id) on delete set null,
  group_name          text not null,           -- snapshot
  option_name         text not null,           -- snapshot
  price_delta_paise   int  not null
);

create table payments (
  id                   uuid primary key default gen_random_uuid(),
  order_id             uuid not null references orders(id) on delete restrict,
  method               payment_method not null,
  status               payment_status not null,
  amount_paise         int  not null check (amount_paise >= 0),
  provider_order_id    text unique,            -- Razorpay order_id
  provider_payment_id  text unique,            -- Razorpay payment_id
  upi_ref              text,                   -- UTR typed by staff when verifying a UPI-intent payment
  verified_by          uuid references auth.users(id),
  raw                  jsonb,                  -- webhook payload
  created_at           timestamptz not null default now(),
  updated_at           timestamptz not null default now()
);

-- Append-only wallet ledger. customers.coin_balance is a cache of SUM(coins).
create table loyalty_ledger (
  id             bigint generated always as identity primary key,
  customer_id    uuid not null references customers(id),
  order_id       uuid references orders(id),
  entry_type     ledger_entry_type not null,
  coins          int  not null check (coins <> 0),   -- +earn / −burn
  balance_after  int  not null check (balance_after >= 0),
  reverses_id    bigint unique references loyalty_ledger(id),
  note           text,
  created_by     uuid,
  created_at     timestamptz not null default now()
);
-- At most one earn and one burn per order (idempotency for retries / double webhooks)
create unique index loyalty_one_earn_burn_per_order
  on loyalty_ledger (order_id, entry_type) where order_id is not null and entry_type in ('earn', 'burn');

-- Status history (replaces DMO `activityLogs` for orders; also feeds prep-time analytics)
create table order_events (
  id           bigint generated always as identity primary key,
  order_id     uuid not null references orders(id) on delete cascade,
  from_status  order_status,
  to_status    order_status not null,
  actor        uuid,
  created_at   timestamptz not null default now()
);

-- Counters: plain tables (not sequences) so numbers are gap-free inside a transaction
create table token_counters (
  outlet_id      uuid not null references outlets(id) on delete cascade,
  business_date  date not null,
  last_token     int  not null,
  primary key (outlet_id, business_date)
);
create table invoice_counters (
  outlet_id    uuid not null references outlets(id) on delete cascade,
  fiscal_year  text not null,   -- '2627' = FY 2026-27 (Apr–Mar)
  last_seq     int  not null,
  primary key (outlet_id, fiscal_year)
);

-- ---------------------------------------------------------------------------
-- Indexes
-- ---------------------------------------------------------------------------
create index orders_kds_idx        on orders (outlet_id, status, created_at)
  where status in ('awaiting_approval', 'placed', 'preparing', 'ready');
create index orders_report_idx     on orders (outlet_id, business_date) where status = 'completed';
create index orders_customer_idx   on orders (customer_id, created_at desc);
create index order_items_order_idx on order_items (order_id);
create index oim_item_idx          on order_item_modifiers (order_item_id);
create index payments_order_idx    on payments (order_id);
create index ledger_customer_idx   on loyalty_ledger (customer_id, created_at desc);
create index order_events_idx      on order_events (order_id, created_at);
create index menu_items_cat_idx    on menu_items (outlet_id, category_id, sort_order);
create index mod_options_group_idx on modifier_options (group_id, sort_order);

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------
create or replace function tg_set_updated_at() returns trigger language plpgsql as $$
begin new.updated_at := now(); return new; end $$;

create trigger outlets_updated    before update on outlets    for each row execute function tg_set_updated_at();
create trigger menu_items_updated before update on menu_items for each row execute function tg_set_updated_at();
create trigger payments_updated   before update on payments   for each row execute function tg_set_updated_at();

create or replace function staff_role_for(p_outlet uuid) returns staff_role
language sql stable security definer set search_path = public as $$
  select role from staff_profiles where user_id = auth.uid() and outlet_id = p_outlet and is_active
$$;

create or replace function has_role(p_outlet uuid, p_roles staff_role[]) returns boolean
language sql stable security definer set search_path = public as $$
  select coalesce(staff_role_for(p_outlet) = any(p_roles), false)
$$;

create or replace function is_any_staff(p_roles staff_role[]) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from staff_profiles where user_id = auth.uid() and is_active and role = any(p_roles))
$$;

create or replace function outlet_today(p_outlet uuid) returns date
language sql stable as $$
  select (now() at time zone timezone)::date from outlets where id = p_outlet
$$;

-- Daily token: 101, 102, ... wraps to token_start after token_end. Row lock makes it race-safe.
create or replace function next_token(p_outlet uuid) returns int
language plpgsql security definer set search_path = public as $$
declare o outlets; v_token int;
begin
  select * into o from outlets where id = p_outlet;
  insert into token_counters as tc (outlet_id, business_date, last_token)
  values (p_outlet, (now() at time zone o.timezone)::date, o.token_start)
  on conflict (outlet_id, business_date) do update
    set last_token = case when tc.last_token >= o.token_end then o.token_start else tc.last_token + 1 end
  returning last_token into v_token;
  return v_token;
end $$;

-- GST invoice no.: INV/2627/000123 (≤16 chars, consecutive per financial year)
create or replace function next_invoice_number(p_outlet uuid) returns text
language plpgsql security definer set search_path = public as $$
declare o outlets; d date; fy text; v_seq int;
begin
  select * into o from outlets where id = p_outlet;
  d := (now() at time zone o.timezone)::date;
  fy := case when extract(month from d) >= 4
             then to_char(d, 'YY') || to_char(d + interval '1 year', 'YY')
             else to_char(d - interval '1 year', 'YY') || to_char(d, 'YY') end;
  insert into invoice_counters as ic (outlet_id, fiscal_year, last_seq) values (p_outlet, fy, 1)
  on conflict (outlet_id, fiscal_year) do update set last_seq = ic.last_seq + 1
  returning last_seq into v_seq;
  return o.invoice_prefix || '/' || fy || '/' || lpad(v_seq::text, 6, '0');
end $$;

-- The ONLY writer of coin balances. Locks the customer row, so concurrent burns can't overspend.
create or replace function post_loyalty_entry(
  p_customer uuid, p_order uuid, p_type ledger_entry_type, p_coins int,
  p_note text default null, p_reverses bigint default null
) returns bigint
language plpgsql security definer set search_path = public as $$
declare v_balance int; v_id bigint;
begin
  if p_coins = 0 then return null; end if;
  select coin_balance into v_balance from customers where id = p_customer for update;
  if not found then raise exception 'customer % not found', p_customer; end if;
  v_balance := v_balance + p_coins;
  if v_balance < 0 then raise exception 'Insufficient coins' using errcode = 'P0001'; end if;
  insert into loyalty_ledger (customer_id, order_id, entry_type, coins, balance_after, reverses_id, note, created_by)
  values (p_customer, p_order, p_type, p_coins, v_balance, p_reverses, p_note, auth.uid())
  returning id into v_id;
  update customers
     set coin_balance = v_balance,
         lifetime_coins_earned = lifetime_coins_earned + case when p_type = 'earn' then p_coins else 0 end
   where id = p_customer;
  return v_id;
end $$;

-- Push status to the customer's phone over a public broadcast topic keyed by the unguessable tracking_key.
-- (Anonymous diners can't use postgres_changes on `orders` because RLS hides the table from them.)
create or replace function broadcast_order_update(o orders) returns void
language plpgsql security definer set search_path = public as $$
begin
  perform realtime.send(
    jsonb_build_object('status', o.status, 'payment_status', o.payment_status,
                       'token', o.token_number, 'updated_at', now()),
    'status', 'order:' || o.tracking_key, false);
end $$;

-- ---------------------------------------------------------------------------
-- Order lifecycle triggers
-- ---------------------------------------------------------------------------
create or replace function tg_orders_before_update() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  if new.status is distinct from old.status then
    case new.status
      when 'placed'    then new.placed_at    := coalesce(new.placed_at, now());
      when 'preparing' then new.preparing_at := now();
      when 'ready'     then new.ready_at     := now();
      when 'completed' then new.completed_at := now();
      when 'cancelled', 'rejected' then new.cancelled_at := now();
      else null;
    end case;
  end if;
  if new.payment_status = 'paid' and old.payment_status is distinct from 'paid' and new.invoice_number is null then
    new.invoice_number := next_invoice_number(new.outlet_id);
  end if;
  new.updated_at := now();
  return new;
end $$;

create or replace function tg_orders_after_update() returns trigger
language plpgsql security definer set search_path = public as $$
declare v_burn_id bigint;
begin
  if new.status is distinct from old.status then
    insert into order_events (order_id, from_status, to_status, actor)
    values (new.id, old.status, new.status, auth.uid());

    if new.customer_id is not null and new.status = 'completed' then
      -- EARN: credit projected coins once
      if new.coins_earned > 0 and not exists
         (select 1 from loyalty_ledger where order_id = new.id and entry_type = 'earn') then
        perform post_loyalty_entry(new.customer_id, new.id, 'earn', new.coins_earned,
                                   'Earned on token #' || new.token_number);
      end if;
      update customers
         set total_orders = total_orders + 1,
             total_spent_paise = total_spent_paise + new.grand_total_paise,
             last_order_at = now()
       where id = new.customer_id;

    elsif new.customer_id is not null and new.status in ('cancelled', 'rejected') then
      -- Give back any coins burned on this order
      select id into v_burn_id from loyalty_ledger where order_id = new.id and entry_type = 'burn';
      if v_burn_id is not null and not exists (select 1 from loyalty_ledger where reverses_id = v_burn_id) then
        perform post_loyalty_entry(new.customer_id, new.id, 'reversal', new.coins_redeemed,
                                   'Coins returned: order ' || new.status, v_burn_id);
      end if;
    end if;
  end if;

  if new.status is distinct from old.status or new.payment_status is distinct from old.payment_status then
    perform broadcast_order_update(new);
  end if;
  return null;
end $$;

create trigger orders_before_update before update on orders for each row execute function tg_orders_before_update();
create trigger orders_after_update  after  update on orders for each row execute function tg_orders_after_update();

-- ---------------------------------------------------------------------------
-- API: place_order  (replaces ngachoan `supabase.from('orders').insert()` and DMO `addDoc(orders)`)
--
-- p = {
--   "outlet_slug": "nbc-demo",
--   "mode": "dine_in" | "takeaway",
--   "table_label": "5", "table_key": "ab12cd34",        -- dine_in only
--   "payment_method": "razorpay" | "upi_intent" | "pay_at_counter",
--   "redeem_coins": true,
--   "customer_name": "Asha", "notes": "less ice",
--   "items": [ { "menu_item_id": "...", "quantity": 2, "option_ids": ["..."], "notes": "" } ]
-- }
-- Prices in the payload are IGNORED. The customer identity comes from the phone-OTP JWT (auth.uid()).
-- ---------------------------------------------------------------------------
create or replace function place_order(p jsonb) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  o           outlets;
  v_table     dining_tables;
  v_customer  customers;
  v_mode      order_mode     := (p->>'mode')::order_mode;
  v_method    payment_method := (p->>'payment_method')::payment_method;
  v_order_id  uuid := gen_random_uuid();
  v_item_id   uuid;
  it          jsonb;
  mi          menu_items;
  g           record;
  v_qty       int;
  v_opts      uuid[];
  v_mod       int;
  v_subtotal  int := 0;
  v_redeem    int := 0;
  v_taxable   int;
  v_cgst      int;
  v_sgst      int;
  v_raw       int;
  v_total     int;
  v_earn      int := 0;
  v_status    order_status;
  v_pstatus   payment_status;
  v_res       orders;
begin
  select * into o from outlets where slug = p->>'outlet_slug';
  if not found then raise exception 'Outlet not found' using errcode = 'P0001'; end if;
  if not o.is_open then raise exception 'Outlet is closed right now' using errcode = 'P0001'; end if;

  -- Mode
  if v_mode = 'dine_in' then
    if not o.dine_in_enabled then raise exception 'Dine-in is disabled' using errcode = 'P0001'; end if;
    select * into v_table from dining_tables
     where outlet_id = o.id and label = p->>'table_label' and is_active
       and (not o.require_table_key or qr_key = p->>'table_key');
    if not found then raise exception 'Invalid table. Please re-scan the QR code.' using errcode = 'P0001'; end if;
  elsif not o.takeaway_enabled then
    raise exception 'Takeaway is disabled' using errcode = 'P0001';
  end if;

  -- Payment method
  if (v_method = 'razorpay' and not o.razorpay_enabled)
     or (v_method = 'upi_intent' and (not o.upi_intent_enabled or o.upi_vpa is null))
     or (v_method = 'pay_at_counter' and not o.pay_at_counter_enabled) then
    raise exception 'Payment method % not available', v_method using errcode = 'P0001';
  end if;

  -- Customer (optional; anonymous orders allowed, they just don't earn coins)
  if auth.uid() is not null then
    select * into v_customer from customers where auth_user_id = auth.uid();
  end if;

  if jsonb_typeof(p->'items') is distinct from 'array' or jsonb_array_length(p->'items') = 0 then
    raise exception 'Cart is empty' using errcode = 'P0001';
  end if;
  if jsonb_array_length(p->'items') > 50 then raise exception 'Too many lines' using errcode = 'P0001'; end if;

  v_status  := case when v_method = 'razorpay' then 'awaiting_payment' else 'awaiting_approval' end;
  v_pstatus := case when v_method = 'upi_intent' then 'pending_verification' else 'unpaid' end;

  insert into orders (id, outlet_id, mode, table_id, token_number, business_date, customer_id, customer_name,
                      status, payment_method, payment_status, subtotal_paise, taxable_paise,
                      cgst_rate_bp, sgst_rate_bp, cgst_paise, sgst_paise, grand_total_paise, notes)
  values (v_order_id, o.id, v_mode, v_table.id, next_token(o.id), (now() at time zone o.timezone)::date,
          v_customer.id, coalesce(nullif(btrim(p->>'customer_name'), ''), v_customer.name),
          v_status, v_method, v_pstatus, 0, 0, o.cgst_rate_bp, o.sgst_rate_bp, 0, 0, 0, left(p->>'notes', 300));

  for it in select * from jsonb_array_elements(p->'items') loop
    v_qty := (it->>'quantity')::int;
    if v_qty is null or v_qty not between 1 and 50 then
      raise exception 'Invalid quantity' using errcode = 'P0001';
    end if;

    select * into mi from menu_items
     where id = (it->>'menu_item_id')::uuid and outlet_id = o.id and is_active and is_available;
    if not found then raise exception 'An item in your cart is no longer available' using errcode = 'P0001'; end if;

    v_opts := coalesce(array(select jsonb_array_elements_text(coalesce(it->'option_ids', '[]'::jsonb))::uuid), '{}');
    if cardinality(v_opts) <> (select count(distinct x) from unnest(v_opts) x) then
      raise exception 'Duplicate add-on' using errcode = 'P0001';
    end if;

    -- every option must be available and belong to an active group attached to THIS item
    if exists (
      select 1 from unnest(v_opts) x
       where not exists (
         select 1 from modifier_options mo
           join modifier_groups gr on gr.id = mo.group_id and gr.is_active
           join menu_item_modifier_groups mg on mg.group_id = mo.group_id and mg.menu_item_id = mi.id
          where mo.id = x and mo.is_available)) then
      raise exception 'Invalid option for %', mi.name using errcode = 'P0001';
    end if;

    -- enforce min/max per group (e.g. Size is required: exactly one)
    for g in
      select gr.name, gr.min_select, gr.max_select,
             (select count(*) from modifier_options mo where mo.group_id = gr.id and mo.id = any(v_opts)) as n
        from menu_item_modifier_groups mg
        join modifier_groups gr on gr.id = mg.group_id and gr.is_active
       where mg.menu_item_id = mi.id
    loop
      if g.n < g.min_select or (g.max_select is not null and g.n > g.max_select) then
        raise exception 'Please choose % for %', g.name, mi.name using errcode = 'P0001';
      end if;
    end loop;

    select coalesce(sum(price_delta_paise), 0) into v_mod from modifier_options where id = any(v_opts);

    insert into order_items (order_id, menu_item_id, item_name, is_veg, base_price_paise, modifiers_paise, quantity, notes)
    values (v_order_id, mi.id, mi.name, mi.is_veg, mi.base_price_paise, v_mod, v_qty, left(it->>'notes', 200))
    returning id into v_item_id;

    insert into order_item_modifiers (order_item_id, modifier_option_id, group_name, option_name, price_delta_paise)
    select v_item_id, mo.id, gr.name, mo.name, mo.price_delta_paise
      from modifier_options mo join modifier_groups gr on gr.id = mo.group_id
     where mo.id = any(v_opts)
     order by gr.sort_order, mo.sort_order;

    v_subtotal := v_subtotal + (mi.base_price_paise + v_mod) * v_qty;
  end loop;

  -- Burn: whole coins only, capped by balance and by max-redeem % of subtotal
  if coalesce((p->>'redeem_coins')::boolean, false) and v_customer.id is not null and o.loyalty_enabled then
    v_redeem := least(v_customer.coin_balance, floor(v_subtotal::numeric * o.loyalty_max_redeem_bp / 10000 / 100)::int);
    if v_redeem < greatest(o.loyalty_min_redeem_coins, 1) then v_redeem := 0; end if;
  end if;

  -- GST on the post-discount value (coins treated as an invoice-level discount — confirm with your CA)
  v_taxable := v_subtotal - v_redeem * 100;
  v_cgst    := round(v_taxable::numeric * o.cgst_rate_bp / 10000);
  v_sgst    := round(v_taxable::numeric * o.sgst_rate_bp / 10000);
  v_raw     := v_taxable + v_cgst + v_sgst;
  v_total   := round(v_raw::numeric / 100) * 100;        -- round to nearest rupee, show round-off line

  -- Earn: X% of the net pre-tax amount (no earning on coins you burned)
  if v_customer.id is not null and o.loyalty_enabled then
    v_earn := floor(v_taxable::numeric * o.loyalty_earn_bp / 10000 / 100)::int;
  end if;

  if v_total = 0 then  -- fully covered (only possible if max_redeem is 100%)
    v_status := 'placed'; v_pstatus := 'paid';
  end if;

  update orders
     set subtotal_paise = v_subtotal, coins_redeemed = v_redeem, taxable_paise = v_taxable,
         cgst_paise = v_cgst, sgst_paise = v_sgst, round_off_paise = v_total - v_raw,
         grand_total_paise = v_total, coins_earned = v_earn,
         status = v_status, payment_status = v_pstatus
   where id = v_order_id
  returning * into v_res;

  if v_redeem > 0 then
    perform post_loyalty_entry(v_customer.id, v_order_id, 'burn', -v_redeem, 'Redeemed on token #' || v_res.token_number);
  end if;

  insert into payments (order_id, method, status, amount_paise)
  values (v_order_id, v_method, v_pstatus, v_total);

  return jsonb_build_object(
    'order_id', v_res.id, 'tracking_key', v_res.tracking_key, 'token_number', v_res.token_number,
    'status', v_res.status, 'payment_method', v_res.payment_method,
    'subtotal_paise', v_res.subtotal_paise, 'coins_redeemed', v_res.coins_redeemed,
    'taxable_paise', v_res.taxable_paise, 'cgst_paise', v_res.cgst_paise, 'sgst_paise', v_res.sgst_paise,
    'round_off_paise', v_res.round_off_paise, 'grand_total_paise', v_res.grand_total_paise,
    'coins_earned', v_res.coins_earned,
    'upi', case when v_method = 'upi_intent'
                then jsonb_build_object('vpa', o.upi_vpa, 'payee', coalesce(o.upi_payee_name, o.name)) end);
end $$;

-- ---------------------------------------------------------------------------
-- API: staff status changes (KDS / counter). Replaces direct `.update({status})` calls.
-- ---------------------------------------------------------------------------
create or replace function set_order_status(p_order uuid, p_to order_status, p_note text default null, p_upi_ref text default null)
returns orders
language plpgsql security definer set search_path = public as $$
declare o orders; r staff_role; ok boolean; approving boolean;
begin
  select * into o from orders where id = p_order for update;
  if not found then raise exception 'Order not found' using errcode = 'P0001'; end if;
  r := staff_role_for(o.outlet_id);
  if r is null then raise exception 'Not authorised' using errcode = '42501'; end if;

  ok := case
    when o.status = 'awaiting_approval' and p_to in ('placed', 'rejected') then r in ('owner', 'manager', 'cashier')
    when o.status = 'awaiting_payment'  and p_to = 'cancelled'              then r in ('owner', 'manager', 'cashier')
    when o.status = 'placed'    and p_to = 'preparing' then true
    when o.status = 'preparing' and p_to = 'ready'     then true
    when o.status = 'ready'     and p_to = 'completed' then true
    when o.status in ('placed', 'preparing', 'ready') and p_to = 'cancelled' then r in ('owner', 'manager')
    else false end;
  if not ok then
    raise exception 'Cannot move order from % to % as %', o.status, p_to, r using errcode = 'P0001';
  end if;

  approving := o.status = 'awaiting_approval' and p_to = 'placed';

  update orders
     set status         = p_to,
         payment_status = case when approving then 'paid'::payment_status
                               when p_to = 'rejected' and payment_status = 'pending_verification' then 'failed'::payment_status
                               else payment_status end,
         approved_by    = case when approving then auth.uid() else approved_by end,
         approved_at    = case when approving then now() else approved_at end,
         cancel_reason  = case when p_to in ('cancelled', 'rejected') then p_note else cancel_reason end
   where id = p_order
  returning * into o;

  if approving then
    update payments
       set status = 'paid', verified_by = auth.uid(), upi_ref = coalesce(p_upi_ref, upi_ref)
     where order_id = p_order and method in ('pay_at_counter', 'upi_intent');
  end if;
  return o;
end $$;

-- Called ONLY by the razorpay-webhook Edge Function (service_role) after HMAC signature verification.
create or replace function mark_order_paid(p_order uuid, p_provider_order_id text, p_provider_payment_id text,
                                           p_amount_paise int, p_raw jsonb)
returns orders
language plpgsql security definer set search_path = public as $$
declare o orders;
begin
  select * into o from orders where id = p_order for update;
  if not found then raise exception 'Order not found'; end if;
  if o.payment_status = 'paid' then return o; end if;                -- idempotent on webhook retries
  if p_amount_paise <> o.grand_total_paise then raise exception 'Amount mismatch'; end if;
  update payments set status = 'paid', provider_order_id = p_provider_order_id,
                      provider_payment_id = p_provider_payment_id, raw = p_raw
   where order_id = p_order and method = 'razorpay';
  update orders set payment_status = 'paid',
                    status = case when status = 'awaiting_payment' then 'placed'::order_status else status end
   where id = p_order returning * into o;
  return o;
end $$;

-- Public, read-only order status for the customer's tracking screen
create or replace function get_order_tracking(p_tracking_key text) returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object(
    'token_number', o.token_number, 'status', o.status, 'mode', o.mode,
    'table', t.label, 'payment_method', o.payment_method, 'payment_status', o.payment_status,
    'invoice_number', o.invoice_number, 'created_at', o.created_at,
    'subtotal_paise', o.subtotal_paise, 'coins_redeemed', o.coins_redeemed, 'taxable_paise', o.taxable_paise,
    'cgst_rate_bp', o.cgst_rate_bp, 'cgst_paise', o.cgst_paise, 'sgst_rate_bp', o.sgst_rate_bp, 'sgst_paise', o.sgst_paise,
    'round_off_paise', o.round_off_paise, 'grand_total_paise', o.grand_total_paise, 'coins_earned', o.coins_earned,
    'customer_name', o.customer_name, 'tracking_key', o.tracking_key,
    'outlet', jsonb_build_object('name', ou.name, 'legal_name', ou.legal_name, 'gstin', ou.gstin,
                                 'fssai_license', ou.fssai_license, 'address', ou.address, 'phone', ou.phone,
                                 'logo_url', ou.logo_url, 'upi_vpa', ou.upi_vpa,
                                 'upi_payee_name', coalesce(ou.upi_payee_name, ou.name)),
    'items', coalesce((
      select jsonb_agg(jsonb_build_object(
               'name', oi.item_name, 'quantity', oi.quantity, 'unit_price_paise', oi.unit_price_paise,
               'line_total_paise', oi.line_total_paise,
               'modifiers', coalesce((select jsonb_agg(m.option_name order by m.id)
                                        from order_item_modifiers m where m.order_item_id = oi.id), '[]'::jsonb))
             order by oi.created_at)
        from order_items oi where oi.order_id = o.id), '[]'::jsonb))
  from orders o
  join outlets ou on ou.id = o.outlet_id
  left join dining_tables t on t.id = o.table_id
  where o.tracking_key = p_tracking_key
$$;

-- Kitchen / counter can "86" an item or option without menu-edit rights
create or replace function set_item_availability(p_item uuid, p_available boolean) returns void
language plpgsql security definer set search_path = public as $$
declare v_outlet uuid;
begin
  select outlet_id into v_outlet from menu_items where id = p_item;
  if not has_role(v_outlet, '{owner,manager,cashier,kitchen}') then
    raise exception 'Not authorised' using errcode = '42501';
  end if;
  update menu_items set is_available = p_available where id = p_item;
end $$;

create or replace function set_option_availability(p_option uuid, p_available boolean) returns void
language plpgsql security definer set search_path = public as $$
declare v_outlet uuid;
begin
  select g.outlet_id into v_outlet from modifier_options o join modifier_groups g on g.id = o.group_id where o.id = p_option;
  if not has_role(v_outlet, '{owner,manager,cashier,kitchen}') then
    raise exception 'Not authorised' using errcode = '42501';
  end if;
  update modifier_options set is_available = p_available where id = p_option;
end $$;

-- Owner / manager goodwill credit or correction (positive or negative)
create or replace function adjust_customer_coins(p_customer uuid, p_coins int, p_note text) returns int
language plpgsql security definer set search_path = public as $$
declare v_balance int;
begin
  if not is_any_staff('{owner,manager}') then raise exception 'Not authorised' using errcode = '42501'; end if;
  if p_coins = 0 or p_note is null or btrim(p_note) = '' then
    raise exception 'Enter a non-zero amount and a reason' using errcode = 'P0001';
  end if;
  perform post_loyalty_entry(p_customer, null, 'adjustment', p_coins, p_note);
  select coin_balance into v_balance from customers where id = p_customer;
  return v_balance;
end $$;

-- Cancel Razorpay orders nobody paid for (schedule with pg_cron, see README). Returns coins burned on them.
create or replace function expire_stale_payments(p_minutes int default 15) returns int
language plpgsql security definer set search_path = public as $$
declare v_count int;
begin
  with stale as (
    update orders set status = 'cancelled', cancel_reason = 'Payment not completed'
     where status = 'awaiting_payment' and created_at < now() - make_interval(mins => p_minutes)
    returning id)
  select count(*) into v_count from stale;
  update payments p set status = 'failed'
    from orders o where o.id = p.order_id and o.status = 'cancelled' and p.status = 'unpaid' and p.method = 'razorpay';
  return v_count;
end $$;

-- Logged-in customer's wallet (cart toggle "Redeem N coins")
create or replace function get_my_wallet() returns jsonb
language sql stable security definer set search_path = public as $$
  select jsonb_build_object('customer_id', c.id, 'phone', c.phone, 'name', c.name, 'coin_balance', c.coin_balance)
    from customers c where c.auth_user_id = auth.uid()
$$;

-- Called right after phone-OTP verification: links the auth user to a customer row (creating it if new)
create or replace function upsert_my_customer(p_name text default null) returns jsonb
language plpgsql security definer set search_path = public as $$
declare v_phone text; v_cust customers;
begin
  if auth.uid() is null then raise exception 'Not signed in' using errcode = '42501'; end if;
  select '+' || ltrim(phone, '+') into v_phone from auth.users where id = auth.uid();
  if v_phone is null or v_phone = '+' then raise exception 'Phone not verified' using errcode = 'P0001'; end if;
  insert into customers (auth_user_id, phone, name) values (auth.uid(), v_phone, nullif(btrim(p_name), ''))
  on conflict (phone) do update
     set auth_user_id = excluded.auth_user_id,
         name = coalesce(customers.name, excluded.name)
  returning * into v_cust;
  return jsonb_build_object('customer_id', v_cust.id, 'name', v_cust.name, 'coin_balance', v_cust.coin_balance);
end $$;

-- ---------------------------------------------------------------------------
-- Analytics views (security_invoker: RLS of the caller applies => only own outlet)
-- ---------------------------------------------------------------------------
create view v_daily_sales with (security_invoker = true) as
select outlet_id, business_date,
       count(*)                                     as orders,
       count(*) filter (where mode = 'takeaway')    as takeaway_orders,
       sum(subtotal_paise)                          as gross_paise,
       sum(coins_redeemed)                          as coins_redeemed,
       sum(taxable_paise)                           as taxable_paise,
       sum(cgst_paise)                              as cgst_paise,
       sum(sgst_paise)                              as sgst_paise,
       sum(grand_total_paise)                       as net_paise,
       sum(coins_earned)                            as coins_issued,
       round(avg(extract(epoch from ready_at - placed_at)) / 60, 1) as avg_prep_minutes
  from orders where status = 'completed'
 group by outlet_id, business_date;

create view v_item_sales with (security_invoker = true) as
select o.outlet_id, o.business_date, oi.menu_item_id, oi.item_name,
       sum(oi.quantity) as qty, sum(oi.line_total_paise) as revenue_paise
  from order_items oi join orders o on o.id = oi.order_id
 where o.status = 'completed'
 group by o.outlet_id, o.business_date, oi.menu_item_id, oi.item_name;

create view v_modifier_sales with (security_invoker = true) as
select o.outlet_id, o.business_date, m.group_name, m.option_name,
       sum(oi.quantity) as qty, sum(m.price_delta_paise * oi.quantity) as revenue_paise
  from order_item_modifiers m
  join order_items oi on oi.id = m.order_item_id
  join orders o on o.id = oi.order_id
 where o.status = 'completed'
 group by o.outlet_id, o.business_date, m.group_name, m.option_name;

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
alter table outlets                   enable row level security;
alter table staff_profiles            enable row level security;
alter table dining_tables             enable row level security;
alter table menu_categories           enable row level security;
alter table menu_items                enable row level security;
alter table modifier_groups           enable row level security;
alter table modifier_options          enable row level security;
alter table menu_item_modifier_groups enable row level security;
alter table customers                 enable row level security;
alter table orders                    enable row level security;
alter table order_items               enable row level security;
alter table order_item_modifiers      enable row level security;
alter table payments                  enable row level security;
alter table loyalty_ledger            enable row level security;
alter table order_events              enable row level security;
alter table token_counters            enable row level security;  -- no policies: functions only
alter table invoice_counters          enable row level security;  -- no policies: functions only

-- Public menu
create policy outlets_read         on outlets for select using (true);
create policy outlets_owner_update on outlets for update using (has_role(id, '{owner}')) with check (has_role(id, '{owner}'));

create policy cat_read  on menu_categories for select using (is_active or has_role(outlet_id, '{owner,manager,cashier,kitchen}'));
create policy cat_write on menu_categories for all using (has_role(outlet_id, '{owner,manager}')) with check (has_role(outlet_id, '{owner,manager}'));

create policy item_read  on menu_items for select using (is_active or has_role(outlet_id, '{owner,manager,cashier,kitchen}'));
create policy item_write on menu_items for all using (has_role(outlet_id, '{owner,manager}')) with check (has_role(outlet_id, '{owner,manager}'));

create policy mg_read  on modifier_groups for select using (is_active or has_role(outlet_id, '{owner,manager,cashier,kitchen}'));
create policy mg_write on modifier_groups for all using (has_role(outlet_id, '{owner,manager}')) with check (has_role(outlet_id, '{owner,manager}'));

create policy mo_read  on modifier_options for select using (exists (select 1 from modifier_groups g where g.id = group_id));
create policy mo_write on modifier_options for all
  using      (exists (select 1 from modifier_groups g where g.id = group_id and has_role(g.outlet_id, '{owner,manager}')))
  with check (exists (select 1 from modifier_groups g where g.id = group_id and has_role(g.outlet_id, '{owner,manager}')));

create policy mimg_read  on menu_item_modifier_groups for select using (exists (select 1 from menu_items i where i.id = menu_item_id));
create policy mimg_write on menu_item_modifier_groups for all
  using      (exists (select 1 from menu_items i where i.id = menu_item_id and has_role(i.outlet_id, '{owner,manager}')))
  with check (exists (select 1 from menu_items i where i.id = menu_item_id and has_role(i.outlet_id, '{owner,manager}')));

-- Tables: staff only (qr_key must not leak); diners are validated inside place_order
create policy tables_staff_read on dining_tables for select using (has_role(outlet_id, '{owner,manager,cashier,kitchen}'));
create policy tables_write      on dining_tables for all using (has_role(outlet_id, '{owner,manager}')) with check (has_role(outlet_id, '{owner,manager}'));

-- Staff
create policy staff_read on staff_profiles for select using (user_id = auth.uid() or has_role(outlet_id, '{owner,manager}'));
create policy staff_write on staff_profiles for all using (has_role(outlet_id, '{owner}')) with check (has_role(outlet_id, '{owner}'));

-- Customers & wallet: own row, or front-of-house staff. No direct writes (RPCs only).
create policy cust_read   on customers      for select using (auth_user_id = auth.uid() or is_any_staff('{owner,manager,cashier}'));
create policy ledger_read on loyalty_ledger for select using (
  exists (select 1 from customers c where c.id = customer_id and c.auth_user_id = auth.uid())
  or is_any_staff('{owner,manager}'));

-- Orders: staff of the outlet, or the logged-in customer who owns it. No direct writes.
create policy orders_read on orders for select using (
  has_role(outlet_id, '{owner,manager,cashier,kitchen}')
  or exists (select 1 from customers c where c.id = customer_id and c.auth_user_id = auth.uid()));
create policy oi_read  on order_items          for select using (exists (select 1 from orders o where o.id = order_id));
create policy oim_read on order_item_modifiers for select using (exists (select 1 from order_items oi where oi.id = order_item_id));
create policy oe_read  on order_events         for select using (exists (select 1 from orders o where o.id = order_id));
create policy pay_read on payments for select using (
  exists (select 1 from orders o where o.id = order_id and has_role(o.outlet_id, '{owner,manager,cashier}')));

-- ---------------------------------------------------------------------------
-- Grants on functions (Postgres grants EXECUTE to PUBLIC by default — lock down)
-- ---------------------------------------------------------------------------
-- Supabase auto-grants EXECUTE on new functions to anon/authenticated/service_role: revoke them all, then re-grant only the API
revoke execute on all functions in schema public from public, anon, authenticated;
grant  execute on function place_order(jsonb)                          to anon, authenticated;
grant  execute on function get_order_tracking(text)                    to anon, authenticated;
grant  execute on function get_my_wallet()                             to authenticated;
grant  execute on function upsert_my_customer(text)                    to authenticated;
grant  execute on function set_order_status(uuid, order_status, text, text) to authenticated;
grant  execute on function mark_order_paid(uuid, text, text, int, jsonb) to service_role;
grant  execute on function expire_stale_payments(int)                   to service_role;
grant  execute on function set_item_availability(uuid, boolean)         to authenticated;
grant  execute on function set_option_availability(uuid, boolean)       to authenticated;
grant  execute on function adjust_customer_coins(uuid, int, text)       to authenticated;
-- RLS policies call these helpers as the querying role:
grant  execute on function staff_role_for(uuid), has_role(uuid, staff_role[]), is_any_staff(staff_role[]),
                           outlet_today(uuid), tg_set_updated_at() to anon, authenticated, service_role;

-- ---------------------------------------------------------------------------
-- Realtime: KDS & Owner dashboards subscribe with postgres_changes (RLS-filtered)
-- ---------------------------------------------------------------------------
alter publication supabase_realtime add table orders, order_items, menu_items, modifier_options;
