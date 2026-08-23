// src/controllers/notificationController.js
import {
  AppError,
  setSocketEmitter,
  createNotification as createNotificationService,
  sendInterestNotification,
  sendProfileActivityNotification,
  getUserProfileActivityNotifications,
  getNotificationsForUser as getNotificationsForUserService,
  markNotificationAsRead,
  markAllNotificationsAsRead,
  deleteNotificationById,
  deleteAllUserNotifications,
  generateMatchNotifications as generateMatchNotificationsService,
  getConversation,
  createDirectMessage,
  getNotificationsForMessage as getNotificationsForMessageService,
} from "./notification.service.js";

// Re-export so socketHandler can keep wiring the emitter through the controller,
// same as before.
export { setSocketEmitter };

// Sends a consistent error response, mirroring the original per-handler
// `error.status || 500` pattern.
const handleError = (res, error, label, fallbackMessage = "Internal error") => {
  console.error(label, error);
  const status = error instanceof AppError ? error.status : error.status || 500;
  return res.status(status).json({ message: error.message || fallbackMessage });
};

/* ------------------------------------------------------------------
   NOTIFICATION CONTROLLER
-------------------------------------------------------------------*/

// Create a new notification for a user
export const createNotification = async (req, res) => {
  try {
    const { userId, type, message } = req.body;
    const notification = await createNotificationService({ userId, type, message });
    return res.status(201).json(notification);
  } catch (error) {
    return handleError(res, error, "Error in createNotification:");
  }
};

// Send interest notification
export const sendInterest = async (req, res) => {
  try {
    const { fromUserId, toUserId } = req.body;
    await sendInterestNotification(fromUserId, toUserId);
    return res.status(201).json({ message: "Interest sent successfully" });
  } catch (error) {
    return handleError(res, error, "Error in sendInterest:");
  }
};

export const sendProfileActivity = async (req, res) => {
  try {
    const { fromUserId, toUserId } = req.body;
    const notification = await sendProfileActivityNotification(fromUserId, toUserId);
    return res.status(201).json({
      message: "Profile activity notification sent successfully",
      notification,
    });
  } catch (error) {
    return handleError(res, error, "❌ Error in sendProfileActivity:");
  }
};

export const getUserNotifications = async (req, res) => {
  try {
    const { userid } = req.params;
    const notifications = await getUserProfileActivityNotifications(userid);
    return res.status(200).json({
      message: "Profile activity notifications retrieved successfully",
      count: notifications.length,
      notifications,
    });
  } catch (error) {
    console.error("❌ Error in getUserNotifications:", error);
    const status = error instanceof AppError ? error.status : 500;
    return res.status(status).json({
      message: status === 500 ? "Internal server error" : error.message,
      error: error.message,
    });
  }
};

// Get all notifications for current user
export const getNotificationsForUser = async (req, res) => {
  try {
    const { userId } = req.params;
    const notifications = await getNotificationsForUserService(
      userId,
      req.user?.id
    );
    return res.json(notifications);
  } catch (error) {
    return handleError(res, error, "❌ Error in getNotificationsForUser:");
  }
};

// Mark notification as read
export const markAsRead = async (req, res) => {
  try {
    const { notificationId } = req.params;
    const updated = await markNotificationAsRead(notificationId);
    return res.json(updated);
  } catch (error) {
    return handleError(res, error, "Error in markAsRead:");
  }
};

// Mark all notifications as read
export const markAllAsRead = async (req, res) => {
  try {
    const { userId } = req.params;
    const updatedCount = await markAllNotificationsAsRead(userId);
    return res.json({
      message: "All notifications marked as read",
      updatedCount,
    });
  } catch (error) {
    return handleError(res, error, "Error in markAllAsRead:");
  }
};

// Delete a notification
export const deleteNotification = async (req, res) => {
  try {
    const { notificationId } = req.params;
    await deleteNotificationById(notificationId);
    return res.json({ message: "Notification deleted" });
  } catch (error) {
    return handleError(res, error, "Error in deleteNotification:");
  }
};

// Delete all notifications for user
export const deleteAllNotifications = async (req, res) => {
  try {
    const { userId } = req.params;
    const deletedCount = await deleteAllUserNotifications(userId);
    return res.json({
      message: "All notifications deleted",
      deletedCount,
    });
  } catch (error) {
    return handleError(res, error, "Error in deleteAllNotifications:");
  }
};

// Generate match notifications (two-way: A ⇔ B)
export const generateMatchNotifications = async (req, res) => {
  try {
    const { userId } = req.params;
    const matches = await generateMatchNotificationsService(userId);
    return res.json({ matches, count: matches.length });
  } catch (error) {
    console.error("Error in generateMatchNotifications:", error);
    const status = error instanceof AppError ? error.status : 500;
    return res.status(status).json({ message: error.message || "Internal error" });
  }
};

/* ------------------------------------------------------------------
   DIRECT MESSAGES
-------------------------------------------------------------------*/

// Get direct message conversation between two users
export const getDirectMessages = async (req, res) => {
  try {
    const { userId, otherUserId } = req.params;
    const result = await getConversation(userId, otherUserId);
    return res.status(200).json(result);
  } catch (error) {
    console.error("Error fetching messages:", error);
    const status = error instanceof AppError ? error.status : 500;
    return res
      .status(status)
      .json({ message: status === 500 ? "Internal server error" : error.message });
  }
};

export const sendDirectMessage = async (req, res) => {
  try {
    if (!req.body) {
      return res.status(400).json({ message: "Request body is missing" });
    }

    const { senderId, receiverId, content } = req.body;
    const newMessage = await createDirectMessage({ senderId, receiverId, content });

    return res.status(201).json({
      message: "Message sent successfully",
      newMessage,
    });
  } catch (error) {
    console.error("Error sending message:", error);
    const status = error instanceof AppError ? error.status : 500;
    return res
      .status(status)
      .json({ message: status === 500 ? "Internal server error" : error.message });
  }
};

export const getNotificationsForMessage = async (req, res) => {
  try {
    const { userId } = req.params;
    const notifications = await getNotificationsForMessageService(userId);
    return res.status(200).json({ notifications });
  } catch (error) {
    console.error("Error fetching notifications:", error);
    const status = error instanceof AppError ? error.status : 500;
    return res
      .status(status)
      .json({ message: status === 500 ? "Internal server error" : error.message });
  }
};