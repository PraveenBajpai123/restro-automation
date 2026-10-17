import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import { OUTLET_SLUG } from '../lib/supabase';

// Same item with different options = different line ("Cappuccino, Large" vs "Cappuccino, Regular")
export const lineKey = (itemId, optionIds) => `${itemId}|${[...optionIds].sort().join(',')}`;

export const useCart = create(
  persist(
    (set, get) => ({
      lines: [],
      redeemCoins: true,
      notes: '',

      add(item, options, qty = 1) {
        const key = lineKey(item.id, options.map((o) => o.id));
        const existing = get().lines.find((l) => l.key === key);
        if (existing) {
          set({ lines: get().lines.map((l) => (l.key === key ? { ...l, qty: Math.min(50, l.qty + qty) } : l)) });
          return;
        }
        set({
          lines: [
            ...get().lines,
            {
              key,
              itemId: item.id,
              name: item.name,
              isVeg: item.is_veg,
              basePaise: item.base_price_paise,
              options: options.map((o) => ({ id: o.id, name: o.name, groupName: o.groupName, deltaPaise: o.price_delta_paise })),
              qty,
            },
          ],
        });
      },
      setQty(key, qty) {
        set({ lines: qty <= 0 ? get().lines.filter((l) => l.key !== key) : get().lines.map((l) => (l.key === key ? { ...l, qty: Math.min(50, qty) } : l)) });
      },
      /** Drop lines whose item or option disappeared from the live menu */
      prune(menuIndex) {
        const ok = (l) => {
          const item = menuIndex.items.get(l.itemId);
          return item && item.is_available && l.options.every((o) => menuIndex.options.get(o.id)?.is_available);
        };
        const kept = get().lines.filter(ok);
        if (kept.length !== get().lines.length) set({ lines: kept });
        return get().lines.length - kept.length;
      },
      setRedeem: (redeemCoins) => set({ redeemCoins }),
      setNotes: (notes) => set({ notes }),
      clear: () => set({ lines: [], notes: '' }),
    }),
    { name: `cart-${OUTLET_SLUG}`, storage: createJSONStorage(() => localStorage), version: 1 },
  ),
);

export const cartCount = (lines) => lines.reduce((s, l) => s + l.qty, 0);
