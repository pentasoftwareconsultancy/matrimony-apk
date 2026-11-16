import 'package:flutter_test/flutter_test.dart';
import 'package:matrimony_app/core/data/dummy_profiles.dart';
import 'package:matrimony_app/core/utils/date_formatter.dart';

void main() {
  group('Date of Birth Formatter Tests', () {
    test('formats UTC ISO strings correctly', () {
      expect(formatDobString('1997-03-14T00:00:00.000Z'), '14 March 1997');
      expect(formatDobString('1995-10-22T00:00:00.000Z'), '22 October 1995');
    });

    test('formats IST offset midnight strings (18:30 UTC of previous day) without 1-day shifting', () {
      expect(formatDobString('1997-03-13T18:30:00.000Z'), '14 March 1997');
      expect(formatDobString('1995-10-21T18:30:00.000Z'), '22 October 1995');
    });

    test('formats YYYY-MM-DD plain strings correctly', () {
      expect(formatDobString('1998-05-02'), '2 May 1998');
      expect(formatDobString('1990-12-31'), '31 December 1990');
    });

    test('formats DD/MM/YYYY and DD-MM-YYYY strings correctly', () {
      expect(formatDobString('14/03/1997'), '14 March 1997');
      expect(formatDobString('05-08-1996'), '5 August 1996');
    });

    test('preserves already formatted strings', () {
      expect(formatDobString('14 March 1997'), '14 March 1997');
      expect(formatDobString('25 August 1998'), '25 August 1998');
    });

    test('handles empty or missing dates gracefully', () {
      expect(formatDobString(null), '');
      expect(formatDobString(''), '');
      expect(formatDobString('null'), '');
      expect(formatDobString('-'), '');
    });

    test('parseDobDateTime parses exact calendar day in UTC', () {
      final dt1 = parseDobDateTime('1997-03-14T00:00:00.000Z');
      expect(dt1, DateTime.utc(1997, 3, 14));

      final dt2 = parseDobDateTime('1997-03-13T18:30:00.000Z');
      expect(dt2, DateTime.utc(1997, 3, 14));

      final dt3 = parseDobDateTime('14/03/1997');
      expect(dt3, DateTime.utc(1997, 3, 14));
    });
  });

  group('MatrimonialProfile Birth Date Mapping Tests', () {
    test('MatrimonialProfile parses user-specific birth date from json', () {
      final profile1 = MatrimonialProfile.fromJson({
        'id': 'user_1',
        'fullName': 'Aarav Sharma',
        'birthDate': '12 January 1994',
        'age': 30,
      });

      final profile2 = MatrimonialProfile.fromJson({
        'id': 'user_2',
        'fullName': 'Priya Patil',
        'dob': '1996-08-25T00:00:00.000Z',
        'age': 28,
      });

      final profile3 = MatrimonialProfile.fromJson({
        'id': 'user_3',
        'fullName': 'Rohan Deshmukh',
        'userRegistration': {
          'dateOfBirth': '1992-11-05T00:00:00.000Z',
        },
        'age': 32,
      });

      expect(profile1.birthDate, '12 January 1994');
      expect(profile2.birthDate, '25 August 1996');
      expect(profile3.birthDate, '5 November 1992');

      // Crucial: They must NOT share the same date of birth!
      expect(profile1.birthDate, isNot(equals(profile2.birthDate)));
      expect(profile2.birthDate, isNot(equals(profile3.birthDate)));
      expect(profile1.birthDate, isNot(equals('14 March 1997')));
    });

    test('MatrimonialProfile without birthDate returns empty string, not a hardcoded fallback', () {
      final profile = MatrimonialProfile.fromJson({
        'id': 'user_empty',
        'fullName': 'Test User',
      });

      expect(profile.birthDate, '');
      expect(profile.dob, isNull);
    });
  });
}

