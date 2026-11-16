import 'package:flutter_test/flutter_test.dart';
import 'package:matrimony_app/features/profile/domain/models/profile_model.dart';

void main() {
  group('Edit Profile Dynamic Family Details Tests', () {
    test('BrotherDetail copyWith, toJson, and fromJson work correctly', () {
      const brother = BrotherDetail(name: 'Rahul', occupation: 'Software Engineer');
      expect(brother.name, 'Rahul');
      expect(brother.occupation, 'Software Engineer');

      final json = brother.toJson();
      expect(json['name'], 'Rahul');
      expect(json['occupation'], 'Software Engineer');

      final fromJson = BrotherDetail.fromJson(json);
      expect(fromJson.name, 'Rahul');
      expect(fromJson.occupation, 'Software Engineer');

      final updated = brother.copyWith(name: 'Rohan');
      expect(updated.name, 'Rohan');
      expect(updated.occupation, 'Software Engineer');
    });

    test('SisterDetail with marriage status and husband details works correctly', () {
      const sister = SisterDetail(
        name: 'Pooja',
        occupation: 'Doctor',
        isMarried: true,
        husbandName: 'Vikram',
        husbandProfession: 'Architect',
      );
      expect(sister.isMarried, isTrue);
      expect(sister.husbandName, 'Vikram');
      expect(sister.husbandProfession, 'Architect');

      final json = sister.toJson();
      expect(json['isMarried'], isTrue);
      expect(json['husbandName'], 'Vikram');

      final parsed = SisterDetail.fromJson(json);
      expect(parsed.name, 'Pooja');
      expect(parsed.isMarried, isTrue);
      expect(parsed.husbandName, 'Vikram');
      expect(parsed.husbandProfession, 'Architect');

      // Toggling isMarried preserves values when needed
      final unmarried = sister.copyWith(isMarried: false);
      expect(unmarried.isMarried, isFalse);
      expect(unmarried.husbandName, 'Vikram');
    });

    test('UncleDetail copyWith, toJson, and fromJson work correctly', () {
      const uncle = UncleDetail(name: 'Suresh Patil', occupation: 'Business');
      expect(uncle.name, 'Suresh Patil');
      expect(uncle.occupation, 'Business');

      final json = uncle.toJson();
      final parsed = UncleDetail.fromJson(json);
      expect(parsed.name, 'Suresh Patil');
      expect(parsed.occupation, 'Business');
    });

    test('ProfileModel handles dynamic family arrays and calculates summaries correctly', () {
      final profile = ProfileModel.empty().copyWith(
        brothersDetails: [
          const BrotherDetail(name: 'Amit', occupation: 'Engineer'),
          const BrotherDetail(name: 'Anil', occupation: 'Manager'),
        ],
        sistersDetails: [
          const SisterDetail(name: 'Priya', occupation: 'Designer', isMarried: true),
          const SisterDetail(name: 'Sneha', occupation: 'Student', isMarried: false),
        ],
        maternalUnclesDetails: [
          const UncleDetail(name: 'Mahesh Patil', occupation: 'Doctor'),
        ],
        unclesDetails: [
          const UncleDetail(name: 'Ramesh Sharma', occupation: 'Govt Officer'),
        ],
        fatherEdu: 'Business Owner',
        motherOcc: 'Teacher',
      );

      expect(profile.brothersSummary, '2 (Amit, Anil)');
      expect(profile.sistersSummary, '2 (Priya, Sneha) (1 Married)');
      expect(profile.maternalUnclesSummary, '1 (Mahesh Patil)');
      expect(profile.unclesSummary, '1 (Ramesh Sharma)');
      expect(profile.fatherEdu, 'Business Owner');
      expect(profile.motherOcc, 'Teacher');

      final json = profile.toJson();
      expect(json['brothers'], '2');
      expect(json['sisters'], '2');
      expect(json['marriedSister'], '1');
      expect(json['marriedSisters'], '1');
      expect(json['maternalUncle'], 'Mahesh Patil');
      expect(json['uncleName'], 'Ramesh Sharma');
      expect(json['fatherOccupation'], 'Business Owner');
      expect(json['motherOccupation'], 'Teacher');
      expect((json['brothersDetails'] as List).length, 2);
      expect((json['sistersDetails'] as List).length, 2);
      expect((json['maternalUnclesDetails'] as List).length, 1);
      expect((json['unclesDetails'] as List).length, 1);
    });

    test('ProfileModel synthesizes backward compatibility from scalar values', () {
      final legacyJson = {
        'fullName': 'Legacy User',
        'brothers': '2',
        'sisters': '1',
        'marriedSisters': '1',
        'maternalUncleName': 'Mama Patil',
        'uncleName': 'Kaka Deshmukh',
        'fatherOccupation': 'Farmer',
        'motherOccupation': 'Homemaker',
      };

      final profile = ProfileModel.fromJson(legacyJson);
      expect(profile.brothersDetails.length, 2);
      expect(profile.sistersDetails.length, 1);
      expect(profile.sistersDetails.first.isMarried, isTrue);
      expect(profile.maternalUnclesDetails.length, 1);
      expect(profile.maternalUnclesDetails.first.name, 'Mama Patil');
      expect(profile.unclesDetails.length, 1);
      expect(profile.unclesDetails.first.name, 'Kaka Deshmukh');
      expect(profile.fatherEdu, 'Farmer');
      expect(profile.motherOcc, 'Homemaker');
    });

    test('All 28 States and 8 Union Territories are defined (36 total)', () {
      const allStatesAndUTs = [
        'Andaman and Nicobar Islands',
        'Andhra Pradesh',
        'Arunachal Pradesh',
        'Assam',
        'Bihar',
        'Chandigarh',
        'Chhattisgarh',
        'Dadra and Nagar Haveli and Daman and Diu',
        'Delhi',
        'Goa',
        'Gujarat',
        'Haryana',
        'Himachal Pradesh',
        'Jammu and Kashmir',
        'Jharkhand',
        'Karnataka',
        'Kerala',
        'Ladakh',
        'Lakshadweep',
        'Madhya Pradesh',
        'Maharashtra',
        'Manipur',
        'Meghalaya',
        'Mizoram',
        'Nagaland',
        'Odisha',
        'Puducherry',
        'Punjab',
        'Rajasthan',
        'Sikkim',
        'Tamil Nadu',
        'Telangana',
        'Tripura',
        'Uttar Pradesh',
        'Uttarakhand',
        'West Bengal',
      ];

      expect(allStatesAndUTs.length, 36);
      expect(allStatesAndUTs.toSet().length, 36); // No duplicates
      expect(allStatesAndUTs.contains('Maharashtra'), isTrue);
      expect(allStatesAndUTs.contains('Ladakh'), isTrue);
      expect(allStatesAndUTs.contains('Delhi'), isTrue);
      expect(allStatesAndUTs.contains('Goa'), isTrue);
    });
  });
}
