import * as mehndiService from "./mehndi.service.js";

export const createMehendi = async (req, res, next) => {
  try {
    const { statusCode, body } = await mehndiService.createMehendi(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getAllMehendi = async (req, res, next) => {
  try {
    const { statusCode, body } = await mehndiService.getAllMehendi();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getMehendiById = async (req, res, next) => {
  try {
    const { statusCode, body } = await mehndiService.getMehendiById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const updateMehendi = async (req, res, next) => {
  try {
    const { statusCode, body } = await mehndiService.updateMehendi(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deleteMehendi = async (req, res, next) => {
  try {
    const { statusCode, body } = await mehndiService.deleteMehendi(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
