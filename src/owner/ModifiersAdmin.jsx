import { useState } from 'react';
import { Plus, Trash2 } from 'lucide-react';
import { staffDb as db, must } from '../lib/supabase';
import { formatINR, rupeesToPaise } from '../lib/money';
import { ErrorNote, Sheet, Spinner } from '../components/ui';
import { PageTitle } from './OwnerLayout';
import { useOutletQuery } from './useOutletData';

const PRESETS = {
  variation: { min: 1, max: 1, hint: 'Customer must pick exactly one, e.g. Size: Regular or Large' },
  addons: { min: 0, max: 3, hint: 'Optional extras, e.g. Extra Shot, Oat Milk' },
};

function GroupEditor({ group, outletId, onClose, onSaved }) {
  const [name, setName] = useState(group.name);
  const [min, setMin] = useState(group.min_select);
  const [max, setMax] = useState(group.max_select ?? '');
  const [options, setOptions] = useState(
    (group.modifier_options || []).sort((a, b) => a.sort_order - b.sort_order).map((o) => ({ ...o, price: (o.price_delta_paise / 100).toString() })),
  );
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  const setOpt = (i, patch) => setOptions((os) => os.map((o, j) => (j === i ? { ...o, ...patch } : o)));
  const applyPreset = (p) => { setMin(PRESETS[p].min); setMax(PRESETS[p].max); };

  const save = async (e) => {
    e.preventDefault();
    const maxN = max === '' ? null : Number(max);
    if (!name.trim()) return setError('Give the group a name.');
    if (maxN !== null && maxN < Number(min)) return setError('Maximum must be at least the minimum.');
    if (options.filter((o) => !o.deleted).length < Math.max(1, Number(min))) return setError('Add enough options for customers to choose from.');
    setBusy(true); setError(null);
    try {
      const row = { outlet_id: outletId, name: name.trim(), min_select: Number(min), max_select: maxN };
      const g = group.id
        ? must(await db.from('modifier_groups').update(row).eq('id', group.id).select('id').single())
        : must(await db.from('modifier_groups').insert(row).select('id').single());
      for (const [i, o] of options.entries()) {
        if (o.deleted) {
          if (o.id) must(await db.from('modifier_options').delete().eq('id', o.id));
          continue;
        }
        const orow = { group_id: g.id, name: o.name.trim(), price_delta_paise: rupeesToPaise(o.price || 0), is_default: Boolean(o.is_default), is_available: o.is_available !== false, sort_order: i };
        if (!orow.name) continue;
        if (o.id) must(await db.from('modifier_options').update(orow).eq('id', o.id));
        else must(await db.from('modifier_options').insert(orow));
      }
      onSaved();
    } catch (err) {
      setError(err.message);
      setBusy(false);
    }
  };

  const archive = async () => {
    if (!window.confirm(`Remove "${group.name}" from every item?`)) return;
    try {
      must(await db.from('modifier_groups').update({ is_active: false }).eq('id', group.id));
      onSaved();
    } catch (e) { setError(e.message); }
  };

  return (
    <Sheet
      open
      onClose={onClose}
      title={group.id ? `Edit ${group.name}` : 'New add-on group'}
      footer={
        <div className="flex gap-2">
          {group.id && <button type="button" className="btn-quiet text-chilli" onClick={archive}>Remove group</button>}
          <button form="group-form" className="btn-primary flex-1" disabled={busy}>{busy ? 'Saving…' : 'Save group'}</button>
        </div>
      }
    >
      <form id="group-form" onSubmit={save} className="space-y-4">
        <ErrorNote>{error}</ErrorNote>
        <label className="block"><span className="label">Group name</span><input className="field" value={name} onChange={(e) => setName(e.target.value)} placeholder="Size, Milk, Add-ons, Dips" required /></label>
        <div className="flex flex-wrap gap-2">
          {Object.entries(PRESETS).map(([k, p]) => (
            <button key={k} type="button" className="btn-quiet px-3 py-2 text-sm" onClick={() => applyPreset(k)} title={p.hint}>
              {k === 'variation' ? 'Required, pick one' : 'Optional extras'}
            </button>
          ))}
        </div>
        <div className="grid grid-cols-2 gap-3">
          <label className="block"><span className="label">Customer must pick at least</span><input className="field num" type="number" min={0} value={min} onChange={(e) => setMin(e.target.value)} /></label>
          <label className="block"><span className="label">And at most (blank = any)</span><input className="field num" type="number" min={1} value={max} onChange={(e) => setMax(e.target.value)} /></label>
        </div>
        <fieldset>
          <legend className="label">Options and extra price</legend>
          <div className="space-y-2">
            {options.map((o, i) => !o.deleted && (
              <div key={o.id || `new-${i}`} className="flex items-center gap-2">
                <input className="field py-2" value={o.name} onChange={(e) => setOpt(i, { name: e.target.value })} placeholder="Option name" aria-label="Option name" />
                <span className="text-ink-soft">+₹</span>
                <input className="field num w-24 py-2" inputMode="decimal" value={o.price} onChange={(e) => setOpt(i, { price: e.target.value })} aria-label="Extra price in rupees" />
                <label className="flex items-center gap-1 text-sm" title="Selected by default"><input type="checkbox" className="accent-cardamom" checked={Boolean(o.is_default)} onChange={(e) => setOpt(i, { is_default: e.target.checked })} /> Default</label>
                <button type="button" className="rounded-lg p-2 text-ink-soft hover:bg-steel" onClick={() => setOpt(i, { deleted: true })} aria-label={`Delete ${o.name || 'option'}`}><Trash2 size={16} /></button>
              </div>
            ))}
          </div>
          <button type="button" className="mt-2 text-sm font-semibold text-cardamom" onClick={() => setOptions((os) => [...os, { name: '', price: '0', is_default: false }])}>+ Add option</button>
        </fieldset>
      </form>
    </Sheet>
  );
}

export default function ModifiersAdmin() {
  const groups = useOutletQuery((db, o) =>
    db.from('modifier_groups').select('*, modifier_options(*), menu_item_modifier_groups(menu_item_id)').eq('outlet_id', o).eq('is_active', true).order('sort_order'),
  );
  const [editing, setEditing] = useState(null);
  if (!groups.rows) return <Spinner />;

  const rule = (g) =>
    g.min_select === 1 && g.max_select === 1 ? 'Required, pick one'
      : g.min_select === 0 ? `Optional${g.max_select ? `, up to ${g.max_select}` : ''}`
      : `Pick ${g.min_select}${g.max_select ? ` to ${g.max_select}` : ' or more'}`;

  return (
    <>
      <PageTitle title="Add-ons" actions={<button className="btn-primary" onClick={() => setEditing({ name: '', min_select: 0, max_select: 3, modifier_options: [] })}><Plus size={18} aria-hidden="true" /> New group</button>}>
        Reusable groups of sizes and extras. Attach them to items on the Menu page.
      </PageTitle>
      <ErrorNote>{groups.error}</ErrorNote>
      {groups.rows.length === 0 && <p className="rounded-2xl bg-white p-6 text-ink-soft ring-1 ring-steel-200">No groups yet. Start with a Size group (Regular, Large +₹40) and an Add-ons group (Extra Shot +₹40).</p>}
      <div className="grid gap-4 lg:grid-cols-2">
        {groups.rows.map((g) => (
          <button key={g.id} onClick={() => setEditing(g)} className="rounded-2xl bg-white p-5 text-left ring-1 ring-steel-200 hover:ring-cardamom">
            <div className="flex items-baseline justify-between gap-3">
              <h2 className="text-lg font-bold">{g.name}</h2>
              <span className="text-sm text-ink-soft">{rule(g)}</span>
            </div>
            <p className="mt-2 text-sm text-ink-soft">
              {[...g.modifier_options].sort((a, b) => a.sort_order - b.sort_order).map((o) => `${o.name}${o.price_delta_paise ? ` +${formatINR(o.price_delta_paise)}` : ''}`).join(', ') || 'No options'}
            </p>
            <p className="mt-2 text-sm">Used on {g.menu_item_modifier_groups.length} item{g.menu_item_modifier_groups.length === 1 ? '' : 's'}</p>
          </button>
        ))}
      </div>
      {editing && <GroupEditor group={editing} outletId={groups.outletId} onClose={() => setEditing(null)} onSaved={() => { setEditing(null); groups.reload(); }} />}
    </>
  );
}
