// Owner-only staff management. Creating users needs the service role, which must never reach the browser.
// (Fixes the old Digital-Menu bug where creating staff client-side signed the admin out.)
//   { action: 'create', email, password, display_name, role }
//   { action: 'set_password', user_id, password }
import { adminClient, callerClient, corsHeaders, fail, json } from '../_shared/http.ts';

const ROLES = ['owner', 'manager', 'cashier', 'kitchen'];

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders });
  if (req.method !== 'POST') return fail(405, 'Use POST');

  const { data: auth } = await callerClient(req).auth.getUser();
  if (!auth?.user) return fail(401, 'Sign in again');

  const db = adminClient();
  const { data: me } = await db.from('staff_profiles').select('outlet_id, role, is_active').eq('user_id', auth.user.id).maybeSingle();
  if (!me?.is_active || me.role !== 'owner') return fail(403, 'Only an owner can manage staff');

  const body = await req.json().catch(() => ({}));

  if (body.action === 'create') {
    const email = String(body.email ?? '').trim().toLowerCase();
    const name = String(body.display_name ?? '').trim();
    if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return fail(400, 'Enter a valid email');
    if (!name) return fail(400, 'Enter a name');
    if (!ROLES.includes(body.role)) return fail(400, 'Pick a role');
    if (String(body.password ?? '').length < 8) return fail(400, 'Password must be at least 8 characters');

    const { data: created, error } = await db.auth.admin.createUser({ email, password: body.password, email_confirm: true });
    if (error) return fail(400, /already/i.test(error.message) ? 'Someone with this email already has an account' : error.message);

    const { error: pErr } = await db.from('staff_profiles').insert({ user_id: created.user.id, outlet_id: me.outlet_id, display_name: name, role: body.role });
    if (pErr) {
      await db.auth.admin.deleteUser(created.user.id);
      return fail(500, pErr.message);
    }
    return json({ user_id: created.user.id });
  }

  if (body.action === 'set_password') {
    if (String(body.password ?? '').length < 8) return fail(400, 'Password must be at least 8 characters');
    const { data: target } = await db.from('staff_profiles').select('outlet_id').eq('user_id', body.user_id).maybeSingle();
    if (!target || target.outlet_id !== me.outlet_id) return fail(404, 'Staff member not found');
    const { error } = await db.auth.admin.updateUserById(body.user_id, { password: body.password });
    if (error) return fail(400, error.message);
    return json({ ok: true });
  }

  return fail(400, 'Unknown action');
});
