import { NavLink, Outlet, Link } from 'react-router-dom';
import { BarChart3, UtensilsCrossed, SlidersHorizontal, QrCode, Users, UserCog, Settings as Cog, MonitorPlay, LogOut } from 'lucide-react';
import { useStaff, can } from '../hooks/useStaff';

const NAV = [
  { to: '/owner', end: true, label: 'Sales', Icon: BarChart3 },
  { to: '/owner/menu', label: 'Menu', Icon: UtensilsCrossed },
  { to: '/owner/modifiers', label: 'Add-ons', Icon: SlidersHorizontal },
  { to: '/owner/tables', label: 'Tables and QR', Icon: QrCode },
  { to: '/owner/customers', label: 'Customers', Icon: Users },
  { to: '/owner/staff', label: 'Staff', Icon: UserCog, roles: ['owner'] },
  { to: '/owner/settings', label: 'Settings', Icon: Cog, roles: ['owner'] },
];

export default function OwnerLayout() {
  const { profile, signOut } = useStaff();
  return (
    <div className="min-h-dvh bg-steel-100 md:flex">
      <aside className="border-b border-steel-200 bg-white md:sticky md:top-0 md:h-dvh md:w-60 md:flex-none md:border-b-0 md:border-r">
        <div className="flex items-center justify-between px-5 py-4 md:block">
          <p className="display text-xl font-extrabold">Owner console</p>
          <p className="text-sm text-ink-soft md:mt-0.5">{profile.display_name}, {profile.role}</p>
        </div>
        <nav className="flex gap-1 overflow-x-auto px-3 pb-3 md:flex-col md:overflow-visible" aria-label="Owner sections">
          {NAV.filter((n) => !n.roles || can(profile, n.roles)).map(({ to, end, label, Icon }) => (
            <NavLink
              key={to}
              to={to}
              end={end}
              className={({ isActive }) =>
                `flex items-center gap-2.5 whitespace-nowrap rounded-xl px-3 py-2.5 text-sm font-semibold ${isActive ? 'bg-ink text-white' : 'text-ink-soft hover:bg-steel'}`
              }
            >
              <Icon size={18} aria-hidden="true" /> {label}
            </NavLink>
          ))}
          <div className="md:mt-4 md:border-t md:border-steel-200 md:pt-4" />
          <Link to="/kds" className="flex items-center gap-2.5 whitespace-nowrap rounded-xl px-3 py-2.5 text-sm font-semibold text-ink-soft hover:bg-steel">
            <MonitorPlay size={18} aria-hidden="true" /> Kitchen display
          </Link>
          <button onClick={signOut} className="flex items-center gap-2.5 whitespace-nowrap rounded-xl px-3 py-2.5 text-left text-sm font-semibold text-ink-soft hover:bg-steel">
            <LogOut size={18} aria-hidden="true" /> Sign out
          </button>
        </nav>
      </aside>
      <main className="min-w-0 flex-1 p-5 md:p-8">
        <Outlet />
      </main>
    </div>
  );
}

export function PageTitle({ title, children, actions }) {
  return (
    <div className="mb-6 flex flex-wrap items-end justify-between gap-4">
      <div>
        <h1 className="display text-3xl font-extrabold">{title}</h1>
        {children && <p className="mt-1 max-w-prose text-ink-soft">{children}</p>}
      </div>
      {actions && <div className="flex gap-2">{actions}</div>}
    </div>
  );
}
