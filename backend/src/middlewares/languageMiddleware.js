/**
 * Middleware to parse and normalize Accept-Language header.
 * Recognizes 'mr' (Marathi) and 'en' (English). Defaults to 'en'.
 */
export const languageMiddleware = (req, res, next) => {
  const acceptLang = req.headers['accept-language'] || req.headers['Accept-Language'] || '';
  
  if (acceptLang.toLowerCase().includes('mr')) {
    req.language = 'mr';
  } else {
    req.language = 'en';
  }

  next();
};

export default languageMiddleware;
