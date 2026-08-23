import express from "express";
import multer from "multer";
import {
  createPhotographer,
  getAllPhotographers,
  getPhotographerById,
  updatePhotographer,
  deletePhotographer,
} from "./photographer.controller.js";

const router = express.Router();
const storage = multer.diskStorage({});
const upload = multer({ storage });

router.post("/", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), createPhotographer);
router.get("/", getAllPhotographers);
router.get("/:id", getPhotographerById);
router.put("/:id", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), updatePhotographer);
router.delete("/:id", deletePhotographer);

export default router;
