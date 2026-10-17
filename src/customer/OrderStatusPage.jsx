import { useEffect, useState } from 'react';
import { Link, useLocation, useParams } from 'react-router-dom';
import { Check, FileDown } from 'lucide-react';
import { useOrderTracking } from '../hooks/useOrderTracking';
import { CUSTOMER_STEPS, customerStatusLabel, isFinal } from '../lib/orderStatus';
import { formatINR } from '../lib/money';
import { buildUpiLink, UPI_APPS, appLink } from '../lib/upi';
import { playSound, unlockSound } from '../lib/sound';
import { ErrorNote, Spinner, CoinIcon } from '../components/ui';
import BillSummary from './BillSummary';
import { payWithRazorpay } from './payments';

function Progress({ status, mode }) {
  const at = CUSTOMER_STEPS.indexOf(status === 'completed' ? 'ready' : status);
  return (
    <ol className="mt-8 grid grid-cols-3 gap-2" aria-label="Order progress">
      {CUSTOMER_STEPS.map((s, i) => {
        const done = at > i || status === 'completed';
        const current = at === i && status !== 'completed';
        return (
          <li key={s} className="flex flex-col gap-2" aria-current={current ? 'step' : undefined}>
            <span className={`h-1.5 rounded-full ${done || current ? 'bg-cardamom' : 'bg-steel-300'} ${current ? 'animate-pulse' : ''}`} />
            <span className={`text-sm ${current ? 'font-bold text-ink' : done ? 'text-ink' : 'text-steel-500'}`}>
              {done && <Check size={14} className="mr-1 inline text-cardamom" aria-hidden="true" />}
              {customerStatusLabel(s, mode)}
            </span>
          </li>
        );
      })}
    </ol>
  );
}

export default function OrderStatusPage() {
  const { trackingKey } = useParams();
  const { state } = useLocation();
  const [payError, setPayError] = useState(state?.payError || null);
  const [paying, setPaying] = useState(false);
  const { order, error, reload } = useOrderTracking(trackingKey, {
    onStatusChange: (s) => {
      if (s === 'ready') {
        playSound('customer');
        navigator.vibrate?.([200, 100, 200]);
      }
    },
  });

  useEffect(() => {
    const unlock = () => unlockSound();
    document.addEventListener('pointerdown', unlock, { once: true });
    return () => document.removeEventListener('pointerdown', unlock);
  }, []);

  if (error) return <main className="mx-auto max-w-lg p-6"><ErrorNote onRetry={reload}>{error}</ErrorNote></main>;
  if (!order) return <Spinner label="Loading your order" />;

  const ready = order.status === 'ready';
  const stopped = ['cancelled', 'rejected'].includes(order.status);
  const menuSearch = localStorage.getItem('last-menu-search') || '';

  const retryRazorpay = async () => {
    setPaying(true); setPayError(null);
    try {
      await payWithRazorpay({ trackingKey, outletName: order.outlet.name, token: order.token_number, name: order.customer_name });
      reload();
    } catch (e) {
      setPayError(e.message);
    } finally {
      setPaying(false);
    }
  };

  const upiLink =
    order.payment_method === 'upi_intent' && order.outlet.upi_vpa
      ? buildUpiLink({
          vpa: order.outlet.upi_vpa, payee: order.outlet.upi_payee_name, amountPaise: order.grand_total_paise,
          note: `Order ${order.token_number}`, ref: trackingKey.slice(0, 20),
        })
      : null;

  return (
    <div className="mx-auto min-h-dvh max-w-lg px-5 pb-16 pt-[max(1.5rem,env(safe-area-inset-top))]">
      <p className="text-ink-soft">{order.outlet.name}</p>

      <section className={`mt-4 rounded-[28px] px-6 pb-7 pt-6 ${stopped ? 'bg-chilli-light' : ready ? 'ready-pulse bg-haldi' : 'bg-white shadow-sm ring-1 ring-steel-200'}`}>
        <p className={`text-base font-semibold ${ready ? 'text-ink' : 'text-ink-soft'}`}>
          {order.mode === 'takeaway' ? 'Your pickup token' : `Table ${order.table}`}
        </p>
        <p className="display num token-in mt-1 text-[112px] font-extrabold leading-[0.85] text-ink" aria-label={`Token ${order.token_number}`}>
          {order.token_number}
        </p>
        <p className="mt-4 text-2xl font-bold" aria-live="polite">{customerStatusLabel(order.status, order.mode)}</p>
        {ready && order.mode === 'takeaway' && <p className="mt-1 text-ink">Show this number at the counter.</p>}
        {order.status === 'awaiting_approval' && order.payment_method === 'pay_at_counter' && (
          <p className="mt-1 text-ink-soft">Pay <span className="num font-semibold text-ink">{formatINR(order.grand_total_paise)}</span> at the counter and mention token {order.token_number}. We start cooking right after.</p>
        )}
        {stopped && <p className="mt-1 text-ink-soft">Any coins you used have been returned to your wallet. Please speak to the staff if you were charged.</p>}
        {!stopped && !order.status.startsWith('awaiting') && <Progress status={order.status} mode={order.mode} />}
      </section>

      {order.status === 'awaiting_payment' && order.payment_method === 'razorpay' && (
        <section className="mt-5 space-y-3">
          <ErrorNote>{payError}</ErrorNote>
          <button className="btn-primary w-full text-lg" onClick={retryRazorpay} disabled={paying}>
            {paying ? 'Opening payment…' : <>Pay <span className="num">{formatINR(order.grand_total_paise)}</span> now</>}
          </button>
          <p className="text-center text-sm text-ink-soft">Unpaid orders are cancelled after 15 minutes.</p>
        </section>
      )}

      {upiLink && order.status === 'awaiting_approval' && (
        <section className="mt-5 rounded-2xl bg-white p-5 ring-1 ring-steel-200">
          <h2 className="font-bold">Pay <span className="num">{formatINR(order.grand_total_paise)}</span> with UPI</h2>
          <p className="mt-1 text-sm text-ink-soft">To {order.outlet.upi_vpa}. After paying, show the payment screen at the counter so we can confirm it.</p>
          <div className="mt-4 grid grid-cols-3 gap-2">
            {UPI_APPS.map((app) => (
              <a key={app.id} href={appLink(app, upiLink)} className="btn-quiet px-2 py-3 text-sm">{app.name}</a>
            ))}
          </div>
          <a href={upiLink} className="btn-primary mt-2 w-full">Other UPI app</a>
        </section>
      )}

      {order.coins_earned > 0 && !stopped && (
        <p className="mt-5 flex items-center gap-2 rounded-2xl bg-haldi-light px-4 py-3 text-sm text-ink">
          <CoinIcon />
          {order.status === 'completed'
            ? <span><span className="font-semibold">{order.coins_earned} coins</span> added to your wallet.</span>
            : <span>You'll earn <span className="font-semibold">{order.coins_earned} coins</span> when this order is completed.</span>}
        </p>
      )}

      <section className="mt-6 rounded-2xl bg-white p-5 ring-1 ring-steel-200">
        <h2 className="mb-3 font-bold">Order details</h2>
        <ul className="mb-4 space-y-3">
          {order.items.map((it, i) => (
            <li key={i} className="flex justify-between gap-4 text-sm">
              <span>
                <span className="num font-semibold">{it.quantity} ×</span> {it.name}
                {it.modifiers.length > 0 && <span className="block text-ink-soft">{it.modifiers.join(', ')}</span>}
              </span>
              <span className="num">{formatINR(it.line_total_paise)}</span>
            </li>
          ))}
        </ul>
        <BillSummary order={order} />
        {order.payment_status === 'paid' && (
          <button className="btn-quiet mt-4 w-full" onClick={() => import('../lib/invoice').then((m) => m.downloadInvoice(order))}>
            <FileDown size={18} aria-hidden="true" /> Download GST invoice
          </button>
        )}
      </section>

      <Link to={`/menu${menuSearch}`} className="btn-quiet mt-6 w-full">
        {isFinal(order.status) ? 'Order again' : 'Add more items'}
      </Link>
    </div>
  );
}
