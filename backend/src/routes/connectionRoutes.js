import express from 'express';
import ConnectionController from '../controllers/ConnectionController.js';
import { protect } from '../middlewares/authMiddleware.js';

const router = express.Router();

router.get('/', protect, ConnectionController.getConnections);
router.post('/interest/:profileId', protect, ConnectionController.expressInterest);
router.put('/respond/:connectionId', protect, ConnectionController.respondToInterest);

export default router;
