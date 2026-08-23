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
    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
      return [];
    }

    final photosList = parseStringList(json['photos']);
    if (photosList.isEmpty) {
      photosList.add('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500');
    }

    return MatrimonialProfile(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      fullName: (json['fullName'] ?? 'User').toString(),
      age: json['age'] is int ? json['age'] : (int.tryParse(json['age']?.toString() ?? '') ?? 25),
      gender: (json['gender'] ?? 'Female').toString(),
      religion: (json['religion'] ?? 'Hindu').toString(),
      caste: (json['caste'] ?? 'General').toString(),
      maritalStatus: (json['maritalStatus'] ?? 'Single').toString(),
      bloodGroup: (json['bloodGroup'] ?? 'B+').toString(),
      height: (json['height'] ?? "5'4\"").toString(),
      qualification: (json['qualification'] ?? 'Graduate').toString(),
      occupation: (json['occupation'] ?? 'Professional').toString(),
      annualIncome: (json['annualIncome'] ?? '₹8,00,000 LPA').toString(),
      incomeValue: (json['incomeValue'] is num)
          ? (json['incomeValue'] as num).toDouble()
          : (double.tryParse(json['incomeValue']?.toString() ?? '') ?? 8.0),
      city: (json['city'] ?? 'Pune').toString(),
      state: (json['state'] ?? 'Maharashtra').toString(),
      country: (json['country'] ?? 'India').toString(),
      about: (json['about'] ?? 'Family-oriented person with modern values.').toString(),
      photos: photosList,
      isPremium: json['isPremium'] == true,
      premiumTier: (json['premiumTier'] ?? 'Free').toString(),
      compatibilityScore: json['compatibilityScore'] is int
          ? json['compatibilityScore']
          : (int.tryParse(json['compatibilityScore']?.toString() ?? '') ?? 85),
      compatibilityTags: parseStringList(json['compatibilityTags']).isEmpty
          ? const ['Same religion', 'Nearby city']
          : parseStringList(json['compatibilityTags']),
      rashi: (json['rashi'] ?? 'Mesh').toString(),
      nakshatra: (json['nakshatra'] ?? 'Ashwini').toString(),
      manglik: json['manglik'] == true,
      familyType: (json['familyType'] ?? 'Nuclear').toString(),
      education: (json['education'] ?? json['qualification'] ?? 'Graduate').toString(),
      diet: (json['diet'] ?? 'Vegetarian').toString(),
      smoking: (json['smoking'] ?? 'No').toString(),
      drinking: (json['drinking'] ?? 'No').toString(),
      fatherName: (json['fatherName'] ?? 'Ramesh Sharma').toString(),
      motherName: (json['motherName'] ?? 'Sunita Sharma').toString(),
      siblings: (json['siblings']?.toString() ?? '1 Brother'),
      hobbies: parseStringList(json['hobbies']).isEmpty
          ? const ['Reading', 'Music', 'Traveling']
          : parseStringList(json['hobbies']),
      isVerified: json['isVerified'] != false,
      workLocation: (json['workLocation'] ?? "${json['city'] ?? 'Pune'}, India").toString(),
      nativePlace: (json['nativePlace'] ?? (json['city'] ?? 'Pune')).toString(),
      familyStatus: (json['familyStatus'] ?? 'Upper Middle Class').toString(),
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
