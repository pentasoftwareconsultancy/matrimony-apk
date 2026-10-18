import '../data/dummy_profiles.dart';

/// Compatibility is calculated from profile fields that are present on both
/// profiles. Missing fields are excluded rather than treated as a mismatch.
class ProfileCompatibilityResult {
  final int score;
  final List<String> tags;
  final bool hasComparableData;

  const ProfileCompatibilityResult({
    required this.score,
    required this.tags,
    required this.hasComparableData,
  });
}

MatrimonialProfile profileFromUser(dynamic user) {
  // Read the serialised model instead of calling optional dynamic getters.
  // The auth User model does not define every field used by MatrimonialProfile,
  // so expressions such as user.incomeValue can throw NoSuchMethodError.
  Map<String, dynamic> data = <String, dynamic>{};
  try {
    final raw = user.toJson();
    if (raw is Map) data = Map<String, dynamic>.from(raw);
  } catch (_) {
    // Keep an empty map; missing fields will be represented as unavailable.
  }

  dynamic value(List<String> keys) {
    for (final key in keys) {
      final candidate = data[key];
      if (candidate != null) return candidate;
    }
    return null;
  }

  String textValue(List<String> keys) => (value(keys) ?? '').toString().trim();

  List<String> parseList(dynamic input) {
    if (input is List) {
      return input
          .map((item) => item.toString().trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }
    return <String>[];
  }

  final ageRaw = value(<String>['age']);
  final age = ageRaw is num
      ? ageRaw.toInt()
      : int.tryParse(ageRaw?.toString() ?? '') ?? 0;

  // incomeValue is not part of the auth User model. Prefer it if the API
  // actually supplied it; otherwise derive a comparable value from annualIncome.
  final incomeRaw = value(<String>['incomeValue']);
  double income = incomeRaw is num
      ? incomeRaw.toDouble()
      : double.tryParse(incomeRaw?.toString().replaceAll(',', '') ?? '') ?? 0.0;
  if (income <= 0) {
    final annualIncome = textValue(<String>['annualIncome']);
    final digits = annualIncome.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsedIncome = double.tryParse(digits) ?? 0.0;
    // Values such as ₹8,00,000 are currency amounts; values such as 8 LPA
    // are already expressed in lakhs per annum.
    income = parsedIncome >= 1000 ? parsedIncome / 100000 : parsedIncome;
  }

  return MatrimonialProfile(
    id: textValue(<String>['id', '_id', 'sId']),
    fullName: textValue(<String>['fullName', 'name']),
    age: age,
    gender: textValue(<String>['gender']),
    religion: textValue(<String>['religion']),
    caste: textValue(<String>['caste']),
    maritalStatus: textValue(<String>['maritalStatus']),
    bloodGroup: textValue(<String>['bloodGroup']),
    height: textValue(<String>['height']),
    qualification: textValue(<String>['qualification', 'education']),
    occupation: textValue(<String>['occupation', 'profession']),
    annualIncome: textValue(<String>['annualIncome']),
    incomeValue: income,
    city: textValue(<String>['city']),
    state: textValue(<String>['state']),
    country: textValue(<String>['country']),
    about: textValue(<String>['about', 'bio', 'aboutFamily']),
    photos: parseList(value(<String>['photos'])),
    isPremium: value(<String>['isPremium']) == true,
    premiumTier: textValue(<String>['premiumTier']),
    compatibilityScore: 0,
    compatibilityTags: const <String>[],
    rashi: textValue(<String>['rashi']),
    nakshatra: textValue(<String>['nakshatra']),
    manglik: value(<String>['manglik']) == true,
    familyType: textValue(<String>['familyType']),
    education: textValue(<String>['education', 'qualification']),
    diet: textValue(<String>['diet']),
    smoking: textValue(<String>['smoking']),
    drinking: textValue(<String>['drinking']),
    fatherName: textValue(<String>['fatherName']),
    motherName: textValue(<String>['motherName']),
    siblings: textValue(<String>['siblings']),
    hobbies: parseList(value(<String>['hobbies'])),
    isVerified: value(<String>['isVerified']) == true,
    workLocation: textValue(<String>['workLocation']),
    nativePlace: textValue(<String>['nativePlace']),
    familyStatus: textValue(<String>['familyStatus']),
  );
}

ProfileCompatibilityResult calculateProfileCompatibility(
    MatrimonialProfile own,
    MatrimonialProfile candidate,
    ) {
  final ownId = own.id.trim();
  final candidateId = candidate.id.trim();
  if (ownId.isNotEmpty && candidateId.isNotEmpty && ownId == candidateId) {
    return const ProfileCompatibilityResult(score: 0, tags: <String>[], hasComparableData: false);
  }

  var availableWeight = 0.0;
  var earnedWeight = 0.0;
  final tags = <String>[];

  void compareText(
      String label,
      String first,
      String second,
      double weight, {
        bool partialMatch = false,
      }) {
    final a = first.trim().toLowerCase();
    final b = second.trim().toLowerCase();
    if (a.isEmpty || b.isEmpty) return;

    availableWeight += weight;
    final matches = a == b || (partialMatch && (a.contains(b) || b.contains(a)));
    if (matches) {
      earnedWeight += weight;
      tags.add(label);
    }
  }

  void compareScore(
      String label,
      double? first,
      double? second,
      double weight,
      double Function(double, double) similarity,
      ) {
    if (first == null || second == null || first <= 0 || second <= 0) return;
    final match = similarity(first, second).clamp(0.0, 1.0);
    availableWeight += weight;
    earnedWeight += weight * match;
    if (match >= 0.6) tags.add(label);
  }

  compareScore('Age range', own.age.toDouble(), candidate.age.toDouble(), 10,
          (a, b) {
        final difference = (a - b).abs();
        if (difference <= 2) return 1;
        if (difference <= 5) return 0.8;
        if (difference <= 8) return 0.6;
        if (difference <= 12) return 0.3;
        return 0;
      });

  compareText('Religion', own.religion, candidate.religion, 12);
  compareText('Caste', own.caste, candidate.caste, 8);
  compareText('Marital status', own.maritalStatus, candidate.maritalStatus, 10);
  compareText('Height', own.height, candidate.height, 5);
  compareText('Education', own.education.isNotEmpty ? own.education : own.qualification,
      candidate.education.isNotEmpty ? candidate.education : candidate.qualification, 10,
      partialMatch: true);
  compareText('Career interests', own.occupation, candidate.occupation, 7,
      partialMatch: true);
  compareScore('Income range', own.incomeValue, candidate.incomeValue, 7, (a, b) {
    final ratio = (a - b).abs() / (a > b ? a : b);
    if (ratio <= 0.15) return 1;
    if (ratio <= 0.30) return 0.75;
    if (ratio <= 0.50) return 0.45;
    return 0.15;
  });

  compareText('City', own.city, candidate.city, 5);
  compareText('State', own.state, candidate.state, 3);
  compareText('Country', own.country, candidate.country, 2);
  compareText('Diet', own.diet, candidate.diet, 5);
  compareText('Family type', own.familyType, candidate.familyType, 5);
  compareText('Manglik status', own.manglik ? 'yes' : 'no',
      candidate.manglik ? 'yes' : 'no', 3);
  compareText('Rashi', own.rashi, candidate.rashi, 2);
  compareText('Nakshatra', own.nakshatra, candidate.nakshatra, 2);

  final ownHobbies = own.hobbies
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .toSet();
  final candidateHobbies = candidate.hobbies
      .map((value) => value.trim().toLowerCase())
      .where((value) => value.isNotEmpty)
      .toSet();
  if (ownHobbies.isNotEmpty && candidateHobbies.isNotEmpty) {
    availableWeight += 4;
    final overlap = ownHobbies.intersection(candidateHobbies).length;
    final similarity = overlap / ownHobbies.union(candidateHobbies).length;
    earnedWeight += 4 * similarity;
    if (overlap > 0) tags.add('Shared hobbies');
  }

  if (availableWeight == 0) {
    return const ProfileCompatibilityResult(score: 0, tags: <String>[], hasComparableData: false);
  }

  final score = ((earnedWeight / availableWeight) * 100)
      .round()
      .clamp(0, 100)
      .toInt();

  return ProfileCompatibilityResult(
    score: score,
    tags: List<String>.unmodifiable(tags),
    hasComparableData: true,
  );
}
