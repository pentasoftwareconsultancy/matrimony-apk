import ConnectionService from '../services/ConnectionService.js';
import { ApiResponse } from '../utils/apiResponse.js';

class ConnectionController {
  async getConnections(req, res, next) {
    try {
      const connections = await ConnectionService.getConnections(req.user._id);
      return ApiResponse.success(res, 'Connections retrieved successfully', connections, 200);
    } catch (error) {
      next(error);
    }
  }

  async expressInterest(req, res, next) {
    try {
      const { profileId } = req.params;
      const result = await ConnectionService.expressInterest(req.user._id, profileId);
      return ApiResponse.success(res, result.message, result, 200);
    } catch (error) {
      next(error);
    }
  }

  async respondToInterest(req, res, next) {
    try {
      const { connectionId } = req.params;
      const { status } = req.body;
      const result = await ConnectionService.respondToInterest(req.user._id, connectionId, status);
      return ApiResponse.success(res, result.message, result, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new ConnectionController();
