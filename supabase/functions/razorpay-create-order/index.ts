// Creates (or reuses) a Razorpay order for an order awaiting online payment.
// Input: { tracking_key }. The amount always comes from the database, never from the browser.
import { adminClient, corsHeaders, fail, json } from '../_shared/http.ts';

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  if (req.method !== 'POST') return fail(405, 'Use POST');

  const keyId = Deno.env.get('RAZORPAY_KEY_ID');
  const keySecret = Deno.env.get('RAZORPAY_KEY_SECRET');
  if (!keyId || !keySecret) return fail(503, 'Online payment is not set up yet. Please choose another way to pay.');

  let trackingKey: string | undefined;
  try {
    ({ tracking_key: trackingKey } = await req.json());
  } catch {
    return fail(400, 'Invalid request');
  }
  if (!trackingKey || !/^[0-9a-f]{32}$/.test(trackingKey)) return fail(400, 'Invalid order reference');

  const db = adminClient();
  const { data: order, error } = await db
    .from('orders')
    .select('id, token_number, status, payment_method, grand_total_paise, outlet_id, payments(id, method, provider_order_id)')
    .eq('tracking_key', trackingKey)
    .maybeSingle();
  if (error) return fail(500, error.message);
  if (!order) return fail(404, 'Order not found');
  if (order.payment_method !== 'razorpay') return fail(409, 'This order is not set to online payment');
  if (order.status !== 'awaiting_payment') return fail(409, 'This order is already paid or was cancelled');

  const payment = order.payments.find((p: { method: string }) => p.method === 'razorpay');
  if (!payment) return fail(500, 'Payment record missing');

  if (payment.provider_order_id) {
    return json({ key_id: keyId, razorpay_order_id: payment.provider_order_id, amount: order.grand_total_paise });
  }

  const rzp = await fetch('https://api.razorpay.com/v1/orders', {
    method: 'POST',
    headers: { Authorization: `Basic ${btoa(`${keyId}:${keySecret}`)}`, 'Content-Type': 'application/json' },
    body: JSON.stringify({
      amount: order.grand_total_paise,
      currency: 'INR',
      receipt: `t${order.token_number}-${order.id.slice(0, 30)}`,
      notes: { order_id: order.id, token: String(order.token_number) },
    }),
  });
  const body = await rzp.json();
  if (!rzp.ok) {
    console.error('Razorpay order failed', rzp.status, body);
    return fail(502, 'The payment provider is not responding. Please try again or pay at the counter.');
  }

  // Only set it if still empty, so two quick taps can't create two different Razorpay orders.
  const { data: updated } = await db
    .from('payments')
    .update({ provider_order_id: body.id })
    .eq('id', payment.id)
    .is('provider_order_id', null)
    .select('provider_order_id')
    .maybeSingle();

  let rzpOrderId = updated?.provider_order_id;
  if (!rzpOrderId) {
    const { data: again } = await db.from('payments').select('provider_order_id').eq('id', payment.id).single();
    rzpOrderId = again?.provider_order_id;
  }
  return json({ key_id: keyId, razorpay_order_id: rzpOrderId, amount: order.grand_total_paise });
});
