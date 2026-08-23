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
}

export default new PaymentController();
