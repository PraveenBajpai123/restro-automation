// Runs the unified migration + seed on embedded Postgres (PGlite) with Supabase auth/realtime stubs,
// then exercises ordering, modifiers, GST, tokens, approval, Razorpay webhook path, loyalty and RLS.
import { PGlite } from '@electric-sql/pglite';
import fs from 'node:fs';

const [migrationPath, seedPath] = process.argv.slice(2);
const db = new PGlite();
let pass = 0, fail = 0;
const ok = (cond, msg, extra) => { if (cond) { pass++; console.log('  PASS', msg); } else { fail++; console.log('  FAIL', msg, extra ?? ''); } };

await db.exec(`
  create role anon; create role authenticated; create role service_role;
  create schema auth;
  create table auth.users (id uuid primary key, phone text);
  create function auth.uid() returns uuid language sql stable as
    $$ select nullif(current_setting('request.jwt.claim.sub', true), '')::uuid $$;
  grant usage on schema auth to anon, authenticated, service_role;
  create schema realtime;
  create table realtime.sent (id serial, payload jsonb, event text, topic text, private boolean);
  create function realtime.send(payload jsonb, event text, topic text, private boolean default true) returns void
    language sql as $$ insert into realtime.sent (payload, event, topic, private) values (payload, event, topic, private) $$;
  create publication supabase_realtime;
  -- Mirror Supabase's default privileges so grant mistakes show up here
  alter default privileges in schema public grant execute on functions to anon, authenticated, service_role;
  alter default privileges in schema public grant all on tables to anon, authenticated, service_role;
`);
await db.exec(fs.readFileSync(migrationPath, 'utf8'));
await db.exec(`
  grant usage on schema public to anon, authenticated, service_role;
  grant select, insert, update, delete on all tables in schema public to anon, authenticated, service_role;
`);
await db.exec(fs.readFileSync(seedPath, 'utf8'));
console.log('Migration + seed applied');

const U = {
  cust:    '10000000-0000-0000-0000-000000000001',
  cashier: '20000000-0000-0000-0000-000000000001',
  kitchen: '20000000-0000-0000-0000-000000000002',
  manager: '20000000-0000-0000-0000-000000000003',
  owner:   '20000000-0000-0000-0000-000000000004',
};
const OUTLET = '00000000-0000-0000-0000-000000000001';
await db.exec(`
  insert into auth.users values ('${U.cust}', '919876543210'), ('${U.cashier}', null), ('${U.kitchen}', null),
                                ('${U.manager}', null), ('${U.owner}', null);
  insert into staff_profiles (user_id, outlet_id, display_name, role) values
    ('${U.cashier}', '${OUTLET}', 'Cashier', 'cashier'), ('${U.kitchen}', '${OUTLET}', 'Kitchen', 'kitchen'),
    ('${U.manager}', '${OUTLET}', 'Manager', 'manager'), ('${U.owner}', '${OUTLET}', 'Owner', 'owner');
`);

async function as(role, sub, sql, params = []) {
  await db.exec(`set role ${role}; select set_config('request.jwt.claim.sub', '${sub ?? ''}', false);`);
  try { return (await db.query(sql, params)).rows; }
  finally { await db.exec(`reset role; select set_config('request.jwt.claim.sub', '', false);`); }
}
async function err(role, sub, sql, params = []) {
  try { await as(role, sub, sql, params); return null; } catch (e) { return e.message; }
}
const place = (p) => `select place_order('${JSON.stringify(p)}'::jsonb) as r`;

const I = { capp: '00000000-0000-0000-0000-0000000000a1', frappe: '00000000-0000-0000-0000-0000000000a3', fries: '00000000-0000-0000-0000-0000000000a4' };
const O = { regular: '00000000-0000-0000-0000-0000000000b1', large: '00000000-0000-0000-0000-0000000000b2',
            shot: '00000000-0000-0000-0000-0000000000b3', cheese: '00000000-0000-0000-0000-0000000000b6' };

console.log('\n1. Anonymous takeaway, modifiers, GST, pay at counter');
const r1 = (await as('anon', null, place({
  outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'pay_at_counter', customer_name: 'Walk-in',
  items: [{ menu_item_id: I.capp, quantity: 2, option_ids: [O.large, O.shot] },
          { menu_item_id: I.fries, quantity: 1, option_ids: [O.cheese] }],
})))[0].r;
ok(r1.subtotal_paise === 70000, 'subtotal ₹700 = 2×(180+40+40) + (150+30)', r1.subtotal_paise);
ok(r1.cgst_paise === 1750 && r1.sgst_paise === 1750, 'CGST ₹17.50 + SGST ₹17.50', r1);
ok(r1.grand_total_paise === 73500, 'grand total ₹735', r1.grand_total_paise);
ok(r1.status === 'awaiting_approval', 'pay-at-counter waits for staff approval', r1.status);
ok(r1.token_number === 101, 'first token of the day is #101', r1.token_number);
ok(r1.coins_earned === 0, 'anonymous order earns no coins');

console.log('\n2. Validation');
let e = await err('anon', null, place({ outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'pay_at_counter',
  items: [{ menu_item_id: I.capp, quantity: 1, option_ids: [] }] }));
ok(e?.includes('Please choose Size for Cappuccino'), 'required Size enforced', e);
e = await err('anon', null, place({ outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'pay_at_counter',
  items: [{ menu_item_id: I.capp, quantity: 1, option_ids: [O.regular, O.large] }] }));
ok(e?.includes('Please choose Size'), 'two sizes rejected (max 1)', e);
e = await err('anon', null, place({ outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'pay_at_counter',
  items: [{ menu_item_id: I.capp, quantity: 1, option_ids: [O.regular, O.cheese] }] }));
ok(e?.includes('Invalid option'), 'Cheese Dip cannot be added to a Cappuccino', e);
e = await err('anon', null, place({ outlet_slug: 'nbc-demo', mode: 'dine_in', table_label: '99', payment_method: 'pay_at_counter',
  items: [{ menu_item_id: I.fries, quantity: 1 }] }));
ok(e?.includes('Invalid table'), 'unknown table rejected', e);
e = await err('anon', null, place({ outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'pay_at_counter',
  items: [{ menu_item_id: I.fries, quantity: 0 }] }));
ok(e?.includes('Invalid quantity'), 'zero quantity rejected', e);

console.log('\n3. RLS for anonymous users');
ok((await as('anon', null, 'select * from orders')).length === 0, 'anon cannot read orders');
ok((await as('anon', null, 'select * from dining_tables')).length === 0, 'anon cannot read table QR keys');
ok((await as('anon', null, 'select * from menu_items')).length === 5, 'anon can read the menu');
e = await err('anon', null, `update orders set status = 'placed'`);
ok((await db.query(`select count(*)::int c from orders where status = 'placed'`)).rows[0].c === 0, 'anon cannot fire orders to kitchen', e);
const track1 = (await as('anon', null, 'select get_order_tracking($1) t', [r1.tracking_key]))[0].t;
ok(track1.items.length === 2 && track1.items.some(i => i.modifiers.includes('Extra Shot')), 'tracking page shows items + modifiers', track1);

console.log('\n4. Staff approval');
e = await err('authenticated', U.kitchen, `select set_order_status($1, 'placed')`, [r1.order_id]);
ok(e?.includes('Cannot move order'), 'kitchen cannot approve pay-at-counter', e);
const a1 = (await as('authenticated', U.cashier, `select * from set_order_status($1, 'placed')`, [r1.order_id]))[0];
ok(a1.status === 'placed' && a1.payment_status === 'paid', 'cashier approval fires order to kitchen, marked paid', a1);
ok(/^INV\/\d{4}\/000001$/.test(a1.invoice_number), 'GST invoice number assigned on payment', a1.invoice_number);
ok((await as('authenticated', U.kitchen, 'select * from orders')).length === 1, 'kitchen sees outlet orders via RLS');

console.log('\n5. Phone-OTP customer, coin redemption, Razorpay, earn on completion');
await as('authenticated', U.cust, `select upsert_my_customer('Asha')`);
const cust = (await db.query(`select * from customers`)).rows[0];
ok(cust.phone === '+919876543210', 'customer created from verified phone', cust.phone);
await db.query(`select post_loyalty_entry($1, null, 'adjustment', 100, 'welcome bonus')`, [cust.id]);
const r2 = (await as('authenticated', U.cust, place({
  outlet_slug: 'nbc-demo', mode: 'dine_in', table_label: '5', payment_method: 'razorpay', redeem_coins: true,
  items: [{ menu_item_id: I.frappe, quantity: 1, option_ids: [O.regular] }],
})))[0].r;
ok(r2.coins_redeemed === 100, 'redeems 100 coins (balance 100, cap 50% of ₹240 = 120)', r2.coins_redeemed);
ok(r2.taxable_paise === 14000 && r2.grand_total_paise === 14700, 'GST on ₹140 after coins, total ₹147', r2);
ok(r2.coins_earned === 7, 'projects 7 coins (5% of ₹140)', r2.coins_earned);
ok(r2.status === 'awaiting_payment', 'Razorpay order waits for webhook', r2.status);
ok((await db.query(`select coin_balance from customers`)).rows[0].coin_balance === 0, 'coins burned immediately (no double spend)');
e = await err('service_role', null, `select mark_order_paid($1, 'order_x', 'pay_x', 99, '{}')`, [r2.order_id]);
ok(e?.includes('Amount mismatch'), 'webhook with wrong amount rejected', e);
e = await err('anon', null, `select mark_order_paid($1, 'order_x', 'pay_x', 14700, '{}')`, [r2.order_id]);
ok(e?.includes('permission denied'), 'anon cannot call mark_order_paid', e);
await as('service_role', null, `select mark_order_paid($1, 'order_x', 'pay_x', 14700, '{}')`, [r2.order_id]);
await as('service_role', null, `select mark_order_paid($1, 'order_x', 'pay_x', 14700, '{}')`, [r2.order_id]);
const o2 = (await db.query(`select * from orders where id = $1`, [r2.order_id])).rows[0];
ok(o2.status === 'placed' && o2.payment_status === 'paid', 'webhook fires order to kitchen (idempotent on retry)', o2.status);
for (const s of ['preparing', 'ready', 'completed'])
  await as('authenticated', U.kitchen, `select set_order_status($1, '${s}')`, [r2.order_id]);
const c2 = (await db.query(`select * from customers`)).rows[0];
ok(c2.coin_balance === 7 && c2.total_orders === 1, 'completion credits 7 coins + stats', c2);
e = await err('authenticated', U.kitchen, `select set_order_status($1, 'placed')`, [r2.order_id]);
ok(e?.includes('Cannot move order'), 'no going backwards from completed', e);
ok((await as('authenticated', U.cust, 'select * from orders')).length === 1, 'customer sees only own orders');
ok((await as('authenticated', U.cust, 'select * from loyalty_ledger')).length === 3, 'customer sees own ledger');
const upd = await as('authenticated', U.cust, `update customers set coin_balance = 99999 returning *`);
ok(upd.length === 0, 'customer cannot edit own coin balance');

console.log('\n6. Cancellation refunds burned coins');
const r3 = (await as('authenticated', U.cust, place({
  outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'upi_intent', redeem_coins: true,
  items: [{ menu_item_id: I.capp, quantity: 1, option_ids: [O.regular] }],
})))[0].r;
ok(r3.coins_redeemed === 7 && r3.upi?.vpa === 'democafe@okaxis', 'UPI intent returns VPA, redeems 7', r3);
ok((await db.query(`select coin_balance from customers`)).rows[0].coin_balance === 0, 'balance 0 after burn');
await as('authenticated', U.cashier, `select set_order_status($1, 'rejected', 'UTR not found')`, [r3.order_id]);
ok((await db.query(`select coin_balance from customers`)).rows[0].coin_balance === 7, 'rejected order returns 7 coins');
const o3 = (await db.query(`select status, payment_status, cancel_reason from orders where id = $1`, [r3.order_id])).rows[0];
ok(o3.payment_status === 'failed' && o3.cancel_reason === 'UTR not found', 'rejection reason + failed payment recorded', o3);

console.log('\n7. Tokens, realtime, analytics');
const tokens = (await db.query(`select token_number from orders order by created_at, token_number`)).rows.map(r => r.token_number);
ok(JSON.stringify(tokens) === '[101,102,103]', 'tokens increment 101,102,103', tokens);
const sent = (await db.query(`select topic, payload from realtime.sent`)).rows;
ok(sent.some(s => s.topic === 'order:' + r2.tracking_key && s.payload.status === 'completed'), 'status broadcast on order:<tracking_key>', sent.length);
const daily = await as('authenticated', U.owner, 'select * from v_daily_sales');
ok(daily.length === 1 && Number(daily[0].net_paise) === 14700 && Number(daily[0].coins_issued) === 7, 'owner daily sales view', daily);
ok((await as('anon', null, 'select * from v_daily_sales')).length === 0, 'anon sees no analytics');
const mods = await as('authenticated', U.owner, 'select * from v_modifier_sales');
ok(mods.length === 1 && mods[0].option_name === 'Regular', 'modifier sales view', mods);


console.log('\n8. Availability, coin adjustments, payment expiry');
await as('authenticated', U.kitchen, `select set_item_availability($1, false)`, [I.fries]);
ok((await as('anon', null, `select is_available from menu_items where id = $1`, [I.fries]))[0].is_available === false, 'kitchen can 86 an item');
e = await err('anon', null, place({ outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'pay_at_counter',
  items: [{ menu_item_id: I.fries, quantity: 1, option_ids: [] }] }));
ok(e?.includes('no longer available'), "86'd item cannot be ordered", e);
e = await err('authenticated', U.cust, `select set_item_availability($1, true)`, [I.fries]);
ok(e?.includes('Not authorised'), 'customer cannot toggle availability', e);
e = await err('authenticated', U.kitchen, `select adjust_customer_coins($1, 50, 'sorry')`, [cust.id]);
ok(e?.includes('Not authorised'), 'kitchen cannot adjust coins', e);
const nb = (await as('authenticated', U.owner, `select adjust_customer_coins($1, 50, 'Late order apology') b`, [cust.id]))[0].b;
ok(nb === 57, 'owner adds 50 goodwill coins', nb);
const r4 = (await as('authenticated', U.cust, place({
  outlet_slug: 'nbc-demo', mode: 'takeaway', payment_method: 'razorpay', redeem_coins: true,
  items: [{ menu_item_id: I.capp, quantity: 1, option_ids: [O.regular] }],
})))[0].r;
await db.exec(`update orders set created_at = now() - interval '30 minutes' where id = '${r4.order_id}'`);
const expired = (await as('service_role', null, `select expire_stale_payments(15) n`))[0].n;
ok(expired === 1, 'abandoned Razorpay order auto-cancelled', expired);
ok((await db.query(`select coin_balance from customers`)).rows[0].coin_balance === 57, 'coins returned after expiry');
const t4 = (await as('anon', null, 'select get_order_tracking($1) t', [r4.tracking_key]))[0].t;
ok(t4.outlet?.gstin === '27AAAAA0000A1Z5' && t4.status === 'cancelled', 'tracking payload carries outlet GST details', t4.outlet);

console.log('\n9. Internal functions are not callable from the browser');
for (const fn of [
  `post_loyalty_entry('${cust.id}', null, 'adjustment', 1000)`,
  `next_token('${OUTLET}')`,
  'expire_stale_payments(0)',
  `next_invoice_number('${OUTLET}')`,
  `mark_order_paid('${r1.order_id}', 'x', 'y', 1, '{}')`,
]) {
  for (const role of ['anon', 'authenticated']) {
    const m = await err(role, role === 'authenticated' ? U.cust : null, `select ${fn}`);
    ok(m?.includes('permission denied'), `${role} cannot call ${fn.split('(')[0]}`, m);
  }
}

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);

