import ProfileRepository from '../repositories/ProfileRepository.js';
import Matrimony from '../models/Matrimony.js';
import UserAction from '../models/UserAction.js';
import ProfileView from '../models/ProfileView.js';
import AuthService from './AuthService.js';

class ProfileService {
  async getProfileByUserId(userId) {
    const matrimony = await ProfileRepository.findByUserId(userId);
    if (!matrimony) return null;
    return await AuthService.getMergedUser(matrimony);
  }

  async getProfileById(id) {
    const matrimony = await Matrimony.findById(id);
    if (!matrimony) return null;
    return await AuthService.getMergedUser(matrimony);
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

    if (profileData.fullName) reg.fullName = profileData.fullName;
    if (profileData.phone) reg.phoneNumber = Number(profileData.phone.replace(/\D/g, ''));
    if (profileData.city) reg.city = profileData.city;
    if (profileData.state) reg.state = profileData.state;
    if (profileData.address) reg.address = profileData.address;

    if (profileData.maritalStatus) personal.maritalStatus = profileData.maritalStatus;
    if (profileData.height) personal.height = profileData.height;
    if (profileData.weight) personal.weight = profileData.weight;
    if (profileData.bloodGroup) personal.bloodGroup = profileData.bloodGroup;
    if (profileData.diet) personal.diet = profileData.diet;
    if (profileData.about || profileData.aboutMe) personal.descriptionAboutSelf = profileData.about || profileData.aboutMe;

    if (profileData.highestEdu || profileData.qualification) edu.highestEducation = profileData.highestEdu || profileData.qualification;
    if (profileData.profession || profileData.occupation) edu.profession = profileData.profession || profileData.occupation;
    if (profileData.income || profileData.annualIncome) edu.annualIncome = profileData.income || profileData.annualIncome;

    if (profileData.religion) astro.religion = profileData.religion;
    if (profileData.caste) astro.caste = profileData.caste;
    if (profileData.rashi) astro.rashi = profileData.rashi;
    if (profileData.gotra) astro.gotra = profileData.gotra;
    if (profileData.manglik !== undefined) astro.isManglik = profileData.manglik === true || profileData.manglik === 'Yes';

    if (profileData.fatherName) family.fatherName = profileData.fatherName;
    if (profileData.motherName) family.motherName = profileData.motherName;
    if (profileData.familyType) family.familyType = profileData.familyType;

    matrimony.userRegistration = reg;
    matrimony.personalDetail = personal;
    matrimony.educationalDetail = edu;
    matrimony.familyDetails = family;
    matrimony.astrologyDetails = astro;
    matrimony.partnerDetail = partner;
    matrimony.documentDetails = docs;

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
      const blockedActions = await UserAction.find({ fromUser: currentUserId, actionType: 'ignore' });
      blockedIds = blockedActions.map(b => b.toUser.toString());
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

    const sanitizedProfiles = [];
    for (const doc of docs) {
      const merged = await AuthService.getMergedUser(doc);
      sanitizedProfiles.push(merged);
    }

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
    if (viewerId.toString() === viewedId.toString()) return null;
    await ProfileView.create({
      viewer: viewerId,
      viewed: viewedId,
      viewedAt: new Date()
    });
    return { success: true };
  }

  async getProfileViews(userId) {
    const views = await ProfileView.find({ viewed: userId })
      .populate('viewer')
      .sort({ viewedAt: -1 })
      .lean();

    const sanitizedViewers = [];
    for (const v of views) {
      if (v.viewer) {
        const merged = await AuthService.getMergedUser(v.viewer);
        sanitizedViewers.push({
          ...merged,
          viewedAt: v.viewedAt
        });
      }
    }
    return sanitizedViewers;
  }
}

export default new ProfileService();
