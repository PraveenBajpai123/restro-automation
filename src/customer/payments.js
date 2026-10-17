import { supabase, must } from '../lib/supabase';
import { openRazorpay } from '../lib/razorpay';

/** Ask our Edge Function to create a Razorpay order for this tracking key, then open Checkout. */
export async function payWithRazorpay({ trackingKey, outletName, token, phone, name }) {
  const res = await supabase.functions.invoke('razorpay-create-order', { body: { tracking_key: trackingKey } });
  if (res.error) {
    let msg = res.error.message;
    try { msg = (await res.error.context.json()).error || msg; } catch { /* keep default */ }
    throw new Error(msg);
  }
  const { key_id, razorpay_order_id, amount } = res.data;
  return openRazorpay({ keyId: key_id, rzpOrderId: razorpay_order_id, amountPaise: amount, outletName, token, phone, name });
}

/** Builds the place_order payload from cart lines — IDs and quantities only, never prices. */
export function orderPayload({ outletSlug, context, lines, paymentMethod, redeemCoins, customerName, notes }) {
  return {
    outlet_slug: outletSlug,
    mode: context.mode,
    table_label: context.mode === 'dine_in' ? context.table : null,
    table_key: context.mode === 'dine_in' ? context.tableKey : null,
    payment_method: paymentMethod,
    redeem_coins: Boolean(redeemCoins),
    customer_name: customerName || null,
    notes: notes || null,
    items: lines.map((l) => ({ menu_item_id: l.itemId, quantity: l.qty, option_ids: l.options.map((o) => o.id) })),
  };
}

export async function placeOrder(payload) {
  return must(await supabase.rpc('place_order', { p: payload }));
}
