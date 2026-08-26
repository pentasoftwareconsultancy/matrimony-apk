import '../../features/auth/domain/models/user.dart';

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

    // ============================================================
    // NAME
    // ============================================================

    final String name =
    (json['fullName'] ??
        json['name'] ??
        registration['fullName'] ??
        'User')
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

    // Remove empty values
    photosList = photosList
        .where((photo) => photo.trim().isNotEmpty)
        .toList();

    if (photosList.isEmpty) {
      photosList.add(
        'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
      );
    }

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
        25;

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
    // RETURN PROFILE
    // ============================================================

    return MatrimonialProfile(
      id: profileId,

      fullName: name,

      age: parsedAge,

      gender:
      (json['gender'] ??
          personal['gender'] ??
          'Female')
          .toString(),

      religion:
      (json['religion'] ??
          astrology['religion'] ??
          'Hindu')
          .toString(),

      caste:
      (json['caste'] ??
          astrology['caste'] ??
          'General')
          .toString(),

      maritalStatus:
      (json['maritalStatus'] ??
          personal['maritalStatus'] ??
          'Single')
          .toString(),

      bloodGroup:
      (json['bloodGroup'] ??
          personal['bloodGroup'] ??
          'Not Specified')
          .toString(),

      height:
      (json['height'] ??
          personal['height'] ??
          'Not Specified')
          .toString(),

      qualification:
      (json['qualification'] ??
          json['education'] ??
          educationDetail['highestEducation'] ??
          educationDetail['universityCollege'] ??
          'Not Specified')
          .toString(),

      occupation:
      (json['occupation'] ??
          json['profession'] ??
          educationDetail['profession'] ??
          'Not Specified')
          .toString(),

      annualIncome: incomeText,

      incomeValue: parsedIncome,

      city:
      (json['city'] ??
          registration['city'] ??
          registration['district'] ??
          'Pune')
          .toString(),

      state:
      (json['state'] ??
          registration['state'] ??
          'Maharashtra')
          .toString(),

      country:
      (json['country'] ??
          registration['country'] ??
          'India')
          .toString(),

      about:
      (json['about'] ??
          json['aboutMe'] ??
          personal['descriptionAboutSelf'] ??
          'Family-oriented person with modern values.')
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
          'Not Specified')
          .toString(),

      nakshatra:
      (json['nakshatra'] ??
          astrology['nakshatra'] ??
          'Not Specified')
          .toString(),

      manglik:
      json['manglik'] == true ||
          astrology['isManglik'] == true,

      familyType:
      (json['familyType'] ??
          family['familyType'] ??
          'Not Specified')
          .toString(),

      education:
      (json['education'] ??
          json['qualification'] ??
          educationDetail['highestEducation'] ??
          'Not Specified')
          .toString(),

      diet:
      (json['diet'] ??
          personal['diet'] ??
          'Not Specified')
          .toString(),

      smoking:
      (json['smoking'] ?? 'No')
          .toString(),

      drinking:
      (json['drinking'] ?? 'No')
          .toString(),

      fatherName:
      (json['fatherName'] ??
          family['fatherName'] ??
          'Not Specified')
          .toString(),

      motherName:
      (json['motherName'] ??
          family['motherName'] ??
          'Not Specified')
          .toString(),

      siblings: siblingsText,

      hobbies: hobbiesList,

      isVerified:
      json['isVerified'] != false,

      workLocation:
      (json['workLocation'] ??
          json['city'] ??
          'Not Specified')
          .toString(),

      nativePlace:
      (json['nativePlace'] ??
          family['nativePlace'] ??
          'Not Specified')
          .toString(),

      familyStatus:
      (json['familyStatus'] ??
          family['familyStatus'] ??
          'Not Specified')
          .toString(),
    );
  }

  User toUser() {
    return User(
      id: id,
      fullName: fullName,
      age: age,
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
      languages: const ['English', 'Hindi'],
      fatherName: fatherName,
      motherName: motherName,
      siblings: 1,
      familyType: familyType,
      profileCompleted: true,
      isVerified: isVerified,
      isPremium: isPremium,
      role: 'user',
      aadharNumber: '123456789012',
      aadharCardUrl: 'aadhar.pdf',
      photos: photos,
    );
  }
}

// Static mock array removed. All profiles loaded dynamically from backend API database.
final List<MatrimonialProfile> dummyProfiles = const [];
