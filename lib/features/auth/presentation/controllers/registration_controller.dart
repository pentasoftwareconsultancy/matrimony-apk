import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../profile/domain/models/profile_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user.dart';
import 'auth_controller.dart';

class RegistrationState {
  final int currentStep;
  final bool isLoading;
  final String? error;

  // Step 1: Account Details / Basic Details
  final String accountType; // Profile created for
  final String fullName;
  final String phone;
  final DateTime? dob;
  final int? age;
  final String motherTongue;
  final String email;
  final String password;
  final String confirmPassword;

  // Step 2: Personal Details
  final String gender;
  final String maritalStatus;
  final String height;
  final String diet;
  final String physicalStatus; // Physical Status / Special Case
  final String bloodGroup;
  final String address;
  final List<String> hobbies;
  final String rashi;
  final String nakshatra;
  final bool manglik;

  // Step 3: Education / Career
  final String qualification; // Highest Education
  final String occupation; // Profession / Occupation
  final String annualIncome;

  // Step 4: Location & Family
  final String country;
  final String state;
  final String city; // City / District
  final String religion;
  final String caste;
  final String familyType;
  final List<UncleDetail> maternalUnclesDetails;
  final List<UncleDetail> paternalUnclesDetails;
  final List<String> languages;
  final String fatherName;
  final String motherName;
  final int siblings;
  final String familyStatus;
  final String nativePlace;
  final String aboutFamily;

  // Step 5: Document Details & Photos
  final String aadharNumber;
  final String aadharCardUrl;
  final String aadharCardName; // local front file name picked
  final List<int>? aadharBytes; // raw front bytes of picked file
  final String aadharBackUrl;
  final String aadharBackName; // local back file name picked
  final List<int>? aadharBackBytes; // raw back bytes of picked file
  final List<String> photos; // list of remote/local photo URLs
  final List<Map<String, dynamic>>? pickedPhotosData; // list of maps with { 'bytes': List<int>, 'fileName': String }
  
  final String casteCertificatePath;
  final String casteCertificateName;
  final String casteCertificateUrl;
  final List<int>? casteCertificateBytes;
  
  // Review & Confirm details
  final bool isConfirmDetailsAccepted;
  final bool isEditingFromReview;

  RegistrationState({
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
    this.accountType = 'Yourself',
    this.fullName = '',
    this.phone = '',
    this.dob,
    this.age,
    this.motherTongue = 'Marathi',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.gender = 'Male',
    this.maritalStatus = 'Never Married',
    this.height = '',
    this.diet = '',
    this.physicalStatus = '',
    this.religion = '',
    this.caste = '',
    this.bloodGroup = '',
    this.address = '',
    this.hobbies = const [],
    this.rashi = '',
    this.nakshatra = '',
    this.manglik = false,
    this.qualification = '',
    this.occupation = '',
    this.annualIncome = '',
    this.country = 'India',
    this.state = '',
    this.city = '',
    this.languages = const [],
    this.fatherName = '',
    this.motherName = '',
    this.siblings = 0,
    this.familyType = '',
    this.familyStatus = 'Middle Class',
    this.nativePlace = '',
    this.aboutFamily = '',
    this.maternalUnclesDetails = const [],
    this.paternalUnclesDetails = const [],
    this.aadharNumber = '',
    this.aadharCardUrl = '',
    this.aadharCardName = '',
    this.aadharBytes,
    this.aadharBackUrl = '',
    this.aadharBackName = '',
    this.aadharBackBytes,
    this.photos = const [],
    this.pickedPhotosData,
    this.casteCertificatePath = '',
    this.casteCertificateName = '',
    this.casteCertificateUrl = '',
    this.casteCertificateBytes,
    this.isConfirmDetailsAccepted = false,
    this.isEditingFromReview = false,
  });

  RegistrationState copyWith({
    int? currentStep,
    bool? isLoading,
    String? error,
    String? accountType,
    String? fullName,
    String? phone,
    DateTime? dob,
    int? age,
    String? motherTongue,
    String? email,
    String? password,
    String? confirmPassword,
    String? gender,
    String? maritalStatus,
    String? height,
    String? diet,
    String? physicalStatus,
    String? religion,
    String? caste,
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
    List<UncleDetail>? maternalUnclesDetails,
    List<UncleDetail>? paternalUnclesDetails,
    String? aadharNumber,
    String? aadharCardUrl,
    String? aadharCardName,
    List<int>? aadharBytes,
    String? aadharBackUrl,
    String? aadharBackName,
    List<int>? aadharBackBytes,
    List<String>? photos,
    List<Map<String, dynamic>>? pickedPhotosData,
    String? casteCertificatePath,
    String? casteCertificateName,
    String? casteCertificateUrl,
    List<int>? casteCertificateBytes,
    bool? isConfirmDetailsAccepted,
    bool? isEditingFromReview,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      accountType: accountType ?? this.accountType,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      motherTongue: motherTongue ?? this.motherTongue,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      height: height ?? this.height,
      diet: diet ?? this.diet,
      physicalStatus: physicalStatus ?? this.physicalStatus,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      address: address ?? this.address,
      hobbies: hobbies ?? this.hobbies,
      rashi: rashi ?? this.rashi,
      nakshatra: nakshatra ?? this.nakshatra,
      manglik: manglik ?? this.manglik,
      qualification: qualification ?? this.qualification,
      occupation: occupation ?? this.occupation,
      annualIncome: annualIncome ?? this.annualIncome,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      languages: languages ?? this.languages,
      fatherName: fatherName ?? this.fatherName,
      motherName: motherName ?? this.motherName,
      siblings: siblings ?? this.siblings,
      familyType: familyType ?? this.familyType,
      familyStatus: familyStatus ?? this.familyStatus,
      nativePlace: nativePlace ?? this.nativePlace,
      aboutFamily: aboutFamily ?? this.aboutFamily,
      maternalUnclesDetails: maternalUnclesDetails ?? this.maternalUnclesDetails,
      paternalUnclesDetails: paternalUnclesDetails ?? this.paternalUnclesDetails,
      aadharNumber: aadharNumber ?? this.aadharNumber,
      aadharCardUrl: aadharCardUrl ?? this.aadharCardUrl,
      aadharCardName: aadharCardName ?? this.aadharCardName,
      aadharBytes: aadharBytes ?? this.aadharBytes,
      aadharBackUrl: aadharBackUrl ?? this.aadharBackUrl,
      aadharBackName: aadharBackName ?? this.aadharBackName,
      aadharBackBytes: aadharBackBytes ?? this.aadharBackBytes,
      photos: photos ?? this.photos,
      pickedPhotosData: pickedPhotosData ?? this.pickedPhotosData,
      casteCertificatePath: casteCertificatePath ?? this.casteCertificatePath,
      casteCertificateName: casteCertificateName ?? this.casteCertificateName,
      casteCertificateUrl: casteCertificateUrl ?? this.casteCertificateUrl,
      casteCertificateBytes: casteCertificateBytes ?? this.casteCertificateBytes,
      isConfirmDetailsAccepted: isConfirmDetailsAccepted ?? this.isConfirmDetailsAccepted,
      isEditingFromReview: isEditingFromReview ?? this.isEditingFromReview,
    );
  }
}

class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final Ref _ref;
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  RegistrationNotifier(this._ref, this._authRepository, this._secureStorage) : super(RegistrationState()) {
    _initFieldsFromAuth();
    _loadCasteCertificateFromStorage();
  }

  void _initFieldsFromAuth() {
    final authUser = _ref.read(authControllerProvider).user;
    if (authUser != null) {
      state = state.copyWith(
        email: authUser.email ?? '',
        phone: authUser.phone ?? '',
        fullName: authUser.fullName ?? '',
      );
    }
  }

  Future<void> _saveCasteCertificateToStorage(String path, String name, String url) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('caste_certificate_path', path);
      await prefs.setString('caste_certificate_name', name);
      await prefs.setString('caste_certificate_url', url);
      await prefs.setString('caste_certificate_status', name.isNotEmpty ? 'Uploaded' : 'Not uploaded');
    } catch (e) {
      // Ignored
    }
  }

  Future<void> _clearCasteCertificateFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('caste_certificate_path');
      await prefs.remove('caste_certificate_name');
      await prefs.remove('caste_certificate_url');
      await prefs.remove('caste_certificate_status');
    } catch (e) {
      // Ignored
    }
  }

  Future<void> _loadCasteCertificateFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final path = prefs.getString('caste_certificate_path') ?? '';
      final name = prefs.getString('caste_certificate_name') ?? '';
      final url = prefs.getString('caste_certificate_url') ?? '';
      
      if (name.isNotEmpty) {
        List<int>? bytes;
        if (!kIsWeb && path.isNotEmpty) {
          try {
            final file = io.File(path);
            if (await file.exists()) {
              bytes = await file.readAsBytes();
            }
          } catch (e) {
            // File might have been cleaned up by OS temp manager, that's fine
          }
        }
        state = state.copyWith(
          casteCertificatePath: path,
          casteCertificateName: name,
          casteCertificateUrl: url,
          casteCertificateBytes: bytes,
        );
      }
    } catch (e) {
      // Ignored
    }
  }

  void updateCasteCertificate({
    String? path,
    String? name,
    List<int>? bytes,
    String? url,
  }) {
    state = state.copyWith(
      casteCertificatePath: path ?? state.casteCertificatePath,
      casteCertificateName: name ?? state.casteCertificateName,
      casteCertificateBytes: bytes ?? state.casteCertificateBytes,
      casteCertificateUrl: url ?? state.casteCertificateUrl,
    );
    _saveCasteCertificateToStorage(
      path ?? state.casteCertificatePath,
      name ?? state.casteCertificateName,
      url ?? state.casteCertificateUrl,
    );
  }

  void removeCasteCertificate() {
    state = state.copyWith(
      casteCertificatePath: '',
      casteCertificateName: '',
      casteCertificateBytes: null,
      casteCertificateUrl: '',
    );
    _clearCasteCertificateFromStorage();
  }

  void loadUserForEditing(User user) {
    state = RegistrationState(
      currentStep: 5,
      accountType: user.accountType ?? 'Self',
      fullName: user.fullName ?? '',
      phone: user.phone ?? '',
      email: user.email ?? '',
      gender: user.gender ?? 'Male',
      dob: user.dob,
      age: user.age,
      religion: user.religion ?? '',
      caste: user.caste ?? '',
      maritalStatus: user.maritalStatus ?? 'Single',
      bloodGroup: user.bloodGroup ?? '',
      address: user.address ?? '',
      hobbies: user.hobbies ?? const [],
      rashi: user.rashi ?? '',
      nakshatra: user.nakshatra ?? '',
      manglik: user.manglik ?? false,
      qualification: user.qualification ?? '',
      occupation: user.occupation ?? '',
      annualIncome: user.annualIncome ?? '',
      country: user.country ?? 'India',
      state: user.state ?? '',
      city: user.city ?? '',
      languages: user.languages ?? const [],
      fatherName: user.fatherName ?? '',
      motherName: user.motherName ?? '',
      siblings: user.siblings ?? 0,
      familyType: user.familyType ?? 'Joint',
      familyStatus: user.familyStatus ?? 'Middle Class',
      nativePlace: user.nativePlace ?? '',
      aboutFamily: user.aboutFamily ?? '',
      aadharNumber: user.aadharNumber ?? '',
      aadharCardUrl: user.aadharCardUrl ?? '',
      photos: user.photos ?? const [],
      casteCertificateUrl: user.casteCertificateUrl ?? '',
      casteCertificateName: user.casteCertificateName ?? '',
    );
  }

  void updateStep1({
    String? accountType,
    String? fullName,
    String? phone,
    DateTime? dob,
    int? age,
    String? motherTongue,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    state = state.copyWith(
      accountType: accountType,
      fullName: fullName,
      phone: phone,
      dob: dob,
      age: age,
      motherTongue: motherTongue,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  void updateStep2({
    String? gender,
    String? maritalStatus,
    String? height,
    String? diet,
    String? physicalStatus,
    DateTime? dob,
    int? age,
    String? religion,
    String? caste,
    String? bloodGroup,
    String? address,
    List<String>? hobbies,
    String? rashi,
    String? nakshatra,
    bool? manglik,
  }) {
    state = state.copyWith(
      gender: gender,
      maritalStatus: maritalStatus,
      height: height,
      diet: diet,
      physicalStatus: physicalStatus,
      dob: dob,
      age: age,
      religion: religion,
      caste: caste,
      bloodGroup: bloodGroup,
      address: address,
      hobbies: hobbies,
      rashi: rashi,
      nakshatra: nakshatra,
      manglik: manglik,
    );
  }

  void updateStep3({
    String? qualification,
    String? occupation,
    String? annualIncome,
    String? country,
    String? stateVal,
    String? city,
    List<String>? languages,
  }) {
    state = state.copyWith(
      qualification: qualification,
      occupation: occupation,
      annualIncome: annualIncome,
      country: country,
      state: stateVal,
      city: city,
      languages: languages,
    );
  }

  void updateStep4({
    String? country,
    String? stateVal,
    String? city,
    String? religion,
    String? caste,
    String? familyType,
    List<UncleDetail>? maternalUnclesDetails,
    List<UncleDetail>? paternalUnclesDetails,
    String? fatherName,
    String? motherName,
    int? siblings,
    String? familyStatus,
    String? nativePlace,
    String? aboutFamily,
  }) {
    state = state.copyWith(
      country: country,
      state: stateVal,
      city: city,
      religion: religion,
      caste: caste,
      familyType: familyType,
      maternalUnclesDetails: maternalUnclesDetails,
      paternalUnclesDetails: paternalUnclesDetails,
      fatherName: fatherName,
      motherName: motherName,
      siblings: siblings,
      familyStatus: familyStatus,
      nativePlace: nativePlace,
      aboutFamily: aboutFamily,
    );
  }

  void updateStep5({
    String? aadharCardName,
    List<int>? aadharBytes,
    String? aadharCardUrl,
    String? aadharBackName,
    List<int>? aadharBackBytes,
    String? aadharBackUrl,
    String? casteCertificateName,
    List<int>? casteCertificateBytes,
    String? casteCertificateUrl,
    String? aadharNumber,
    List<String>? photos,
    List<Map<String, dynamic>>? pickedPhotosData,
  }) {
    state = state.copyWith(
      aadharCardName: aadharCardName,
      aadharBytes: aadharBytes,
      aadharCardUrl: aadharCardUrl,
      aadharBackName: aadharBackName,
      aadharBackBytes: aadharBackBytes,
      aadharBackUrl: aadharBackUrl,
      casteCertificateName: casteCertificateName,
      casteCertificateBytes: casteCertificateBytes,
      casteCertificateUrl: casteCertificateUrl,
      aadharNumber: aadharNumber,
      photos: photos,
      pickedPhotosData: pickedPhotosData,
    );
  }

  void updateAadharCard({
    String? name,
    List<int>? bytes,
    String? url,
  }) {
    state = state.copyWith(
      aadharCardName: name ?? state.aadharCardName,
      aadharBytes: bytes ?? state.aadharBytes,
      aadharCardUrl: url ?? state.aadharCardUrl,
    );
  }

  void removeAadharCard() {
    state = state.copyWith(
      aadharCardName: '',
      aadharBytes: null,
      aadharCardUrl: '',
    );
  }

  void updateAadharBack({
    String? name,
    List<int>? bytes,
    String? url,
  }) {
    state = state.copyWith(
      aadharBackName: name ?? state.aadharBackName,
      aadharBackBytes: bytes ?? state.aadharBackBytes,
      aadharBackUrl: url ?? state.aadharBackUrl,
    );
  }

  void removeAadharBack() {
    state = state.copyWith(
      aadharBackName: '',
      aadharBackBytes: null,
      aadharBackUrl: '',
    );
  }

  void addPickedPhoto({required List<int> bytes, required String fileName}) {
    final currentList = List<Map<String, dynamic>>.from(state.pickedPhotosData ?? []);
    if (currentList.length < 6) {
      currentList.add({
        'bytes': bytes,
        'fileName': fileName,
      });
      state = state.copyWith(pickedPhotosData: currentList);
    }
  }

  void removePickedPhoto(int index) {
    final currentList = List<Map<String, dynamic>>.from(state.pickedPhotosData ?? []);
    if (index >= 0 && index < currentList.length) {
      currentList.removeAt(index);
      state = state.copyWith(pickedPhotosData: currentList);
    }
  }

  void removePhotoUrl(int index) {
    final currentUrls = List<String>.from(state.photos);
    if (index >= 0 && index < currentUrls.length) {
      currentUrls.removeAt(index);
      state = state.copyWith(photos: currentUrls);
    }
  }

  void clearPickedPhotos() {
    state = state.copyWith(pickedPhotosData: []);
  }

  void setConfirmDetailsAccepted(bool val) {
    state = state.copyWith(isConfirmDetailsAccepted: val);
  }

  void setEditingFromReview(bool val) {
    state = state.copyWith(isEditingFromReview: val);
  }

  void setStep(int step) {
    if (step >= 0 && step <= 5) {
      state = state.copyWith(currentStep: step);
    }
  }

  void nextStep() {
    if (state.currentStep < 5) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void prevStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<bool> submit() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      String aadharUrl = state.aadharCardUrl;
      String aadharBackUrl = state.aadharBackUrl;
      String casteCertificateUrl = state.casteCertificateUrl;
      // Keep persistent URLs only. Browser blob URLs and local paths
      // must never be stored as profile photo URLs.
      List<String> uploadedPhotos = state.photos
          .where(
            (url) =>
        url.startsWith('https://') ||
            url.startsWith('http://'),
      )
          .toList();

      // If we have local documents/photos to upload, upload them to Cloudinary first
      if (state.aadharBytes != null || state.aadharBackBytes != null || state.casteCertificateBytes != null || (state.pickedPhotosData != null && state.pickedPhotosData!.isNotEmpty)) {
        final uploadResult = await _authRepository.uploadFiles(
          aadharBytes: state.aadharBytes,
          aadharFileName: state.aadharCardName,
          aadharBackBytes: state.aadharBackBytes,
          aadharBackFileName: state.aadharBackName,
          casteBytes: state.casteCertificateBytes,
          casteFileName: state.casteCertificateName,
          photos: state.pickedPhotosData,
        );
        if (uploadResult['aadharUrl'] != null && uploadResult['aadharUrl'].toString().isNotEmpty) {
          aadharUrl = uploadResult['aadharUrl'];
        }
        if (uploadResult['aadharBackUrl'] != null && uploadResult['aadharBackUrl'].toString().isNotEmpty) {
          aadharBackUrl = uploadResult['aadharBackUrl'];
        }
        if (uploadResult['casteCertificateUrl'] != null && uploadResult['casteCertificateUrl'].toString().isNotEmpty) {
          casteCertificateUrl = uploadResult['casteCertificateUrl'];
        }
        final urls = (uploadResult['photoUrls'] as List? ?? [])
            .map((url) => url.toString())
            .where(
              (url) =>
          url.startsWith('https://') ||
              url.startsWith('http://'),
        );

        for (final url in urls) {
          if (!uploadedPhotos.contains(url)) {
            uploadedPhotos.add(url);
          }
        }
      }

      final int? parsedIncome = _parseAnnualIncome(state.annualIncome);
      final data = {
        'accountType': state.accountType,
        'profileCreatedFor': state.accountType,
        'fullName': state.fullName,
        'phone': state.phone,
        'mobile': state.phone,
        'email': state.email,
        'password': state.password,
        'confirmPassword': state.confirmPassword,
        'gender': state.gender,
        'dob': state.dob?.toIso8601String(),
        if (state.age != null) 'age': state.age,
        'religion': state.religion,
        'caste': state.caste,
        'maritalStatus': state.maritalStatus,
        'height': state.height,
        'diet': state.diet,
        'specialCase': state.physicalStatus,
        'physicalStatus': state.physicalStatus,
        'bloodGroup': state.bloodGroup,
        if (state.address.isNotEmpty) 'address': state.address,
        if (state.hobbies.isNotEmpty) 'hobbies': state.hobbies,
        if (state.rashi.isNotEmpty) 'rashi': state.rashi,
        if (state.nakshatra.isNotEmpty) 'nakshatra': state.nakshatra,
        'manglik': state.manglik,
        'qualification': state.qualification,
        'highestEducation': state.qualification,
        'occupation': state.occupation,
        'profession': state.occupation,
        'annualIncome': parsedIncome ?? state.annualIncome,
        'country': state.country,
        if (state.state.isNotEmpty) 'state': state.state,
        if (state.city.isNotEmpty) ...{
          'city': state.city,
          'district': state.city,
        },
        if (state.languages.isNotEmpty) 'languages': state.languages,
        'motherTongue': state.motherTongue.isNotEmpty ? state.motherTongue : (state.languages.isNotEmpty ? state.languages.first : 'Marathi'),
        'fatherName': state.fatherName,
        'motherName': state.motherName,
        'siblings': state.siblings,
        'brothers': state.siblings,
        'familyType': state.familyType,
        'familyStatus': state.familyStatus,
        'familyValues': state.familyStatus,
        'nativePlace': state.nativePlace,
        'aboutFamily': state.aboutFamily,
        'maternalUnclesDetails': state.maternalUnclesDetails
            .where((u) => u.name.trim().isNotEmpty || u.occupation.trim().isNotEmpty || u.mobile.trim().isNotEmpty)
            .map((u) => u.toJson())
            .toList(),
        'unclesDetails': state.paternalUnclesDetails
            .where((u) => u.name.trim().isNotEmpty || u.occupation.trim().isNotEmpty || u.mobile.trim().isNotEmpty)
            .map((u) => u.toJson())
            .toList(),
        'maternalUncleName': state.maternalUnclesDetails.map((u) => u.name).where((n) => n.trim().isNotEmpty).join(', '),
        'uncleName': state.paternalUnclesDetails.map((u) => u.name).where((n) => n.trim().isNotEmpty).join(', '),
        if (state.maternalUnclesDetails.isNotEmpty && state.maternalUnclesDetails.first.mobile.isNotEmpty)
          'maternalUncleMobile': state.maternalUnclesDetails.first.mobile,
        if (state.paternalUnclesDetails.isNotEmpty && state.paternalUnclesDetails.first.mobile.isNotEmpty)
          'paternalUncleMobile': state.paternalUnclesDetails.first.mobile,
        'aadharNumber': state.aadharNumber,
        'aadharCardUrl': aadharUrl,
        'aadhaarFrontphoto': aadharUrl,
        'aadharBackUrl': aadharBackUrl,
        'aadhaarBackphoto': aadharBackUrl,
        'casteCertificateUrl': casteCertificateUrl,
        'castecertificate': casteCertificateUrl,
        'casteCertificateName': state.casteCertificateName,
        'photos': uploadedPhotos,
      };

      final result = await _authRepository.registerProfile(data);
      await _clearCasteCertificateFromStorage();
      final user = result['user'] as User;
      final token = result['token'] as String?;
      if (token != null && token.isNotEmpty) {
        await _secureStorage.saveToken(token);
      }

      _ref.read(authControllerProvider.notifier).setAuthenticatedState(user);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  int? _parseAnnualIncome(String raw) {
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

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final registrationControllerProvider = StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return RegistrationNotifier(ref, authRepository, secureStorage);
});
