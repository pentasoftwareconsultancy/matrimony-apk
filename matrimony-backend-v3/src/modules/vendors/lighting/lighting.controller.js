import * as lightingService from "./lighting.service.js";

export const createLighting = async (req, res, next) => {
  try {
    const { statusCode, body } = await lightingService.createLighting(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getAllLightings = async (req, res, next) => {
  try {
    const { statusCode, body } = await lightingService.getAllLightings();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getLightingById = async (req, res, next) => {
  try {
    const { statusCode, body } = await lightingService.getLightingById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const updateLighting = async (req, res, next) => {
  try {
    const { statusCode, body } = await lightingService.updateLighting(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deleteLighting = async (req, res, next) => {
  try {
    const { statusCode, body } = await lightingService.deleteLighting(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
