-- LOCAL DEVELOPMENT ONLY (loaded by `supabase db reset` via config.toml). Never run against production.
-- Creates one login per role for the demo outlet. Password for all: devpassword
do $$
declare
  r record;
  v_id uuid;
begin
  for r in
    select * from (values
      ('owner@demo.test',   'Asha (owner)',     'owner'::staff_role),
      ('manager@demo.test', 'Ravi (manager)',   'manager'::staff_role),
      ('cashier@demo.test', 'Meera (counter)',  'cashier'::staff_role),
      ('kitchen@demo.test', 'Kitchen tablet',   'kitchen'::staff_role)
    ) as t(email, name, role)
  loop
    v_id := gen_random_uuid();
    insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
                            raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
                            confirmation_token, recovery_token, email_change_token_new, email_change)
    values ('00000000-0000-0000-0000-000000000000', v_id, 'authenticated', 'authenticated', r.email,
            extensions.crypt('devpassword', extensions.gen_salt('bf')), now(),
            '{"provider":"email","providers":["email"]}', '{}', now(), now(), '', '', '', '');
    insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
    values (gen_random_uuid(), v_id, v_id::text, jsonb_build_object('sub', v_id::text, 'email', r.email, 'email_verified', true),
            'email', now(), now(), now());
    insert into public.staff_profiles (user_id, outlet_id, display_name, role)
    values (v_id, '00000000-0000-0000-0000-000000000001', r.name, r.role);
  end loop;
end $$;

-- Demo photos so the menu looks real locally
update public.menu_items set image_url = case name
  when 'Cappuccino'            then 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=480&q=70&auto=format&fit=crop'
  when 'Cafe Latte'            then 'https://images.unsplash.com/photo-1561882468-9110e03e0f78?w=480&q=70&auto=format&fit=crop'
  when 'Hazelnut Frappe'       then 'https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=480&q=70&auto=format&fit=crop'
  when 'Peri Peri Fries'       then 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=480&q=70&auto=format&fit=crop'
  when 'Chicken Club Sandwich' then 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=480&q=70&auto=format&fit=crop'
end
where outlet_id = '00000000-0000-0000-0000-000000000001';
