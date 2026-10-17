// Turns a menu JSON file (supabase/menus/*.json) into an idempotent SQL seed.
//   node scripts/menu-to-sql.mjs supabase/menus/berries.json > supabase/seed_berries.sql
// Item rows: [name, priceRupees, description?, groupKeys?]. Category "groups" apply to every item in it.
// Re-running is safe: the outlet's previous menu is soft-deleted (past orders keep their records).
import { readFileSync } from 'node:fs';

const file = process.argv[2];
if (!file) throw new Error('Usage: node scripts/menu-to-sql.mjs <menu.json>');
const menu = JSON.parse(readFileSync(file, 'utf8'));
const { outlet, groups, categories } = menu;

const q = (s) => (s == null ? 'null' : `'${String(s).replaceAll("'", "''")}'`);
const paise = (rupees) => {
  if (!Number.isFinite(rupees) || rupees < 0) throw new Error(`Bad price: ${rupees}`);
  return Math.round(rupees * 100);
};
const O = q(outlet.id);
const out = [];
const emit = (s) => out.push(s);

emit(`-- Generated from ${file.replaceAll('\\', '/')} by scripts/menu-to-sql.mjs. Edit the JSON, not this file.`);
emit('begin;');
emit(`update outlets set slug = ${q(outlet.slug)}, name = ${q(outlet.name)}, invoice_prefix = ${q(outlet.invoice_prefix ?? 'INV')},
  legal_name = null, gstin = null, address = null, phone = null, upi_vpa = null, upi_payee_name = ${q(outlet.name)},
  upi_intent_enabled = false
where id = ${O};`);
emit(`-- Retire the previous menu (soft delete keeps past order lines intact)
update menu_items set is_active = false where outlet_id = ${O};
update menu_categories set is_active = false where outlet_id = ${O};
update modifier_groups set is_active = false where outlet_id = ${O};`);

emit('create temp table _g (key text primary key, id uuid) on commit drop;');
let gi = 0;
for (const [key, g] of Object.entries(groups)) {
  gi++;
  emit(`with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values (${O}, ${q(g.name)}, ${g.min}, ${g.max ?? 'null'}, ${gi}) returning id)
insert into _g select ${q(key)}, id from g;`);
  const opts = g.options.map(([name, price, isDefault], i) =>
    `((select id from _g where key = ${q(key)}), ${q(name)}, ${paise(price)}, ${Boolean(isDefault)}, true, ${i + 1})`);
  emit(`insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values\n  ${opts.join(',\n  ')};`);
}

let itemCount = 0;
for (const [ci, c] of categories.entries()) {
  emit(`\n-- ${c.name}`);
  emit(`insert into menu_categories (outlet_id, name, sort_order) values (${O}, ${q(c.name)}, ${ci + 1})
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;`);
  for (const [ii, row] of c.items.entries()) {
    const [name, price, description = null, itemGroups = []] = row;
    const keys = [...new Set([...itemGroups, ...(c.groups ?? [])])];
    for (const k of keys) if (!groups[k]) throw new Error(`Unknown group "${k}" on ${name}`);
    itemCount++;
    const insert = `insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values (${O}, (select id from menu_categories where outlet_id = ${O} and name = ${q(c.name)}), ${q(name)}, ${q(description)}, ${paise(price)}, true, ${ii + 1})`;
    if (!keys.length) {
      emit(`${insert};`);
      continue;
    }
    emit(`with i as (${insert} returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array[${keys.map(q).join(', ')}]) with ordinality as x(key, ord) join _g g on g.key = x.key;`);
  }
}
emit('commit;');
emit(`\nselect 'Menu loaded' as result, ${categories.length} as sections, ${itemCount} as items;`);
process.stdout.write(out.join('\n') + '\n');
process.stderr.write(`${categories.length} sections, ${itemCount} items, ${Object.keys(groups).length} add-on groups\n`);
