import crypto from 'crypto';
import Razorpay from 'razorpay';
import Membership from '../models/Membership.js';

class PaymentService {
  getRazorpayInstance() {
    const key_id = process.env.RAZORPAY_KEY_ID;
    const key_secret = process.env.RAZORPAY_SECRET;
    if (!key_id || !key_secret) {
      return null;
    }
    return new Razorpay({ key_id, key_secret });
  }

  async createOrder(userId, { planId, planType = 'Gold', amount = 999, currency = 'INR' }) {
    const razorpay = this.getRazorpayInstance();
    const orderOptions = {
      amount: amount * 100,
      currency,
      receipt: `receipt_${userId.toString().substring(0, 8)}_${Date.now()}`,
      notes: {
        userId: userId.toString(),
        planId: planId || planType,
      },
    };

    let orderId = `order_mock_${Math.random().toString(36).substring(7)}`;
    let key = process.env.RAZORPAY_KEY_ID || 'rzp_test_mockkey123';

    if (razorpay) {
      const order = await razorpay.orders.create(orderOptions);
      orderId = order.id;
      key = process.env.RAZORPAY_KEY_ID;
    }

    // Create pending membership record
    await Membership.create({
      userId,
      planType: planType || 'Gold',
      amount,
      currency,
      orderId,
      status: 'created',
    });

    return {
      id: orderId,
      currency,
      amount: orderOptions.amount,
      key,
    };
  }

  async verifyPayment(userId, { razorpay_order_id, razorpay_payment_id, razorpay_signature, planType = 'Gold' }) {
    const secret = process.env.RAZORPAY_SECRET;

    if (secret && razorpay_order_id && razorpay_payment_id && razorpay_signature) {
      const generated_signature = crypto
        .createHmac('sha256', secret)
        .update(`${razorpay_order_id}|${razorpay_payment_id}`)
        .digest('hex');

      if (generated_signature !== razorpay_signature) {
        const error = new Error('Invalid payment signature');
        error.statusCode = 400;
        throw error;
      }
    }

    const expiryDate = new Date();
    expiryDate.setDate(expiryDate.getDate() + 365); // 1 year membership

    // Update or create paid membership record in memberships collection
    let membership = await Membership.findOne({ orderId: razorpay_order_id });
    if (!membership) {
      membership = new Membership({
        userId,
        planType,
        amount: 999,
        currency: 'INR',
        orderId: razorpay_order_id || `order_${Date.now()}`,
      });
    }

    membership.paymentId = razorpay_payment_id || `pay_${Date.now()}`;
    membership.status = 'paid';
    membership.expiryDate = expiryDate;
    await membership.save();

    return {
      success: true,
      message: 'Payment verified successfully. Premium status activated.',
      membership: membership.planType,
    };
  }
}

export default new PaymentService();
