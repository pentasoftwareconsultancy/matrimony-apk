import * as sponsorService from "./sponsor.service.js";

export const createSponsor = async (req, res) => {
  try {
    const sponsor = await sponsorService.createSponsor(req);
    return res.status(201).json(sponsor);
  } catch (error) {
    return res.status(error.status || 500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getAllSponsors = async (req, res) => {
  try {
    const sponsors = await sponsorService.getAllSponsors();
    return res.status(200).json(sponsors);
  } catch (error) {
    return res.status(error.status || 500).json({
      success: false,
      message: error.message,
    });
  }
};

export const getSponsorById = async (req, res) => {
  try {
    const sponsor = await sponsorService.getSponsorById(req.params.id);
    return res.status(200).json(sponsor);
  } catch (error) {
    return res.status(error.status || 500).json({
      success: false,
      message: error.message,
    });
  }
};

export const updateSponsor = async (req, res) => {
  try {
    const sponsor = await sponsorService.updateSponsor(req);
    return res.status(200).json(sponsor);
  } catch (error) {
    return res.status(error.status || 500).json({
      success: false,
      message: error.message,
    });
  }
};

export const deleteSponsor = async (req, res) => {
  try {
    const result = await sponsorService.deleteSponsor(req.params.id);
    return res.status(200).json(result);
  } catch (error) {
    return res.status(error.status || 500).json({
      success: false,
      message: error.message,
    });
  }
};