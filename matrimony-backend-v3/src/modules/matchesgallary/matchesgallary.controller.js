import * as matchesGalleryService from "./matchesgallary.service.js";

export const createMatchesGallery = async (req, res, next) => {
  try {
    const { statusCode, body } = await matchesGalleryService.createMatchesGallery(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getAllMatchesGallery = async (req, res, next) => {
  try {
    const { statusCode, body } = await matchesGalleryService.getAllMatchesGallery();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getMatchesGalleryById = async (req, res, next) => {
  try {
    const { statusCode, body } = await matchesGalleryService.getMatchesGalleryById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const updateMatchesGallery = async (req, res, next) => {
  try {
    const { statusCode, body } = await matchesGalleryService.updateMatchesGallery(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deleteMatchesGallery = async (req, res, next) => {
  try {
    const { statusCode, body } = await matchesGalleryService.deleteMatchesGallery(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deleteGalleryImage = async (req, res, next) => {
  try {
    const { statusCode, body } = await matchesGalleryService.deleteGalleryImage(
      req.params.id,
      req.params.imageIndex
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
