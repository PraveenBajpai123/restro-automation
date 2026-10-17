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

/**
 * One dish. Text always starts on the same left edge; a photo, when there is one, sits on the right
 * with the add control overlapping its bottom edge (the Swiggy/Zomato pattern).
 */
export default function MenuItemRow({ item, inCartQty, onAdd, onSetQty, showVeg }) {
  const customisable = item.groups.length > 0;
  const soldOut = !item.is_available;
  const hasVariants = item.groups.some((g) => g.min_select > 0 && g.options.some((o) => o.price_delta_paise > 0));
  const photo = Boolean(item.image_url);

  const control = soldOut ? (
    <span className="rounded-full bg-white px-3 py-1.5 text-xs font-semibold text-ink-soft shadow-sm ring-1 ring-ink/10">Sold out</span>
  ) : inCartQty > 0 && !customisable ? (
    <div className="rounded-full bg-white shadow-md ring-1 ring-ink/10">
      <Stepper value={inCartQty} onChange={onSetQty} size="sm" label={`${item.name} quantity`} />
    </div>
  ) : (
    <button
      onClick={onAdd}
      className="relative flex h-9 items-center gap-1 rounded-full bg-white px-4 text-sm font-semibold text-espresso shadow-md ring-1 ring-ink/10 hover:bg-espresso hover:text-white"
      aria-label={inCartQty > 0 ? `Add another ${item.name}, ${inCartQty} in your order` : `Add ${item.name}${customisable ? ', choose options' : ''}`}
    >
      <Plus size={15} strokeWidth={2.75} aria-hidden="true" /> Add
      {inCartQty > 0 && (
        <span className="num absolute -right-1.5 -top-1.5 grid h-5 min-w-[1.25rem] place-items-center rounded-full bg-espresso px-1 text-[11px] font-bold text-white" aria-hidden="true">
          {inCartQty}
        </span>
      )}
    </button>
  );

  return (
    <li className={`flex items-start gap-4 py-4 ${soldOut ? 'opacity-55' : ''}`}>
      <div className="min-w-0 flex-1">
        <h3 className="font-serif text-[16px] font-semibold leading-snug">
          {showVeg && <VegMark isVeg={item.is_veg} className="mr-1.5 align-[-1px]" />}
          {item.name}
        </h3>
        <p className="num mt-1 text-[15px] font-semibold tracking-tight">
          {hasVariants && <span className="mr-1 text-xs font-normal text-ink-soft">from</span>}
          {formatINR(fromPrice(item))}
        </p>
        {item.description && <p className="mt-1 text-[13px] leading-snug text-ink-soft">{item.description}</p>}
        {customisable && !soldOut && <p className="mt-1.5 text-[11px] font-medium uppercase tracking-wider text-cardamom">Customisable</p>}
      </div>

      {photo ? (
        <div className="relative flex w-[104px] flex-none flex-col items-center pb-4">
          <img src={item.image_url} alt="" loading="lazy" className="h-[104px] w-[104px] rounded-2xl bg-steel-200 object-cover" />
          <div className="absolute bottom-0">{control}</div>
        </div>
      ) : (
        <div className="flex-none pt-0.5">{control}</div>
      )}
    </li>
  );
}
