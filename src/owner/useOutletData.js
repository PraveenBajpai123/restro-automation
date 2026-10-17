import { useCallback, useEffect, useState } from 'react';
import { staffDb as db, must } from '../lib/supabase';
import { useStaff } from '../hooks/useStaff';

/** Small helper for owner screens: load rows for this outlet and expose reload + mutation wrapper */
export function useOutletQuery(build, deps = []) {
  const { profile } = useStaff();
  const [rows, setRows] = useState(null);
  const [error, setError] = useState(null);

  const load = useCallback(async () => {
    try {
      setRows(must(await build(db, profile.outlet_id)));
      setError(null);
    } catch (e) {
      setError(e.message);
    }
  }, [profile.outlet_id, ...deps]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => { load(); }, [load]);

  const mutate = async (fn) => {
    try {
      must(await fn(db, profile.outlet_id));
      await load();
      return true;
    } catch (e) {
      setError(e.message);
      return false;
    }
  };

  return { rows, error, setError, reload: load, mutate, outletId: profile.outlet_id };
}
