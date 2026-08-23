import express from "express";
import multer from "multer";
import {
  createLighting,
  getAllLightings,
  getLightingById,
  updateLighting,
  deleteLighting,
} from "./lighting.controller.js";

const router = express.Router();
const storage = multer.diskStorage({});
const upload = multer({ storage });

router.post("/", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), createLighting);
router.get("/", getAllLightings);
router.get("/:id", getLightingById);
router.put("/:id", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), updateLighting);
router.delete("/:id", deleteLighting);

export default router;
