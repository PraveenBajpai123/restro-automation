// Razorpay → us. Verifies X-Razorpay-Signature (HMAC-SHA256 of the raw body with the webhook secret),
// then marks the order paid, which fires it to the kitchen. Configure in Razorpay Dashboard → Webhooks:
//   URL:    https://<project>.supabase.co/functions/v1/razorpay-webhook
//   Events: payment.captured, order.paid
// Deploy with --no-verify-jwt (Razorpay does not send a Supabase JWT).
import { adminClient, json } from '../_shared/http.ts';

const enc = new TextEncoder();

async function hmacHex(secret: string, body: string) {
  const key = await crypto.subtle.importKey('raw', enc.encode(secret), { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']);
  const sig = await crypto.subtle.sign('HMAC', key, enc.encode(body));
  return [...new Uint8Array(sig)].map((b) => b.toString(16).padStart(2, '0')).join('');
}

function safeEqual(a: string, b: string) {
  if (a.length !== b.length) return false;
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

Deno.serve(async (req) => {
  if (req.method !== 'POST') return json({ error: 'Use POST' }, 405);
  const secret = Deno.env.get('RAZORPAY_WEBHOOK_SECRET');
  if (!secret) return json({ error: 'Webhook secret not configured' }, 500);

  const raw = await req.text();
  const signature = req.headers.get('x-razorpay-signature') ?? '';
  if (!safeEqual(await hmacHex(secret, raw), signature)) return json({ error: 'Invalid signature' }, 401);

  const event = JSON.parse(raw);
  if (!['payment.captured', 'order.paid'].includes(event.event)) return json({ ignored: event.event });

  const payment = event.payload?.payment?.entity;
  const rzpOrderId: string | undefined = payment?.order_id ?? event.payload?.order?.entity?.id;
  if (!payment || !rzpOrderId) return json({ ignored: 'no payment entity' });

  const db = adminClient();
  const { data: row } = await db.from('payments').select('order_id').eq('provider_order_id', rzpOrderId).maybeSingle();
  if (!row) {
    console.warn('Webhook for unknown Razorpay order', rzpOrderId);
    return json({ ignored: 'unknown order' }); // 200 so Razorpay stops retrying
  }

  const { error } = await db.rpc('mark_order_paid', {
    p_order: row.order_id,
    p_provider_order_id: rzpOrderId,
    p_provider_payment_id: payment.id,
    p_amount_paise: payment.amount,
    p_raw: event,
  });
  if (error) {
    // e.g. amount mismatch or order cancelled after 15 minutes: needs a manual refund from the Razorpay dashboard
    console.error('mark_order_paid failed', row.order_id, error.message);
    return json({ error: error.message }, 409);
  }
  return json({ ok: true });
});
