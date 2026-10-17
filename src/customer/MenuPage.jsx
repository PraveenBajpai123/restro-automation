import { useEffect, useMemo, useRef, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { Search, ShoppingBag } from 'lucide-react';
import { useOutlet } from '../hooks/useOutlet';
import { useMenu } from '../hooks/useMenu';
import { useCustomer } from '../hooks/useCustomer';
import { useCart, cartCount } from '../stores/cart';
import { computeBill, formatINR } from '../lib/money';
import { OUTLET_SLUG } from '../lib/supabase';
import { unlockSound } from '../lib/sound';
import { CoinIcon, ErrorNote, Spinner } from '../components/ui';
import { recentOrders, rememberOrder } from '../hooks/useOrderTracking';
import { useOrderContext } from './useOrderContext';
import MenuItemRow from './MenuItemRow';
import ItemCustomizerSheet from './ItemCustomizerSheet';
import CartSheet from './CartSheet';
import CheckoutSheet from './CheckoutSheet';
import PhoneLoginSheet from './PhoneLoginSheet';
import { orderPayload, placeOrder, payWithRazorpay } from './payments';

export default function MenuPage() {
  const navigate = useNavigate();
  const { outlet, error: outletError, loading: outletLoading } = useOutlet();
  const context = useOrderContext(outlet);
  const { categories, index, loading, error: menuError, reload } = useMenu(outlet?.id);
  const customer = useCustomer();
  const cart = useCart();

  const [query, setQuery] = useState('');
  const [vegOnly, setVegOnly] = useState(false);
  const [activeCat, setActiveCat] = useState(null);
  const [customizing, setCustomizing] = useState(null);
  const [sheet, setSheet] = useState(null); // 'cart' | 'checkout' | 'login'
  const [returnTo, setReturnTo] = useState(null);
  const [notice, setNotice] = useState(null);
  const sectionRefs = useRef({});

  // Remember how the diner arrived (?table=5&k=…) so "Add more items" returns to the same table
  useEffect(() => {
    try { localStorage.setItem('last-menu-search', window.location.search); } catch { /* private mode */ }
  }, []);

  // Drop cart lines that became unavailable (staff 86'd them) and tell the diner
  useEffect(() => {
    if (!loading && index.items.size) {
      const removed = cart.prune(index);
      if (removed) setNotice(`${removed} item${removed > 1 ? 's were' : ' was'} removed from your order because it just sold out.`);
    }
  }, [index, loading]); // eslint-disable-line react-hooks/exhaustive-deps

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    return categories
      .map((c) => ({
        ...c,
        items: c.items.filter(
          (i) => (!vegOnly || i.is_veg) && (!q || i.name.toLowerCase().includes(q) || i.description?.toLowerCase().includes(q)),
        ),
      }))
      .filter((c) => c.items.length);
  }, [categories, query, vegOnly]);

  const wallet = customer.wallet;
  const bill = computeBill(cart.lines, outlet, {
    coinBalance: wallet?.coin_balance ?? 0,
    redeem: cart.redeemCoins,
    signedIn: customer.isPhoneUser && Boolean(wallet),
  });
  const previewEarn = computeBill(cart.lines, outlet, { signedIn: true }).earn;
  const count = cartCount(cart.lines);
  const qtyOf = (itemId) => cart.lines.filter((l) => l.itemId === itemId).reduce((s, l) => s + l.qty, 0);
  const active = recentOrders();

  const onAdd = (item) => {
    unlockSound();
    if (item.groups.length) setCustomizing(item);
    else cart.add(item, [], 1);
  };

  const openLogin = (from) => {
    setReturnTo(from);
    setSheet('login');
  };

  const handlePlace = async ({ paymentMethod, customerName }) => {
    unlockSound();
    const payload = orderPayload({
      outletSlug: OUTLET_SLUG, context, lines: cart.lines, paymentMethod,
      redeemCoins: cart.redeemCoins && bill.coins > 0, customerName, notes: cart.notes,
    });
    const result = await placeOrder(payload);
    rememberOrder(result.tracking_key, result.token_number);
    cart.clear();
    if (customer.isPhoneUser) customer.refreshWallet().catch(() => {});

    if (paymentMethod === 'razorpay') {
      try {
        await payWithRazorpay({
          trackingKey: result.tracking_key, outletName: outlet.name, token: result.token_number,
          phone: customer.session?.user?.phone, name: customerName,
        });
      } catch (e) {
        // Order exists; the status page offers "Pay now" again.
        navigate(`/o/${result.tracking_key}`, { state: { payError: e.message } });
        return;
      }
    }
    navigate(`/o/${result.tracking_key}`, { state: { justPlaced: true } });
  };

  const scrollTo = (id) => {
    setActiveCat(id);
    sectionRefs.current[id]?.scrollIntoView({ behavior: 'smooth', block: 'start' });
  };

  if (outletLoading) return <Spinner label="Loading menu" />;
  if (outletError) return <main className="mx-auto max-w-lg p-6"><ErrorNote>{outletError}</ErrorNote></main>;

  return (
    <div className="mx-auto min-h-dvh max-w-2xl pb-32">
      <header className="px-5 pb-4 pt-[max(1.25rem,env(safe-area-inset-top))]">
        <div className="flex items-start justify-between gap-3">
          <div className="flex items-center gap-3">
            {outlet.logo_url && <img src={outlet.logo_url} alt="" className="h-11 w-11 rounded-xl object-cover" />}
            <div>
              <h1 className="display text-[28px] font-extrabold leading-none">{outlet.name}</h1>
              {outlet.address && <p className="mt-1 text-sm text-ink-soft">{outlet.address}</p>}
            </div>
          </div>
          {customer.isPhoneUser && wallet && (
            <span className="flex flex-none items-center gap-1.5 rounded-full bg-white px-3 py-1.5 text-sm font-semibold shadow-sm ring-1 ring-steel-200" aria-label={`${wallet.coin_balance} coins`}>
              <CoinIcon /> <span className="num">{wallet.coin_balance}</span>
            </span>
          )}
        </div>

        <div className="mt-4 flex flex-wrap items-center gap-2">
          {context?.mode ? (
            <div className="inline-flex rounded-full bg-white p-1 text-sm font-semibold shadow-sm ring-1 ring-steel-200" role="group" aria-label="Order type">
              {context.canSwitch ? (
                ['dine_in', 'takeaway'].map((m) => (
                  <button
                    key={m}
                    onClick={() => context.setMode(m)}
                    aria-pressed={context.mode === m}
                    className={`rounded-full px-3.5 py-1.5 ${context.mode === m ? 'bg-ink text-white' : 'text-ink-soft'}`}
                  >
                    {m === 'dine_in' ? `Table ${context.table}` : 'Takeaway'}
                  </button>
                ))
              ) : (
                <span className="px-3.5 py-1.5">{context.label}</span>
              )}
            </div>
          ) : (
            <ErrorNote>Scan the QR code on your table to order.</ErrorNote>
          )}
          {!outlet.is_open && <span className="rounded-full bg-chilli-light px-3 py-1.5 text-sm font-semibold text-chilli">Not taking orders right now</span>}
        </div>

        {active.length > 0 && (
          <Link to={`/o/${active[0].key}`} className="mt-4 flex items-center justify-between rounded-2xl bg-ink px-4 py-3 text-white">
            <span>Track your order <span className="num font-bold">#{active[0].token}</span></span>
            <span className="text-sm text-steel-300">View status</span>
          </Link>
        )}
      </header>

      <div className="sticky top-0 z-30 border-b border-steel-200 bg-steel/95 backdrop-blur">
        <div className="flex items-center gap-2 px-5 pt-2">
          <label className="relative flex-1">
            <Search size={18} className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-steel-500" aria-hidden="true" />
            <input type="search" className="field py-2.5 pl-10" placeholder="Search the menu" value={query} onChange={(e) => setQuery(e.target.value)} aria-label="Search the menu" />
          </label>
          <button
            onClick={() => setVegOnly((v) => !v)}
            aria-pressed={vegOnly}
            className={`flex items-center gap-2 rounded-xl px-3 py-2.5 text-sm font-semibold ring-1 ${vegOnly ? 'bg-cardamom-light text-cardamom-dark ring-cardamom' : 'bg-white ring-steel-300'}`}
          >
            <span className="veg-mark text-cardamom" aria-hidden="true" /> Veg
          </button>
        </div>
        <nav className="flex gap-2 overflow-x-auto px-5 py-3 [scrollbar-width:none]" aria-label="Menu sections">
          {filtered.map((c) => (
            <button
              key={c.id}
              onClick={() => scrollTo(c.id)}
              className={`whitespace-nowrap rounded-full px-4 py-1.5 text-sm font-semibold ${activeCat === c.id ? 'bg-ink text-white' : 'bg-white text-ink ring-1 ring-steel-300'}`}
            >
              {c.name}
            </button>
          ))}
        </nav>
      </div>

      <main className="px-5">
        {notice && <div className="mt-4"><ErrorNote>{notice}</ErrorNote></div>}
        {menuError && <div className="mt-4"><ErrorNote onRetry={reload}>{menuError}</ErrorNote></div>}
        {loading ? (
          <Spinner label="Loading menu" />
        ) : filtered.length === 0 ? (
          <p className="py-16 text-center text-ink-soft">{query || vegOnly ? 'Nothing matches. Try another search.' : 'The menu is empty for now.'}</p>
        ) : (
          filtered.map((c) => (
            <section key={c.id} ref={(el) => (sectionRefs.current[c.id] = el)} className="scroll-mt-32 pt-6" aria-labelledby={`cat-${c.id}`}>
              <h2 id={`cat-${c.id}`} className="display text-2xl font-bold">{c.name}</h2>
              <div className="divide-y divide-steel-300/70">
                {c.items.map((item) => (
                  <MenuItemRow
                    key={item.id}
                    item={item}
                    inCartQty={qtyOf(item.id)}
                    onAdd={() => onAdd(item)}
                    onSetQty={(q) => {
                      const line = cart.lines.find((l) => l.itemId === item.id);
                      if (line) cart.setQty(line.key, q);
                    }}
                  />
                ))}
              </div>
            </section>
          ))
        )}
      </main>

      {count > 0 && !sheet && !customizing && (
        <div className="fixed inset-x-0 bottom-0 z-30 mx-auto max-w-2xl px-4 pb-[max(1rem,env(safe-area-inset-bottom))]">
          <button onClick={() => setSheet('cart')} className="flex w-full items-center justify-between rounded-2xl bg-cardamom px-5 py-4 text-white shadow-xl hover:bg-cardamom-dark">
            <span className="flex items-center gap-3">
              <ShoppingBag size={20} aria-hidden="true" />
              <span className="num font-semibold">{count} item{count > 1 ? 's' : ''}</span>
            </span>
            <span className="flex items-center gap-3 font-bold">
              <span className="num">{formatINR(bill.subtotal)}</span>
              <span>View order</span>
            </span>
          </button>
        </div>
      )}

      {customizing && (
        <ItemCustomizerSheet
          item={customizing}
          onClose={() => setCustomizing(null)}
          onAdd={(item, options, qty) => {
            cart.add(item, options, qty);
            setCustomizing(null);
          }}
        />
      )}
      <CartSheet
        open={sheet === 'cart'}
        onClose={() => setSheet(null)}
        cart={cart}
        bill={bill}
        previewEarn={previewEarn}
        outlet={outlet}
        customer={customer}
        context={context}
        onSignIn={() => openLogin('cart')}
        onCheckout={() => setSheet('checkout')}
      />
      <CheckoutSheet
        open={sheet === 'checkout'}
        onClose={() => setSheet('cart')}
        outlet={outlet}
        context={context}
        bill={bill}
        customer={customer}
        onSignIn={() => openLogin('checkout')}
        onPlace={handlePlace}
      />
      <PhoneLoginSheet
        open={sheet === 'login'}
        onClose={() => setSheet(returnTo)}
        customer={customer}
        onDone={() => setSheet(returnTo)}
      />
    </div>
  );
}
