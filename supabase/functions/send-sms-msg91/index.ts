// Supabase Auth "Send SMS" hook → MSG91 (India). Supabase generates the OTP; we only deliver it.
// Setup (Dashboard → Authentication → Hooks → Send SMS → HTTPS):
//   URL:    https://<project>.supabase.co/functions/v1/send-sms-msg91
//   Secret: copy the generated "v1,whsec_..." value into SEND_SMS_HOOK_SECRET
// Secrets: MSG91_AUTH_KEY, MSG91_TEMPLATE_ID (a DLT-approved template with an ##otp## variable).
import { Webhook } from 'npm:standardwebhooks@1.0.0';

Deno.serve(async (req) => {
  const payload = await req.text();
  const secret = (Deno.env.get('SEND_SMS_HOOK_SECRET') ?? '').replace('v1,whsec_', '');
  let event: { user: { phone: string }; sms: { otp: string } };
  try {
    event = new Webhook(secret).verify(payload, Object.fromEntries(req.headers)) as typeof event;
  } catch {
    return new Response(JSON.stringify({ error: { http_code: 401, message: 'Invalid signature' } }), { status: 401 });
  }

  const res = await fetch('https://control.msg91.com/api/v5/flow', {
    method: 'POST',
    headers: { authkey: Deno.env.get('MSG91_AUTH_KEY')!, 'Content-Type': 'application/json', accept: 'application/json' },
    body: JSON.stringify({
      template_id: Deno.env.get('MSG91_TEMPLATE_ID'),
      short_url: '0',
      recipients: [{ mobiles: event.user.phone.replace(/^\+/, ''), otp: event.sms.otp }],
    }),
  });
  if (!res.ok) {
    console.error('MSG91 failed', res.status, await res.text());
    return new Response(JSON.stringify({ error: { http_code: 502, message: 'Could not send the SMS. Try again in a minute.' } }), { status: 502 });
  }
  return new Response('{}', { headers: { 'Content-Type': 'application/json' } });
});
