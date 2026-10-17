import { lazy, Suspense } from 'react';
import { BrowserRouter, Navigate, Route, Routes, useLocation } from 'react-router-dom';
import { isConfigured } from './lib/supabase';
import MenuPage from './customer/MenuPage';
import OrderStatusPage from './customer/OrderStatusPage';
import { StaffProvider } from './hooks/useStaff';
import { PageLoader } from './components/ui';

// Staff and owner screens load on demand so diners on mobile data only download the menu.
const LoginPage = lazy(() => import('./staff/LoginPage'));
const RequireRole = lazy(() => import('./staff/RequireRole'));
const KdsPage = lazy(() => import('./staff/KdsPage'));
const OwnerLayout = lazy(() => import('./owner/OwnerLayout'));
const Analytics = lazy(() => import('./owner/Analytics'));
const MenuAdmin = lazy(() => import('./owner/MenuAdmin'));
const ModifiersAdmin = lazy(() => import('./owner/ModifiersAdmin'));
const TablesQr = lazy(() => import('./owner/TablesQr'));
const StaffAdmin = lazy(() => import('./owner/StaffAdmin'));
const CustomersAdmin = lazy(() => import('./owner/CustomersAdmin'));
const Settings = lazy(() => import('./owner/Settings'));

/** Old ngachoan QR codes used ?meja=; keep them working */
function LegacyRedirect() {
  const { search } = useLocation();
  const p = new URLSearchParams(search);
  if (p.get('meja') && !p.get('table')) p.set('table', p.get('meja'));
  p.delete('meja');
  return <Navigate to={`/menu?${p.toString()}`} replace />;
}

function SetupNeeded() {
  return (
    <main className="mx-auto max-w-lg p-6">
      <h1 className="text-2xl font-bold">Connect a Supabase project</h1>
      <p className="mt-3 text-ink-soft">
        Copy <code>.env.example</code> to <code>.env</code>, fill in <code>VITE_SUPABASE_URL</code> and{' '}
        <code>VITE_SUPABASE_ANON_KEY</code>, then restart <code>npm run dev</code>. The README has the full setup.
      </p>
    </main>
  );
}

export default function App() {
  if (!isConfigured) return <SetupNeeded />;
  const staff = (roles, el) => <RequireRole roles={roles}>{el}</RequireRole>;
  return (
    <BrowserRouter>
      <StaffProvider>
        <Suspense fallback={<PageLoader />}>
        <Routes>
          <Route path="/" element={<LegacyRedirect />} />
          <Route path="/menu" element={<MenuPage />} />
          <Route path="/o/:trackingKey" element={<OrderStatusPage />} />
          <Route path="/login" element={<LoginPage />} />
          <Route path="/kds" element={staff(['owner', 'manager', 'cashier', 'kitchen'], <KdsPage />)} />
          <Route path="/owner" element={staff(['owner', 'manager'], <OwnerLayout />)}>
            <Route index element={<Analytics />} />
            <Route path="menu" element={<MenuAdmin />} />
            <Route path="modifiers" element={<ModifiersAdmin />} />
            <Route path="tables" element={<TablesQr />} />
            <Route path="customers" element={<CustomersAdmin />} />
            <Route path="staff" element={staff(['owner'], <StaffAdmin />)} />
            <Route path="settings" element={staff(['owner'], <Settings />)} />
          </Route>
          <Route path="*" element={<Navigate to="/menu" replace />} />
        </Routes>
        </Suspense>
      </StaffProvider>
    </BrowserRouter>
  );
}
