import { useEffect, useState } from 'react';
import QRCode from 'qrcode';
import { jsPDF } from 'jspdf';
import { Download, Printer } from 'lucide-react';
import { ErrorNote, Spinner } from '../components/ui';
import { PageTitle } from './OwnerLayout';
import { useOutletQuery } from './useOutletData';
import { useOutlet } from '../hooks/useOutlet';

const origin = () => window.location.origin;
const tableUrl = (t, withKey) => `${origin()}/menu?table=${encodeURIComponent(t.label)}${withKey ? `&k=${t.qr_key}` : ''}`;
const takeawayUrl = () => `${origin()}/menu?mode=takeaway`;
const qrOpts = { margin: 1, width: 512, color: { dark: '#1F2A30', light: '#FFFFFF' }, errorCorrectionLevel: 'M' };

function QrCard({ title, url }) {
  const [src, setSrc] = useState(null);
  useEffect(() => { QRCode.toDataURL(url, qrOpts).then(setSrc); }, [url]);
  return (
    <figure className="flex flex-col items-center rounded-2xl bg-white p-4 ring-1 ring-steel-200">
      {src ? <img src={src} alt={`QR code for ${title}`} className="h-36 w-36" /> : <div className="h-36 w-36" />}
      <figcaption className="mt-2 text-center">
        <span className="block font-bold">{title}</span>
        <a href={url} target="_blank" rel="noreferrer" className="block max-w-[11rem] truncate text-xs text-ink-soft underline">{url.replace(/^https?:\/\//, '')}</a>
      </figcaption>
      {src && <a href={src} download={`qr-${title.replace(/\s+/g, '-').toLowerCase()}.png`} className="mt-2 text-sm font-semibold text-cardamom"><Download size={14} className="mr-1 inline" aria-hidden="true" />PNG</a>}
    </figure>
  );
}

export default function TablesQr() {
  const { outlet } = useOutlet();
  const tables = useOutletQuery((db, o) => db.from('dining_tables').select('*').eq('outlet_id', o).order('label'));
  const [from, setFrom] = useState('1');
  const [to, setTo] = useState('10');
  const [busy, setBusy] = useState(false);

  if (!tables.rows || !outlet) return <Spinner />;
  const withKey = outlet.require_table_key;
  const active = tables.rows.filter((t) => t.is_active).sort((a, b) => a.label.localeCompare(b.label, 'en', { numeric: true }));

  const addRange = async (e) => {
    e.preventDefault();
    const a = parseInt(from, 10), b = parseInt(to, 10);
    if (!(a > 0 && b >= a && b - a < 100)) return tables.setError('Enter a range like 1 to 20.');
    const byLabel = new Map(tables.rows.map((t) => [t.label, t]));
    const labels = Array.from({ length: b - a + 1 }, (_, i) => String(a + i));
    const fresh = labels.filter((l) => !byLabel.has(l)).map((label) => ({ outlet_id: tables.outletId, label }));
    const revive = labels.filter((l) => byLabel.get(l)?.is_active === false).map((l) => byLabel.get(l).id);
    if (fresh.length) await tables.mutate((db) => db.from('dining_tables').insert(fresh));
    if (revive.length) await tables.mutate((db) => db.from('dining_tables').update({ is_active: true }).in('id', revive));
  };

  const printSheet = async () => {
    setBusy(true);
    try {
      const doc = new jsPDF({ unit: 'mm', format: 'a4' });
      const cards = [{ title: 'Takeaway', url: takeawayUrl(), sub: 'Order and pick up at the counter' }, ...active.map((t) => ({ title: `Table ${t.label}`, url: tableUrl(t, withKey), sub: 'Scan to order' }))];
      const cw = 63, ch = 85, mx = 10.5, my = 12;
      for (const [i, c] of cards.entries()) {
        const pos = i % 9;
        if (i > 0 && pos === 0) doc.addPage();
        const x = mx + (pos % 3) * cw, y = my + Math.floor(pos / 3) * (ch + 5);
        doc.setDrawColor(203, 211, 214); doc.roundedRect(x + 2, y, cw - 4, ch, 4, 4);
        doc.setFont('helvetica', 'bold'); doc.setFontSize(11); doc.text(outlet.name, x + cw / 2, y + 9, { align: 'center' });
        doc.addImage(await QRCode.toDataURL(c.url, qrOpts), 'PNG', x + 11.5, y + 13, 40, 40);
        doc.setFontSize(18); doc.text(c.title, x + cw / 2, y + 63, { align: 'center' });
        doc.setFont('helvetica', 'normal'); doc.setFontSize(9); doc.text(c.sub, x + cw / 2, y + 70, { align: 'center' });
        doc.text('Earn coins on every order', x + cw / 2, y + 76, { align: 'center' });
      }
      doc.save(`${outlet.slug}-table-qr-codes.pdf`);
    } finally {
      setBusy(false);
    }
  };

  return (
    <>
      <PageTitle title="Tables and QR codes" actions={<button className="btn-primary" onClick={printSheet} disabled={busy}><Printer size={18} aria-hidden="true" /> {busy ? 'Preparing…' : 'Print all QR codes'}</button>}>
        Each table gets its own QR. The takeaway QR goes at the counter for self-pickup orders with a token number.
        {withKey && ' Table QRs carry a secret key, so reprint them if you regenerate keys.'}
      </PageTitle>
      <ErrorNote>{tables.error}</ErrorNote>

      <form onSubmit={addRange} className="mb-6 flex flex-wrap items-end gap-2">
        <label><span className="label">Add tables from</span><input className="field num w-24" value={from} onChange={(e) => setFrom(e.target.value)} inputMode="numeric" /></label>
        <label><span className="label">to</span><input className="field num w-24" value={to} onChange={(e) => setTo(e.target.value)} inputMode="numeric" /></label>
        <button className="btn-quiet">Add tables</button>
      </form>

      <div className="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
        {outlet.takeaway_enabled && <QrCard title="Takeaway" url={takeawayUrl()} />}
        {active.map((t) => (
          <div key={t.id} className="relative">
            <QrCard title={`Table ${t.label}`} url={tableUrl(t, withKey)} />
            <button className="absolute right-2 top-2 rounded-lg px-2 py-1 text-xs text-ink-soft hover:bg-steel" onClick={() => window.confirm(`Remove table ${t.label}?`) && tables.mutate((db) => db.from('dining_tables').update({ is_active: false }).eq('id', t.id))}>Remove</button>
          </div>
        ))}
      </div>
    </>
  );
}
