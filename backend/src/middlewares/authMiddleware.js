import jwt from 'jsonwebtoken';
import UserRepository from '../repositories/UserRepository.js';
import { ApiResponse } from '../utils/apiResponse.js';

export const protect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    try {
      // Get token from header
      token = req.headers.authorization.split(' ')[1];

      // Verify token
      const decoded = jwt.verify(token, process.env.JWT_SECRET);

      // Get user from database (excluding password)
      const user = await UserRepository.findById(decoded.id);
      if (!user) {
        return ApiResponse.error(res, 'Not authorized, user not found', 401);
      }

      req.user = user;
      next();
    } catch (error) {
      console.error(error);
      return ApiResponse.error(res, 'Not authorized, token failed', 401);
    }
  }

  if (!token) {
    return ApiResponse.error(res, 'Not authorized, no token provided', 401);
  }
};

export const admin = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    return ApiResponse.error(res, 'Not authorized as an admin', 403);
  }
};

export const adminOnly = admin;

export const optionalProtect = async (req, res, next) => {
  let token;

  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith('Bearer')
  ) {
    try {
      token = req.headers.authorization.split(' ')[1];
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const user = await UserRepository.findById(decoded.id);
      if (user) {
        req.user = user;
      }
    } catch (error) {
      console.error('Optional auth token failure:', error.message);
    }
  }
  next();
};

