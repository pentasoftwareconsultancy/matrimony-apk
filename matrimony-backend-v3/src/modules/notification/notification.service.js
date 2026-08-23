// src/services/notificationService.js
import mongoose from "mongoose";
import Notification from "./notification.schema.js";
import Matrimony from "../brideGroom/bridegroom.schema.js";
import Message from "../message/message.schema.js";

// Import socket emitter (set from socketHandler via setSocketEmitter)
let emitNewNotification;

export const setSocketEmitter = (emitter) => {
  emitNewNotification = emitter;
};

const emit = (notification) => {
  if (emitNewNotification) emitNewNotification(notification);
};

// Generic service-layer error carrying an HTTP status code
export class AppError extends Error {
  constructor(status, message) {
    super(message);
    this.name = "AppError";
    this.status = status;
  }
}

// helper: validate ObjectIds
export const ensureObjectId = (id) => {
  if (!mongoose.isValidObjectId(id)) {
    throw new AppError(400, "Invalid user id");
  }
  return new mongoose.Types.ObjectId(id);
};

/* ------------------------------------------------------------------
   NOTIFICATIONS
-------------------------------------------------------------------*/

// Create a new notification for a user
export const createNotification = async ({ userId, type, message }) => {
  ensureObjectId(userId);

  const notification = new Notification({ user: userId, type, message });
  await notification.save();

  emit(notification);

  return notification;
};

// Send an "interest" notification from one user to another
export const sendInterestNotification = async (fromUserId, toUserId) => {
  ensureObjectId(fromUserId);
  ensureObjectId(toUserId);

  const fromUser = await Matrimony.findById(fromUserId);
  if (!fromUser) {
    throw new AppError(404, "Sender not found");
  }

  const toUser = await Matrimony.findById(toUserId);
  if (!toUser) {
    throw new AppError(404, "Receiver not found");
  }

  const name = fromUser.userRegistration?.fullName || "Someone";
  const interestMessage = `${name} has shown interest in your profile!`;

  const notification = new Notification({
    user: toUserId,
    type: "interest",
    message: interestMessage,
    senderImage: fromUser.documentDetails?.photoFull, // Optional for UI
  });
  await notification.save();

  emit(notification);

  return notification;
};

// Create (or refresh) a "profile viewed" notification
export const sendProfileActivityNotification = async (fromUserId, toUserId) => {
  console.log(`📨 Creating profile activity: ${fromUserId} → ${toUserId}`);

  ensureObjectId(fromUserId);
  ensureObjectId(toUserId);

  // Don't send notification to self
  if (fromUserId.toString() === toUserId.toString()) {
    console.log("🚫 Skipping self-notification");
    throw new AppError(400, "Cannot send notification to self");
  }

  const fromUser = await Matrimony.findById(fromUserId).select(
    "userRegistration.fullName documentDetails.photoFull"
  );
  if (!fromUser) {
    console.log("❌ Viewer not found");
    throw new AppError(404, "Viewer not found");
  }

  const toUser = await Matrimony.findById(toUserId).select("_id");
  if (!toUser) {
    console.log("❌ Profile owner not found");
    throw new AppError(404, "Profile owner not found");
  }

  const viewerName = fromUser.userRegistration?.fullName || "Someone";
  const activityMessage = `${viewerName} viewed your profile!`;
  console.log(`📝 Notification message: ${activityMessage}`);

  // Check if notification already exists for this activity (within last 24 hours)
  const twentyFourHoursAgo = new Date(Date.now() - 24 * 60 * 60 * 1000);

  const existingNotification = await Notification.findOne({
    user: toUserId,
    type: "profileActivity",
    message: activityMessage,
    createdAt: { $gte: twentyFourHoursAgo },
  });

  let notification;
  if (existingNotification) {
    console.log("🔄 Updating existing notification");
    existingNotification.createdAt = new Date();
    existingNotification.isRead = false;
    notification = await existingNotification.save();
  } else {
    console.log("🆕 Creating new notification");
    notification = new Notification({
      user: toUserId,
      type: "profileActivity",
      message: activityMessage,
      senderImage: fromUser.documentDetails?.photoFull,
      fromUserId: fromUserId,
    });
    notification = await notification.save();
  }

  console.log(`✅ Notification saved: ${notification._id}`);

  emit(notification);

  return notification;
};

// Get all "profileActivity" notifications for a user
export const getUserProfileActivityNotifications = async (userid) => {
  if (!mongoose.Types.ObjectId.isValid(userid)) {
    throw new AppError(400, "Invalid user ID");
  }

  const notifications = await Notification.find({
    user: userid,
    type: "profileActivity",
  })
    .sort({ createdAt: -1 }) // Most recent first
    .populate({
      path: "fromUserId",
      select: "userRegistration.fullName documentDetails.photoFull",
      options: { strictPopulate: false },
    });

  console.log(
    `📋 Found ${notifications.length} profile activity notifications for user: ${userid}`
  );

  return notifications;
};

// Get all notifications for a user, optionally scoped to the requester
export const getNotificationsForUser = async (userId, requestingUserId) => {
  console.log(
    `🔍 Fetching notifications for user: ${userId} (from: ${requestingUserId})`
  );
  ensureObjectId(userId);

  // Optional: Ensure user can only fetch their own (if a requester id was provided)
  if (requestingUserId && requestingUserId !== userId) {
    throw new AppError(403, "Access denied");
  }

  const notifications = await Notification.find({ user: userId })
    .populate("user", "userRegistration.fullName")
    .sort({ createdAt: -1 })
    .lean();

  console.log(`✅ Found ${notifications.length} notifications for ${userId}`);

  return notifications;
};

// Mark a single notification as read
export const markNotificationAsRead = async (notificationId) => {
  ensureObjectId(notificationId);

  const updated = await Notification.findByIdAndUpdate(
    notificationId,
    { isRead: true },
    { new: true }
  );

  if (!updated) {
    throw new AppError(404, "Notification not found");
  }

  return updated;
};

// Mark all of a user's notifications as read
export const markAllNotificationsAsRead = async (userId) => {
  ensureObjectId(userId);

  const updated = await Notification.updateMany(
    { user: userId, isRead: false },
    { isRead: true }
  );

  return updated.modifiedCount;
};

// Delete a single notification
export const deleteNotificationById = async (notificationId) => {
  ensureObjectId(notificationId);

  const deleted = await Notification.findByIdAndDelete(notificationId);

  if (!deleted) {
    throw new AppError(404, "Notification not found");
  }

  return deleted;
};

// Delete all notifications for a user
export const deleteAllUserNotifications = async (userId) => {
  ensureObjectId(userId);

  const deleted = await Notification.deleteMany({ user: userId });

  return deleted.deletedCount;
};

/* ------------------------------------------------------------------
   MATCH ALERT GENERATOR (auto-match based on preferences)
-------------------------------------------------------------------*/

// helper: advanced scoring system
export const calculateMatchScore = (userA, userB) => {
  let score = 0;
  let total = 0;

  // mapping: partner preference (A) → actual detail (B)
  const preferences = [
    // Personal details
    { pref: "partnerMaritalStatus", actual: "maritalStatus", source: "personalDetail" },
    { pref: "partnerComplexionType", actual: "complexionType", source: "personalDetail" },
    { pref: "partnerHeight", actual: "height", source: "personalDetail" },
    { pref: "partnerWeight", actual: "weight", source: "personalDetail" },
    { pref: "partnerDiet", actual: "diet", source: "personalDetail" },
    { pref: "partnerSmokingDrinking", actual: "smoking", source: "personalDetail" }, // ⚠️ could extend to drinking

    // Education & Profession
    { pref: "partnerEducation", actual: "highestEducation", source: "educationalDetail" },
    { pref: "partnerProfession", actual: "profession", source: "educationalDetail" },
    { pref: "partnerIncome", actual: "annualIncome", source: "educationalDetail" },

    // Location
    { pref: "partnerWorkingLocation", actual: "companyAddress", source: "educationalDetail" },
  ];

  for (const { pref, actual, source } of preferences) {
    total++;
    const prefValue = userA.partnerDetail?.[pref];
    const actualValue = userB[source]?.[actual];

    if (prefValue && actualValue) {
      // normalize to string for safe compare
      if (String(prefValue).toLowerCase() === String(actualValue).toLowerCase()) {
        score++;
      }
    }
  }

  return total > 0 ? Math.round((score / total) * 100) : 0;
};

// Generate match notifications (two-way: A ⇔ B) for a given user against everyone else
export const generateMatchNotifications = async (userId) => {
  ensureObjectId(userId);

  const currentUser = await Matrimony.findById(userId);
  if (!currentUser) {
    throw new AppError(404, "User not found");
  }

  const allUsers = await Matrimony.find({ _id: { $ne: userId } });

  const matches = [];

  for (const other of allUsers) {
    const scoreA = calculateMatchScore(currentUser, other); // A → B
    const scoreB = calculateMatchScore(other, currentUser); // B → A

    if (scoreA > 0 && scoreB > 0) {
      const finalScore = Math.round((scoreA + scoreB) / 2);

      const notifA = new Notification({
        user: userId,
        type: "match",
        message: `${other.userRegistration?.fullName || "Someone"} is a ${finalScore}% match with you!`,
        senderImage: other.documentDetails?.photoFull,
      });
      await notifA.save();
      emit(notifA);

      const notifB = new Notification({
        user: other._id,
        type: "match",
        message: `${currentUser.userRegistration?.fullName || "Someone"} is a ${finalScore}% match with you!`,
        senderImage: currentUser.documentDetails?.photoFull,
      });
      await notifB.save();
      emit(notifB);

      matches.push({ score: finalScore, other: other._id });
    }
  }

  return matches;
};

/* ------------------------------------------------------------------
   DIRECT MESSAGES
-------------------------------------------------------------------*/

// Get direct message conversation between two users
export const getConversation = async (userId, otherUserId) => {
  if (
    !mongoose.isValidObjectId(userId) ||
    !mongoose.isValidObjectId(otherUserId)
  ) {
    throw new AppError(400, "Invalid user ID");
  }

  const user = await Matrimony.findById(userId);
  const otherUser = await Matrimony.findById(otherUserId);

  if (!user || !otherUser) {
    throw new AppError(404, "User not found");
  }

  const messages = await Message.find({
    $or: [
      { sender: userId, receiver: otherUserId },
      { sender: otherUserId, receiver: userId },
    ],
  })
    .sort({ createdAt: 1 })
    .populate("sender", "userRegistration.fullName documentDetails.photoFull")
    .populate("receiver", "userRegistration.fullName documentDetails.photoFull");

  return {
    messages,
    otherUser: {
      _id: otherUser._id,
      name: otherUser.userRegistration?.fullName,
      photo: otherUser.documentDetails?.photoFull,
    },
  };
};

// Create and persist a direct message, and emit it over socket.io if available.
//
// NOTE: this preserves the original behavior, which references a module-level
// `onlineUsers` map that isn't defined/imported anywhere in the original file.
// That means the socket-emit block will throw a ReferenceError whenever
// `global.io` is set, which gets swallowed by the outer try/catch (the
// message is still saved, but the caller gets a 500 instead of 201). Wire up
// a real `onlineUsers` map (e.g. import it from your socket handler) to fix
// this — left as-is here since it wasn't part of the requested refactor.
export const createDirectMessage = async ({ senderId, receiverId, content }) => {
  if (!senderId || !receiverId || !content) {
    throw new AppError(
      400,
      "Missing required fields: senderId, receiverId, or content"
    );
  }

  if (
    !mongoose.isValidObjectId(senderId) ||
    !mongoose.isValidObjectId(receiverId)
  ) {
    throw new AppError(400, "Invalid user ID");
  }

  const sender = await Matrimony.findById(senderId);
  const receiver = await Matrimony.findById(receiverId);

  if (!sender || !receiver) {
    throw new AppError(404, "User not found");
  }

  const newMessage = new Message({
    sender: senderId,
    receiver: receiverId,
    content,
  });

  await newMessage.save();

  await newMessage.populate(
    "sender",
    "userRegistration.fullName documentDetails.photoFull"
  );

  if (global.io) {
    const receiverSocketId = onlineUsers.get(receiverId);
    if (receiverSocketId) {
      global.io.to(receiverId).emit("receiveMessage", {
        senderId,
        receiverId,
        message: content,
        _id: newMessage._id,
        createdAt: newMessage.createdAt,
      });
    }
  }

  return newMessage;
};

// Get notifications relevant to the messaging screen
export const getNotificationsForMessage = async (userId) => {
  if (!mongoose.isValidObjectId(userId)) {
    throw new AppError(400, "Invalid user ID");
  }

  const notifications = await Notification.find({ user: userId })
    .sort({ createdAt: -1 })
    .populate({
      path: "fromUserId",
      model: "Matrimony",
      select: "userRegistration.fullName documentDetails.photoFull",
      options: { strictPopulate: false },
    });

  return notifications;
};