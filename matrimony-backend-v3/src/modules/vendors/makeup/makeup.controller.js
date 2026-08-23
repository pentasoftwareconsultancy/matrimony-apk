import * as makeupService from "./makeup.service.js";

export const createMakeup = async (req, res, next) => {
  try {
    const { statusCode, body } = await makeupService.createMakeup(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getAllMakeup = async (req, res, next) => {
  try {
    const { statusCode, body } = await makeupService.getAllMakeup();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getMakeupById = async (req, res, next) => {
  try {
    const { statusCode, body } = await makeupService.getMakeupById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const updateMakeup = async (req, res, next) => {
  try {
    const { statusCode, body } = await makeupService.updateMakeup(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deleteMakeup = async (req, res, next) => {
  try {
    const { statusCode, body } = await makeupService.deleteMakeup(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
