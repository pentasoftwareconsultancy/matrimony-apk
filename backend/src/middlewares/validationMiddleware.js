import Joi from 'joi';
import { ApiResponse } from '../utils/apiResponse.js';

// ============================================================
// REGEX PATTERNS
// ============================================================

const phonePattern = /^\d{10}$/;

const emailPattern =
  /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

// ============================================================
// GENERIC VALIDATION MIDDLEWARE
// ============================================================

const marathiValidationMap = {
  'Validation Error': 'प्रमाणीकरण त्रुटी',
  'Please enter a valid email address': 'कृपया वैध ईमेल पत्ता प्रविष्ट करा',
  'Email is required': 'ईमेल आवश्यक आहे',
  'Password is required': 'पासवर्ड आवश्यक आहे',
  'OTP must be exactly 4 digits': 'ओटीपी अचूक ४ अंकी असावा',
  'OTP code is required': 'ओटीपी कोड आवश्यक आहे',
  'Phone number is required': 'फोन नंबर आवश्यक आहे',
  'Full name is required': 'पूर्ण नाव आवश्यक आहे',
  'is required': 'आवश्यक आहे',
};

const localizeValidationMessage = (msg, isMr) => {
  if (!isMr || !msg) return msg;
  if (marathiValidationMap[msg]) return marathiValidationMap[msg];
  if (msg.includes('is required')) {
    const field = msg.replace('is required', '').trim();
    return `${field} आवश्यक आहे`;
  }
  return msg;
};

export const validate = (schema) => {
  return (req, res, next) => {
    const isMr = req.language === 'mr';
const normalizedBody = { ...req.body };

for (const [key, value] of Object.entries(normalizedBody)) {
  if (value === '') {
    normalizedBody[key] = undefined;
  }
}

const { error, value } = schema.validate(normalizedBody, {
  abortEarly: false,
  allowUnknown: false,
});

if (!error) {
  req.body = value;
}

    if (error) {
      const errorDetails = error.details.reduce((acc, current) => {
        const key = current.path.join('.');
        const cleanMsg = current.message.replace(/"/g, '');
        acc[key] = localizeValidationMessage(cleanMsg, isMr);
        return acc;
      }, {});

      console.log('[VALIDATION FAILED]', errorDetails);

      const rawFirstMessage =
        error.details[0]?.message.replace(/"/g, '') ||
        'Validation Error';

      const firstMessage = localizeValidationMessage(rawFirstMessage, isMr);

      return ApiResponse.error(
        res,
        firstMessage,
        400,
        errorDetails
      );
    }

    next();
  };
};

// ============================================================
// LOGIN
// ============================================================

export const loginSchema = Joi.object({
  email: Joi.string()
    .trim()
    .pattern(emailPattern)
    .required()
    .messages({
      'string.pattern.base': 'Please enter a valid email address',
      'any.required': 'Email is required',
      'string.empty': 'Email is required',
    }),

  password: Joi.string()
    .required()
    .messages({
      'any.required': 'Password is required',
      'string.empty': 'Password is required',
    }),
}).unknown(true);

// ============================================================
// VERIFY OTP
// ============================================================

export const verifyOtpSchema = Joi.object({
  email: Joi.string()
    .allow('', null)
    .optional(),

  phoneNumber: Joi.string()
    .allow('', null)
    .optional(),

  phone: Joi.string()
    .allow('', null)
    .optional(),

  code: Joi.string()
    .length(4)
    .required()
    .messages({
      'string.length': 'OTP must be exactly 4 digits',
      'any.required': 'OTP code is required',
      'string.empty': 'OTP code is required',
    }),
}).unknown(true);

// ============================================================
// REGISTER
// ============================================================
//
// REQUIRED FIELDS:
// These must be supplied by the user during registration.
//
// OPTIONAL FIELDS:
// If omitted, AuthService will convert them to
// "Not Specified" where appropriate.
//
// Documents remain optional.
// ============================================================

export const registerSchema = Joi.object({

  // ----------------------------------------------------------
  // ACCOUNT / BASIC INFORMATION
  // ----------------------------------------------------------

  accountType: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required': 'Account type is required',
      'string.empty': 'Account type is required',
    }),

  fullName: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required': 'Full name is required',
      'string.empty': 'Full name is required',
    }),

  phone: Joi.string()
    .trim()
    .pattern(phonePattern)
    .required()
    .messages({
      'string.pattern.base':
        'Please enter a valid 10-digit mobile number',
      'any.required': 'Mobile number is required',
      'string.empty': 'Mobile number is required',
    }),

  email: Joi.string()
    .trim()
    .pattern(emailPattern)
    .required()
    .messages({
      'string.pattern.base':
        'Please enter a valid email address',
      'any.required': 'Email is required',
      'string.empty': 'Email is required',
    }),

  password: Joi.string()
    .min(6)
    .required()
    .messages({
      'string.min':
        'Password must be at least 6 characters long',
      'any.required': 'Password is required',
      'string.empty': 'Password is required',
    }),

  confirmPassword: Joi.string()
    .valid(Joi.ref('password'))
    .optional()
    .allow('', null)
    .messages({
      'any.only': 'Password and confirm password do not match',
    }),

  // ----------------------------------------------------------
  // PERSONAL DETAILS
  // ----------------------------------------------------------

  gender: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required': 'Gender is required',
      'string.empty': 'Gender is required',
    }),

  dob: Joi.date()
    .required()
    .messages({
      'date.base':
        'Please enter a valid date of birth',
      'any.required':
        'Date of birth is required',
    }),

  maritalStatus: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required': 'Marital status is required',
      'string.empty': 'Marital status is required',
    }),

  height: Joi.number()
    .positive()
    .messages({
      'number.base': 'Height is required',
      'number.positive': 'Height must be greater than 0',
      'any.required': 'Height is required',
    }),

  weight: Joi.number()
    .positive()
    .messages({
      'number.base': 'Weight is required',
      'number.positive': 'Weight must be greater than 0',
      'any.required': 'Weight is required',
    }),

  bloodGroup: Joi.string()
    .trim()
    .messages({
      'any.required': 'Blood group is required',
      'string.empty': 'Blood group is required',
    }),

  diet: Joi.string()
    .trim()
    .messages({
      'any.required': 'Diet is required',
      'string.empty': 'Diet is required',
    }),

  smoking: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Smoking preference is required',
      'string.empty':
        'Smoking preference is required',
    }),

  drinking: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Drinking preference is required',
      'string.empty':
        'Drinking preference is required',
    }),

  // ----------------------------------------------------------
  // EDUCATION / CAREER
  // ----------------------------------------------------------

  highestEducation: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Highest education is required',
      'string.empty':
        'Highest education is required',
    }),

  educationField: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Education field is required',
      'string.empty':
        'Education field is required',
    }),

  profession: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Profession is required',
      'string.empty':
        'Profession is required',
    }),

  occupationPosition: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Occupation position is required',
      'string.empty':
        'Occupation position is required',
    }),

  annualIncome: Joi.alternatives()
    .try(
      Joi.number().min(0),
      Joi.string()
        .trim()
        .pattern(/\d+/)
        .messages({
          'string.pattern.base': 'Annual income must include a numeric value',
        })
    )
    .required()
    .messages({
      'any.required': 'Annual income is required',
    }),

  // ----------------------------------------------------------
  // FAMILY DETAILS
  // ----------------------------------------------------------

  fatherName: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required':
        'Father name is required',
      'string.empty':
        'Father name is required',
    }),

  motherName: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required':
        'Mother name is required',
      'string.empty':
        'Mother name is required',
    }),

  familyType: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required':
        'Family type is required',
      'string.empty':
        'Family type is required',
    }),

  familyValues: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Family values are required',
      'string.empty':
        'Family values are required',
    }),

 nativePlace: Joi.string()
   .trim()
   .allow('', null)
   .optional(),

  // ----------------------------------------------------------
  // ASTROLOGY / RELIGION
  // ----------------------------------------------------------

  motherTongue: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Mother tongue is required',
      'string.empty':
        'Mother tongue is required',
    }),

  religion: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required':
        'Religion is required',
      'string.empty':
        'Religion is required',
    }),

  caste: Joi.string()
    .trim()
    .required()
    .messages({
      'any.required':
        'Caste is required',
      'string.empty':
        'Caste is required',
    }),

  // ----------------------------------------------------------
  // PARTNER PREFERENCES
  // ----------------------------------------------------------

  partnerMaritalStatus: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Partner marital status is required',
      'string.empty':
        'Partner marital status is required',
    }),

expectedAgeRange: Joi.object({
  from: Joi.number()
    .min(18)
    .optional(),

  to: Joi.number()
    .greater(Joi.ref('from'))
    .optional(),
})
  .optional()
  .allow(null),

  partnerHeight: Joi.number()
    .positive()
    .messages({
      'number.base':
        'Partner height is required',
      'number.positive':
        'Partner height must be greater than 0',
      'any.required':
        'Partner height is required',
    }),

  partnerDiet: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Partner diet is required',
      'string.empty':
        'Partner diet is required',
    }),

  partnerSmoking: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Partner smoking preference is required',
      'string.empty':
        'Partner smoking preference is required',
    }),

  partnerDrinking: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Partner drinking preference is required',
      'string.empty':
        'Partner drinking preference is required',
    }),

  partnerEducation: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Partner education is required',
      'string.empty':
        'Partner education is required',
    }),

  partnerProfession: Joi.string()
    .trim()
    .messages({
      'any.required':
        'Partner profession is required',
      'string.empty':
        'Partner profession is required',
    }),

  wantsWorkingPartner: Joi.boolean()
    .messages({
      'any.required':
        'Working partner preference is required',
    }),

  // ----------------------------------------------------------
  // OPTIONAL REGISTRATION DETAILS
  // ----------------------------------------------------------

  alternativePhoneNumber: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  pincode: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  address: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  village: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  taluka: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  district: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  state: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  country: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  // ----------------------------------------------------------
  // OPTIONAL PERSONAL DETAILS
  // ----------------------------------------------------------

  complexionType: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  specialCase: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  bodyType: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  hobbies: Joi.any().optional(),

  agriculturalLandAcres: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  about: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  // ----------------------------------------------------------
  // OPTIONAL EDUCATION DETAILS
  // ----------------------------------------------------------

  universityCollege: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  organizationName: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  companyAddress: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  // ----------------------------------------------------------
  // OPTIONAL FAMILY DETAILS
  // ----------------------------------------------------------

  fatherOccupation: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  motherOccupation: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  brothers: Joi.number()
    .min(0)
    .optional(),

  marriedBrothers: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  sisters: Joi.number()
    .min(0)
    .optional(),

  marriedSisters: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  maternalUncleName: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  maternalUnclePhone: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  uncleName: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  unclePhone: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  aboutFamily: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  maternalUnclesDetails: Joi.array()
    .items(
      Joi.object({
        name: Joi.string().trim().allow('', null).optional(),
        occupation: Joi.string().trim().allow('', null).optional(),
        profession: Joi.string().trim().allow('', null).optional(),
      }).unknown(true)
    )
    .optional(),

  unclesDetails: Joi.array()
    .items(
      Joi.object({
        name: Joi.string().trim().allow('', null).optional(),
        occupation: Joi.string().trim().allow('', null).optional(),
        profession: Joi.string().trim().allow('', null).optional(),
      }).unknown(true)
    )
    .optional(),

  // ----------------------------------------------------------
  // OPTIONAL ASTROLOGY DETAILS
  // ----------------------------------------------------------

  subCast: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  placeOfBirth: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  timeOfBirth: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  rashi: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  gotra: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  gan: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  nadi: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  charan: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  nakshatra: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  manglik: Joi.boolean().optional(),

  importanceOfPatrika: Joi.any().optional(),

  // ----------------------------------------------------------
  // OPTIONAL PARTNER DETAILS
  // ----------------------------------------------------------

  partnerWeight: Joi.number()
    .positive()
    .allow(null)
    .optional(),

  partnerWorkingLocation: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  partnerIncome: Joi.number()
    .min(0)
    .optional(),

  // ----------------------------------------------------------
  // OPTIONAL DOCUMENT DETAILS
  // ----------------------------------------------------------

  aadharNumber: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  panCardNumber: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  passportNumber: Joi.string()
    .trim()
    .allow('', null)
    .optional(),

  aadhaarFrontphoto: Joi.string()
    .allow('', null)
    .optional(),

  aadhaarBackphoto: Joi.string()
    .allow('', null)
    .optional(),

  panFrontphoto: Joi.string()
    .allow('', null)
    .optional(),

  panBackphoto: Joi.string()
    .allow('', null)
    .optional(),

  highestEducationalDoc: Joi.string()
    .allow('', null)
    .optional(),

  castecertificate: Joi.string()
    .allow('', null)
    .optional(),

  passportFrontphoto: Joi.string()
    .allow('', null)
    .optional(),

  passportBackphoto: Joi.string()
    .allow('', null)
    .optional(),

  photoFulls: Joi.string()
    .allow('', null)
    .optional(),

  photoCloseup: Joi.string()
    .allow('', null)
    .optional(),

  photoFull: Joi.string()
    .allow('', null)
    .optional(),

  familyPhoto: Joi.string()
    .allow('', null)
    .optional(),

  photos: Joi.array()
    .items(Joi.string())
    .optional(),

}).unknown(true);

// ============================================================
// CHECK USER
// ============================================================

export const checkUserSchema = Joi.object({
  email: Joi.string()
    .allow('', null)
    .optional(),

  phone: Joi.string()
    .allow('', null)
    .optional(),

  identifier: Joi.string()
    .allow('', null)
    .optional(),
}).unknown(true);

// ============================================================
// SEND OTP
// ============================================================

export const sendOtpSchema = Joi.object({
  email: Joi.string()
    .allow('', null)
    .optional(),

  phone: Joi.string()
    .allow('', null)
    .optional(),
}).unknown(true);

// ============================================================
// FORGOT PASSWORD
// ============================================================

export const forgotPasswordSchema = Joi.object({
  identifier: Joi.string()
    .required()
    .messages({
      'any.required':
        'Email or mobile number is required',
      'string.empty':
        'Email or mobile number is required',
    }),
}).unknown(true);

// ============================================================
// RESET PASSWORD
// ============================================================

export const resetPasswordSchema = Joi.object({
  identifier: Joi.string()
    .required()
    .messages({
      'any.required':
        'Email or mobile number is required',
      'string.empty':
        'Email or mobile number is required',
    }),

  code: Joi.string()
    .length(4)
    .required()
    .messages({
      'string.length':
        'OTP must be exactly 4 digits',
      'any.required':
        'OTP code is required',
      'string.empty':
        'OTP code is required',
    }),

  newPassword: Joi.string()
    .min(6)
    .required()
    .messages({
      'string.min':
        'Password must be at least 6 characters long',
      'any.required':
        'New password is required',
      'string.empty':
        'New password is required',
    }),

  confirmPassword: Joi.string()
    .allow('', null)
    .optional(),
}).unknown(true);

// ============================================================
// CHANGE PASSWORD
// ============================================================

export const changePasswordSchema = Joi.object({
  currentPassword: Joi.string()
    .required()
    .messages({
      'any.required':
        'Current password is required',
      'string.empty':
        'Current password is required',
    }),

  newPassword: Joi.string()
    .min(6)
    .required()
    .messages({
      'string.min':
        'New password must be at least 6 characters long',
      'any.required':
        'New password is required',
      'string.empty':
        'New password is required',
    }),

  confirmPassword: Joi.string()
    .allow('', null)
    .optional(),
}).unknown(true);