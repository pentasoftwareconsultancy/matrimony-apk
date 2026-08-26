import Matrimony from "../models/Matrimony.js";



// ==================================================
// IN-MEMORY USER PRESENCE
// ==================================================
//
// Map structure:
//
// userId -> {
//   sockets: Set,
//   lastSeenAt: Date | null
// }
//
// A Set is used because one user can have
// multiple active sockets/devices.
// ==================================================

const presenceMap = new Map();


// ==================================================
// USER CONNECTED
// ==================================================

export const userConnected = (userId, socketId) => {

  const existing = presenceMap.get(userId);

  if (existing) {

    existing.sockets.add(socketId);

  } else {

    presenceMap.set(userId, {
      sockets: new Set([socketId]),
      lastSeenAt: null,
    });

  }

};


// ==================================================
// USER DISCONNECTED
// ==================================================

export const userDisconnected = async (
  userId,
  socketId
) => {

  const existing = presenceMap.get(userId);

  if (!existing) {
    return null;
  }

  existing.sockets.delete(socketId);

  // User still has another active socket
  if (existing.sockets.size > 0) {
    return {
      isOnline: true,
      lastSeenAt: existing.lastSeenAt,
    };
  }

  // ----------------------------------------------
  // User is completely offline
  // ----------------------------------------------

  const lastSeenAt = new Date();

  existing.lastSeenAt = lastSeenAt;

  // ----------------------------------------------
  // Persist last seen in MongoDB
  // ----------------------------------------------

  try {

    await Matrimony.findByIdAndUpdate(
      userId,
      {
        lastSeenAt,
      }
    );

    console.log(
      `[Presence] Last seen saved for ${userId}: ${lastSeenAt.toISOString()}`
    );

  } catch (error) {

    console.error(
      `[Presence] Failed to save last seen for ${userId}:`,
      error.message
    );

  }

  return {
    isOnline: false,
    lastSeenAt,
  };
};


// ==================================================
// CHECK ONLINE STATUS
// ==================================================

export const isUserOnline = (userId) => {

  const existing = presenceMap.get(userId);

  return Boolean(
    existing &&
    existing.sockets.size > 0
  );

};


// ==================================================
// GET PRESENCE
// ==================================================

export const getUserPresence = (userId) => {

  const existing = presenceMap.get(userId);

  if (!existing) {

    return {
      isOnline: false,
      lastSeenAt: null,
    };

  }

  return {
    isOnline: existing.sockets.size > 0,
    lastSeenAt: existing.lastSeenAt,
  };

};


// ==================================================
// GET ALL ONLINE USERS
// ==================================================

export const getOnlineUserIds = () => {

  const onlineUsers = [];

  for (const [
    userId,
    presence
  ] of presenceMap.entries()) {

    if (presence.sockets.size > 0) {
      onlineUsers.push(userId);
    }

  }

  return onlineUsers;

};