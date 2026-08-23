import express from "express";
import multer from "multer";
import {
  createJewellery,
  getAllJewellery,
  getJewelleryById,
  updateJewellery,
  deleteJewellery,
} from "./jewellery.controller.js";

const router = express.Router();
const storage = multer.diskStorage({});
const upload = multer({ storage });

router.post("/", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), createJewellery);
router.get("/", getAllJewellery);
router.get("/:id", getJewelleryById);
router.put("/:id", upload.fields([{ name: "image", maxCount: 1 }, { name: "images", maxCount: 10 }]), updateJewellery);
router.delete("/:id", deleteJewellery);

export default router;
