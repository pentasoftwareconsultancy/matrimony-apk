import * as photographerService from "./photographer.service.js";

export const createPhotographer = async (req, res, next) => {
  try {
    const { statusCode, body } = await photographerService.createPhotographer(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getAllPhotographers = async (req, res, next) => {
  try {
    const { statusCode, body } = await photographerService.getAllPhotographers();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getPhotographerById = async (req, res, next) => {
  try {
    const { statusCode, body } = await photographerService.getPhotographerById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const updatePhotographer = async (req, res, next) => {
  try {
    const { statusCode, body } = await photographerService.updatePhotographer(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deletePhotographer = async (req, res, next) => {
  try {
    const { statusCode, body } = await photographerService.deletePhotographer(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
