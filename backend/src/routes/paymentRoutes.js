import express from 'express';
import PaymentController from '../controllers/PaymentController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

// Razorpay server-to-server webhook verified via x-razorpay-signature
router.post('/webhook', PaymentController.webhook);

router.use(protect);

router.post('/create-order', PaymentController.createOrder);
router.post('/verify', PaymentController.verifyPayment);

export default router;
