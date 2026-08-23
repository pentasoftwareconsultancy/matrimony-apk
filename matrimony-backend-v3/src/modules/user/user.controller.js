import * as userService from "./user.service.js";

export const expressInterest = async (req, res, next) => {
  try {
    const { statusCode, body } = await userService.expressInterest(
      req.user?.id,
      req.params.targetUserId
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const ignoreUser = async (req, res, next) => {
  try {
    const { statusCode, body } = await userService.ignoreUser(
      req.user?.id,
      req.params.targetUserId
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const shortlistUser = async (req, res, next) => {
  try {
    const { statusCode, body } = await userService.shortlistUser(
      req.user?.id,
      req.params.targetUserId
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const reportUser = async (req, res, next) => {
  try {
    const { reportReason, reportNote } = req.body;
    const { statusCode, body } = await userService.reportUser(
      req.user?.id,
      req.params.targetUserId,
      reportReason,
      reportNote
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const checkInterestStatus = async (req, res, next) => {
  try {
    const { statusCode, body } = await userService.checkInterestStatus(
      req.user?.id,
      req.params.targetUserId
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const checkShortlistStatus = async (req, res, next) => {
  try {
    const { statusCode, body } = await userService.checkShortlistStatus(
      req.user?.id,
      req.params.targetUserId
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const undoAction = async (req, res, next) => {
  try {
    const { actionType, targetUserId } = req.params;
    const { statusCode, body } = await userService.undoAction(
      req.user?.id,
      actionType,
      targetUserId
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getMyActions = async (req, res, next) => {
  try {
    const { statusCode, body } = await userService.getMyActions(
      req.user?.id,
      req.params.actionType
    );
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};

export const getReceivedInterests = async (req, res, next) => {
  try {
    const { statusCode, body } = await userService.getReceivedInterests(req.user?.id);
    return res.status(statusCode).json(body);
  } catch (error) {
    next(error);
  }
};
