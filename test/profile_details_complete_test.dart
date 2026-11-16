import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:matrimony_app/core/network/api_client.dart';
import 'package:matrimony_app/core/data/dummy_profiles.dart';
import 'package:matrimony_app/features/home/presentation/screens/profile_details_screen.dart';
import 'package:matrimony_app/features/profile/domain/models/profile_model.dart';

import 'package:matrimony_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:matrimony_app/features/auth/domain/models/user.dart';

class FakeAuthController extends StateNotifier<AuthState> implements AuthController {
  FakeAuthController(User user)
      : super(AuthState(isAuthenticated: true, user: user));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeApiClient extends Fake implements ApiClient {
  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return Response(
      requestOptions: RequestOptions(path: path),
      data: {'status': 'success', 'data': {}},
      statusCode: 200,
    );
  }

  @override
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    return Response(
      requestOptions: RequestOptions(path: path),
      data: {'status': 'success'},
      statusCode: 200,
    );
  }
}

void main() {
  group('Profile Details Field Mapping & Deserialization Tests', () {
    test('MatrimonialProfile parses complete MongoDB and Edit Profile payload', () {
      final mongoData = {
        '_id': 'user_123',
        'fullName': 'Rahul Sharma',
        'age': 28,
        'gender': 'Male',
        'religion': 'Hindu',
        'caste': 'Maratha',
        'subCaste': '96 Kuli',
        'maritalStatus': 'Never Married',
        'bloodGroup': 'O+',
        'height': '5 ft 10 in',
        'weight': '72 kg',
        'motherTongue': 'Marathi',
        'complexion': 'Fair',
        'bodyType': 'Athletic',
        'specialCase': 'No',
        'drinkingSmoking': 'No',
        'agriLand': '5 Acres',
        'children': 0,
        'phone': '9876543210',
        'altPhone': '9876543211',
        'email': 'rahul@test.com',
        'country': 'India',
        'state': 'Maharashtra',
        'city': 'Pune',
        'district': 'Pune',
        'taluka': 'Haveli',
        'village': 'Wagholi',
        'pincode': '412207',
        'workPlace': 'Hinjewadi, Pune',
        'homePlace': 'Wagholi, Pune',
        'nativePlace': 'Satara',
        'highestEdu': 'B.Tech Computer Science',
        'eduField': 'Engineering',
        'university': 'Pune University',
        'profession': 'Software Architect',
        'designation': 'Lead Engineer',
        'organization': 'Google',
        'companyAddress': 'Google Cloud Campus, Pune',
        'annualIncome': '35 LPA',
        'workLocation': 'Pune',
        'gotra': 'Kashyap',
        'rashi': 'Simha (Leo)',
        'nakshatra': 'Magha',
        'charan': '2',
        'gan': 'Deva',
        'nadi': 'Madhya',
        'manglik': false,
        'placeOfBirth': 'Satara',
        'birthTime': '10:30 AM',
        'partnerPriority': '✨ High',
        'fatherName': 'Dilip Sharma',
        'fatherEdu': 'Teacher',
        'motherName': 'Smita Sharma',
        'motherOcc': 'Homemaker',
        'familyType': 'Joint',
        'familyValues': 'Traditional',
        'aboutFamily': 'Well-settled, respected family',
        'unclePhone': '9876500000',
        'diet': 'Vegetarian',
        'smoking': 'No',
        'drinking': 'No',
        'hobbies': ['Reading', 'Cricket', 'Travelling'],
        'about': 'Passionate engineer looking for a life partner.',
        'brothersDetails': [
          {'name': 'Vikram Sharma', 'occupation': 'Doctor'},
          {'name': 'Rohan Sharma', 'occupation': 'Engineer'},
        ],
        'sistersDetails': [
          {
            'name': 'Pooja Sharma',
            'occupation': 'Architect',
            'isMarried': true,
            'husbandName': 'Amit Patil',
            'husbandProfession': 'Civil Engineer'
          }
        ],
        'maternalUnclesDetails': [
          {'name': 'Ramesh Shinde', 'profession': 'Advocate'},
          {'name': 'Suresh Shinde', 'profession': 'Professor'},
        ],
        'unclesDetails': [
          {'name': 'Mahesh Sharma', 'profession': 'Business'},
          {'name': 'Kailash Sharma', 'profession': 'Bank Manager'},
        ],
        'partnerMaritalStatus': 'Never Married',
        'partnerAgeRange': '24 - 28',
        'partnerComplexion': 'Fair',
        'partnerHeight': '5 ft 2 in - 5 ft 8 in',
        'partnerWeight': '50 - 65 kg',
        'partnerDiet': 'Vegetarian',
        'partnerSmoking': 'No',
        'partnerDrinking': 'No',
        'partnerWorkingLocation': 'Pune / Mumbai',
        'partnerIncome': '10+ LPA',
        'partnerEducation': 'Graduate / Post Graduate',
        'partnerProfession': 'IT / Corporate',
        'wantsWorkingPartner': true,
      };

      final profile = MatrimonialProfile.fromJson(mongoData);

      expect(profile.fullName, 'Rahul Sharma');
      expect(profile.subCaste, '96 Kuli');
      expect(profile.highestEdu, 'B.Tech Computer Science');
      expect(profile.profession, 'Software Architect');
      expect(profile.designation, 'Lead Engineer');
      expect(profile.organization, 'Google');
      expect(profile.nadi, 'Madhya');
      expect(profile.taluka, 'Haveli');
      expect(profile.partnerPriority, '✨ High');
      expect(profile.fatherEdu, 'Teacher');
      expect(profile.motherOcc, 'Homemaker');
      expect(profile.familyValues, 'Traditional');

      // Check ALL maternal uncles are present
      expect(profile.maternalUnclesDetails.length, 2);
      expect(profile.maternalUnclesDetails[0].name, 'Ramesh Shinde');
      expect(profile.maternalUnclesDetails[0].profession, 'Advocate');
      expect(profile.maternalUnclesDetails[1].name, 'Suresh Shinde');
      expect(profile.maternalUnclesDetails[1].profession, 'Professor');

      // Check ALL paternal uncles are present
      expect(profile.unclesDetails.length, 2);
      expect(profile.unclesDetails[0].name, 'Mahesh Sharma');
      expect(profile.unclesDetails[0].profession, 'Business');
      expect(profile.unclesDetails[1].name, 'Kailash Sharma');
      expect(profile.unclesDetails[1].profession, 'Bank Manager');

      // Check Brothers & Sisters
      expect(profile.brothersDetails.length, 2);
      expect(profile.sistersDetails.length, 1);
      expect(profile.sistersDetails[0].isMarried, isTrue);

      // Check Partner Preferences
      expect(profile.partnerMaritalStatus, 'Never Married');
      expect(profile.partnerAgeRange, '24 - 28');
      expect(profile.wantsWorkingPartner, isTrue);
    });

    test('MatrimonialProfile handles missing or empty fields with default empty values without throwing', () {
      final profile = MatrimonialProfile.empty();
      expect(profile.fullName, '');
      expect(profile.subCaste, '');
      expect(profile.maternalUnclesDetails, isEmpty);
      expect(profile.unclesDetails, isEmpty);
      expect(profile.brothersDetails, isEmpty);
      expect(profile.sistersDetails, isEmpty);
      expect(profile.photos, isEmpty);
    });
  });

  group('ProfileDetailsScreen Widget Rendering Tests', () {
    testWidgets('Renders complete profile fields including all uncles without throwing any exception',
        (tester) async {
      final profile = MatrimonialProfile.fromJson({
        'id': 'prof_test_1',
        'fullName': 'Priya Kulkarni',
        'age': 26,
        'gender': 'Female',
        'religion': 'Hindu',
        'caste': 'Brahmin',
        'maritalStatus': 'Never Married',
        'bloodGroup': 'B+',
        'height': '5 ft 5 in',
        'qualification': 'BE Computers',
        'occupation': 'Data Scientist',
        'annualIncome': '18 LPA',
        'incomeValue': 18,
        'city': 'Mumbai',
        'state': 'Maharashtra',
        'country': 'India',
        'about': 'Tech enthusiast and classical singer',
        'photos': <String>[], // Empty photos to test safe avatar rendering
        'isPremium': true,
        'premiumTier': 'Gold',
        'subCaste': 'Deshastha',
        'highestEdu': 'Master of Science',
        'eduField': 'Data Science',
        'university': 'Mumbai University',
        'profession': 'Senior Data Scientist',
        'designation': 'Tech Lead',
        'organization': 'Tech Corp',
        'companyAddress': 'BKC, Mumbai',
        'workLocation': 'Mumbai',
        'gotra': 'Vashistha',
        'rashi': 'Kanya (Virgo)',
        'nakshatra': 'Hasta',
        'charan': '1',
        'gan': 'Manushya',
        'nadi': 'Antya',
        'placeOfBirth': 'Nashik',
        'birthTime': '08:15 AM',
        'partnerPriority': '✨ High',
        'fatherName': 'Anil Kulkarni',
        'fatherEdu': 'Chartered Accountant',
        'motherName': 'Sunita Kulkarni',
        'motherOcc': 'Professor',
        'familyType': 'Nuclear',
        'familyValues': 'Moderate',
        'aboutFamily': 'Loving family based in Mumbai',
        'district': 'Mumbai Suburban',
        'taluka': 'Andheri',
        'village': 'Vile Parle',
        'homePlace': 'Vile Parle, Mumbai',
        'workPlace': 'BKC, Mumbai',
        'nativePlace': 'Nashik',
        'weight': '55 kg',
        'motherTongue': 'Marathi',
        'complexion': 'Fair',
        'bodyType': 'Slim',
        'specialCase': 'No',
        'drinkingSmoking': 'No',
        'agriLand': 'None',
        'children': 0,
        'maternalUnclesDetails': [
          {'name': 'Ganesh Joshi', 'profession': 'Civil Engineer'},
          {'name': 'Vijay Joshi', 'profession': 'Doctor'},
          {'name': 'Sunil Joshi', 'profession': 'Architect'},
        ],
        'unclesDetails': [
          {'name': 'Prakash Kulkarni', 'profession': 'Banker'},
          {'name': 'Ashok Kulkarni', 'profession': 'Businessman'},
        ],
        'brothersDetails': [
          {'name': 'Aditya Kulkarni', 'occupation': 'Software Engineer'},
        ],
        'sistersDetails': [
          {
            'name': 'Sneha Kulkarni',
            'occupation': 'Dentist',
            'isMarried': true,
            'husbandName': 'Dr. Rahul Deshmukh',
            'husbandProfession': 'Surgeon',
          },
        ],
        'partnerMaritalStatus': 'Never Married',
        'partnerAgeRange': '27 - 31',
        'partnerEducation': 'Engineer / MBA',
        'wantsWorkingPartner': true,
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(FakeApiClient()),
          ],
          child: MaterialApp(
            home: ProfileDetailsScreen(profile: profile),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify no crash on initial frame
      expect(tester.takeException(), isNull);

      // Verify header name and basic info
      expect(find.text('Priya Kulkarni'), findsNWidgets(2));
      expect(find.text('ABOUT ME'), findsOneWidget);
      expect(find.text('Tech enthusiast and classical singer'), findsOneWidget);

      // Verify Personal Details
      expect(find.text('PERSONAL DETAILS'), findsOneWidget);
      expect(find.text('FULL NAME'), findsOneWidget);
      expect(find.text('GENDER'), findsOneWidget);
      expect(find.text('HEIGHT'), findsOneWidget);
      expect(find.text('WEIGHT'), findsOneWidget);

      // Verify Education & Career
      expect(find.text('EDUCATION & CAREER'), findsOneWidget);
      expect(find.text('HIGHEST EDU'), findsOneWidget);
      expect(find.text('PROFESSION'), findsOneWidget);
      expect(find.text('Senior Data Scientist'), findsNWidgets(2));

      // Verify Religious & Horoscope
      expect(find.text('RELIGIOUS & HOROSCOPE'), findsOneWidget);
      expect(find.text('SUB-CASTE'), findsOneWidget);
      expect(find.text('Deshastha'), findsOneWidget);
      expect(find.text('PLACE OF BIRTH'), findsOneWidget);
      expect(find.text('Nashik'), findsNWidgets(2));

      // Verify Location Details
      expect(find.text('LOCATION DETAILS'), findsOneWidget);
      expect(find.text('DISTRICT'), findsOneWidget);
      expect(find.text('Mumbai Suburban'), findsOneWidget);
      expect(find.text('TALUKA'), findsOneWidget);
      expect(find.text('Andheri'), findsOneWidget);

      // Verify Family Details & ALL 3 Maternal Uncles
      expect(find.text('FAMILY DETAILS'), findsOneWidget);
      expect(find.text('MATERNAL UNCLE 1'), findsOneWidget);
      expect(find.text('Ganesh Joshi (Civil Engineer)'), findsOneWidget);
      expect(find.text('MATERNAL UNCLE 2'), findsOneWidget);
      expect(find.text('Vijay Joshi (Doctor)'), findsOneWidget);
      expect(find.text('MATERNAL UNCLE 3'), findsOneWidget);
      expect(find.text('Sunil Joshi (Architect)'), findsOneWidget);

      // Verify ALL 2 Paternal Uncles
      expect(find.text('PATERNAL UNCLE 1'), findsOneWidget);
      expect(find.text('Prakash Kulkarni (Banker)'), findsOneWidget);
      expect(find.text('PATERNAL UNCLE 2'), findsOneWidget);
      expect(find.text('Ashok Kulkarni (Businessman)'), findsOneWidget);

      // Verify Dynamic Brother and Sister
      expect(find.text('BROTHER 1'), findsOneWidget);
      expect(find.text('Aditya Kulkarni (Software Engineer)'), findsOneWidget);
      expect(find.text('SISTER 1'), findsOneWidget);

      // Verify Partner Preferences Section
      expect(find.text('PARTNER PREFERENCES'), findsOneWidget);
      expect(find.text('EXPECTED MARITAL STATUS'), findsOneWidget);
      expect(find.text('Never Married'), findsAtLeastNWidgets(1));

      // Verify bottom actions
      expect(find.text('Express Interest'), findsOneWidget);
      expect(find.text('Message'), findsOneWidget);
    });

    testWidgets('Renders Edit Profile button and contact details when viewing own profile',
        (tester) async {
      final ownProfile = MatrimonialProfile.fromJson({
        'id': 'my_profile_1',
        '_id': 'my_profile_1',
        'fullName': 'Rahul Sharma',
        'phone': '9876543210',
        'email': 'rahul@test.com',
        'maritalStatus': 'Never Married',
        'religion': 'Hindu',
      });

      final loggedInUser = User(
        id: 'my_profile_1',
        email: 'rahul@test.com',
        fullName: 'Rahul Sharma',
        profileCompleted: true,
        isVerified: true,
        isPremium: false,
        role: 'user',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            apiClientProvider.overrideWithValue(FakeApiClient()),
            authControllerProvider.overrideWith(
              (ref) => FakeAuthController(loggedInUser),
            ),
          ],
          child: MaterialApp(
            home: ProfileDetailsScreen(profile: ownProfile),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Check Edit Profile button is present for owner
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Express Interest'), findsNothing);
      expect(find.text('Message'), findsNothing);

      // Check contact details are rendered for owner
      expect(find.text('PHONE NUMBER'), findsOneWidget);
      expect(find.text('9876543210'), findsOneWidget);
      expect(find.text('EMAIL'), findsOneWidget);
      expect(find.text('rahul@test.com'), findsOneWidget);
    });
  });
}
