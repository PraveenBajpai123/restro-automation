import { Sheet, Stepper, VegMark, CoinIcon } from '../components/ui';
import { formatINR, lineTotalPaise } from '../lib/money';
import BillSummary from './BillSummary';

export default function CartSheet({ open, onClose, cart, bill, previewEarn, outlet, customer, context, onSignIn, onCheckout }) {
  const { lines, setQty, redeemCoins, setRedeem, notes, setNotes } = cart;
  const wallet = customer.wallet;

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
              <VegMark isVeg={l.isVeg} className="mt-1.5" />
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
            <section className="mt-5 rounded-2xl bg-haldi-light p-4" aria-label="Store coins">
              {customer.isPhoneUser && wallet ? (
                <>
                  <div className="flex items-center justify-between gap-3">
                    <div>
                      <p className="flex items-center gap-1.5 font-semibold text-ink">
                        <CoinIcon /> <span className="num">{wallet.coin_balance}</span> coins
                      </p>
                      <p className="mt-0.5 text-sm text-haldi-dark">
                        {bill.maxRedeemable > 0
                          ? `Use ${bill.maxRedeemable} coins to save ${formatINR(bill.maxRedeemable * 100)}`
                          : wallet.coin_balance > 0
                            ? 'Add more to use your coins on this order'
                            : 'You earn coins on every completed order'}
                      </p>
                    </div>
                    {bill.maxRedeemable > 0 && (
                      <label className="relative inline-flex cursor-pointer items-center">
                        <input type="checkbox" className="peer sr-only" checked={redeemCoins} onChange={(e) => setRedeem(e.target.checked)} />
                        <span className="h-7 w-12 rounded-full bg-steel-300 transition-colors peer-checked:bg-cardamom peer-focus-visible:ring-2 peer-focus-visible:ring-cardamom peer-focus-visible:ring-offset-2" />
                        <span className="absolute left-1 top-1 h-5 w-5 rounded-full bg-white transition-transform peer-checked:translate-x-5" />
                        <span className="sr-only">Redeem coins</span>
                      </label>
                    )}
                  </div>
                  {bill.earn > 0 && <p className="mt-2 text-sm text-ink-soft">You will earn {bill.earn} coins when this order is completed.</p>}
                </>
              ) : (
                <div className="flex items-center justify-between gap-3">
                  <p className="text-sm text-ink">
                    <span className="font-semibold">Earn {previewEarn} coins on this order.</span> 1 coin = ₹1 off your next visit.
                  </p>
                  <button onClick={onSignIn} className="btn-quiet flex-none px-3 py-2 text-sm">
                    Add phone
                  </button>
                </div>
              )}
            </section>
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
