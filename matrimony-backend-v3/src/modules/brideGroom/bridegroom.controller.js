import {
  getProfilessService,
  getProfilesService,
  getProfileByIdService,
  deleteProfileByIdService,
} from "./bridegroom.service.js";

export const getProfiless = async (req, res) => {
  try {
    const users = await getProfilessService();

    return res.status(200).json({
      success: true,
      users,
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getProfiles = async (req, res) => {
  try {
    const result = await getProfilesService(req.params.userId);

    return res.status(200).json({
      success: true,
      count: result.count,
      users: result.users,
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getProfileById = async (req, res) => {
  try {
    const profile = await getProfileByIdService(req.params.id);

    return res.status(200).json({
      success: true,
      data: profile,
    });
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

export const deleteProfileById = async (req, res) => {
  try {
    const result = await deleteProfileByIdService(req.params.id);

    return res.status(200).json(result);
  } catch (error) {
    console.error(error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};