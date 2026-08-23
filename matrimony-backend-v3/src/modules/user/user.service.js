import UserAction from "./useraction.schema.js";

// Helper: find existing action
const findAction = async (fromUser, toUser, actionType) => {
  return UserAction.findOne({ fromUser, toUser, actionType });
};

// ──────────────────────────────────────────────────────────────
// Interest (toggle)
export const expressInterest = async (fromUser, toUser) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  if (fromUser.toString() === toUser) {
    return { statusCode: 400, body: { message: "You cannot perform this action on yourself." } };
  }

  let action = await findAction(fromUser, toUser, "interest");
  let active = false;

  if (action) {
    // Toggle existing
    action.active = !action.active;
    await action.save();
    active = action.active;
  } else {
    // Create new
    await UserAction.create({ fromUser, toUser, actionType: "interest", active: true });
    active = true;
  }

  return { statusCode: 200, body: { success: true, active } };
};

// ──────────────────────────────────────────────────────────────
// Ignore (one‑way, no toggle)
export const ignoreUser = async (fromUser, toUser) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  if (fromUser.toString() === toUser) {
    return { statusCode: 400, body: { message: "You cannot perform this action on yourself." } };
  }

  let action = await findAction(fromUser, toUser, "ignore");
  if (!action) {
    action = await UserAction.create({ fromUser, toUser, actionType: "ignore", active: true });
  } else if (!action.active) {
    action.active = true;
    await action.save();
  }

  return { statusCode: 200, body: { success: true, ignored: true } };
};

// ──────────────────────────────────────────────────────────────
// Shortlist (toggle)
export const shortlistUser = async (fromUser, toUser) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  if (fromUser.toString() === toUser) {
    return { statusCode: 400, body: { message: "You cannot perform this action on yourself." } };
  }

  let action = await findAction(fromUser, toUser, "shortlist");
  let active = false;

  if (action) {
    action.active = !action.active;
    await action.save();
    active = action.active;
  } else {
    await UserAction.create({ fromUser, toUser, actionType: "shortlist", active: true });
    active = true;
  }

  return { statusCode: 200, body: { success: true, active } };
};

// ──────────────────────────────────────────────────────────────
// Report (one‑way, can be updated but always active)
export const reportUser = async (fromUser, toUser, reportReason, reportNote) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  if (fromUser.toString() === toUser) {
    return { statusCode: 400, body: { message: "You cannot perform this action on yourself." } };
  }

  const validReasons = ["fake_profile", "inappropriate", "spam", "harassment", "other"];
  if (!reportReason || !validReasons.includes(reportReason)) {
    return {
      statusCode: 400,
      body: { message: "A valid reportReason is required.", validReasons },
    };
  }

  await UserAction.findOneAndUpdate(
    { fromUser, toUser, actionType: "report" },
    { active: true, reportReason, reportNote: reportNote?.trim() || null },
    { upsert: true, new: true }
  );

  return { statusCode: 200, body: { success: true, message: "Report submitted." } };
};

// ──────────────────────────────────────────────────────────────
// Check Interest Status
export const checkInterestStatus = async (fromUser, toUser) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  const action = await findAction(fromUser, toUser, "interest");
  const active = action ? action.active : false;
  return { statusCode: 200, body: { active } };
};

// ──────────────────────────────────────────────────────────────
// Check Shortlist Status
export const checkShortlistStatus = async (fromUser, toUser) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  const action = await findAction(fromUser, toUser, "shortlist");
  const active = action ? action.active : false;
  return { statusCode: 200, body: { active } };
};

// ──────────────────────────────────────────────────────────────
// Undo Action (delete)
export const undoAction = async (fromUser, actionType, targetUserId) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  const validTypes = ["interest", "ignore", "shortlist"];
  if (!validTypes.includes(actionType)) {
    return { statusCode: 400, body: { message: `Cannot undo action: ${actionType}` } };
  }

  const deleted = await UserAction.findOneAndDelete({
    fromUser,
    toUser: targetUserId,
    actionType,
  });

  if (!deleted) {
    return { statusCode: 404, body: { message: "Action not found." } };
  }

  return { statusCode: 200, body: { message: `${actionType} removed successfully.` } };
};

// ──────────────────────────────────────────────────────────────
// Get My Actions (list of actions I performed)
export const getMyActions = async (fromUser, actionType) => {
  if (!fromUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  const validTypes = ["interest", "ignore", "shortlist", "report"];
  if (!validTypes.includes(actionType)) {
    return { statusCode: 400, body: { message: `Invalid actionType: ${actionType}` } };
  }

  const actions = await UserAction.find({ fromUser, actionType, active: true })
    .populate("toUser", "name profilePicture age")
    .sort({ createdAt: -1 });

  return { statusCode: 200, body: { count: actions.length, actions } };
};

// ──────────────────────────────────────────────────────────────
// Get Received Interests (people who expressed interest in me)
export const getReceivedInterests = async (toUser) => {
  if (!toUser) {
    return { statusCode: 401, body: { message: "Authentication required" } };
  }

  const actions = await UserAction.find({ toUser, actionType: "interest", active: true })
    .populate("fromUser", "name profilePicture age")
    .sort({ createdAt: -1 });

  return { statusCode: 200, body: { count: actions.length, actions } };
};
