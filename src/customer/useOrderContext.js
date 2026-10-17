import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';

/**
 * Where is this order going?
 *   /menu?table=5&k=ab12cd34  -> dine-in at table 5 (k only needed when outlet.require_table_key)
 *   /menu?mode=takeaway       -> takeaway / self-pickup counter QR
 *   /menu                     -> takeaway if the outlet allows it
 */
export function useOrderContext(outlet) {
  const [params] = useSearchParams();
  const table = params.get('table')?.trim() || null;
  const tableKey = params.get('k') || null;
  const requested = params.get('mode') === 'takeaway' ? 'takeaway' : table ? 'dine_in' : 'takeaway';
  const [override, setOverride] = useState(null);

  return useMemo(() => {
    if (!outlet) return null;
    let mode = override || requested;
    if (mode === 'dine_in' && (!outlet.dine_in_enabled || !table)) mode = 'takeaway';
    if (mode === 'takeaway' && !outlet.takeaway_enabled) mode = table && outlet.dine_in_enabled ? 'dine_in' : null;
    const canSwitch = Boolean(table && outlet.dine_in_enabled && outlet.takeaway_enabled);
    return {
      mode, // null => nothing orderable (e.g. takeaway off and no table in the QR)
      table,
      tableKey,
      canSwitch,
      setMode: setOverride,
      label: mode === 'dine_in' ? `Table ${table}` : 'Takeaway',
    };
  }, [outlet, override, requested, table, tableKey]);
}
