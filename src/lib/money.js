// Money is integer paise everywhere. These helpers mirror place_order() in SQL so the
// cart can show the bill instantly; the server result is always the one we keep.

const inr = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', maximumFractionDigits: 0 });
const inrExact = new Intl.NumberFormat('en-IN', { style: 'currency', currency: 'INR', minimumFractionDigits: 2, maximumFractionDigits: 2 });

/** ₹180 for whole rupees, ₹17.50 otherwise */
export function formatINR(paise) {
  const p = paise ?? 0;
  return p % 100 === 0 ? inr.format(p / 100) : inrExact.format(p / 100);
}
export const formatINRExact = (paise) => inrExact.format((paise ?? 0) / 100);
export const rupeesToPaise = (r) => Math.round(Number(r) * 100);
export const paiseToRupees = (p) => (p ?? 0) / 100;
export const bpToPercent = (bp) => `${((bp ?? 0) / 100).toLocaleString('en-IN', { maximumFractionDigits: 2 })}%`;

export const lineUnitPaise = (line) => line.basePaise + line.options.reduce((s, o) => s + o.deltaPaise, 0);
export const lineTotalPaise = (line) => lineUnitPaise(line) * line.qty;

/**
 * @param {Array} lines cart lines
 * @param {object} outlet row from `outlets`
 * @param {{ coinBalance?: number, redeem?: boolean, signedIn?: boolean }} wallet
 */
export function computeBill(lines, outlet, { coinBalance = 0, redeem = false, signedIn = false } = {}) {
  const subtotal = lines.reduce((s, l) => s + lineTotalPaise(l), 0);
  const loyaltyOn = Boolean(outlet?.loyalty_enabled);
  const maxRedeemBp = outlet?.loyalty_max_redeem_bp ?? 0;
  let maxRedeemable = loyaltyOn && signedIn ? Math.min(coinBalance, Math.floor((subtotal * maxRedeemBp) / 10000 / 100)) : 0;
  if (maxRedeemable < Math.max(outlet?.loyalty_min_redeem_coins ?? 0, 1)) maxRedeemable = 0;
  const coins = redeem ? maxRedeemable : 0;
  const taxable = subtotal - coins * 100;
  const cgst = Math.round((taxable * (outlet?.cgst_rate_bp ?? 0)) / 10000);
  const sgst = Math.round((taxable * (outlet?.sgst_rate_bp ?? 0)) / 10000);
  const raw = taxable + cgst + sgst;
  const total = Math.round(raw / 100) * 100;
  const earn = signedIn && loyaltyOn ? Math.floor((taxable * (outlet?.loyalty_earn_bp ?? 0)) / 10000 / 100) : 0;
  return { subtotal, coins, maxRedeemable, taxable, cgst, sgst, roundOff: total - raw, total, earn };
}
