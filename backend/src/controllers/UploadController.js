
import { uploadBuffer } from '../utils/cloudinary.js';
import { ApiResponse } from '../utils/apiResponse.js';
import { validateUploadedFile } from '../middlewares/uploadMiddleware.js';

class UploadController {
  async uploadFiles(req, res, next) {
    try {
      const files = req.files || {};

      const aadharFile = files.aadharCard?.[0];
      const aadharBackFile = files.aadharCardBack?.[0];
      const casteFile = files.casteCertificate?.[0];
      const photoFiles = files.photos || [];

      if (
        !aadharFile &&
        !aadharBackFile &&
        !casteFile &&
        photoFiles.length === 0
      ) {
        return ApiResponse.error(res, 'No files uploaded', 400);
      }

      // Validate files before uploading
      if (aadharFile) {
        validateUploadedFile(aadharFile, { allowPdf: true });
      }

      if (aadharBackFile) {
        validateUploadedFile(aadharBackFile, { allowPdf: true });
      }

      if (casteFile) {
        validateUploadedFile(casteFile, { allowPdf: true });
      }

      for (const photo of photoFiles) {
        validateUploadedFile(photo, { allowPdf: false });
      }

      let aadharUrl = '';
      let aadharBackUrl = '';
      let casteCertificateUrl = '';
      const photoUrls = [];

      if (aadharFile) {
        const result = await uploadBuffer(
          aadharFile.buffer,
          'aadhar_cards'
        );
        aadharUrl = result.secure_url;
      }

      if (aadharBackFile) {
        const result = await uploadBuffer(
          aadharBackFile.buffer,
          'aadhar_cards'
        );
        aadharBackUrl = result.secure_url;
      }

      if (casteFile) {
        const result = await uploadBuffer(
          casteFile.buffer,
          'caste_certificates'
        );
        casteCertificateUrl = result.secure_url;
      }

      for (const photo of photoFiles) {
        const result = await uploadBuffer(
          photo.buffer,
          'profile_photos'
        );
        photoUrls.push(result.secure_url);
      }

      return ApiResponse.success(
        res,
        'Files uploaded successfully',
        {
          aadharUrl,
          aadharBackUrl,
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
