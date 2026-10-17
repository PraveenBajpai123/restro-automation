export const CUSTOMER_STEPS = ['placed', 'preparing', 'ready'];

export function customerStatusLabel(status, mode) {
  switch (status) {
    case 'awaiting_payment': return 'Waiting for payment';
    case 'awaiting_approval': return 'Waiting for the counter to confirm';
    case 'placed': return 'Placed';
    case 'preparing': return 'Preparing';
    case 'ready': return mode === 'takeaway' ? 'Ready for pickup' : 'On its way to your table';
    case 'completed': return mode === 'takeaway' ? 'Picked up' : 'Served';
    case 'cancelled': return 'Cancelled';
    case 'rejected': return 'Not accepted';
    default: return status;
  }
}

export const isFinal = (s) => ['completed', 'cancelled', 'rejected'].includes(s);

export const paymentLabel = (method) =>
  ({ razorpay: 'Paid online', upi_intent: 'UPI', pay_at_counter: 'Pay at counter' })[method] || method;
