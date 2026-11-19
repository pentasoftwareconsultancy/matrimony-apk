import PaymentService from '../services/PaymentService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class PaymentController {
  async createOrder(req, res, next) {
    try {
      const userId = req.user.id;
      const result = await PaymentService.createOrder(userId, req.body);
      return ApiResponse.success(res, 'Payment order created successfully', result);
    } catch (err) {
      next(err);
    }
  }

  async verifyPayment(req, res, next) {
    try {
      const userId = req.user.id;
      const result = await PaymentService.verifyPayment(userId, req.body);
      return ApiResponse.success(res, result.message, result);
    } catch (err) {
      next(err);
    }
  }

  async webhook(req, res, next) {
    try {
      const signature = req.headers['x-razorpay-signature'];
      const result = await PaymentService.handleWebhook(req.rawBody, signature);
      return ApiResponse.success(res, 'Webhook handled', result);
    } catch (err) {
      next(err);
    }
  }
}

export default new PaymentController();
