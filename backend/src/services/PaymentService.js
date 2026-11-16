import crypto from 'crypto';
import Razorpay from 'razorpay';
import Membership from '../models/Membership.js';

const PLAN_CATALOG = {
  Silver: { amount: 999, currency: 'INR', durationDays: 365 },
  Gold: { amount: 2499, currency: 'INR', durationDays: 365 },
  Platinum: { amount: 4999, currency: 'INR', durationDays: 365 },
};

function timingSafeHexCompare(expectedHex, providedHex) {
  if (typeof expectedHex !== 'string' || typeof providedHex !== 'string') {
    return false;
  }
  const expectedBuf = Buffer.from(expectedHex, 'utf8');
  const providedBuf = Buffer.from(providedHex, 'utf8');
  if (expectedBuf.length !== providedBuf.length) {
    return false;
  }
  return crypto.timingSafeEqual(expectedBuf, providedBuf);
}

class PaymentService {
  getRazorpayConfig() {
    const key_id = process.env.RAZORPAY_KEY_ID?.trim();
    const key_secret = process.env.RAZORPAY_SECRET?.trim();
    if (!key_id || !key_secret) {
      const error = new Error('Payment gateway is not configured on the server');
      error.statusCode = 503;
      throw error;
    }
    return {
      keyId: key_id,
      keySecret: key_secret,
      client: new Razorpay({ key_id, key_secret }),
    };
  }

  async createOrder(userId, { planId, planType = 'Gold' }) {
    const resolvedPlan = PLAN_CATALOG[planType]
      ? planType
      : PLAN_CATALOG[planId]
        ? planId
        : null;

    if (!resolvedPlan) {
      const error = new Error('Invalid membership plan selected');
      error.statusCode = 400;
      throw error;
    }

    const plan = PLAN_CATALOG[resolvedPlan];
    const { keyId, client } = this.getRazorpayConfig();

    const orderOptions = {
      amount: plan.amount * 100,
      currency: plan.currency,
      receipt: `rcpt_${userId.toString().substring(0, 8)}_${Date.now()}`,
      notes: {
        userId: userId.toString(),
        planType: resolvedPlan,
      },
    };

    const order = await client.orders.create(orderOptions);

    await Membership.create({
      userId,
      planType: resolvedPlan,
      amount: plan.amount,
      currency: plan.currency,
      orderId: order.id,
      status: 'created',
    });

    return {
      id: order.id,
      currency: plan.currency,
      amount: orderOptions.amount,
      planType: resolvedPlan,
      key: keyId,
    };
  }

  async verifyPayment(userId, { razorpay_order_id, razorpay_payment_id, razorpay_signature }) {
    if (!razorpay_order_id || !razorpay_payment_id || !razorpay_signature) {
      const error = new Error('Missing required Razorpay verification fields');
      error.statusCode = 400;
      throw error;
    }

    const { keySecret, client } = this.getRazorpayConfig();

    const generatedSignature = crypto
      .createHmac('sha256', keySecret)
      .update(`${razorpay_order_id}|${razorpay_payment_id}`)
      .digest('hex');

    if (!timingSafeHexCompare(generatedSignature, razorpay_signature)) {
      const error = new Error('Invalid payment signature');
      error.statusCode = 400;
      throw error;
    }

    const membership = await Membership.findOne({ orderId: razorpay_order_id });
    if (!membership) {
      const error = new Error('Payment order not found');
      error.statusCode = 404;
      throw error;
    }

    if (membership.userId.toString() !== userId.toString()) {
      const error = new Error('Unauthorized payment verification attempt');
      error.statusCode = 403;
      throw error;
    }

    if (membership.status === 'paid') {
      if (membership.paymentId === razorpay_payment_id) {
        return {
          success: true,
          message: 'Payment already verified. Premium status active.',
          membership: membership.planType,
        };
      }
      const error = new Error('Order has already been settled with another payment');
      error.statusCode = 409;
      throw error;
    }

    const payment = await client.payments.fetch(razorpay_payment_id);
    if (
      !payment ||
      payment.order_id !== razorpay_order_id ||
      Number(payment.amount) !== membership.amount * 100 ||
      payment.currency !== membership.currency ||
      !['captured', 'authorized'].includes(payment.status)
    ) {
      const error = new Error('Payment verification failed against Razorpay records');
      error.statusCode = 400;
      throw error;
    }

    const durationDays = PLAN_CATALOG[membership.planType]?.durationDays ?? 365;
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + durationDays);

    membership.paymentId = razorpay_payment_id;
    membership.status = 'paid';
    membership.expiryDate = expiryDate;
    await membership.save();

    return {
      success: true,
      message: 'Payment verified successfully. Premium status activated.',
      membership: membership.planType,
    };
  }

  async handleWebhook(rawBody, signature) {
    const webhookSecret = process.env.RAZORPAY_WEBHOOK_SECRET?.trim();
    if (!webhookSecret) {
      const error = new Error('Razorpay webhook secret is not configured');
      error.statusCode = 503;
      throw error;
    }
    if (!rawBody || !signature) {
      const error = new Error('Missing webhook body or signature');
      error.statusCode = 400;
      throw error;
    }

    const expectedSignature = crypto
      .createHmac('sha256', webhookSecret)
      .update(rawBody)
      .digest('hex');

    if (!timingSafeHexCompare(expectedSignature, signature)) {
      const error = new Error('Invalid webhook signature');
      error.statusCode = 400;
      throw error;
    }

    const event = JSON.parse(rawBody.toString('utf8'));
    if (event.event !== 'payment.captured' && event.event !== 'order.paid') {
      return { received: true, ignored: true };
    }

    const paymentEntity = event.payload?.payment?.entity;
    const orderId = paymentEntity?.order_id;
    const paymentId = paymentEntity?.id;
    if (!orderId || !paymentId) {
      return { received: true, ignored: true };
    }

    const membership = await Membership.findOne({ orderId });
    if (!membership || membership.status === 'paid') {
      return { received: true, processed: false };
    }
    if (Number(paymentEntity.amount) !== membership.amount * 100) {
      const error = new Error('Webhook amount mismatch');
      error.statusCode = 400;
      throw error;
    }

    const durationDays = PLAN_CATALOG[membership.planType]?.durationDays ?? 365;
    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + durationDays);

    membership.paymentId = paymentId;
    membership.status = 'paid';
    membership.expiryDate = expiryDate;
    await membership.save();

    return { received: true, processed: true };
  }
}

export default new PaymentService();
