// Must run after authMiddleware (needs req.user populated from the JWT).
const requireRole = (role) => (req, res, next) => {
  if (!req.user || req.user.role !== role) {
    return res.status(403).json({
      success: false,
      message: "Access denied. Insufficient permissions.",
    });
  }
  next();
};

export default requireRole;
