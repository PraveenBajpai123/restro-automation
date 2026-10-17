import { useEffect, useState } from 'react';
import { Sparkles } from 'lucide-react';
import { CoinIcon } from '../components/ui';
import { normalisePhone } from '../hooks/useCustomer';
import { formatINR } from '../lib/money';

/**
 * Coins callout in the cart. Signed-out diners verify their mobile inline (number → 6-digit SMS code)
 * instead of a separate popup. The code step stays: it is what stops someone spending another person's coins.
 */
export default function LoyaltyBox({ customer, bill, previewEarn, redeemCoins, setRedeem }) {
  const wallet = customer.wallet;
  const [step, setStep] = useState('idle'); // idle | code
  const [phone, setPhone] = useState('');
  const [code, setCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const [resendIn, setResendIn] = useState(0);

  useEffect(() => {
    if (resendIn <= 0) return;
    const t = setTimeout(() => setResendIn((s) => s - 1), 1000);
    return () => clearTimeout(t);
  }, [resendIn]);

  const e164 = normalisePhone(phone);

  const send = async (e) => {
    e?.preventDefault();
    if (!e164) return setError('Enter a 10-digit mobile number.');
    setBusy(true);
    setError(null);
    try {
      await customer.sendOtp(e164);
      setStep('code');
      setResendIn(30);
    } catch (err) {
      setError(err.message);
    } finally {
      setBusy(false);
    }
  };

  const verify = async (e) => {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await customer.verifyOtp(e164, code.trim());
      setStep('idle');
      setCode('');
    } catch (err) {
      setError(/expired|invalid/i.test(err.message) ? 'That code is wrong or has expired.' : err.message);
    } finally {
      setBusy(false);
    }
  };

  const shell = 'mt-5 rounded-2xl bg-gradient-to-br from-[#FFF4D6] via-[#FBE7B5] to-[#F3D58C] p-4 text-ink shadow-sm ring-1 ring-[#E2C26E]/60';

  if (customer.isPhoneUser && wallet) {
    return (
      <section className={shell} aria-label="Berries Coins">
        <div className="flex items-center justify-between gap-3">
          <div>
            <p className="flex items-center gap-1.5 font-semibold">
              <CoinIcon size={18} /> <span className="num">{wallet.coin_balance}</span> Berries Coins
            </p>
            <p className="mt-0.5 text-sm text-ink-soft">
              {bill.maxRedeemable > 0
                ? `Use ${bill.maxRedeemable} coins to save ${formatINR(bill.maxRedeemable * 100)}`
                : wallet.coin_balance > 0
                  ? 'Add a little more to use your coins on this order'
                  : 'Coins land in your wallet when this order is completed'}
            </p>
          </div>
          {bill.maxRedeemable > 0 && (
            <label className="relative inline-flex flex-none cursor-pointer items-center">
              <input type="checkbox" className="peer sr-only" checked={redeemCoins} onChange={(e) => setRedeem(e.target.checked)} />
              <span className="h-7 w-12 rounded-full bg-ink/20 transition-colors peer-checked:bg-espresso peer-focus-visible:ring-2 peer-focus-visible:ring-espresso peer-focus-visible:ring-offset-2" />
              <span className="absolute left-1 top-1 h-5 w-5 rounded-full bg-white transition-transform peer-checked:translate-x-5" />
              <span className="sr-only">Use coins</span>
            </label>
          )}
        </div>
        {bill.earn > 0 && (
          <p className="mt-2 flex items-center gap-1.5 text-sm font-medium text-haldi-dark">
            <Sparkles size={14} aria-hidden="true" /> You'll earn {bill.earn} Berries Coins on this order
          </p>
        )}
      </section>
    );
  }

  return (
    <section className={shell} aria-label="Earn Berries Coins">
      <p className="flex items-center gap-2 font-semibold">
        <CoinIcon size={18} /> Earn {previewEarn} Berries Coins on this order
      </p>
      <p className="mt-0.5 text-sm text-ink-soft">1 coin = ₹1 off your next visit. Add your mobile number to collect them.</p>

      {step === 'idle' ? (
        <form onSubmit={send} className="mt-3 flex gap-2">
          <div className="flex min-w-0 flex-1 overflow-hidden rounded-xl bg-white/90 ring-1 ring-ink/10 focus-within:ring-2 focus-within:ring-espresso">
            <span className="flex items-center pl-3 pr-1 text-sm text-ink-soft">+91</span>
            <input
              className="min-w-0 flex-1 bg-transparent px-2 py-2.5 text-base outline-none"
              type="tel"
              inputMode="numeric"
              autoComplete="tel-national"
              maxLength={14}
              placeholder="Mobile number"
              value={phone}
              onChange={(e) => setPhone(e.target.value)}
              aria-label="Mobile number"
            />
          </div>
          <button className="flex-none rounded-xl bg-espresso px-4 text-sm font-semibold text-white disabled:opacity-50" disabled={busy || !phone}>
            {busy ? 'Sending…' : 'Get code'}
          </button>
        </form>
      ) : (
        <form onSubmit={verify} className="mt-3">
          <p className="text-sm">
            Code sent to {e164}.{' '}
            <button type="button" className="font-semibold underline" onClick={() => { setStep('idle'); setError(null); }}>Change</button>
          </p>
          <div className="mt-2 flex gap-2">
            <input
              className="num min-w-0 flex-1 rounded-xl bg-white/90 px-3 py-2.5 text-center text-lg tracking-[0.4em] outline-none ring-1 ring-ink/10 focus:ring-2 focus:ring-espresso"
              inputMode="numeric"
              autoComplete="one-time-code"
              maxLength={6}
              value={code}
              onChange={(e) => setCode(e.target.value.replace(/\D/g, ''))}
              aria-label="6-digit code"
              autoFocus
            />
            <button className="flex-none rounded-xl bg-espresso px-4 text-sm font-semibold text-white disabled:opacity-50" disabled={busy || code.length < 6}>
              {busy ? 'Checking…' : 'Verify'}
            </button>
          </div>
          <button type="button" className="mt-2 text-xs text-ink-soft underline disabled:no-underline disabled:opacity-60" disabled={resendIn > 0 || busy} onClick={send}>
            {resendIn > 0 ? `Resend code in ${resendIn}s` : 'Resend code'}
          </button>
        </form>
      )}
      {error && <p className="mt-2 text-sm font-medium text-chilli" role="alert">{error}</p>}
    </section>
  );
}
