import { formatINR, formatINRExact, bpToPercent } from '../lib/money';

/** GST bill lines. Accepts either a computeBill() result or a server order (…_paise fields). */
export default function BillSummary({ bill, outlet, order }) {
  const b = order
    ? {
        subtotal: order.subtotal_paise, coins: order.coins_redeemed, cgst: order.cgst_paise, sgst: order.sgst_paise,
        roundOff: order.round_off_paise, total: order.grand_total_paise,
      }
    : bill;
  const cgstBp = order?.cgst_rate_bp ?? outlet?.cgst_rate_bp;
  const sgstBp = order?.sgst_rate_bp ?? outlet?.sgst_rate_bp;

  const Row = ({ label, value, className = '' }) => (
    <div className={`flex justify-between py-1 ${className}`}>
      <dt>{label}</dt>
      <dd className="num">{value}</dd>
    </div>
  );

  return (
    <dl className="text-sm text-ink-soft">
      <Row label="Item total" value={formatINRExact(b.subtotal)} />
      {b.coins > 0 && <Row label={`Coins used (${b.coins})`} value={`−${formatINRExact(b.coins * 100)}`} className="text-haldi-dark" />}
      <Row label={`CGST ${bpToPercent(cgstBp)}`} value={formatINRExact(b.cgst)} />
      <Row label={`SGST ${bpToPercent(sgstBp)}`} value={formatINRExact(b.sgst)} />
      {b.roundOff !== 0 && <Row label="Round off" value={`${b.roundOff > 0 ? '+' : '−'}${formatINRExact(Math.abs(b.roundOff))}`} />}
      <div className="mt-2 flex justify-between border-t border-dashed border-steel-300 pt-3 text-base font-bold text-ink">
        <dt>To pay</dt>
        <dd className="num">{formatINR(b.total)}</dd>
      </div>
    </dl>
  );
}
