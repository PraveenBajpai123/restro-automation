import { Sheet, Stepper, VegMark } from '../components/ui';
import { formatINR, lineTotalPaise } from '../lib/money';
import BillSummary from './BillSummary';
import LoyaltyBox from './LoyaltyBox';

export default function CartSheet({ showVeg = false, open, onClose, cart, bill, previewEarn, outlet, customer, context, onSignIn, onCheckout }) {
  const { lines, setQty, redeemCoins, setRedeem, notes, setNotes } = cart;

  return (
    <Sheet
      open={open}
      onClose={onClose}
      title="Your order"
      footer={
        <button className="btn-primary w-full text-lg" onClick={onCheckout} disabled={!lines.length || !context?.mode}>
          Continue to pay <span className="num">{formatINR(bill.total)}</span>
        </button>
      }
    >
      <p className="-mt-1 mb-3 text-sm text-ink-soft">{context?.label}</p>

      {lines.length === 0 ? (
        <p className="py-10 text-center text-ink-soft">Your order is empty. Add something from the menu.</p>
      ) : (
        <ul className="divide-y divide-steel-200">
          {lines.map((l) => (
            <li key={l.key} className="flex items-start gap-3 py-4">
              {showVeg && <VegMark isVeg={l.isVeg} className="mt-1.5" />}
              <div className="min-w-0 flex-1">
                <p className="font-semibold leading-snug">{l.name}</p>
                {l.options.length > 0 && <p className="mt-0.5 text-sm text-ink-soft">{l.options.map((o) => o.name).join(', ')}</p>}
                <p className="num mt-1 text-sm font-semibold">{formatINR(lineTotalPaise(l))}</p>
              </div>
              <Stepper value={l.qty} onChange={(q) => setQty(l.key, q)} size="sm" label={`${l.name} quantity`} />
            </li>
          ))}
        </ul>
      )}

      {lines.length > 0 && (
        <>
          <label className="mt-2 block">
            <span className="label">Cooking instructions</span>
            <textarea
              className="field min-h-[3rem] resize-none text-sm"
              rows={2}
              maxLength={300}
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              placeholder="Less sugar, no onion…"
            />
          </label>

          {outlet?.loyalty_enabled && (
            <LoyaltyBox customer={customer} bill={bill} previewEarn={previewEarn} redeemCoins={redeemCoins} setRedeem={setRedeem} />
          )}

          <section className="mt-5">
            <h3 className="mb-2 font-bold">Bill details</h3>
            <BillSummary bill={bill} outlet={outlet} />
          </section>
        </>
      )}
    </Sheet>
  );
}
