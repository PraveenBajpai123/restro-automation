import { formatINRExact, bpToPercent } from '../lib/money';

const time = (iso) => new Date(iso).toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit' });
const dash = <div style={{ borderTop: '1px dashed #000', margin: '4px 0' }} />;
const rowStyle = { display: 'flex', justifyContent: 'space-between', gap: 6 };

/** 58 mm kitchen ticket (ported from ngachoan DapurView, now with modifiers and notes) */
export function KitchenTicket({ order, outletName }) {
  return (
    <div>
      <div style={{ textAlign: 'center', fontWeight: 700 }}>{outletName}</div>
      <div style={{ textAlign: 'center' }}>KITCHEN ORDER</div>
      {dash}
      <div style={{ fontSize: 22, fontWeight: 800, textAlign: 'center' }}>#{order.token_number}</div>
      <div style={{ textAlign: 'center', fontWeight: 700 }}>{order.mode === 'dine_in' ? `TABLE ${order.dining_tables?.label}` : 'TAKEAWAY'}</div>
      <div style={{ textAlign: 'center' }}>{time(order.placed_at || order.created_at)}{order.customer_name ? ` ${order.customer_name}` : ''}</div>
      {dash}
      {order.order_items.map((it) => (
        <div key={it.id} style={{ marginBottom: 4 }}>
          <div style={{ ...rowStyle, fontWeight: 700, fontSize: 13 }}>
            <span>{it.item_name}</span>
            <span>x{it.quantity}</span>
          </div>
          {it.order_item_modifiers.map((m) => (
            <div key={m.id} style={{ paddingLeft: 8 }}>+ {m.option_name}</div>
          ))}
          {it.notes && <div style={{ paddingLeft: 8, fontStyle: 'italic' }}>* {it.notes}</div>}
        </div>
      ))}
      {order.notes && (
        <>
          {dash}
          <div style={{ fontWeight: 700 }}>NOTE: {order.notes}</div>
        </>
      )}
      {dash}
    </div>
  );
}

/** 58 mm customer bill with GST split */
export function CustomerReceipt({ order, outlet }) {
  const r = (label, paise, bold) => (
    <div style={{ ...rowStyle, fontWeight: bold ? 700 : 400 }}>
      <span>{label}</span>
      <span>{formatINRExact(paise).replace('₹', 'Rs.')}</span>
    </div>
  );
  return (
    <div>
      <div style={{ textAlign: 'center', fontWeight: 700, fontSize: 13 }}>{outlet.name}</div>
      {outlet.address && <div style={{ textAlign: 'center' }}>{outlet.address}</div>}
      {outlet.gstin && <div style={{ textAlign: 'center' }}>GSTIN {outlet.gstin}</div>}
      <div style={{ textAlign: 'center', fontWeight: 700, marginTop: 4 }}>TAX INVOICE</div>
      {dash}
      <div>Inv: {order.invoice_number || 'UNPAID'}</div>
      <div>{new Date(order.created_at).toLocaleString('en-IN')}</div>
      <div>Token #{order.token_number} {order.mode === 'dine_in' ? `Table ${order.dining_tables?.label}` : 'Takeaway'}</div>
      {dash}
      {order.order_items.map((it) => (
        <div key={it.id}>
          <div style={rowStyle}>
            <span>{it.quantity} {it.item_name}</span>
            <span>{(it.line_total_paise / 100).toFixed(2)}</span>
          </div>
          {it.order_item_modifiers.length > 0 && <div style={{ paddingLeft: 8 }}>{it.order_item_modifiers.map((m) => m.option_name).join(', ')}</div>}
        </div>
      ))}
      {dash}
      {r('Item total', order.subtotal_paise)}
      {order.coins_redeemed > 0 && r(`Coins (${order.coins_redeemed})`, -order.coins_redeemed * 100)}
      {r(`CGST ${bpToPercent(order.cgst_rate_bp)}`, order.cgst_paise)}
      {r(`SGST ${bpToPercent(order.sgst_rate_bp)}`, order.sgst_paise)}
      {order.round_off_paise !== 0 && r('Round off', order.round_off_paise)}
      {r('TOTAL', order.grand_total_paise, true)}
      {dash}
      <div style={{ textAlign: 'center' }}>SAC 996331. Thank you!</div>
    </div>
  );
}
