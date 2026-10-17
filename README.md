# Cafe QR Ordering & Loyalty Platform

QR table ordering and takeaway tokens for Indian cafes and QSRs. It combines the operational backbone of
`ngachoan-qr-order` (Supabase + realtime kitchen display, thermal printing, owner analytics) with the customer
menu UX from `Digital-Menu-Ordering-System`, plus:

- **Sizes and paid add-ons** (Regular/Large, Extra Shot +₹40) that update the price live
- **Phone OTP and Store Coins**: earn X% back on completed orders, redeem in the cart (1 coin = ₹1)
- **Dine-in** via `/menu?table=5`, **Takeaway** with a daily token (#101 onwards) and live *Placed → Preparing → Ready for Pickup*
- **GST billing** (CGST 2.5% + SGST 2.5%, round-off, consecutive invoice numbers), **Razorpay**, **UPI app links**,
  and **Pay at Counter**, which needs staff approval on the kitchen display before cooking starts

Architecture and the migration map from the two original repos: [docs/ARCHITECTURE_AND_MIGRATION.md](docs/ARCHITECTURE_AND_MIGRATION.md).
Built from [heaventech-store/ngachoan-qr-order](https://github.com/heaventech-store/ngachoan-qr-order) and [taha-contractor/Digital-Menu-Ordering-System](https://github.com/taha-contractor/Digital-Menu-Ordering-System) (MIT; the notification sounds in `public/` come from it).

## Screens

| URL | Who | What |
|---|---|---|
| `/menu?table=5` | Diners | Menu, customise, cart, coins, checkout |
| `/menu?mode=takeaway` | Diners | Same, for self-pickup with a token |
| `/o/<tracking-key>` | Diners | Big token number, live status, pay, GST invoice PDF |
| `/login` | Staff | Email + password |
| `/kds` | Kitchen, cashier | Columns: Needs payment, New, Preparing, Ready. Printing, out-of-stock toggles |
| `/owner` | Owner, manager | Sales, Menu, Add-ons, Tables and QR, Customers, Staff, Settings |

## Run it locally

Needs Node 20+ and Docker Desktop (with about 6 GB free on the drive Docker stores images on).

```bash
npm install
```

```bash
npx supabase start
```

`supabase start` applies `supabase/migrations`, loads `seed.sql` (demo cafe) and `seed_dev_users.sql` (demo staff), and prints an
**API URL** and **anon key**. Put them in `.env`:

```bash
cp .env.example .env
```

```bash
npm run dev
```

Then open:

- Diner: http://localhost:5173/menu?table=5 (log in with phone `98765 43210`, OTP `123456`)
- Kitchen: http://localhost:5173/kds as `kitchen@demo.test` or `cashier@demo.test`
- Owner: http://localhost:5173/owner as `owner@demo.test`

All demo staff passwords are `devpassword`. Test phone numbers are in `supabase/config.toml` under `[auth.sms.test_otp]`.

Edge Functions locally (Razorpay, staff admin):

```bash
npx supabase functions serve --env-file supabase/functions/.env
```

with `supabase/functions/.env` containing `RAZORPAY_KEY_ID`, `RAZORPAY_KEY_SECRET`, `RAZORPAY_WEBHOOK_SECRET` (test-mode keys).

## Load your menu

The live menu is **Berries Café & Restaurant** (`supabase/menus/berries.json`, 279 items in 30 sections, with
syrups, plant milks, toppings, ice cream scoops, pasta sauces and veggies, paratha fillings and single/double espresso
as add-on choices). To change it in bulk, edit the JSON, then:

```bash
npm run menu:build
```

```bash
npm run test:menu
```

and run `supabase/seed_berries.sql` in the Supabase SQL Editor. It is safe to re-run: the previous menu is
retired (past orders keep their lines) and replaced. Day-to-day changes such as prices, photos and sold-out items are
easier in **Owner → Menu**.

## Tests

```bash
npm test
```

runs the bill-maths unit tests (they mirror the SQL).

```bash
npm run test:db
```

runs 51 database checks on embedded Postgres: pricing, modifier rules, GST, tokens, approvals, the Razorpay webhook path,
coin earn/burn/refund, and row-level security.

## Deploy to production

1. **Create a Supabase project** (region Mumbai `ap-south-1`), then link and push the schema:
   ```bash
   npx supabase login
   ```
   ```bash
   npx supabase link --project-ref <your-project-ref>
   ```
   ```bash
   npx supabase db push
   ```
   Do **not** run `seed_dev_users.sql` in production. To load the demo menu, run `supabase/seed.sql` in the SQL editor,
   or create your outlet row and build the menu in the owner console.
2. **Create the first owner.** In Dashboard → Authentication → Users, add a user with email + password. Then in the SQL editor:
   ```sql
   insert into staff_profiles (user_id, outlet_id, display_name, role)
   select id, (select id from outlets where slug = 'your-slug'), 'Your name', 'owner'
   from auth.users where email = 'you@yourcafe.in';
   ```
   After that, add every other staff member from **Owner → Staff**.
3. **Deploy the Edge Functions:**
   ```bash
   npx supabase functions deploy razorpay-create-order --no-verify-jwt
   ```
   ```bash
   npx supabase functions deploy razorpay-webhook --no-verify-jwt
   ```
   ```bash
   npx supabase functions deploy staff-admin
   ```
   ```bash
   npx supabase functions deploy send-sms-msg91 --no-verify-jwt
   ```
4. **Secrets** (never put these in `.env` for the frontend):
   ```bash
   npx supabase secrets set RAZORPAY_KEY_ID=rzp_live_xxx RAZORPAY_KEY_SECRET=xxx RAZORPAY_WEBHOOK_SECRET=xxx
   ```
   ```bash
   npx supabase secrets set MSG91_AUTH_KEY=xxx MSG91_TEMPLATE_ID=xxx SEND_SMS_HOOK_SECRET="v1,whsec_xxx" ALLOWED_ORIGIN=https://order.yourcafe.in
   ```
5. **Razorpay:** Dashboard → Webhooks → add `https://<ref>.supabase.co/functions/v1/razorpay-webhook` with events
   `payment.captured` and `order.paid`, using the same webhook secret. Turn on automatic capture in payment settings.
6. **Phone OTP:** Dashboard → Authentication → Providers → Phone: enable. Then Authentication → Hooks → *Send SMS* →
   HTTPS → `https://<ref>.supabase.co/functions/v1/send-sms-msg91`, and copy the hook secret into `SEND_SMS_HOOK_SECRET`.
   MSG91 needs a **DLT-registered** sender ID and an OTP template with an `##otp##` variable (TRAI rule).
7. **Frontend:** build with `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `VITE_OUTLET_SLUG` set, and host `dist/` on
   Vercel, Netlify, Cloudflare Pages or Firebase Hosting with a single-page-app rewrite to `index.html`.
8. **Kitchen printer:** run the KDS in Chrome with `--kiosk-printing` and set the 58 mm thermal printer as the default
   printer, so "Print and start" prints without a dialog.
9. **Print table QR codes** from **Owner → Tables and QR**. Turn on *Require the secret key* in Settings first if you want
   QR codes that can't be guessed.

## How money works

- All amounts are stored as integer **paise**; rates are basis points (250 = 2.5%).
- The browser sends **item and option IDs only**. `place_order()` in Postgres re-prices everything, validates the size
  and add-on rules, assigns the token, and burns coins inside one transaction.
- GST is charged on the bill **after coins** (treated as an invoice discount). Confirm this treatment with your CA.
- Coins are earned on the net pre-tax amount when the order is **completed**, and returned automatically if an order is
  rejected, cancelled, or abandoned at payment (after 15 minutes, via `pg_cron`).
- UPI-app payments can't be confirmed automatically, so they wait in **Needs payment** until a cashier checks the UTR.
  Razorpay payments are confirmed by a signature-verified webhook.

## Project layout

```
src/customer   menu, item customiser, cart, checkout, phone OTP, order status
src/staff      login, role guard, kitchen display, 58 mm print slips
src/owner      sales, menu, add-ons, tables and QR, customers, staff, settings
src/lib        supabase clients, money maths, UPI links, Razorpay, invoice PDF, sounds
supabase/      migrations, seeds, Edge Functions, database tests
```
