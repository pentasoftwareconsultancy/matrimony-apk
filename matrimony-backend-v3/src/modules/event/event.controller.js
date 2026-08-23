import * as eventService from "./event.service.js";

export const createEvent = async (req, res, next) => {
  try {
    const response = await eventService.createEvent(req);

    return res.status(response.statusCode).json(response.data);
  } catch (error) {
    next(error);
  }
};

export const getAllEvents = async (req, res, next) => {
  try {
    const response = await eventService.getAllEvents();

    return res.status(response.statusCode).json(response.data);
  } catch (error) {
    next(error);
  }
};

export const getEventById = async (req, res, next) => {
  try {
    const response = await eventService.getEventById(req.params.id);

    return res.status(response.statusCode).json(response.data);
  } catch (error) {
    next(error);
  }
};

export const updateEvent = async (req, res, next) => {
  try {
    const response = await eventService.updateEvent(req);

    return res.status(response.statusCode).json(response.data);
  } catch (error) {
    next(error);
  }
};

export const deleteEvent = async (req, res, next) => {
  try {
    const response = await eventService.deleteEvent(req.params.id);

    return res.status(response.statusCode).json(response.data);
  } catch (error) {
    next(error);
  }
};