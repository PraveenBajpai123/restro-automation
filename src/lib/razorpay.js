let loading = null;

export function loadRazorpay() {
  if (window.Razorpay) return Promise.resolve();
  if (!loading) {
    loading = new Promise((resolve, reject) => {
      const s = document.createElement('script');
      s.src = 'https://checkout.razorpay.com/v1/checkout.js';
      s.onload = resolve;
      s.onerror = () => { loading = null; reject(new Error('Could not load the payment page. Check your connection.')); };
      document.head.appendChild(s);
    });
  }
  return loading;
}

/**
 * Opens Razorpay Checkout (UPI intent, cards, netbanking). Resolves 'paid' or 'dismissed'.
 * Payment is confirmed server-side by the razorpay-webhook function; the success handler only moves the UI on.
 */
export async function openRazorpay({ keyId, rzpOrderId, amountPaise, outletName, token, phone, name }) {
  await loadRazorpay();
  return new Promise((resolve) => {
    const rzp = new window.Razorpay({
      key: keyId,
      order_id: rzpOrderId,
      amount: amountPaise,
      currency: 'INR',
      name: outletName,
      description: `Order #${token}`,
      prefill: { contact: phone || undefined, name: name || undefined },
      theme: { color: '#2F6B4F' },
      config: { display: { preferences: { show_default_blocks: true } } },
      handler: () => resolve('paid'),
      modal: { ondismiss: () => resolve('dismissed'), confirm_close: true },
    });
    rzp.open();
  });
}
