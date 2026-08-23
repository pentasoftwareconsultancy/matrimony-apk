import Joi from 'joi';
import { ApiResponse } from '../utils/apiResponse.js';

// Standard regex patterns matching website backend
const phonePattern = /^\d{10}$/; // Exactly 10 digits
const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

export const validate = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false, allowUnknown: true });
    if (error) {
      const errorDetails = error.details.reduce((acc, current) => {
        const key = current.path.join('.');
        acc[key] = current.message.replace(/"/g, '');
        return acc;
      }, {});
      console.log('[VALIDATION FAILED]', errorDetails);
      const firstMessage = error.details[0]?.message.replace(/"/g, '') || 'Validation Error';
      return ApiResponse.error(res, firstMessage, 400, errorDetails);
    }
    next();
  };
};

export const loginSchema = Joi.object({
  email: Joi.string().trim().pattern(emailPattern).required().messages({
    'string.pattern.base': 'Please enter a valid email address',
    'any.required': 'Email is required',
    'string.empty': 'Email is required',
  }),
  password: Joi.string().required().messages({
    'any.required': 'Password is required',
    'string.empty': 'Password is required',
  }),
}).unknown(true);

export const verifyOtpSchema = Joi.object({
  email: Joi.string().allow('', null).optional(),
  phoneNumber: Joi.string().allow('', null).optional(),
  phone: Joi.string().allow('', null).optional(),
  code: Joi.string().length(4).required().messages({
    'string.length': 'OTP must be exactly 4 digits',
    'any.required': 'OTP code is required',
  }),
}).unknown(true);

export const registerSchema = Joi.object({
  accountType: Joi.string().allow('', null).optional(),
  fullName: Joi.string().required().messages({
    'any.required': 'Full name is required',
    'string.empty': 'Full name is required',
  }),
  phone: Joi.string().allow('', null).optional(),
  phoneNumber: Joi.string().allow('', null).optional(),
  email: Joi.string().trim().pattern(emailPattern).required().messages({
    'string.pattern.base': 'Please enter a valid email address',
    'any.required': 'Email is required',
    'string.empty': 'Email is required',
  }),
  password: Joi.string().min(6).required().messages({
    'string.min': 'Password must be at least 6 characters long',
    'any.required': 'Password is required',
    'string.empty': 'Password is required',
  }),
}).unknown(true);

export const checkUserSchema = Joi.object({
  email: Joi.string().allow('', null).optional(),
  phone: Joi.string().allow('', null).optional(),
  identifier: Joi.string().allow('', null).optional(),
}).unknown(true);

export const sendOtpSchema = Joi.object({
  email: Joi.string().allow('', null).optional(),
  phone: Joi.string().allow('', null).optional(),
}).unknown(true);

export const forgotPasswordSchema = Joi.object({
  identifier: Joi.string().required().messages({
    'any.required': 'Email or mobile number is required',
  }),
}).unknown(true);

export const resetPasswordSchema = Joi.object({
  identifier: Joi.string().required(),
  code: Joi.string().length(4).required(),
  newPassword: Joi.string().min(6).required(),
  confirmPassword: Joi.string().allow('', null).optional(),
}).unknown(true);

export const changePasswordSchema = Joi.object({
  currentPassword: Joi.string().required(),
  newPassword: Joi.string().min(6).required(),
  confirmPassword: Joi.string().allow('', null).optional(),
}).unknown(true);
