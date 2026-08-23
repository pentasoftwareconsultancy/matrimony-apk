import express from 'express';
import cors from 'cors';
import routes from './routes.js'; // ✅ Fixed import

const app = express(); 

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api', routes); // Routes mounted

app.get('/', (req, res) => {
  res.status(200).json({ message: 'Server is running 🚀' });
});

// 404 handler for unmatched routes
app.use((req, res) => {
  res.status(404).json({ success: false, message: 'Route not found' });
});

// Global error handler — every controller's next(error) lands here.
// eslint-disable-next-line no-unused-vars
app.use((err, req, res, next) => {
  console.error(err);
  const statusCode = err.status || err.statusCode || 500;
  res.status(statusCode).json({
    success: false,
    message: err.message || 'Internal server error',
    ...(err.extra || {}),
  });
});

export default app;
