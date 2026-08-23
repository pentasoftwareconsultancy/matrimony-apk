

import jwt from "jsonwebtoken";
import dotenv from "dotenv";

dotenv.config();

const authMiddleware = (req, res, next) => {
  const authHeader = req.header("Authorization");
  console.log("Authorization Header:", authHeader); // Debug
  console.log("JWT_SECRET during verification:", process.env.JWT_SECRET); // Debug

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      success: false,
      message: "Access denied. No token provided or invalid format.",
    });
  }

  const token = authHeader.replace("Bearer ", "");

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log("Decoded Token:", decoded); // Debug
    req.user = decoded;
    next();
  } catch (error) {
    console.error("JWT verification error:", error); // Debug
    if (error.name === "TokenExpiredError") {
      return res.status(401).json({
        success: false,
        message: "Token has expired.",
        error: "TokenExpiredError",
      });
    }
    res.status(401).json({
      success: false,
      message: "Invalid token.",
      error: error.name,
    });
  }
};

export default authMiddleware;