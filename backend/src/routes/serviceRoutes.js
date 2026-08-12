import express from 'express';
import {
  getVendors,
  getVendorById,
  createVendor,
  updateVendor,
  deleteVendor,
} from '../controllers/serviceController.js';
import { protect, adminOnly } from '../middlewares/authMiddleware.js';

const router = express.Router();

// Public routes
router.get('/', getVendors);
router.get('/:id', getVendorById);

// Admin-only CRUD routes
router.post('/', protect, adminOnly, createVendor);
router.put('/:id', protect, adminOnly, updateVendor);
router.delete('/:id', protect, adminOnly, deleteVendor);

export default router;
