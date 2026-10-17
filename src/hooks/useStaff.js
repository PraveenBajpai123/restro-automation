import { createContext, useContext, useEffect, useState, createElement } from 'react';
import { staffDb as supabase } from '../lib/supabase';

const StaffContext = createContext(null);

/** Email/password staff session + their staff_profiles row (role, outlet) */
export function StaffProvider({ children }) {
  const [state, setState] = useState({ loading: true, session: null, profile: null });

  useEffect(() => {
    let alive = true;
    const resolve = async (session) => {
      if (!session) {
        if (alive) setState({ loading: false, session: null, profile: null });
        return;
      }
      const { data } = await supabase
        .from('staff_profiles')
        .select('user_id, outlet_id, display_name, role, is_active')
        .eq('user_id', session.user.id)
        .maybeSingle();
      if (alive) setState({ loading: false, session, profile: data?.is_active ? data : null });
    };
    supabase.auth.getSession().then(({ data }) => resolve(data.session));
    const { data: sub } = supabase.auth.onAuthStateChange((_e, s) => {
      setTimeout(() => resolve(s), 0); // avoid calling supabase inside the auth callback
    });
    return () => {
      alive = false;
      sub.subscription.unsubscribe();
    };
  }, []);

  const signIn = async (email, password) => {
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) throw new Error(error.message === 'Invalid login credentials' ? 'Wrong email or password.' : error.message);
  };
  const signOut = () => supabase.auth.signOut();

  return createElement(StaffContext.Provider, { value: { ...state, signIn, signOut } }, children);
}

export const useStaff = () => useContext(StaffContext);

export const can = (profile, roles) => Boolean(profile && roles.includes(profile.role));
