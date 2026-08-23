// src/modules/message/message.service.js
import mongoose from "mongoose";
import Matrimony from "../brideGroom/bridegroom.schema.js";
import Message from "./message.schema.js";

// Generic service-layer error carrying an HTTP status code
export class AppError extends Error {
  constructor(status, message) {
    super(message);
    this.name = "AppError";
    this.status = status;
  }
}

// Helper: Validate ObjectIds
export const ensureObjectId = (id) => {
  if (!mongoose.isValidObjectId(id)) {
    throw new AppError(400, "Invalid user id");
  }
  return new mongoose.Types.ObjectId(id);
};

/* ------------------------------------------------------------------
   ONLINE USER TRACKING (userId -> socketId)

   Exported so both the socket handler and any other module that needs to
   know if a user is currently connected (e.g. notificationService's
   createDirectMessage) can share the same map instead of each having its
   own out-of-sync copy.
-------------------------------------------------------------------*/
export const onlineUsers = new Map();

export const registerOnlineUser = (userId, socketId) => {
  onlineUsers.set(userId, socketId);
};

export const getOnlineSocketId = (userId) => onlineUsers.get(userId);

export const unregisterSocketId = (socketId) => {
  for (const [userId, sockId] of onlineUsers.entries()) {
    if (sockId === socketId) {
      onlineUsers.delete(userId);
      return userId;
    }
  }
  return null;
};

/* ------------------------------------------------------------------
   MESSAGE / USER LOOKUP LOGIC
-------------------------------------------------------------------*/

// Get all users except the given one, filtered to the opposite gender
export const getAllUsersExceptMe = async (userId) => {
  ensureObjectId(userId);
  console.log("[getAllUsersExceptMe] fetching users except:", userId);

  const currentUser = await Matrimony.findById(userId).select(
    "personalDetail.gender"
  );

  if (!currentUser) {
    throw new AppError(404, "User not found");
  }

  const currentGender = currentUser.personalDetail?.gender;
  if (!currentGender) {
    throw new AppError(400, "User gender not set");
  }

  const users = await Matrimony.find({
    _id: { $ne: userId },
    "personalDetail.gender": { $ne: currentGender },
  }).select(
    "_id userRegistration.fullName userRegistration.email documentDetails.photoFulls personalDetail.gender"
  );

  return users.map((user) => {
    const fullName = user.userRegistration?.fullName || "Anonymous";
    const email = user.userRegistration?.email || "N/A";
    const profile = user.documentDetails?.photoFulls;
    const gender = user.personalDetail?.gender;

    return { _id: user._id, fullName, email, profile, gender };
  });
};

// Persist a message to the database. Used by both the socket handler and
// the REST sendMessage endpoint.
export const persistMessage = async (senderId, receiverId, content) => {
  ensureObjectId(senderId);
  ensureObjectId(receiverId);

  const newMessage = new Message({
    sender: senderId,
    receiver: receiverId,
    content,
  });
  await newMessage.save();

  return newMessage;
};

// Get messages between two users (both directions), oldest first
export const getMessagesBetween = async (senderId, receiverId) => {
  ensureObjectId(senderId);
  ensureObjectId(receiverId);

  const messages = await Message.find({
    $or: [
      { sender: senderId, receiver: receiverId },
      { sender: receiverId, receiver: senderId },
    ],
  })
    .sort({ createdAt: 1 })
    .select("_id sender receiver content createdAt");

  return messages;
};

// Delete a message, only if the requesting user was sender or receiver
export const deleteMessageById = async (messageId, userId) => {
  ensureObjectId(messageId);
  ensureObjectId(userId);

  const message = await Message.findById(messageId);
  if (!message) {
    throw new AppError(404, "Message not found");
  }

  if (
    message.sender.toString() !== userId &&
    message.receiver.toString() !== userId
  ) {
    throw new AppError(403, "Unauthorized to delete message");
  }

  await Message.findByIdAndDelete(messageId);
};