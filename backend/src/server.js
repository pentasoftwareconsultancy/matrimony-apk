import http from "http";
import app from "./app.js";
import connectDB from "./config/db.js";
import { seedDatabase } from "./seed.js";
import { initializeSocket } from "./sockets/index.js";

const PORT = process.env.PORT || 8000;

// --------------------------------------------------
// Create HTTP server
// --------------------------------------------------

const httpServer = http.createServer(app);

// --------------------------------------------------
// Initialize Socket.IO
// --------------------------------------------------

initializeSocket(httpServer);

// --------------------------------------------------
// Start server
// --------------------------------------------------

httpServer.listen(PORT, "0.0.0.0", () => {
  console.log(
    `Server running in ${
      process.env.NODE_ENV || "development"
    } mode on port ${PORT} (http://0.0.0.0:${PORT})`
  );

  // Connect to database asynchronously
  connectDB()
    .then(async () => {
      await seedDatabase();
    })
    .catch((err) => {
      console.error(
        "Asynchronous DB connection warning:",
        err.message
      );
    });
});