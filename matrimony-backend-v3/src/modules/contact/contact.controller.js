import * as contactService from "./contact.service.js";

export const submitContact = async (req, res, next) => {
  try {
    const response = await contactService.submitContact(req.body);

    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};

export const getAllContacts = async (req, res, next) => {
  try {
    const response = await contactService.getAllContacts();

    return res.status(response.statusCode).json(response);
  } catch (error) {
    next(error);
  }
};