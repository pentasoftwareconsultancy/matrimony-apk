import express from "express";
import multer from "multer";
import {
  createMehendi,
  getAllMehendi,
  getMehendiById,
  updateMehendi,
  deleteMehendi,
} from "./mehndi.controller.js";

const router = express.Router();
const storage = multer.diskStorage({});
const upload = multer({ storage });

router.post("/", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), createMehendi);
router.get("/", getAllMehendi);
router.get("/:id", getMehendiById);
router.put("/:id", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), updateMehendi);
router.delete("/:id", deleteMehendi);

export default router;
