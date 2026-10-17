import { useEffect, useState } from 'react';
import { supabase, must, OUTLET_SLUG } from '../lib/supabase';

let cached = null;

export function useOutlet() {
  const [state, setState] = useState({ outlet: cached, loading: !cached, error: null });

  useEffect(() => {
    let alive = true;
    supabase
      .from('outlets')
      .select('*')
      .eq('slug', OUTLET_SLUG)
      .maybeSingle()
      .then((res) => {
        if (!alive) return;
        try {
          const outlet = must(res);
          if (!outlet) throw new Error(`No outlet with slug "${OUTLET_SLUG}". Check VITE_OUTLET_SLUG.`);
          cached = outlet;
          setState({ outlet, loading: false, error: null });
        } catch (e) {
          setState({ outlet: null, loading: false, error: e.message });
        }
      });
    return () => { alive = false; };
  }, []);

  const refresh = async () => {
    const outlet = must(await supabase.from('outlets').select('*').eq('slug', OUTLET_SLUG).single());
    cached = outlet;
    setState({ outlet, loading: false, error: null });
    return outlet;
  };

  return { ...state, refresh };
}
