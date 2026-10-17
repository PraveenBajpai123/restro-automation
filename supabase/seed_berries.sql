-- Generated from supabase/menus/berries.json by scripts/menu-to-sql.mjs. Edit the JSON, not this file.
begin;
update outlets set slug = 'berries', name = 'Berries Café & Restaurant', invoice_prefix = 'BER',
  legal_name = null, gstin = null, address = null, phone = null, upi_vpa = null, upi_payee_name = 'Berries Café & Restaurant',
  upi_intent_enabled = false
where id = '00000000-0000-0000-0000-000000000001';
-- Retire the previous menu (soft delete keeps past order lines intact)
update menu_items set is_active = false where outlet_id = '00000000-0000-0000-0000-000000000001';
update menu_categories set is_active = false where outlet_id = '00000000-0000-0000-0000-000000000001';
update modifier_groups set is_active = false where outlet_id = '00000000-0000-0000-0000-000000000001';
alter table menu_categories add column if not exists image_url text;
create temp table _g (key text primary key, id uuid) on commit drop;
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Shot', 1, 1, 1) returning id)
insert into _g select 'espresso', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'espresso'), 'Single', 0, true, true, 1),
  ((select id from _g where key = 'espresso'), 'Double', 4000, false, true, 2);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Pasta Sauce', 1, 1, 2) returning id)
insert into _g select 'sauce', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'sauce'), 'Arrabbiata', 0, true, true, 1),
  ((select id from _g where key = 'sauce'), 'Alfredo', 0, false, true, 2),
  ((select id from _g where key = 'sauce'), 'Pesto', 0, false, true, 3),
  ((select id from _g where key = 'sauce'), 'Roasted Bell Pepper', 0, false, true, 4);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Extra Veggies', 0, 5, 3) returning id)
insert into _g select 'veggies', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'veggies'), 'Broccoli', 8900, false, true, 1),
  ((select id from _g where key = 'veggies'), 'Bell Peppers', 8900, false, true, 2),
  ((select id from _g where key = 'veggies'), 'Jalapeño', 8900, false, true, 3),
  ((select id from _g where key = 'veggies'), 'Black Olives', 8900, false, true, 4),
  ((select id from _g where key = 'veggies'), 'Green Olives', 8900, false, true, 5),
  ((select id from _g where key = 'veggies'), 'Cherry Tomato', 8900, false, true, 6),
  ((select id from _g where key = 'veggies'), 'Mushroom', 8900, false, true, 7),
  ((select id from _g where key = 'veggies'), 'Onion', 8900, false, true, 8),
  ((select id from _g where key = 'veggies'), 'Zucchini', 8900, false, true, 9),
  ((select id from _g where key = 'veggies'), 'Golden Corn', 8900, false, true, 10),
  ((select id from _g where key = 'veggies'), 'Baby Corn', 8900, false, true, 11);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Paratha Filling', 1, 1, 4) returning id)
insert into _g select 'paratha', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'paratha'), 'Aloo', 0, true, true, 1),
  ((select id from _g where key = 'paratha'), 'Paneer', 0, false, true, 2),
  ((select id from _g where key = 'paratha'), 'Gobhi', 0, false, true, 3),
  ((select id from _g where key = 'paratha'), 'Aachari', 0, false, true, 4);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Extra Shot', 0, 1, 5) returning id)
insert into _g select 'shot', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'shot'), 'Extra Espresso Shot', 4500, false, true, 1);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Flavoured Syrup', 0, 2, 6) returning id)
insert into _g select 'syrup', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'syrup'), 'Caramel', 4500, false, true, 1),
  ((select id from _g where key = 'syrup'), 'Vanilla', 4500, false, true, 2),
  ((select id from _g where key = 'syrup'), 'Hazelnut', 4500, false, true, 3),
  ((select id from _g where key = 'syrup'), 'Butterscotch', 4500, false, true, 4),
  ((select id from _g where key = 'syrup'), 'Rose', 4500, false, true, 5),
  ((select id from _g where key = 'syrup'), 'Cinnamon', 4500, false, true, 6);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Plant-based Milk', 0, 1, 7) returning id)
insert into _g select 'milk', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'milk'), 'Almond Milk', 8500, false, true, 1),
  ((select id from _g where key = 'milk'), 'Soy Milk', 8500, false, true, 2),
  ((select id from _g where key = 'milk'), 'Oat Milk', 8500, false, true, 3),
  ((select id from _g where key = 'milk'), 'Coconut Milk', 8500, false, true, 4);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Toppings', 0, 3, 8) returning id)
insert into _g select 'topping', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'topping'), 'Whipped Cream', 6500, false, true, 1),
  ((select id from _g where key = 'topping'), 'Chocolate Drizzle', 6500, false, true, 2),
  ((select id from _g where key = 'topping'), 'Caramel', 6500, false, true, 3),
  ((select id from _g where key = 'topping'), 'Crushed Biscoff', 6500, false, true, 4),
  ((select id from _g where key = 'topping'), 'Cocoa', 6500, false, true, 5);
with g as (insert into modifier_groups (outlet_id, name, min_select, max_select, sort_order)
  values ('00000000-0000-0000-0000-000000000001', 'Ice Cream Scoop', 0, 2, 9) returning id)
insert into _g select 'scoop', id from g;
insert into modifier_options (group_id, name, price_delta_paise, is_default, is_veg, sort_order) values
  ((select id from _g where key = 'scoop'), 'Vanilla Scoop', 6500, false, true, 1),
  ((select id from _g where key = 'scoop'), 'Chocolate Scoop', 6500, false, true, 2);

-- Hot Coffee
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Hot Coffee', 1, '/menu/hot-coffee.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Espresso', 'Strong, rich coffee shot', null, 8000, true, false, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['espresso', 'shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Macchiato', 'Espresso with a hint of milk', null, 18500, true, false, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Americano', 'Smooth diluted espresso', null, 16500, true, false, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Cappuccino', 'Espresso with creamy foam', null, 19000, true, false, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Caffè Latte', 'Espresso with steamed milk', '/menu/hot-coffee.webp', 21000, true, true, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Flat White', 'Velvety espresso with micro-foam', null, 21000, true, false, 6) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Mocha', 'Espresso blended with chocolate', null, 26500, true, false, 7) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Biscoff Latte', 'Latte with Biscoff flavour', null, 25500, true, false, 8) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Caramel Latte', 'Latte with caramel sweetness', null, 24000, true, false, 9) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Tiramisu Latte', 'Latte with tiramisu essence', null, 24500, true, false, 10) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Matcha Latte', 'Creamy Japanese green tea latte', null, 26500, true, false, 11) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Nutella Latte', 'Latte infused with Nutella flavour', null, 26500, true, false, 12) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Hazelnut Latte', 'Smooth espresso & creamy hazelnut flavour', null, 24500, true, false, 13) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Iced Coffee
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Iced Coffee', 2, '/menu/iced-coffee.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Iced Coffee'), 'Iced Americano', 'Bold espresso over ice, crisp & refreshing', '/menu/iced-coffee.webp', 13500, true, false, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Iced Coffee'), 'Iced Latte', 'Espresso with cold milk, light & creamy', null, 18500, true, false, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Iced Coffee'), 'Iced Mocha', 'Chocolate & coffee over ice, sweet & rich', null, 21000, true, false, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Signature Coffee
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Signature Coffee', 3, '/menu/signature-coffee.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Classic Cold Brew', 'Nutty, caramel-rich espresso', null, 16000, true, false, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Saffron Pistachio Latte', 'Luxury blend with saffron & pistachio', null, 26000, true, false, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Coconut Cold Brew', 'Silky cold brew with a twist of coconut', null, 19500, true, false, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Affogato Bliss', 'Creamy & light', '/menu/affogato.webp', 18500, true, true, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Vietnamese Cold Brew', 'Smooth cold brew sweetened with rich condensed milk', null, 15500, true, false, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Frappe
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Frappe', 4, '/menu/frappe.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Brownie Frappe', 'Rich chocolate blend with brownie chunks', null, 27500, true, false, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Butterscotch Frappe', 'Creamy caramelised butterscotch delight', null, 22500, true, false, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Strawberry Frappe', 'Fresh, fruity and perfectly sweet', null, 22500, true, false, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Biscoff Frappe', 'Spiced biscuit flavour with creamy coffee', null, 26500, true, false, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Berry Mocha Frappe', 'Mocha infused with a mixed berries twist', null, 28500, true, false, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Rose Vanilla Frappe', 'Floral rose meets smooth vanilla', null, 27500, true, false, 6) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Caramel Frappe', 'Classic sweet caramel blended to perfection', null, 27500, true, false, 7) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Matcha Frappe', 'Earthy matcha with a creamy finish', null, 28500, true, false, 8) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Tiramisu Frappe', 'Coffee, cocoa and cream inspired by the classic dessert', null, 27500, true, false, 9) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Nutella Frappe', 'Creamy coffee frappe with Nutella', null, 28500, true, false, 10) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Classic Frappe', 'Frothy coffee blend, cool and energising', null, 18500, true, false, 11) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Coffee Coolers
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Coffee Coolers', 5, '/menu/coffee-coolers.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Cold Brew Tonic', 'Cold brew topped with fizzy tonic for a zesty twist', null, 21000, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Mocha Mint Cooler', 'Chocolate & mint fused with chilled coffee', null, 19000, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Affogato Float', 'Espresso & vanilla ice cream delight', null, 15500, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Iced Orange Coffee', 'Espresso with fresh orange zest & juice', null, 22500, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Coffee Mojito', 'Coffee, mint & lime for a cool, tangy sip', null, 25500, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Bull''s Eye', 'Espresso with Red Bull for a bold kick', null, 32500, true, false, 6);

-- Coffee Shakes
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Coffee Shakes', 6, '/menu/coffee-shakes.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Coffee Caramel Shake', 'Cold coffee meets creamy caramel', null, 26500, true, false, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Mocha Crunch Shake', 'Chocolate & espresso blended with ice cream', '/menu/coffee-shakes.webp', 28500, true, false, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Tiramisu Shake', 'Italian dessert turned into a shake', null, 27500, true, false, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Hazelnut Praline Shake', 'Nutty, indulgent, with roasted praline bits', null, 27500, true, false, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Hazelnut Tiramisu Shake', 'A rich dessert-style coffee shake', null, 31000, true, false, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Shots
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Shots', 7, '/menu/shots.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Espresso Shot', 'Pure, strong & intense', '/menu/shots.webp', 8000, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Hazelnut Shot', 'Nutty sweetness kick', null, 11000, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Caramel Shot', 'Smooth & indulgent', null, 11000, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Vanilla Shot', 'Creamy & light', null, 11000, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Irish Cream Shot', 'Non-alcoholic, silky & rich', null, 12500, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Mocha Shot', 'Mini chocolate espresso', null, 14500, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Cranberry Shot', 'Tangy, refreshing burst of cranberry flavour', null, 11000, true, false, 7);

-- Thick Shakes
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Thick Shakes', 8, '/menu/thick-shakes.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Chocolate Shake', null, '/menu/thick-shakes.webp', 24500, true, false, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Vanilla Shake', null, null, 24500, true, false, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Strawberry Shake', null, null, 24500, true, false, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Butterscotch Shake', null, null, 25500, true, false, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Nutella Shake', null, null, 27500, true, false, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Biscoff Shake', null, null, 28500, true, false, 6) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Brownie Shake', null, null, 28500, true, false, 7) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Oreo Shake', null, null, 29500, true, false, 8) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'KitKat Shake', null, null, 29500, true, false, 9) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Ferrero Rocher Shake', null, null, 32500, true, false, 10) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Banana Caramel Shake', null, null, 28500, true, false, 11) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Lychee Shake', null, null, 27500, true, false, 12) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Berry Blast Shake', null, null, 26500, true, false, 13) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Tender Coconut Shake', null, null, 28500, true, false, 14) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Tiramisu Thick Shake', null, null, 28500, true, false, 15) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Nutella Hazelnut Shake', null, null, 26500, true, false, 16) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Brownie Fudge Shake', null, null, 29500, true, false, 17) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Strawberry Cheesecake Shake', null, null, 32500, true, false, 18) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Blueberry Lavender Shake', null, null, 32500, true, false, 19) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Lychee Rose Shake', null, null, 28500, true, false, 20) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Mango Almond Bliss', null, null, 28500, true, false, 21) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Berry Biscoff Shake', null, null, 28500, true, false, 22) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Hot Bournvita Brownie Shake', null, null, 28500, true, false, 23) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Bournvita Shake', null, null, 27500, true, false, 24) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Tiramisu Hot Chocolate', null, null, 35500, true, false, 25) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Hazelnut Hot Chocolate', null, null, 34500, true, false, 26) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Biscoff Hot Chocolate', null, null, 35500, true, false, 27) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Sea Salt Hot Chocolate', null, null, 38500, true, false, 28) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Coolers
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Coolers', 9, '/menu/coolers.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Classic Lemon Iced Tea', null, null, 12500, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Peach Iced Tea', null, null, 13500, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Watermelon Cooler', null, null, 12500, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Mint Mojito', null, null, 16500, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Peach Mojito', null, null, 17500, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Lavender Mojito', null, null, 18500, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Cranberry Mojito', null, '/menu/coolers.webp', 16500, true, true, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Berry Blast Cooler', null, null, 16500, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Lychee Basil Sparkle', null, null, 18500, true, false, 9);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Black Dragon', null, null, 18500, true, false, 10);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Martini Punch', null, null, 16500, true, false, 11);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Blackcurrant Sparkler', null, null, 16500, true, false, 12);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Bubblegum Spritzer', null, null, 16500, true, false, 13);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Green Apple Spritzer', null, null, 18500, true, false, 14);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Cucumber Basil Cooler', null, null, 15500, true, false, 15);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Rose Lemonade', null, '/menu/rose-lemonade.webp', 19500, true, false, 16);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Spicy Guava', null, null, 16500, true, false, 17);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Pinacolada', null, null, 22500, true, false, 18);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Cosmopolitan', null, null, 22500, true, false, 19);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Bull''s Mint Blast', null, null, 22500, true, false, 20);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Sweet Lime Soda', null, null, 12500, true, false, 21);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Salted Lime Soda', null, null, 12500, true, false, 22);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Masala Cold Drink', null, null, 12500, true, false, 23);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Butter Milk', null, null, 8500, true, false, 24);

-- Toasts
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Toasts', 10, '/menu/toasts.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Chilli Cheese Toast', 'Mozzarella, cheddar, bell peppers & green chilli on toasted bread', '/menu/toasts.webp', 28500, true, true, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Pesto Avocado Toast', 'Creamy avocado with basil pesto', null, 35900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Avocado Feta Toast', 'Smashed avocado topped with feta & microgreens', null, 37500, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Roasted Hummus Toast', 'Sourdough with hummus, cherry tomatoes & sesame seeds', null, 32900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Spinach Ricotta Mushroom Toast', 'Sautéed spinach & mushrooms with ricotta', null, 38900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Pesto Tomato Bruschetta', 'Toasted bread with pesto, basil & cherry tomatoes', null, 28900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Avocado Balsamic Tartines', 'Open-faced toast with avocado & balsamic glaze', null, 32900, true, false, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Sundried Tomato Avocado Toast', 'Avocado with sundried tomatoes on artisan bread', null, 29900, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Mushroom Garlic Toast', 'Garlic-sautéed mushrooms on golden toast', null, 27500, true, false, 9);

-- Sandwiches
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Sandwiches', 11, '/menu/sandwiches.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Grilled Cheese Sandwich', 'Golden toasted bread with melted cheese', null, 27900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Pesto Veggie Sandwich', 'Veggies with basil pesto on toasted bread', null, 26900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Vegetable Club Sandwich', 'Triple-layered veggies, cheese & house sauce', null, 27500, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Pesto Mozzarella Sandwich', 'Fresh mozzarella, tomato and basil pesto', null, 32900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Mediterranean Hummus Sandwich', 'Hummus, olives, cucumber & sun-dried tomatoes', null, 29000, true, false, 5);

-- Burgers
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Burgers', 12, '/menu/burgers.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Veg Burger', 'Classic veggie patty with tomato, lettuce and house sauce', null, 25500, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Mexican Burger', 'Spicy beans patty with jalapeños, salsa and cheese', null, 28500, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Cottage Cheese Tikka Burger', 'Indian spiced cottage cheese tikka patty with mayo', null, 28900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Volcano Cheese Burger', 'A spicy, cheesy burger loaded with molten cheese and fiery flavour', '/menu/burgers.webp', 33900, true, true, 4);

-- Pastas
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Pastas', 13, '/menu/pastas.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Build Your Own Pasta', 'Pick your sauce and veggies. Served with garlic bread', null, 45000, true, false, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['sauce', 'veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Chilli Garlic Butter Spaghetti', 'Spaghetti tossed in rich garlic butter and spicy chilli oil for a bold, flavourful kick', null, 39900, true, false, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Aglio Olio', 'Classic Italian pasta tossed with garlic, olive oil, chilli flakes and herbs', null, 37900, true, false, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Ravioli Pasta', 'Stuffed pasta pockets served with rich sauce and herbs', null, 42900, true, false, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- French Fries
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'French Fries', 14, '/menu/french-fries.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Classic Veg Fries', 'Crispy golden fries, lightly salted', '/menu/french-fries.webp', 17900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Cheesy Garlic Fries', 'In garlic butter & melted cheese', null, 24900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Herb & Parmesan Fries', 'Fries with herbs & parmesan sprinkle', null, 27900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Spicy Cajun Fries', 'Bold, zesty Cajun-seasoned fries', null, 19900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Masala Fries', 'Indian-style spiced fries with tangy chutney', null, 16500, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Chilli Cheese Fries', 'Tossed in spicy veg chilli & melted cheese', null, 31900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Peri Peri Fries', 'Crispy fries tossed in tangy and spicy peri-peri seasoning', null, 22900, true, false, 7);

-- Salads
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Salads', 15, '/menu/salads.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Watermelon & Feta Salad', 'Juicy watermelon, feta, walnuts & basil with balsamic dressing', null, 28000, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Gado Gado Salad', 'Indonesian veggies and tofu with creamy peanut dressing', null, 25500, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'California Salad', 'Avocado, fresh veggies, feta, walnuts & cranberries with garlic-rosemary dressing', null, 35900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Caesar Salad', 'Classic romaine, parmesan, croutons & creamy Caesar dressing', null, 29900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Caprese Salad', 'Fresh tomato, mozzarella & basil with balsamic glaze', '/menu/caprese.webp', 31900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Greek Salad', 'Tomatoes, cucumber, olives, red onion & feta with oregano dressing', '/menu/salads.webp', 28000, true, false, 6);

-- Mexican
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Mexican', 16, '/menu/mexican.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Quesadilla', 'Grilled tortilla stuffed with cheese, veggies and spices', null, 34900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Burrito Bowl', 'A bowl of rice, beans, veggies and toppings inspired by a burrito', null, 48000, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Nachos Mexicana', 'Crispy nachos topped with beans, cheese, salsa and jalapeños', '/menu/mexican.webp', 37900, true, true, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Mexican Hot Pot', 'Spicy Mexican rice bowl with beans, veggies and melted cheese', null, 45000, true, false, 4);

-- Lebanese
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Lebanese', 17, '/menu/lebanese.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Lebanese'), 'Hummus Bowl', 'Creamy hummus served with fresh veggies, pita and toppings', '/menu/lebanese.webp', 34900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Lebanese'), 'Labneh Crackers', 'Creamy labneh served with crisp seasoned crackers', null, 48000, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Lebanese'), 'Falafel Bites', 'Crispy chickpea balls served with creamy dip', null, 37900, true, false, 3);

-- Sushi
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Sushi', 18, '/menu/sushi.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Tempura Sushi', 'Crispy tempura-filled sushi rolls with savoury seasoning', null, 34900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Uramaki Sushi', 'Inside-out rolls with rice outside and flavourful fillings inside', null, 34900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Dragon Sushi', 'Bold & spicy roll with layered toppings and creamy sauce', '/menu/sushi.webp', 34900, true, true, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Avocado Sushi', 'Fresh rolls with smooth avocado and light seasoning', null, 35900, true, false, 4);

-- Dim Sum
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Dim Sum', 19, '/menu/dim-sum.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Cheese Corn Dim Sum', 'Soft dumplings filled with creamy cheese & sweet corn', null, 32900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Exotic Veg Dim Sum', 'Steamed dim sums packed with mixed seasonal vegetables', null, 32900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Shiitake Mushroom Dim Sum', 'Savoury dumplings stuffed with shiitake mushrooms & herbs', null, 34900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Assorted Dim Sum', 'Cheese Corn, Exotic Veg and Shiitake Mushroom dim sums', null, 35900, true, false, 4);

-- Soups
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Soups', 20, '/menu/soups.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Roasted Bell Pepper Soup', null, null, 24900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Burnt Garlic Broccoli Soup', null, null, 24900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Hot & Sour Soup', null, null, 24900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Manchow Soup', null, null, 24900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Lemon Coriander Soup', null, null, 24900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Sweet Corn Soup', null, null, 24900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Tomato Basil Soup', null, '/menu/soups.webp', 22900, true, false, 7);

-- Oriental
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Oriental', 21, '/menu/oriental.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Pepper Corn Crisp', null, null, 37900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Paneer Chilli', null, null, 35900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Mushroom Chilli', null, null, 37900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Manchurian', null, null, 35900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Dragon Paneer', null, null, 37900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Hakka Noodles', null, '/menu/oriental.webp', 32900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Schezwan Noodles', null, null, 33900, true, false, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Chilli Garlic Noodles', null, null, 33900, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Chinese Bhel', null, null, 32900, true, false, 9);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Stir-Fried Veg in Garlic Sauce', null, null, 32900, true, false, 10);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Broccoli Mushroom in Hunan Sauce', null, null, 35900, true, false, 11);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Crispy Corn Salt & Pepper', null, null, 29900, true, false, 12);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Honey Chilli Potatoes', null, null, 29900, true, false, 13);

-- Appetizers
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Appetizers', 22, null)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Cheese Corn Kebab', null, null, 28900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Dahi Kebab', null, null, 29900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Veg Seekh Kebab', null, null, 28900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Hara Bhara Kebab', null, null, 28900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Beetroot Thecha Kebab', null, null, 29900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Malai Broccoli', null, null, 33900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Paneer Tikka', null, null, 29900, true, false, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Malai Paneer Tikka', null, null, 30900, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Lehsuni Paneer Tikka', null, null, 30900, true, false, 9);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Aachari Paneer Tikka', null, null, 30900, true, false, 10);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Pahadi Tikka', null, null, 32900, true, false, 11);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Paneer Banarasi Tikka', null, null, 32900, true, false, 12);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Paneer Thecha Tikka', null, null, 32900, true, false, 13);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Mushroom Tikka', null, null, 33900, true, false, 14);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Mushroom Multani Tikka', null, null, 35900, true, false, 15);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Tandoori Thecha Aloo', null, null, 28900, true, false, 16);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Tandoori Pineapple', null, null, 29900, true, false, 17);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Dal Makhani Shots', null, null, 35900, true, false, 18);

-- Veg Main Course
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Veg Main Course', 23, '/menu/veg-main.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Palak Lehsuni', null, null, 28900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Palak Corn', null, null, 29900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Mix Veg', null, null, 29900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Diwani Handi', null, null, 32900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Bhuna Masala', null, null, 32900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Angara', null, null, 33900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Kolhapuri', null, null, 29900, true, false, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Methi Matar Malai', null, null, 33900, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Shahi Malai Kofta', null, null, 35900, true, false, 9);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Rajasthani Kofta', null, null, 35900, true, false, 10);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Kaju Masala', null, null, 36900, true, false, 11);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Kaju Matar Malai', null, null, 37900, true, false, 12);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Stuffed Tomato Masala', null, null, 35900, true, false, 13);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Aloo Jeera', null, null, 28900, true, false, 14);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Aloo Dum Punjabi', null, null, 32900, true, false, 15);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Tawa Mushroom', null, null, 33900, true, false, 16);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Mushroom Masala', null, null, 33900, true, false, 17);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Chana Masala', null, null, 32900, true, false, 18);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Bhindi Masala', null, null, 28900, true, false, 19);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Bhindi Dry', null, null, 27900, true, false, 20);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Kurkuri Bhindi', null, null, 28900, true, false, 21);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Makai Masala', null, null, 32900, true, false, 22);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Sev Tamatar', null, null, 28900, true, false, 23);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Sev Bhaji', null, null, 29900, true, false, 24);

-- Paneer Main Course
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Paneer Main Course', 24, '/menu/paneer.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Bulbul', null, null, 35900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Akbari', null, null, 37900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Angara', null, null, 33900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Patiala', null, null, 34900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Palak Paneer', null, '/menu/paneer.webp', 32900, true, true, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Do Pyaaza', null, null, 33900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Tikka Masala', null, null, 35900, true, false, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Tikka Lababdar', null, null, 35900, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Lababdar', null, null, 33900, true, false, 9);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Butter Masala', null, null, 33900, true, false, 10);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Chatpata', null, null, 33900, true, false, 11);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Kadhai Paneer', null, null, 33900, true, false, 12);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Pasanda', null, null, 33900, true, false, 13);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Shahi Paneer', null, null, 35900, true, false, 14);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Kolhapuri', null, null, 33900, true, false, 15);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Kaju Masala', null, null, 38900, true, false, 16);

-- Dal
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Dal', 25, '/menu/dal.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Plain Dal', null, null, 28900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Fry', null, null, 31900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Tadka', null, null, 32900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Makhani', null, null, 35900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Mughlai', null, null, 33900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Snack Dal with Papad', null, null, 35900, true, false, 6);

-- Rice
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Rice', 26, '/menu/rice.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Plain Rice', null, null, 27900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Jeera Rice', null, null, 28900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Onion Jeera Rice', null, null, 29900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Green Peas Pulao', null, null, 29900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Tomato Onion Rice', null, null, 31900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Curd Rice', null, null, 29900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Masala Rice', null, null, 31900, true, false, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Lemon Rice', null, null, 31900, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Veg Pulao', null, null, 32900, true, false, 9);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Paneer Pulao', null, null, 33900, true, false, 10);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Tawa Pulao', null, null, 33900, true, false, 11);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Veg Biryani', null, '/menu/rice.webp', 33900, true, false, 12);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Hyderabadi Biryani', null, null, 34900, true, false, 13);

-- Breads
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Breads', 27, '/menu/breads.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Roti Plain', null, null, 4500, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Roti Butter', null, null, 5500, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Naan Plain', null, null, 5500, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Naan Butter', null, '/menu/breads.webp', 6500, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Garlic Naan', null, null, 6500, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Cheese Garlic Naan', null, null, 9500, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Mix Veg Kulcha', null, null, 7500, true, false, 7);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Thecha Aloo Kulcha', null, null, 8500, true, false, 8);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Cheese Corn Kulcha', null, null, 9500, true, false, 9);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Paneer Kulcha', null, null, 9500, true, false, 10);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Lacha Paratha', null, null, 6500, true, false, 11);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Missi Roti', null, null, 7500, true, false, 12);
with i as (insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Choice of Paratha', 'Aloo, Paneer, Gobhi or Aachari', null, 12500, true, false, 13) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['paratha']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Curd & Raita
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Curd & Raita', 28, null)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Plain Curd', null, null, 8900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Boondi Raita', null, null, 13900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Veg Raita', null, null, 12900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Pineapple Raita', null, null, 15900, true, false, 4);

-- Indian Salads
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Indian Salads', 29, '/menu/indian-salads.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Green Salad', null, null, 13900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Onion Salad', null, '/menu/indian-salads.webp', 12900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Kachumbar Salad', null, null, 12900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Peanut Salad', null, null, 23900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Chana Roast', null, null, 23900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Bhungara Pyaaz', null, null, 25900, true, false, 6);

-- Papad & Sides
insert into menu_categories (outlet_id, name, sort_order, image_url) values ('00000000-0000-0000-0000-000000000001', 'Papad & Sides', 30, '/menu/papad.webp')
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order, image_url = excluded.image_url;
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Plain Papad', null, '/menu/papad.webp', 4900, true, false, 1);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Masala Papad', null, null, 8900, true, false, 2);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Chane Ka Papad', null, null, 5900, true, false, 3);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Ghee Khichiya', null, null, 8900, true, false, 4);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Masala Khichiya', null, null, 12900, true, false, 5);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Papad Churi', null, null, 15900, true, false, 6);
insert into menu_items (outlet_id, category_id, name, description, image_url, base_price_paise, is_veg, is_bestseller, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Baghari Sev', null, null, 21900, true, false, 7);
commit;

select 'Menu loaded' as result, 30 as sections, 279 as items;
