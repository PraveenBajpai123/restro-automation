import { useState } from 'react';
import { Navigate, useLocation } from 'react-router-dom';
import { useStaff } from '../hooks/useStaff';
import { ErrorNote } from '../components/ui';

export default function LoginPage() {
  const { session, profile, loading, signIn, signOut } = useStaff();
  const location = useLocation();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState(null);

  if (!loading && profile) {
    const home = ['owner', 'manager'].includes(profile.role) && !location.state?.from?.startsWith('/kds') ? '/owner' : '/kds';
    return <Navigate to={location.state?.from || home} replace />;
  }

  const submit = async (e) => {
    e.preventDefault();
    setBusy(true);
    setError(null);
    try {
      await signIn(email.trim(), password);
    } catch (err) {
      setError(err.message);
    } finally {
      setBusy(false);
    }
  };

  return (
    <main className="flex min-h-dvh items-center justify-center bg-ink p-5">
      <form onSubmit={submit} className="w-full max-w-sm rounded-3xl bg-white p-7 shadow-2xl">
        <h1 className="display text-3xl font-extrabold">Staff sign in</h1>
        <p className="mt-1 text-ink-soft">Kitchen display and owner console</p>
        {session && !profile && !loading && (
          <div className="mt-5">
            <ErrorNote>
              {session.user.email} is not set up as staff for this outlet. Ask the owner to add you.{' '}
              <button type="button" className="font-semibold underline" onClick={signOut}>Sign out</button>
            </ErrorNote>
          </div>
        )}
        <label className="mt-6 block">
          <span className="label">Email</span>
          <input className="field" type="email" autoComplete="username" required value={email} onChange={(e) => setEmail(e.target.value)} />
        </label>
        <label className="mt-4 block">
          <span className="label">Password</span>
          <input className="field" type="password" autoComplete="current-password" required value={password} onChange={(e) => setPassword(e.target.value)} />
        </label>
        <div className="mt-4"><ErrorNote>{error}</ErrorNote></div>
        <button className="btn-primary mt-5 w-full" disabled={busy}>{busy ? 'Signing in…' : 'Sign in'}</button>
      </form>
    </main>
  );
}
