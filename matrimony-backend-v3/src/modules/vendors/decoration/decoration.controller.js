import * as decorationService from "./decoration.service.js";

export const createDecoration = async (req, res, next) => {
  try {
    const response = await decorationService.createDecoration(req);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const getAllDecorations = async (req, res, next) => {
  try {
    const response = await decorationService.getAllDecorations();
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const getDecorationById = async (req, res, next) => {
  try {
    const response = await decorationService.getDecorationById(req.params.id);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const updateDecoration = async (req, res, next) => {
  try {
    const response = await decorationService.updateDecoration(req);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const deleteDecoration = async (req, res, next) => {
  try {
    const response = await decorationService.deleteDecoration(req.params.id);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};