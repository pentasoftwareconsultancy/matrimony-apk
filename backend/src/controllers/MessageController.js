import MessageService from '../services/MessageService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class MessageController {
  async getConversations(req, res, next) {
    try {
      const conversations = await MessageService.getConversations(req.user._id);
      return ApiResponse.success(res, 'Conversations retrieved', conversations, 200);
    } catch (error) {
      next(error);
    }
  }

  async getMessagesWithPartner(req, res, next) {
    try {
      const { partnerId } = req.params;
      const messages = await MessageService.getMessagesWithPartner(req.user._id, partnerId);
      return ApiResponse.success(res, 'Messages retrieved', messages, 200);
    } catch (error) {
      next(error);
    }
  }

  async sendMessage(req, res, next) {
    try {
      const { partnerId } = req.params;
      const { text } = req.body;
      const message = await MessageService.sendMessage(req.user._id, partnerId, text);
      return ApiResponse.success(res, 'Message sent', message, 200);
    } catch (error) {
      next(error);
    }
  }


  async getUserPresence(req, res, next) {
    try {
      const { userId } = req.params;

      const { getUserPresence } =
        await import("../sockets/presence.js");

      const presence = getUserPresence(userId);

      return ApiResponse.success(
        res,
        "User presence retrieved",
        {
          userId,
          ...presence,
        },
        200
      );

    } catch (error) {
      next(error);
    }
  }
}

export default new MessageController();
