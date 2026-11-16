import { v2 as cloudinary } from 'cloudinary';
import { Readable } from 'stream';

export const uploadBuffer = (buffer, folder = 'matrimony', options = {}) => {
  return new Promise((resolve, reject) => {
    const cloudName = process.env.CLOUDINARY_CLOUD_NAME?.trim();
    const apiKey = process.env.CLOUDINARY_API_KEY?.trim();
    const apiSecret = process.env.CLOUDINARY_API_SECRET?.trim();

    if (!cloudName || !apiKey || !apiSecret) {
      const error = new Error('Media storage is not configured on the server');
      error.statusCode = 503;
      return reject(error);
    }

    cloudinary.config({
      cloud_name: cloudName,
      api_key: apiKey,
      api_secret: apiSecret,
    });

    const uploadStream = cloudinary.uploader.upload_stream(
      {
        folder,
        resource_type: options.resourceType || 'auto',
      },
      (error, result) => {
        if (error) {
          console.error('[CLOUDINARY ERROR]', error);
          return reject(error);
        }
        resolve(result);
      }
    );

    const readStream = Readable.from(buffer);
    readStream.on('error', reject);
    uploadStream.on('error', reject);
    readStream.pipe(uploadStream);
  });
};
