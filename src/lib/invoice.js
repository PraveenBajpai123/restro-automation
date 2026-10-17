import { jsPDF } from 'jspdf';
import { bpToPercent } from './money';

// jsPDF's built-in fonts have no ₹ glyph, so the PDF uses "Rs." (standard on Indian thermal bills too).
const rs = (paise) => `Rs. ${((paise ?? 0) / 100).toFixed(2)}`;

/** GST tax invoice from a get_order_tracking() payload */
export function downloadInvoice(order) {
  const o = order.outlet || {};
  const doc = new jsPDF({ unit: 'mm', format: [80, 200 + order.items.length * 9] });
  const W = 80;
  let y = 10;
  const center = (t, size = 9, style = 'normal') => { doc.setFont('helvetica', style); doc.setFontSize(size); doc.text(t, W / 2, y, { align: 'center' }); y += size * 0.5; };
  const row = (l, r, style = 'normal') => { doc.setFont('helvetica', style); doc.setFontSize(8.5); doc.text(l, 5, y); doc.text(r, W - 5, y, { align: 'right' }); y += 4.6; };
  const rule = () => { doc.setLineDashPattern([1, 1], 0); doc.line(5, y - 2, W - 5, y - 2); y += 2.5; };

  center(o.name || 'Tax invoice', 13, 'bold'); y += 1;
  if (o.legal_name && o.legal_name !== o.name) center(o.legal_name, 8);
  if (o.address) doc.splitTextToSize(o.address, W - 10).forEach((l) => center(l, 8));
  if (o.phone) center(`Ph: ${o.phone}`, 8);
  if (o.gstin) center(`GSTIN: ${o.gstin}`, 8, 'bold');
  if (o.fssai_license) center(`FSSAI: ${o.fssai_license}`, 8);
  y += 2;
  center('TAX INVOICE', 10, 'bold');
  y += 1; rule();

  row('Invoice no.', order.invoice_number || 'Pending payment');
  row('Date', new Date(order.created_at).toLocaleString('en-IN', { dateStyle: 'medium', timeStyle: 'short' }));
  row('Order', `#${order.token_number} ${order.mode === 'dine_in' ? `Table ${order.table}` : 'Takeaway'}`);
  if (order.customer_name) row('Customer', order.customer_name);
  row('SAC', '996331 Restaurant service');
  rule();

  for (const it of order.items) {
    doc.setFont('helvetica', 'bold'); doc.setFontSize(8.5);
    const name = doc.splitTextToSize(`${it.quantity} x ${it.name}`, W - 32);
    doc.text(name, 5, y);
    doc.text(rs(it.line_total_paise), W - 5, y, { align: 'right' });
    y += name.length * 4;
    if (it.modifiers.length) {
      doc.setFont('helvetica', 'normal'); doc.setFontSize(7.5);
      const mods = doc.splitTextToSize(it.modifiers.join(', '), W - 14);
      doc.text(mods, 8, y); y += mods.length * 3.5;
    }
    y += 1;
  }
  rule();
  row('Item total', rs(order.subtotal_paise));
  if (order.coins_redeemed > 0) row(`Coins redeemed (${order.coins_redeemed})`, `- ${rs(order.coins_redeemed * 100)}`);
  row('Taxable value', rs(order.taxable_paise));
  row(`CGST @ ${bpToPercent(order.cgst_rate_bp)}`, rs(order.cgst_paise));
  row(`SGST @ ${bpToPercent(order.sgst_rate_bp)}`, rs(order.sgst_paise));
  if (order.round_off_paise) row('Round off', rs(order.round_off_paise));
  y += 1;
  row('TOTAL', rs(order.grand_total_paise), 'bold');
  rule();
  if (order.coins_earned > 0 && order.status === 'completed') center(`You earned ${order.coins_earned} coins on this order`, 8);
  center('Thank you. See you again!', 8);

  doc.save(`invoice-${order.invoice_number?.replaceAll('/', '-') || order.token_number}.pdf`);
}
