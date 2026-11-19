import ProfileService from '../services/ProfileService.js';
import { ApiResponse } from '../utils/apiResponse.js';
import { validateUploadedFile } from '../middlewares/uploadMiddleware.js';
import { uploadBuffer } from '../utils/cloudinary.js';

class ProfileController {
  async getMyProfile(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const profileObj = await ProfileService.getProfileByUserId(userId);
      if (!profileObj) {
        return ApiResponse.error(res, 'Profile not found', 404);
      }

      return ApiResponse.success(res, 'Profile retrieved successfully', { profile: profileObj }, 200);
    } catch (error) {
      next(error);
    }
  }

  async updateMyProfile(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const profileObj = await ProfileService.updateProfile(userId, req.body);
      return ApiResponse.success(res, 'Profile updated successfully', { profile: profileObj }, 200);
    } catch (error) {
      next(error);
    }
  }

  async uploadPhoto(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const file = req.file || (req.files && (req.files['photo']?.[0] || req.files['photos']?.[0]));
      if (!file) {
        return ApiResponse.error(res, 'No photo uploaded', 400);
      }
      validateUploadedFile(file, { allowPdf: false });
      const result = await uploadBuffer(file.buffer, 'profile_photos');
      const photoUrl = result.secure_url;
      const profile = await ProfileService.addPhoto(userId, photoUrl);
      return ApiResponse.success(res, 'Photo uploaded successfully', { profile, photoUrl }, 200);
    } catch (error) {
      next(error);
    }
  }

  async uploadDocument(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const docId = (req.body?.docId || req.body?.type || '').toString().trim().toLowerCase();
      const file = req.file || (req.files && (req.files['document']?.[0] || req.files['file']?.[0]));
      if (!file) {
        return ApiResponse.error(res, 'No document file uploaded', 400);
      }
      validateUploadedFile(file, { allowPdf: true });
      const result = await uploadBuffer(file.buffer, 'kyc_documents');
      const documentUrl = result.secure_url;
      const profile = await ProfileService.uploadDocument(userId, docId, documentUrl);
      return ApiResponse.success(
        res,
        'Document uploaded successfully. Verification pending.',
        { profile, documentUrl },
        200
      );
    } catch (error) {
      next(error);
    }
  }

  async deleteDocument(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const profile = await ProfileService.removeDocument(userId, req.params.docId);
      return ApiResponse.success(res, 'Document removed successfully', { profile }, 200);
    } catch (error) {
      next(error);
    }
  }

  async deletePhoto(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const { photoUrl } = req.body;
      const profile = await ProfileService.removePhoto(userId, photoUrl);
      return ApiResponse.success(res, 'Photo deleted successfully', { profile }, 200);
    } catch (error) {
      next(error);
    }
  }

  async savePartnerPreference(req, res, next) {
    try {
      const userId = req.user._id || req.user.id;
      const profile = await ProfileService.savePartnerPreference(userId, req.body);
      return ApiResponse.success(res, 'Partner preferences saved successfully', { profile }, 200);
    } catch (error) {
      next(error);
    }
  }

  async getMatches(req, res, next) {
    try {
      const userId = req.user ? (req.user._id || req.user.id) : null;
      const matches = await ProfileService.getMatches(userId, req.query);
      return ApiResponse.success(res, 'Matches retrieved successfully', matches, 200);
    } catch (error) {
      next(error);
    }
  }

  async getProfileById(req, res, next) {
    try {
      const viewerId = req.user ? (req.user._id || req.user.id) : null;
      const profile = await ProfileService.getProfileById(req.params.id, viewerId);
      if (!profile) {
        return ApiResponse.error(res, 'Profile not found', 404);
      }
      return ApiResponse.success(res, 'Profile retrieved successfully', { profile }, 200);
    } catch (error) {
      next(error);
    }
  }

  async recordView(req, res, next) {
    try {
      const viewerUserId = req.user._id || req.user.id;
      const { id } = req.params;
      const result = await ProfileService.recordProfileView(viewerUserId, id);
      return ApiResponse.success(res, 'Profile view recorded', { view: result }, 200);
    } catch (error) {
      next(error);
    }
  }

  async getProfileViews(req, res, next) {
    try {
      const viewedUserId = req.user._id || req.user.id;
      const result = await ProfileService.getProfileViews(viewedUserId);
      return ApiResponse.success(res, 'Profile views retrieved', result, 200);
    } catch (error) {
      next(error);
    }
  }
}

export default new ProfileController();
