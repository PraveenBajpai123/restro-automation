import { useEffect, useState } from 'react';
import { staffDb as db, must } from '../lib/supabase';
import { useStaff } from '../hooks/useStaff';
import { ErrorNote, Spinner } from '../components/ui';
import { PageTitle } from './OwnerLayout';

const pct = (bp) => String((bp ?? 0) / 100);
const toBp = (p) => Math.round(Number(p) * 100);

function Section({ title, children, hint }) {
  return (
    <section className="rounded-2xl bg-white p-5 ring-1 ring-steel-200">
      <h2 className="text-lg font-bold">{title}</h2>
      {hint && <p className="mt-0.5 text-sm text-ink-soft">{hint}</p>}
      <div className="mt-4 grid gap-4 sm:grid-cols-2">{children}</div>
    </section>
  );
}

const Toggle = ({ label, checked, onChange, detail }) => (
  <label className="flex items-start gap-3 sm:col-span-2">
    <input type="checkbox" className="mt-0.5 h-5 w-5 accent-cardamom" checked={checked} onChange={(e) => onChange(e.target.checked)} />
    <span><span className="block font-semibold">{label}</span>{detail && <span className="block text-sm text-ink-soft">{detail}</span>}</span>
  </label>
);

export default function Settings() {
  const { profile } = useStaff();
  const [form, setForm] = useState(null);
  const [saved, setSaved] = useState(null);
  const [error, setError] = useState(null);
  const [busy, setBusy] = useState(false);

  useEffect(() => {
    db.from('outlets').select('*').eq('id', profile.outlet_id).single().then((res) => {
      try {
        const o = must(res);
        setForm({ ...o, cgst: pct(o.cgst_rate_bp), sgst: pct(o.sgst_rate_bp), earn: pct(o.loyalty_earn_bp), maxRedeem: pct(o.loyalty_max_redeem_bp) });
      } catch (e) { setError(e.message); }
    });
  }, [profile.outlet_id]);

  if (!form) return error ? <ErrorNote>{error}</ErrorNote> : <Spinner />;

  const set = (k) => (e) => setForm((f) => ({ ...f, [k]: e.target.value }));
  const flag = (k) => (v) => setForm((f) => ({ ...f, [k]: v }));
  const text = (k, label, props = {}) => (
    <label className={`block ${props.wide ? 'sm:col-span-2' : ''}`}>
      <span className="label">{label}</span>
      <input className="field" value={form[k] ?? ''} onChange={set(k)} {...props.input} />
    </label>
  );

  const save = async (e) => {
    e.preventDefault();
    setBusy(true); setError(null); setSaved(null);
    try {
      if (form.upi_intent_enabled && !form.upi_vpa?.includes('@')) throw new Error('Enter your merchant UPI ID (like cafe@okaxis) to accept UPI app payments.');
      const n = (v) => (v === '' || v == null ? null : v.trim?.() ?? v);
      must(await db.from('outlets').update({
        name: form.name.trim(), legal_name: n(form.legal_name), gstin: n(form.gstin)?.toUpperCase() || null, fssai_license: n(form.fssai_license),
        address: n(form.address), phone: n(form.phone), logo_url: n(form.logo_url), cover_url: n(form.cover_url),
        cgst_rate_bp: toBp(form.cgst), sgst_rate_bp: toBp(form.sgst), invoice_prefix: form.invoice_prefix.trim() || 'INV',
        loyalty_enabled: form.loyalty_enabled, loyalty_earn_bp: toBp(form.earn), loyalty_max_redeem_bp: toBp(form.maxRedeem),
        loyalty_min_redeem_coins: parseInt(form.loyalty_min_redeem_coins, 10) || 0,
        upi_vpa: n(form.upi_vpa), upi_payee_name: n(form.upi_payee_name),
        razorpay_enabled: form.razorpay_enabled, upi_intent_enabled: form.upi_intent_enabled, pay_at_counter_enabled: form.pay_at_counter_enabled,
        dine_in_enabled: form.dine_in_enabled, takeaway_enabled: form.takeaway_enabled, require_table_key: form.require_table_key,
        token_start: parseInt(form.token_start, 10), token_end: parseInt(form.token_end, 10), is_open: form.is_open,
      }).eq('id', form.id));
      setSaved('Settings saved. Customers see the changes on their next page load.');
    } catch (err) {
      setError(/gstin/.test(err.message) ? 'That GSTIN does not look right. It should be 15 characters, like 27AAAAA0000A1Z5.' : err.message);
    } finally {
      setBusy(false);
    }
  };

  return (
    <form onSubmit={save}>
      <PageTitle title="Settings" actions={<button className="btn-primary" disabled={busy}>{busy ? 'Saving…' : 'Save settings'}</button>} />
      {error && <div className="mb-4"><ErrorNote>{error}</ErrorNote></div>}
      {saved && <p className="mb-4 rounded-xl bg-cardamom-light px-4 py-3 text-sm text-cardamom-dark" role="status">{saved}</p>}

      <div className="space-y-6">
        <Section title="Taking orders">
          <Toggle label="Open for orders" checked={form.is_open} onChange={flag('is_open')} detail="Turn off at closing time. The menu stays visible but nobody can order." />
          <Toggle label="Dine-in (table QR codes)" checked={form.dine_in_enabled} onChange={flag('dine_in_enabled')} />
          <Toggle label="Takeaway and self-pickup" checked={form.takeaway_enabled} onChange={flag('takeaway_enabled')} detail="Customers get a token number and are told when it is ready." />
          <Toggle label="Require the secret key in table QR codes" checked={form.require_table_key} onChange={flag('require_table_key')} detail="Stops people ordering to a table by typing the address. You must reprint QR codes after turning this on." />
          {text('token_start', 'First token of the day', { input: { inputMode: 'numeric' } })}
          {text('token_end', 'Last token before starting again', { input: { inputMode: 'numeric' } })}
        </Section>

        <Section title="Payments" hint="Razorpay keys are set as Supabase secrets, never here. See the README.">
          <Toggle label="Pay online with Razorpay" checked={form.razorpay_enabled} onChange={flag('razorpay_enabled')} detail="UPI, cards, netbanking. Confirmed automatically, so orders go straight to the kitchen." />
          <Toggle label="Pay with a UPI app" checked={form.upi_intent_enabled} onChange={flag('upi_intent_enabled')} detail="Opens GPay, PhonePe or Paytm with the amount filled in. Staff confirm payment on the kitchen display." />
          <Toggle label="Pay at the counter" checked={form.pay_at_counter_enabled} onChange={flag('pay_at_counter_enabled')} detail="Staff approve the order on the kitchen display after taking payment." />
          {text('upi_vpa', 'Merchant UPI ID', { input: { placeholder: 'cafe@okaxis' } })}
          {text('upi_payee_name', 'Name shown in the UPI app')}
        </Section>

        <Section title="Store coins" hint="1 coin = ₹1. Coins are earned on completed orders and returned if an order is cancelled.">
          <Toggle label="Loyalty coins" checked={form.loyalty_enabled} onChange={flag('loyalty_enabled')} />
          {text('earn', 'Coins earned (% of bill before GST)', { input: { inputMode: 'decimal' } })}
          {text('maxRedeem', 'Most of a bill payable with coins (%)', { input: { inputMode: 'decimal' } })}
          {text('loyalty_min_redeem_coins', 'Minimum coins before they can be used', { input: { inputMode: 'numeric' } })}
        </Section>

        <Section title="Bills and GST" hint="Restaurant service is usually 5% GST: CGST 2.5% plus SGST 2.5%. Check with your CA.">
          {text('cgst', 'CGST %', { input: { inputMode: 'decimal' } })}
          {text('sgst', 'SGST %', { input: { inputMode: 'decimal' } })}
          {text('gstin', 'GSTIN', { input: { maxLength: 15 } })}
          {text('invoice_prefix', 'Invoice number prefix (up to 4 letters)', { input: { maxLength: 4 } })}
          {text('fssai_license', 'FSSAI licence number')}
        </Section>

        <Section title="Outlet details" hint="Shown on the menu and printed on bills.">
          {text('name', 'Name on the menu')}
          {text('legal_name', 'Registered business name')}
          {text('address', 'Address', { wide: true })}
          {text('phone', 'Phone')}
          {text('logo_url', 'Logo image URL')}
          {text('cover_url', 'Cover photo URL (banner at the top of the menu)', { wide: true })}
        </Section>
      </div>
    </form>
  );
}
