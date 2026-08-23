import express from "express";
import { loginAny } from "./auth.controller.js";

const router = express.Router();

router.post("/login", loginAny);

export default router;
