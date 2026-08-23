

// src/routes/notificationRoutes.js
import express from "express";
import authMiddleware from '../../middleware/authMiddleware.js';
import {
  createNotification,
  getNotificationsForUser,
  markAsRead,
  deleteNotification,
  sendInterest,
  sendProfileActivity,
  getUserNotifications,
  markAllAsRead,
  deleteAllNotifications,
  generateMatchNotifications,
  getDirectMessages,
  sendDirectMessage,
  getNotificationsForMessage,
  setSocketEmitter, // Import to set emitter
} from "./notification.controller.js";

const router = express.Router();

// Set socket emitter (call this after socket setup in app.js)
router.use((req, res, next) => {
  setSocketEmitter(req.app.get('socketEmitter')); // Set from app
  next();
});

/**
 * @route   POST /api/notifications
 * @desc    Create a new notification
 */
router.post("/", authMiddleware, createNotification);

router.post("/interest", authMiddleware, sendInterest);
router.post("/profile-activity",authMiddleware, sendProfileActivity);
router.get("/:userId", authMiddleware, getNotificationsForUser);
router.get("/profileactivityget/:userid", authMiddleware, getUserNotifications);

router.patch("/read/:notificationId", authMiddleware, markAsRead);

/**
 * @route   PATCH /api/notifications/read-all/:userId
 * @desc    Mark all notifications as read
 */
router.patch("/read-all/:userId", authMiddleware, markAllAsRead);

/**
 * @route   DELETE /api/notifications/:notificationId
 * @desc    Delete a notification
 */
router.delete("/:notificationId", authMiddleware, deleteNotification);

/**
 * @route   DELETE /api/notifications/all/:userId
 * @desc    Delete all notifications for user
 */
router.delete("/all/:userId", authMiddleware, deleteAllNotifications);

/**
 * @route   POST /api/notifications/generate-match/:userId
 * @desc    Generate match notifications
 */
router.post("/generate-match/:userId", authMiddleware, generateMatchNotifications);

// Get messages between two users
router.get("/messages/:userId/:otherUserId", getDirectMessages);

// Send a direct message
router.post("/messages/send", sendDirectMessage);

// Get notifications with sender info
router.get("/notifications/:userId", getNotificationsForMessage);


export default router;