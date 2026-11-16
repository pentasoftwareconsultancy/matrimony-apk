import Event from '../models/Event.js';
import {
  getEventDateWindow,
  isUpcomingEvent,
  toDayUtcMs,
} from '../utils/eventDateFilter.js';

// GET upcoming events only from shared database
export const getEvents = async (req, res, next) => {
  try {
    const events = await Event.find({
      isDeleted: { $ne: true },
      deleted: { $ne: true },
      isCancelled: { $ne: true },
      isCanceled: { $ne: true },
      cancelled: { $ne: true },
      canceled: { $ne: true },
      isActive: { $ne: false },
      active: { $ne: false },
    }).lean();

    const now = new Date();
    const upcomingEvents = events
      .filter((event) => isUpcomingEvent(event, now))
      .sort((a, b) => {
        const winA = getEventDateWindow(a);
        const winB = getEventDateWindow(b);
        const dayA = winA.startDay || winA.endDay;
        const dayB = winB.startDay || winB.endDay;
        const diff = toDayUtcMs(dayA) - toDayUtcMs(dayB);
        if (diff !== 0) return diff;
        return new Date(b.createdAt || 0).getTime() - new Date(a.createdAt || 0).getTime();
      });

    res.status(200).json({
      success: true,
      count: upcomingEvents.length,
      data: upcomingEvents,
    });
  } catch (error) {
    next(error);
  }
};

// GET event by ID
export const getEventById = async (req, res, next) => {
  try {
    const event = await Event.findById(req.params.id);
    if (!event) {
      return res.status(404).json({ success: false, message: 'Event not found' });
    }
    res.status(200).json({ success: true, data: event });
  } catch (error) {
    next(error);
  }
};

// ADMIN / System methods
export const createEvent = async (req, res, next) => {
  try {
    const event = await Event.create(req.body);
    res.status(201).json({ success: true, data: event });
  } catch (error) {
    next(error);
  }
};

export const updateEvent = async (req, res, next) => {
  try {
    const event = await Event.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!event) {
      return res.status(404).json({ success: false, message: 'Event not found' });
    }
    res.status(200).json({ success: true, data: event });
  } catch (error) {
    next(error);
  }
};

export const deleteEvent = async (req, res, next) => {
  try {
    const event = await Event.findByIdAndDelete(req.params.id);
    if (!event) {
      return res.status(404).json({ success: false, message: 'Event not found' });
    }
    res.status(200).json({ success: true, message: 'Event deleted successfully' });
  } catch (error) {
    next(error);
  }
};
