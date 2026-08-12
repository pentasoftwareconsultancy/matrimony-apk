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

// Generate 50 realistic Indian matrimony profiles deterministically
final List<MatrimonialProfile> dummyProfiles = _generate50Profiles();

List<MatrimonialProfile> _generate50Profiles() {
  final List<MatrimonialProfile> list = [];

  final femaleNames = [
    'Aaradhya Sharma', 'Priyanka Patel', 'Sneha Reddy', 'Kavya Nair',
    'Simran Kaur', 'Fatima Siddiqui', 'Ananya Roy', 'Sneha Jain',
    'Ishita Joshi', 'Meera Iyer', 'Ritu Desai', 'Pooja Hegde',
    'Kriti Senon', 'Aditi Rao', 'Shruti Haasan', 'Tanvi Shah',
    'Neha Kakkar', 'Komal Pandey', 'Rhea Chakraborty', 'Alia Bhatt',
    'Kiara Advani', 'Disha Patani', 'Janhvi Kapoor', 'Sara Khan',
    'Anushka Sen'
  ];

  final maleNames = [
    'Kaushal Sharma', 'Rohan Deshmukh', 'Arjun Mehta', 'Jaspreet Singh',
    'Arman Khan', 'Neil Fernandes', 'Aniket Kulkarni', 'Nikhil Gowda',
    'Vikram Aditya', 'Siddharth Roy', 'Pranav Anand', 'Kabir Thapar',
    'Devendra Singh', 'Rishabh Pant', 'Manish Pandey', 'Abhishek Ray',
    'Aditya Birla', 'Karan Johar', 'Varun Dhawan', 'Ranbir Kapoor',
    'Sidharth Malhotra', 'Kartik Aaryan', 'Ayushmann Khurrana', 'Vicky Kaushal',
    'Ranveer Singh'
  ];

  final femalePhotos = [
    'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=500',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500',
    'https://images.unsplash.com/photo-1506919258185-6078bba55d2a?w=500',
    'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=500',
    'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=500',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=500',
    'https://images.unsplash.com/photo-1548142813-c348350df52b?w=500',
    'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=500',
  ];

  final malePhotos = [
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=500',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=500',
    'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=500',
    'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=500',
    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
    'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=500',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
  ];

  final religions = ['Hindu', 'Muslim', 'Sikh', 'Christian', 'Jain'];
  
  final castes = {
    'Hindu': ['Brahmin', 'Maratha', 'Patel', 'Kayastha', 'Vokkaliga', 'Iyer', 'Joshi'],
    'Muslim': ['Sunni Sheikh', 'Sunni Pathan', 'Shia Sayyid'],
    'Sikh': ['Jatt Sikh', 'Ramgarhia', 'Khatri Sikh'],
    'Christian': ['Roman Catholic', 'Protestant', 'Syrian Christian'],
    'Jain': ['Jain Digambar', 'Jain Shvetambar']
  };

  final cities = [
    {'name': 'Pune', 'state': 'Maharashtra'},
    {'name': 'Ahmedabad', 'state': 'Gujarat'},
    {'name': 'Hyderabad', 'state': 'Telangana'},
    {'name': 'Kochi', 'state': 'Kerala'},
    {'name': 'Chandigarh', 'state': 'Punjab'},
    {'name': 'Lucknow', 'state': 'Uttar Pradesh'},
    {'name': 'Kolkata', 'state': 'West Bengal'},
    {'name': 'Jaipur', 'state': 'Rajasthan'},
    {'name': 'Mumbai', 'state': 'Maharashtra'},
    {'name': 'Bengaluru', 'state': 'Karnataka'},
    {'name': 'Delhi', 'state': 'Delhi'},
    {'name': 'Goa', 'state': 'Goa'},
    {'name': 'Amritsar', 'state': 'Punjab'},
    {'name': 'Mysuru', 'state': 'Karnataka'},
  ];

  final occupations = [
    'Software Engineer', 'Doctor', 'Bank Manager', 'Architect', 'Chartered Accountant',
    'Lead Data Scientist', 'Business Owner', 'Hotel Manager', 'Hardware Chip Designer',
    'Automobile Engineer', 'Nurse', 'Researcher', 'HR Specialist', 'Graphic Designer'
  ];

  final qualifications = ['B.Tech', 'Doctorate', 'M.B.A', 'Master\'s', 'Bachelor\'s'];

  final rashiList = ['Mesh', 'Vrushabh', 'Mithun', 'Kark', 'Sinh', 'Kanya', 'Tula', 'Vrushchik', 'Dhanu', 'Makar', 'Kumbh', 'Meen'];
  final nakshatras = ['Ashwini', 'Rohini', 'Ardra', 'Pushya', 'Magha', 'Hasta', 'Chitra', 'Anuradha', 'Mula', 'Shatabhisha', 'Revati'];

  final hobbiesList = [
    ['Coding', 'Trekking', 'Classical Music'],
    ['Reading', 'Gardening', 'Cooking'],
    ['Painting', 'Traveling', 'Yoga'],
    ['Photography', 'Music', 'Fitness'],
    ['Cricket', 'Movies', 'Blogging']
  ];

  // Helper to generate 25 females first, then 25 males
  for (int i = 0; i < 50; i++) {
    final isFemale = i < 25;
    final gender = isFemale ? 'Female' : 'Male';
    final name = isFemale ? femaleNames[i % femaleNames.length] : maleNames[(i - 25) % maleNames.length];
    
    // Choose photos
    final photoList = isFemale ? femalePhotos : malePhotos;
    final p1 = photoList[i % photoList.length];
    final p2 = photoList[(i + 1) % photoList.length];
    final p3 = photoList[(i + 2) % photoList.length];

    final age = 22 + (i % 12); // ages 22 to 33
    final heightVal = 5.0 + ((i % 10) * 0.1); // 5'0" to 5'9"
    final heightStr = "${heightVal.toStringAsFixed(1).replaceFirst('.', '\'')}\"";
    
    final rel = religions[i % religions.length];
    final casteOpts = castes[rel] ?? ['General'];
    final caste = casteOpts[i % casteOpts.length];

    final loc = cities[i % cities.length];
    final occ = occupations[i % occupations.length];
    final qual = qualifications[i % qualifications.length];

    final double incomeLPA = 4.0 + (i % 22); // 4 to 25 LPA
    final incomeStr = "₹${incomeLPA.toInt()},00,000 LPA";

    final rashi = rashiList[i % rashiList.length];
    final nakshatra = nakshatras[i % nakshatras.length];

    final isPrem = i % 3 == 0;
    final tiers = ['Platinum', 'Gold', 'Diamond'];
    final premTier = isPrem ? tiers[i % tiers.length] : 'None';

    final score = 65 + (i % 31); // compatibility score 65% to 95%
    final manglik = i % 4 == 0;
    final familyType = i % 2 == 0 ? 'Nuclear' : 'Joint';

    final diet = i % 3 == 0 ? 'Vegetarian' : (i % 3 == 1 ? 'Non-Vegetarian' : 'Jain');

    list.add(MatrimonialProfile(
      id: 'p${i + 1}',
      fullName: name,
      age: age,
      gender: gender,
      religion: rel,
      caste: caste,
      maritalStatus: i % 5 == 0 ? 'Divorced' : 'Single',
      bloodGroup: i % 2 == 0 ? 'B+' : 'O+',
      height: heightStr,
      qualification: qual,
      occupation: occ,
      annualIncome: incomeStr,
      incomeValue: incomeLPA,
      city: loc['name']!,
      state: loc['state']!,
      country: 'India',
      about: 'I am a profile generated for testing matchmaking features. I value family values, mutual respect, and career alignment.',
      photos: [p1, p2, p3],
      isPremium: isPrem,
      premiumTier: premTier,
      compatibilityScore: score,
      compatibilityTags: i % 2 == 0 ? ['Same religion', 'Nearby city'] : ['Similar income', 'Hobbies match'],
      rashi: rashi,
      nakshatra: nakshatra,
      manglik: manglik,
      familyType: familyType,
      education: qual,
      diet: diet,
      smoking: i % 6 == 0 ? 'Yes' : 'No',
      drinking: i % 4 == 0 ? 'Occasionally' : 'No',
      fatherName: 'Late Ramesh ${name.split(' ').last}',
      motherName: 'Sujata ${name.split(' ').last}',
      siblings: i % 3 == 0 ? '1 Brother' : (i % 3 == 1 ? '1 Sister' : 'None'),
      hobbies: hobbiesList[i % hobbiesList.length],
      isVerified: i % 2 == 0,
      workLocation: "Tech Park, ${loc['name']}",
      nativePlace: loc['name']!,
      familyStatus: i % 2 == 0 ? 'Middle Class' : 'Upper Middle Class',
    ));
  }

  return list;
}
