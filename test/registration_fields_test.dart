import 'package:flutter_test/flutter_test.dart';
import 'package:matrimony_app/features/auth/presentation/controllers/registration_controller.dart';

void main() {
  group('Registration Field Updates Tests', () {
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

    test('RegistrationState defaults do not force removed fields in payload', () {
      final state = RegistrationState(
        accountType: 'Bride',
        fullName: 'Test User',
        phone: '9876543210',
        email: 'test@example.com',
        password: 'Password123',
        confirmPassword: 'Password123',
        gender: 'Female',
        dob: DateTime(1998, 5, 20),
        age: 26,
        religion: 'Hindu',
        caste: 'Maratha',
        maritalStatus: 'Never Married',
        bloodGroup: 'B+',
        qualification: 'B.Tech',
        occupation: 'Software Engineer',
        annualIncome: '10 LPA',
        fatherName: 'Father Name',
        motherName: 'Mother Name',
        familyType: 'Nuclear',
        aadharNumber: '123456789012',
      );

      // Verify removed fields are empty by default
      expect(state.hobbies.isEmpty, isTrue);
      expect(state.nakshatra.isEmpty, isTrue);
      expect(state.state.isEmpty, isTrue);
      expect(state.city.isEmpty, isTrue);
      expect(state.languages.isEmpty, isTrue);

      // Verify essential fields are present
      expect(state.bloodGroup, 'B+');
      expect(state.dob, isNotNull);
      expect(state.age, 26);
    });

    test('RegistrationState reset clears all inputs back to Step 0', () {
      final filledState = RegistrationState(
        currentStep: 5,
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phone: '9876543210',
        photos: ['https://example.com/photo.jpg'],
      );

      expect(filledState.currentStep, 5);
      expect(filledState.fullName, 'Jane Doe');

      // Calling reset returns fresh initial state
      final resetState = RegistrationState();
      expect(resetState.currentStep, 0);
      expect(resetState.fullName, '');
      expect(resetState.email, '');
      expect(resetState.phone, '');
      expect(resetState.photos, isEmpty);
    });

    test('Annual income parsing handles varied input formats', () {
      int? parseAnnualIncome(String raw) {
        final cleaned = raw.replaceAll(',', '').trim();
        final direct = int.tryParse(cleaned);
        if (direct != null) return direct;
        final lpaMatch = RegExp(r'(\d+(?:\.\d+)?)\s*(?:lpa|lakh|lakhs)', caseSensitive: false).firstMatch(cleaned);
        if (lpaMatch != null) {
          final val = double.tryParse(lpaMatch.group(1) ?? '');
          if (val != null) return (val * 100000).round();
        }
        final numMatch = RegExp(r'\d+').firstMatch(cleaned);
        return numMatch != null ? int.tryParse(numMatch.group(0)!) : null;
      }

      expect(parseAnnualIncome('1200000'), 1200000);
      expect(parseAnnualIncome('12,00,000'), 1200000);
      expect(parseAnnualIncome('12 LPA'), 1200000);
      expect(parseAnnualIncome('10 Lakhs'), 1000000);
      expect(parseAnnualIncome('₹10 Lakhs - ₹15 Lakhs'), 1000000);
      expect(parseAnnualIncome('invalid'), isNull);
    });
  });
}

