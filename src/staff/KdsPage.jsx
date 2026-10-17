import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { Link } from 'react-router-dom';
import { Printer, Volume2, VolumeX, PackageX, LogOut, LayoutDashboard } from 'lucide-react';
import { staffDb as db, must } from '../lib/supabase';
import { useStaff, can } from '../hooks/useStaff';
import { useMenu } from '../hooks/useMenu';
import { playSound, unlockSound } from '../lib/sound';
import { formatINR } from '../lib/money';
import { paymentLabel } from '../lib/orderStatus';
import { ErrorNote, Sheet } from '../components/ui';
import { KitchenTicket, CustomerReceipt } from './PrintSlips';

const ACTIVE = ['awaiting_approval', 'placed', 'preparing', 'ready'];
const ORDER_SELECT = `*, dining_tables(label),
  order_items(id, item_name, quantity, notes, line_total_paise, created_at, order_item_modifiers(id, group_name, option_name)),
  payments(method, status, upi_ref)`;

function useNow(ms = 15000) {
  const [now, setNow] = useState(Date.now());
  useEffect(() => {
    const t = setInterval(() => setNow(Date.now()), ms);
    return () => clearInterval(t);
  }, [ms]);
  return now;
}

function Elapsed({ since, now }) {
  const mins = Math.max(0, Math.floor((now - new Date(since).getTime()) / 60000));
  const tone = mins >= 15 ? 'bg-chilli text-white' : mins >= 8 ? 'bg-haldi text-ink' : 'bg-ink-700 text-steel-200';
  return <span className={`num rounded-lg px-2 py-0.5 text-sm font-bold ${tone}`} title="Minutes since the order reached the kitchen">{mins} min</span>;
}

function OrderCard({ order, now, profile, onAction, onPrint, busy }) {
  const [utr, setUtr] = useState('');
  const approving = order.status === 'awaiting_approval';
  const isCounterRole = can(profile, ['owner', 'manager', 'cashier']);
  const sortedItems = [...order.order_items].sort((a, b) => a.created_at.localeCompare(b.created_at));

  return (
    <article className={`rounded-2xl bg-ink-800 p-4 ring-1 ${approving ? 'ring-haldi' : order.status === 'ready' ? 'ring-cardamom' : 'ring-ink-700'}`}>
      <header className="flex items-start justify-between gap-2">
        <div>
          <p className="display num text-4xl font-extrabold leading-none text-white">#{order.token_number}</p>
          <p className="mt-1 text-sm font-semibold text-steel-200">
            {order.mode === 'dine_in' ? `Table ${order.dining_tables?.label}` : 'Takeaway'}
            {order.customer_name && <span className="font-normal text-steel-500"> for {order.customer_name}</span>}
          </p>
        </div>
        <Elapsed since={order.placed_at || order.created_at} now={now} />
      </header>

      <ul className="mt-3 space-y-2 border-t border-ink-700 pt-3">
        {sortedItems.map((it) => (
          <li key={it.id} className="text-steel-100">
            <span className="num mr-2 inline-block min-w-[2ch] rounded bg-ink-700 px-1.5 text-center font-bold text-white">{it.quantity}</span>
            <span className="font-semibold">{it.item_name}</span>
            {it.order_item_modifiers.length > 0 && (
              <span className="mt-0.5 block pl-9 text-sm text-haldi">{it.order_item_modifiers.map((m) => m.option_name).join(', ')}</span>
            )}
            {it.notes && <span className="block pl-9 text-sm italic text-steel-300">{it.notes}</span>}
          </li>
        ))}
      </ul>
      {order.notes && <p className="mt-3 rounded-lg bg-haldi/15 px-3 py-2 text-sm text-haldi">Note: {order.notes}</p>}

      {approving && (
        <div className="mt-4 rounded-xl bg-ink-900 p-3">
          <p className="text-sm text-steel-200">
            Collect <span className="num text-lg font-bold text-white">{formatINR(order.grand_total_paise)}</span> by {paymentLabel(order.payment_method).toLowerCase()}
          </p>
          {order.payment_method === 'upi_intent' && isCounterRole && (
            <input
              className="field mt-2 bg-ink-800 py-2 text-sm text-white placeholder:text-steel-500"
              placeholder="UPI reference (UTR), optional"
              value={utr}
              onChange={(e) => setUtr(e.target.value)}
              aria-label="UPI reference number"
            />
          )}
        </div>
      )}

      <div className="mt-4 flex gap-2">
        {approving ? (
          isCounterRole ? (
            <>
              <button className="btn-primary flex-1 py-2.5" disabled={busy} onClick={() => onAction(order, 'placed', { upi: utr })}>Paid, send to kitchen</button>
              <button className="btn rounded-xl bg-ink-700 px-3 py-2.5 text-steel-100 hover:bg-ink-900" disabled={busy} onClick={() => onAction(order, 'rejected')}>Reject</button>
            </>
          ) : (
            <p className="text-sm text-steel-500">Waiting for the counter to confirm payment</p>
          )
        ) : order.status === 'placed' ? (
          <button className="btn flex-1 bg-haldi py-2.5 text-ink hover:brightness-95" disabled={busy} onClick={() => onAction(order, 'preparing', { print: true })}>
            <Printer size={18} aria-hidden="true" /> Print and start
          </button>
        ) : order.status === 'preparing' ? (
          <button className="btn-primary flex-1 py-2.5" disabled={busy} onClick={() => onAction(order, 'ready')}>Mark ready</button>
        ) : (
          <button className="btn-primary flex-1 py-2.5" disabled={busy} onClick={() => onAction(order, 'completed')}>
            {order.mode === 'takeaway' ? 'Picked up' : 'Served'}
          </button>
        )}
        {!approving && (
          <button className="btn rounded-xl bg-ink-700 px-3 text-steel-100 hover:bg-ink-900" onClick={() => onPrint(order, 'ticket')} aria-label="Reprint kitchen ticket" title="Reprint kitchen ticket">
            <Printer size={18} />
          </button>
        )}
      </div>
      {!approving && (
        <div className="mt-2 flex justify-between text-xs text-steel-500">
          <button className="hover:text-steel-200" onClick={() => onPrint(order, 'receipt')}>Print bill</button>
          {can(profile, ['owner', 'manager']) && order.status !== 'completed' && (
            <button className="hover:text-chilli" onClick={() => onAction(order, 'cancelled')}>Cancel order</button>
          )}
        </div>
      )}
    </article>
  );
}

function StockSheet({ open, onClose, outletId }) {
  const { categories, reload } = useMenu(open ? outletId : null, db);
  const [error, setError] = useState(null);
  const toggle = async (fn, args) => {
    try {
      must(await db.rpc(fn, args));
      reload();
    } catch (e) {
      setError(e.message);
    }
  };
  return (
    <Sheet open={open} onClose={onClose} title="Out of stock">
      <p className="mb-3 text-sm text-ink-soft">Switch off anything you've run out of. It disappears from the menu right away.</p>
      <ErrorNote>{error}</ErrorNote>
      {categories.map((c) => (
        <section key={c.id} className="mb-5">
          <h3 className="mb-1 font-bold">{c.name}</h3>
          {c.items.map((i) => (
            <div key={i.id} className="border-b border-steel-200 py-2">
              <label className="flex items-center justify-between gap-3">
                <span className={i.is_available ? '' : 'text-ink-soft line-through'}>{i.name}</span>
                <input type="checkbox" className="h-5 w-5 accent-cardamom" checked={i.is_available} onChange={(e) => toggle('set_item_availability', { p_item: i.id, p_available: e.target.checked })} />
              </label>
            </div>
          ))}
        </section>
      ))}
      {categories.length > 0 && (
        <section className="mb-4">
          <h3 className="mb-1 font-bold">Add-ons and options</h3>
          {[...new Map(categories.flatMap((c) => c.items.flatMap((i) => i.groups.flatMap((g) => g.options.map((o) => [o.id, { ...o, group: g.name }]))))).values()].map((o) => (
            <label key={o.id} className="flex items-center justify-between gap-3 border-b border-steel-200 py-2">
              <span className={o.is_available ? '' : 'text-ink-soft line-through'}>{o.name} <span className="text-sm text-ink-soft">({o.group})</span></span>
              <input type="checkbox" className="h-5 w-5 accent-cardamom" checked={o.is_available} onChange={(e) => toggle('set_option_availability', { p_option: o.id, p_available: e.target.checked })} />
            </label>
          ))}
        </section>
      )}
    </Sheet>
  );
}

export default function KdsPage() {
  const { profile, signOut } = useStaff();
  const [orders, setOrders] = useState([]);
  const [outlet, setOutlet] = useState(null);
  const [live, setLive] = useState('connecting');
  const [error, setError] = useState(null);
  const [busyId, setBusyId] = useState(null);
  const [sound, setSound] = useState(true);
  const [stockOpen, setStockOpen] = useState(false);
  const [printJob, setPrintJob] = useState(null);
  const soundRef = useRef(sound);
  soundRef.current = sound;
  const now = useNow();

  const outletId = profile.outlet_id;

  const loadAll = useCallback(async () => {
    try {
      const rows = must(await db.from('orders').select(ORDER_SELECT).eq('outlet_id', outletId).in('status', ACTIVE).order('created_at'));
      setOrders(rows);
      setError(null);
    } catch (e) {
      setError(e.message);
    }
  }, [outletId]);

  const loadOne = useCallback(async (id, eventType, newStatus) => {
    const { data } = await db.from('orders').select(ORDER_SELECT).eq('id', id).maybeSingle();
    setOrders((prev) => {
      const rest = prev.filter((o) => o.id !== id);
      return data && ACTIVE.includes(data.status) ? [...rest, data].sort((a, b) => a.created_at.localeCompare(b.created_at)) : rest;
    });
    const arrived = (eventType === 'INSERT' && newStatus === 'awaiting_approval') || (eventType === 'UPDATE' && newStatus === 'placed');
    if (arrived && soundRef.current) playSound('staff');
  }, []);

  useEffect(() => {
    db.from('outlets').select('*').eq('id', outletId).single().then(({ data }) => setOutlet(data));
    loadAll();
    const channel = db
      .channel(`kds-${outletId}`)
      .on('postgres_changes', { event: '*', schema: 'public', table: 'orders', filter: `outlet_id=eq.${outletId}` }, (payload) => {
        // place_order writes the order and its items in one transaction, so re-reading by id returns the full ticket
        loadOne(payload.new.id, payload.eventType, payload.new.status);
      })
      .subscribe((status) => {
        setLive(status === 'SUBSCRIBED' ? 'live' : status === 'CLOSED' || status === 'CHANNEL_ERROR' ? 'offline' : 'connecting');
        if (status === 'SUBSCRIBED') loadAll(); // catch up on anything missed while disconnected
      });
    return () => { db.removeChannel(channel); };
  }, [outletId, loadAll, loadOne]);

  // Print through a hidden 58 mm area, then clear it
  useEffect(() => {
    if (!printJob) return;
    const t = setTimeout(() => {
      window.print();
      setPrintJob(null);
    }, 50);
    return () => clearTimeout(t);
  }, [printJob]);

  const act = async (order, to, { print, upi } = {}) => {
    let note = null;
    if (to === 'rejected' || to === 'cancelled') {
      note = window.prompt(to === 'rejected' ? 'Why are you rejecting this order? The customer will see it is not accepted.' : 'Reason for cancelling?');
      if (note === null) return;
    }
    setBusyId(order.id);
    try {
      must(await db.rpc('set_order_status', { p_order: order.id, p_to: to, p_note: note || null, p_upi_ref: upi || null }));
      if (print) setPrintJob({ kind: 'ticket', order });
      loadOne(order.id);
    } catch (e) {
      setError(e.message);
    } finally {
      setBusyId(null);
    }
  };

  const columns = useMemo(() => {
    const by = (s) => orders.filter((o) => o.status === s);
    const cols = [
      { id: 'placed', title: 'New', items: by('placed') },
      { id: 'preparing', title: 'Preparing', items: by('preparing') },
      { id: 'ready', title: 'Ready', items: by('ready') },
    ];
    const approvals = by('awaiting_approval');
    if (approvals.length || can(profile, ['owner', 'manager', 'cashier'])) cols.unshift({ id: 'awaiting_approval', title: 'Needs payment', items: approvals });
    return cols;
  }, [orders, profile]);

  return (
    <div className="min-h-dvh bg-ink-900 text-steel-100" onPointerDown={unlockSound}>
      <header className="flex flex-wrap items-center justify-between gap-3 border-b border-ink-700 px-5 py-3">
        <div className="flex items-center gap-3">
          <h1 className="display text-2xl font-extrabold text-white">{outlet?.name || 'Kitchen'}</h1>
          <span className={`flex items-center gap-1.5 rounded-full px-2.5 py-1 text-xs font-semibold ${live === 'live' ? 'bg-cardamom/25 text-cardamom-light' : 'bg-chilli/25 text-chilli-light'}`}>
            <span className={`h-2 w-2 rounded-full ${live === 'live' ? 'bg-cardamom-light' : 'bg-chilli animate-pulse'}`} />
            {live === 'live' ? 'Live' : live === 'offline' ? 'Offline, retrying' : 'Connecting'}
          </span>
        </div>
        <div className="flex items-center gap-2 text-sm">
          <button className="btn rounded-xl bg-ink-800 px-3 py-2 text-steel-100 hover:bg-ink-700" onClick={() => setStockOpen(true)}>
            <PackageX size={16} aria-hidden="true" /> Out of stock
          </button>
          <button className="btn rounded-xl bg-ink-800 px-3 py-2 text-steel-100 hover:bg-ink-700" onClick={() => setSound((s) => !s)} aria-pressed={sound} aria-label="New order sound">
            {sound ? <Volume2 size={16} /> : <VolumeX size={16} />}
          </button>
          {can(profile, ['owner', 'manager']) && (
            <Link to="/owner" className="btn rounded-xl bg-ink-800 px-3 py-2 text-steel-100 hover:bg-ink-700">
              <LayoutDashboard size={16} aria-hidden="true" /> Owner
            </Link>
          )}
          <button className="btn rounded-xl bg-ink-800 px-3 py-2 text-steel-100 hover:bg-ink-700" onClick={signOut} aria-label="Sign out" title={`Signed in as ${profile.display_name}`}>
            <LogOut size={16} />
          </button>
        </div>
      </header>

      {error && <div className="px-5 pt-3"><ErrorNote onRetry={loadAll}>{error}</ErrorNote></div>}

      <main className={`grid gap-4 p-4 md:grid-cols-2 ${columns.length === 4 ? 'xl:grid-cols-4' : 'xl:grid-cols-3'}`}>
        {columns.map((col) => (
          <section key={col.id} aria-labelledby={`col-${col.id}`} className="min-w-0">
            <h2 id={`col-${col.id}`} className="mb-3 flex items-baseline justify-between px-1">
              <span className={`text-lg font-bold ${col.id === 'awaiting_approval' && col.items.length ? 'text-haldi' : 'text-white'}`}>{col.title}</span>
              <span className="num text-steel-500">{col.items.length}</span>
            </h2>
            <div className="space-y-3">
              {col.items.length === 0 && <p className="rounded-2xl border border-dashed border-ink-700 px-4 py-8 text-center text-sm text-steel-500">Nothing here</p>}
              {col.items.map((o) => (
                <OrderCard key={o.id} order={o} now={now} profile={profile} busy={busyId === o.id} onAction={act} onPrint={(order, kind) => setPrintJob({ kind, order })} />
              ))}
            </div>
          </section>
        ))}
      </main>

      <StockSheet open={stockOpen} onClose={() => setStockOpen(false)} outletId={outletId} />

      {printJob && outlet && (
        <div className="print-area" aria-hidden="true">
          {printJob.kind === 'ticket' ? <KitchenTicket order={printJob.order} outletName={outlet.name} /> : <CustomerReceipt order={printJob.order} outlet={outlet} />}
        </div>
      )}
    </div>
  );
}
