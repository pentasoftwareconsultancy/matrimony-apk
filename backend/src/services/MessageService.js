import Message from "../models/Message.js";
import Matrimony from "../models/Matrimony.js";
import AuthService from "./AuthService.js";

class MessageService {
  // --------------------------------------------------
  // GET ALL CONVERSATIONS
  // --------------------------------------------------

  async getConversations(userId) {
    if (!userId) return [];

    const messages = await Message.find({
      $or: [
        { sender: userId },
        { receiver: userId },
      ],
    })
      .sort({ createdAt: 1 })
      .lean();

    const conversationMap = {};

    for (const msg of messages) {
      const senderId = msg.sender.toString();
      const receiverId = msg.receiver.toString();

      const isSender = senderId === userId.toString();

      const partnerId = isSender
        ? receiverId
        : senderId;

      if (!conversationMap[partnerId]) {
        conversationMap[partnerId] = [];
      }

      conversationMap[partnerId].push({
        id: msg._id.toString(),

        senderId: senderId === userId.toString()
          ? "me"
          : senderId,

        receiverId,

        text: msg.content,

        status: msg.status,

        deliveredAt: msg.deliveredAt,

        readAt: msg.readAt,

        timestamp: msg.createdAt,
      });
    }

    const partnerIds = Object.keys(conversationMap);

    if (partnerIds.length === 0) {
      return [];
    }

    const partnerDocs = await Matrimony.find({
      _id: { $in: partnerIds },
    }).lean();

    const partnerMap = {};

    for (const doc of partnerDocs) {
      partnerMap[doc._id.toString()] =
        await AuthService.getMergedUser(doc);
    }

    const conversations = partnerIds.map((partnerId) => {
      const partner = partnerMap[partnerId];

      const messagesForPartner =
        conversationMap[partnerId] || [];

      const lastMessage =
        messagesForPartner[messagesForPartner.length - 1];

      return {
        partnerId,

        partnerName:
          partner?.fullName ||
          "Matrimony Member",

        partnerAvatar:
          partner?.photos?.length > 0
            ? partner.photos[0]
            : "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100",

        lastMessage: lastMessage?.text || "",

        lastMessageTime:
          lastMessage?.timestamp || null,

        messages: messagesForPartner,
      };
    });

    // Most recent conversation first
    conversations.sort((a, b) => {
      return (
        new Date(b.lastMessageTime || 0) -
        new Date(a.lastMessageTime || 0)
      );
    });

    return conversations;
  }

  // --------------------------------------------------
  // GET MESSAGES WITH PARTNER
  // --------------------------------------------------

  async getMessagesWithPartner(userId, partnerId) {
    if (!userId || !partnerId) {
      const error = new Error(
        "User ID and partner ID are required"
      );

      error.statusCode = 400;

      throw error;
    }

    const messages = await Message.find({
      $or: [
        {
          sender: userId,
          receiver: partnerId,
        },
        {
          sender: partnerId,
          receiver: userId,
        },
      ],
    })
      .sort({ createdAt: 1 })
      .lean();

    return messages.map((msg) => {
      const senderId = msg.sender.toString();

      return {
        id: msg._id.toString(),

        senderId:
          senderId === userId.toString()
            ? "me"
            : senderId,

        receiverId:
          msg.receiver.toString(),

        text: msg.content,

        status: msg.status,

        deliveredAt: msg.deliveredAt,

        readAt: msg.readAt,

        timestamp: msg.createdAt,
      };
    });
  }

  // --------------------------------------------------
  // SEND MESSAGE
  // --------------------------------------------------

  async sendMessage(senderId, partnerId, text) {
    if (!senderId || !partnerId) {
      const error = new Error(
        "Sender and receiver are required"
      );

      error.statusCode = 400;

      throw error;
    }

    if (!text || text.trim() === "") {
      const error = new Error(
        "Message text cannot be empty"
      );

      error.statusCode = 400;

      throw error;
    }

    // Make sure receiver exists
    const receiver = await Matrimony.findById(partnerId);

    if (!receiver) {
      const error = new Error(
        "Receiver not found"
      );

      error.statusCode = 404;

      throw error;
    }

    const message = await Message.create({
      sender: senderId,
      receiver: partnerId,
      content: text.trim(),
      status: "sent",
    });

    return {
      id: message._id.toString(),

      senderId: "me",

      receiverId: partnerId,

      text: message.content,

      status: message.status,

      deliveredAt: message.deliveredAt,

      readAt: message.readAt,

      timestamp: message.createdAt,
    };
  }

  // --------------------------------------------------
  // MARK MESSAGE AS DELIVERED
  // --------------------------------------------------

  async markAsDelivered(messageId, userId) {
    const message = await Message.findOne({
      _id: messageId,
      receiver: userId,
    });

    if (!message) {
      const error = new Error(
        "Message not found"
      );

      error.statusCode = 404;

      throw error;
    }

    if (message.status === "read") {
      return message;
    }

    message.status = "delivered";
    message.deliveredAt = new Date();

    await message.save();

    return message;
  }

  // --------------------------------------------------
  // MARK MESSAGE AS READ
  // --------------------------------------------------

  async markAsRead(messageId, userId) {
    const message = await Message.findOne({
      _id: messageId,
      receiver: userId,
    });

    if (!message) {
      const error = new Error(
        "Message not found"
      );

      error.statusCode = 404;

      throw error;
    }

    message.status = "read";

    if (!message.deliveredAt) {
      message.deliveredAt = new Date();
    }

    message.readAt = new Date();

    await message.save();

    return message;
  }
}

export default new MessageService();