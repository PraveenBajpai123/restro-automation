import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.VITE_SUPABASE_URL;
const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

export const isConfigured = Boolean(url && anonKey && !anonKey.startsWith('replace-'));
export const OUTLET_SLUG = import.meta.env.VITE_OUTLET_SLUG || 'nbc-demo';

const make = (storageKey) =>
  isConfigured ? createClient(url, anonKey, { auth: { persistSession: true, storageKey } }) : null;

// Two independent sessions so a diner's phone-OTP login never collides with a staff login on a shared device.
export const supabase = make(`qr-${OUTLET_SLUG}-customer`); // customer menu, checkout, tracking
export const staffDb = make(`qr-${OUTLET_SLUG}-staff`); // KDS + owner console

/** Unwrap a Supabase response, throwing a readable Error. */
export function must({ data, error }) {
  if (error) throw new Error(friendlyError(error));
  return data;
}

export function friendlyError(error) {
  const msg = error?.message || String(error);
  if (/Failed to fetch|NetworkError/i.test(msg)) return 'No connection. Check your internet and try again.';
  return msg;
}
