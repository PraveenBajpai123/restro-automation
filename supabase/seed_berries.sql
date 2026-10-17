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
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Hot Coffee', 1)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Espresso', 'Strong, rich coffee shot', 8000, true, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['espresso', 'shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Macchiato', 'Espresso with a hint of milk', 18500, true, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Americano', 'Smooth diluted espresso', 16500, true, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Cappuccino', 'Espresso with creamy foam', 19000, true, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Caffè Latte', 'Espresso with steamed milk', 21000, true, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Flat White', 'Velvety espresso with micro-foam', 21000, true, 6) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Mocha', 'Espresso blended with chocolate', 26500, true, 7) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Biscoff Latte', 'Latte with Biscoff flavour', 25500, true, 8) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Caramel Latte', 'Latte with caramel sweetness', 24000, true, 9) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Tiramisu Latte', 'Latte with tiramisu essence', 24500, true, 10) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Matcha Latte', 'Creamy Japanese green tea latte', 26500, true, 11) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Nutella Latte', 'Latte infused with Nutella flavour', 26500, true, 12) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Hot Coffee'), 'Hazelnut Latte', 'Smooth espresso & creamy hazelnut flavour', 24500, true, 13) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Iced Coffee
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Iced Coffee', 2)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Iced Coffee'), 'Iced Americano', 'Bold espresso over ice, crisp & refreshing', 13500, true, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Iced Coffee'), 'Iced Latte', 'Espresso with cold milk, light & creamy', 18500, true, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Iced Coffee'), 'Iced Mocha', 'Chocolate & coffee over ice, sweet & rich', 21000, true, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Signature Coffee
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Signature Coffee', 3)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Classic Cold Brew', 'Nutty, caramel-rich espresso', 16000, true, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Saffron Pistachio Latte', 'Luxury blend with saffron & pistachio', 26000, true, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Coconut Cold Brew', 'Silky cold brew with a twist of coconut', 19500, true, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Affogato Bliss', 'Creamy & light', 18500, true, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Signature Coffee'), 'Vietnamese Cold Brew', 'Smooth cold brew sweetened with rich condensed milk', 15500, true, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['syrup', 'topping']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Frappe
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Frappe', 4)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Brownie Frappe', 'Rich chocolate blend with brownie chunks', 27500, true, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Butterscotch Frappe', 'Creamy caramelised butterscotch delight', 22500, true, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Strawberry Frappe', 'Fresh, fruity and perfectly sweet', 22500, true, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Biscoff Frappe', 'Spiced biscuit flavour with creamy coffee', 26500, true, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Berry Mocha Frappe', 'Mocha infused with a mixed berries twist', 28500, true, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Rose Vanilla Frappe', 'Floral rose meets smooth vanilla', 27500, true, 6) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Caramel Frappe', 'Classic sweet caramel blended to perfection', 27500, true, 7) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Matcha Frappe', 'Earthy matcha with a creamy finish', 28500, true, 8) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Tiramisu Frappe', 'Coffee, cocoa and cream inspired by the classic dessert', 27500, true, 9) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Nutella Frappe', 'Creamy coffee frappe with Nutella', 28500, true, 10) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Frappe'), 'Classic Frappe', 'Frothy coffee blend, cool and energising', 18500, true, 11) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['shot', 'syrup', 'milk', 'topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Coffee Coolers
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Coffee Coolers', 5)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Cold Brew Tonic', 'Cold brew topped with fizzy tonic for a zesty twist', 21000, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Mocha Mint Cooler', 'Chocolate & mint fused with chilled coffee', 19000, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Affogato Float', 'Espresso & vanilla ice cream delight', 15500, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Iced Orange Coffee', 'Espresso with fresh orange zest & juice', 22500, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Coffee Mojito', 'Coffee, mint & lime for a cool, tangy sip', 25500, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Coolers'), 'Bull''s Eye', 'Espresso with Red Bull for a bold kick', 32500, true, 6);

-- Coffee Shakes
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Coffee Shakes', 6)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Coffee Caramel Shake', 'Cold coffee meets creamy caramel', 26500, true, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Mocha Crunch Shake', 'Chocolate & espresso blended with ice cream', 28500, true, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Tiramisu Shake', 'Italian dessert turned into a shake', 27500, true, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Hazelnut Praline Shake', 'Nutty, indulgent, with roasted praline bits', 27500, true, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coffee Shakes'), 'Hazelnut Tiramisu Shake', 'A rich dessert-style coffee shake', 31000, true, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Shots
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Shots', 7)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Espresso Shot', 'Pure, strong & intense', 8000, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Hazelnut Shot', 'Nutty sweetness kick', 11000, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Caramel Shot', 'Smooth & indulgent', 11000, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Vanilla Shot', 'Creamy & light', 11000, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Irish Cream Shot', 'Non-alcoholic, silky & rich', 12500, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Mocha Shot', 'Mini chocolate espresso', 14500, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Shots'), 'Cranberry Shot', 'Tangy, refreshing burst of cranberry flavour', 11000, true, 7);

-- Thick Shakes
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Thick Shakes', 8)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Chocolate Shake', null, 24500, true, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Vanilla Shake', null, 24500, true, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Strawberry Shake', null, 24500, true, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Butterscotch Shake', null, 25500, true, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Nutella Shake', null, 27500, true, 5) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Biscoff Shake', null, 28500, true, 6) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Brownie Shake', null, 28500, true, 7) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Oreo Shake', null, 29500, true, 8) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'KitKat Shake', null, 29500, true, 9) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Ferrero Rocher Shake', null, 32500, true, 10) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Banana Caramel Shake', null, 28500, true, 11) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Lychee Shake', null, 27500, true, 12) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Berry Blast Shake', null, 26500, true, 13) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Tender Coconut Shake', null, 28500, true, 14) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Tiramisu Thick Shake', null, 28500, true, 15) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Nutella Hazelnut Shake', null, 26500, true, 16) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Brownie Fudge Shake', null, 29500, true, 17) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Strawberry Cheesecake Shake', null, 32500, true, 18) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Blueberry Lavender Shake', null, 32500, true, 19) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Lychee Rose Shake', null, 28500, true, 20) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Mango Almond Bliss', null, 28500, true, 21) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Berry Biscoff Shake', null, 28500, true, 22) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Hot Bournvita Brownie Shake', null, 28500, true, 23) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Bournvita Shake', null, 27500, true, 24) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Tiramisu Hot Chocolate', null, 35500, true, 25) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Hazelnut Hot Chocolate', null, 34500, true, 26) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Biscoff Hot Chocolate', null, 35500, true, 27) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Thick Shakes'), 'Sea Salt Hot Chocolate', null, 38500, true, 28) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['topping', 'scoop']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Coolers
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Coolers', 9)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Classic Lemon Iced Tea', null, 12500, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Peach Iced Tea', null, 13500, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Watermelon Cooler', null, 12500, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Mint Mojito', null, 16500, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Peach Mojito', null, 17500, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Lavender Mojito', null, 18500, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Cranberry Mojito', null, 16500, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Berry Blast Cooler', null, 16500, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Lychee Basil Sparkle', null, 18500, true, 9);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Black Dragon', null, 18500, true, 10);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Martini Punch', null, 16500, true, 11);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Blackcurrant Sparkler', null, 16500, true, 12);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Bubblegum Spritzer', null, 16500, true, 13);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Green Apple Spritzer', null, 18500, true, 14);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Cucumber Basil Cooler', null, 15500, true, 15);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Rose Lemonade', null, 19500, true, 16);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Spicy Guava', null, 16500, true, 17);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Pinacolada', null, 22500, true, 18);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Cosmopolitan', null, 22500, true, 19);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Bull''s Mint Blast', null, 22500, true, 20);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Sweet Lime Soda', null, 12500, true, 21);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Salted Lime Soda', null, 12500, true, 22);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Masala Cold Drink', null, 12500, true, 23);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Coolers'), 'Butter Milk', null, 8500, true, 24);

-- Toasts
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Toasts', 10)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Chilli Cheese Toast', 'Mozzarella, cheddar, bell peppers & green chilli on toasted bread', 28500, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Pesto Avocado Toast', 'Creamy avocado with basil pesto', 35900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Avocado Feta Toast', 'Smashed avocado topped with feta & microgreens', 37500, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Roasted Hummus Toast', 'Sourdough with hummus, cherry tomatoes & sesame seeds', 32900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Spinach Ricotta Mushroom Toast', 'Sautéed spinach & mushrooms with ricotta', 38900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Pesto Tomato Bruschetta', 'Toasted bread with pesto, basil & cherry tomatoes', 28900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Avocado Balsamic Tartines', 'Open-faced toast with avocado & balsamic glaze', 32900, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Sundried Tomato Avocado Toast', 'Avocado with sundried tomatoes on artisan bread', 29900, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Toasts'), 'Mushroom Garlic Toast', 'Garlic-sautéed mushrooms on golden toast', 27500, true, 9);

-- Sandwiches
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Sandwiches', 11)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Grilled Cheese Sandwich', 'Golden toasted bread with melted cheese', 27900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Pesto Veggie Sandwich', 'Veggies with basil pesto on toasted bread', 26900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Vegetable Club Sandwich', 'Triple-layered veggies, cheese & house sauce', 27500, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Pesto Mozzarella Sandwich', 'Fresh mozzarella, tomato and basil pesto', 32900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sandwiches'), 'Mediterranean Hummus Sandwich', 'Hummus, olives, cucumber & sun-dried tomatoes', 29000, true, 5);

-- Burgers
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Burgers', 12)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Veg Burger', 'Classic veggie patty with tomato, lettuce and house sauce', 25500, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Mexican Burger', 'Spicy beans patty with jalapeños, salsa and cheese', 28500, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Cottage Cheese Tikka Burger', 'Indian spiced cottage cheese tikka patty with mayo', 28900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Burgers'), 'Volcano Cheese Burger', 'A spicy, cheesy burger loaded with molten cheese and fiery flavour', 33900, true, 4);

-- Pastas
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Pastas', 13)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Build Your Own Pasta', 'Pick your sauce and veggies. Served with garlic bread', 45000, true, 1) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['sauce', 'veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Chilli Garlic Butter Spaghetti', 'Spaghetti tossed in rich garlic butter and spicy chilli oil for a bold, flavourful kick', 39900, true, 2) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Aglio Olio', 'Classic Italian pasta tossed with garlic, olive oil, chilli flakes and herbs', 37900, true, 3) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Pastas'), 'Ravioli Pasta', 'Stuffed pasta pockets served with rich sauce and herbs', 42900, true, 4) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['veggies']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- French Fries
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'French Fries', 14)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Classic Veg Fries', 'Crispy golden fries, lightly salted', 17900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Cheesy Garlic Fries', 'In garlic butter & melted cheese', 24900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Herb & Parmesan Fries', 'Fries with herbs & parmesan sprinkle', 27900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Spicy Cajun Fries', 'Bold, zesty Cajun-seasoned fries', 19900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Masala Fries', 'Indian-style spiced fries with tangy chutney', 16500, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Chilli Cheese Fries', 'Tossed in spicy veg chilli & melted cheese', 31900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'French Fries'), 'Peri Peri Fries', 'Crispy fries tossed in tangy and spicy peri-peri seasoning', 22900, true, 7);

-- Salads
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Salads', 15)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Watermelon & Feta Salad', 'Juicy watermelon, feta, walnuts & basil with balsamic dressing', 28000, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Gado Gado Salad', 'Indonesian veggies and tofu with creamy peanut dressing', 25500, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'California Salad', 'Avocado, fresh veggies, feta, walnuts & cranberries with garlic-rosemary dressing', 35900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Caesar Salad', 'Classic romaine, parmesan, croutons & creamy Caesar dressing', 29900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Caprese Salad', 'Fresh tomato, mozzarella & basil with balsamic glaze', 31900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Salads'), 'Greek Salad', 'Tomatoes, cucumber, olives, red onion & feta with oregano dressing', 28000, true, 6);

-- Mexican
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Mexican', 16)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Quesadilla', 'Grilled tortilla stuffed with cheese, veggies and spices', 34900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Burrito Bowl', 'A bowl of rice, beans, veggies and toppings inspired by a burrito', 48000, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Nachos Mexicana', 'Crispy nachos topped with beans, cheese, salsa and jalapeños', 37900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Mexican'), 'Mexican Hot Pot', 'Spicy Mexican rice bowl with beans, veggies and melted cheese', 45000, true, 4);

-- Lebanese
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Lebanese', 17)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Lebanese'), 'Hummus Bowl', 'Creamy hummus served with fresh veggies, pita and toppings', 34900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Lebanese'), 'Labneh Crackers', 'Creamy labneh served with crisp seasoned crackers', 48000, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Lebanese'), 'Falafel Bites', 'Crispy chickpea balls served with creamy dip', 37900, true, 3);

-- Sushi
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Sushi', 18)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Tempura Sushi', 'Crispy tempura-filled sushi rolls with savoury seasoning', 34900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Uramaki Sushi', 'Inside-out rolls with rice outside and flavourful fillings inside', 34900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Dragon Sushi', 'Bold & spicy roll with layered toppings and creamy sauce', 34900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Sushi'), 'Avocado Sushi', 'Fresh rolls with smooth avocado and light seasoning', 35900, true, 4);

-- Dim Sum
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Dim Sum', 19)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Cheese Corn Dim Sum', 'Soft dumplings filled with creamy cheese & sweet corn', 32900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Exotic Veg Dim Sum', 'Steamed dim sums packed with mixed seasonal vegetables', 32900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Shiitake Mushroom Dim Sum', 'Savoury dumplings stuffed with shiitake mushrooms & herbs', 34900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dim Sum'), 'Assorted Dim Sum', 'Cheese Corn, Exotic Veg and Shiitake Mushroom dim sums', 35900, true, 4);

-- Soups
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Soups', 20)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Roasted Bell Pepper Soup', null, 24900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Burnt Garlic Broccoli Soup', null, 24900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Hot & Sour Soup', null, 24900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Manchow Soup', null, 24900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Lemon Coriander Soup', null, 24900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Sweet Corn Soup', null, 24900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Soups'), 'Tomato Basil Soup', null, 22900, true, 7);

-- Oriental
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Oriental', 21)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Pepper Corn Crisp', null, 37900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Paneer Chilli', null, 35900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Mushroom Chilli', null, 37900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Manchurian', null, 35900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Dragon Paneer', null, 37900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Hakka Noodles', null, 32900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Schezwan Noodles', null, 33900, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Chilli Garlic Noodles', null, 33900, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Chinese Bhel', null, 32900, true, 9);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Stir-Fried Veg in Garlic Sauce', null, 32900, true, 10);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Broccoli Mushroom in Hunan Sauce', null, 35900, true, 11);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Crispy Corn Salt & Pepper', null, 29900, true, 12);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Oriental'), 'Honey Chilli Potatoes', null, 29900, true, 13);

-- Appetizers
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Appetizers', 22)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Cheese Corn Kebab', null, 28900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Dahi Kebab', null, 29900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Veg Seekh Kebab', null, 28900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Hara Bhara Kebab', null, 28900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Beetroot Thecha Kebab', null, 29900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Malai Broccoli', null, 33900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Paneer Tikka', null, 29900, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Malai Paneer Tikka', null, 30900, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Lehsuni Paneer Tikka', null, 30900, true, 9);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Aachari Paneer Tikka', null, 30900, true, 10);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Pahadi Tikka', null, 32900, true, 11);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Paneer Banarasi Tikka', null, 32900, true, 12);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Paneer Thecha Tikka', null, 32900, true, 13);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Mushroom Tikka', null, 33900, true, 14);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Mushroom Multani Tikka', null, 35900, true, 15);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Tandoori Thecha Aloo', null, 28900, true, 16);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Tandoori Pineapple', null, 29900, true, 17);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Appetizers'), 'Dal Makhani Shots', null, 35900, true, 18);

-- Veg Main Course
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Veg Main Course', 23)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Palak Lehsuni', null, 28900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Palak Corn', null, 29900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Mix Veg', null, 29900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Diwani Handi', null, 32900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Bhuna Masala', null, 32900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Angara', null, 33900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Veg Kolhapuri', null, 29900, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Methi Matar Malai', null, 33900, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Shahi Malai Kofta', null, 35900, true, 9);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Rajasthani Kofta', null, 35900, true, 10);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Kaju Masala', null, 36900, true, 11);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Kaju Matar Malai', null, 37900, true, 12);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Stuffed Tomato Masala', null, 35900, true, 13);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Aloo Jeera', null, 28900, true, 14);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Aloo Dum Punjabi', null, 32900, true, 15);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Tawa Mushroom', null, 33900, true, 16);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Mushroom Masala', null, 33900, true, 17);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Chana Masala', null, 32900, true, 18);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Bhindi Masala', null, 28900, true, 19);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Bhindi Dry', null, 27900, true, 20);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Kurkuri Bhindi', null, 28900, true, 21);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Makai Masala', null, 32900, true, 22);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Sev Tamatar', null, 28900, true, 23);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Veg Main Course'), 'Sev Bhaji', null, 29900, true, 24);

-- Paneer Main Course
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Paneer Main Course', 24)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Bulbul', null, 35900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Akbari', null, 37900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Angara', null, 33900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Patiala', null, 34900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Palak Paneer', null, 32900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Do Pyaaza', null, 33900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Tikka Masala', null, 35900, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Tikka Lababdar', null, 35900, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Lababdar', null, 33900, true, 9);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Butter Masala', null, 33900, true, 10);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Chatpata', null, 33900, true, 11);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Kadhai Paneer', null, 33900, true, 12);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Pasanda', null, 33900, true, 13);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Shahi Paneer', null, 35900, true, 14);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Kolhapuri', null, 33900, true, 15);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Paneer Main Course'), 'Paneer Kaju Masala', null, 38900, true, 16);

-- Dal
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Dal', 25)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Plain Dal', null, 28900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Fry', null, 31900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Tadka', null, 32900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Makhani', null, 35900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Dal Mughlai', null, 33900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Dal'), 'Snack Dal with Papad', null, 35900, true, 6);

-- Rice
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Rice', 26)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Plain Rice', null, 27900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Jeera Rice', null, 28900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Onion Jeera Rice', null, 29900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Green Peas Pulao', null, 29900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Tomato Onion Rice', null, 31900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Curd Rice', null, 29900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Masala Rice', null, 31900, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Lemon Rice', null, 31900, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Veg Pulao', null, 32900, true, 9);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Paneer Pulao', null, 33900, true, 10);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Tawa Pulao', null, 33900, true, 11);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Veg Biryani', null, 33900, true, 12);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Rice'), 'Hyderabadi Biryani', null, 34900, true, 13);

-- Breads
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Breads', 27)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Roti Plain', null, 4500, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Roti Butter', null, 5500, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Naan Plain', null, 5500, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Tandoori Naan Butter', null, 6500, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Garlic Naan', null, 6500, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Cheese Garlic Naan', null, 9500, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Mix Veg Kulcha', null, 7500, true, 7);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Thecha Aloo Kulcha', null, 8500, true, 8);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Cheese Corn Kulcha', null, 9500, true, 9);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Paneer Kulcha', null, 9500, true, 10);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Lacha Paratha', null, 6500, true, 11);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Missi Roti', null, 7500, true, 12);
with i as (insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Breads'), 'Choice of Paratha', 'Aloo, Paneer, Gobhi or Aachari', 12500, true, 13) returning id)
insert into menu_item_modifier_groups (menu_item_id, group_id, sort_order)
select i.id, g.id, x.ord from i, unnest(array['paratha']) with ordinality as x(key, ord) join _g g on g.key = x.key;

-- Curd & Raita
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Curd & Raita', 28)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Plain Curd', null, 8900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Boondi Raita', null, 13900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Veg Raita', null, 12900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Curd & Raita'), 'Pineapple Raita', null, 15900, true, 4);

-- Indian Salads
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Indian Salads', 29)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Green Salad', null, 13900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Onion Salad', null, 12900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Kachumbar Salad', null, 12900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Peanut Salad', null, 23900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Chana Roast', null, 23900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Indian Salads'), 'Bhungara Pyaaz', null, 25900, true, 6);

-- Papad & Sides
insert into menu_categories (outlet_id, name, sort_order) values ('00000000-0000-0000-0000-000000000001', 'Papad & Sides', 30)
on conflict (outlet_id, name) do update set is_active = true, sort_order = excluded.sort_order;
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Plain Papad', null, 4900, true, 1);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Masala Papad', null, 8900, true, 2);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Chane Ka Papad', null, 5900, true, 3);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Ghee Khichiya', null, 8900, true, 4);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Masala Khichiya', null, 12900, true, 5);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Papad Churi', null, 15900, true, 6);
insert into menu_items (outlet_id, category_id, name, description, base_price_paise, is_veg, sort_order)
  values ('00000000-0000-0000-0000-000000000001', (select id from menu_categories where outlet_id = '00000000-0000-0000-0000-000000000001' and name = 'Papad & Sides'), 'Baghari Sev', null, 21900, true, 7);
commit;

select 'Menu loaded' as result, 30 as sections, 279 as items;
