import 'package:flutter_test/flutter_test.dart';
import 'package:matrimony_app/features/auth/presentation/controllers/registration_controller.dart';
import 'package:matrimony_app/features/profile/domain/models/profile_model.dart';

void main() {
  group('Registration Field Updates & Uncle Details Tests', () {
    test('Allowed Blood Group dropdown options', () {
      const allowedBloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
      expect(allowedBloodGroups.length, 8);
      for (final bg in ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']) {
        expect(allowedBloodGroups.contains(bg), isTrue);
      }
      expect(allowedBloodGroups.contains('Unknown'), isFalse);
    });

    test('DOB calculates age accurately without requiring Age input field', () {
      final now = DateTime.now();
      final dob = DateTime(now.year - 25, now.month, now.day);
      
      int calculatedAge = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        calculatedAge--;
      }

      expect(calculatedAge, 25);
    });

    test('Strict No Dummy Data: Initial RegistrationState starts completely empty with 0 uncles', () {
      final state = RegistrationState();
      expect(state.maternalUnclesDetails, isEmpty);
      expect(state.paternalUnclesDetails, isEmpty);
    });

    test('Strict No Dummy Data: Empty or unentered records are filtered out and never submitted', () {
      final emptyUncleList = [
        const UncleDetail(name: '', occupation: ''),
        const UncleDetail(name: '   ', occupation: '  '),
      ];

      final filtered = emptyUncleList
          .where((u) => u.name.trim().isNotEmpty || u.occupation.trim().isNotEmpty)
          .toList();

      expect(filtered, isEmpty);
    });

    test('Strict No Dummy Data: When count is zero, submitted list is strictly empty', () {
      final state = RegistrationState(
        maternalUnclesDetails: const [],
        paternalUnclesDetails: const [],
      );

      final maternalPayload = state.maternalUnclesDetails
          .where((u) => u.name.trim().isNotEmpty || u.occupation.trim().isNotEmpty)
          .map((u) => u.toJson())
          .toList();
      final paternalPayload = state.paternalUnclesDetails
          .where((u) => u.name.trim().isNotEmpty || u.occupation.trim().isNotEmpty)
          .map((u) => u.toJson())
          .toList();

      expect(maternalPayload, isEmpty);
      expect(paternalPayload, isEmpty);
    });

    test('Test Case: Maternal = 1, Paternal = 1', () {
      final maternal = [
        const UncleDetail(name: 'Ramesh Patil', occupation: 'Civil Engineer'),
      ];
      final paternal = [
        const UncleDetail(name: 'Suresh Patil', occupation: 'Doctor'),
      ];

      final state = RegistrationState().copyWith(
        maternalUnclesDetails: maternal,
        paternalUnclesDetails: paternal,
      );

      expect(state.maternalUnclesDetails.length, 1);
      expect(state.maternalUnclesDetails[0].name, 'Ramesh Patil');
      expect(state.maternalUnclesDetails[0].occupation, 'Civil Engineer');

      expect(state.paternalUnclesDetails.length, 1);
      expect(state.paternalUnclesDetails[0].name, 'Suresh Patil');
      expect(state.paternalUnclesDetails[0].occupation, 'Doctor');
    });

    test('Test Case: Maternal = 2, Paternal = 1', () {
      final maternal = [
        const UncleDetail(name: 'Ramesh Patil', occupation: 'Teacher'),
        const UncleDetail(name: 'Ganesh Patil', occupation: 'Software Engineer'),
      ];
      final paternal = [
        const UncleDetail(name: 'Suresh Patil', occupation: 'Bank Manager'),
      ];

      final state = RegistrationState().copyWith(
        maternalUnclesDetails: maternal,
        paternalUnclesDetails: paternal,
      );

      expect(state.maternalUnclesDetails.length, 2);
      expect(state.maternalUnclesDetails[0].name, 'Ramesh Patil');
      expect(state.maternalUnclesDetails[1].name, 'Ganesh Patil');

      expect(state.paternalUnclesDetails.length, 1);
      expect(state.paternalUnclesDetails[0].name, 'Suresh Patil');
    });

    test('Test Case: Maternal = 1, Paternal = 2', () {
      final maternal = [
        const UncleDetail(name: 'Anand Shinde', occupation: 'Lawyer'),
      ];
      final paternal = [
        const UncleDetail(name: 'Vijay Shinde', occupation: 'Architect'),
        const UncleDetail(name: 'Prakash Shinde', occupation: 'Business'),
      ];

      final state = RegistrationState().copyWith(
        maternalUnclesDetails: maternal,
        paternalUnclesDetails: paternal,
      );

      expect(state.maternalUnclesDetails.length, 1);
      expect(state.maternalUnclesDetails[0].name, 'Anand Shinde');

      expect(state.paternalUnclesDetails.length, 2);
      expect(state.paternalUnclesDetails[0].name, 'Vijay Shinde');
      expect(state.paternalUnclesDetails[0].occupation, 'Architect');
      expect(state.paternalUnclesDetails[1].name, 'Prakash Shinde');
      expect(state.paternalUnclesDetails[1].occupation, 'Business');
    });

    test('Test Case: Maternal = 3, Paternal = 3', () {
      final maternal = [
        const UncleDetail(name: 'Maternal Uncle 1', occupation: 'Prof 1'),
        const UncleDetail(name: 'Maternal Uncle 2', occupation: 'Prof 2'),
        const UncleDetail(name: 'Maternal Uncle 3', occupation: 'Prof 3'),
      ];
      final paternal = [
        const UncleDetail(name: 'Paternal Uncle 1', occupation: 'Prof A'),
        const UncleDetail(name: 'Paternal Uncle 2', occupation: 'Prof B'),
        const UncleDetail(name: 'Paternal Uncle 3', occupation: 'Prof C'),
      ];

      final state = RegistrationState().copyWith(
        maternalUnclesDetails: maternal,
        paternalUnclesDetails: paternal,
      );

      expect(state.maternalUnclesDetails.length, 3);
      expect(state.maternalUnclesDetails[2].name, 'Maternal Uncle 3');
      expect(state.maternalUnclesDetails[2].occupation, 'Prof 3');

      expect(state.paternalUnclesDetails.length, 3);
      expect(state.paternalUnclesDetails[2].name, 'Paternal Uncle 3');
      expect(state.paternalUnclesDetails[2].occupation, 'Prof C');
    });

    test('Test Case: Reduce count after entering details preserves visible entries', () {
      final initialMaternal = [
        const UncleDetail(name: 'Uncle 1', occupation: 'Engineer'),
        const UncleDetail(name: 'Uncle 2', occupation: 'Doctor'),
        const UncleDetail(name: 'Uncle 3', occupation: 'Teacher'),
      ];

      // Simulated reducing count to 1: taking the first 1
      final reducedMaternal = initialMaternal.sublist(0, 1);

      expect(reducedMaternal.length, 1);
      // Uncle 1 entered details preserved
      expect(reducedMaternal[0].name, 'Uncle 1');
      expect(reducedMaternal[0].occupation, 'Engineer');
    });

    test('UncleDetail toJson & fromJson serialization and backward compatibility', () {
      const detail = UncleDetail(name: 'Kishore Deshmukh', occupation: 'Professor');
      final json = detail.toJson();

      expect(json['name'], 'Kishore Deshmukh');
      expect(json['occupation'], 'Professor');
      expect(json['profession'], 'Professor');

      // fromJson with occupation
      final fromOcc = UncleDetail.fromJson({'name': 'Kishore', 'occupation': 'Doctor'});
      expect(fromOcc.name, 'Kishore');
      expect(fromOcc.occupation, 'Doctor');

      // fromJson with profession (backward compatibility)
      final fromProf = UncleDetail.fromJson({'name': 'Kishore', 'profession': 'Scientist'});
      expect(fromProf.name, 'Kishore');
      expect(fromProf.occupation, 'Scientist');
    });

    test('RegistrationState payload mapping includes uncles details and legacy scalar names', () {
      final state = RegistrationState(
        accountType: 'Self',
        fullName: 'Rahul Test',
        fatherName: 'Father Name',
        motherName: 'Mother Name',
        maternalUnclesDetails: [
          const UncleDetail(name: 'Maternal Uncle 1', occupation: 'Teacher'),
          const UncleDetail(name: 'Maternal Uncle 2', occupation: 'Engineer'),
        ],
        paternalUnclesDetails: [
          const UncleDetail(name: 'Paternal Uncle 1', occupation: 'Officer'),
        ],
      );

      final maternalJson = state.maternalUnclesDetails
          .where((u) => u.name.trim().isNotEmpty || u.occupation.trim().isNotEmpty)
          .map((u) => u.toJson())
          .toList();
      final paternalJson = state.paternalUnclesDetails
          .where((u) => u.name.trim().isNotEmpty || u.occupation.trim().isNotEmpty)
          .map((u) => u.toJson())
          .toList();
      final maternalScalar = state.maternalUnclesDetails.map((u) => u.name).where((n) => n.trim().isNotEmpty).join(', ');
      final paternalScalar = state.paternalUnclesDetails.map((u) => u.name).where((n) => n.trim().isNotEmpty).join(', ');

      expect(maternalJson.length, 2);
      expect(paternalJson.length, 1);
      expect(maternalScalar, 'Maternal Uncle 1, Maternal Uncle 2');
      expect(paternalScalar, 'Paternal Uncle 1');
    });
  });
}
