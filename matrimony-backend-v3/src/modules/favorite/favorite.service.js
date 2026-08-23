import mongoose from "mongoose";
import Favorite from "./favorite.schema.js";
import Matrimony from "../brideGroom/bridegroom.schema.js";

// 👉 Add to Favorites
export const addFavorite = async (userId, profileId) => {
  // check if profile exists
  const profile = await Matrimony.findById(profileId);
  if (!profile) {
    return { statusCode: 404, body: { message: "Profile not found" } };
  }

  // Check if already favorited
  const existingFavorite = await Favorite.findOne({ userId, profileId });
  if (existingFavorite) {
    return { statusCode: 400, body: { message: "Profile already in favorites" } };
  }

  // create new favorite
  const favorite = new Favorite({
    userId,
    profileId,
    isFavorite: true
  });

  await favorite.save();

  return {
    statusCode: 200,
    body: { message: "Profile added to favorites", favorite },
  };
};

// 👉 Get User's Favorite Profiles
export const getFavorites = async (userId) => {
  const favorites = await Favorite.find({ userId, isFavorite: true })
    .populate("profileId");

  return {
    statusCode: 200,
    body: { message: "Favorites fetched successfully", favorites },
  };
};

// 👉 Check if a specific profile is favorited by a user
export const checkFavorite = async (userId, profileId) => {
  const favorite = await Favorite.findOne({
    userId: new mongoose.Types.ObjectId(userId),
    profileId: new mongoose.Types.ObjectId(profileId),
    isFavorite: true
  });

  return {
    statusCode: 200,
    body: { isFavorite: !!favorite, favorite },
  };
};

// 👉 Remove from Favorites
export const removeFavorites = async (userId, profileId) => {
  await Favorite.findOneAndDelete({ userId, profileId });

  return { statusCode: 200, body: { message: "Profile removed from favorites" } };
};

// 👉 Remove from Favorites - Fixed: Proper parameter extraction
export const removeFavorite = async (userId, profileId) => {
  console.log("Removing favorite:", { userId, profileId });

  const result = await Favorite.findOneAndDelete({
    userId,
    profileId
  });

  if (!result) {
    return { statusCode: 404, body: { message: "Favorite not found" } };
  }

  return { statusCode: 200, body: { message: "Profile removed from favorites" } };
};
