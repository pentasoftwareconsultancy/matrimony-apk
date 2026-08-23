import express from "express";
import multer from "multer";
import {
  createMatchesGallery,
  getAllMatchesGallery,
  getMatchesGalleryById,
  updateMatchesGallery,
  deleteMatchesGallery,
  deleteGalleryImage
} from "./matchesgallary.controller.js";

const router = express.Router();

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname);
  }
});

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB limit
  }
});

// Create gallery item with multiple images
router.post("/create", upload.array("images", 10), createMatchesGallery);

// Get all gallery items
router.get("/getmatches", getAllMatchesGallery);

// Get single gallery item by ID
router.get("/getmatchesid/:id", getMatchesGalleryById);

// Update gallery item (add new images or update description)
router.put("/update/:id", upload.array("images", 10), updateMatchesGallery);

// Delete entire gallery item
router.delete("/delete/:id", deleteMatchesGallery);

// Delete single image from gallery item
// router.delete("/:id/images/:imageIndex", deleteGalleryImage);

export default router;