import { Navigate, useLocation } from 'react-router-dom';
import { useStaff, can } from '../hooks/useStaff';
import { Spinner } from '../components/ui';

/** UX guard only. The database enforces the same roles through RLS and role-checked RPCs. */
export default function RequireRole({ roles, children }) {
  const { loading, profile, signOut } = useStaff();
  const location = useLocation();
  if (loading) return <Spinner />;
  if (!profile) return <Navigate to="/login" replace state={{ from: location.pathname }} />;
  if (!can(profile, roles))
    return (
      <main className="mx-auto max-w-md p-8 text-center">
        <h1 className="text-xl font-bold">This page needs a different role</h1>
        <p className="mt-2 text-ink-soft">You are signed in as {profile.display_name} ({profile.role}).</p>
        <div className="mt-5 flex justify-center gap-3">
          <a href="/kds" className="btn-quiet">Open kitchen display</a>
          <button className="btn-quiet" onClick={signOut}>Sign out</button>
        </div>
      </main>
    );
  return children;
}
