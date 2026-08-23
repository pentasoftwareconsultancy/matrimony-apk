// routes/djMusicRoutes.js
import express from "express";
import multer from "multer";
import {
  createDJMusic,
  getAllDJMusic,
  getDJMusicById,
  updateDJMusic,
  deleteDJMusic,
} from "./djmusic.controller.js";

const router = express.Router();

// ✅ Multer setup for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/"); // temporary storage before Cloudinary
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + "-" + file.originalname);
  },
});
const upload = multer({ storage });

// --------------------- Routes ---------------------

// CREATE DJMusic
router.post(
  "/",
  upload.fields([
    { name: "image", maxCount: 1 },      // main image
    { name: "images", maxCount: 10 },    // gallery images
  ]),
  createDJMusic
);

// GET All DJMusic
router.get("/", getAllDJMusic);

// GET DJMusic by ID
router.get("/:id", getDJMusicById);

// UPDATE DJMusic
router.put(
  "/:id",
  upload.fields([
    { name: "image", maxCount: 1 },
    { name: "images", maxCount: 10 },
  ]),
  updateDJMusic
);

router.delete("/:id", deleteDJMusic);

export default router;
