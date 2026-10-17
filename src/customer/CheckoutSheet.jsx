import { useEffect, useMemo, useState } from 'react';
import { Check, CreditCard, Smartphone, Store } from 'lucide-react';
import { Sheet, ErrorNote, CoinIcon } from '../components/ui';
import { formatINR } from '../lib/money';

export function availableMethods(outlet) {
  const m = [];
  if (outlet?.razorpay_enabled)
    m.push({ id: 'razorpay', title: 'Pay online', detail: 'UPI, cards, netbanking. Confirmed instantly.', Icon: CreditCard });
  if (outlet?.upi_intent_enabled && outlet?.upi_vpa)
    m.push({ id: 'upi_intent', title: 'Pay with a UPI app', detail: 'GPay, PhonePe, Paytm. The counter confirms your payment.', Icon: Smartphone });
  if (outlet?.pay_at_counter_enabled)
    m.push({ id: 'pay_at_counter', title: 'Pay at the counter', detail: 'Cash or card. We start cooking once you have paid.', Icon: Store });
  return m;
}

export default function CheckoutSheet({ open, onClose, outlet, context, bill, customer, onSignIn, onPlace, placed }) {
  const methods = useMemo(() => availableMethods(outlet), [outlet]);
  const [method, setMethod] = useState(methods[0]?.id);
  const [name, setName] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (open) {
      setError(null);
      if (!methods.some((m) => m.id === method)) setMethod(methods[0]?.id);
      if (!name && customer.wallet?.name) setName(customer.wallet.name);
    }
  }, [open, methods, method, name, customer.wallet]);

  const submit = async () => {
    setBusy(true);
    setError(null);
    try {
      await onPlace({ paymentMethod: method, customerName: name.trim() });
    } catch (e) {
      setError(e.message);
      setBusy(false);
    }
  };

  const cta = method === 'pay_at_counter' ? 'Place order' : 'Place order and pay';

  return (
    <Sheet
      open={open}
      onClose={busy ? undefined : onClose}
      title="Checkout"
      footer={
        <>
          <ErrorNote>{error}</ErrorNote>
          <button
            className={`btn-primary mt-3 w-full text-lg transition-colors duration-300 ${placed ? '!bg-veg !opacity-100' : ''}`}
            disabled={busy || !method}
            onClick={submit}
            aria-live="polite"
          >
            {placed ? (
              <><Check size={22} strokeWidth={3} className="token-in" aria-hidden="true" /> {placed}</>
            ) : busy ? (
              <><span className="h-4 w-4 animate-spin rounded-full border-2 border-white/40 border-t-white" aria-hidden="true" /> Placing your order…</>
            ) : (
              <>{cta} <span className="num">{formatINR(bill.total)}</span></>
            )}
          </button>
        </>
      }
    >
      <div className="rounded-2xl bg-steel-100 px-4 py-3 text-sm">
        <p className="font-semibold">{context?.mode === 'dine_in' ? `Dine-in at table ${context.table}` : 'Takeaway. Collect at the counter when your token is called.'}</p>
      </div>

      <label className="mt-5 block">
        <span className="label">Name for the order</span>
        <input className="field" value={name} onChange={(e) => setName(e.target.value)} maxLength={40} autoComplete="given-name" placeholder="Optional" />
      </label>

      {outlet?.loyalty_enabled && (
        <div className="mt-4 flex items-center justify-between gap-3 rounded-2xl ring-1 ring-steel-200 px-4 py-3 text-sm">
          {customer.isPhoneUser ? (
            <>
              <span className="flex items-center gap-1.5">
                <CoinIcon /> {customer.session.user.phone.replace(/^91/, '+91 ')}
                {bill.earn > 0 && <span className="text-ink-soft">, earning {bill.earn} coins</span>}
              </span>
              <button className="text-ink-soft underline" onClick={customer.signOut}>Not you?</button>
            </>
          ) : (
            <>
              <span>Add your phone to earn coins on this order.</span>
              <button className="btn-quiet flex-none px-3 py-2" onClick={onSignIn}>Add phone</button>
            </>
          )}
        </div>
      )}

      <fieldset className="mt-6">
        <legend className="mb-2 text-lg font-bold">How would you like to pay?</legend>
        {methods.length === 0 && <ErrorNote>This outlet has no payment method switched on. Please order at the counter.</ErrorNote>}
        <div className="space-y-2">
          {methods.map(({ id, title, detail, Icon }) => (
            <label key={id} className={`flex cursor-pointer items-start gap-3 rounded-2xl px-4 py-3.5 ring-1 ${method === id ? 'bg-cardamom-light ring-2 ring-cardamom' : 'ring-steel-200'}`}>
              <input type="radio" name="pay" className="mt-1 h-5 w-5 accent-cardamom" checked={method === id} onChange={() => setMethod(id)} />
              <Icon size={20} className="mt-0.5 flex-none text-cardamom" aria-hidden="true" />
              <span>
                <span className="block font-semibold">{title}</span>
                <span className="block text-sm text-ink-soft">{detail}</span>
              </span>
            </label>
          ))}
        </div>
      </fieldset>
    </Sheet>
  );
}
