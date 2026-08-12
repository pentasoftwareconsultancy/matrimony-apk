import Joi from 'joi';
import { ApiResponse } from '../utils/apiResponse.js';

export const validate = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false });
    if (error) {
      const errorDetails = error.details.reduce((acc, current) => {
        const key = current.path.join('.');
        acc[key] = current.message.replace(/"/g, '');
        return acc;
      }, {});
      return ApiResponse.error(res, 'Validation Error', 400, errorDetails);
    }
    next();
  };
};

export const loginSchema = Joi.object({
  email: Joi.string().email().optional().messages({
    'string.email': 'Please enter a valid email address',
  }),
  phoneNumber: Joi.string().optional().messages({
    'string.base': 'Please enter a valid phone number',
  }),
}).or('email', 'phoneNumber').messages({
  'object.missing': 'Please provide either email or phone number to log in',
});

export const verifyOtpSchema = Joi.object({
  email: Joi.string().email().optional(),
  phoneNumber: Joi.string().optional(),
  code: Joi.string().length(4).required().messages({
    'string.length': 'OTP must be exactly 4 digits',
    'any.required': 'OTP code is required',
  }),
}).or('email', 'phoneNumber').messages({
  'object.missing': 'Email or phone number context is missing',
});

export const registerSchema = Joi.object({
  // Step 1: Account details
  accountType: Joi.string().valid('Bride', 'Groom', 'Parent', 'Guardian', 'Sibling', 'Friend', 'Relative').required().messages({
    'any.only': 'Register As must be one of Bride, Groom, Parent, Guardian, Sibling, Friend, Relative',
    'any.required': 'Register As is required',
  }),
  fullName: Joi.string().required().messages({
    'any.required': 'Full Name is required',
  }),
  phone: Joi.string().required().messages({
    'any.required': 'Phone Number is required',
  }),
  email: Joi.string().email().required().messages({
    'string.email': 'Please enter a valid email address',
    'any.required': 'Email is required',
  }),
  password: Joi.string().min(8).pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$/).required().messages({
    'string.min': 'Password must be at least 8 characters long',
    'string.pattern.base': 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
    'any.required': 'Password is required',
  }),
  confirmPassword: Joi.string().valid(Joi.ref('password')).required().messages({
    'any.only': 'Confirm password must match password',
    'any.required': 'Confirm password is required',
  }),

  // Step 2: Basic profile
  gender: Joi.string().valid('Male', 'Female', 'Other').required().messages({
    'any.required': 'Gender is required',
  }),
  dob: Joi.date().iso().required().messages({
    'any.required': 'Date of birth is required',
  }),
  religion: Joi.string().required().messages({
    'any.required': 'Religion is required',
  }),
  caste: Joi.string().required().messages({
    'any.required': 'Caste is required',
  }),
  maritalStatus: Joi.string().required().messages({
    'any.required': 'Marital Status is required',
  }),
  bloodGroup: Joi.string().required().messages({
    'any.required': 'Blood Group is required',
  }),
  address: Joi.string().allow('').optional(),
  hobbies: Joi.array().items(Joi.string()).optional(),
  rashi: Joi.string().required().messages({
    'any.required': 'Rashi is required',
  }),
  nakshatra: Joi.string().required().messages({
    'any.required': 'Nakshatra is required',
  }),
  manglik: Joi.boolean().required().messages({
    'any.required': 'Manglik field is required',
  }),

  // Step 3: Education
  qualification: Joi.string().required().messages({
    'any.required': 'Highest Qualification is required',
  }),
  occupation: Joi.string().required().messages({
    'any.required': 'Occupation is required',
  }),
  annualIncome: Joi.string().required().messages({
    'any.required': 'Annual Income is required',
  }),
  country: Joi.string().required().messages({
    'any.required': 'Country is required',
  }),
  state: Joi.string().required().messages({
    'any.required': 'State is required',
  }),
  city: Joi.string().required().messages({
    'any.required': 'City is required',
  }),
  languages: Joi.array().items(Joi.string()).min(1).required().messages({
    'array.min': 'Please select at least one language',
    'any.required': 'Languages Known is required',
  }),

  // Step 4: Family Details
  fatherName: Joi.string().required().messages({
    'any.required': 'Father name is required',
  }),
  motherName: Joi.string().required().messages({
    'any.required': 'Mother name is required',
  }),
  siblings: Joi.number().min(0).required().messages({
    'any.required': 'Number of siblings is required',
  }),
  familyType: Joi.string().required().messages({
    'any.required': 'Family type is required',
  }),
  familyStatus: Joi.string().required().messages({
    'any.required': 'Family status is required',
  }),
  nativePlace: Joi.string().required().messages({
    'any.required': 'Native place is required',
  }),
  aboutFamily: Joi.string().allow('').optional(),

  // Step 5: Documents & Photos
  aadharNumber: Joi.string().required().messages({
    'any.required': 'Aadhar card number is required',
  }),
  aadharCardUrl: Joi.string().allow('').optional(),
  photos: Joi.array().items(Joi.string()).min(3).max(6).required().messages({
    'array.min': 'Please upload at least 3 photos',
    'array.max': 'You can upload a maximum of 6 photos',
    'any.required': 'Profile photos are required',
  }),
});

export const checkUserSchema = Joi.object({
  email: Joi.string().email().optional(),
  phone: Joi.string().optional(),
  identifier: Joi.string().optional(),
}).or('email', 'phone', 'identifier');

export const sendOtpSchema = Joi.object({
  email: Joi.string().email().optional(),
  phone: Joi.string().optional(),
}).or('email', 'phone');
