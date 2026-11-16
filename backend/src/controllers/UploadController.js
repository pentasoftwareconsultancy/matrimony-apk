import { uploadBuffer } from '../utils/cloudinary.js';
import { ApiResponse } from '../utils/apiResponse.js';
import { validateUploadedFile } from '../middlewares/uploadMiddleware.js';

class UploadController {
  async uploadFiles(req, res, next) {
    try {
      const files = req.files || {};
      let aadharUrl = '';
      let casteCertificateUrl = '';
      const photoUrls = [];

      const aadharFile = files['aadharCard']?.[0];
      const casteFile = files['casteCertificate']?.[0];
      const photoFiles = files['photos'] || [];

      if (!aadharFile && !casteFile && photoFiles.length === 0) {
        return ApiResponse.error(res, 'No files uploaded', 400);
      }

      // Validate all file signatures before uploading any file
      if (aadharFile) {
        validateUploadedFile(aadharFile, { allowPdf: true });
      }
      if (casteFile) {
        validateUploadedFile(casteFile, { allowPdf: true });
      }
      for (const photoFile of photoFiles) {
        validateUploadedFile(photoFile, { allowPdf: false });
      }

      if (aadharFile) {
        const result = await uploadBuffer(aadharFile.buffer, 'aadhar_cards');
        aadharUrl = result.secure_url;
      }

      if (casteFile) {
        const result = await uploadBuffer(casteFile.buffer, 'caste_certificates');
        casteCertificateUrl = result.secure_url;
      }

      for (const photoFile of photoFiles) {
        const result = await uploadBuffer(photoFile.buffer, 'profile_photos');
        photoUrls.push(result.secure_url);
      }

      return ApiResponse.success(
        res,
        'Files uploaded successfully',
        {
          aadharUrl,
          casteCertificateUrl,
          photoUrls,
        },
        200
      );
    } catch (error) {
      console.error('[UPLOAD ERROR]', error);
      next(error);
    }
  }
}

export default new UploadController();
