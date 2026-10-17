import { useCallback, useEffect, useMemo, useState } from 'react';
import { supabase, must } from '../lib/supabase';

const MENU_SELECT = `
  *,
  menu_items (
    id, name, description, image_url, base_price_paise, is_veg, is_bestseller, is_available, sort_order,
    menu_item_modifier_groups (
      sort_order,
      modifier_groups ( id, name, min_select, max_select, sort_order,
        modifier_options ( id, name, price_delta_paise, is_default, is_veg, is_available, sort_order ) )
    )
  )`;

const bySort = (a, b) => a.sort_order - b.sort_order || a.name.localeCompare(b.name);

function normalise(categories) {
  return categories
    .sort(bySort)
    .map((c) => ({
      ...c,
      items: (c.menu_items || [])
        .sort(bySort)
        .map(({ menu_item_modifier_groups, ...item }) => ({
          ...item,
          groups: (menu_item_modifier_groups || [])
            .filter((link) => link.modifier_groups)
            .sort((a, b) => a.sort_order - b.sort_order)
            .map((link) => ({
              ...link.modifier_groups,
              options: [...(link.modifier_groups.modifier_options || [])].sort(bySort),
            })),
        })),
    }))
    .filter((c) => c.items.length > 0);
}

/** Live menu: categories → items → modifier groups → options, refreshed when staff 86 something */
export function useMenu(outletId, client = supabase) {
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const load = useCallback(async () => {
    if (!outletId) return;
    try {
      const rows = must(
        await client.from('menu_categories').select(MENU_SELECT).eq('outlet_id', outletId).eq('is_active', true),
      );
      setCategories(normalise(rows));
      setError(null);
    } catch (e) {
      setError(e.message);
    } finally {
      setLoading(false);
    }
  }, [outletId, client]);

  useEffect(() => {
    load();
    if (!outletId) return;
    const channel = client
      .channel(`menu-${outletId}`)
      .on('postgres_changes', { event: '*', schema: 'public', table: 'menu_items', filter: `outlet_id=eq.${outletId}` }, load)
      .on('postgres_changes', { event: '*', schema: 'public', table: 'modifier_options' }, load)
      .subscribe();
    return () => { client.removeChannel(channel); };
  }, [outletId, load, client]);

  const index = useMemo(() => {
    const items = new Map();
    const options = new Map();
    for (const c of categories)
      for (const i of c.items) {
        items.set(i.id, i);
        for (const g of i.groups) for (const o of g.options) options.set(o.id, o);
      }
    return { items, options };
  }, [categories]);

  return { categories, index, loading, error, reload: load };
}
