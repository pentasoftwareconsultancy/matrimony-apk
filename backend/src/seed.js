import mongoose from 'mongoose';
import Event from './models/Event.js';

export const seedDatabase = async () => {
  try {
    const mongoUri = process.env.MONGO_URI;
    if (!mongoUri) return;

    // Check if events exist in shared database
    const eventCount = await Event.countDocuments().catch(() => 0);
    console.log(`[DB INFO] Current event count in shared MongoDB: ${eventCount}`);
  } catch (err) {
    console.warn('[SEED WARNING]', err.message);
  }
};
