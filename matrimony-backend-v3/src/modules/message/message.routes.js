

import express from "express";
import { 
  sendMessage, 
  getMessages, 
  deleteMessage,
  getAllUsersExceptMe 
} from "./message.controller.js";

const router = express.Router();

/**
 * @route   POST /api/messages/send
 * @desc    Send a new message
 */
router.post("/send", sendMessage);

/**
 * @route   GET /api/messages/users/:userId
 * @desc    Get all users except the logged-in user
 * ⚠️ MUST come before /:senderId/:receiverId to avoid route conflicts
 */
router.get("/users/:userId", getAllUsersExceptMe);

/**
 * @route   GET /api/messages/:senderId/:receiverId
 * @desc    Get all messages between two users
 */
router.get("/:senderId/:receiverId", getMessages);

/**
 * @route   DELETE /api/messages/:messageId
 * @desc    Delete a specific message
 */
router.delete("/:messageId", deleteMessage);

export default router;