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

export default function MenuItemRow({ item, inCartQty, onAdd, onSetQty }) {
  const customisable = item.groups.length > 0;
  const soldOut = !item.is_available;
  const price = fromPrice(item);
  const hasVariants = item.groups.some((g) => g.options.some((o) => o.price_delta_paise > 0));

  return (
    <article className={`flex gap-4 py-5 ${soldOut ? 'opacity-55' : ''}`} aria-label={item.name}>
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <VegMark isVeg={item.is_veg} />
          {item.is_bestseller && <span className="rounded-md bg-haldi-light px-1.5 py-0.5 text-xs font-semibold text-haldi-dark">Bestseller</span>}
        </div>
        <h3 className="mt-1.5 text-[17px] font-semibold leading-snug">{item.name}</h3>
        <p className="num mt-0.5 font-semibold">
          {hasVariants && <span className="font-normal text-ink-soft">from </span>}
          {formatINR(price)}
        </p>
        {item.description && <p className="mt-1.5 line-clamp-2 text-sm leading-relaxed text-ink-soft">{item.description}</p>}
      </div>

      <div className="relative flex w-28 flex-none flex-col items-center">
        {item.image_url ? (
          <img src={item.image_url} alt="" loading="lazy" className="h-28 w-28 rounded-2xl bg-steel-200 object-cover" />
        ) : (
          <div className="h-20 w-28" aria-hidden="true" />
        )}
        <div className={`${item.image_url ? '-mt-5' : ''} relative`}>
          {soldOut ? (
            <span className="block rounded-xl bg-white px-3 py-2 text-sm font-semibold text-ink-soft shadow ring-1 ring-steel-300">Sold out</span>
          ) : inCartQty > 0 && !customisable ? (
            <div className="rounded-xl bg-white shadow ring-1 ring-steel-300">
              <Stepper value={inCartQty} onChange={(q) => onSetQty(q)} size="sm" label={`${item.name} quantity`} />
            </div>
          ) : (
            <button
              onClick={onAdd}
              className="relative rounded-xl bg-white px-6 py-2 text-sm font-bold text-cardamom shadow ring-1 ring-steel-300 hover:bg-cardamom-light"
              aria-label={inCartQty > 0 ? `Add another ${item.name}, ${inCartQty} in your order` : `Add ${item.name}`}
            >
              Add
              {inCartQty > 0 && (
                <span className="num absolute -right-2 -top-2 grid h-5 min-w-[1.25rem] place-items-center rounded-full bg-cardamom px-1 text-xs text-white" aria-hidden="true">
                  {inCartQty}
                </span>
              )}
            </button>
          )}
        </div>
        {customisable && !soldOut && <span className="mt-1 text-xs text-ink-soft">Customisable</span>}
      </div>
    </article>
  );
}
