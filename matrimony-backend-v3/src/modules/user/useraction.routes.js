import express from "express";
import protect from "../../middleware/authMiddleware.js";
import {
  expressInterest,
  ignoreUser,
  shortlistUser,
  reportUser,
  undoAction,
  getMyActions,
  getReceivedInterests,
  checkInterestStatus,    // ✅ add this
  checkShortlistStatus,   // ✅ add this
} from  "./user.controller.js";

const router = express.Router();

// Action Routes
router.post("/interest/:targetUserId", protect, expressInterest);
router.post("/ignore/:targetUserId", protect, ignoreUser);
router.post("/shortlist/:targetUserId", protect, shortlistUser);
router.post("/report/:targetUserId", protect, reportUser);

// Status Check Routes (for frontend)
router.get("/interest/status/:targetUserId", protect, checkInterestStatus);
router.get("/shortlist/status/:targetUserId", protect, checkShortlistStatus);

// Undo Route
router.delete("/:actionType/:targetUserId", protect, undoAction);

// Query Routes
router.get("/my/:actionType", protect, getMyActions);
router.get("/received/interest", protect, getReceivedInterests);

export default router;