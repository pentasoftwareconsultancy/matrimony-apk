import { Server } from "socket.io";

import { socketAuth } from "./socketAuth.js";
import { registerMessageSocket } from "./messageSocket.js";

import {
  userConnected,
  userDisconnected,
  getUserPresence,
} from "./presence.js";

let io;


// ==================================================
// INITIALIZE SOCKET.IO
// ==================================================

export const initializeSocket = (httpServer) => {

  io = new Server(httpServer, {

    cors: {
      origin: [
        'http://localhost:61602',
        'https://matrimony-apk-9895.web.app',
        'https://matrimony-apk-9895.firebaseapp.com',
      ],
      credentials: true,
      methods: ['GET', 'POST'],
    },

  });


  // ==================================================
  // SOCKET AUTHENTICATION
  // ==================================================

  io.use(socketAuth);


  // ==================================================
  // CONNECTION
  // ==================================================

  io.on("connection", (socket) => {

    const userId = socket.userId;

    console.log(
      `[Socket] User connected: ${userId}`
    );

    console.log(
      `[Socket] Socket ID: ${socket.id}`
    );


    // ==================================================
    // PERSONAL USER ROOM
    // ==================================================

    const userRoom = `user:${userId}`;

    socket.join(userRoom);

    console.log(
      `[Socket] Joined room: ${userRoom}`
    );


    // ==================================================
    // PRESENCE
    // ==================================================

    userConnected(
      userId,
      socket.id
    );

    console.log(
      `[Presence] ${userId} is ONLINE`
    );


    // ==================================================
    // NOTIFY OTHER USERS
    // ==================================================

    socket.broadcast.emit(
      "userOnline",
      {
        userId,
        isOnline: true,
      }
    );


    // ==================================================
    // GET USER PRESENCE
    // ==================================================

    socket.on(
      "getUserPresence",
      ({ userId: targetUserId }, callback) => {

        if (!targetUserId) {

          return callback?.({
            success: false,
            error: "User ID is required",
          });

        }

        const presence =
          getUserPresence(targetUserId);

        callback?.({
          success: true,
          userId: targetUserId,
          ...presence,
        });

      }
    );


    // ==================================================
    // REGISTER MESSAGE EVENTS
    // ==================================================

    registerMessageSocket(socket);


    // ==================================================
    // DISCONNECT
    // ==================================================

    socket.on("disconnect", async (reason) => {

      const presence =
        await userDisconnected(
          userId,
          socket.id
        );


      console.log(
        `[Socket] User disconnected: ${userId} | ${reason}`
      );


      // ----------------------------------------------
      // User still has another active socket
      // ----------------------------------------------

      if (presence?.isOnline) {

        console.log(
          `[Presence] ${userId} is still ONLINE`
        );

        return;
      }


      // ----------------------------------------------
      // User has completely gone offline
      // ----------------------------------------------

      console.log(
        `[Presence] ${userId} is OFFLINE`
      );


      socket.broadcast.emit(
        "userOffline",
        {
          userId,
          isOnline: false,
          lastSeenAt:
            presence?.lastSeenAt || new Date(),
        }
      );

    });

  });


  console.log(
    "[Socket] Socket.IO initialized"
  );


  return io;
};


// ==================================================
// GET SOCKET.IO INSTANCE
// ==================================================

export const getIO = () => {

  if (!io) {

    throw new Error(
      "Socket.IO has not been initialized"
    );

  }

  return io;
};