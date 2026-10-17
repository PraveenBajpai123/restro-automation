import { useCallback, useEffect, useMemo, useState } from 'react';
import { staffDb as db, must } from '../lib/supabase';
import { useStaff } from '../hooks/useStaff';
import { formatINR } from '../lib/money';
import { ErrorNote, Spinner } from '../components/ui';
import { PageTitle } from './OwnerLayout';

const RANGES = [
  { id: 1, label: 'Today' },
  { id: 7, label: '7 days' },
  { id: 30, label: '30 days' },
];

function istDate(offsetDays = 0) {
  const d = new Date(Date.now() + 5.5 * 3600 * 1000 - offsetDays * 86400000);
  return d.toISOString().slice(0, 10);
}

function Tile({ label, value, detail }) {
  return (
    <div className="rounded-2xl bg-white p-5 ring-1 ring-steel-200">
      <p className="text-sm text-ink-soft">{label}</p>
      <p className="num mt-1 text-3xl font-bold">{value}</p>
      {detail && <p className="mt-1 text-sm text-ink-soft">{detail}</p>}
    </div>
  );
}

/** Horizontal single-series bars: value at the tip, hover/focus tooltip, table view toggle. */
function BarList({ title, rows, valueOf, format, detailOf, empty }) {
  const [asTable, setAsTable] = useState(false);
  const [hover, setHover] = useState(null);
  const max = Math.max(1, ...rows.map(valueOf));
  return (
    <section className="rounded-2xl bg-white p-5 ring-1 ring-steel-200" aria-label={title}>
      <div className="mb-4 flex items-center justify-between">
        <h2 className="text-lg font-bold">{title}</h2>
        {rows.length > 0 && (
          <button className="text-sm text-ink-soft underline" onClick={() => setAsTable((t) => !t)}>{asTable ? 'Show chart' : 'Show table'}</button>
        )}
      </div>
      {rows.length === 0 ? (
        <p className="py-6 text-center text-ink-soft">{empty}</p>
      ) : asTable ? (
        <table className="w-full text-sm">
          <thead className="text-left text-ink-soft"><tr><th className="py-1 font-medium">Name</th><th className="py-1 text-right font-medium">Value</th><th className="py-1 text-right font-medium">Detail</th></tr></thead>
          <tbody>
            {rows.map((r) => (
              <tr key={r.key} className="border-t border-steel-200"><td className="py-1.5">{r.name}</td><td className="num py-1.5 text-right">{format(valueOf(r))}</td><td className="num py-1.5 text-right text-ink-soft">{detailOf(r)}</td></tr>
            ))}
          </tbody>
        </table>
      ) : (
        <ul className="space-y-3">
          {rows.map((r) => {
            const pct = (valueOf(r) / max) * 100;
            return (
              <li
                key={r.key}
                className="relative"
                tabIndex={0}
                onMouseEnter={() => setHover(r.key)}
                onMouseLeave={() => setHover(null)}
                onFocus={() => setHover(r.key)}
                onBlur={() => setHover(null)}
              >
                <p className="mb-1 truncate text-sm">{r.name}</p>
                <div className="flex items-center gap-2">
                  <div className="h-4 flex-1">
                    <div className="h-4 rounded-r bg-cardamom" style={{ width: `${Math.max(pct, 1)}%` }} />
                  </div>
                  <span className="num w-20 flex-none text-right text-sm font-semibold">{format(valueOf(r))}</span>
                </div>
                {hover === r.key && (
                  <div role="tooltip" className="pointer-events-none absolute -top-9 left-0 z-10 rounded-lg bg-ink px-3 py-1.5 text-xs text-white shadow-lg">
                    {r.name}: {format(valueOf(r))}, {detailOf(r)}
                  </div>
                )}
              </li>
            );
          })}
        </ul>
      )}
    </section>
  );
}

/** Daily net sales columns (single series). One axis, hairline baseline, value on hover. */
function DailyColumns({ days }) {
  const [asTable, setAsTable] = useState(false);
  const [hover, setHover] = useState(null);
  const max = Math.max(1, ...days.map((d) => d.net));
  return (
    <section className="rounded-2xl bg-white p-5 ring-1 ring-steel-200" aria-label="Net sales by day">
      <div className="mb-4 flex items-center justify-between">
        <h2 className="text-lg font-bold">Net sales by day</h2>
        <button className="text-sm text-ink-soft underline" onClick={() => setAsTable((t) => !t)}>{asTable ? 'Show chart' : 'Show table'}</button>
      </div>
      {asTable ? (
        <table className="w-full text-sm">
          <thead className="text-left text-ink-soft"><tr><th className="py-1 font-medium">Day</th><th className="py-1 text-right font-medium">Orders</th><th className="py-1 text-right font-medium">Net sales</th></tr></thead>
          <tbody>{days.map((d) => (<tr key={d.date} className="border-t border-steel-200"><td className="py-1.5">{d.label}</td><td className="num py-1.5 text-right">{d.orders}</td><td className="num py-1.5 text-right">{formatINR(d.net)}</td></tr>))}</tbody>
        </table>
      ) : (
        <div className="relative">
          <div className="flex h-48 items-end gap-[2px] border-b border-steel-200">
            {days.map((d) => (
              <button
                key={d.date}
                className="group relative flex h-full flex-1 items-end justify-center focus-visible:ring-0"
                onMouseEnter={() => setHover(d)}
                onMouseLeave={() => setHover(null)}
                onFocus={() => setHover(d)}
                onBlur={() => setHover(null)}
                aria-label={`${d.label}: ${formatINR(d.net)}, ${d.orders} orders`}
              >
                <span className={`block w-full max-w-[24px] rounded-t ${hover?.date === d.date ? 'bg-cardamom-dark' : 'bg-cardamom'}`} style={{ height: `${(d.net / max) * 100}%`, minHeight: d.net ? 2 : 0 }} />
              </button>
            ))}
          </div>
          <div className="mt-1 flex justify-between text-xs text-ink-soft">
            <span>{days[0]?.label}</span>
            <span>{days[days.length - 1]?.label}</span>
          </div>
          {hover && (
            <div role="tooltip" className="pointer-events-none absolute -top-2 left-1/2 -translate-x-1/2 rounded-lg bg-ink px-3 py-1.5 text-xs text-white shadow-lg">
              {hover.label}: <span className="num font-semibold">{formatINR(hover.net)}</span>, {hover.orders} orders
            </div>
          )}
        </div>
      )}
    </section>
  );
}

export default function Analytics() {
  const { profile } = useStaff();
  const [range, setRange] = useState(1);
  const [data, setData] = useState(null);
  const [error, setError] = useState(null);

  const load = useCallback(async () => {
    try {
      const from = istDate(range - 1);
      const q = (view) => db.from(view).select('*').eq('outlet_id', profile.outlet_id).gte('business_date', from);
      const [daily, items, mods, live] = await Promise.all([
        q('v_daily_sales'),
        q('v_item_sales'),
        q('v_modifier_sales'),
        db.from('orders').select('status', { count: 'exact', head: false }).eq('outlet_id', profile.outlet_id).in('status', ['awaiting_approval', 'placed', 'preparing', 'ready']),
      ]);
      setData({ daily: must(daily), items: must(items), mods: must(mods), live: must(live) });
      setError(null);
    } catch (e) {
      setError(e.message);
    }
  }, [range, profile.outlet_id]);

  useEffect(() => {
    load();
    const channel = db
      .channel(`owner-${profile.outlet_id}`)
      .on('postgres_changes', { event: 'UPDATE', schema: 'public', table: 'orders', filter: `outlet_id=eq.${profile.outlet_id}` }, load)
      .subscribe();
    return () => { db.removeChannel(channel); };
  }, [load, profile.outlet_id]);

  const summary = useMemo(() => {
    if (!data) return null;
    const sum = (k) => data.daily.reduce((s, d) => s + Number(d[k] || 0), 0);
    const orders = sum('orders');
    const prep = data.daily.filter((d) => d.avg_prep_minutes != null);
    const days = Array.from({ length: Math.max(range, 1) }, (_, i) => {
      const date = istDate(range - 1 - i);
      const row = data.daily.find((d) => d.business_date === date);
      return {
        date,
        label: new Date(`${date}T00:00:00`).toLocaleDateString('en-IN', { day: 'numeric', month: 'short' }),
        net: Number(row?.net_paise || 0),
        orders: Number(row?.orders || 0),
      };
    });
    const group = (rows, keyOf, nameOf) => {
      const m = new Map();
      for (const r of rows) {
        const k = keyOf(r);
        const cur = m.get(k) || { key: k, name: nameOf(r), qty: 0, revenue: 0 };
        cur.qty += Number(r.qty);
        cur.revenue += Number(r.revenue_paise);
        m.set(k, cur);
      }
      return [...m.values()].sort((a, b) => b.revenue - a.revenue);
    };
    const items = group(data.items, (r) => r.menu_item_id || r.item_name, (r) => r.item_name).slice(0, 10);
    const mods = group(data.mods, (r) => `${r.group_name}|${r.option_name}`, (r) => `${r.option_name} (${r.group_name})`)
      .filter((r) => r.revenue > 0)
      .slice(0, 8);
    return {
      orders,
      net: sum('net_paise'),
      gross: sum('gross_paise'),
      cgst: sum('cgst_paise'),
      sgst: sum('sgst_paise'),
      coinsIssued: sum('coins_issued'),
      coinsRedeemed: sum('coins_redeemed'),
      takeaway: sum('takeaway_orders'),
      avgTicket: orders ? Math.round(sum('net_paise') / orders) : 0,
      prep: prep.length ? (prep.reduce((s, d) => s + Number(d.avg_prep_minutes) * Number(d.orders), 0) / prep.reduce((s, d) => s + Number(d.orders), 0)).toFixed(1) : null,
      live: data.live.length,
      days,
      items,
      mods,
    };
  }, [data, range]);

  return (
    <>
      <PageTitle
        title="Sales"
        actions={
          <div className="inline-flex rounded-xl bg-white p-1 ring-1 ring-steel-200" role="group" aria-label="Date range">
            {RANGES.map((r) => (
              <button key={r.id} onClick={() => setRange(r.id)} aria-pressed={range === r.id} className={`rounded-lg px-3 py-1.5 text-sm font-semibold ${range === r.id ? 'bg-ink text-white' : 'text-ink-soft'}`}>
                {r.label}
              </button>
            ))}
          </div>
        }
      >
        Completed orders only, by business day in IST. Updates live as orders finish.
      </PageTitle>
      <ErrorNote onRetry={load}>{error}</ErrorNote>
      {!summary ? (
        <Spinner />
      ) : (
        <div className="space-y-6">
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <Tile label="Net sales" value={formatINR(summary.net)} detail={`${summary.orders} orders, ${formatINR(summary.avgTicket)} average`} />
            <Tile label="GST collected" value={formatINR(summary.cgst + summary.sgst)} detail={`CGST ${formatINR(summary.cgst)}, SGST ${formatINR(summary.sgst)}`} />
            <Tile label="Coins" value={`${summary.coinsIssued} earned`} detail={`${summary.coinsRedeemed} redeemed (${formatINR(summary.coinsRedeemed * 100)} discount)`} />
            <Tile
              label="Kitchen"
              value={summary.prep ? `${summary.prep} min` : 'No data'}
              detail={`Average prep time. ${summary.live} order${summary.live === 1 ? '' : 's'} in progress now.`}
            />
          </div>
          {range > 1 && <DailyColumns days={summary.days} />}
          <div className="grid gap-6 xl:grid-cols-2">
            <BarList
              title="Top items by revenue"
              rows={summary.items}
              valueOf={(r) => r.revenue}
              format={formatINR}
              detailOf={(r) => `${r.qty} sold`}
              empty="No completed orders in this period yet."
            />
            <BarList
              title="Paid add-ons by revenue"
              rows={summary.mods}
              valueOf={(r) => r.revenue}
              format={formatINR}
              detailOf={(r) => `${r.qty} added`}
              empty="No paid add-ons sold in this period yet."
            />
          </div>
          <p className="text-sm text-ink-soft">
            Takeaway made up {summary.orders ? Math.round((summary.takeaway / summary.orders) * 100) : 0}% of orders. Item revenue is before coins and GST.
          </p>
        </div>
      )}
    </>
  );
}
