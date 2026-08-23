import * as djMusicService from "./djMusic.service.js";

export const createDJMusic = async (req, res, next) => {
  try {
    const response = await djMusicService.createDJMusic(req);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const getAllDJMusic = async (req, res, next) => {
  try {
    const response = await djMusicService.getAllDJMusic();
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const getDJMusicById = async (req, res, next) => {
  try {
    const response = await djMusicService.getDJMusicById(req.params.id);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const updateDJMusic = async (req, res, next) => {
  try {
    const response = await djMusicService.updateDJMusic(req);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const deleteDJMusic = async (req, res, next) => {
  try {
    const response = await djMusicService.deleteDJMusic(req.params.id);
    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};