import * as jewelleryService from "./jewellery.service.js";

export const createJewellery = async (req, res, next) => {
  try {
    const { statusCode, body } = await jewelleryService.createJewellery(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getAllJewellery = async (req, res, next) => {
  try {
    const { statusCode, body } = await jewelleryService.getAllJewellery();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getJewelleryById = async (req, res, next) => {
  try {
    const { statusCode, body } = await jewelleryService.getJewelleryById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const updateJewellery = async (req, res, next) => {
  try {
    const { statusCode, body } = await jewelleryService.updateJewellery(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deleteJewellery = async (req, res, next) => {
  try {
    const { statusCode, body } = await jewelleryService.deleteJewellery(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
