import express from "express";
import { createOrder, verifyPayment, getMyMemberships, checkActiveMembership, getOtherMembershipsWithProfiles, getPremiumProfileById } from "./membership.controller.js";
import authMiddleware from "../../middleware/authMiddleware.js";

const router = express.Router();

// ✅ Protected routes
router.post("/create-order", authMiddleware, createOrder);
router.post("/verify-payment", authMiddleware, verifyPayment);
router.get("/mine", authMiddleware, getMyMemberships);
router.post("/check-active", authMiddleware, checkActiveMembership);
router.get("/premium-members", authMiddleware, getOtherMembershipsWithProfiles);
router.get("/premium-members/:id", getPremiumProfileById);

export default router;
