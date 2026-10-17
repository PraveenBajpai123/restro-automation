// Loads a generated menu seed on top of the demo data (twice, to prove it is re-runnable) and orders from it.
//   node supabase/tests/menu.test.mjs supabase/migrations/20261017000000_unified_schema.sql supabase/seed.sql supabase/seed_berries.sql
import { PGlite } from '@electric-sql/pglite';
import fs from 'node:fs';

const [migrationPath, seedPath, menuPath] = process.argv.slice(2);
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
  create function realtime.send(payload jsonb, event text, topic text, private boolean default true) returns void
    language sql as $$ select null $$;
  create publication supabase_realtime;
`);
await db.exec(fs.readFileSync(migrationPath, 'utf8'));
await db.exec(`grant usage on schema public to anon, authenticated, service_role;
  grant select, insert, update, delete on all tables in schema public to anon, authenticated, service_role;`);
await db.exec(fs.readFileSync(seedPath, 'utf8'));

const order = async (items, slug = 'berries') => {
  const p = { outlet_slug: slug, mode: 'takeaway', payment_method: 'pay_at_counter', items };
  let r;
  await db.exec('set role anon');
  try {
    r = (await db.query(`select place_order($1::jsonb) r`, [JSON.stringify(p)])).rows[0].r;
  } finally {
    await db.exec('reset role');
  }
  // Read back as the table owner: RLS (correctly) hides orders from anonymous diners
  return (await db.query('select subtotal_paise, grand_total_paise from orders where id = $1', [r.order_id])).rows[0];
};
const failMsg = async (items) => { try { await order(items); return null; } catch (e) { return e.message; } };

// An order on the old demo menu, which must survive the menu swap
const old = (await db.query(`select id from menu_items where name = 'Cafe Latte'`)).rows[0].id;
await order([{ menu_item_id: old, quantity: 1, option_ids: [] }], 'nbc-demo').catch(() => null);

const menuSql = fs.readFileSync(menuPath, 'utf8');
await db.exec(menuSql);
await db.exec(menuSql); // re-runnable

const item = async (name) => (await db.query(`select id from menu_items where name = $1 and is_active`, [name])).rows;
const opt = async (group, name) => (await db.query(
  `select o.id from modifier_options o join modifier_groups g on g.id = o.group_id where g.is_active and g.name = $1 and o.name = $2`, [group, name])).rows[0]?.id;

const outlet = (await db.query(`select slug, name from outlets`)).rows[0];
ok(outlet.slug === 'berries' && outlet.name.startsWith('Berries'), 'outlet renamed to Berries', outlet);
const counts = (await db.query(`select
  (select count(*) from menu_items where is_active)::int items,
  (select count(*) from menu_categories where is_active)::int cats,
  (select count(*) from modifier_groups where is_active)::int groups,
  (select count(*) from menu_items where not is_active and name = 'Cafe Latte')::int old`)).rows[0];
ok(counts.items === 279 && counts.cats === 30 && counts.groups === 9, 'one active copy of the menu after two runs', counts);
ok(counts.old === 1, 'demo items retired, not deleted');
ok((await item('Paneer Tikka')).length === 1, 'no duplicate items');

const pasta = (await item('Build Your Own Pasta'))[0].id;
const b = await order([{ menu_item_id: pasta, quantity: 1, option_ids: [await opt('Pasta Sauce', 'Alfredo'), await opt('Extra Veggies', 'Broccoli'), await opt('Extra Veggies', 'Mushroom')] }]);
ok(b.subtotal_paise === 62800 && b.grand_total_paise === 65900, 'Pasta Alfredo + 2 veggies = ₹628, ₹659 with GST', b);
ok((await failMsg([{ menu_item_id: pasta, quantity: 1, option_ids: [] }]))?.length > 0, 'pasta sauce is required');

const espresso = (await item('Espresso'))[0].id;
const e = await order([{ menu_item_id: espresso, quantity: 2, option_ids: [await opt('Shot', 'Double')] }]);
ok(e.subtotal_paise === 24000, '2 double espressos = ₹240', e);

const latte = (await item('Hazelnut Latte'))[0].id;
const l = await order([{ menu_item_id: latte, quantity: 1, option_ids: [await opt('Plant-based Milk', 'Oat Milk'), await opt('Flavoured Syrup', 'Caramel')] }]);
ok(l.subtotal_paise === 37500, 'Hazelnut Latte + oat milk + caramel syrup = ₹375', l);

const roti = (await item('Tandoori Roti Butter'))[0].id;
const r = await order([{ menu_item_id: roti, quantity: 4, option_ids: [] }]);
ok(r.subtotal_paise === 22000, '4 butter rotis = ₹220', r);

// Photos-only update: idempotent, and leaves owner edits such as prices alone
const photos = fs.readFileSync(menuPath.replace('seed_berries.sql', 'update_berries_photos.sql'), 'utf8');
await db.query(`update menu_items set base_price_paise = 99900 where name = 'Caffè Latte'`);
await db.exec(photos);
await db.exec(photos);
const res = (await db.query(photos.slice(photos.indexOf("select 'Photos updated'")))).rows[0];
ok(Number(res.section_photos) === 28 && Number(res.item_photos) === 23 && Number(res.chef_picks) === 8, '28 section photos, 23 item photos, 8 chef picks', res);
ok((await db.query(`select base_price_paise from menu_items where name = 'Caffè Latte' and is_active`)).rows[0].base_price_paise === 99900, 'photo update keeps owner price edits');

console.log(`\n${pass} passed, ${fail} failed`);
process.exit(fail ? 1 : 0);
