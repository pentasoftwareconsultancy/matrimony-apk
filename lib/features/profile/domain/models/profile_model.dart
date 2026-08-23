import 'document_model.dart';

String _asStr(dynamic val, [String fallback = '']) {
  if (val == null) return fallback;
  if (val is bool) return val ? 'Yes' : 'No';
  return val.toString();
}

int _asInt(dynamic val, [int fallback = 0]) {
  if (val == null) return fallback;
  if (val is int) return val;
  if (val is double) return val.toInt();
  if (val is String) return int.tryParse(val) ?? fallback;
  return fallback;
}

String _parseDob(dynamic dobVal, dynamic birthDateVal) {
  if (dobVal != null) {
    final str = dobVal.toString();
    if (str.contains('T')) {
      final dt = DateTime.tryParse(str);
      if (dt != null) {
        return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
      }
    }
    if (str.isNotEmpty) return str;
  }
  return _asStr(birthDateVal);
}

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

  factory ProfileModel.referenceInitial() {
    return ProfileModel.empty();
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
    int total = 10;
    int filled = 0;
    if (fullName.trim().isNotEmpty) filled++;
    if (age > 0) filled++;
    if (photos.isNotEmpty) filled++;
    if (maritalStatus.trim().isNotEmpty) filled++;
    if (occupation.trim().isNotEmpty || profession.trim().isNotEmpty) filled++;
    if (religion.trim().isNotEmpty) filled++;
    if (caste.trim().isNotEmpty) filled++;
    if (workPlace.trim().isNotEmpty || homePlace.trim().isNotEmpty || state.trim().isNotEmpty) filled++;
    if (highestEdu.trim().isNotEmpty) filled++;
    if (aboutMe.trim().isNotEmpty) filled++;

    final pct = (filled / total) * 100;
    return pct < 10.0 && fullName.isNotEmpty ? 40.0 : (pct == 0 ? 0.0 : pct);
  }

  factory ProfileModel.empty() {
    return const ProfileModel(
      profileId: '',
      fullName: '',
      age: 0,
      aboutMe: '',
      tag: '',
      photos: [],
      birthDate: '',
      workPlace: '',
      homePlace: '',
      maritalStatus: '',
      income: '',
      village: '',
      state: '',
      pincode: '',
      occupation: '',
      children: 0,
      complexion: '',
      bodyType: '',
      diet: '',
      specialCase: '',
      drinkingSmoking: '',
      motherTongue: '',
      phone: '',
      altPhone: '',
      email: '',
      hobbies: [],
      religion: '',
      agriLand: '',
      weight: '',
      height: '',
      caste: '',
      highestEdu: '',
      profession: '',
      university: '',
      organization: '',
      companyAddress: '',
      eduField: '',
      designation: '',
      birthTime: '',
      rashi: '',
      charan: '',
      nakshatra: '',
      placeOfBirth: '',
      gotra: '',
      manglik: '',
      gan: '',
      partnerPriority: '',
      fatherName: '',
      motherName: '',
      brothers: '',
      maternalUncle: '',
      unclePhone: '',
      fatherEdu: '',
      motherOcc: '',
      sisters: '',
      familyType: '',
      familyValues: '',
      marriedSister: '',
      uncleName: '',
      documents: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'fullName': fullName,
      'name': fullName,
      'age': age,
      'aboutMe': aboutMe,
      'about': aboutMe,
      'tag': tag,
      'photos': photos,
      'birthDate': birthDate,
      'dob': birthDate,
      'workPlace': workPlace,
      'workLocation': workPlace,
      'homePlace': homePlace,
      'nativePlace': homePlace,
      'maritalStatus': maritalStatus,
      'income': income,
      'annualIncome': income,
      'village': village,
      'state': state,
      'pincode': pincode,
      'occupation': occupation,
      'profession': profession.isNotEmpty ? profession : occupation,
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
      'qualification': highestEdu,
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
      'manglik': manglik.toLowerCase() == 'yes' || manglik.toLowerCase() == 'true',
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
      profileId: _asStr(json['profileId'] ?? json['id'] ?? json['_id']),
      fullName: _asStr(json['fullName'] ?? json['name']),
      age: _asInt(json['age']),
      aboutMe: _asStr(json['aboutMe'] ?? json['about']),
      tag: _asStr(json['tag'], 'MODIFYING'),
      photos: (json['photos'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      birthDate: _parseDob(json['dob'], json['birthDate']),
      workPlace: _asStr(json['workPlace'] ?? json['workLocation'] ?? json['city']),
      homePlace: _asStr(json['homePlace'] ?? json['nativePlace'] ?? json['address']),
      maritalStatus: _asStr(json['maritalStatus']),
      income: _asStr(json['income'] ?? json['annualIncome']),
      village: _asStr(json['village']),
      state: _asStr(json['state']),
      pincode: _asStr(json['pincode']),
      occupation: _asStr(json['occupation'] ?? json['profession']),
      children: _asInt(json['children']),
      complexion: _asStr(json['complexion']),
      bodyType: _asStr(json['bodyType']),
      diet: _asStr(json['diet']),
      specialCase: _asStr(json['specialCase']),
      drinkingSmoking: _asStr(json['drinkingSmoking']),
      motherTongue: _asStr(json['motherTongue']),
      phone: _asStr(json['phone']),
      altPhone: _asStr(json['altPhone']),
      email: _asStr(json['email']),
      hobbies: (json['hobbies'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      religion: _asStr(json['religion']),
      agriLand: _asStr(json['agriLand']),
      weight: _asStr(json['weight']),
      height: _asStr(json['height']),
      caste: _asStr(json['caste']),
      highestEdu: _asStr(json['highestEdu'] ?? json['qualification']),
      profession: _asStr(json['profession'] ?? json['occupation']),
      university: _asStr(json['university']),
      organization: _asStr(json['organization']),
      companyAddress: _asStr(json['companyAddress']),
      eduField: _asStr(json['eduField']),
      designation: _asStr(json['designation']),
      birthTime: _asStr(json['birthTime']),
      rashi: _asStr(json['rashi']),
      charan: _asStr(json['charan']),
      nakshatra: _asStr(json['nakshatra']),
      placeOfBirth: _asStr(json['placeOfBirth']),
      gotra: _asStr(json['gotra']),
      manglik: _asStr(json['manglik']),
      gan: _asStr(json['gan']),
      partnerPriority: _asStr(json['partnerPriority'], 'High'),
      fatherName: _asStr(json['fatherName']),
      motherName: _asStr(json['motherName']),
      brothers: _asStr(json['brothers']),
      maternalUncle: _asStr(json['maternalUncle']),
      unclePhone: _asStr(json['unclePhone']),
      fatherEdu: _asStr(json['fatherEdu']),
      motherOcc: _asStr(json['motherOcc']),
      sisters: _asStr(json['sisters']),
      familyType: _asStr(json['familyType']),
      familyValues: _asStr(json['familyValues']),
      marriedSister: _asStr(json['marriedSister']),
      uncleName: _asStr(json['uncleName']),
      documents: (json['documents'] as List<dynamic>?)
              ?.map((d) => DocumentModel.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
