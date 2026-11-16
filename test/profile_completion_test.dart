import 'package:flutter_test/flutter_test.dart';
import 'package:matrimony_app/features/profile/domain/models/profile_model.dart';

ProfileModel createFullyCompletedProfile() {
  return const ProfileModel(
    profileId: 'USR001',
    fullName: 'Rahul Sharma',
    age: 28,
    aboutMe: 'Working professional looking for a life partner with shared values.',
    tag: 'ACTIVE',
    photos: ['https://res.cloudinary.com/demo/image/upload/user_1.jpg'],
    birthDate: '15/05/1996',
    workPlace: 'Pune',
    homePlace: 'Mumbai',
    maritalStatus: 'Never Married',
    income: '1500000',
    village: 'Haveli',
    state: 'Maharashtra',
    pincode: '411038',
    occupation: 'Software Engineer',
    children: 0,
    complexion: 'Wheatish',
    bodyType: 'Athletic',
    diet: 'Vegetarian',
    specialCase: 'No',
    drinkingSmoking: 'No',
    motherTongue: 'Marathi',
    phone: '9876543210',
    altPhone: '',
    email: 'rahul.sharma@example.com',
    hobbies: ['Reading', 'Travelling'],
    religion: 'Hindu',
    agriLand: '2 Acres',
    weight: '70 kg',
    height: "5'10\"",
    caste: 'Maratha',
    highestEdu: 'B.Tech Computer Science',
    profession: 'Software Engineer',
    university: 'Pune University',
    organization: 'Tech Corp India',
    companyAddress: 'Hinjawadi, Pune',
    eduField: 'Engineering',
    designation: 'Senior Developer',
    birthTime: '10:30 AM',
    rashi: 'Simha (Leo)',
    charan: '2',
    nakshatra: 'Magha',
    placeOfBirth: 'Pune',
    gotra: 'Kashyap',
    manglik: 'No',
    gan: 'Deva',
    partnerPriority: 'High',
    fatherName: 'Dilip Sharma',
    motherName: 'Smita Sharma',
    brothers: '1',
    brothersDetails: [
      BrotherDetail(name: 'Amit Sharma', occupation: 'Civil Engineer'),
    ],
    maternalUncle: 'Mahesh Patil',
    maternalUnclesDetails: [
      UncleDetail(name: 'Mahesh Patil', occupation: 'Doctor'),
    ],
    unclePhone: '9822012345',
    fatherEdu: 'Retired Officer',
    motherOcc: 'Teacher',
    sisters: '1',
    sistersDetails: [
      SisterDetail(
        name: 'Pooja Sharma',
        occupation: 'Architect',
        isMarried: true,
        husbandName: 'Vikram',
        husbandProfession: 'Lawyer',
      ),
    ],
    familyType: 'Nuclear',
    familyValues: 'Moderate',
    marriedSister: '1',
    uncleName: 'Suresh Sharma',
    unclesDetails: [
      UncleDetail(name: 'Suresh Sharma', occupation: 'Business'),
    ],
    documents: [],
  );
}

void main() {
  group('Profile Completion Percentage Tests', () {
    test('Empty profile returns 0.0%', () {
      final empty = ProfileModel.empty();
      expect(empty.calculateCompletionPercentage(), 0.0);
    });

    test('Profile with empty strings, whitespace, and Not Specified returns 0.0%', () {
      final notSpecifiedProfile = ProfileModel.empty().copyWith(
        fullName: '   ',
        aboutMe: 'Not Specified',
        workPlace: 'not specified',
        homePlace: 'Not-Specified',
        maritalStatus: 'not_specified',
        income: 'N/A',
        village: 'NA',
        state: 'None',
        pincode: 'null',
        occupation: 'undefined',
        complexion: 'Not Specified',
        bodyType: 'Not Specified',
        diet: 'Not Specified',
        specialCase: 'Not Specified',
        drinkingSmoking: 'Not Specified',
        motherTongue: 'Not Specified',
        phone: 'Not Specified',
        email: 'Not Specified',
        religion: 'Not Specified',
        caste: 'Not Specified',
        fatherName: 'Not Specified',
        motherName: 'Not Specified',
      );
      expect(notSpecifiedProfile.calculateCompletionPercentage(), 0.0);
    });

    test('Placeholder bio and default backend bio do not count as completed', () {
      final profileWithDefaults = ProfileModel.empty().copyWith(
        aboutMe: 'Tap to add about me description...',
      );
      expect(profileWithDefaults.calculateCompletionPercentage(), 0.0);

      final profileWithBackendBio = ProfileModel.empty().copyWith(
        aboutMe: 'Family-oriented person with modern values.',
      );
      expect(profileWithBackendBio.calculateCompletionPercentage(), 0.0);
    });

    test('Dummy unsplash photos do not count as completed', () {
      final profileWithDummyPhoto = ProfileModel.empty().copyWith(
        photos: ['https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=500'],
      );
      expect(profileWithDummyPhoto.calculateCompletionPercentage(), 0.0);
    });

    test('Fully completed profile returns exactly 100.0%', () {
      final fullProfile = createFullyCompletedProfile();
      expect(fullProfile.calculateCompletionPercentage(), 100.0);
    });

    test('Divorced user with children completed returns 100.0%', () {
      final fullProfile = createFullyCompletedProfile().copyWith(
        maritalStatus: 'Divorced',
        children: 1,
      );
      expect(fullProfile.calculateCompletionPercentage(), 100.0);
    });

    test('Profile with ~50% filled fields produces dynamic proportional percentage', () {
      // Fill half the fields
      final halfProfile = ProfileModel.empty().copyWith(
        fullName: 'Rahul Sharma',
        age: 28,
        birthDate: '15/05/1996',
        workPlace: 'Pune',
        homePlace: 'Mumbai',
        maritalStatus: 'Never Married',
        income: '1200000',
        village: 'Haveli',
        state: 'Maharashtra',
        pincode: '411038',
        occupation: 'Software Engineer',
        complexion: 'Wheatish',
        bodyType: 'Athletic',
        diet: 'Vegetarian',
        specialCase: 'No',
        drinkingSmoking: 'No',
        motherTongue: 'Marathi',
        phone: '9876543210',
        email: 'rahul@example.com',
        religion: 'Hindu',
        caste: 'Maratha',
        fatherName: 'Dilip',
        motherName: 'Smita',
        familyType: 'Nuclear',
        familyValues: 'Moderate',
        highestEdu: 'B.Tech',
        profession: 'Software Engineer',
      );

      final pct = halfProfile.calculateCompletionPercentage();
      expect(pct, greaterThan(40.0));
      expect(pct, lessThan(60.0));
    });

    test('Updating a field from valid to empty decreases percentage', () {
      final fullProfile = createFullyCompletedProfile();
      expect(fullProfile.calculateCompletionPercentage(), 100.0);

      final modified = fullProfile.copyWith(
        occupation: '',
        highestEdu: '',
        caste: 'Not Specified',
      );
      expect(modified.calculateCompletionPercentage(), lessThan(100.0));
      expect(modified.calculateCompletionPercentage(), greaterThan(90.0));
    });

    test('Updating a field from empty to valid increases percentage', () {
      final initial = ProfileModel.empty().copyWith(
        fullName: 'Sarthak Shelke',
        age: 26,
        phone: '9876543210',
      );
      final initialScore = initial.calculateCompletionPercentage();

      final updated = initial.copyWith(
        workPlace: 'Pune',
        occupation: 'Engineer',
        highestEdu: 'B.E.',
      );
      final updatedScore = updated.calculateCompletionPercentage();

      expect(updatedScore, greaterThan(initialScore));
    });

    test('Different users with distinct data have distinct completion percentages', () {
      final userA = ProfileModel.empty().copyWith(
        fullName: 'User A',
        age: 25,
        phone: '9876543210',
        email: 'a@example.com',
        state: 'Maharashtra',
      );

      final userB = ProfileModel.empty().copyWith(
        fullName: 'User B',
        age: 30,
        phone: '9876543211',
        email: 'b@example.com',
        state: 'Gujarat',
        workPlace: 'Ahmedabad',
        occupation: 'Doctor',
        highestEdu: 'MBBS',
        fatherName: 'Ramesh',
        motherName: 'Sunita',
        religion: 'Hindu',
        caste: 'Patel',
        income: '2000000',
        maritalStatus: 'Never Married',
        diet: 'Vegetarian',
      );

      final scoreA = userA.calculateCompletionPercentage();
      final scoreB = userB.calculateCompletionPercentage();

      expect(scoreA, isNot(equals(scoreB)));
      expect(scoreB, greaterThan(scoreA));
    });

    test('Dynamic family uncle fields count as completed when name is provided', () {
      final withUncle = ProfileModel.empty().copyWith(
        maternalUnclesDetails: const [
          UncleDetail(name: 'Suresh Patil', occupation: 'Farmer'),
        ],
      );
      expect(withUncle.calculateCompletionPercentage(), greaterThan(0.0));

      final withUnspecifiedUncle = ProfileModel.empty().copyWith(
        maternalUnclesDetails: const [
          UncleDetail(name: 'Not Specified', occupation: ''),
        ],
      );
      expect(withUnspecifiedUncle.calculateCompletionPercentage(), 0.0);
    });

    test('isValidFieldString helper correctly identifies valid and invalid values', () {
      expect(ProfileModel.isValidFieldString(null), isFalse);
      expect(ProfileModel.isValidFieldString(''), isFalse);
      expect(ProfileModel.isValidFieldString('   '), isFalse);
      expect(ProfileModel.isValidFieldString('Not Specified'), isFalse);
      expect(ProfileModel.isValidFieldString('not specified'), isFalse);
      expect(ProfileModel.isValidFieldString('Not-Specified'), isFalse);
      expect(ProfileModel.isValidFieldString('not_specified'), isFalse);
      expect(ProfileModel.isValidFieldString('N/A'), isFalse);
      expect(ProfileModel.isValidFieldString('na'), isFalse);
      expect(ProfileModel.isValidFieldString('None'), isFalse);
      expect(ProfileModel.isValidFieldString('null'), isFalse);
      expect(ProfileModel.isValidFieldString('undefined'), isFalse);

      expect(ProfileModel.isValidFieldString('Pune'), isTrue);
      expect(ProfileModel.isValidFieldString('Software Engineer'), isTrue);
      expect(ProfileModel.isValidFieldString('1500000'), isTrue);
      expect(ProfileModel.isValidFieldString('Joint'), isTrue);
    });
  });
}
