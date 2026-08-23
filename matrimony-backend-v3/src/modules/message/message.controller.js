// src/controllers/messageController.js
import {
  AppError,
  getAllUsersExceptMe as getAllUsersExceptMeService,
  persistMessage,
  getMessagesBetween,
  deleteMessageById,
} from "./message.service.js";

const handleError = (res, error, label) => {
  console.error(label, error);
  const status = error instanceof AppError ? error.status : error.status || 500;
  return res.status(status).json({ message: error.message || "Internal error" });
};

// Get all users except logged-in user & filter by opposite gender
export const getAllUsersExceptMe = async (req, res) => {
  try {
    const { userId } = req.params;
    const formattedUsers = await getAllUsersExceptMeService(userId);
    return res.json(formattedUsers);
  } catch (error) {
    return handleError(res, error, "Error in getAllUsersExceptMe:");
  }
};

// Send message (REST API, saves to DB)
export const sendMessage = async (req, res) => {
  try {
    const { senderId, receiverId, message } = req.body;

    if (!senderId || !receiverId || !message) {
      return res.status(400).json({ message: "Missing required fields" });
    }

    const newMessage = await persistMessage(senderId, receiverId, message);

    return res.status(201).json({
      message: "Message sent successfully",
      data: {
        _id: newMessage._id,
        senderId,
        receiverId,
        message,
        createdAt: newMessage.createdAt,
      },
    });
  } catch (error) {
    return handleError(res, error, "Error in sendMessage:");
  }
};

// Get messages between two users
export const getMessages = async (req, res) => {
  try {
    const { senderId, receiverId } = req.params;
    const messages = await getMessagesBetween(senderId, receiverId);
    return res.json(messages);
  } catch (error) {
    return handleError(res, error, "Error in getMessages:");
  }
};

// Delete a specific message
export const deleteMessage = async (req, res) => {
  try {
    const { messageId } = req.params;
    const { userId } = req.body; // User attempting to delete

    await deleteMessageById(messageId, userId);

    return res.json({ message: "Message deleted successfully" });
  } catch (error) {
    return handleError(res, error, "Error in deleteMessage:");
  }
};