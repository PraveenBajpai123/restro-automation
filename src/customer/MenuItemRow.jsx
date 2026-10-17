import { Plus } from 'lucide-react';
import { VegMark, Stepper } from '../components/ui';
import { formatINR } from '../lib/money';

/** Lowest price a customer can actually pay: base + cheapest choice of every required group */
export function fromPrice(item) {
  return item.groups.reduce((sum, g) => {
    if (g.min_select < 1) return sum;
    const deltas = g.options.filter((o) => o.is_available).map((o) => o.price_delta_paise).sort((a, b) => a - b);
    return sum + deltas.slice(0, g.min_select).reduce((a, b) => a + b, 0);
  }, item.base_price_paise);
}

/** One line of a menu section: name and description on the left, price and add control on the right */
export default function MenuItemRow({ item, inCartQty, onAdd, onSetQty, showVeg }) {
  const customisable = item.groups.length > 0;
  const soldOut = !item.is_available;
  const hasVariants = item.groups.some((g) => g.min_select > 0 && g.options.some((o) => o.price_delta_paise > 0));

  return (
    <li className={`flex items-start gap-3 py-3.5 ${soldOut ? 'opacity-55' : ''}`}>
      {item.image_url && <img src={item.image_url} alt="" loading="lazy" className="h-[72px] w-[72px] flex-none rounded-2xl bg-steel-200 object-cover shadow-sm shadow-ink/10" />}
      <div className="min-w-0 flex-1">
        <div className="flex items-baseline gap-3">
          <h3 className="flex-1 font-serif text-[16px] font-semibold leading-snug">
            {showVeg && <VegMark isVeg={item.is_veg} className="mr-1.5 align-[-1px]" />}
            {item.name}
          </h3>
          <p className="num flex-none font-serif text-[17px] font-semibold">
            {hasVariants && <span className="mr-1 font-sans text-xs font-normal text-ink-soft">from</span>}
            {formatINR(fromPrice(item))}
          </p>
        </div>
        {item.description && <p className="mt-0.5 text-[13px] leading-snug text-ink-soft">{item.description}</p>}
        {item.is_bestseller && <p className="mt-1 text-xs font-semibold text-cardamom">Chef's pick</p>}
      </div>

      <div className="flex w-[4.5rem] flex-none justify-end pt-0.5">
        {soldOut ? (
          <span className="pt-1 text-xs font-semibold text-ink-soft">Sold out</span>
        ) : inCartQty > 0 && !customisable ? (
          <Stepper value={inCartQty} onChange={onSetQty} size="sm" label={`${item.name} quantity`} />
        ) : (
          <button
            onClick={onAdd}
            className="relative grid h-9 w-9 place-items-center rounded-full border border-cardamom bg-white text-cardamom hover:bg-cardamom hover:text-white"
            aria-label={inCartQty > 0 ? `Add another ${item.name}, ${inCartQty} in your order` : `Add ${item.name}${customisable ? ', choose options' : ''}`}
          >
            <Plus size={18} strokeWidth={2.5} aria-hidden="true" />
            {inCartQty > 0 && (
              <span className="num absolute -right-1.5 -top-1.5 grid h-5 min-w-[1.25rem] place-items-center rounded-full bg-cardamom px-1 text-[11px] font-bold text-white" aria-hidden="true">
                {inCartQty}
              </span>
            )}
          </button>
        )}
      </div>
    </li>
  );
}
