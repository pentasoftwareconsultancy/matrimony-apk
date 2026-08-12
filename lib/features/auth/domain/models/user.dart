// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    String? email,
    String? phone,
    String? accountType,
    String? fullName,
    String? gender,
    int? age,
    DateTime? dob,
    String? religion,
    String? caste,
    String? maritalStatus,
    String? bloodGroup,
    String? address,
    List<String>? hobbies,
    String? rashi,
    String? nakshatra,
    bool? manglik,
    String? qualification,
    String? occupation,
    String? annualIncome,
    String? country,
    String? state,
    String? city,
    List<String>? languages,
    String? fatherName,
    String? motherName,
    int? siblings,
    String? familyType,
    String? familyStatus,
    String? nativePlace,
    String? aboutFamily,
    String? aadharNumber,
    String? aadharCardUrl,
    String? casteCertificateUrl,
    String? casteCertificateName,
    List<String>? photos,
    required bool profileCompleted,
    required bool isVerified,
    required bool isPremium,
    required String role,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
