import express from "express";
import { getNearmeProfiles, getSingleProfile } from "./nearme.controller.js";

const router = express.Router();

// Dynamic route parameter
router.get("/:userId", getNearmeProfiles);
router.get("/details/:id", getSingleProfile);

export default router;
