import { v2 as cloudinary } from 'cloudinary';
import { Readable } from 'stream';

cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME || 'mock',
  api_key: process.env.CLOUDINARY_API_KEY || 'mock',
  api_secret: process.env.CLOUDINARY_API_SECRET || 'mock',
});

export const uploadBuffer = (buffer, folder = 'matrimony') => {
  return new Promise((resolve, reject) => {
    // If no credentials configured, simulate a successful upload for development convenience
    if (!process.env.CLOUDINARY_CLOUD_NAME || !process.env.CLOUDINARY_API_KEY || !process.env.CLOUDINARY_API_SECRET) {
      console.log(`[CLOUDINARY MOCK] Simulating file upload to folder: ${folder}`);
      const randomId = Math.random().toString(36).substring(7);
      return resolve({
        secure_url: `https://res.cloudinary.com/demo/image/upload/v12345678/${folder}/${randomId}.png`,
        public_id: `${folder}/${randomId}`
      });
    }

    const uploadStream = cloudinary.uploader.upload_stream(
      { folder },
      (error, result) => {
        if (error) {
          console.error('[CLOUDINARY ERROR]', error);
          return reject(error);
        }
        resolve(result);
      }
    );
    Readable.from(buffer).pipe(uploadStream);
  });
};
