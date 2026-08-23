import express from 'express';
import FAQController from '../controllers/FAQController.js';

const router = express.Router();

router.get('/', FAQController.getFAQs);

export default router;
