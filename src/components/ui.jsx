import { useEffect, useRef } from 'react';
import { X } from 'lucide-react';

export function VegMark({ isVeg, className = '' }) {
  if (isVeg === null || isVeg === undefined) return null;
  return (
    <span
      className={`veg-mark ${isVeg ? 'text-cardamom' : 'nonveg text-chilli'} ${className}`}
      role="img"
      aria-label={isVeg ? 'Vegetarian' : 'Non-vegetarian'}
    />
  );
}

/** Accessible bottom sheet: focus trap-lite, Esc to close, scroll lock */
export function Sheet({ open, onClose, title, children, footer, labelledBy = 'sheet-title' }) {
  const ref = useRef(null);

  useEffect(() => {
    if (!open) return;
    const prev = document.activeElement;
    const onKey = (e) => e.key === 'Escape' && onClose?.();
    document.addEventListener('keydown', onKey);
    document.body.style.overflow = 'hidden';
    ref.current?.focus();
    return () => {
      document.removeEventListener('keydown', onKey);
      document.body.style.overflow = '';
      prev?.focus?.();
    };
  }, [open, onClose]);

  if (!open) return null;
  return (
    <>
      <div className="sheet-backdrop" onClick={onClose} aria-hidden="true" />
      <div ref={ref} tabIndex={-1} role="dialog" aria-modal="true" aria-labelledby={labelledBy} className="sheet outline-none">
        <div className="flex items-start justify-between gap-4 px-5 pb-2 pt-5">
          <h2 id={labelledBy} className="text-xl font-bold leading-tight">{title}</h2>
          <button onClick={onClose} className="-mr-2 -mt-1 rounded-full p-2 text-ink-soft hover:bg-steel" aria-label="Close">
            <X size={20} />
          </button>
        </div>
        <div className="flex-1 overflow-y-auto px-5 pb-4">{children}</div>
        {footer && <div className="border-t border-steel-200 px-5 py-4 pb-[max(1rem,env(safe-area-inset-bottom))]">{footer}</div>}
      </div>
    </>
  );
}

export function Stepper({ value, onChange, min = 0, max = 50, size = 'md', label }) {
  const s = size === 'sm' ? 'h-8 w-8 text-base' : 'h-10 w-10 text-lg';
  return (
    <div className="inline-flex items-center rounded-xl bg-cardamom-light text-cardamom-dark" role="group" aria-label={label}>
      <button type="button" className={`${s} rounded-xl font-bold hover:bg-cardamom/10`} onClick={() => onChange(value - 1)} disabled={value <= min} aria-label="Remove one">
        −
      </button>
      <span className="num min-w-[1.75rem] text-center font-bold" aria-live="polite">{value}</span>
      <button type="button" className={`${s} rounded-xl font-bold hover:bg-cardamom/10`} onClick={() => onChange(value + 1)} disabled={value >= max} aria-label="Add one">
        +
      </button>
    </div>
  );
}

export function Spinner({ label = 'Loading' }) {
  return (
    <div className="flex items-center justify-center p-10 text-ink-soft" role="status">
      <span className="h-5 w-5 animate-spin rounded-full border-2 border-steel-300 border-t-cardamom" />
      <span className="sr-only">{label}</span>
    </div>
  );
}

export function ErrorNote({ children, onRetry }) {
  if (!children) return null;
  return (
    <div className="rounded-xl bg-chilli-light px-4 py-3 text-sm text-chilli" role="alert">
      {children}
      {onRetry && (
        <button onClick={onRetry} className="ml-2 font-semibold underline">
          Try again
        </button>
      )}
    </div>
  );
}

export function CoinIcon({ size = 16 }) {
  return (
    <svg width={size} height={size} viewBox="0 0 16 16" aria-hidden="true">
      <circle cx="8" cy="8" r="7.5" fill="#F2B705" />
      <circle cx="8" cy="8" r="5.2" fill="none" stroke="#8A6A00" strokeWidth="1" />
      <text x="8" y="11" textAnchor="middle" fontSize="7.5" fontWeight="700" fill="#8A6A00" fontFamily="system-ui">₹</text>
    </svg>
  );
}
