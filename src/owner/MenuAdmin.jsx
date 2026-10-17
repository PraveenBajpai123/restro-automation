import { useState } from 'react';
import { Plus, Pencil, ImagePlus } from 'lucide-react';
import { staffDb as db, must } from '../lib/supabase';
import { formatINR, rupeesToPaise } from '../lib/money';
import { ErrorNote, Sheet, Spinner, VegMark } from '../components/ui';
import { PageTitle } from './OwnerLayout';
import { useOutletQuery } from './useOutletData';

const blankItem = { name: '', description: '', price: '', category_id: '', is_veg: true, is_bestseller: false, is_available: true, image_url: '', sort_order: 0, groupIds: [] };

function ItemEditor({ item, categories, groups, outletId, onClose, onSaved }) {
  const [form, setForm] = useState(item);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const set = (k) => (e) => setForm((f) => ({ ...f, [k]: e.target.type === 'checkbox' ? e.target.checked : e.target.value }));

  const upload = async (file) => {
    if (!file) return;
    setBusy(true);
    try {
      const path = `${outletId}/${Date.now()}-${file.name.replace(/[^\w.-]/g, '_')}`;
      must(await db.storage.from('menu-images').upload(path, file, { cacheControl: '31536000', upsert: false }));
      const { data } = db.storage.from('menu-images').getPublicUrl(path);
      setForm((f) => ({ ...f, image_url: data.publicUrl }));
    } catch (e) {
      setError(`Image upload failed: ${e.message}`);
    } finally {
      setBusy(false);
    }
  };

  const save = async (e) => {
    e.preventDefault();
    const price = rupeesToPaise(form.price);
    if (!form.name.trim() || !Number.isFinite(price) || price < 0) return setError('Enter a name and a valid price.');
    setBusy(true);
    setError(null);
    try {
      const row = {
        outlet_id: outletId,
        name: form.name.trim(),
        description: form.description.trim() || null,
        base_price_paise: price,
        category_id: form.category_id || null,
        is_veg: form.is_veg === 'na' ? null : Boolean(form.is_veg),
        is_bestseller: form.is_bestseller,
        is_available: form.is_available,
        image_url: form.image_url.trim() || null,
        sort_order: Number(form.sort_order) || 0,
      };
      const saved = form.id
        ? must(await db.from('menu_items').update(row).eq('id', form.id).select('id').single())
        : must(await db.from('menu_items').insert(row).select('id').single());
      must(await db.from('menu_item_modifier_groups').delete().eq('menu_item_id', saved.id));
      if (form.groupIds.length)
        must(await db.from('menu_item_modifier_groups').insert(form.groupIds.map((g, i) => ({ menu_item_id: saved.id, group_id: g, sort_order: i }))));
      onSaved();
    } catch (err) {
      setError(err.message);
      setBusy(false);
    }
  };

  const remove = async () => {
    if (!window.confirm(`Remove ${form.name} from the menu? Past orders keep their record.`)) return;
    try {
      must(await db.from('menu_items').update({ is_active: false }).eq('id', form.id));
      onSaved();
    } catch (e) {
      setError(e.message);
    }
  };

  return (
    <Sheet
      open
      onClose={onClose}
      title={form.id ? `Edit ${item.name}` : 'New item'}
      footer={
        <div className="flex gap-2">
          {form.id && <button type="button" className="btn-quiet text-chilli" onClick={remove}>Remove</button>}
          <button form="item-form" className="btn-primary flex-1" disabled={busy}>{busy ? 'Saving…' : 'Save item'}</button>
        </div>
      }
    >
      <form id="item-form" onSubmit={save} className="space-y-4">
        <ErrorNote>{error}</ErrorNote>
        <label className="block"><span className="label">Name</span><input className="field" value={form.name} onChange={set('name')} required /></label>
        <label className="block"><span className="label">Description</span><textarea className="field" rows={2} value={form.description} onChange={set('description')} /></label>
        <div className="grid grid-cols-2 gap-3">
          <label className="block"><span className="label">Price (₹, before GST)</span><input className="field num" inputMode="decimal" value={form.price} onChange={set('price')} required /></label>
          <label className="block">
            <span className="label">Section</span>
            <select className="field" value={form.category_id} onChange={set('category_id')}>
              <option value="">No section</option>
              {categories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
            </select>
          </label>
        </div>
        <fieldset>
          <legend className="label">Food type</legend>
          <div className="flex gap-2">
            {[[true, 'Veg'], [false, 'Non-veg'], ['na', 'Not food']].map(([v, l]) => (
              <label key={l} className={`flex cursor-pointer items-center gap-2 rounded-xl px-3 py-2 ring-1 ${String(form.is_veg) === String(v) ? 'bg-cardamom-light ring-cardamom' : 'ring-steel-300'}`}>
                <input type="radio" className="sr-only" checked={String(form.is_veg) === String(v)} onChange={() => setForm((f) => ({ ...f, is_veg: v }))} />
                {v !== 'na' && <VegMark isVeg={v} />} {l}
              </label>
            ))}
          </div>
        </fieldset>
        <div className="flex flex-wrap gap-5">
          <label className="flex items-center gap-2"><input type="checkbox" className="h-5 w-5 accent-cardamom" checked={form.is_available} onChange={set('is_available')} /> In stock</label>
          <label className="flex items-center gap-2"><input type="checkbox" className="h-5 w-5 accent-cardamom" checked={form.is_bestseller} onChange={set('is_bestseller')} /> Bestseller tag</label>
        </div>
        <div>
          <span className="label">Photo</span>
          <div className="flex items-center gap-3">
            {form.image_url && <img src={form.image_url} alt="" className="h-16 w-16 rounded-xl object-cover" />}
            <label className="btn-quiet cursor-pointer py-2 text-sm">
              <ImagePlus size={16} aria-hidden="true" /> Upload
              <input type="file" accept="image/*" className="sr-only" onChange={(e) => upload(e.target.files?.[0])} />
            </label>
            <input className="field py-2 text-sm" placeholder="or paste an image URL" value={form.image_url} onChange={set('image_url')} />
          </div>
        </div>
        <fieldset>
          <legend className="label">Sizes and add-ons</legend>
          {groups.length === 0 && <p className="text-sm text-ink-soft">Create groups on the Add-ons page first.</p>}
          <div className="space-y-1">
            {groups.map((g) => (
              <label key={g.id} className="flex items-center gap-2">
                <input
                  type="checkbox"
                  className="h-5 w-5 accent-cardamom"
                  checked={form.groupIds.includes(g.id)}
                  onChange={(e) => setForm((f) => ({ ...f, groupIds: e.target.checked ? [...f.groupIds, g.id] : f.groupIds.filter((x) => x !== g.id) }))}
                />
                {g.name} <span className="text-sm text-ink-soft">({g.modifier_options.length} options{g.min_select > 0 ? ', required' : ''})</span>
              </label>
            ))}
          </div>
        </fieldset>
        <label className="block w-32"><span className="label">Order in section</span><input className="field num" type="number" value={form.sort_order} onChange={set('sort_order')} /></label>
      </form>
    </Sheet>
  );
}

export default function MenuAdmin() {
  const cats = useOutletQuery((db, o) => db.from('menu_categories').select('*').eq('outlet_id', o).order('sort_order'));
  const items = useOutletQuery((db, o) =>
    db.from('menu_items').select('*, menu_item_modifier_groups(group_id, sort_order)').eq('outlet_id', o).eq('is_active', true).order('sort_order'),
  );
  const groups = useOutletQuery((db, o) => db.from('modifier_groups').select('*, modifier_options(id)').eq('outlet_id', o).eq('is_active', true).order('sort_order'));
  const [editing, setEditing] = useState(null);
  const [newCat, setNewCat] = useState('');

  if (!cats.rows || !items.rows || !groups.rows) return <Spinner />;

  const open = (it) =>
    setEditing(
      it
        ? {
            ...it,
            price: (it.base_price_paise / 100).toString(),
            description: it.description || '',
            image_url: it.image_url || '',
            category_id: it.category_id || '',
            is_veg: it.is_veg === null ? 'na' : it.is_veg,
            groupIds: [...it.menu_item_modifier_groups].sort((a, b) => a.sort_order - b.sort_order).map((g) => g.group_id),
          }
        : { ...blankItem, category_id: cats.rows[0]?.id || '' },
    );

  const addCategory = async (e) => {
    e.preventDefault();
    if (!newCat.trim()) return;
    const ok = await cats.mutate((db, o) => db.from('menu_categories').insert({ outlet_id: o, name: newCat.trim(), sort_order: cats.rows.length + 1 }));
    if (ok) setNewCat('');
  };

  const sections = [...cats.rows.map((c) => ({ ...c, items: items.rows.filter((i) => i.category_id === c.id) })), { id: null, name: 'No section', is_active: true, items: items.rows.filter((i) => !i.category_id) }].filter((s) => s.id || s.items.length);

  return (
    <>
      <PageTitle title="Menu" actions={<button className="btn-primary" onClick={() => open(null)}><Plus size={18} aria-hidden="true" /> New item</button>}>
        Prices are before GST. Changes appear on customers' phones immediately.
      </PageTitle>
      <ErrorNote>{cats.error || items.error}</ErrorNote>

      <div className="space-y-6">
        {sections.map((s) => (
          <section key={s.id || 'none'} className="rounded-2xl bg-white ring-1 ring-steel-200">
            <header className="flex items-center justify-between border-b border-steel-200 px-5 py-3">
              <h2 className={`text-lg font-bold ${s.is_active ? '' : 'text-ink-soft line-through'}`}>{s.name}</h2>
              {s.id && (
                <div className="flex gap-3 text-sm">
                  <button className="text-ink-soft underline" onClick={() => { const n = window.prompt('Rename section', s.name); if (n?.trim()) cats.mutate((db) => db.from('menu_categories').update({ name: n.trim() }).eq('id', s.id)); }}>Rename</button>
                  <button className="text-ink-soft underline" onClick={() => cats.mutate((db) => db.from('menu_categories').update({ is_active: !s.is_active }).eq('id', s.id))}>{s.is_active ? 'Hide' : 'Show'}</button>
                </div>
              )}
            </header>
            {s.items.length === 0 ? (
              <p className="px-5 py-4 text-sm text-ink-soft">No items in this section yet.</p>
            ) : (
              <ul className="divide-y divide-steel-200">
                {s.items.map((it) => (
                  <li key={it.id} className="flex items-center gap-3 px-5 py-3">
                    {it.image_url ? <img src={it.image_url} alt="" className="h-11 w-11 rounded-lg object-cover" /> : <div className="h-11 w-11 rounded-lg bg-steel" />}
                    <VegMark isVeg={it.is_veg} />
                    <div className="min-w-0 flex-1">
                      <p className="truncate font-semibold">{it.name}</p>
                      <p className="text-sm text-ink-soft">
                        {it.menu_item_modifier_groups.length > 0 && `${it.menu_item_modifier_groups.length} add-on group${it.menu_item_modifier_groups.length > 1 ? 's' : ''}. `}
                        {!it.is_available && <span className="font-semibold text-chilli">Out of stock</span>}
                      </p>
                    </div>
                    <span className="num font-semibold">{formatINR(it.base_price_paise)}</span>
                    <button className="rounded-lg p-2 text-ink-soft hover:bg-steel" onClick={() => open(it)} aria-label={`Edit ${it.name}`}><Pencil size={16} /></button>
                  </li>
                ))}
              </ul>
            )}
          </section>
        ))}
      </div>

      <form onSubmit={addCategory} className="mt-6 flex max-w-md gap-2">
        <input className="field" placeholder="New section, e.g. Desserts" value={newCat} onChange={(e) => setNewCat(e.target.value)} aria-label="New section name" />
        <button className="btn-quiet flex-none">Add section</button>
      </form>

      {editing && (
        <ItemEditor
          item={editing}
          categories={cats.rows}
          groups={groups.rows}
          outletId={cats.outletId}
          onClose={() => setEditing(null)}
          onSaved={() => { setEditing(null); items.reload(); }}
        />
      )}
    </>
  );
}
