import * as nearmeService from "./nearme.service.js";

// Fetch opposite-gender users from same village (excluding logged-in user)
export const getNearmeProfiles = async (req, res, next) => {
  try {
    console.log("Request params:", req.params);
    const { statusCode, body } = await nearmeService.getNearmeProfiles(req.params.userId);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

// Fetch single profile by ID
export const getSingleProfile = async (req, res, next) => {
  try {
    const { statusCode, body } = await nearmeService.getSingleProfile(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
