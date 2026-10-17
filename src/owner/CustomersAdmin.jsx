import { useState } from 'react';
import { staffDb as db, must } from '../lib/supabase';
import { formatINR } from '../lib/money';
import { ErrorNote, Sheet, Spinner, CoinIcon } from '../components/ui';
import { PageTitle } from './OwnerLayout';
import { useOutletQuery } from './useOutletData';

const ENTRY_LABEL = { earn: 'Earned', burn: 'Redeemed', reversal: 'Returned', adjustment: 'Adjusted', expiry: 'Expired' };

function CustomerSheet({ customer, onClose, onChanged }) {
  const ledger = useOutletQuery(
    (db) => db.from('loyalty_ledger').select('*').eq('customer_id', customer.id).order('created_at', { ascending: false }).limit(50),
    [customer.id],
  );
  const [coins, setCoins] = useState('');
  const [note, setNote] = useState('');
  const [error, setError] = useState(null);

  const adjust = async (e) => {
    e.preventDefault();
    try {
      must(await db.rpc('adjust_customer_coins', { p_customer: customer.id, p_coins: parseInt(coins, 10), p_note: note }));
      setCoins(''); setNote('');
      ledger.reload(); onChanged();
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <Sheet open onClose={onClose} title={customer.name || customer.phone}>
      <p className="text-ink-soft">{customer.phone}. {customer.total_orders} orders, {formatINR(customer.total_spent_paise)} spent.</p>
      <p className="mt-3 flex items-center gap-2 text-2xl font-bold"><CoinIcon size={22} /> <span className="num">{customer.coin_balance}</span> coins</p>

      <form onSubmit={adjust} className="mt-5 rounded-2xl bg-steel-100 p-4">
        <h3 className="font-bold">Add or remove coins</h3>
        <div className="mt-3 flex gap-2">
          <input className="field num w-28" inputMode="numeric" placeholder="+50 or -20" value={coins} onChange={(e) => setCoins(e.target.value)} aria-label="Coins" />
          <input className="field" placeholder="Reason, e.g. Late order apology" value={note} onChange={(e) => setNote(e.target.value)} aria-label="Reason" />
        </div>
        <ErrorNote>{error}</ErrorNote>
        <button className="btn-primary mt-3 w-full" disabled={!parseInt(coins, 10) || !note.trim()}>Save adjustment</button>
      </form>

      <h3 className="mb-2 mt-6 font-bold">Wallet history</h3>
      {!ledger.rows ? <Spinner /> : ledger.rows.length === 0 ? <p className="text-sm text-ink-soft">No coin activity yet.</p> : (
        <ul className="divide-y divide-steel-200 text-sm">
          {ledger.rows.map((l) => (
            <li key={l.id} className="flex justify-between gap-3 py-2">
              <span>
                <span className="font-semibold">{ENTRY_LABEL[l.entry_type]}</span> {l.note && <span className="text-ink-soft">{l.note}</span>}
                <span className="block text-xs text-ink-soft">{new Date(l.created_at).toLocaleString('en-IN', { dateStyle: 'medium', timeStyle: 'short' })}</span>
              </span>
              <span className={`num font-semibold ${l.coins > 0 ? 'text-cardamom' : 'text-ink'}`}>{l.coins > 0 ? '+' : ''}{l.coins}</span>
            </li>
          ))}
        </ul>
      )}
    </Sheet>
  );
}

export default function CustomersAdmin() {
  const [search, setSearch] = useState('');
  const customers = useOutletQuery((db) => {
    let q = db.from('customers').select('*').order('total_spent_paise', { ascending: false }).limit(100);
    const s = search.replace(/[^\d]/g, '');
    if (s.length >= 3) q = q.like('phone', `%${s}%`);
    else if (search.trim()) q = q.ilike('name', `%${search.trim()}%`);
    return q;
  }, [search]);
  const [open, setOpen] = useState(null);

  return (
    <>
      <PageTitle title="Customers">Everyone who signed in with their phone. Coins are shared across all your outlets.</PageTitle>
      <input className="field mb-4 max-w-sm" type="search" placeholder="Search by phone or name" value={search} onChange={(e) => setSearch(e.target.value)} aria-label="Search customers" />
      <ErrorNote>{customers.error}</ErrorNote>
      {!customers.rows ? <Spinner /> : customers.rows.length === 0 ? (
        <p className="rounded-2xl bg-white p-6 text-ink-soft ring-1 ring-steel-200">No customers yet. They appear here after their first phone sign-in at checkout.</p>
      ) : (
        <div className="overflow-x-auto rounded-2xl bg-white ring-1 ring-steel-200">
          <table className="w-full text-sm">
            <thead className="bg-steel-100 text-left text-ink-soft">
              <tr><th className="px-4 py-2.5 font-medium">Customer</th><th className="px-4 py-2.5 text-right font-medium">Orders</th><th className="px-4 py-2.5 text-right font-medium">Spent</th><th className="px-4 py-2.5 text-right font-medium">Coins</th><th className="px-4 py-2.5 font-medium">Last order</th></tr>
            </thead>
            <tbody>
              {customers.rows.map((c) => (
                <tr key={c.id} className="cursor-pointer border-t border-steel-200 hover:bg-steel-100" onClick={() => setOpen(c)}>
                  <td className="px-4 py-2.5"><button className="text-left" onClick={() => setOpen(c)}><span className="font-semibold">{c.name || 'No name'}</span><span className="block text-ink-soft">{c.phone}</span></button></td>
                  <td className="num px-4 py-2.5 text-right">{c.total_orders}</td>
                  <td className="num px-4 py-2.5 text-right">{formatINR(c.total_spent_paise)}</td>
                  <td className="num px-4 py-2.5 text-right">{c.coin_balance}</td>
                  <td className="px-4 py-2.5 text-ink-soft">{c.last_order_at ? new Date(c.last_order_at).toLocaleDateString('en-IN') : 'None yet'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
      {open && <CustomerSheet customer={open} onClose={() => setOpen(null)} onChanged={customers.reload} />}
    </>
  );
}
