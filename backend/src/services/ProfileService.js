import ProfileRepository from '../repositories/ProfileRepository.js';
import Matrimony from '../models/Matrimony.js';
import UserAction from '../models/UserAction.js';
import ProfileView from '../models/ProfileView.js';
import AuthService from './AuthService.js';

import NotificationService from './NotificationService.js';

class ProfileService {
  async getProfileByUserId(userId) {
    const matrimony = await ProfileRepository.findByUserId(userId);
    if (!matrimony) return null;
    return await AuthService.getMergedUser(matrimony);
  }

  async getProfileById(id, viewerId = null) {
    const matrimony = await Matrimony.findById(id);
    if (!matrimony) return null;
    const isOwner = Boolean(viewerId && viewerId.toString() === id.toString());
    return await AuthService.getMergedUser(matrimony, { includePrivate: isOwner });
  }

  async updateProfile(userId, profileData) {
    const matrimony = await Matrimony.findById(userId);
    if (!matrimony) throw new Error('Profile not found');

    const personal = matrimony.personalDetail || {};
    const edu = matrimony.educationalDetail || {};
    const family = matrimony.familyDetails || {};
    const astro = matrimony.astrologyDetails || {};
    const partner = matrimony.partnerDetail || {};
    const docs = matrimony.documentDetails || {};
    const reg = matrimony.userRegistration || {};

    const hasValue = (val) => val !== undefined && val !== null && (typeof val !== 'string' || val.trim().length > 0);

    // 1. User Registration / Basic Information
    if (hasValue(profileData.fullName || profileData.name)) {
      reg.fullName = (profileData.fullName || profileData.name).toString().trim();
    }
    if (hasValue(profileData.phone || profileData.phoneNumber)) {
      const cleanPhone = (profileData.phone || profileData.phoneNumber).toString().replace(/\D/g, '');
      if (cleanPhone) reg.phoneNumber = Number(cleanPhone);
    }
    if (hasValue(profileData.altPhone || profileData.alternativePhoneNumber)) {
      reg.alternativePhoneNumber = (profileData.altPhone || profileData.alternativePhoneNumber).toString().trim();
    }
    if (hasValue(profileData.email)) {
      reg.email = profileData.email.toString().trim().toLowerCase();
    }
    const rawDob = profileData.birthDate || profileData.dob || profileData.dateOfBirth;
    if (hasValue(rawDob)) {
      let parsedDate = null;
      if (typeof rawDob === 'string' && rawDob.includes('/')) {
        const parts = rawDob.split('/');
        if (parts.length === 3) {
          parsedDate = new Date(`${parts[2]}-${parts[1]}-${parts[0]}`);
        }
      } else {
        parsedDate = new Date(rawDob);
      }
      if (parsedDate && !isNaN(parsedDate.getTime())) {
        reg.dateOfBirth = parsedDate;
      }
    }
    if (hasValue(profileData.city || profileData.district)) {
      reg.district = (profileData.city || profileData.district).toString().trim();
    }
    if (hasValue(profileData.state)) {
      reg.state = profileData.state.toString().trim();
    }
    if (hasValue(profileData.country)) {
      reg.country = profileData.country.toString().trim();
    }
    if (hasValue(profileData.address || profileData.homePlace)) {
      reg.address = (profileData.address || profileData.homePlace).toString().trim();
    }
    if (hasValue(profileData.village)) {
      reg.village = profileData.village.toString().trim();
    }
    if (hasValue(profileData.pincode)) {
      reg.pincode = profileData.pincode.toString().trim();
    }

    // 2. Personal Details
    if (hasValue(profileData.maritalStatus)) personal.maritalStatus = profileData.maritalStatus.toString().trim();
    if (hasValue(profileData.age)) {
      const parsedAge = Number(profileData.age);
      if (!isNaN(parsedAge) && parsedAge > 0) personal.age = parsedAge;
    }
    if (hasValue(profileData.height)) {
      const digits = profileData.height.toString().replace(/[^\d.]/g, '');
      const h = Number(digits);
      if (!isNaN(h) && h > 0) personal.height = h;
    }
    if (hasValue(profileData.weight)) {
      const digits = profileData.weight.toString().replace(/[^\d.]/g, '');
      const w = Number(digits);
      if (!isNaN(w) && w > 0) personal.weight = w;
    }
    if (hasValue(profileData.bloodGroup)) personal.bloodGroup = profileData.bloodGroup.toString().trim();
    if (hasValue(profileData.diet)) personal.diet = profileData.diet.toString().trim();
    if (hasValue(profileData.complexion || profileData.complexionType)) {
      personal.complexionType = (profileData.complexion || profileData.complexionType).toString().trim();
    }
    if (hasValue(profileData.bodyType)) personal.bodyType = profileData.bodyType.toString().trim();
    if (hasValue(profileData.specialCase)) personal.specialCase = profileData.specialCase.toString().trim();
    if (hasValue(profileData.smoking)) personal.smoking = profileData.smoking.toString().trim();
    if (hasValue(profileData.drinking)) personal.drinking = profileData.drinking.toString().trim();
    if (hasValue(profileData.drinkingSmoking)) {
      personal.smoking = profileData.drinkingSmoking.toString().trim();
      personal.drinking = profileData.drinkingSmoking.toString().trim();
    }
    if (hasValue(profileData.hobbies)) {
      personal.hobbies = Array.isArray(profileData.hobbies) ? profileData.hobbies : [profileData.hobbies.toString().trim()];
    }
    if (hasValue(profileData.agriLand || profileData.agriculturalLandAcres)) {
      personal.agriculturalLandAcres = (profileData.agriLand || profileData.agriculturalLandAcres).toString().trim();
    }
    if (hasValue(profileData.children || profileData.numberOfChildren)) {
      const c = Number(profileData.children ?? profileData.numberOfChildren);
      if (!isNaN(c)) personal.numberOfChildren = c;
    }
    if (hasValue(profileData.about || profileData.aboutMe || profileData.descriptionAboutSelf)) {
      personal.descriptionAboutSelf = (profileData.about || profileData.aboutMe || profileData.descriptionAboutSelf).toString().trim();
    }

    // 3. Educational & Professional Details
    if (hasValue(profileData.highestEdu || profileData.qualification || profileData.highestEducation)) {
      edu.highestEducation = (profileData.highestEdu || profileData.qualification || profileData.highestEducation).toString().trim();
    }
    if (hasValue(profileData.eduField || profileData.educationField)) {
      edu.educationField = (profileData.eduField || profileData.educationField).toString().trim();
    }
    if (hasValue(profileData.university || profileData.universityCollege)) {
      edu.universityCollege = (profileData.university || profileData.universityCollege).toString().trim();
    }
    if (hasValue(profileData.profession || profileData.occupation)) {
      edu.profession = (profileData.profession || profileData.occupation).toString().trim();
    }
    if (hasValue(profileData.designation || profileData.occupationPosition)) {
      edu.occupationPosition = (profileData.designation || profileData.occupationPosition).toString().trim();
    }
    if (hasValue(profileData.organization || profileData.organizationName)) {
      edu.organizationName = (profileData.organization || profileData.organizationName).toString().trim();
    }
    if (hasValue(profileData.companyAddress || profileData.workPlace || profileData.workLocation)) {
      edu.companyAddress = (profileData.companyAddress || profileData.workPlace || profileData.workLocation).toString().trim();
    }
    if (hasValue(profileData.income || profileData.annualIncome)) {
      edu.annualIncome = (profileData.income || profileData.annualIncome).toString().trim();
    }

    // 4. Astrology / Religion Details
    if (hasValue(profileData.motherTongue)) astro.motherTongue = profileData.motherTongue.toString().trim();
    if (hasValue(profileData.religion)) astro.religion = profileData.religion.toString().trim();
    if (hasValue(profileData.caste)) astro.caste = profileData.caste.toString().trim();
    if (hasValue(profileData.subCast)) astro.subCast = profileData.subCast.toString().trim();
    if (hasValue(profileData.placeOfBirth)) astro.placeOfBirth = profileData.placeOfBirth.toString().trim();
    if (hasValue(profileData.birthTime || profileData.timeOfBirth)) {
      astro.timeOfBirth = (profileData.birthTime || profileData.timeOfBirth).toString().trim();
    }
    if (hasValue(profileData.rashi)) astro.rashi = profileData.rashi.toString().trim();
    if (hasValue(profileData.gotra)) astro.gotra = profileData.gotra.toString().trim();
    if (hasValue(profileData.nakshatra)) astro.nakshatra = profileData.nakshatra.toString().trim();
    if (hasValue(profileData.charan)) astro.charan = profileData.charan.toString().trim();
    if (hasValue(profileData.gan)) astro.gan = profileData.gan.toString().trim();
    if (hasValue(profileData.nadi)) astro.nadi = profileData.nadi.toString().trim();
    if (profileData.manglik !== undefined) {
      astro.isManglik = profileData.manglik === true || profileData.manglik === 'Yes' || profileData.manglik === 'yes';
    }
    if (hasValue(profileData.partnerPriority || profileData.importanceOfPatrika)) {
      astro.importanceOfPatrika = (profileData.partnerPriority || profileData.importanceOfPatrika).toString().trim();
    }

    // 5. Family Details
    if (hasValue(profileData.fatherName)) family.fatherName = profileData.fatherName.toString().trim();
    if (hasValue(profileData.fatherEdu || profileData.fatherOccupation)) {
      family.fatherOccupation = (profileData.fatherEdu || profileData.fatherOccupation).toString().trim();
    }
    if (hasValue(profileData.motherName)) family.motherName = profileData.motherName.toString().trim();
    if (hasValue(profileData.motherOcc || profileData.motherOccupation)) {
      family.motherOccupation = (profileData.motherOcc || profileData.motherOccupation).toString().trim();
    }
    if (hasValue(profileData.familyType)) family.familyType = profileData.familyType.toString().trim();
    if (hasValue(profileData.familyValues || profileData.familyStatus)) {
      family.familyValues = (profileData.familyValues || profileData.familyStatus).toString().trim();
      family.familyStatus = (profileData.familyStatus || profileData.familyValues).toString().trim();
    }
    if (hasValue(profileData.nativePlace || profileData.homePlace)) {
      family.nativePlace = (profileData.nativePlace || profileData.homePlace).toString().trim();
    }

    // Dynamic Brothers Details
    if (Array.isArray(profileData.brothersDetails)) {
      family.brothersDetails = profileData.brothersDetails.map((b) => ({
        name: (b?.name || '').toString().trim(),
        occupation: (b?.occupation || '').toString().trim(),
      }));
      family.brothers = family.brothersDetails.length;
    } else if (hasValue(profileData.brothers)) {
      const b = Number(profileData.brothers);
      if (!isNaN(b)) family.brothers = b;
    }

    // Dynamic Sisters Details
    if (Array.isArray(profileData.sistersDetails)) {
      family.sistersDetails = profileData.sistersDetails.map((s) => ({
        name: (s?.name || '').toString().trim(),
        occupation: (s?.occupation || '').toString().trim(),
        isMarried: Boolean(s?.isMarried === true || s?.isMarried === 'true' || s?.isMarried === 'Yes' || s?.married === true),
        husbandName: (s?.husbandName || '').toString().trim(),
        husbandProfession: (s?.husbandProfession || '').toString().trim(),
      }));
      family.sisters = family.sistersDetails.length;
      const marriedCount = family.sistersDetails.filter((s) => s.isMarried).length;
      family.marriedSisters = marriedCount > 0 ? String(marriedCount) : '0';
    } else {
      if (hasValue(profileData.sisters)) {
        const s = Number(profileData.sisters);
        if (!isNaN(s)) family.sisters = s;
      }
      if (hasValue(profileData.marriedSister || profileData.marriedSisters)) {
        family.marriedSisters = (profileData.marriedSister || profileData.marriedSisters).toString().trim();
      }
    }

    // Dynamic Maternal Uncles Details
    if (Array.isArray(profileData.maternalUnclesDetails)) {
      family.maternalUnclesDetails = profileData.maternalUnclesDetails.map((u) => ({
        name: (u?.name || '').toString().trim(),
        occupation: (u?.occupation || '').toString().trim(),
      }));
      if (family.maternalUnclesDetails.length > 0) {
        family.maternalUncleName = family.maternalUnclesDetails.map((u) => u.name).filter(Boolean).join(', ');
      }
    } else if (hasValue(profileData.maternalUncle || profileData.maternalUncleName)) {
      family.maternalUncleName = (profileData.maternalUncle || profileData.maternalUncleName).toString().trim();
    }

    // Dynamic Uncles Details
    if (Array.isArray(profileData.unclesDetails)) {
      family.unclesDetails = profileData.unclesDetails.map((u) => ({
        name: (u?.name || '').toString().trim(),
        occupation: (u?.occupation || '').toString().trim(),
      }));
      if (family.unclesDetails.length > 0) {
        family.uncleName = family.unclesDetails.map((u) => u.name).filter(Boolean).join(', ');
      }
    } else if (hasValue(profileData.uncleName)) {
      family.uncleName = profileData.uncleName.toString().trim();
    }

    if (hasValue(profileData.unclePhone || profileData.maternalUnclePhone)) {
      family.unclePhone = (profileData.unclePhone || profileData.maternalUnclePhone).toString().trim();
      family.maternalUnclePhone = (profileData.unclePhone || profileData.maternalUnclePhone).toString().trim();
    }
    if (hasValue(profileData.aboutFamily)) family.aboutFamily = profileData.aboutFamily.toString().trim();

    // 6. Documents & Photos
    if (Array.isArray(profileData.photos) && profileData.photos.length > 0) {
      docs.photos = profileData.photos.filter((p) => typeof p === 'string' && p.trim().length > 0);
      if (docs.photos.length > 0) {
        docs.photoFulls = docs.photos[0];
        if (docs.photos.length > 1) docs.photoCloseup = docs.photos[1];
        if (docs.photos.length > 2) docs.photoFull = docs.photos[2];
      }
    }
    if (hasValue(profileData.aadharNumber || profileData.aadharCardNumber)) {
      docs.aadharCardNumber = (profileData.aadharNumber || profileData.aadharCardNumber).toString().trim();
    }
    if (hasValue(profileData.aadharCardUrl || profileData.aadhaarFrontphoto)) {
      const nextAadhar = (profileData.aadharCardUrl || profileData.aadhaarFrontphoto).toString().trim();
      if (nextAadhar !== docs.aadhaarFrontphoto) {
        docs.aadhaarFrontphoto = nextAadhar;
        docs.aadharStatus = 'pending';
        matrimony.isVerified = false;
      }
    }
    if (hasValue(profileData.casteCertificateUrl || profileData.castecertificate)) {
      const nextCaste = (profileData.casteCertificateUrl || profileData.castecertificate).toString().trim();
      if (nextCaste !== docs.castecertificate) {
        docs.castecertificate = nextCaste;
        docs.casteStatus = 'pending';
      }
    }

    matrimony.userRegistration = reg;
    matrimony.personalDetail = personal;
    matrimony.educationalDetail = edu;
    matrimony.familyDetails = family;
    matrimony.astrologyDetails = astro;
    matrimony.partnerDetail = partner;
    matrimony.documentDetails = docs;

    matrimony.markModified('userRegistration');
    matrimony.markModified('personalDetail');
    matrimony.markModified('educationalDetail');
    matrimony.markModified('familyDetails');
    matrimony.markModified('astrologyDetails');
    matrimony.markModified('partnerDetail');
    matrimony.markModified('documentDetails');

    await matrimony.save();
    return await AuthService.getMergedUser(matrimony);
  }


  async addPhoto(userId, photoUrl) {
    const matrimony = await Matrimony.findById(userId);

    if (!matrimony) {
      const error = new Error('Profile not found');
      error.statusCode = 404;
      throw error;
    }

    if (!photoUrl || typeof photoUrl !== 'string') {
      const error = new Error('Invalid photo URL');
      error.statusCode = 400;
      throw error;
    }

    const docs = matrimony.documentDetails || {};

    const legacyPhotos = [
      docs.photoFulls,
      docs.photoCloseup,
      docs.photoFull,
      docs.familyPhoto,
    ].filter(Boolean);

    const storedPhotos = Array.isArray(docs.photos)
      ? docs.photos.filter(Boolean)
      : [];

    const allPhotos = [...new Set([
      ...legacyPhotos,
      ...storedPhotos,
    ])];

    // Prevent duplicate photos.
    if (allPhotos.includes(photoUrl)) {
      return await AuthService.getMergedUser(matrimony);
    }

    // Enforce the maximum of six photos on the backend too.
    if (allPhotos.length >= 6) {
      const error = new Error(
        'Maximum 6 profile photos are allowed'
      );
      error.statusCode = 400;
      throw error;
    }

    docs.photos = [...new Set([...storedPhotos, photoUrl])];

    // Keep the primary photo field populated.
    if (!docs.photoFulls) {
      docs.photoFulls = photoUrl;
    }

    matrimony.documentDetails = docs;
    matrimony.markModified('documentDetails');

    await matrimony.save();

    return await AuthService.getMergedUser(matrimony);
  }

  async removePhoto(userId, photoUrl) {
    const matrimony = await Matrimony.findById(userId);

    if (!matrimony) {
      const error = new Error('Profile not found');
      error.statusCode = 404;
      throw error;
    }

    if (!photoUrl || typeof photoUrl !== 'string') {
      const error = new Error('Invalid photo URL');
      error.statusCode = 400;
      throw error;
    }

    const docs = matrimony.documentDetails || {};

    // Remove from the main photo array.
    const storedPhotos = Array.isArray(docs.photos)
      ? docs.photos
      : [];

    docs.photos = storedPhotos.filter(
      (photo) => photo !== photoUrl
    );

    // Also remove matching legacy photo references.
    if (docs.photoFulls === photoUrl) {
      docs.photoFulls = docs.photos[0] || '';
    }

    if (docs.photoCloseup === photoUrl) {
      docs.photoCloseup = '';
    }

    if (docs.photoFull === photoUrl) {
      docs.photoFull = '';
    }

    if (docs.familyPhoto === photoUrl) {
      docs.familyPhoto = '';
    }

    matrimony.documentDetails = docs;
    matrimony.markModified('documentDetails');

    await matrimony.save();

    return await AuthService.getMergedUser(matrimony);
  }


  _resolveDocumentFields(docId) {
    const docMap = {
      aadhar: { urlField: 'aadhaarFrontphoto', statusField: 'aadharStatus' },
      aadhaar: { urlField: 'aadhaarFrontphoto', statusField: 'aadharStatus' },
      caste: { urlField: 'castecertificate', statusField: 'casteStatus' },
      pan: { urlField: 'panFrontphoto', statusField: 'panStatus' },
      education: { urlField: 'highestEducationalDoc', statusField: 'educationStatus' },
    };
    const mapping = docMap[(docId || '').toString().toLowerCase()];
    if (!mapping) {
      const error = new Error('Unsupported document type');
      error.statusCode = 400;
      throw error;
    }
    return mapping;
  }

  async uploadDocument(userId, docId, fileUrl) {
    const mapping = this._resolveDocumentFields(docId);
    const matrimony = await Matrimony.findById(userId);
    if (!matrimony) {
      const error = new Error('Profile not found');
      error.statusCode = 404;
      throw error;
    }

    const docs = matrimony.documentDetails || {};
    docs[mapping.urlField] = fileUrl;
    docs[mapping.statusField] = 'pending';
    matrimony.isVerified = false;
    matrimony.documentDetails = docs;
    matrimony.markModified('documentDetails');
    await matrimony.save();

    return await AuthService.getMergedUser(matrimony);
  }

  async removeDocument(userId, docId) {
    const mapping = this._resolveDocumentFields(docId);
    const matrimony = await Matrimony.findById(userId);
    if (!matrimony) {
      const error = new Error('Profile not found');
      error.statusCode = 404;
      throw error;
    }

    const docs = matrimony.documentDetails || {};
    docs[mapping.urlField] = '';
    docs[mapping.statusField] = 'pending';
    matrimony.isVerified = false;
    matrimony.documentDetails = docs;
    matrimony.markModified('documentDetails');
    await matrimony.save();

    return await AuthService.getMergedUser(matrimony);
  }

  async getMatches(currentUserId, queryParams = {}) {
    const {
      categoryTab = 'Near me',
      search = '',
      ageMin = 22,
      ageMax = 35,
      maritalStatus,
      city,
      state,
      country,
      profession,
      education,
      religion,
      caste,
      diet,
    } = queryParams;

    let currentUserDoc = null;
    let blockedIds = [];
    if (currentUserId) {
      currentUserDoc = await Matrimony.findById(currentUserId);
      const blockedActions = await UserAction.find({
        actionType: 'ignore',
        active: true,
        $or: [{ fromUser: currentUserId }, { toUser: currentUserId }],
      }).lean();
      blockedIds = blockedActions.map((b) =>
        b.fromUser.toString() === currentUserId.toString()
          ? b.toUser.toString()
          : b.fromUser.toString()
      );
    }

    const query = {
      approvalStatus: { $nin: ['Denied', 'Deleted'] },
    };

    if (currentUserId) {
      query._id = { $ne: currentUserId, $nin: blockedIds };
    }

    // Gender recommendation rule: Male <-> Female / Groom <-> Bride
    if (currentUserDoc && currentUserDoc.personalDetail?.gender) {
      const userGender = currentUserDoc.personalDetail.gender;
      if (userGender === 'Groom' || userGender === 'Male') {
        query["personalDetail.gender"] = { $in: ['Bride', 'Female'] };
      } else if (userGender === 'Bride' || userGender === 'Female') {
        query["personalDetail.gender"] = { $in: ['Groom', 'Male'] };
      }
    }

    // Dynamic Age Filter (checking age, dateOfBirth, or missing age field)
    const minAgeNum = Number(ageMin) || 22;
    const maxAgeNum = Number(ageMax) || 35;
    const maxBirthDate = new Date();
    maxBirthDate.setFullYear(maxBirthDate.getFullYear() - minAgeNum);
    const minBirthDate = new Date();
    minBirthDate.setFullYear(minBirthDate.getFullYear() - maxAgeNum - 1);

    query["$or"] = [
      { "personalDetail.age": { $gte: minAgeNum, $lte: maxAgeNum } },
      { "userRegistration.dateOfBirth": { $gte: minBirthDate, $lte: maxBirthDate } },
      { "personalDetail.age": { $exists: false } },
      { "personalDetail.age": null },
    ];

    if (maritalStatus) {
      query["personalDetail.maritalStatus"] = new RegExp(maritalStatus, 'i');
    }
    if (city) {
      query["$or"] = [
        { "userRegistration.city": new RegExp(city, 'i') },
        { "userRegistration.district": new RegExp(city, 'i') },
        { "userRegistration.village": new RegExp(city, 'i') }
      ];
    }
    if (state) {
      query["userRegistration.state"] = new RegExp(state, 'i');
    }
    if (profession) {
      query["educationalDetail.profession"] = new RegExp(profession, 'i');
    }
    if (education) {
      query["educationalDetail.highestEducation"] = new RegExp(education, 'i');
    }
    if (religion) {
      query["astrologyDetails.religion"] = new RegExp(religion, 'i');
    }
    if (caste) {
      query["astrologyDetails.caste"] = new RegExp(caste, 'i');
    }
    if (diet) {
      query["personalDetail.diet"] = new RegExp(diet, 'i');
    }

    if (search && search.trim()) {
      const searchRegex = new RegExp(search.trim(), 'i');
      query["$or"] = [
        { "userRegistration.fullName": searchRegex },
        { "userRegistration.city": searchRegex },
        { "userRegistration.district": searchRegex },
        { "educationalDetail.profession": searchRegex },
        { "astrologyDetails.religion": searchRegex },
        { "astrologyDetails.caste": searchRegex }
      ];
    }

    let sortOptions = { createdAt: -1 };
    if (categoryTab === 'New matches' || categoryTab === 'New') {
      sortOptions = { createdAt: -1 };
    }

    const docs = await Matrimony.find(query).sort(sortOptions).limit(100).lean();

   const sanitizedProfiles =
     await Promise.all(
       docs.map((doc) =>
         AuthService.getMergedUser(doc, { includePrivate: false })
       )
     );

    // Prioritize location for 'Near me'
    if (categoryTab === 'Near me' && currentUserDoc) {
      const userLocation = currentUserDoc.userRegistration?.district || currentUserDoc.userRegistration?.city || '';
      if (userLocation) {
        const uLoc = userLocation.toLowerCase();
        sanitizedProfiles.sort((a, b) => {
          const aMatch = (a.city && a.city.toLowerCase().includes(uLoc)) || (a.district && a.district.toLowerCase().includes(uLoc));
          const bMatch = (b.city && b.city.toLowerCase().includes(uLoc)) || (b.district && b.district.toLowerCase().includes(uLoc));
          if (aMatch && !bMatch) return -1;
          if (!aMatch && bMatch) return 1;
          return 0;
        });
      }
    }

    return sanitizedProfiles;
  }

  async savePartnerPreference(userId, preferenceData) {
    const matrimony = await Matrimony.findById(userId);
    if (!matrimony) throw new Error('User not found');

    const partner = matrimony.partnerDetail || {};
    if (preferenceData.maritalStatus) partner.partnerMaritalStatus = preferenceData.maritalStatus;
    if (preferenceData.ageMin || preferenceData.ageMax) {
      partner.expectedAgeRange = {
        from: Number(preferenceData.ageMin || 21),
        to: Number(preferenceData.ageMax || 35),
      };
    }
    if (preferenceData.diet) partner.partnerDiet = preferenceData.diet;
    if (preferenceData.education) partner.partnerEducation = preferenceData.education;

    matrimony.partnerDetail = partner;
    await matrimony.save();
    return await AuthService.getMergedUser(matrimony);
  }

async recordProfileView(viewerId, viewedId) {
  if (!viewerId || !viewedId) {
    throw new Error('Viewer and viewed profile are required');
  }

  const viewerIdString = viewerId.toString();
  const viewedIdString = viewedId.toString();

  // ------------------------------------------------------------
  // Prevent self-view
  // ------------------------------------------------------------

  if (viewerIdString === viewedIdString) {
    return {
      recorded: false,
      reason: 'SELF_VIEW',
    };
  }

  // ------------------------------------------------------------
  // Verify target profile exists
  // ------------------------------------------------------------

  const viewedProfile = await Matrimony.findById(viewedId)
    .select('_id');

  if (!viewedProfile) {
    const error = new Error('Profile not found');
    error.statusCode = 404;
    throw error;
  }

  // ------------------------------------------------------------
  // 24-hour window
  // ------------------------------------------------------------

  const twentyFourHoursAgo = new Date(
    Date.now() - 24 * 60 * 60 * 1000
  );

  // ------------------------------------------------------------
  // First check.
  //
  // This handles the normal case without attempting an insert.
  // ------------------------------------------------------------

  const existingView = await ProfileView.findOne({
    viewerUserId: viewerId,
    viewedUserId: viewedId,
    viewedProfileId: viewedId,
    createdAt: {
      $gte: twentyFourHoursAgo,
    },
  }).select('_id');

  if (existingView) {
    return {
      recorded: false,
      reason: 'ALREADY_VIEWED_TODAY',
    };
  }

  // ------------------------------------------------------------
  // IMPORTANT:
  //
  // Create a deterministic key for this 24-hour viewing window.
  //
  // The same viewer + viewed profile + current 24-hour window
  // produces the same key.
  // ------------------------------------------------------------

  const windowStart = new Date(
    Math.floor(
      Date.now() / (24 * 60 * 60 * 1000)
    ) * (24 * 60 * 60 * 1000)
  );

  const viewKey =
    `${viewerIdString}_${viewedIdString}_${windowStart.getTime()}`;

  // ------------------------------------------------------------
  // Atomic protection.
  //
  // If multiple requests arrive simultaneously, MongoDB's unique
  // index on viewKey allows only ONE of them to create the view.
  // ------------------------------------------------------------

  let createdView = false;

  try {
    await ProfileView.create({
      viewerUserId: viewerId,
      viewedUserId: viewedId,
      viewedProfileId: viewedId,
      viewKey,
    });

    createdView = true;
  } catch (error) {
    // MongoDB duplicate-key error.
    //
    // Another simultaneous request already created this view.
    if (error?.code === 11000) {
      return {
        recorded: false,
        reason: 'ALREADY_VIEWED_TODAY',
      };
    }

    throw error;
  }

  // ------------------------------------------------------------
  // Only the request that successfully created the ProfileView
  // reaches this section.
  //
  // Therefore only ONE notification is generated.
  // ------------------------------------------------------------

  if (createdView) {
    const viewerProfile = await Matrimony.findById(viewerId)
      .select('documentDetails userRegistration');

    const photos =
      viewerProfile?.documentDetails?.photos || [];

    const senderImage =
      photos.length > 0
        ? photos[0]
        : '';

    await NotificationService.createProfileViewNotification({
      recipientUserId: viewedId,
      actorUserId: viewerId,
      profileId: viewerId,
      senderImage,
    });
  }

  return {
    recorded: true,
    reason: 'NEW_VIEW',
  };
}

async getProfileViews(userId) {
  if (!userId) {
    return {
      count: 0,
      views: [],
    };
  }

  // ============================================================
  // GET ALL PROFILE VIEWS FOR THE LOGGED-IN USER
  // ============================================================

  const views = await ProfileView.find({
    viewedUserId: userId,
  })
    .sort({ createdAt: -1 })
    .lean();

  const sanitizedViews = [];

  for (const view of views) {
    // ==========================================================
    // viewerUserId = THE PERSON WHO VIEWED THE PROFILE
    // viewedUserId = THE PERSON WHOSE PROFILE WAS VIEWED
    // ==========================================================

    if (!view.viewerUserId) {
      continue;
    }

    const viewerId = view.viewerUserId.toString();

    // ==========================================================
    // IMPORTANT:
    // Fetch the ACTUAL Matrimony document of the viewer.
    // Do NOT pass a populated {_id} object to getMergedUser().
    // ==========================================================

    const viewerMatrimony = await Matrimony.findById(viewerId)
      .lean();

    if (!viewerMatrimony) {
      continue;
    }

    // ==========================================================
    // Convert the complete viewer document into the same
    // profile format used everywhere else in the application.
    // ==========================================================

    const viewerProfile =
      await AuthService.getMergedUser(viewerMatrimony, { includePrivate: false });

    if (!viewerProfile) {
      continue;
    }

    // ==========================================================
    // DEBUG
    // ==========================================================

    console.log(
      '[ProfileViews] Viewer ID:',
      viewerId
    );

    console.log(
      '[ProfileViews] Viewer name:',
      viewerMatrimony.userRegistration?.fullName
    );

    console.log(
      '[ProfileViews] Merged profile name:',
      viewerProfile.fullName
    );

    console.log(
      '[ProfileViews] Merged profile ID:',
      viewerProfile.id
    );

    // ==========================================================
    // RETURN VIEWER PROFILE
    // ==========================================================

    sanitizedViews.push({
      profile: viewerProfile,
      viewedAt: view.createdAt,
    });
  }

  return {
    count: sanitizedViews.length,
    views: sanitizedViews,
  };
}
}

export default new ProfileService();
