import express from "express";
import multer from "multer";
import {
  createMakeup,
  getAllMakeup,
  getMakeupById,
  updateMakeup,
  deleteMakeup,
} from "./makeup.controller.js";

const router = express.Router();
const storage = multer.diskStorage({});
const upload = multer({ storage });

router.post("/", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), createMakeup);
router.get("/", getAllMakeup);
router.get("/:id", getMakeupById);
router.put("/:id", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), updateMakeup);
router.delete("/:id", deleteMakeup);

export default router;
