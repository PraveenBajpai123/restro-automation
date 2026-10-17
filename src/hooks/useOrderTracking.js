import { useCallback, useEffect, useRef, useState } from 'react';
import { supabase, must, OUTLET_SLUG } from '../lib/supabase';

const STORE_KEY = `orders-${OUTLET_SLUG}`;

/** Tracking keys of orders placed from this phone (newest first) */
export function rememberOrder(trackingKey, token) {
  const list = recentOrders().filter((o) => o.key !== trackingKey);
  list.unshift({ key: trackingKey, token, at: Date.now() });
  try { localStorage.setItem(STORE_KEY, JSON.stringify(list.slice(0, 20))); } catch { /* private mode */ }
}

export function recentOrders() {
  try {
    const list = JSON.parse(localStorage.getItem(STORE_KEY) || '[]');
    const dayAgo = Date.now() - 24 * 3600 * 1000;
    return list.filter((o) => o.at > dayAgo);
  } catch {
    return [];
  }
}

/** Order status via RPC + live pushes on the public broadcast topic order:<tracking_key> */
export function useOrderTracking(trackingKey, { onStatusChange } = {}) {
  const [order, setOrder] = useState(null);
  const [error, setError] = useState(null);
  const lastStatus = useRef(null);
  const cb = useRef(onStatusChange);
  cb.current = onStatusChange;

  const load = useCallback(async () => {
    try {
      const o = must(await supabase.rpc('get_order_tracking', { p_tracking_key: trackingKey }));
      if (!o) throw new Error('We could not find this order. Check the link from your receipt.');
      if (lastStatus.current && lastStatus.current !== o.status) cb.current?.(o.status, o);
      lastStatus.current = o.status;
      setOrder(o);
      setError(null);
    } catch (e) {
      setError(e.message);
    }
  }, [trackingKey]);

  useEffect(() => {
    if (!trackingKey) return;
    load();
    const channel = supabase
      .channel(`order:${trackingKey}`)
      .on('broadcast', { event: 'status' }, () => load())
      .subscribe();
    // Safety net if the socket drops (phones sleep): refresh when the tab becomes visible
    const onVisible = () => document.visibilityState === 'visible' && load();
    document.addEventListener('visibilitychange', onVisible);
    return () => {
      supabase.removeChannel(channel);
      document.removeEventListener('visibilitychange', onVisible);
    };
  }, [trackingKey, load]);

  return { order, error, reload: load };
}
