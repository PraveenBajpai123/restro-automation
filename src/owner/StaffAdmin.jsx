import { useState } from 'react';
import { Plus } from 'lucide-react';
import { staffDb as db } from '../lib/supabase';
import { useStaff } from '../hooks/useStaff';
import { ErrorNote, Sheet, Spinner } from '../components/ui';
import { PageTitle } from './OwnerLayout';
import { useOutletQuery } from './useOutletData';

const ROLES = [
  { id: 'kitchen', label: 'Kitchen', detail: 'Kitchen display: cook, mark ready, mark out of stock' },
  { id: 'cashier', label: 'Cashier', detail: 'Kitchen display plus approving counter and UPI payments' },
  { id: 'manager', label: 'Manager', detail: 'Everything above plus menu, tables, customers and sales' },
  { id: 'owner', label: 'Owner', detail: 'Everything, including staff and outlet settings' },
];

async function callStaffAdmin(body) {
  const res = await db.functions.invoke('staff-admin', { body });
  if (res.error) {
    let msg = res.error.message;
    try { msg = (await res.error.context.json()).error || msg; } catch { /* keep */ }
    throw new Error(msg);
  }
  return res.data;
}

function AddStaffSheet({ onClose, onSaved }) {
  const [form, setForm] = useState({ display_name: '', email: '', password: '', role: 'kitchen' });
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);
  const set = (k) => (e) => setForm((f) => ({ ...f, [k]: e.target.value }));

  const save = async (e) => {
    e.preventDefault();
    if (form.password.length < 8) return setError('Use a password of at least 8 characters.');
    setBusy(true); setError(null);
    try {
      await callStaffAdmin({ action: 'create', ...form });
      onSaved();
    } catch (err) {
      setError(err.message);
      setBusy(false);
    }
  };

  return (
    <Sheet open onClose={onClose} title="Add a staff member" footer={<button form="staff-form" className="btn-primary w-full" disabled={busy}>{busy ? 'Adding…' : 'Add staff member'}</button>}>
      <form id="staff-form" onSubmit={save} className="space-y-4">
        <label className="block"><span className="label">Name</span><input className="field" value={form.display_name} onChange={set('display_name')} required /></label>
        <label className="block"><span className="label">Email (used to sign in)</span><input className="field" type="email" value={form.email} onChange={set('email')} required autoComplete="off" /></label>
        <label className="block"><span className="label">Temporary password</span><input className="field" type="text" value={form.password} onChange={set('password')} required autoComplete="new-password" /></label>
        <fieldset>
          <legend className="label">Role</legend>
          <div className="space-y-2">
            {ROLES.map((r) => (
              <label key={r.id} className={`flex cursor-pointer gap-3 rounded-xl px-3 py-2.5 ring-1 ${form.role === r.id ? 'bg-cardamom-light ring-cardamom' : 'ring-steel-200'}`}>
                <input type="radio" name="role" className="mt-1 accent-cardamom" checked={form.role === r.id} onChange={() => setForm((f) => ({ ...f, role: r.id }))} />
                <span><span className="block font-semibold">{r.label}</span><span className="block text-sm text-ink-soft">{r.detail}</span></span>
              </label>
            ))}
          </div>
        </fieldset>
        <ErrorNote>{error}</ErrorNote>
      </form>
    </Sheet>
  );
}

export default function StaffAdmin() {
  const { profile } = useStaff();
  const staff = useOutletQuery((db, o) => db.from('staff_profiles').select('*').eq('outlet_id', o).order('created_at'));
  const [adding, setAdding] = useState(false);
  const [error, setError] = useState(null);

  if (!staff.rows) return <Spinner />;

  const update = (id, patch) => staff.mutate((db) => db.from('staff_profiles').update(patch).eq('user_id', id));
  const resetPassword = async (s) => {
    const password = window.prompt(`New password for ${s.display_name} (at least 8 characters)`);
    if (!password) return;
    try {
      await callStaffAdmin({ action: 'set_password', user_id: s.user_id, password });
      window.alert('Password updated.');
    } catch (e) {
      setError(e.message);
    }
  };

  return (
    <>
      <PageTitle title="Staff" actions={<button className="btn-primary" onClick={() => setAdding(true)}><Plus size={18} aria-hidden="true" /> Add staff</button>}>
        Staff sign in at /login. Turning someone off signs them out of the kitchen display on their next action.
      </PageTitle>
      <ErrorNote>{staff.error || error}</ErrorNote>
      <div className="overflow-x-auto rounded-2xl bg-white ring-1 ring-steel-200">
        <table className="w-full text-sm">
          <thead className="bg-steel-100 text-left text-ink-soft"><tr><th className="px-4 py-2.5 font-medium">Name</th><th className="px-4 py-2.5 font-medium">Role</th><th className="px-4 py-2.5 font-medium">Access</th><th className="px-4 py-2.5" /></tr></thead>
          <tbody>
            {staff.rows.map((s) => {
              const me = s.user_id === profile.user_id;
              return (
                <tr key={s.user_id} className="border-t border-steel-200">
                  <td className="px-4 py-2.5 font-semibold">{s.display_name}{me && <span className="font-normal text-ink-soft"> (you)</span>}</td>
                  <td className="px-4 py-2.5">
                    <select className="field py-1.5" value={s.role} disabled={me} onChange={(e) => update(s.user_id, { role: e.target.value })} aria-label={`Role for ${s.display_name}`}>
                      {ROLES.map((r) => <option key={r.id} value={r.id}>{r.label}</option>)}
                    </select>
                  </td>
                  <td className="px-4 py-2.5">
                    <label className="flex items-center gap-2"><input type="checkbox" className="h-5 w-5 accent-cardamom" checked={s.is_active} disabled={me} onChange={(e) => update(s.user_id, { is_active: e.target.checked })} /> {s.is_active ? 'Active' : 'Off'}</label>
                  </td>
                  <td className="px-4 py-2.5 text-right"><button className="text-ink-soft underline" onClick={() => resetPassword(s)}>Reset password</button></td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
      {adding && <AddStaffSheet onClose={() => setAdding(false)} onSaved={() => { setAdding(false); staff.reload(); }} />}
    </>
  );
}
