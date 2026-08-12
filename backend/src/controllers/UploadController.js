import { uploadBuffer } from '../utils/cloudinary.js';
import { ApiResponse } from '../utils/apiResponse.js';

class UploadController {
  async uploadFiles(req, res, next) {
    try {
      const files = req.files;
      let aadharUrl = '';
      const photoUrls = [];

      // 1. Upload Aadhaar Card if present
      if (files && files['aadharCard'] && files['aadharCard'][0]) {
        const aadharFile = files['aadharCard'][0];
        const result = await uploadBuffer(aadharFile.buffer, 'aadhar_cards');
        aadharUrl = result.secure_url;
      }

      // 2. Upload Profile Photos if present
      if (files && files['photos']) {
        for (const photoFile of files['photos']) {
          const result = await uploadBuffer(photoFile.buffer, 'profile_photos');
          photoUrls.push(result.secure_url);
        }
      }

      return ApiResponse.success(res, 'Files uploaded successfully', {
        aadharUrl,
        photoUrls
      }, 200);
    } catch (error) {
      console.error('[UPLOAD ERROR]', error);
      next(error);
    }
  }
}

export default new UploadController();
