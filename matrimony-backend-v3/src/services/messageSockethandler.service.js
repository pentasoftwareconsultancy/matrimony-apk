// src/sockets/messageSocketHandler.js
import { Server } from "socket.io";
import {
  persistMessage,
  registerOnlineUser,
  getOnlineSocketId,
  unregisterSocketId,
} from "../modules/message/message.service.js";

/* ------------------------------------------------------------------
   SOCKET HANDLER (real-time chat with DB storage)
-------------------------------------------------------------------*/
export const initMessageSocket = (server) => {
  const io = new Server(server, {
    cors: {
      origin: "*", // Replace with frontend URL in production
      methods: ["GET", "POST"],
    },
  });

  io.on("connection", (socket) => {
    console.log("✅ Client connected:", socket.id);

    // Register user
    socket.on("register", (userId) => {
      registerOnlineUser(userId, socket.id);
      socket.join(userId); // Join user's own room
      console.log(`📌 Registered user ${userId} with socket ${socket.id}`);
    });

    // Send message (save to DB and emit)
    socket.on("sendMessage", async ({ senderId, receiverId, message }) => {
      try {
        console.log(`📩 ${senderId} -> ${receiverId}: ${message}`);

        const newMessage = await persistMessage(senderId, receiverId, message);

        // Send to receiver if online
        const receiverSocketId = getOnlineSocketId(receiverId);
        if (receiverSocketId) {
          io.to(receiverId).emit("receiveMessage", {
            senderId,
            receiverId,
            message,
            _id: newMessage._id,
            createdAt: newMessage.createdAt,
          });
        }

        // Confirmation back to sender
        socket.emit("messageSent", {
          senderId,
          receiverId,
          message,
          _id: newMessage._id,
          createdAt: newMessage.createdAt,
        });
      } catch (error) {
        console.error("Error sending message:", error);
        socket.emit("messageError", { message: "Failed to send message" });
      }
    });

    // Disconnect cleanup
    socket.on("disconnect", () => {
      const userId = unregisterSocketId(socket.id);
      if (userId) {
        console.log("❌ Disconnected user:", userId);
      }
    });
  });

  return io;
};