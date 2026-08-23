import * as personService from "./person.service.js";

export const createPerson = async (req, res, next) => {
  try {
    const { statusCode, body } = await personService.createPerson(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getAllPersons = async (req, res, next) => {
  try {
    const { statusCode, body } = await personService.getAllPersons(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getPersonsByPlace = async (req, res, next) => {
  try {
    const { statusCode, body } = await personService.getPersonsByPlace(req.params.place);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getPersonById = async (req, res, next) => {
  try {
    const { statusCode, body } = await personService.getPersonById(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const updatePerson = async (req, res, next) => {
  try {
    const { statusCode, body } = await personService.updatePerson(req);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const deletePerson = async (req, res, next) => {
  try {
    const { statusCode, body } = await personService.deletePerson(req.params.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
