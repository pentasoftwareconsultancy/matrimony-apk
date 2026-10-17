import MessageService from "../services/MessageService.js";
import { getIO } from "./index.js";

export const registerMessageSocket = (socket) => {

  // ==================================================
  // SEND MESSAGE
  // ==================================================

  socket.on("sendMessage", async (data, callback) => {
    try {
      const { receiverId, text } = data;

      if (!receiverId) {
        throw new Error("Receiver ID is required");
      }

      if (!text || !text.trim()) {
        throw new Error("Message text cannot be empty");
      }

      const senderId = socket.userId;

      // ----------------------------------------------
      // Save message
      // ----------------------------------------------

      const message = await MessageService.sendMessage(
        senderId,
        receiverId,
        text
      );

      const io = getIO();

      // ----------------------------------------------
      // Prepare socket message
      //
      // IMPORTANT:
      // Socket receiver gets REAL senderId,
      // not "me".
      // ----------------------------------------------

      const socketMessage = {
        ...message,
        senderId,
        receiverId,
        status: "sent",
      };

      // ----------------------------------------------
      // Send to receiver
      // ----------------------------------------------

      io.to(`user:${receiverId}`).emit(
        "newMessage",
        socketMessage
      );

      // ----------------------------------------------
      // Acknowledge sender
      // ----------------------------------------------

      if (callback) {
        callback({
          success: true,
          message,
        });
      }

    } catch (error) {

      console.error(
        "[Socket] Send message error:",
        error.message
      );

      if (callback) {
        callback({
          success: false,
          error: error.message,
        });
      }
    }
  });


  // ==================================================
  // MESSAGE DELIVERED
  // ==================================================

  socket.on(
    "messageDelivered",
    async (data, callback) => {

      try {
        const { messageId } = data;

        if (!messageId) {
          throw new Error(
            "Message ID is required"
          );
        }

        const userId = socket.userId;

        // --------------------------------------------
        // Mark delivered
        // --------------------------------------------

        const message =
          await MessageService.markAsDelivered(
            messageId,
            userId
          );

        const io = getIO();

        const senderId =
          message.sender.toString();

        const receiverId =
          message.receiver.toString();

        // --------------------------------------------
        // Notify sender
        // --------------------------------------------

        io.to(`user:${senderId}`).emit(
          "messageDelivered",
          {
            messageId:
              message._id.toString(),

            status:
              message.status,

            deliveredAt:
              message.deliveredAt,

            senderId,

            receiverId,
          }
        );

        if (callback) {
          callback({
            success: true,

            messageId:
              message._id.toString(),

            status:
              message.status,

            deliveredAt:
              message.deliveredAt,
          });
        }

      } catch (error) {

        console.error(
          "[Socket] Delivery update error:",
          error.message
        );

        if (callback) {
          callback({
            success: false,
            error: error.message,
          });
        }
      }
    }
  );


  // ==================================================
  // MESSAGE READ
  // ==================================================

  socket.on(
    "messageRead",
    async (data, callback) => {

      try {

        const { messageId } = data;

        if (!messageId) {
          throw new Error(
            "Message ID is required"
          );
        }

        const userId = socket.userId;

        // --------------------------------------------
        // IMPORTANT:
        // MessageService only allows the receiver
        // to mark the message as read.
        // --------------------------------------------

        const message =
          await MessageService.markAsRead(
            messageId,
            userId
          );

        const io = getIO();

        const senderId =
          message.sender.toString();

        const receiverId =
          message.receiver.toString();

        // --------------------------------------------
        // Notify sender
        // --------------------------------------------

        io.to(`user:${senderId}`).emit(
          "messageRead",
          {
            messageId:
              message._id.toString(),

            status:
              message.status,

            readAt:
              message.readAt,

            senderId,

            receiverId,
          }
        );

        // --------------------------------------------
        // Acknowledge receiver
        // --------------------------------------------

        if (callback) {
          callback({
            success: true,

            messageId:
              message._id.toString(),

            status:
              message.status,

            readAt:
              message.readAt,
          });
        }

      } catch (error) {

        console.error(
          "[Socket] Read update error:",
          error.message
        );

        if (callback) {
          callback({
            success: false,
            error: error.message,
          });
        }
      }
    }
  );

};