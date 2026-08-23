// src/controllers/AdminDashboardController.js
import {
  AppError,
  getTotalUsersCount,
  getGroomsStats,
  getBrideStats,
  getRecentRegistrations,
  getUserGrowthStats,
  getPendingUsers,
  getApprovedUsers,
  getDeniedUsers,
  approveUserAndNotify,
  denyUserAndNotify,
  importUsersFromExcel,
  filterUsers,
  getFilterOptions,
  getProfileById as getProfileByIdService,
  deleteProfileById as deleteProfileByIdService,
  getAdminInfo as getAdminInfoService,
  getAllAdmins,
} from "./adminprofile.service.js";

export const totalUsers = async (req, res, next) => {
  try {
    const totalUsers = await getTotalUsersCount();
    res.status(200).json({ success: true, totalUsers });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const groomsDetails = async (req, res, next) => {
  try {
    const stats = await getGroomsStats();
    res.status(201).json({ success: true, ...stats });
  } catch (error) {
    res.status(404).json({ success: false, message: error.message });
  }
};

export const brideDetails = async (req, res, next) => {
  try {
    const stats = await getBrideStats();
    res.status(201).json({ success: true, ...stats });
  } catch (error) {
    res.status(404).json({ success: false, message: error.message });
  }
};

export const newRegistrations = async (req, res, next) => {
  try {
    const newRegistrations = await getRecentRegistrations(50);
    res.status(200).json({
      success: true,
      count: newRegistrations.length,
      newRegistrations,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const userGrowth = async (req, res) => {
  try {
    const stats = await getUserGrowthStats();
    res.json({ success: true, ...stats });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getPendingUser = async (req, res, next) => {
  try {
    const allPendingUsers = await getPendingUsers();
    res.status(200).json({
      success: true,
      count: allPendingUsers.length,
      allPendingUsers,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getApproveUser = async (req, res, next) => {
  try {
    const allApproveUsers = await getApprovedUsers();
    res.status(200).json({
      success: true,
      count: allApproveUsers.length,
      allApproveUsers,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const approveUser = async (req, res, next) => {
  try {
    const result = await approveUserAndNotify(req.params.id, req.user?.id);

    res.status(200).json({
      success: true,
      message: "User approved and notification email sent successfully",
      ...result,
    });
  } catch (error) {
    console.error("Error approving user:", error);
    if (error instanceof AppError) {
      return res
        .status(error.status)
        .json({ success: false, message: error.message, ...error.extra });
    }
    res.status(500).json({ success: false, message: error.message });
  }
};

export const denyUser = async (req, res, next) => {
  try {
    const { denyUser, frontendUpdateLink } = await denyUserAndNotify(req.params.id);

    res.status(200).json({
      success: true,
      message: "User denied and email sent successfully with frontend update link",
      denyUser,
      frontendUpdateLink,
    });
  } catch (error) {
    console.error("Error denying user:", error);
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getDenyUser = async (req, res, next) => {
  try {
    const allDenyUsers = await getDeniedUsers();
    res.status(200).json({
      success: true,
      message: "all Denied Users",
      count: allDenyUsers.length,
      allDenyUsers,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const ExcelregisterUsers = async (req, res) => {
  try {
    const { insertedCount, errors } = await importUsersFromExcel(req.file);

    res.json({
      success: errors.length === 0,
      message: `${insertedCount} users inserted, ${errors.length} failed`,
      errors,
    });
  } catch (err) {
    console.error(err);
    if (err instanceof AppError) {
      return res
        .status(err.status)
        .json({ success: false, message: err.message, ...err.extra });
    }
    res.status(500).json({ success: false, message: err.message });
  }
};

// ================== ADMIN FILTER USERS ==================
export const adminFilterUsers = async (req, res) => {
  try {
    const users = await filterUsers(req.query);
    res.status(200).json({ success: true, count: users.length, data: users });
  } catch (error) {
    console.error("Error in admin filter:", error);
    res.status(500).json({ success: false, message: "Error filtering users (Admin)" });
  }
};

export const adminFilterOptions = async (req, res) => {
  try {
    const data = await getFilterOptions();
    res.status(200).json({ success: true, data });
  } catch (error) {
    console.error("Error getting admin filter options:", error);
    res
      .status(500)
      .json({ success: false, message: "Error getting admin filter options" });
  }
};

export const getProfileById = async (req, res) => {
  try {
    const { id } = req.params;
    const profile = await getProfileByIdService(id);
    return res.status(200).json({ success: true, data: profile });
  } catch (error) {
    console.error("Error fetching profile:", error);
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    return res.status(500).json({
      success: false,
      message: "Server error while fetching profile",
      error: error.message,
    });
  }
};

export const deleteProfileById = async (req, res) => {
  try {
    const { id } = req.params;
    await deleteProfileByIdService(id);
    return res.status(200).json({
      success: true,
      message: "Profile and all images deleted successfully",
    });
  } catch (error) {
    console.error("Error deleting profile:", error);
    if (error instanceof AppError) {
      return res.status(error.status).json({ success: false, message: error.message });
    }
    return res.status(500).json({
      success: false,
      message: "Server error while deleting profile",
      error: error.message,
    });
  }
};

export const getAdminInfo = async (req, res) => {
  try {
    const { id } = req.params;
    const admin = await getAdminInfoService(id);
    res.status(200).json({
      success: true,
      message: "Admin info Fetched",
      admin,
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getadmin = async (req, res) => {
  try {
    const admin = await getAllAdmins();
    res.status(200).json({ success: true, admin });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};