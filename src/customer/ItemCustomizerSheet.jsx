import { useEffect, useMemo, useState } from 'react';
import { Sheet, Stepper, VegMark } from '../components/ui';
import { formatINR } from '../lib/money';

function groupHint(g) {
  if (g.min_select === 1 && g.max_select === 1) return 'Choose 1';
  if (g.min_select === 0 && g.max_select) return `Optional, up to ${g.max_select}`;
  if (g.min_select === 0) return 'Optional';
  if (g.max_select && g.max_select !== g.min_select) return `Choose ${g.min_select} to ${g.max_select}`;
  return `Choose ${g.min_select}`;
}

function defaultsFor(item) {
  const sel = {};
  for (const g of item.groups) {
    const available = g.options.filter((o) => o.is_available);
    let picks = available.filter((o) => o.is_default).map((o) => o.id);
    if (g.min_select >= 1 && picks.length === 0 && available[0]) picks = [available[0].id];
    sel[g.id] = picks.slice(0, g.max_select ?? picks.length);
  }
  return sel;
}

/** Variations + add-ons picker. Price updates live as options change. */
export default function ItemCustomizerSheet({ item, onClose, onAdd, showVeg = false }) {
  const [selected, setSelected] = useState({});
  const [qty, setQty] = useState(1);

  useEffect(() => {
    if (item) {
      setSelected(defaultsFor(item));
      setQty(1);
    }
  }, [item]);

  const chosen = useMemo(() => {
    if (!item) return [];
    return item.groups.flatMap((g) => g.options.filter((o) => selected[g.id]?.includes(o.id)).map((o) => ({ ...o, groupName: g.name })));
  }, [item, selected]);

  if (!item) return null;

  const unit = item.base_price_paise + chosen.reduce((s, o) => s + o.price_delta_paise, 0);
  const missing = item.groups.find((g) => (selected[g.id]?.length || 0) < g.min_select);

  const toggle = (g, optionId) => {
    setSelected((prev) => {
      const cur = prev[g.id] || [];
      if (g.max_select === 1) return { ...prev, [g.id]: [optionId] };
      if (cur.includes(optionId)) return { ...prev, [g.id]: cur.filter((id) => id !== optionId) };
      if (g.max_select && cur.length >= g.max_select) return prev;
      return { ...prev, [g.id]: [...cur, optionId] };
    });
  };

  return (
    <Sheet
      open
      onClose={onClose}
      title={item.name}
      footer={
        <div className="flex items-center gap-3">
          <Stepper value={qty} onChange={setQty} min={1} label="Quantity" />
          <button className="btn-primary flex-1" disabled={Boolean(missing)} onClick={() => onAdd(item, chosen, qty)}>
            {missing ? `Choose ${missing.name.toLowerCase()}` : <>Add to order <span className="num">{formatINR(unit * qty)}</span></>}
          </button>
        </div>
      }
    >
      {item.image_url && <img src={item.image_url} alt="" className="mb-4 aspect-[16/9] w-full rounded-2xl object-cover" />}
      <div className="flex items-center gap-2 text-sm text-ink-soft">
        {showVeg && <VegMark isVeg={item.is_veg} />}
        <span className="num">{formatINR(item.base_price_paise)}</span>
      </div>
      {item.description && <p className="mt-2 text-ink-soft">{item.description}</p>}

      {item.groups.map((g) => {
        const single = g.max_select === 1;
        const count = selected[g.id]?.length || 0;
        const full = g.max_select && count >= g.max_select;
        return (
          <fieldset key={g.id} className="mt-6">
            <legend className="flex w-full items-baseline justify-between">
              <span className="text-lg font-bold">{g.name}</span>
              <span className={`text-sm ${count < g.min_select ? 'font-semibold text-chilli' : 'text-ink-soft'}`}>{groupHint(g)}</span>
            </legend>
            <div className="mt-2 divide-y divide-steel-200 rounded-2xl ring-1 ring-steel-200">
              {g.options.map((o) => {
                const on = selected[g.id]?.includes(o.id);
                const disabled = !o.is_available || (!on && !single && full);
                return (
                  <label key={o.id} className={`flex cursor-pointer items-center gap-3 px-4 py-3.5 ${disabled ? 'cursor-not-allowed opacity-50' : ''}`}>
                    <input
                      type={single ? 'radio' : 'checkbox'}
                      name={g.id}
                      checked={Boolean(on)}
                      disabled={disabled}
                      onChange={() => toggle(g, o.id)}
                      className="h-5 w-5 accent-cardamom"
                    />
                    {showVeg && <VegMark isVeg={o.is_veg} />}
                    <span className="flex-1">{o.name}{!o.is_available && ' (sold out)'}</span>
                    <span className="num text-ink-soft">{o.price_delta_paise > 0 ? `+${formatINR(o.price_delta_paise)}` : ''}</span>
                  </label>
                );
              })}
            </div>
          </fieldset>
        );
      })}
    </Sheet>
  );
}
