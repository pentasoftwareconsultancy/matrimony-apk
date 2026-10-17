import jwt from "jsonwebtoken";
import UserRepository from "../repositories/UserRepository.js";

export const socketAuth = async (socket, next) => {
  try {
    const token =
      socket.handshake.auth?.token ||
      socket.handshake.headers?.authorization?.replace(
        "Bearer ",
        ""
      );

    if (!token) {
      return next(
        new Error("Authentication token required")
      );
    }

    const decoded = jwt.verify(
      token,
      process.env.JWT_SECRET ||
        "supersecretjwtkey123!@#"
    );

    const user = await UserRepository.findById(decoded.id);

    if (!user) {
      return next(
        new Error("User not found")
      );
    }

    // Attach authenticated user to socket
    socket.user = user;

    socket.userId = user._id.toString();

    console.log(
      `[Socket Auth] User authenticated: ${socket.userId}`
    );

    next();
  } catch (error) {
    console.error(
      "[Socket Auth] Authentication failed:",
      error.message
    );

    next(
      new Error("Authentication failed")
    );
  }
};