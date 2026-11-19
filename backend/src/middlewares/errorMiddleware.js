import { ApiResponse } from '../utils/apiResponse.js';

export const errorHandler = (err, req, res, next) => {
  console.error('--- ERROR LOG ---');
  console.error(err.stack || err);
  console.error('-----------------');

  // Custom errors or Mongoose errors
  const isMr = req.language === 'mr';
  let statusCode = err.statusCode || 500;
  let message = err.message || (isMr ? 'अंतर्गत सर्व्हर त्रुटी' : 'Internal Server Error');
  let errors = err.errors || null;

  // Handle Mongoose Bad ObjectID
  if (err.name === 'CastError') {
    message = isMr
      ? `संसाधन आढळले नाही (${err.value})`
      : `Resource not found with id of ${err.value}`;
    statusCode = 404;
  }

  // Handle Mongoose Duplicate Key Error
  if (err.code === 11000) {
    statusCode = 409;
    const keyPattern = err.keyPattern ? Object.keys(err.keyPattern) : [];
    const keyString = (keyPattern.join(' ') + ' ' + (err.errmsg || err.message || '')).toLowerCase();
    
    if (keyString.includes('phone') || keyString.includes('mobile')) {
      message = isMr ? 'हा मोबाईल क्रमांक आधीच नोंदणीकृत आहे' : 'Mobile number already registered';
    } else if (keyString.includes('email')) {
      message = isMr ? 'हा ईमेल आधीच नोंदणीकृत आहे' : 'Email already registered';
    } else if (keyString.includes('aadhar')) {
      message = isMr ? 'हा आधार क्रमांक आधीच नोंदणीकृत आहे' : 'Aadhaar number already registered';
    } else {
      message = isMr ? 'नोंद आधीच अस्तित्वात आहे' : 'Duplicate field value entered';
    }
  }

  // Handle Mongoose Validation Error
  if (err.name === 'ValidationError') {
    message = Object.values(err.errors).map(val => val.message).join(', ');
    statusCode = 400;
  }

  // Handle Multer File Upload Errors
  if (err.name === 'MulterError') {
    statusCode = 400;
    if (err.code === 'LIMIT_FILE_SIZE') {
      message = isMr
        ? 'अपलोड केलेली फाईल ५ MB मर्यादेपेक्षा मोठी आहे'
        : 'Uploaded file exceeds the 5MB size limit';
    } else if (err.code === 'LIMIT_FILE_COUNT') {
      message = isMr ? 'खूप साऱ्या फाईल्स अपलोड केल्या आहेत' : 'Too many files uploaded';
    } else {
      message = isMr ? 'अवैध फाईल अपलोड' : (err.message || 'Invalid file upload');
    }
  }

  // Localize common generic messages if in Marathi
  if (isMr) {
    if (message === 'Internal Server Error') message = 'अंतर्गत सर्व्हर त्रुटी';
    if (message === 'Unauthorized' || message === 'Not authorized to access this route') {
      message = 'प्रवेश अनधिकृत आहे';
    }
    if (message === 'Invalid credentials' || message === 'Invalid email or password') {
      message = 'अवैध ईमेल किंवा पासवर्ड';
    }
  }

  return ApiResponse.error(res, message, statusCode, errors);
};

export const notFound = (req, res, next) => {
  const isMr = req.language === 'mr';
  const error = new Error(isMr ? `सापडले नाही - ${req.originalUrl}` : `Not Found - ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
};
