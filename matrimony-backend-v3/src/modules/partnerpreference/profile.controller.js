import * as profileService from "./profile.service.js";

export const getMatches = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.getMatches(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getNearMeProfiles = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.getNearMeProfiles(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getNewProfiles = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.getNewProfiles(req.user.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const filterUsers = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.filterUsers(req.user.id, req.query);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getFilterOptions = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.getFilterOptions();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getUserById = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.getUserById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const adminFilterUsers = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.adminFilterUsers(req.query);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const adminFilterOptions = async (req, res, next) => {
  try {
    const { statusCode, body } = await profileService.adminFilterOptions();
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
