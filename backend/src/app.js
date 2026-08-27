import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

import authRoutes from './routes/authRoutes.js';
import profileRoutes from './routes/profileRoutes.js';
import favoriteRoutes from './routes/favoriteRoutes.js';
import connectionRoutes from './routes/connectionRoutes.js';
import messageRoutes from './routes/messageRoutes.js';
import blockedRoutes from './routes/blockedRoutes.js';
import notificationRoutes from './routes/notificationRoutes.js';
import settingsRoutes from './routes/settingsRoutes.js';
import serviceRoutes from './routes/serviceRoutes.js';
import eventRoutes from './routes/eventRoutes.js';
import paymentRoutes from './routes/paymentRoutes.js';
import testimonialRoutes from './routes/testimonialRoutes.js';
import faqRoutes from './routes/faqRoutes.js';

import { errorHandler, notFound } from './middlewares/errorMiddleware.js';

// --------------------------------------------------
// Load environment variables
// --------------------------------------------------

dotenv.config();

const app = express();

const allowedOrigins = [
  'http://localhost:61602',
  'https://matrimony-apk-9895.web.app',
  'https://matrimony-apk-9895.firebaseapp.com',
];


// --------------------------------------------------
// CORS
// --------------------------------------------------

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin) {
        return callback(null, true);
      }

      if (allowedOrigins.includes(origin)) {
        return callback(null, true);
      }

      console.log(`[CORS] Blocked origin: ${origin}`);
      return callback(new Error('Not allowed by CORS'));
    },

    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],

    allowedHeaders: [
      'Content-Type',
      'Authorization',
      'X-Requested-With',
      'Accept',
      'Origin',
    ],
  })
);
// --------------------------------------------------
// Body parsers
// --------------------------------------------------

app.use(express.json({ limit: '50mb' }));

app.use(
  express.urlencoded({
    extended: true,
    limit: '50mb',
  })
);

// --------------------------------------------------
// Request logger
// --------------------------------------------------

app.use((req, res, next) => {
  console.log(
    `[${new Date().toISOString()}] ${req.method} ${req.originalUrl}`
  );

  next();
});

// --------------------------------------------------
// Health check
// --------------------------------------------------

app.get('/api/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    time: new Date(),
  });
});

// --------------------------------------------------
// API Routes
// --------------------------------------------------

app.use('/api/auth', authRoutes);

app.use('/api/profile', profileRoutes);

app.use('/api/favorites', favoriteRoutes);

app.use('/api/connections', connectionRoutes);

app.use('/api/messages', messageRoutes);

app.use('/api/blocked', blockedRoutes);

app.use('/api/notifications', notificationRoutes);

app.use('/api/settings', settingsRoutes);

app.use('/api/services', serviceRoutes);

app.use('/api/events', eventRoutes);

app.use('/api/payments', paymentRoutes);

app.use('/api/testimonials', testimonialRoutes);

app.use('/api/faqs', faqRoutes);

// --------------------------------------------------
// 404 handler
// --------------------------------------------------

app.use(notFound);

// --------------------------------------------------
// Global error handler
// --------------------------------------------------

app.use(errorHandler);

export default app;