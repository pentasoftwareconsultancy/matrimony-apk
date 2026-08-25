import jwt from 'jsonwebtoken';
import bcrypt from 'bcryptjs';
import Matrimony from '../models/Matrimony.js';
import Membership from '../models/Membership.js';
import { sendOTPEmail } from '../utils/mailer.js';

const otpStore = new Map();

function parseIncomeLPA(incomeStr) {
  if (!incomeStr) return 15.0;
  const str = incomeStr.toString();
  const digits = str.replace(/[^\d]/g, '');
  if (!digits) return 15.0;
  const val = parseFloat(digits);
  if (val > 1000) {
    return val / 100000.0;
  }
  return val > 0 ? val : 15.0;
}

class AuthService {
  generateToken(userId, email) {
    return jwt.sign(
      { id: userId, email, role: 'user' },
      process.env.JWT_SECRET || 'supersecretjwtkey123!@#',
      { expiresIn: '30d' }
    );
  }

  generate4DigitOTP() {
    return Math.floor(1000 + Math.random() * 9000).toString();
  }

  async getMergedUser(matrimonyDoc) {
    if (!matrimonyDoc) return null;

    const doc = matrimonyDoc.toObject ? matrimonyDoc.toObject() : matrimonyDoc;
    const userIdStr = doc._id ? doc._id.toString() : '';

    const reg = doc.userRegistration || {};
    const personal = doc.personalDetail || {};
    const edu = doc.educationalDetail || {};
    const family = doc.familyDetails || {};
    const astro = doc.astrologyDetails || {};
    const partner = doc.partnerDetail || {};
    const docs = doc.documentDetails || {};

    // Collect all photo URLs
    const photosList = [];
    if (docs.photoFulls) photosList.push(docs.photoFulls);
    if (docs.photoCloseup) photosList.push(docs.photoCloseup);
    if (docs.photoFull) photosList.push(docs.photoFull);
    if (docs.familyPhoto) photosList.push(docs.familyPhoto);
    if (Array.isArray(docs.photos)) {
      docs.photos.forEach(p => { if (p && !photosList.includes(p)) photosList.push(p); });
    }
    if (photosList.length === 0) {
      photosList.push('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500');
    }

    // Check active membership
    let isPremium = false;
    try {
      const activeMem = await Membership.findOne({
        userId: doc._id,
        status: 'paid',
        expiryDate: { $gte: new Date() }
      });
      if (activeMem) isPremium = true;
    } catch (_) {}

    // Map gender representation cleanly
    let mappedGender = personal.gender;
    if (mappedGender === 'Bride') mappedGender = 'Female';
    if (mappedGender === 'Groom') mappedGender = 'Male';
    if (!mappedGender) mappedGender = 'Female';

    // Calculate age if missing in personalDetail
    let age = personal.age;
    if (!age && reg.dateOfBirth) {
      const bDate = new Date(reg.dateOfBirth);
      if (!isNaN(bDate.getTime())) {
        const today = new Date();
        age = today.getFullYear() - bDate.getFullYear();
        const m = today.getMonth() - bDate.getMonth();
        if (m < 0 || (m === 0 && today.getDate() < bDate.getDate())) {
          age--;
        }
      }
    }
    if (!age || age <= 0) age = 25;

    const incomeLPA = parseIncomeLPA(edu.annualIncome);

    const merged = {
      _id: userIdStr,
      id: userIdStr,
      email: reg.email || '',
      phone: reg.phoneNumber ? reg.phoneNumber.toString() : '',
      accountType: reg.profileCreatedFor || 'Yourself',
      fullName: reg.fullName || 'Matrimony Member',
      name: reg.fullName || 'Matrimony Member',
      gender: mappedGender,
      age,
      dob: reg.dateOfBirth || null,
      birthDate: reg.dateOfBirth ? new Date(reg.dateOfBirth).toLocaleDateString() : '',
      religion: astro.religion || 'Hindu',
      caste: astro.caste || 'Kunbi',
      maritalStatus: personal.maritalStatus || 'Single',
      bloodGroup: personal.bloodGroup || 'B+',
      address: reg.address || '',
      hobbies: Array.isArray(personal.hobbies) ? personal.hobbies : (personal.hobbies ? [personal.hobbies] : []),
      rashi: astro.rashi || 'Mesh',
      nakshatra: astro.nakshatra || 'Ashwini',
      manglik: astro.isManglik ?? false,
      qualification: edu.highestEducation || 'Graduate',
      education: edu.highestEducation || 'Graduate',
      occupation: edu.profession || 'Professional',
      profession: edu.profession || 'Professional',
      annualIncome: edu.annualIncome ? edu.annualIncome.toString() : '₹10 Lakhs - ₹15 Lakhs',
      income: edu.annualIncome ? edu.annualIncome.toString() : '₹10 Lakhs - ₹15 Lakhs',
      incomeValue: incomeLPA,
      country: reg.country || 'India',
      state: reg.state || 'Maharashtra',
      city: reg.district || reg.village || reg.city || 'Pune',
      district: reg.district || 'Pune',
      village: reg.village || '',
      workLocation: edu.companyAddress || reg.district || 'Pune',
      homePlace: reg.address || reg.district || 'Pune',
      nativePlace: family.nativePlace || reg.district || 'Pune',
      languages: [astro.motherTongue || 'Marathi'],
      fatherName: family.fatherName || '',
      motherName: family.motherName || '',
      siblings: (family.brothers || 0) + (family.sisters || 0),
      familyType: family.familyType || 'Nuclear',
      familyStatus: family.familyValues || 'Middle Class',
      about: personal.descriptionAboutSelf || 'Family-oriented person with modern values.',
      aboutMe: personal.descriptionAboutSelf || 'Family-oriented person with modern values.',
      height: personal.height ? `${personal.height} cm` : "5'6\"",
      weight: personal.weight ? `${personal.weight} kg` : "60 kg",
      diet: personal.diet || 'Vegetarian',
      smoking: personal.smoking || 'No',
      drinking: personal.drinking || 'No',
      aadharNumber: docs.aadharCardNumber || '',
      aadharCardUrl: docs.aadhaarFrontphoto || '',
      casteCertificateUrl: docs.castecertificate || '',
      casteCertificateName: docs.castecertificate ? 'caste_certificate.pdf' : '',
      photos: photosList,
      profileCompleted: true,
      isVerified: true,
      isPremium,
      role: 'user',
      compatibilityScore: 92,
      compatibilityTags: ['Same religion', 'Nearby city', 'Same caste'],
      userRegistration: {
        ...reg,
        password: undefined,
        confirmPassword: undefined,
      },
      personalDetail: personal,
      educationalDetail: edu,
      familyDetails: family,
      astrologyDetails: astro,
      partnerDetail: partner,
      documentDetails: docs,
      approvalStatus: doc.approvalStatus || 'Approved',
    };

    return merged;
  }

  async checkUser(checkData) {
    const { email, phone, identifier } = checkData;
    let matrimony = null;

    if (email) {
      const cleanEmail = email.trim().toLowerCase();
      matrimony = await Matrimony.findOne({ "userRegistration.email": cleanEmail });
    } else if (phone) {
      const cleanPhone = Number(phone.toString().replace(/\D/g, ''));
      matrimony = await Matrimony.findOne({ "userRegistration.phoneNumber": cleanPhone });
    } else if (identifier) {
      const normalized = identifier.trim().toLowerCase();
      if (normalized.includes('@')) {
        matrimony = await Matrimony.findOne({ "userRegistration.email": normalized });
      } else {
        const cleanPhone = Number(normalized.replace(/\D/g, ''));
        matrimony = await Matrimony.findOne({ "userRegistration.phoneNumber": cleanPhone });
      }
    }

    return { exists: !!matrimony };
  }

  async sendOTP(otpData) {
    const { email, phone, phoneNumber } = otpData;
    const targetPhone = phone || phoneNumber;
    let matrimony = null;

    if (email) {
      matrimony = await Matrimony.findOne({ "userRegistration.email": email.trim().toLowerCase() });
    } else if (targetPhone) {
      const num = Number(targetPhone.toString().replace(/\D/g, ''));
      matrimony = await Matrimony.findOne({ "userRegistration.phoneNumber": num });
    }

    const otpCode = this.generate4DigitOTP();
    const targetKey = email ? email.trim().toLowerCase() : targetPhone.toString();
    otpStore.set(targetKey, { code: otpCode, expiresAt: Date.now() + 10 * 60 * 1000 });

    if (email) {
      try {
        await sendOTPEmail(email, otpCode);
      } catch (err) {
        console.error("Email OTP send error:", err.message);
      }
    }

    console.log(`[OTP GENERATED] Target: ${targetKey} | Code: ${otpCode}`);
    return { success: true, message: 'OTP sent successfully' };
  }

  async loginUser(loginData) {
    const { email, password } = loginData;

    if (!email || !email.trim()) {
      const error = new Error('Email is required');
      error.statusCode = 400;
      throw error;
    }

    if (!password) {
      const error = new Error('Password is required');
      error.statusCode = 400;
      throw error;
    }

    const cleanEmail = email.trim().toLowerCase();
    const user = await Matrimony.findOne({ "userRegistration.email": cleanEmail });

    if (!user) {
      const error = new Error('Email not registered');
      error.statusCode = 401;
      throw error;
    }

    const storedPassword = user.userRegistration?.password;
    if (!storedPassword) {
      const error = new Error('Incorrect password');
      error.statusCode = 401;
      throw error;
    }

    let isMatch = false;
    if (storedPassword.startsWith('$2')) {
      isMatch = await bcrypt.compare(password, storedPassword);
    } else {
      isMatch = password === storedPassword;
    }

    if (!isMatch) {
      const error = new Error('Incorrect password');
      error.statusCode = 401;
      throw error;
    }

    const token = user.jwtToken ? user.jwtToken() : this.generateToken(user._id, cleanEmail);
    const mergedUser = await this.getMergedUser(user);

    return {
      token,
      profileCompleted: true,
      user: mergedUser,
    };
  }

  async verifyOTP(verifyData) {
    const { email, phoneNumber, phone: reqPhone, code } = verifyData;
    const targetPhone = phoneNumber || reqPhone;
    const targetKey = email ? email.trim().toLowerCase() : (targetPhone ? targetPhone.toString() : '');

    const record = otpStore.get(targetKey);
    if (!record || record.code !== code) {
      const error = new Error('Invalid OTP code');
      error.statusCode = 401;
      throw error;
    }

    if (Date.now() > record.expiresAt) {
      otpStore.delete(targetKey);
      const error = new Error('OTP has expired');
      error.statusCode = 401;
      throw error;
    }

    otpStore.delete(targetKey);

    let user;
    if (email) {
      user = await Matrimony.findOne({ "userRegistration.email": email.trim().toLowerCase() });
    } else if (targetPhone) {
      const num = Number(targetPhone.toString().replace(/\D/g, ''));
      user = await Matrimony.findOne({ "userRegistration.phoneNumber": num });
    }

    if (!user) {
      const error = new Error('User not registered');
      error.statusCode = 404;
      throw error;
    }

    const token = user.jwtToken ? user.jwtToken() : this.generateToken(user._id, user.userRegistration.email);
    const mergedUser = await this.getMergedUser(user);

    return {
      token,
      profileCompleted: true,
      user: mergedUser,
    };
  }

async completeRegistration(userId, registrationData) {
  const data = registrationData || {};

  // ============================================================
  // HELPER FUNCTIONS
  // ============================================================

  const optionalString = (value) => {
    if (
      value === undefined ||
      value === null ||
      value === ''
    ) {
      return 'Not Specified';
    }

    return value.toString().trim();
  };

  const optionalNumber = (value) => {
    if (
      value === undefined ||
      value === null ||
      value === ''
    ) {
      return null;
    }

    const number = Number(value);

    return Number.isNaN(number) ? null : number;
  };

  const optionalArray = (value) => {
    if (
      value === undefined ||
      value === null ||
      value === ''
    ) {
      return [];
    }

    if (Array.isArray(value)) {
      return value;
    }

    return [value];
  };

  const optionalDocument = (value) => {
    if (
      value === undefined ||
      value === null ||
      value === ''
    ) {
      return '';
    }

    return value.toString().trim();
  };

  // ============================================================
  // NORMALIZE BASIC VALUES
  // ============================================================

  const cleanEmail = data.email
    ? data.email.toString().trim().toLowerCase()
    : null;

  const rawPhone =
    data.phone ||
    data.phoneNumber;

  const cleanPhone = rawPhone
    ? Number(
        rawPhone
          .toString()
          .replace(/\D/g, '')
      )
    : null;

  const cleanAadhar = data.aadharNumber
    ? data.aadharNumber.toString().trim()
    : null;

  const dobValue =
    data.dob ||
    data.dateOfBirth;

  // ============================================================
  // DUPLICATE PHONE CHECK
  // ============================================================

  if (cleanPhone) {
    const existingPhone =
      await Matrimony.findOne({
        "userRegistration.phoneNumber":
          cleanPhone,
      });

    if (
      existingPhone &&
      (
        !userId ||
        existingPhone._id.toString() !==
          userId.toString()
      )
    ) {
      const error = new Error(
        'Mobile number already registered'
      );

      error.statusCode = 409;

      throw error;
    }
  }

  // ============================================================
  // DUPLICATE EMAIL CHECK
  // ============================================================

  if (cleanEmail) {
    const existingEmail =
      await Matrimony.findOne({
        "userRegistration.email":
          cleanEmail,
      });

    if (
      existingEmail &&
      (
        !userId ||
        existingEmail._id.toString() !==
          userId.toString()
      )
    ) {
      const error = new Error(
        'Email already registered'
      );

      error.statusCode = 409;

      throw error;
    }
  }

  // ============================================================
  // DUPLICATE AADHAAR CHECK
  // ============================================================

  if (cleanAadhar) {
    const existingAadhar =
      await Matrimony.findOne({
        "documentDetails.aadharCardNumber":
          cleanAadhar,
      });

    if (
      existingAadhar &&
      (
        !userId ||
        existingAadhar._id.toString() !==
          userId.toString()
      )
    ) {
      const error = new Error(
        'Aadhaar number already registered'
      );

      error.statusCode = 409;

      throw error;
    }
  }

  // ============================================================
  // FIND EXISTING USER
  // ============================================================

  let matrimonyUser = null;

  if (userId) {
    matrimonyUser =
      await Matrimony.findById(userId);
  }

  if (
    !matrimonyUser &&
    cleanEmail
  ) {
    matrimonyUser =
      await Matrimony.findOne({
        "userRegistration.email":
          cleanEmail,
      });
  }

  // ============================================================
  // CALCULATE AGE
  // ============================================================

  let calculatedAge =
    optionalNumber(data.age);

  if (dobValue) {
    const birthDate =
      new Date(dobValue);

    if (!isNaN(birthDate.getTime())) {
      const today =
        new Date();

      calculatedAge =
        today.getFullYear() -
        birthDate.getFullYear();

      const monthDifference =
        today.getMonth() -
        birthDate.getMonth();

      if (
        monthDifference < 0 ||
        (
          monthDifference === 0 &&
          today.getDate() <
            birthDate.getDate()
        )
      ) {
        calculatedAge--;
      }
    }
  }

  // ============================================================
  // NORMALIZE GENDER
  // ============================================================

  let formattedGender =
    data.gender;

  if (
    formattedGender === 'Female'
  ) {
    formattedGender =
      'Bride';
  }

  if (
    formattedGender === 'Male'
  ) {
    formattedGender =
      'Groom';
  }

  // ============================================================
  // USER REGISTRATION
  // ============================================================

  const registration = {
    fullName:
      data.fullName,

    dateOfBirth:
      dobValue
        ? new Date(dobValue)
        : null,

    phoneNumber:
      cleanPhone,

    email:
      cleanEmail,

    password:
      data.password,

    confirmPassword:
      optionalString(
        data.confirmPassword
      ),

    profileCreatedFor:
      optionalString(
        data.accountType
      ),

    alternativePhoneNumber:
      optionalString(
        data.alternativePhoneNumber
      ),

    pincode:
      optionalString(
        data.pincode
      ),

    address:
      optionalString(
        data.address
      ),

    village:
      optionalString(
        data.village
      ),

    taluka:
      optionalString(
        data.taluka
      ),

    district:
      optionalString(
        data.district
      ),

    state:
      optionalString(
        data.state
      ),

    country:
      optionalString(
        data.country
      ),
  };

  // ============================================================
  // PERSONAL DETAILS
  // ============================================================

  const personalDetails = {
    gender:
      formattedGender,

    maritalStatus:
      data.maritalStatus,

    numberOfChildren:
      optionalNumber(
        data.numberOfChildren
      ) ?? 0,

    age:
      calculatedAge,

    height:
      optionalNumber(
        data.height
      ),

    weight:
      optionalNumber(
        data.weight
      ),

    complexionType:
      optionalString(
        data.complexionType
      ),

    bloodGroup:
      data.bloodGroup,

    specialCase:
      optionalString(
        data.specialCase
      ),

    bodyType:
      optionalString(
        data.bodyType
      ),

    diet:
      data.diet,

    smoking:
      data.smoking,

    drinking:
      data.drinking,

    hobbies:
      optionalArray(
        data.hobbies
      ),

    agriculturalLandAcres:
      optionalString(
        data.agriculturalLandAcres
      ),

    descriptionAboutSelf:
      optionalString(
        data.about ||
        data.aboutMe
      ),
  };

  // ============================================================
  // EDUCATIONAL DETAILS
  // ============================================================

  const educationalDetails = {
    highestEducation:
      data.highestEducation,

    educationField:
      data.educationField,

    universityCollege:
      optionalString(
        data.universityCollege
      ),

    profession:
      data.profession,

    occupationPosition:
      data.occupationPosition,

    organizationName:
      optionalString(
        data.organizationName
      ),

    companyAddress:
      optionalString(
        data.companyAddress
      ),

    annualIncome:
      data.annualIncome,
  };

  // ============================================================
  // FAMILY DETAILS
  // ============================================================

  const familyDetails = {
    fatherName:
      data.fatherName,

    fatherOccupation:
      optionalString(
        data.fatherOccupation
      ),

    motherName:
      data.motherName,

    motherOccupation:
      optionalString(
        data.motherOccupation
      ),

    familyType:
      data.familyType,

    familyValues:
      data.familyValues,

    familyStatus:
      optionalString(
        data.familyStatus
      ),

    nativePlace:
      data.nativePlace,

    brothers:
      optionalNumber(
        data.brothers
      ) ?? 0,

    marriedBrothers:
      optionalString(
        data.marriedBrothers
      ),

    sisters:
      optionalNumber(
        data.sisters
      ) ?? 0,

    marriedSisters:
      optionalString(
        data.marriedSisters
      ),

    maternalUncleName:
      optionalString(
        data.maternalUncleName
      ),

    maternalUnclePhone:
      optionalString(
        data.maternalUnclePhone
      ),

    uncleName:
      optionalString(
        data.uncleName
      ),

    unclePhone:
      optionalString(
        data.unclePhone
      ),

    aboutFamily:
      optionalString(
        data.aboutFamily
      ),
  };

  // ============================================================
  // ASTROLOGY DETAILS
  // ============================================================

  const astrologyDetails = {
    motherTongue:
      data.motherTongue,

    religion:
      data.religion,

    caste:
      data.caste,

    subCast:
      optionalString(
        data.subCast
      ),

    placeOfBirth:
      optionalString(
        data.placeOfBirth
      ),

    timeOfBirth:
      optionalString(
        data.timeOfBirth
      ),

    rashi:
      optionalString(
        data.rashi
      ),

    gotra:
      optionalString(
        data.gotra
      ),

    gan:
      optionalString(
        data.gan
      ),

    nadi:
      optionalString(
        data.nadi
      ),

    charan:
      optionalString(
        data.charan
      ),

    nakshatra:
      optionalString(
        data.nakshatra
      ),

    isManglik:
      data.manglik ?? false,

    importanceOfPatrika:
      data.importanceOfPatrika ??
      'Not Specified',
  };

  // ============================================================
  // PARTNER DETAILS
  // ============================================================

  const ageRange =
    data.expectedAgeRange || {};

  const partnerDetails = {
    partnerMaritalStatus:
      data.partnerMaritalStatus,

    expectedAgeRange: {
      from:
        optionalNumber(
          ageRange.from
        ),

      to:
        optionalNumber(
          ageRange.to
        ),
    },

    partnerComplexionType:
      optionalString(
        data.partnerComplexionType
      ),

    partnerHeight:
      optionalNumber(
        data.partnerHeight
      ),

    partnerWeight:
      optionalNumber(
        data.partnerWeight
      ),

    partnerDiet:
      data.partnerDiet,

    partnerSmoking:
      data.partnerSmoking,

    partnerDrinking:
      data.partnerDrinking,

    partnerWorkingLocation:
      optionalString(
        data.partnerWorkingLocation
      ),

    partnerIncome:
      optionalNumber(
        data.partnerIncome
      ),

    partnerEducation:
      data.partnerEducation,

    partnerProfession:
      data.partnerProfession,

    wantsWorkingPartner:
      data.wantsWorkingPartner,
  };

  // ============================================================
  // DOCUMENT DETAILS
  // ============================================================

  const documentDetails = {
    aadharCardNumber:
      optionalDocument(
        data.aadharNumber
      ),

    panCardNumber:
      optionalDocument(
        data.panCardNumber
      ),

    passportNumber:
      optionalDocument(
        data.passportNumber
      ),

    aadhaarFrontphoto:
      optionalDocument(
        data.aadhaarFrontphoto
      ),

    aadhaarBackphoto:
      optionalDocument(
        data.aadhaarBackphoto
      ),

    panFrontphoto:
      optionalDocument(
        data.panFrontphoto
      ),

    panBackphoto:
      optionalDocument(
        data.panBackphoto
      ),

    highestEducationalDoc:
      optionalDocument(
        data.highestEducationalDoc
      ),

    castecertificate:
      optionalDocument(
        data.castecertificate
      ),

    passportFrontphoto:
      optionalDocument(
        data.passportFrontphoto
      ),

    passportBackphoto:
      optionalDocument(
        data.passportBackphoto
      ),

    photoFulls:
      optionalDocument(
        data.photoFulls
      ),

    photoCloseup:
      optionalDocument(
        data.photoCloseup
      ),

    photoFull:
      optionalDocument(
        data.photoFull
      ),

    familyPhoto:
      optionalDocument(
        data.familyPhoto
      ),

    photos:
      optionalArray(
        data.photos
      ),
  };

  // ============================================================
  // CREATE NEW USER
  // ============================================================

  if (!matrimonyUser) {
    matrimonyUser =
      new Matrimony({
        approvalStatus:
          'Approved',

        userRegistration:
          registration,

        personalDetail:
          personalDetails,

        educationalDetail:
          educationalDetails,

        familyDetails:
          familyDetails,

        astrologyDetails:
          astrologyDetails,

        partnerDetail:
          partnerDetails,

        documentDetails:
          documentDetails,
      });
  }

  // ============================================================
  // UPDATE EXISTING USER
  // ============================================================

  else {
    matrimonyUser.userRegistration = {
      ...(
        matrimonyUser
          .userRegistration
          ?.toObject?.() || {}
      ),
      ...registration,
    };

    matrimonyUser.personalDetail = {
      ...(
        matrimonyUser
          .personalDetail
          ?.toObject?.() || {}
      ),
      ...personalDetails,
    };

    matrimonyUser.educationalDetail = {
      ...(
        matrimonyUser
          .educationalDetail
          ?.toObject?.() || {}
      ),
      ...educationalDetails,
    };

    matrimonyUser.familyDetails = {
      ...(
        matrimonyUser
          .familyDetails
          ?.toObject?.() || {}
      ),
      ...familyDetails,
    };

    matrimonyUser.astrologyDetails = {
      ...(
        matrimonyUser
          .astrologyDetails
          ?.toObject?.() || {}
      ),
      ...astrologyDetails,
    };

    matrimonyUser.partnerDetail = {
      ...(
        matrimonyUser
          .partnerDetail
          ?.toObject?.() || {}
      ),
      ...partnerDetails,
    };

    matrimonyUser.documentDetails = {
      ...(
        matrimonyUser
          .documentDetails
          ?.toObject?.() || {}
      ),
      ...documentDetails,
    };
  }

  // ============================================================
  // SAVE
  // ============================================================

  await matrimonyUser.save();

  // ============================================================
  // GENERATE JWT
  // ============================================================

  const token =
    matrimonyUser.jwtToken
      ? matrimonyUser.jwtToken()
      : this.generateToken(
          matrimonyUser._id,
          matrimonyUser
            .userRegistration
            .email
        );

  // ============================================================
  // RETURN USER
  // ============================================================

  const mergedUser =
    await this.getMergedUser(
      matrimonyUser
    );

  return {
    token,
    user: mergedUser,
  };
}
  async forgotPassword({ identifier }) {
    if (!identifier) {
      const error = new Error('Identifier is required');
      error.statusCode = 400;
      throw error;
    }

    const normalized = identifier.trim().toLowerCase();
    let user;
    if (normalized.includes('@')) {
      user = await Matrimony.findOne({ "userRegistration.email": normalized });
    } else {
      const num = Number(normalized.replace(/\D/g, ''));
      user = await Matrimony.findOne({ "userRegistration.phoneNumber": num });
    }

    if (!user) {
      const error = new Error('No account found with this email or mobile number.');
      error.statusCode = 404;
      throw error;
    }

    const otpCode = this.generate4DigitOTP();
    otpStore.set(normalized, { code: otpCode, expiresAt: Date.now() + 10 * 60 * 1000 });

    if (user.userRegistration?.email) {
      try {
        await sendOTPEmail(user.userRegistration.email, otpCode);
      } catch (err) {
        console.error("Password reset email error:", err.message);
      }
    }

    console.log(`[FORGOT PASSWORD OTP] Target: ${normalized} | Code: ${otpCode}`);
    return { success: true, message: 'Password reset code sent successfully' };
  }

  async verifyForgotOtp({ identifier, code }) {
    const normalized = identifier.trim().toLowerCase();
    const record = otpStore.get(normalized);

    if (!record || record.code !== code) {
      const error = new Error('Invalid code');
      error.statusCode = 401;
      throw error;
    }

    if (Date.now() > record.expiresAt) {
      otpStore.delete(normalized);
      const error = new Error('Reset code has expired');
      error.statusCode = 401;
      throw error;
    }

    return { success: true, message: 'OTP verified successfully' };
  }

  async resetPassword({ identifier, code, newPassword }) {
    const normalized = identifier.trim().toLowerCase();
    const record = otpStore.get(normalized);

    if (!record || record.code !== code) {
      const error = new Error('Invalid or expired password reset session');
      error.statusCode = 401;
      throw error;
    }

    let user;
    if (normalized.includes('@')) {
      user = await Matrimony.findOne({ "userRegistration.email": normalized });
    } else {
      const num = Number(normalized.replace(/\D/g, ''));
      user = await Matrimony.findOne({ "userRegistration.phoneNumber": num });
    }

    if (!user) {
      const error = new Error('User not found');
      error.statusCode = 404;
      throw error;
    }

    user.userRegistration.password = newPassword;
    await user.save();
    otpStore.delete(normalized);

    return { success: true, message: 'Password updated successfully' };
  }

  async changePassword(userId, { currentPassword, newPassword }) {
    const user = await Matrimony.findById(userId);
    if (!user || !user.userRegistration?.password) {
      const error = new Error('User account error');
      error.statusCode = 400;
      throw error;
    }

    const isMatch = await user.comparePassword(currentPassword);
    if (!isMatch) {
      const error = new Error('Current password is incorrect');
      error.statusCode = 400;
      throw error;
    }

    user.userRegistration.password = newPassword;
    await user.save();

    return { success: true, message: 'Password changed successfully' };
  }
}

export default new AuthService();
