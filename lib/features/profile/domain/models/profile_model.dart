import 'document_model.dart';

class ProfileModel {
  // Profile ID & Summary
  final String profileId;
  final String fullName;
  final int age;
  final String aboutMe;
  final String tag;
  final List<String> photos;

  // Personal Details
  final String birthDate;
  final String workPlace;
  final String homePlace;
  final String maritalStatus;
  final String income;
  final String village;
  final String state;
  final String pincode;
  final String occupation;
  final int children;
  final String complexion;
  final String bodyType;
  final String diet;
  final String specialCase;
  final String drinkingSmoking;
  final String motherTongue;
  final String phone;
  final String altPhone;
  final String email;
  final List<String> hobbies;
  final String religion;
  final String agriLand;
  final String weight;
  final String height;
  final String caste;

  // Educational Details
  final String highestEdu;
  final String profession;
  final String university;
  final String organization;
  final String companyAddress;
  final String eduField;
  final String designation;

  // Horoscope
  final String birthTime;
  final String rashi;
  final String charan;
  final String nakshatra;
  final String placeOfBirth;
  final String gotra;
  final String manglik;
  final String gan;
  final String partnerPriority;

  // Family Details
  final String fatherName;
  final String motherName;
  final String brothers;
  final String maternalUncle;
  final String unclePhone;
  final String fatherEdu;
  final String motherOcc;
  final String sisters;
  final String familyType;
  final String familyValues;
  final String marriedSister;
  final String uncleName;

  // Documents
  final List<DocumentModel> documents;

  const ProfileModel({
    required this.profileId,
    required this.fullName,
    required this.age,
    required this.aboutMe,
    required this.tag,
    required this.photos,
    required this.birthDate,
    required this.workPlace,
    required this.homePlace,
    required this.maritalStatus,
    required this.income,
    required this.village,
    required this.state,
    required this.pincode,
    required this.occupation,
    required this.children,
    required this.complexion,
    required this.bodyType,
    required this.diet,
    required this.specialCase,
    required this.drinkingSmoking,
    required this.motherTongue,
    required this.phone,
    required this.altPhone,
    required this.email,
    required this.hobbies,
    required this.religion,
    required this.agriLand,
    required this.weight,
    required this.height,
    required this.caste,
    required this.highestEdu,
    required this.profession,
    required this.university,
    required this.organization,
    required this.companyAddress,
    required this.eduField,
    required this.designation,
    required this.birthTime,
    required this.rashi,
    required this.charan,
    required this.nakshatra,
    required this.placeOfBirth,
    required this.gotra,
    required this.manglik,
    required this.gan,
    required this.partnerPriority,
    required this.fatherName,
    required this.motherName,
    required this.brothers,
    required this.maternalUncle,
    required this.unclePhone,
    required this.fatherEdu,
    required this.motherOcc,
    required this.sisters,
    required this.familyType,
    required this.familyValues,
    required this.marriedSister,
    required this.uncleName,
    required this.documents,
  });

  /// Reference initial data matching the exact user seed specs
  factory ProfileModel.referenceInitial() {
    return const ProfileModel(
      profileId: 'HK65425',
      fullName: 'Hritik Kulkarni',
      age: 27,
      aboutMe:
          'Born into a close-knit joint family from Jaipur, I value our Marwari traditions and seek a partner who respects cultural roots. As a Chartered Accountant by profession, I balance work with temple visits and family time. An adventurous soul who’s as...',
      tag: 'MODIFYING',
      photos: [
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=500',
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500',
        'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=500',
        'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=500',
      ],
      birthDate: '13/02/1998',
      workPlace: 'Chennai, Tamil Nadu',
      homePlace: 'Kochi, Kerala',
      maritalStatus: 'Divorced',
      income: '₹7,20,000 LPA',
      village: 'Manchar',
      state: 'Kerala',
      pincode: '23456',
      occupation: 'Software Engineer',
      children: 0,
      complexion: 'Fair',
      bodyType: 'Slim',
      diet: 'Vegan',
      specialCase: 'No',
      drinkingSmoking: 'No',
      motherTongue: 'Marathi',
      phone: '1234567890',
      altPhone: '0987654321',
      email: 'Kavya123@gmail.com',
      hobbies: ['Painting', 'cooking', 'dancing'],
      religion: 'Kunbi, Maratha',
      agriLand: '5 Acres',
      weight: '60 kg',
      height: '5.11 ft',
      caste: 'Hindu',
      highestEdu: 'MBA',
      profession: 'Software Engineer',
      university: 'SBVB Institute Research',
      organization: 'Smart Matrix Pvt Ltd',
      companyAddress: 'No',
      eduField: 'IT',
      designation: 'Senior Software Eng',
      birthTime: '4:30 pm',
      rashi: 'Swati Nair',
      charan: '2',
      nakshatra: 'Megha',
      placeOfBirth: 'Manchar',
      gotra: 'Bhardwaj',
      manglik: 'No',
      gan: 'Rakshasa',
      partnerPriority: 'High',
      fatherName: 'Vishwanath Nair',
      motherName: 'Swati Nair',
      brothers: 'No',
      maternalUncle: 'Anil Kesur',
      unclePhone: '1234567890',
      fatherEdu: 'IT',
      motherOcc: 'Housewife',
      sisters: '2',
      familyType: 'Nuclear',
      familyValues: 'Moderate',
      marriedSister: '1',
      uncleName: 'Rupesh Nair',
      documents: [
        DocumentModel(
          id: 'doc_aadhaar',
          title: 'Aadhaar Card',
          type: 'aadhaar',
          status: 'verified',
        ),
        DocumentModel(
          id: 'doc_pan',
          title: 'Pan Card',
          type: 'pan',
          status: 'verified',
        ),
        DocumentModel(
          id: 'doc_photos',
          title: 'Profile Photos',
          type: 'photos',
          status: 'verified',
        ),
      ],
    );
  }

  ProfileModel copyWith({
    String? profileId,
    String? fullName,
    int? age,
    String? aboutMe,
    String? tag,
    List<String>? photos,
    String? birthDate,
    String? workPlace,
    String? homePlace,
    String? maritalStatus,
    String? income,
    String? village,
    String? state,
    String? pincode,
    String? occupation,
    int? children,
    String? complexion,
    String? bodyType,
    String? diet,
    String? specialCase,
    String? drinkingSmoking,
    String? motherTongue,
    String? phone,
    String? altPhone,
    String? email,
    List<String>? hobbies,
    String? religion,
    String? agriLand,
    String? weight,
    String? height,
    String? caste,
    String? highestEdu,
    String? profession,
    String? university,
    String? organization,
    String? companyAddress,
    String? eduField,
    String? designation,
    String? birthTime,
    String? rashi,
    String? charan,
    String? nakshatra,
    String? placeOfBirth,
    String? gotra,
    String? manglik,
    String? gan,
    String? partnerPriority,
    String? fatherName,
    String? motherName,
    String? brothers,
    String? maternalUncle,
    String? unclePhone,
    String? fatherEdu,
    String? motherOcc,
    String? sisters,
    String? familyType,
    String? familyValues,
    String? marriedSister,
    String? uncleName,
    List<DocumentModel>? documents,
  }) {
    return ProfileModel(
      profileId: profileId ?? this.profileId,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      aboutMe: aboutMe ?? this.aboutMe,
      tag: tag ?? this.tag,
      photos: photos ?? this.photos,
      birthDate: birthDate ?? this.birthDate,
      workPlace: workPlace ?? this.workPlace,
      homePlace: homePlace ?? this.homePlace,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      income: income ?? this.income,
      village: village ?? this.village,
      state: state ?? this.state,
      pincode: pincode ?? this.pincode,
      occupation: occupation ?? this.occupation,
      children: children ?? this.children,
      complexion: complexion ?? this.complexion,
      bodyType: bodyType ?? this.bodyType,
      diet: diet ?? this.diet,
      specialCase: specialCase ?? this.specialCase,
      drinkingSmoking: drinkingSmoking ?? this.drinkingSmoking,
      motherTongue: motherTongue ?? this.motherTongue,
      phone: phone ?? this.phone,
      altPhone: altPhone ?? this.altPhone,
      email: email ?? this.email,
      hobbies: hobbies ?? this.hobbies,
      religion: religion ?? this.religion,
      agriLand: agriLand ?? this.agriLand,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      caste: caste ?? this.caste,
      highestEdu: highestEdu ?? this.highestEdu,
      profession: profession ?? this.profession,
      university: university ?? this.university,
      organization: organization ?? this.organization,
      companyAddress: companyAddress ?? this.companyAddress,
      eduField: eduField ?? this.eduField,
      designation: designation ?? this.designation,
      birthTime: birthTime ?? this.birthTime,
      rashi: rashi ?? this.rashi,
      charan: charan ?? this.charan,
      nakshatra: nakshatra ?? this.nakshatra,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      gotra: gotra ?? this.gotra,
      manglik: manglik ?? this.manglik,
      gan: gan ?? this.gan,
      partnerPriority: partnerPriority ?? this.partnerPriority,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      brothers: brothers ?? this.brothers,
      maternalUncle: maternalUncle ?? this.maternalUncle,
      unclePhone: unclePhone ?? this.unclePhone,
      fatherEdu: fatherEdu ?? this.fatherEdu,
      motherOcc: motherOcc ?? this.motherOcc,
      sisters: sisters ?? this.sisters,
      familyType: familyType ?? this.familyType,
      familyValues: familyValues ?? this.familyValues,
      marriedSister: marriedSister ?? this.marriedSister,
      uncleName: uncleName ?? this.uncleName,
      documents: documents ?? this.documents,
    );
  }

  double calculateCompletionPercentage() {
    return 55.0; // Standard score matching reference design
  }

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'fullName': fullName,
      'age': age,
      'aboutMe': aboutMe,
      'tag': tag,
      'photos': photos,
      'birthDate': birthDate,
      'workPlace': workPlace,
      'homePlace': homePlace,
      'maritalStatus': maritalStatus,
      'income': income,
      'village': village,
      'state': state,
      'pincode': pincode,
      'occupation': occupation,
      'children': children,
      'complexion': complexion,
      'bodyType': bodyType,
      'diet': diet,
      'specialCase': specialCase,
      'drinkingSmoking': drinkingSmoking,
      'motherTongue': motherTongue,
      'phone': phone,
      'altPhone': altPhone,
      'email': email,
      'hobbies': hobbies,
      'religion': religion,
      'agriLand': agriLand,
      'weight': weight,
      'height': height,
      'caste': caste,
      'highestEdu': highestEdu,
      'profession': profession,
      'university': university,
      'organization': organization,
      'companyAddress': companyAddress,
      'eduField': eduField,
      'designation': designation,
      'birthTime': birthTime,
      'rashi': rashi,
      'charan': charan,
      'nakshatra': nakshatra,
      'placeOfBirth': placeOfBirth,
      'gotra': gotra,
      'manglik': manglik,
      'gan': gan,
      'partnerPriority': partnerPriority,
      'fatherName': fatherName,
      'motherName': motherName,
      'brothers': brothers,
      'maternalUncle': maternalUncle,
      'unclePhone': unclePhone,
      'fatherEdu': fatherEdu,
      'motherOcc': motherOcc,
      'sisters': sisters,
      'familyType': familyType,
      'familyValues': familyValues,
      'marriedSister': marriedSister,
      'uncleName': uncleName,
      'documents': documents.map((d) => d.toJson()).toList(),
    };
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      profileId: json['profileId'] as String? ?? 'HK65425',
      fullName: json['fullName'] as String? ?? 'Hritik Kulkarni',
      age: json['age'] as int? ?? 27,
      aboutMe: json['aboutMe'] as String? ?? '',
      tag: json['tag'] as String? ?? 'MODIFYING',
      photos: (json['photos'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      birthDate: json['birthDate'] as String? ?? '',
      workPlace: json['workPlace'] as String? ?? '',
      homePlace: json['homePlace'] as String? ?? '',
      maritalStatus: json['maritalStatus'] as String? ?? '',
      income: json['income'] as String? ?? '',
      village: json['village'] as String? ?? '',
      state: json['state'] as String? ?? '',
      pincode: json['pincode'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      children: json['children'] as int? ?? 0,
      complexion: json['complexion'] as String? ?? '',
      bodyType: json['bodyType'] as String? ?? '',
      diet: json['diet'] as String? ?? '',
      specialCase: json['specialCase'] as String? ?? '',
      drinkingSmoking: json['drinkingSmoking'] as String? ?? '',
      motherTongue: json['motherTongue'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      altPhone: json['altPhone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      hobbies: (json['hobbies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      religion: json['religion'] as String? ?? '',
      agriLand: json['agriLand'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      height: json['height'] as String? ?? '',
      caste: json['caste'] as String? ?? '',
      highestEdu: json['highestEdu'] as String? ?? '',
      profession: json['profession'] as String? ?? '',
      university: json['university'] as String? ?? '',
      organization: json['organization'] as String? ?? '',
      companyAddress: json['companyAddress'] as String? ?? '',
      eduField: json['eduField'] as String? ?? '',
      designation: json['designation'] as String? ?? '',
      birthTime: json['birthTime'] as String? ?? '',
      rashi: json['rashi'] as String? ?? '',
      charan: json['charan'] as String? ?? '',
      nakshatra: json['nakshatra'] as String? ?? '',
      placeOfBirth: json['placeOfBirth'] as String? ?? '',
      gotra: json['gotra'] as String? ?? '',
      manglik: json['manglik'] as String? ?? '',
      gan: json['gan'] as String? ?? '',
      partnerPriority: json['partnerPriority'] as String? ?? 'High',
      fatherName: json['fatherName'] as String? ?? '',
      motherName: json['motherName'] as String? ?? '',
      brothers: json['brothers'] as String? ?? '',
      maternalUncle: json['maternalUncle'] as String? ?? '',
      unclePhone: json['unclePhone'] as String? ?? '',
      fatherEdu: json['fatherEdu'] as String? ?? '',
      motherOcc: json['motherOcc'] as String? ?? '',
      sisters: json['sisters'] as String? ?? '',
      familyType: json['familyType'] as String? ?? '',
      familyValues: json['familyValues'] as String? ?? '',
      marriedSister: json['marriedSister'] as String? ?? '',
      uncleName: json['uncleName'] as String? ?? '',
      documents: (json['documents'] as List<dynamic>?)
              ?.map((d) => DocumentModel.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
