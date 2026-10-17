import { useCallback, useEffect, useState } from 'react';
import { supabase, must } from '../lib/supabase';

/**
 * Phone-OTP customer session + coin wallet.
 * Staff sessions (email login) are ignored here: a staff member ordering a coffee isn't a loyalty customer.
 */
export function useCustomer() {
  const [session, setSession] = useState(null);
  const [wallet, setWallet] = useState(null);
  const [ready, setReady] = useState(false);

  const loadWallet = useCallback(async () => {
    const w = must(await supabase.rpc('get_my_wallet'));
    setWallet(w);
    return w;
  }, []);

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      setSession(data.session);
      setReady(true);
    });
    const { data: sub } = supabase.auth.onAuthStateChange((_e, s) => setSession(s));
    return () => sub.subscription.unsubscribe();
  }, []);

  const isPhoneUser = Boolean(session?.user?.phone);

  useEffect(() => {
    if (isPhoneUser) loadWallet().catch(() => setWallet(null));
    else setWallet(null);
  }, [isPhoneUser, loadWallet]);

  const sendOtp = async (phone) => {
    must(await supabase.auth.signInWithOtp({ phone }));
  };

  const verifyOtp = async (phone, token, name) => {
    must(await supabase.auth.verifyOtp({ phone, token, type: 'sms' }));
    must(await supabase.rpc('upsert_my_customer', { p_name: name || null }));
    return loadWallet();
  };

  const signOut = async () => {
    await supabase.auth.signOut();
    setWallet(null);
  };

  return { ready, session, isPhoneUser, wallet, sendOtp, verifyOtp, signOut, refreshWallet: loadWallet };
}

/** "+91 98765 43210" → "+919876543210"; 10-digit Indian numbers get +91 */
export function normalisePhone(input) {
  const digits = String(input).replace(/[^\d+]/g, '');
  if (/^\+[1-9]\d{7,14}$/.test(digits)) return digits;
  const d = digits.replace(/\D/g, '');
  if (/^[6-9]\d{9}$/.test(d)) return `+91${d}`;
  if (/^91[6-9]\d{9}$/.test(d)) return `+${d}`;
  return null;
}
