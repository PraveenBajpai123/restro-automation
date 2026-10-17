import { useEffect, useState } from 'react';
import { Sheet, ErrorNote } from '../components/ui';
import { normalisePhone } from '../hooks/useCustomer';

/** Phone + 6-digit OTP. On success the customer row and wallet are linked to the phone. */
export default function PhoneLoginSheet({ open, onClose, customer, onDone }) {
  const [step, setStep] = useState('phone');
  const [phone, setPhone] = useState('');
  const [name, setName] = useState('');
  const [code, setCode] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const [resendIn, setResendIn] = useState(0);

  useEffect(() => {
    if (open) { setStep('phone'); setCode(''); setError(null); }
  }, [open]);

  useEffect(() => {
    if (resendIn <= 0) return;
    const t = setTimeout(() => setResendIn((s) => s - 1), 1000);
    return () => clearTimeout(t);
  }, [resendIn]);

  const e164 = normalisePhone(phone);

  const send = async (e) => {
    e?.preventDefault();
    if (!e164) return setError('Enter a 10-digit mobile number.');
    setBusy(true); setError(null);
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
    setBusy(true); setError(null);
    try {
      await customer.verifyOtp(e164, code.trim(), name.trim());
      onDone?.();
    } catch (err) {
      setError(/expired|invalid/i.test(err.message) ? 'That code is wrong or has expired. Check the SMS and try again.' : err.message);
    } finally {
      setBusy(false);
    }
  };

  return (
    <Sheet open={open} onClose={onClose} title={step === 'phone' ? 'Earn coins on every order' : 'Enter the code'}>
      {step === 'phone' ? (
        <form onSubmit={send} className="space-y-4 pb-2">
          <p className="text-ink-soft">We'll text you a one-time code. Your coins are saved to this number.</p>
          <label className="block">
            <span className="label">Mobile number</span>
            <div className="flex">
              <span className="flex items-center rounded-l-xl border border-r-0 border-steel-300 bg-steel-100 px-3 text-ink-soft">+91</span>
              <input
                className="field rounded-l-none"
                type="tel"
                inputMode="numeric"
                autoComplete="tel-national"
                maxLength={14}
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                placeholder="98765 43210"
                autoFocus
              />
            </div>
          </label>
          <label className="block">
            <span className="label">Your name (optional)</span>
            <input className="field" autoComplete="given-name" value={name} onChange={(e) => setName(e.target.value)} placeholder="So we can call your order" />
          </label>
          <ErrorNote>{error}</ErrorNote>
          <button className="btn-primary w-full" disabled={busy || !phone}>{busy ? 'Sending…' : 'Send code'}</button>
        </form>
      ) : (
        <form onSubmit={verify} className="space-y-4 pb-2">
          <p className="text-ink-soft">Sent to {e164}. <button type="button" className="font-semibold text-cardamom underline" onClick={() => setStep('phone')}>Change</button></p>
          <input
            className="field num text-center text-2xl tracking-[0.5em]"
            inputMode="numeric"
            autoComplete="one-time-code"
            maxLength={6}
            value={code}
            onChange={(e) => setCode(e.target.value.replace(/\D/g, ''))}
            aria-label="6-digit code"
            autoFocus
          />
          <ErrorNote>{error}</ErrorNote>
          <button className="btn-primary w-full" disabled={busy || code.length < 6}>{busy ? 'Checking…' : 'Verify and continue'}</button>
          <button type="button" className="w-full text-sm text-ink-soft disabled:opacity-50" disabled={resendIn > 0 || busy} onClick={send}>
            {resendIn > 0 ? `Resend code in ${resendIn}s` : 'Resend code'}
          </button>
        </form>
      )}
    </Sheet>
  );
}
