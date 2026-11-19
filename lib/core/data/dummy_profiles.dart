import '../../features/auth/domain/models/user.dart';
import '../../features/profile/domain/models/profile_model.dart';
import '../utils/date_formatter.dart';

class MatrimonialProfile {
  final String id;
  final String fullName;
  final int age;
  final String gender;
  final String religion;
  final String caste;
  final String maritalStatus;
  final String bloodGroup;
  final String height; // e.g. "5'6\""
  final String qualification;
  final String occupation;
  final String annualIncome; // e.g. "₹9,00,000 LPA"
  final double incomeValue; // numeric for filtering
  final String city;
  final String state;
  final String country;
  final String about;
  final List<String> photos;
  final bool isPremium;
  final String premiumTier; // "Platinum", "Gold", "Diamond"
  final int compatibilityScore;
  final List<String> compatibilityTags;
  final String rashi;
  final String nakshatra;
  final bool manglik;
  final String familyType;
  final String education;

  // Additional fields for details screen
  final String diet; // "Vegetarian", "Non-Vegetarian", "Jain", "Vegan"
  final String smoking; // "No", "Yes", "Occasionally"
  final String drinking; // "No", "Yes", "Occasionally"
  final String fatherName;
  final String motherName;
  final String siblings; // e.g. "1 Brother", "2 Sisters", "None"
  final List<String> hobbies;
  final bool isVerified;
  final String workLocation;
  final String nativePlace;
  final String familyStatus;
  final String birthDate;
  final DateTime? dob;

  // Complete Edit Profile Fields
  final String weight;
  final String motherTongue;
  final String complexion;
  final String bodyType;
  final String specialCase;
  final String drinkingSmoking;
  final String agriLand;
  final int children;
  final String phone;
  final String altPhone;
  final String email;

  // Location Fields
  final String district;
  final String taluka;
  final String village;
  final String pincode;
  final String workPlace;
  final String homePlace;

  // Educational & Professional Fields
  final String highestEdu;
  final String profession;
  final String university;
  final String organization;
  final String companyAddress;
  final String eduField;
  final String designation;

  // Horoscope & Religious Fields
  final String subCaste;
  final String placeOfBirth;
  final String birthTime;
  final String charan;
  final String gotra;
  final String gan;
  final String nadi;
  final String partnerPriority;

  // Family Fields
  final String fatherEdu; // Father's Occupation
  final String motherOcc; // Mother's Occupation
  final String familyValues;
  final String aboutFamily;
  final String brothers;
  final String sisters;
  final String marriedSister;
  final String maternalUncle;
  final String uncleName;
  final String unclePhone;
  final List<BrotherDetail> brothersDetails;
  final List<SisterDetail> sistersDetails;
  final List<UncleDetail> maternalUnclesDetails;
  final List<UncleDetail> unclesDetails;

  // Partner Preferences
  final String partnerMaritalStatus;
  final String partnerAgeRange;
  final String partnerComplexion;
  final String partnerHeight;
  final String partnerWeight;
  final String partnerDiet;
  final String partnerSmoking;
  final String partnerDrinking;
  final String partnerWorkingLocation;
  final String partnerIncome;
  final String partnerEducation;
  final String partnerProfession;
  final bool wantsWorkingPartner;

  String get income => annualIncome;

  factory MatrimonialProfile.empty() => MatrimonialProfile.fromJson({});

  MatrimonialProfile({
    required this.id,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.religion,
    required this.caste,
    required this.maritalStatus,
    required this.bloodGroup,
    required this.height,
    required this.qualification,
    required this.occupation,
    required this.annualIncome,
    required this.incomeValue,
    required this.city,
    required this.state,
    required this.country,
    required this.about,
    required this.photos,
    required this.isPremium,
    required this.premiumTier,
    required this.compatibilityScore,
    required this.compatibilityTags,
    required this.rashi,
    required this.nakshatra,
    required this.manglik,
    required this.familyType,
    required this.education,
    required this.diet,
    required this.smoking,
    required this.drinking,
    required this.fatherName,
    required this.motherName,
    required this.siblings,
    required this.hobbies,
    required this.isVerified,
    required this.workLocation,
    required this.nativePlace,
    required this.familyStatus,
    this.birthDate = '',
    this.dob,
    this.weight = '',
    this.motherTongue = '',
    this.complexion = '',
    this.bodyType = '',
    this.specialCase = '',
    this.drinkingSmoking = '',
    this.agriLand = '',
    this.children = 0,
    this.phone = '',
    this.altPhone = '',
    this.email = '',
    this.district = '',
    this.taluka = '',
    this.village = '',
    this.pincode = '',
    this.workPlace = '',
    this.homePlace = '',
    this.highestEdu = '',
    this.profession = '',
    this.university = '',
    this.organization = '',
    this.companyAddress = '',
    this.eduField = '',
    this.designation = '',
    this.subCaste = '',
    this.placeOfBirth = '',
    this.birthTime = '',
    this.charan = '',
    this.gotra = '',
    this.gan = '',
    this.nadi = '',
    this.partnerPriority = '',
    this.fatherEdu = '',
    this.motherOcc = '',
    this.familyValues = '',
    this.aboutFamily = '',
    this.brothers = '',
    this.sisters = '',
    this.marriedSister = '',
    this.maternalUncle = '',
    this.uncleName = '',
    this.unclePhone = '',
    this.brothersDetails = const [],
    this.sistersDetails = const [],
    this.maternalUnclesDetails = const [],
    this.unclesDetails = const [],
    this.partnerMaritalStatus = '',
    this.partnerAgeRange = '',
    this.partnerComplexion = '',
    this.partnerHeight = '',
    this.partnerWeight = '',
    this.partnerDiet = '',
    this.partnerSmoking = '',
    this.partnerDrinking = '',
    this.partnerWorkingLocation = '',
    this.partnerIncome = '',
    this.partnerEducation = '',
    this.partnerProfession = '',
    this.wantsWorkingPartner = false,
  });

  factory MatrimonialProfile.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value
            .where((e) => e != null)
            .map((e) => e.toString())
            .where((e) => e.trim().isNotEmpty)
            .toList();
      }

      return [];
    }

    // ============================================================
    // ID
    // ============================================================

    final String profileId =
    (json['id'] ??
        json['_id'] ??
        json['userId'] ??
        json['profileId'] ??
        '')
        .toString();

    // ============================================================
    // NESTED BACKEND OBJECTS
    // ============================================================

    final registration =
    json['userRegistration'] is Map
        ? Map<String, dynamic>.from(
      json['userRegistration'],
    )
        : <String, dynamic>{};

    final personal =
    json['personalDetail'] is Map
        ? Map<String, dynamic>.from(
      json['personalDetail'],
    )
        : <String, dynamic>{};

    final educationDetail =
    json['educationalDetail'] is Map
        ? Map<String, dynamic>.from(
      json['educationalDetail'],
    )
        : <String, dynamic>{};

    final family =
    json['familyDetails'] is Map
        ? Map<String, dynamic>.from(
      json['familyDetails'],
    )
        : <String, dynamic>{};

    final astrology =
    json['astrologyDetails'] is Map
        ? Map<String, dynamic>.from(
      json['astrologyDetails'],
    )
        : <String, dynamic>{};

    final documents =
    json['documentDetails'] is Map
        ? Map<String, dynamic>.from(
      json['documentDetails'],
    )
        : <String, dynamic>{};

    final partner =
    json['partnerDetail'] is Map
        ? Map<String, dynamic>.from(
      json['partnerDetail'],
    )
        : <String, dynamic>{};

    List<BrotherDetail> parseBrothers(dynamic raw) {
      if (raw is List) {
        return raw.map((item) {
          if (item is Map) {
            return BrotherDetail(
              name: (item['name'] ?? '').toString().trim(),
              occupation: (item['occupation'] ?? '').toString().trim(),
            );
          }
          return BrotherDetail(name: item.toString().trim(), occupation: '');
        }).where((b) => b.name.isNotEmpty || b.occupation.isNotEmpty).toList();
      }
      return [];
    }

    List<SisterDetail> parseSisters(dynamic raw) {
      if (raw is List) {
        return raw.map((item) {
          if (item is Map) {
            return SisterDetail(
              name: (item['name'] ?? '').toString().trim(),
              occupation: (item['occupation'] ?? '').toString().trim(),
              isMarried: item['isMarried'] == true || item['isMarried'] == 'true' || item['married'] == true,
              husbandName: (item['husbandName'] ?? '').toString().trim(),
              husbandProfession: (item['husbandProfession'] ?? '').toString().trim(),
            );
          }
          return SisterDetail(name: item.toString().trim(), occupation: '');
        }).where((s) => s.name.isNotEmpty || s.occupation.isNotEmpty).toList();
      }
      return [];
    }

    List<UncleDetail> parseUncles(dynamic raw) {
      if (raw is List) {
        return raw.map((item) {
          if (item is Map) {
            return UncleDetail(
              name: (item['name'] ?? '').toString().trim(),
              occupation: (item['occupation'] ?? item['profession'] ?? '').toString().trim(),
            );
          }
          return UncleDetail(name: item.toString().trim(), occupation: '');
        }).where((u) => u.name.isNotEmpty || u.occupation.isNotEmpty).toList();
      }
      return [];
    }

    final parsedBrothersDetails = parseBrothers(json['brothersDetails'] ?? family['brothersDetails']);
    final parsedSistersDetails = parseSisters(json['sistersDetails'] ?? family['sistersDetails']);
    var parsedMaternalUncles = parseUncles(json['maternalUnclesDetails'] ?? family['maternalUnclesDetails']);
    final maternalName = (json['maternalUncle'] ?? json['maternalUncleName'] ?? family['maternalUncleName'] ?? '').toString().trim();
    if (parsedMaternalUncles.isEmpty && maternalName.isNotEmpty && maternalName.toLowerCase() != 'not specified') {
      parsedMaternalUncles = [UncleDetail(name: maternalName, occupation: '')];
    }

    var parsedUncles = parseUncles(json['unclesDetails'] ?? family['unclesDetails']);
    final paternalName = (json['uncleName'] ?? family['uncleName'] ?? '').toString().trim();
    if (parsedUncles.isEmpty && paternalName.isNotEmpty && paternalName.toLowerCase() != 'not specified') {
      parsedUncles = [UncleDetail(name: paternalName, occupation: '')];
    }

    // ============================================================
    // NAME
    // ============================================================

    final String name =
    (json['fullName'] ??
        json['name'] ??
        registration['fullName'] ??
        '')
        .toString();

    // ============================================================
    // PHOTOS
    // ============================================================

    List<String> photosList =
    parseStringList(
      json['photos'],
    );

    if (photosList.isEmpty) {
      photosList =
          parseStringList(
            documents['photos'],
          );
    }

    // Remove empty values and dummy unsplash URLs
    photosList = photosList
        .where((photo) => photo.trim().isNotEmpty && !photo.toLowerCase().contains('unsplash.com'))
        .toList();

    // ============================================================
    // AGE
    // ============================================================

    final dynamic ageValue =
        json['age'] ??
            personal['age'];

    final int parsedAge =
    ageValue is int
        ? ageValue
        : int.tryParse(
      ageValue?.toString() ?? '',
    ) ??
        0;

    // ============================================================
    // INCOME
    // ============================================================

    final dynamic incomeValueRaw =
        json['incomeValue'] ??
            json['income'] ??
            json['annualIncome'] ??
            educationDetail['annualIncome'];

    final double parsedIncome =
    incomeValueRaw is num
        ? incomeValueRaw.toDouble()
        : double.tryParse(
      incomeValueRaw?.toString() ?? '',
    ) ??
        0.0;

    final String incomeText =
    (json['annualIncome'] ??
        json['income'] ??
        educationDetail['annualIncome'] ??
        'Not Specified')
        .toString();

    // ============================================================
    // HOBBIES
    // ============================================================

    final hobbiesList =
    parseStringList(
      json['hobbies'] ??
          personal['hobbies'],
    );

    // ============================================================
    // SIBLINGS
    // ============================================================

    final int brothers =
        int.tryParse(
          family['brothers']?.toString() ?? '0',
        ) ??
            0;

    final int sisters =
        int.tryParse(
          family['sisters']?.toString() ?? '0',
        ) ??
            0;

    final String siblingsText =
    (json['siblings'] ??
        (brothers + sisters == 0
            ? 'None'
            : '${brothers + sisters} Siblings'))
        .toString();

    // ============================================================
    // DATE OF BIRTH
    // ============================================================

    final dynamic rawDob = json['birthDate'] ??
        json['dob'] ??
        json['dateOfBirth'] ??
        registration['dateOfBirth'] ??
        registration['dob'] ??
        registration['birthDate'] ??
        personal['dateOfBirth'] ??
        personal['dob'];

    final String parsedBirthDate = formatDobString(rawDob);
    final DateTime? parsedDob = parseDobDateTime(rawDob);

    // ============================================================
    // RETURN PROFILE
    // ============================================================

    return MatrimonialProfile(
      id: profileId,

      fullName: name,

      age: parsedAge,

      gender:
      (json['gender'] ??
          personal['gender'] ??
          '')
          .toString(),

      religion:
      (json['religion'] ??
          astrology['religion'] ??
          '')
          .toString(),

      caste:
      (json['caste'] ??
          astrology['caste'] ??
          '')
          .toString(),

      maritalStatus:
      (json['maritalStatus'] ??
          personal['maritalStatus'] ??
          '')
          .toString(),

      bloodGroup:
      (json['bloodGroup'] ??
          personal['bloodGroup'] ??
          '')
          .toString(),

      height:
      (json['height'] ??
          personal['height'] ??
          '')
          .toString(),

      qualification:
      (json['qualification'] ??
          json['education'] ??
          educationDetail['highestEducation'] ??
          educationDetail['universityCollege'] ??
          '')
          .toString(),

      occupation:
      (json['occupation'] ??
          json['profession'] ??
          educationDetail['profession'] ??
          '')
          .toString(),

      annualIncome: incomeText,

      incomeValue: parsedIncome,

      city:
      (json['city'] ??
          registration['city'] ??
          registration['district'] ??
          '')
          .toString(),

      state:
      (json['state'] ??
          registration['state'] ??
          '')
          .toString(),

      country:
      (json['country'] ??
          registration['country'] ??
          '')
          .toString(),

      about:
      (json['about'] ??
          json['aboutMe'] ??
          personal['descriptionAboutSelf'] ??
          '')
          .toString(),

      photos: photosList,

      isPremium:
      json['isPremium'] == true,

      premiumTier:
      (json['premiumTier'] ?? 'Free')
          .toString(),

      compatibilityScore:
      json['compatibilityScore'] is int
          ? json['compatibilityScore']
          : int.tryParse(
        json['compatibilityScore']
            ?.toString() ??
            '',
      ) ??
          0,

      compatibilityTags:
      parseStringList(
        json['compatibilityTags'],
      ),

      rashi:
      (json['rashi'] ??
          astrology['rashi'] ??
          '')
          .toString(),

      nakshatra:
      (json['nakshatra'] ??
          astrology['nakshatra'] ??
          '')
          .toString(),

      manglik:
      json['manglik'] == true ||
          astrology['isManglik'] == true,

      familyType:
      (json['familyType'] ??
          family['familyType'] ??
          '')
          .toString(),

      education:
      (json['education'] ??
          json['qualification'] ??
          educationDetail['highestEducation'] ??
          '')
          .toString(),

      diet:
      (json['diet'] ??
          personal['diet'] ??
          '')
          .toString(),

      smoking:
      (json['smoking'] ?? '')
          .toString(),

      drinking:
      (json['drinking'] ?? '')
          .toString(),

      fatherName:
      (json['fatherName'] ??
          family['fatherName'] ??
          '')
          .toString(),

      motherName:
      (json['motherName'] ??
          family['motherName'] ??
          '')
          .toString(),

      siblings: siblingsText,

      hobbies: hobbiesList,

      isVerified:
      json['isVerified'] == true,

      workLocation:
      (json['workLocation'] ??
          json['city'] ??
          '')
          .toString(),

      nativePlace:
      (json['nativePlace'] ??
          family['nativePlace'] ??
          '')
          .toString(),

      familyStatus:
      (json['familyStatus'] ??
          json['familyValues'] ??
          family['familyStatus'] ??
          family['familyValues'] ??
          '')
          .toString(),

      birthDate: parsedBirthDate,

      dob: parsedDob,

      weight: (json['weight'] ?? personal['weight'] ?? '').toString(),
      motherTongue: (json['motherTongue'] ?? astrology['motherTongue'] ?? '').toString(),
      complexion: (json['complexion'] ?? json['complexionType'] ?? personal['complexionType'] ?? '').toString(),
      bodyType: (json['bodyType'] ?? personal['bodyType'] ?? '').toString(),
      specialCase: (json['specialCase'] ?? personal['specialCase'] ?? '').toString(),
      drinkingSmoking: (json['drinkingSmoking'] ?? (personal['smoking'] != null ? '${personal['smoking']} / ${personal['drinking'] ?? 'No'}' : '')).toString(),
      agriLand: (json['agriLand'] ?? json['agriculturalLandAcres'] ?? personal['agriculturalLandAcres'] ?? '').toString(),
      children: int.tryParse((json['children'] ?? json['numberOfChildren'] ?? personal['numberOfChildren'] ?? '0').toString()) ?? 0,
      phone: (json['phone'] ?? json['phoneNumber'] ?? registration['phoneNumber'] ?? '').toString(),
      altPhone: (json['altPhone'] ?? json['alternativePhoneNumber'] ?? registration['alternativePhoneNumber'] ?? '').toString(),
      email: (json['email'] ?? registration['email'] ?? '').toString(),

      district: (json['district'] ?? registration['district'] ?? '').toString(),
      taluka: (json['taluka'] ?? registration['taluka'] ?? '').toString(),
      village: (json['village'] ?? registration['village'] ?? '').toString(),
      pincode: (json['pincode'] ?? registration['pincode'] ?? '').toString(),
      workPlace: (json['workPlace'] ?? json['workLocation'] ?? educationDetail['companyAddress'] ?? '').toString(),
      homePlace: (json['homePlace'] ?? registration['address'] ?? '').toString(),

      highestEdu: (json['highestEdu'] ?? json['highestEducation'] ?? educationDetail['highestEducation'] ?? '').toString(),
      profession: (json['profession'] ?? educationDetail['profession'] ?? '').toString(),
      university: (json['university'] ?? json['universityCollege'] ?? educationDetail['universityCollege'] ?? '').toString(),
      organization: (json['organization'] ?? json['organizationName'] ?? educationDetail['organizationName'] ?? '').toString(),
      companyAddress: (json['companyAddress'] ?? educationDetail['companyAddress'] ?? '').toString(),
      eduField: (json['eduField'] ?? json['educationField'] ?? educationDetail['educationField'] ?? '').toString(),
      designation: (json['designation'] ?? json['occupationPosition'] ?? educationDetail['occupationPosition'] ?? '').toString(),

      subCaste: (json['subCaste'] ?? json['subCast'] ?? astrology['subCast'] ?? astrology['subCaste'] ?? '').toString(),
      placeOfBirth: (json['placeOfBirth'] ?? astrology['placeOfBirth'] ?? '').toString(),
      birthTime: (json['birthTime'] ?? json['timeOfBirth'] ?? astrology['timeOfBirth'] ?? '').toString(),
      charan: (json['charan'] ?? astrology['charan'] ?? '').toString(),
      gotra: (json['gotra'] ?? astrology['gotra'] ?? '').toString(),
      gan: (json['gan'] ?? astrology['gan'] ?? '').toString(),
      nadi: (json['nadi'] ?? astrology['nadi'] ?? '').toString(),
      partnerPriority: (json['partnerPriority'] ?? json['importanceOfPatrika'] ?? astrology['importanceOfPatrika'] ?? '').toString(),

      fatherEdu: (json['fatherEdu'] ?? json['fatherOccupation'] ?? family['fatherOccupation'] ?? '').toString(),
      motherOcc: (json['motherOcc'] ?? json['motherOccupation'] ?? family['motherOccupation'] ?? '').toString(),
      familyValues: (json['familyValues'] ?? json['familyStatus'] ?? family['familyValues'] ?? family['familyStatus'] ?? '').toString(),
      aboutFamily: (json['aboutFamily'] ?? family['aboutFamily'] ?? '').toString(),
      brothers: (json['brothers'] ?? family['brothers'] ?? '').toString(),
      sisters: (json['sisters'] ?? family['sisters'] ?? '').toString(),
      marriedSister: (json['marriedSister'] ?? json['marriedSisters'] ?? family['marriedSisters'] ?? '').toString(),
      maternalUncle: maternalName,
      uncleName: paternalName,
      unclePhone: (json['unclePhone'] ?? json['maternalUnclePhone'] ?? family['unclePhone'] ?? family['maternalUnclePhone'] ?? '').toString(),
      brothersDetails: parsedBrothersDetails,
      sistersDetails: parsedSistersDetails,
      maternalUnclesDetails: parsedMaternalUncles,
      unclesDetails: parsedUncles,

      partnerMaritalStatus: (json['partnerMaritalStatus'] ?? partner['partnerMaritalStatus'] ?? '').toString(),
      partnerAgeRange: (json['partnerAgeRange'] ?? (partner['expectedAgeRange'] is Map ? '${partner['expectedAgeRange']['from'] ?? ''} - ${partner['expectedAgeRange']['to'] ?? ''}' : '')).toString(),
      partnerComplexion: (json['partnerComplexion'] ?? partner['partnerComplexionType'] ?? '').toString(),
      partnerHeight: (json['partnerHeight'] ?? partner['partnerHeight'] ?? '').toString(),
      partnerWeight: (json['partnerWeight'] ?? partner['partnerWeight'] ?? '').toString(),
      partnerDiet: (json['partnerDiet'] ?? partner['partnerDiet'] ?? '').toString(),
      partnerSmoking: (json['partnerSmoking'] ?? partner['partnerSmoking'] ?? '').toString(),
      partnerDrinking: (json['partnerDrinking'] ?? partner['partnerDrinking'] ?? '').toString(),
      partnerWorkingLocation: (json['partnerWorkingLocation'] ?? partner['partnerWorkingLocation'] ?? '').toString(),
      partnerIncome: (json['partnerIncome'] ?? partner['partnerIncome'] ?? '').toString(),
      partnerEducation: (json['partnerEducation'] ?? partner['partnerEducation'] ?? '').toString(),
      partnerProfession: (json['partnerProfession'] ?? partner['partnerProfession'] ?? '').toString(),
      wantsWorkingPartner: json['wantsWorkingPartner'] == true || partner['wantsWorkingPartner'] == true,
    );
  }

  factory MatrimonialProfile.fromProfileModel(ProfileModel p) {
    return MatrimonialProfile(
      id: p.profileId,
      fullName: p.fullName,
      age: p.age,
      gender: '',
      religion: p.religion,
      caste: p.caste,
      maritalStatus: p.maritalStatus,
      bloodGroup: '',
      height: p.height,
      qualification: p.highestEdu,
      occupation: p.occupation,
      annualIncome: p.income,
      incomeValue: 0.0,
      city: p.village,
      state: p.state,
      country: '',
      about: p.aboutMe,
      photos: p.photos,
      isPremium: false,
      premiumTier: 'Free',
      compatibilityScore: 0,
      compatibilityTags: const [],
      rashi: p.rashi,
      nakshatra: p.nakshatra,
      manglik: p.manglik.toLowerCase().contains('yes') || p.manglik == 'true',
      familyType: p.familyType,
      education: p.highestEdu,
      diet: p.diet,
      smoking: '',
      drinking: '',
      fatherName: p.fatherName,
      motherName: p.motherName,
      siblings: '${p.brothers} Brothers, ${p.sisters} Sisters',
      hobbies: p.hobbies,
      isVerified: false,
      workLocation: p.workPlace,
      nativePlace: p.homePlace,
      familyStatus: p.familyValues,
      birthDate: p.birthDate,
      weight: p.weight,
      motherTongue: p.motherTongue,
      complexion: p.complexion,
      bodyType: p.bodyType,
      specialCase: p.specialCase,
      drinkingSmoking: p.drinkingSmoking,
      agriLand: p.agriLand,
      children: p.children,
      phone: p.phone,
      altPhone: p.altPhone,
      email: p.email,
      district: '',
      taluka: '',
      village: p.village,
      pincode: p.pincode,
      workPlace: p.workPlace,
      homePlace: p.homePlace,
      highestEdu: p.highestEdu,
      profession: p.profession,
      university: p.university,
      organization: p.organization,
      companyAddress: p.companyAddress,
      eduField: p.eduField,
      designation: p.designation,
      subCaste: '',
      placeOfBirth: p.placeOfBirth,
      birthTime: p.birthTime,
      charan: p.charan,
      gotra: p.gotra,
      gan: p.gan,
      nadi: '',
      partnerPriority: p.partnerPriority,
      fatherEdu: p.fatherEdu,
      motherOcc: p.motherOcc,
      familyValues: p.familyValues,
      aboutFamily: '',
      brothers: p.brothers,
      sisters: p.sisters,
      marriedSister: p.marriedSister,
      maternalUncle: p.maternalUncle,
      uncleName: p.uncleName,
      unclePhone: p.unclePhone,
      brothersDetails: p.brothersDetails,
      sistersDetails: p.sistersDetails,
      maternalUnclesDetails: p.maternalUnclesDetails,
      unclesDetails: p.unclesDetails,
    );
  }

  MatrimonialProfile copyWith({
    String? id,
    String? fullName,
    int? age,
    String? gender,
    String? religion,
    String? caste,
    String? maritalStatus,
    String? bloodGroup,
    String? height,
    String? qualification,
    String? occupation,
    String? annualIncome,
    double? incomeValue,
    String? city,
    String? state,
    String? country,
    String? about,
    List<String>? photos,
    bool? isPremium,
    String? premiumTier,
    int? compatibilityScore,
    List<String>? compatibilityTags,
    String? rashi,
    String? nakshatra,
    bool? manglik,
    String? familyType,
    String? education,
    String? diet,
    String? smoking,
    String? drinking,
    String? fatherName,
    String? motherName,
    String? siblings,
    List<String>? hobbies,
    bool? isVerified,
    String? workLocation,
    String? nativePlace,
    String? familyStatus,
    String? birthDate,
    DateTime? dob,
    String? weight,
    String? motherTongue,
    String? complexion,
    String? bodyType,
    String? specialCase,
    String? drinkingSmoking,
    String? agriLand,
    int? children,
    String? phone,
    String? altPhone,
    String? email,
    String? district,
    String? taluka,
    String? village,
    String? pincode,
    String? workPlace,
    String? homePlace,
    String? highestEdu,
    String? profession,
    String? university,
    String? organization,
    String? companyAddress,
    String? eduField,
    String? designation,
    String? subCaste,
    String? placeOfBirth,
    String? birthTime,
    String? charan,
    String? gotra,
    String? gan,
    String? nadi,
    String? partnerPriority,
    String? fatherEdu,
    String? motherOcc,
    String? familyValues,
    String? aboutFamily,
    String? brothers,
    String? sisters,
    String? marriedSister,
    String? maternalUncle,
    String? uncleName,
    String? unclePhone,
    List<BrotherDetail>? brothersDetails,
    List<SisterDetail>? sistersDetails,
    List<UncleDetail>? maternalUnclesDetails,
    List<UncleDetail>? unclesDetails,
    String? partnerMaritalStatus,
    String? partnerAgeRange,
    String? partnerComplexion,
    String? partnerHeight,
    String? partnerWeight,
    String? partnerDiet,
    String? partnerSmoking,
    String? partnerDrinking,
    String? partnerWorkingLocation,
    String? partnerIncome,
    String? partnerEducation,
    String? partnerProfession,
    bool? wantsWorkingPartner,
  }) {
    return MatrimonialProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      height: height ?? this.height,
      qualification: qualification ?? this.qualification,
      occupation: occupation ?? this.occupation,
      annualIncome: annualIncome ?? this.annualIncome,
      incomeValue: incomeValue ?? this.incomeValue,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      about: about ?? this.about,
      photos: photos ?? this.photos,
      isPremium: isPremium ?? this.isPremium,
      premiumTier: premiumTier ?? this.premiumTier,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
      compatibilityTags: compatibilityTags ?? this.compatibilityTags,
      rashi: rashi ?? this.rashi,
      nakshatra: nakshatra ?? this.nakshatra,
      manglik: manglik ?? this.manglik,
      familyType: familyType ?? this.familyType,
      education: education ?? this.education,
      diet: diet ?? this.diet,
      smoking: smoking ?? this.smoking,
      drinking: drinking ?? this.drinking,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      siblings: siblings ?? this.siblings,
      hobbies: hobbies ?? this.hobbies,
      isVerified: isVerified ?? this.isVerified,
      workLocation: workLocation ?? this.workLocation,
      nativePlace: nativePlace ?? this.nativePlace,
      familyStatus: familyStatus ?? this.familyStatus,
      birthDate: birthDate ?? this.birthDate,
      dob: dob ?? this.dob,
      weight: weight ?? this.weight,
      motherTongue: motherTongue ?? this.motherTongue,
      complexion: complexion ?? this.complexion,
      bodyType: bodyType ?? this.bodyType,
      specialCase: specialCase ?? this.specialCase,
      drinkingSmoking: drinkingSmoking ?? this.drinkingSmoking,
      agriLand: agriLand ?? this.agriLand,
      children: children ?? this.children,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      district: district ?? this.district,
      taluka: taluka ?? this.taluka,
      village: village ?? this.village,
      pincode: pincode ?? this.pincode,
      workPlace: workPlace ?? this.workPlace,
      homePlace: homePlace ?? this.homePlace,
      highestEdu: highestEdu ?? this.highestEdu,
      profession: profession ?? this.profession,
      university: university ?? this.university,
      organization: organization ?? this.organization,
      companyAddress: companyAddress ?? this.companyAddress,
      eduField: eduField ?? this.eduField,
      designation: designation ?? this.designation,
      subCaste: subCaste ?? this.subCaste,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      birthTime: birthTime ?? this.birthTime,
      charan: charan ?? this.charan,
      gotra: gotra ?? this.gotra,
      gan: gan ?? this.gan,
      nadi: nadi ?? this.nadi,
      partnerPriority: partnerPriority ?? this.partnerPriority,
      fatherEdu: fatherEdu ?? this.fatherEdu,
      motherOcc: motherOcc ?? this.motherOcc,
      familyValues: familyValues ?? this.familyValues,
      aboutFamily: aboutFamily ?? this.aboutFamily,
      brothers: brothers ?? this.brothers,
      sisters: sisters ?? this.sisters,
      marriedSister: marriedSister ?? this.marriedSister,
      maternalUncle: maternalUncle ?? this.maternalUncle,
      uncleName: uncleName ?? this.uncleName,
      unclePhone: unclePhone ?? this.unclePhone,
      brothersDetails: brothersDetails ?? this.brothersDetails,
      sistersDetails: sistersDetails ?? this.sistersDetails,
      maternalUnclesDetails: maternalUnclesDetails ?? this.maternalUnclesDetails,
      unclesDetails: unclesDetails ?? this.unclesDetails,
      partnerMaritalStatus: partnerMaritalStatus ?? this.partnerMaritalStatus,
      partnerAgeRange: partnerAgeRange ?? this.partnerAgeRange,
      partnerComplexion: partnerComplexion ?? this.partnerComplexion,
      partnerHeight: partnerHeight ?? this.partnerHeight,
      partnerWeight: partnerWeight ?? this.partnerWeight,
      partnerDiet: partnerDiet ?? this.partnerDiet,
      partnerSmoking: partnerSmoking ?? this.partnerSmoking,
      partnerDrinking: partnerDrinking ?? this.partnerDrinking,
      partnerWorkingLocation: partnerWorkingLocation ?? this.partnerWorkingLocation,
      partnerIncome: partnerIncome ?? this.partnerIncome,
      partnerEducation: partnerEducation ?? this.partnerEducation,
      partnerProfession: partnerProfession ?? this.partnerProfession,
      wantsWorkingPartner: wantsWorkingPartner ?? this.wantsWorkingPartner,
    );
  }

  User toUser() {
    return User(
      id: id,
      fullName: fullName,
      age: age,
      dob: dob,
      gender: gender,
      religion: religion,
      caste: caste,
      maritalStatus: maritalStatus,
      bloodGroup: bloodGroup,
      address: "$city, $state, $country",
      hobbies: hobbies,
      rashi: rashi,
      nakshatra: nakshatra,
      manglik: manglik,
      qualification: qualification,
      occupation: occupation,
      annualIncome: annualIncome,
      country: country,
      state: state,
      city: city,
      languages: const [],
      fatherName: fatherName,
      motherName: motherName,
      siblings: 0,
      familyType: familyType,
      profileCompleted: true,
      isVerified: isVerified,
      isPremium: isPremium,
      role: 'user',
      aadharNumber: '',
      aadharCardUrl: '',
      photos: photos,
    );
  }
}
