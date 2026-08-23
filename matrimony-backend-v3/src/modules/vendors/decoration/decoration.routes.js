// routes/decorationRoutes.js
import express from "express";
import multer from "multer";
import {
  createDecoration,
  getAllDecorations,
  getDecorationById,
  updateDecoration,
  deleteDecoration,
} from "./decoration.controller.js";

const router = express.Router();

// ✅ Multer setup for file uploads (store temp before sending to Cloudinary)
const storage = multer.diskStorage({});
const upload = multer({ storage });

// Routes
router.post(
  "/",
  upload.fields([
    { name: "image", maxCount: 1 }, // main image
    { name: "images", maxCount: 10 }, // gallery images
  ]),
  createDecoration
);

router.get("/", getAllDecorations);
router.get("/:id", getDecorationById);

router.put(
  "/:id",
  upload.fields([
    { name: "image", maxCount: 1 },
    { name: "images", maxCount: 10 },
  ]),
  updateDecoration
);

router.delete("/:id", deleteDecoration);

export default router;
