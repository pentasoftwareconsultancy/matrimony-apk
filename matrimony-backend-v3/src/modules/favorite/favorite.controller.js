import * as favoriteService from "./favorite.service.js";

export const addFavorite = async (req, res, next) => {
  try {
    const { userId, profileId } = req.body;
    const { statusCode, body } = await favoriteService.addFavorite(userId, profileId);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getFavorites = async (req, res, next) => {
  try {
    const { userId } = req.params;
    const { statusCode, body } = await favoriteService.getFavorites(userId);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const checkFavorite = async (req, res, next) => {
  try {
    const { userId, profileId } = req.params;
    const { statusCode, body } = await favoriteService.checkFavorite(userId, profileId);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const removeFavorites = async (req, res, next) => {
  try {
    const { userId, profileId } = req.body;
    const { statusCode, body } = await favoriteService.removeFavorites(userId, profileId);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const removeFavorite = async (req, res, next) => {
  try {
    const { userId, profileId } = req.params;
    const { statusCode, body } = await favoriteService.removeFavorite(userId, profileId);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
