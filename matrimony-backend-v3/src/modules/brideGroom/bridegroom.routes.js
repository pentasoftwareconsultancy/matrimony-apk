
import express from 'express';
import upload from '../middleware/multer.js';
import { userRegister,updateProfile,loginBrideGroom,logoutBrideGroom,forgotPassword,
  verifyOTP,
  resetPassword,} from '../auth/auth.controller.js';
import { getProfiles,deleteProfileById,getProfileById, getProfiless} from './bridegroom.controller.js';
import {  getMatches, getNearMeProfiles, getNewProfiles, filterUsers,getFilterOptions, getUserById,
  
 } from '../controllers/ProfileController.js';
import authMiddleware from '../middleware/authMiddleware.js';
const router = express.Router();

router.post(
  '/register',
  upload.fields([
    { name: 'aadhaarFrontphoto', maxCount: 1 },
    { name: 'aadhaarBackphoto', maxCount: 1 },
    { name: 'panFrontphoto', maxCount: 1 },
    { name: 'panBackphoto', maxCount: 1 },
    { name: 'passportFrontphoto', maxCount: 1 },
    { name: 'passportBackphoto', maxCount: 1 },
    { name: 'photoFulls', maxCount: 1 },
    { name: 'highestEducationalDoc', maxCount: 1 },
    { name: 'castecertificate', maxCount: 1 },
    { name: 'photoCloseup', maxCount: 1 },
    { name: 'photoFull', maxCount: 1 },
    { name: 'familyPhoto', maxCount: 1 },
  ]),
  userRegister);

router.post('/login', loginBrideGroom);
router.post("/logout", authMiddleware, logoutBrideGroom);
// @route POST /api/matrimony/forgot-password
router.post("/forgot-password", forgotPassword);

// @route POST /api/matrimony/verify-otp
router.post("/verify-otp", verifyOTP);

// @route POST /api/matrimony/reset-password
router.post("/reset-password", resetPassword);
router.get('/getprofiles',getProfiles)
// for test purpose
router.get('/getprofiless',getProfiless)

router.put('/updateprofile/:id',authMiddleware,upload.fields([
  { name: 'aadhaarFrontphoto', maxCount: 1 },
  { name: 'aadhaarBackphoto', maxCount: 1 },
  { name: 'panFrontphoto', maxCount: 1 },
  { name: 'panBackphoto', maxCount: 1 },
  { name: 'passportFrontphoto', maxCount: 1 },
  { name: 'passportBackphoto', maxCount: 1 },
  { name: 'photoFulls', maxCount: 1 },
  { name: 'highestEducationalDoc', maxCount: 1 },
  { name: 'castecertificate', maxCount: 1 },
  
  { name: 'photoCloseup', maxCount: 1 },
  { name: 'photoFull', maxCount: 1 },
  { name: 'familyPhoto', maxCount: 1 }
]), updateProfile);


// GET /api/profiles/near-me?pincode=422605 OR district/state
router.get('/near-me/:id', getNearMeProfiles);

// GET /api/profiles/new
router.get('/new',authMiddleware, getNewProfiles);

// delete profile
router.delete('/deleteprofile/:id',authMiddleware,deleteProfileById)


router.get('/getprofile/:id',authMiddleware,getProfileById)

router.get('/getprofile/:id',getProfileById)

router.get("/partnermatch/:id",authMiddleware, getMatches);
// router.get("/filter", filterUsers);
// router.get("/options", getFilterOptions);
// router.get("/:id", getUserById);

router.get("/filter", authMiddleware, filterUsers);
router.get("/options", authMiddleware, getFilterOptions);
router.get("/:id", authMiddleware, getUserById);


export default router;