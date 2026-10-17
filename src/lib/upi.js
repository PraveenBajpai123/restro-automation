// UPI intent deep link (NPCI spec). Opens GPay / PhonePe / Paytm / BHIM.
// Payments made this way cannot be verified automatically: staff confirm the UTR on the KDS.
export function buildUpiLink({ vpa, payee, amountPaise, note, ref }) {
  const params = new URLSearchParams({ pa: vpa, pn: payee, am: (amountPaise / 100).toFixed(2), cu: 'INR', tn: note });
  if (ref) params.set('tr', ref);
  return `upi://pay?${params.toString()}`;
}

export const UPI_APPS = [
  { id: 'gpay', name: 'Google Pay', scheme: 'tez://upi/pay' },
  { id: 'phonepe', name: 'PhonePe', scheme: 'phonepe://pay' },
  { id: 'paytm', name: 'Paytm', scheme: 'paytmmp://pay' },
];

/** App-specific link; the generic upi:// link shows the phone's app chooser */
export const appLink = (app, upiLink) => (app ? upiLink.replace('upi://pay', app.scheme) : upiLink);
