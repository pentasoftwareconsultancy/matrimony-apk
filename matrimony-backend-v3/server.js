

import http from "http";
import dotenv from "dotenv";
import app from "./src/app.js";
import connectDB from "./src/config/db.js";
import { Server } from "socket.io";

dotenv.config();

const PORT = process.env.PORT || 8000;

const server = http.createServer(app);

const ALLOWED_ORIGINS = [
  "http://localhost:3000",
  "http://localhost:5173",
  "http://localhost:5174",
  "https://www.kunbisamaj.com",
  "https://kunbisamaj.com",
];

const io = new Server(server, {
  cors: {
    origin: (origin, callback) => {
      if (!origin) return callback(null, true);

      if (ALLOWED_ORIGINS.includes(origin)) {
        callback(null, true);
      } else {
        console.warn(`CORS blocked origin: ${origin}`);
        callback(new Error("Not allowed by CORS"));
      }
    },
    methods: ["GET", "POST"],
    credentials: true,
  },
});

io.on("connection", (socket) => {
  console.log("A user connected:", socket.id);

  socket.on("join", (userId) => {
    socket.join(userId);
    console.log(`User ${userId} joined their room`);
  });

  socket.on("sendMessage", ({ senderId, receiverId, text }) => {
    console.log("Message received:", { senderId, receiverId, text });
    io.to(receiverId).emit("receiveMessage", { senderId, text });
  });

  socket.on("checkMatch", ({ userA, userB }) => {
    console.log(`Checking match between ${userA} and ${userB}`);
    io.to(userA).emit("newMatch", { userA, userB, message: "You have a new match!" });
    io.to(userB).emit("newMatch", { userA, userB, message: "You have a new match!" });
  });

  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
  });
});

connectDB().then(() => {
  server.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
  });
});