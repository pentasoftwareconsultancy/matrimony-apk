import mongoose from 'mongoose';

const eventSchema = new mongoose.Schema(
  {
    title: { type: String, required: true },
    subtitle: { type: String, default: 'meet' },
    date: { type: String, required: true },
    time: { type: String, default: '9 PM' },
    location: { type: String, required: true },
    organizer: { type: String, default: 'Matrimony Team' },
    description: { type: String, required: true },
    status: {
      type: String,
      required: true,
      enum: ['upcoming', 'past'],
      default: 'upcoming',
    },
    badgeText: { type: String, default: 'SOON' },
    images: [{ type: String }],
    whatsappNumber: { type: String, default: '919856543232' },
    isActive: { type: Boolean, default: true },
  },
  {
    timestamps: true,
    collection: 'events',
  }
);

const Event = mongoose.model('Event', eventSchema);
export default Event;
