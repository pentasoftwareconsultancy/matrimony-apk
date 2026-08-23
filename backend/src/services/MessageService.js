import Message from '../models/Message.js';
import Matrimony from '../models/Matrimony.js';
import AuthService from './AuthService.js';

class MessageService {
  async getConversations(userId) {
    if (!userId) return [];

    const messages = await Message.find({
      $or: [
        { sender: userId },
        { receiver: userId },
        { senderId: userId },
        { recipientId: userId }
      ]
    }).sort({ createdAt: 1 }).lean();

    const conversationMap = {};

    for (const msg of messages) {
      const msgSender = msg.sender || msg.senderId;
      const msgReceiver = msg.receiver || msg.recipientId;
      if (!msgSender || !msgReceiver) continue;

      const isSender = msgSender.toString() === userId.toString();
      const partnerIdStr = isSender ? msgReceiver.toString() : msgSender.toString();

      if (!conversationMap[partnerIdStr]) {
        conversationMap[partnerIdStr] = [];
      }

      conversationMap[partnerIdStr].push({
        id: msg._id.toString(),
        senderId: isSender ? 'me' : partnerIdStr,
        text: msg.content || msg.text || '',
        timestamp: msg.createdAt,
      });
    }

    const partnerIds = Object.keys(conversationMap);
    const partnerDocs = await Matrimony.find({ _id: { $in: partnerIds } });

    const partnerMap = {};
    for (const doc of partnerDocs) {
      partnerMap[doc._id.toString()] = await AuthService.getMergedUser(doc);
    }

    const conversations = partnerIds.map(partnerId => {
      const p = partnerMap[partnerId];
      return {
        partnerId,
        partnerName: p ? (p.fullName || 'Matrimony Member') : 'Matrimony Member',
        partnerAvatar: (p && p.photos && p.photos.length > 0) ? p.photos[0] : 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
        messages: conversationMap[partnerId] || [],
      };
    });

    return conversations;
  }

  async getMessagesWithPartner(userId, partnerId) {
    const messages = await Message.find({
      $or: [
        { sender: userId, receiver: partnerId },
        { sender: partnerId, receiver: userId },
        { senderId: userId, recipientId: partnerId },
        { senderId: partnerId, recipientId: userId }
      ]
    }).sort({ createdAt: 1 }).lean();

    return messages.map(msg => {
      const msgSender = msg.sender || msg.senderId;
      const isSender = msgSender.toString() === userId.toString();
      return {
        id: msg._id.toString(),
        senderId: isSender ? 'me' : partnerId,
        text: msg.content || msg.text || '',
        timestamp: msg.createdAt,
      };
    });
  }

  async sendMessage(senderId, partnerId, text) {
    if (!text || text.trim() === '') {
      const error = new Error('Message text cannot be empty');
      error.statusCode = 400;
      throw error;
    }

    const message = await Message.create({
      sender: senderId,
      receiver: partnerId,
      content: text.trim(),
    });

    return {
      id: message._id.toString(),
      senderId: 'me',
      text: message.content,
      timestamp: message.createdAt,
    };
  }
}

export default new MessageService();
