import { describe, it, expect } from 'vitest';
import { computeBill, formatINR } from './money.js';

const outlet = { cgst_rate_bp: 250, sgst_rate_bp: 250, loyalty_enabled: true, loyalty_earn_bp: 500, loyalty_max_redeem_bp: 5000, loyalty_min_redeem_coins: 0 };
const opt = (deltaPaise) => ({ id: String(deltaPaise), name: 'x', groupName: 'g', deltaPaise });

describe('computeBill (mirrors place_order)', () => {
  it('matches the SQL example: ₹700 + 5% GST = ₹735', () => {
    const lines = [
      { basePaise: 18000, options: [opt(4000), opt(4000)], qty: 2 },
      { basePaise: 15000, options: [opt(3000)], qty: 1 },
    ];
    expect(computeBill(lines, outlet)).toMatchObject({ subtotal: 70000, cgst: 1750, sgst: 1750, total: 73500, roundOff: 0, earn: 0 });
  });

  it('caps redemption at 50% and earns on the net amount', () => {
    const b = computeBill([{ basePaise: 24000, options: [], qty: 1 }], outlet, { coinBalance: 500, redeem: true, signedIn: true });
    expect(b).toMatchObject({ coins: 120, taxable: 12000, cgst: 300, sgst: 300, total: 12600, earn: 6 });
  });

  it('matches the SQL Frappe case: 100 coins on ₹240', () => {
    const b = computeBill([{ basePaise: 24000, options: [], qty: 1 }], outlet, { coinBalance: 100, redeem: true, signedIn: true });
    expect(b).toMatchObject({ coins: 100, taxable: 14000, total: 14700, earn: 7 });
  });

  it('rounds to the nearest rupee with a round-off line', () => {
    // 199 + 4.975 + 4.975 = 208.95 -> ₹209
    expect(computeBill([{ basePaise: 19900, options: [], qty: 1 }], outlet)).toMatchObject({ cgst: 498, sgst: 498, total: 20900, roundOff: 4 });
  });

  it('signed-out customers cannot redeem', () => {
    expect(computeBill([{ basePaise: 24000, options: [], qty: 1 }], outlet, { coinBalance: 100, redeem: true }).coins).toBe(0);
  });

  it('formats rupees', () => {
    expect(formatINR(18000)).toBe('₹180');
    expect(formatINR(1750)).toBe('₹17.50');
  });
});
