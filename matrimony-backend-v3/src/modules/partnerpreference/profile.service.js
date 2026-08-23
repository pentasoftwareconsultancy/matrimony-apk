import Matrimony from "../brideGroom/bridegroom.schema.js";
import mongoose from "mongoose";
import partnerPrefernceSchema from "./profile.schema.js";

export const getMatches = async (userId) => {
  const user = await Matrimony.findById(userId);

  if (!user) {
    return { statusCode: 404, body: { success: false, message: "User not found" } };
  }

  const pref = user.partnerDetail;
  console.log("User Preferences:", pref);

  console.log("annualIncome:", pref.partnerIncome, typeof pref.partnerIncome);
  if (!pref) {
    return { statusCode: 400, body: { success: false, message: "No partner preferences set" } };
  }

  // conversion formula  inch to cm
  const convertHeightToCm = (height) => {
    if (!height) return null;

    // Case 1: Already in cm (assume anything > 100 is cm)
    if (height > 100) {
      return height;
    }

    // Case 2: Feet.Inches format (e.g., 5.7 => 5 feet 7 inches)
    const feet = Math.floor(height);
    const inches = Math.round((height - feet) * 10); // 0.7 -> 7 inches
    return feet * 30.48 + inches * 2.54;
  };
  // Opposite gender
  const oppositeGender =
    user.personalDetail.gender === "Groom" ? "Bride" : "Groom";

  // Base query
  const query = {
    "personalDetail.gender": oppositeGender,
    _id: { $ne: userId }, // Exclude self
    "personalDetail.age": {
      $gte: pref.expectedAgeRange.from, // candidate's age >= min age
      $lte: pref.expectedAgeRange.to, // candidate's age <= max age
    },
    // "personalDetail.maritalStatus": pref.partnerMaritalStatus
  };

  if (pref.partnerMaritalStatus) {
    query["personalDetail.maritalStatus"] = pref.partnerMaritalStatus;
  }
  if (pref.partnerComplexionType) {
    query["personalDetail.complexionType"] = pref.partnerComplexionType;
  }
  if (pref.partnerHeight) {
    const heightInCm = convertHeightToCm(pref.partnerHeight);
    query["personalDetail.height"] = {
      $gte: pref.partnerHeight - 10,
      $lte: pref.partnerHeight + 10,
    };
    console.log(heightInCm);
  }
  if (pref.partnerWeight) {
    query["personalDetail.weight"] = {
      $gte: pref.partnerWeight - 5,
      $lte: pref.partnerWeight + 10,
    };
  }
  if (pref.partnerDiet) {
    query["personalDetail.diet"] = pref.partnerDiet;
  }
  if (pref.partnerDrinking) {
    query["personalDetail.drinking"] = pref.partnerDrinking;
  }
  if (pref.partnerSmoking) {
    query["personalDetail.smoking"] = pref.partnerSmoking;
  }
  if (pref.partnerWorkingLocation) {
    query["educationalDetail.companyAddress"] = {
      $regex: pref.partnerWorkingLocation,
      $options: "i",
    };
  }

  // needs updated in future
  // if (pref.partnerIncome) {
  //   query["educationalDetail.annualIncome"] = { $gte: Number(pref.partnerIncome-200000), $lte: Number(pref.partnerIncome + 200000)};
  // }
  if (pref.partnerEducation) {
    query["educationalDetail.highestEducation"] = pref.partnerEducation;
  }
  if (pref.partnerProfession) {
    query["educationalDetail.profession"] = pref.partnerProfession;
  }

  // Fetch matches
  const matches = await Matrimony.find(query);
  return {
    statusCode: 200,
    body: { success: true, count: matches.length, matches },
  };
};

export const getNearMeProfiles = async (userId) => {
  const currentUser = await Matrimony.findById(userId);
  console.log("User ID:", userId);
  console.log("Found User:", currentUser);

  if (
    !currentUser ||
    !currentUser.location ||
    !currentUser.location.coordinates
  ) {
    return {
      statusCode: 404,
      body: { success: false, message: "User not found or location not set" },
    };
  }

  const [lng, lat] = currentUser.location.coordinates;

  const nearbyUsers = await Matrimony.find({
    _id: { $ne: userId },
    location: {
      $near: {
        $geometry: {
          type: "Point",
          coordinates: [lng, lat],
        },
        $maxDistance: 50000, // in meters = 50km
      },
    },
  });

  return {
    statusCode: 200,
    body: { success: true, count: nearbyUsers.length, data: nearbyUsers },
  };
};

export const getNewProfiles = async (userId) => {
  // ✅ Find the logged-in user
  const currentUser = await Matrimony.findById(userId).populate(
    "personalDetail"
  );

  if (!currentUser || !currentUser.personalDetail?.gender) {
    return {
      statusCode: 404,
      body: { success: false, message: "User not found or gender not set" },
    };
  }

  // ✅ Opposite gender filter
  let genderFilter = {};
  if (currentUser.personalDetail.gender === "Bride") {
    genderFilter["personalDetail.gender"] = "Groom";
  } else if (currentUser.personalDetail.gender === "Groom") {
    genderFilter["personalDetail.gender"] = "Bride";
  }

  // ✅ Fetch only opposite gender profiles
  const profiles = await Matrimony.find({
    _id: { $ne: userId }, // exclude logged-in user
    ...genderFilter,
  })
    .sort({ createdAt: -1 }) // newest first
    .limit(20)
    .select("-password -confirmPassword");

  return {
    statusCode: 200,
    body: {
      success: true,
      message: "New profiles fetched successfully",
      data: profiles,
    },
  };
};

// ===================== HEIGHT HELPER =====================
function convertHeightToInches(heightString) {
  try {
    if (heightString.includes("'")) {
      const parts = heightString.split("'");
      const feet = parseInt(parts[0]);
      const inches = parts[1] ? parseInt(parts[1].replace(/"/g, "")) : 0;
      return feet * 12 + inches;
    } else if (heightString.includes(".")) {
      const feet = parseFloat(heightString);
      return Math.round(feet * 12);
    } else if (!isNaN(heightString)) {
      return parseInt(heightString);
    }
    return null;
  } catch (error) {
    console.error("Error converting height:", error);
    return null;
  }
}

export const filterUsers = async (userId, filters) => {
  let query = {};

  // ✅ Restrict bride → see grooms only / groom → see brides only
  const loggedInUser = await Matrimony.findById(userId).populate(
    "personalDetail"
  );
  if (loggedInUser && loggedInUser.personalDetail?.gender) {
    if (loggedInUser.personalDetail.gender === "Bride") {
      query["personalDetail.gender"] = "Groom";
    } else if (loggedInUser.personalDetail.gender === "Groom") {
      query["personalDetail.gender"] = "Bride";
    }
  }

  // ================== Age filter ==================
  if (filters.minAge || filters.maxAge) {
    query["userRegistration.dateOfBirth"] = {};

    if (filters.minAge) {
      const maxBirthDate = new Date();
      maxBirthDate.setFullYear(
        maxBirthDate.getFullYear() - parseInt(filters.minAge)
      );
      query["userRegistration.dateOfBirth"].$gte = maxBirthDate;
    }

    if (filters.maxAge) {
      const minBirthDate = new Date();
      minBirthDate.setFullYear(
        minBirthDate.getFullYear() - parseInt(filters.maxAge) - 1
      );
      query["userRegistration.dateOfBirth"].$lte = minBirthDate;
    }
  }

  // ================== Marital status filter ==================
  if (filters.maritalStatus) {
    query["personalDetail.maritalStatus"] = filters.maritalStatus;
  }

  // ================== Height filter ==================
  if (filters.height) {
    const heightInInches = convertHeightToInches(filters.height);
    if (heightInInches) {
      query["personalDetail.height"] = heightInInches;
    }
  }

  // ================== Other filters ==================
  if (filters.state) query["userRegistration.state"] = filters.state;
  if (filters.country) query["userRegistration.country"] = filters.country;
  if (filters.occupation)
    query["educationalDetail.profession"] = filters.occupation;
  if (filters.annualIncome)
    query["educationalDetail.annualIncome"] = {
      $gte: parseInt(filters.annualIncome),
    };
  if (filters.diet) query["personalDetail.diet"] = filters.diet;
  if (filters.familyType)
    query["familyDetails.familyType"] = filters.familyType;
  if (filters.smoke)
    query["personalDetail.smoking"] = filters.smoke === "Yes" ? "Yes" : "No";
  if (filters.drink)
    query["personalDetail.drinking"] = filters.drink === "Yes" ? "Yes" : "No";
  if (filters.religion) query["astrologyDetails.religion"] = filters.religion;
  if (filters.caste) query["astrologyDetails.caste"] = filters.caste;

  // ================== Query DB ==================
  const filteredUsers = await Matrimony.find(query)
    .populate("userRegistration")
    .populate("personalDetail")
    .populate("educationalDetail")
    .populate("familyDetails")
    .populate("astrologyDetails")
    .populate("documentDetails");

  return { statusCode: 200, body: { success: true, data: filteredUsers } };
};

// ===================== GET FILTER OPTIONS =====================
export const getFilterOptions = async () => {
  const maritalStatuses = await Matrimony.distinct(
    "personalDetail.maritalStatus"
  );
  const occupations = await Matrimony.distinct(
    "educationalDetail.profession"
  );
  const diets = await Matrimony.distinct("personalDetail.diet");
  const familyTypes = await Matrimony.distinct("familyDetails.familyType");
  const religions = await Matrimony.distinct("astrologyDetails.religion");
  const castes = await Matrimony.distinct("astrologyDetails.caste");
  const countries = await Matrimony.distinct("userRegistration.country");
  const states = await Matrimony.distinct("userRegistration.state");

  return {
    statusCode: 200,
    body: {
      success: true,
      data: {
        maritalStatuses: maritalStatuses.filter(Boolean),
        occupations: occupations.filter(Boolean),
        diets: diets.filter(Boolean),
        familyTypes: familyTypes.filter(Boolean),
        religions: religions.filter(Boolean),
        castes: castes.filter(Boolean),
        countries: countries.filter(Boolean),
        states: states.filter(Boolean),
      },
    },
  };
};

// ===================== GET USER BY ID =====================
export const getUserById = async (id) => {
  const user = await Matrimony.findById(id)
    .populate("userRegistration")
    .populate("personalDetail")
    .populate("educationalDetail")
    .populate("familyDetails")
    .populate("astrologyDetails")
    .populate("documentDetails");

  if (!user) {
    return { statusCode: 404, body: { success: false, message: "User not found" } };
  }

  return { statusCode: 200, body: { success: true, data: user } };
};

// ================== ADMIN FILTER USERS ==================
export const adminFilterUsers = async (filters) => {
  let query = {};

  // ✅ Gender filter (Bride/Groom)
  if (filters.gender) {
    query["personalDetail.gender"] = filters.gender;
  }

  // ✅ Age filter
  if (filters.minAge || filters.maxAge) {
    query["userRegistration.dateOfBirth"] = {};

    if (filters.minAge) {
      const maxBirthDate = new Date();
      maxBirthDate.setFullYear(
        maxBirthDate.getFullYear() - parseInt(filters.minAge)
      );
      query["userRegistration.dateOfBirth"].$gte = maxBirthDate;
    }

    if (filters.maxAge) {
      const minBirthDate = new Date();
      minBirthDate.setFullYear(
        minBirthDate.getFullYear() - parseInt(filters.maxAge) - 1
      );
      query["userRegistration.dateOfBirth"].$lte = minBirthDate;
    }
  }

  // ✅ Status (Marital status)
  if (filters.status) {
    query["personalDetail.maritalStatus"] = filters.status;
  }

  // ✅ District
  if (filters.district) {
    query["userRegistration.district"] = filters.district;
  }

  // ✅ Profession
  if (filters.profession) {
    query["educationalDetail.profession"] = filters.profession;
  }

  // ✅ Annual Income
  if (filters.annualIncome) {
    query["educationalDetail.annualIncome"] = {
      $gte: parseInt(filters.annualIncome),
    };
  }

  // ✅ Education
  if (filters.education) {
    query["educationalDetail.educationLevel"] = filters.education;
  }

  // ✅ Family Type
  if (filters.familyType) {
    query["familyDetails.familyType"] = filters.familyType;
  }

  // ============= Query DB =============
  const users = await Matrimony.find(query)
    .populate("userRegistration")
    .populate("personalDetail")
    .populate("educationalDetail")
    .populate("familyDetails")
    .populate("astrologyDetails");

  return {
    statusCode: 200,
    body: { success: true, count: users.length, data: users },
  };
};

// ================== ADMIN FILTER OPTIONS ==================
export const adminFilterOptions = async () => {
  const genders = await Matrimony.distinct("personalDetail.gender");
  const statuses = await Matrimony.distinct("personalDetail.maritalStatus");
  const districts = await Matrimony.distinct("userRegistration.district");
  const professions = await Matrimony.distinct("educationalDetail.profession");
  const annualIncomes = await Matrimony.distinct("educationalDetail.annualIncome");
  const educations = await Matrimony.distinct("educationalDetail.educationLevel");
  const familyTypes = await Matrimony.distinct("familyDetails.familyType");

  return {
    statusCode: 200,
    body: {
      success: true,
      data: {
        genders: genders.filter(Boolean),
        statuses: statuses.filter(Boolean),
        districts: districts.filter(Boolean),
        professions: professions.filter(Boolean),
        annualIncomes: annualIncomes.filter(Boolean),
        educations: educations.filter(Boolean),
        familyTypes: familyTypes.filter(Boolean),
      },
    },
  };
};
