import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/models/user.dart';
import 'auth_controller.dart';

class RegistrationState {
  final int currentStep;
  final bool isLoading;
  final String? error;

  // Step 1: Account Details
  final String accountType;
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final String confirmPassword;

  // Step 2: Basic Profile
  final String gender;
  final DateTime? dob;
  final int? age;
  final String religion;
  final String caste;
  final String maritalStatus;
  final String bloodGroup;
  final String address;
  final List<String> hobbies;
  final String rashi;
  final String nakshatra;
  final bool manglik;

  // Step 3: Education
  final String qualification;
  final String occupation;
  final String annualIncome;
  final String country;
  final String state;
  final String city;
  final List<String> languages;

  // Step 4: Family Details
  final String fatherName;
  final String motherName;
  final int siblings;
  final String familyType;
  final String familyStatus;
  final String nativePlace;
  final String aboutFamily;

  // Step 5: Documents & Photos
  final String aadharNumber;
  final String aadharCardUrl;
  final String aadharCardName; // local file name picked
  final List<int>? aadharBytes; // raw bytes of picked file
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
    this.accountType = 'Self',
    this.fullName = '',
    this.phone = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.gender = 'Male',
    this.dob,
    this.age,
    this.religion = '',
    this.caste = '',
    this.maritalStatus = 'Single',
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
    this.familyType = 'Joint',
    this.familyStatus = 'Middle Class',
    this.nativePlace = '',
    this.aboutFamily = '',
    this.aadharNumber = '',
    this.aadharCardUrl = '',
    this.aadharCardName = '',
    this.aadharBytes,
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
    String? email,
    String? password,
    String? confirmPassword,
    String? gender,
    DateTime? dob,
    int? age,
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
    String? aadharCardName,
    List<int>? aadharBytes,
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
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      age: age ?? this.age,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      maritalStatus: maritalStatus ?? this.maritalStatus,
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
      aadharNumber: aadharNumber ?? this.aadharNumber,
      aadharCardUrl: aadharCardUrl ?? this.aadharCardUrl,
      aadharCardName: aadharCardName ?? this.aadharCardName,
      aadharBytes: aadharBytes ?? this.aadharBytes,
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
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    state = state.copyWith(
      accountType: accountType,
      fullName: fullName,
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  void updateStep2({
    String? gender,
    DateTime? dob,
    int? age,
    String? religion,
    String? caste,
    String? maritalStatus,
    String? bloodGroup,
    String? address,
    List<String>? hobbies,
    String? rashi,
    String? nakshatra,
    bool? manglik,
  }) {
    state = state.copyWith(
      gender: gender,
      dob: dob,
      age: age,
      religion: religion,
      caste: caste,
      maritalStatus: maritalStatus,
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
    String? fatherName,
    String? motherName,
    int? siblings,
    String? familyType,
    String? familyStatus,
    String? nativePlace,
    String? aboutFamily,
  }) {
    state = state.copyWith(
      fatherName: fatherName,
      motherName: motherName,
      siblings: siblings,
      familyType: familyType,
      familyStatus: familyStatus,
      nativePlace: nativePlace,
      aboutFamily: aboutFamily,
    );
  }

  void updateStep5({
    String? aadharNumber,
    String? aadharCardUrl,
    String? aadharCardName,
    List<int>? aadharBytes,
    List<String>? photos,
    List<Map<String, dynamic>>? pickedPhotosData,
  }) {
    state = state.copyWith(
      aadharNumber: aadharNumber,
      aadharCardUrl: aadharCardUrl,
      aadharCardName: aadharCardName,
      aadharBytes: aadharBytes,
      photos: photos,
      pickedPhotosData: pickedPhotosData,
    );
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
      String casteCertificateUrl = state.casteCertificateUrl;
      List<String> uploadedPhotos = List.from(state.photos);

      // If we have local documents/photos to upload, upload them to Cloudinary first
      if (state.aadharBytes != null || state.casteCertificateBytes != null || (state.pickedPhotosData != null && state.pickedPhotosData!.isNotEmpty)) {
        final uploadResult = await _authRepository.uploadFiles(
          aadharBytes: state.aadharBytes,
          aadharFileName: state.aadharCardName,
          casteBytes: state.casteCertificateBytes,
          casteFileName: state.casteCertificateName,
          photos: state.pickedPhotosData,
        );
        if (uploadResult['aadharUrl'] != null && uploadResult['aadharUrl'].toString().isNotEmpty) {
          aadharUrl = uploadResult['aadharUrl'];
        }
        if (uploadResult['casteCertificateUrl'] != null && uploadResult['casteCertificateUrl'].toString().isNotEmpty) {
          casteCertificateUrl = uploadResult['casteCertificateUrl'];
        }
        if (uploadResult['photoUrls'] != null) {
          final List<dynamic> urls = uploadResult['photoUrls'];
          uploadedPhotos.addAll(urls.map((u) => u.toString()));
        }
      }

      final data = {
        'accountType': state.accountType,
        'fullName': state.fullName,
        'phone': state.phone,
        'email': state.email,
        'password': state.password,
        'confirmPassword': state.confirmPassword,
        'gender': state.gender,
        'dob': state.dob?.toIso8601String(),
        'religion': state.religion,
        'caste': state.caste,
        'maritalStatus': state.maritalStatus,
        'bloodGroup': state.bloodGroup,
        'address': state.address,
        'hobbies': state.hobbies,
        'rashi': state.rashi,
        'nakshatra': state.nakshatra,
        'manglik': state.manglik,
        'qualification': state.qualification,
        'occupation': state.occupation,
        'annualIncome': state.annualIncome,
        'country': state.country,
        'state': state.state,
        'city': state.city,
        'languages': state.languages,
        'fatherName': state.fatherName,
        'motherName': state.motherName,
        'siblings': state.siblings,
        'familyType': state.familyType,
        'familyStatus': state.familyStatus,
        'nativePlace': state.nativePlace,
        'aboutFamily': state.aboutFamily,
        'aadharNumber': state.aadharNumber,
        'aadharCardUrl': aadharUrl,
        'casteCertificateUrl': casteCertificateUrl,
        'casteCertificateName': state.casteCertificateName,
        'photos': uploadedPhotos,
      };

      final result = await _authRepository.registerProfile(data);
      await _clearCasteCertificateFromStorage();
      final user = result['user'] as User;
      final token = result['token'] as String;

      final isAuthenticated = _ref.read(authControllerProvider).isAuthenticated;
      if (isAuthenticated) {
        _ref.read(authControllerProvider.notifier).setAuthenticatedState(user);
      }
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
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
