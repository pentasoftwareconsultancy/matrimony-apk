import mongoose from 'mongoose';

const profileSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    unique: true,
  },
  accountType: {
    type: String,
    enum: ['Bride', 'Groom', 'Parent', 'Guardian', 'Sibling', 'Friend', 'Relative'],
  },
  fullName: {
    type: String,
    trim: true,
  },
  gender: {
    type: String,
    enum: ['Male', 'Female', 'Other'],
  },
  age: {
    type: Number,
  },
  dob: {
    type: Date,
  },
  religion: {
    type: String,
  },
  caste: {
    type: String,
  },
  maritalStatus: {
    type: String,
  },
  bloodGroup: {
    type: String,
  },
  address: {
    type: String,
  },
  hobbies: {
    type: [String],
    default: [],
  },
  rashi: {
    type: String,
  },
  nakshatra: {
    type: String,
  },
  manglik: {
    type: Boolean,
    default: false,
  },
  qualification: {
    type: String,
  },
  occupation: {
    type: String,
  },
  annualIncome: {
    type: String,
  },
  country: {
    type: String,
  },
  state: {
    type: String,
  },
  city: {
    type: String,
  },
  languages: {
    type: [String],
    default: [],
  },
  fatherName: {
    type: String,
  },
  motherName: {
    type: String,
  },
  siblings: {
    type: Number,
    default: 0,
  },
  familyType: {
    type: String,
  },
  familyStatus: {
    type: String,
  },
  nativePlace: {
    type: String,
  },
  aboutFamily: {
    type: String,
  },
  aadharNumber: {
    type: String,
    trim: true,
  },
  aadharCardUrl: {
    type: String,
  },
  photos: {
    type: [String],
    default: [],
  },
  partnerPreference: {
    type: mongoose.Schema.Types.Mixed,
    default: {},
  }
}, {
  timestamps: true,
  collection: 'profiles'
});

const Profile = mongoose.model('Profile', profileSchema);
export default Profile;
