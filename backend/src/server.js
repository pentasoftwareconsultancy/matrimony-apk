import app from './app.js';
import connectDB from './config/db.js';
import { seedDatabase } from './seed.js';

const PORT = process.env.PORT || 8000;

// Start server immediately on specified port (0.0.0.0)
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server running in ${process.env.NODE_ENV || 'development'} mode on port ${PORT} (http://0.0.0.0:${PORT})`);

  // Connect to database asynchronously
  connectDB().then(async () => {
    await seedDatabase();
  }).catch((err) => {
    console.error('Asynchronous DB connection warning:', err.message);
  });
});
