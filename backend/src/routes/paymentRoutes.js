import express from 'express';
import PaymentController from '../controllers/PaymentController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.use(protect);

router.post('/create-order', PaymentController.createOrder);
router.post('/verify', PaymentController.verifyPayment);

export default router;
