import express from 'express';
import TestimonialController from '../controllers/TestimonialController.js';

const router = express.Router();

router.get('/', TestimonialController.getTestimonials);

export default router;
