import multer from 'multer';
import path from 'path';

export const MAX_UPLOAD_SIZE_BYTES = 5 * 1024 * 1024; // 5 MB

const IMAGE_MIME_TYPES = new Set([
  'image/jpeg',
  'image/jpg',
  'image/png',
  'image/webp',
]);

const DOCUMENT_MIME_TYPES = new Set([
  ...IMAGE_MIME_TYPES,
  'application/pdf',
]);

const IMAGE_EXTENSIONS = new Set(['.jpg', '.jpeg', '.png', '.webp']);
const DOCUMENT_EXTENSIONS = new Set([...IMAGE_EXTENSIONS, '.pdf']);

function detectBufferKind(buffer) {
  if (!Buffer.isBuffer(buffer) || buffer.length < 4) return null;

  // JPEG: FF D8 FF
  if (buffer[0] === 0xff && buffer[1] === 0xd8 && buffer[2] === 0xff) {
    return 'image/jpeg';
  }
  // PNG: 89 50 4E 47 0D 0A 1A 0A
  if (
    buffer.length >= 8 &&
    buffer[0] === 0x89 &&
    buffer[1] === 0x50 &&
    buffer[2] === 0x4e &&
    buffer[3] === 0x47 &&
    buffer[4] === 0x0d &&
    buffer[5] === 0x0a &&
    buffer[6] === 0x1a &&
    buffer[7] === 0x0a
  ) {
    return 'image/png';
  }
  // WEBP: RIFF....WEBP
  if (
    buffer.length >= 12 &&
    buffer.subarray(0, 4).toString('ascii') === 'RIFF' &&
    buffer.subarray(8, 12).toString('ascii') === 'WEBP'
  ) {
    return 'image/webp';
  }
  // PDF: %PDF-
  if (
    buffer.length >= 5 &&
    buffer.subarray(0, 5).toString('ascii') === '%PDF-'
  ) {
    return 'application/pdf';
  }

  return null;
}

export function createUploadFields(fields, { pdfFields = [] } = {}) {
  const pdfSet = new Set(pdfFields);

  return multer({
    storage: multer.memoryStorage(),
    limits: {
      fileSize: MAX_UPLOAD_SIZE_BYTES,
      files: fields.reduce((sum, f) => sum + (f.maxCount || 1), 0),
    },
    fileFilter: (_req, file, cb) => {
      const allowsPdf = pdfSet.has(file.fieldname);
      const allowedMimes = allowsPdf ? DOCUMENT_MIME_TYPES : IMAGE_MIME_TYPES;
      const allowedExts = allowsPdf ? DOCUMENT_EXTENSIONS : IMAGE_EXTENSIONS;

      const ext = path.extname(file.originalname || '').toLowerCase();
      const mime = (file.mimetype || '').toLowerCase();

      // Some mobile pickers send application/octet-stream while preserving extension;
      // final verification is always performed on magic bytes below.
      const mimeValid =
        allowedMimes.has(mime) || mime === 'application/octet-stream';
      const extValid = !ext || allowedExts.has(ext);

      if (!mimeValid || !extValid) {
        const error = new Error(
          `Unsupported file type for ${file.fieldname}. Allowed: ${
            allowsPdf ? 'JPG, PNG, WEBP, PDF' : 'JPG, PNG, WEBP'
          }`
        );
        error.statusCode = 400;
        return cb(error);
      }

      cb(null, true);
    },
  }).fields(fields);
}

export function validateUploadedFile(file, { allowPdf = false } = {}) {
  const detectedKind = detectBufferKind(file?.buffer);
  if (!detectedKind) {
    const error = new Error(
      `Invalid or corrupted file content for ${file?.fieldname || 'upload'}`
    );
    error.statusCode = 400;
    throw error;
  }
  if (detectedKind === 'application/pdf' && !allowPdf) {
    const error = new Error(
      `PDF files are not allowed for ${file?.fieldname || 'image upload'}`
    );
    error.statusCode = 400;
    throw error;
  }
  return detectedKind;
}

export function createUploadRateLimiter({
  windowMs = 15 * 60 * 1000,
  maxRequests = 20,
} = {}) {
  const hits = new Map();

  return (req, res, next) => {
    const now = Date.now();
    const key = req.ip || req.socket?.remoteAddress || 'unknown';
    const existing = hits.get(key);

    if (!existing || now > existing.resetAt) {
      hits.set(key, { count: 1, resetAt: now + windowMs });
      return next();
    }

    existing.count += 1;
    if (existing.count > maxRequests) {
      const error = new Error(
        'Too many upload requests. Please try again later.'
      );
      error.statusCode = 429;
      return next(error);
    }

    return next();
  };
}

