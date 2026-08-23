


import express from "express";
import {
  addFavorite,
  getFavorites,
  removeFavorite,
  removeFavorites,
  checkFavorite
  
} from "./favorite.controller.js";
import authMiddleware from '../../middleware/authMiddleware.js';

const router = express.Router();

// Add profile to favorites
router.post("/add", authMiddleware, addFavorite);

// Get all favorites of a user
router.get("/:userId", authMiddleware, getFavorites);
// router.js - Update the routes
router.get("/check/:userId/:profileId", authMiddleware, checkFavorite);

// Remove from favorites - FIXED: Added missing slash
router.delete("/remove/:userId/:profileId", authMiddleware, removeFavorite);
router.delete("/remove:userId/:profileId",authMiddleware, removeFavorites);

export default router;