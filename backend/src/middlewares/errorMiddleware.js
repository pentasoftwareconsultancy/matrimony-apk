import { ApiResponse } from '../utils/apiResponse.js';

export const errorHandler = (err, req, res, next) => {
  console.error('--- ERROR LOG ---');
  console.error(err.stack || err);
  console.error('-----------------');

  // Custom errors or Mongoose errors
  let statusCode = err.statusCode || 500;
  let message = err.message || 'Internal Server Error';
  let errors = err.errors || null;

  // Handle Mongoose Bad ObjectID
  if (err.name === 'CastError') {
    message = `Resource not found with id of ${err.value}`;
    statusCode = 404;
  }

  // Handle Mongoose Duplicate Key Error
  if (err.code === 11000) {
    statusCode = 409;
    const keyPattern = err.keyPattern ? Object.keys(err.keyPattern) : [];
    const keyString = (keyPattern.join(' ') + ' ' + (err.errmsg || err.message || '')).toLowerCase();
    
    if (keyString.includes('phone') || keyString.includes('mobile')) {
      message = 'Mobile number already registered';
    } else if (keyString.includes('email')) {
      message = 'Email already registered';
    } else if (keyString.includes('aadhar')) {
      message = 'Aadhaar number already registered';
    } else {
      message = 'Duplicate field value entered';
    }
  }

  // Handle Mongoose Validation Error
  if (err.name === 'ValidationError') {
    message = Object.values(err.errors).map(val => val.message).join(', ');
    statusCode = 400;
  }

  return ApiResponse.error(res, message, statusCode, errors);
};

export const notFound = (req, res, next) => {
  const error = new Error(`Not Found - ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
};
