import { useEffect, useMemo, useRef, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { ChevronDown, Search, ShoppingBag } from 'lucide-react';
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
import MenuItemRow, { fromPrice } from './MenuItemRow';
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
  const [openCats, setOpenCats] = useState(() => new Set());
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

  const searching = Boolean(query.trim()) || vegOnly;
  const isOpen = (id) => searching || openCats.has(id);
  const toggleCat = (id) =>
    setOpenCats((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });

  // First section starts open, like a printed menu's first page
  useEffect(() => {
    if (categories.length && openCats.size === 0) setOpenCats(new Set([categories[0].id]));
  }, [categories]); // eslint-disable-line react-hooks/exhaustive-deps

  const scrollTo = (id) => {
    setActiveCat(id);
    setOpenCats((prev) => new Set(prev).add(id));
    requestAnimationFrame(() => sectionRefs.current[id]?.scrollIntoView({ behavior: 'smooth', block: 'start' }));
  };

  const hasNonVeg = categories.some((c) => c.items.some((i) => i.is_veg === false));
  const picks = categories.flatMap((c) => c.items).filter((i) => i.is_bestseller && i.is_available).slice(0, 10);
  const thumbOf = (c) => c.items.find((i) => i.image_url)?.image_url;

  if (outletLoading) return <Spinner label="Loading menu" />;
  if (outletError) return <main className="mx-auto max-w-lg p-6"><ErrorNote>{outletError}</ErrorNote></main>;

  return (
    <div className="mx-auto min-h-dvh max-w-2xl pb-32">
      <header className="relative h-56 overflow-hidden bg-gradient-to-br from-cardamom via-ink-700 to-ink-900 text-white">
        {outlet.cover_url && <img src={outlet.cover_url} alt="" className="absolute inset-0 h-full w-full object-cover" />}
        <div className="absolute inset-0 bg-gradient-to-b from-ink-900/20 via-ink-900/35 to-ink-900/70" aria-hidden="true" />
        <div className="relative flex h-full flex-col items-center justify-center px-6 pb-6 pt-[env(safe-area-inset-top)] text-center">
          {outlet.logo_url && <img src={outlet.logo_url} alt="" className="mb-3 h-14 w-14 rounded-2xl object-cover shadow-lg" />}
          <h1 className="font-serif text-[30px] font-semibold uppercase leading-tight tracking-[0.1em] [text-shadow:0_2px_12px_rgba(0,0,0,.35)]">{outlet.name}</h1>
          {outlet.address && <p className="mt-1.5 text-sm text-white/85">{outlet.address}</p>}
        </div>
        {customer.isPhoneUser && wallet && (
          <span className="absolute right-4 top-[max(1rem,env(safe-area-inset-top))] flex items-center gap-1.5 rounded-full bg-white/95 px-3 py-1.5 text-sm font-semibold text-ink shadow" aria-label={`${wallet.coin_balance} coins`}>
            <CoinIcon /> <span className="num">{wallet.coin_balance}</span>
          </span>
        )}
      </header>

      <div className="relative -mt-6 rounded-t-[28px] bg-steel px-5 pt-5">
        <div className="flex flex-wrap items-center justify-center gap-2">
          {context?.mode ? (
            <div className="inline-flex rounded-full bg-ink/[0.06] p-1 text-sm font-semibold ring-1 ring-ink/10" role="group" aria-label="Order type">
              {context.canSwitch ? (
                ['dine_in', 'takeaway'].map((m) => (
                  <button
                    key={m}
                    onClick={() => context.setMode(m)}
                    aria-pressed={context.mode === m}
                    className={`rounded-full px-4 py-1.5 ${context.mode === m ? 'bg-cardamom text-white shadow-sm' : 'text-ink-soft'}`}
                  >
                    {m === 'dine_in' ? `Table ${context.table}` : 'Takeaway'}
                  </button>
                ))
              ) : (
                <span className="px-4 py-1.5">{context.label}</span>
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
      </div>

      <div className="sticky top-0 z-30 bg-steel/95 pt-3 backdrop-blur">
        <div className="flex items-center gap-2 px-5">
          <label className="relative flex-1">
            <Search size={18} className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-steel-500" aria-hidden="true" />
            <input type="search" className="field rounded-full border-ink/10 bg-white/80 py-2.5 pl-10" placeholder="Search the menu" value={query} onChange={(e) => setQuery(e.target.value)} aria-label="Search the menu" />
          </label>
          {hasNonVeg && (
            <button
              onClick={() => setVegOnly((v) => !v)}
              aria-pressed={vegOnly}
              className={`flex items-center gap-2 rounded-full px-3.5 py-2.5 text-sm font-semibold ring-1 ${vegOnly ? 'bg-cardamom text-white ring-cardamom' : 'bg-white/80 ring-ink/10'}`}
            >
              <span className="veg-mark text-veg" aria-hidden="true" /> Veg
            </button>
          )}
        </div>
        <nav className="flex gap-2 overflow-x-auto px-5 py-3 [scrollbar-width:none]" aria-label="Menu sections">
          {filtered.map((c) => {
            const on = activeCat === c.id;
            const thumb = thumbOf(c);
            return (
              <button
                key={c.id}
                onClick={() => scrollTo(c.id)}
                aria-current={on ? 'true' : undefined}
                className={`flex flex-none items-center gap-2 whitespace-nowrap rounded-full border py-1 text-sm ${thumb ? 'pl-1 pr-4' : 'px-4 py-1.5'} ${on ? 'border-cardamom bg-cardamom font-semibold text-white' : 'border-ink/10 bg-ink/[0.08] text-ink'}`}
              >
                {thumb && <img src={thumb} alt="" className="h-8 w-8 rounded-full object-cover" />}
                {c.name}
              </button>
            );
          })}
        </nav>
      </div>

      <main className="px-5">
        {notice && <div className="mt-2"><ErrorNote>{notice}</ErrorNote></div>}
        {menuError && <div className="mt-2"><ErrorNote onRetry={reload}>{menuError}</ErrorNote></div>}

        {!searching && picks.length > 0 && (
          <section className="pt-4" aria-labelledby="picks">
            <h2 id="picks" className="text-center font-serif text-[19px] font-semibold">Chef's Picks</h2>
            <p className="mt-0.5 text-center text-[13px] text-ink-soft">Our signature dishes, made to perfection</p>
            <ul className="-mx-5 mt-4 flex gap-3 overflow-x-auto px-5 pb-1 [scrollbar-width:none]">
              {picks.map((i) => (
                <li key={i.id} className="w-36 flex-none">
                  <button onClick={() => onAdd(i)} className="block w-full text-center" aria-label={`Add ${i.name}`}>
                    {i.image_url ? (
                      <img src={i.image_url} alt="" loading="lazy" className="aspect-square w-full rounded-2xl bg-steel-200 object-cover" />
                    ) : (
                      <span className="grid aspect-square w-full place-items-center rounded-2xl bg-gradient-to-br from-cardamom-light to-steel-200 font-serif text-4xl font-semibold text-cardamom" aria-hidden="true">
                        {i.name.charAt(0)}
                      </span>
                    )}
                    <span className="mt-2 block truncate text-[13px] font-medium">{i.name}</span>
                    <span className="num block font-serif text-[17px] font-semibold">{formatINR(fromPrice(i))}</span>
                  </button>
                </li>
              ))}
            </ul>
          </section>
        )}

        {loading ? (
          <Spinner label="Loading menu" />
        ) : filtered.length === 0 ? (
          <p className="py-16 text-center text-ink-soft">{searching ? 'Nothing matches. Try another search.' : 'The menu is empty for now.'}</p>
        ) : (
          <div className="mt-5 space-y-3">
            {filtered.map((c) => {
              const open = isOpen(c.id);
              const thumb = thumbOf(c);
              return (
                <section
                  key={c.id}
                  ref={(el) => (sectionRefs.current[c.id] = el)}
                  className="scroll-mt-32 rounded-[14px] border border-ink/10 bg-white/40"
                >
                  <h2>
                    <button
                      onClick={() => toggleCat(c.id)}
                      aria-expanded={open}
                      aria-controls={`cat-${c.id}`}
                      className="flex w-full items-center gap-3 px-4 py-3.5 text-left"
                    >
                      {thumb && <img src={thumb} alt="" className="h-10 w-10 flex-none rounded-lg object-cover" />}
                      <span className="flex-1 font-serif text-[18px] font-semibold text-cardamom">{c.name}</span>
                      <span className="num text-xs text-ink-soft">{c.items.length}</span>
                      <ChevronDown size={18} className={`text-ink-soft transition-transform ${open ? 'rotate-180' : ''}`} aria-hidden="true" />
                    </button>
                  </h2>
                  {open && (
                    <ul id={`cat-${c.id}`} className="divide-y divide-ink/[0.07] px-4 pb-1">
                      {c.items.map((item) => (
                        <MenuItemRow
                          key={item.id}
                          item={item}
                          showVeg={hasNonVeg}
                          inCartQty={qtyOf(item.id)}
                          onAdd={() => onAdd(item)}
                          onSetQty={(q) => {
                            const line = cart.lines.find((l) => l.itemId === item.id);
                            if (line) cart.setQty(line.key, q);
                          }}
                        />
                      ))}
                    </ul>
                  )}
                </section>
              );
            })}
          </div>
        )}

        <footer className="mt-10 text-center">
          <p className="font-serif text-lg font-semibold uppercase tracking-[0.12em]">{outlet.name}</p>
          {outlet.loyalty_enabled && <p className="mt-1 text-xs text-ink-soft">Earn coins on every order. 1 coin = ₹1 off your next visit.</p>}
        </footer>
      </main>

      {count > 0 && !sheet && !customizing && (
        <div className="fixed inset-x-0 bottom-0 z-30 mx-auto max-w-2xl px-4 pb-[max(1rem,env(safe-area-inset-bottom))]">
          <button onClick={() => setSheet('cart')} className="flex w-full items-center justify-between rounded-full bg-cardamom px-6 py-4 text-white shadow-xl shadow-ink/20 hover:bg-cardamom-dark">
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
