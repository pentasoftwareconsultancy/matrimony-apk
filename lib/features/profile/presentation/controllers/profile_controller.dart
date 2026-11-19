import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/models/profile_model.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/domain/models/user.dart';

class ProfileState {
  final ProfileModel profile;
  final bool isDirty;
  final bool isLoading;
  final bool isSaving;
  final bool isPhotoUploading;
  final String? errorMessage;
  final String? successMessage;
  final Map<String, String> validationErrors;
  final double completionPercentage;

  ProfileState({
    required this.profile,
    this.isDirty = false,
    this.isLoading = false,
    this.isSaving = false,
    this.isPhotoUploading = false,
    this.errorMessage,
    this.successMessage,
    this.validationErrors = const {},
    required this.completionPercentage,
  });

  ProfileState copyWith({
    ProfileModel? profile,
    bool? isDirty,
    bool? isLoading,
    bool? isSaving,
    bool? isPhotoUploading,
    String? errorMessage,
    String? successMessage,
    Map<String, String>? validationErrors,
    double? completionPercentage,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isDirty: isDirty ?? this.isDirty,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isPhotoUploading: isPhotoUploading ?? this.isPhotoUploading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      validationErrors: validationErrors ?? this.validationErrors,
      completionPercentage: completionPercentage ?? this.completionPercentage,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  final ProfileRepository _repository;
  final Ref _ref;

  ProfileController(this._repository, this._ref)
      : super(ProfileState(
    profile: ProfileModel.empty(),
    completionPercentage: 0.0,
  )) {
    loadProfile();
  }

  void _syncUserWithProfile(Map<String, dynamic> profileMap, ProfileModel profileModel) {
    try {
      final cleanMap = Map<String, dynamic>.from(profileMap);
      if (cleanMap['_id'] == null && cleanMap['id'] != null) {
        cleanMap['_id'] = cleanMap['id'];
      }
      cleanMap['profileCompleted'] ??= true;
      cleanMap['isVerified'] ??= false;
      cleanMap['isPremium'] ??= false;
      cleanMap['role'] ??= 'user';
      if (cleanMap['dob'] != null && cleanMap['dob'] is! String) {
        cleanMap['dob'] = cleanMap['dob'].toString();
      }
      final updatedUser = User.fromJson(cleanMap);
      _ref.read(authControllerProvider.notifier).updateUser(updatedUser);
    } catch (_) {
      final currentUser = _ref.read(authControllerProvider).user;
      if (currentUser != null) {
        final updatedUser = currentUser.copyWith(
          fullName: profileModel.fullName.isNotEmpty ? profileModel.fullName : currentUser.fullName,
          age: profileModel.age > 0 ? profileModel.age : currentUser.age,
          maritalStatus: profileModel.maritalStatus.isNotEmpty ? profileModel.maritalStatus : currentUser.maritalStatus,
          occupation: profileModel.occupation.isNotEmpty ? profileModel.occupation : currentUser.occupation,
          annualIncome: profileModel.income.isNotEmpty ? profileModel.income : currentUser.annualIncome,
          state: profileModel.state.isNotEmpty ? profileModel.state : currentUser.state,
          city: profileModel.workPlace.isNotEmpty ? profileModel.workPlace : currentUser.city,
          religion: profileModel.religion.isNotEmpty ? profileModel.religion : currentUser.religion,
          caste: profileModel.caste.isNotEmpty ? profileModel.caste : currentUser.caste,
          photos: profileModel.photos.isNotEmpty ? profileModel.photos : currentUser.photos,
          phone: profileModel.phone.isNotEmpty ? profileModel.phone : currentUser.phone,
          email: profileModel.email.isNotEmpty ? profileModel.email : currentUser.email,
          hobbies: profileModel.hobbies.isNotEmpty ? profileModel.hobbies : currentUser.hobbies,
          address: profileModel.homePlace.isNotEmpty ? profileModel.homePlace : currentUser.address,
          fatherName: profileModel.fatherName.isNotEmpty ? profileModel.fatherName : currentUser.fatherName,
          motherName: profileModel.motherName.isNotEmpty ? profileModel.motherName : currentUser.motherName,
          familyType: profileModel.familyType.isNotEmpty ? profileModel.familyType : currentUser.familyType,
        );
        _ref.read(authControllerProvider.notifier).updateUser(updatedUser);
      }
    }
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final profileMap = await _repository.getProfileData();
      final loaded = ProfileModel.fromJson(profileMap);
      _syncUserWithProfile(profileMap, loaded);
      state = ProfileState(
        profile: loaded,
        isDirty: false,
        isLoading: false,
        completionPercentage: loaded.calculateCompletionPercentage(),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load profile details.',
      );
    }
  }

  void updateField(String key, dynamic value) {
    ProfileModel current = state.profile;
    Map<String, String> errors = Map.from(state.validationErrors);
    errors.remove(key);

    switch (key) {
    // Summary
      case 'fullName':
        if (value.toString().trim().length < 2) {
          errors['fullName'] = 'Name must be at least 2 characters';
        }
        current = current.copyWith(fullName: value.toString());
        break;
      case 'age':
        final parsedAge = int.tryParse(value.toString());
        if (parsedAge == null || parsedAge < 18 || parsedAge > 100) {
          errors['age'] = 'Age must be between 18 and 100';
        }
        current = current.copyWith(age: parsedAge ?? current.age);
        break;
      case 'aboutMe':
        current = current.copyWith(aboutMe: value.toString());
        break;

    // Personal Details
      case 'birthDate':
        current = current.copyWith(birthDate: value.toString());
        break;
      case 'workPlace':
        current = current.copyWith(workPlace: value.toString());
        break;
      case 'homePlace':
        current = current.copyWith(homePlace: value.toString());
        break;
      case 'maritalStatus':
        current = current.copyWith(maritalStatus: value.toString());
        break;
      case 'income':
        current = current.copyWith(income: value.toString());
        break;
      case 'village':
        current = current.copyWith(village: value.toString());
        break;
      case 'state':
        current = current.copyWith(state: value.toString());
        break;
      case 'pincode':
        final pin = value.toString().trim();
        if (pin.isNotEmpty && (pin.length < 5 || pin.length > 6 || int.tryParse(pin) == null)) {
          errors['pincode'] = 'Enter a valid pincode';
        }
        current = current.copyWith(pincode: pin);
        break;
      case 'occupation':
        current = current.copyWith(occupation: value.toString());
        break;
      case 'children':
        current = current.copyWith(children: int.tryParse(value.toString()) ?? 0);
        break;
      case 'complexion':
        current = current.copyWith(complexion: value.toString());
        break;
      case 'bodyType':
        current = current.copyWith(bodyType: value.toString());
        break;
      case 'diet':
        current = current.copyWith(diet: value.toString());
        break;
      case 'specialCase':
        current = current.copyWith(specialCase: value.toString());
        break;
      case 'drinkingSmoking':
        current = current.copyWith(drinkingSmoking: value.toString());
        break;
      case 'motherTongue':
        current = current.copyWith(motherTongue: value.toString());
        break;
      case 'phone':
        final ph = value.toString().trim();
        if (ph.isNotEmpty && ph.length < 10) {
          errors['phone'] = 'Enter a valid 10-digit phone number';
        }
        current = current.copyWith(phone: ph);
        break;
      case 'altPhone':
        current = current.copyWith(altPhone: value.toString());
        break;
      case 'email':
        final emailStr = value.toString().trim();
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (emailStr.isNotEmpty && !emailRegex.hasMatch(emailStr)) {
          errors['email'] = 'Enter a valid email address';
        }
        current = current.copyWith(email: emailStr);
        break;
      case 'hobbies':
        if (value is List<String>) {
          current = current.copyWith(hobbies: value);
        } else if (value is String) {
          current = current.copyWith(hobbies: value.split(',').map((e) => e.trim()).toList());
        }
        break;
      case 'religion':
        current = current.copyWith(religion: value.toString());
        break;
      case 'agriLand':
        current = current.copyWith(agriLand: value.toString());
        break;
      case 'weight':
        current = current.copyWith(weight: value.toString());
        break;
      case 'height':
        current = current.copyWith(height: value.toString());
        break;
      case 'caste':
        current = current.copyWith(caste: value.toString());
        break;

    // Educational
      case 'highestEdu':
        current = current.copyWith(highestEdu: value.toString());
        break;
      case 'profession':
        current = current.copyWith(profession: value.toString());
        break;
      case 'university':
        current = current.copyWith(university: value.toString());
        break;
      case 'organization':
        current = current.copyWith(organization: value.toString());
        break;
      case 'companyAddress':
        current = current.copyWith(companyAddress: value.toString());
        break;
      case 'eduField':
        current = current.copyWith(eduField: value.toString());
        break;
      case 'designation':
        current = current.copyWith(designation: value.toString());
        break;

    // Horoscope
      case 'birthTime':
        current = current.copyWith(birthTime: value.toString());
        break;
      case 'rashi':
        current = current.copyWith(rashi: value.toString());
        break;
      case 'charan':
        current = current.copyWith(charan: value.toString());
        break;
      case 'nakshatra':
        current = current.copyWith(nakshatra: value.toString());
        break;
      case 'placeOfBirth':
        current = current.copyWith(placeOfBirth: value.toString());
        break;
      case 'gotra':
        current = current.copyWith(gotra: value.toString());
        break;
      case 'manglik':
        current = current.copyWith(manglik: value.toString());
        break;
      case 'gan':
        current = current.copyWith(gan: value.toString());
        break;
      case 'partnerPriority':
        current = current.copyWith(partnerPriority: value.toString());
        break;

    // Family Details
      case 'fatherName':
        current = current.copyWith(fatherName: value.toString());
        break;
      case 'motherName':
        current = current.copyWith(motherName: value.toString());
        break;
      case 'brothers':
        current = current.copyWith(brothers: value.toString());
        break;
      case 'maternalUncle':
        current = current.copyWith(maternalUncle: value.toString());
        break;
      case 'unclePhone':
        current = current.copyWith(unclePhone: value.toString());
        break;
      case 'fatherEdu':
      case 'fatherOccupation':
        current = current.copyWith(fatherEdu: value.toString());
        break;
      case 'motherOcc':
      case 'motherOccupation':
        current = current.copyWith(motherOcc: value.toString());
        break;
      case 'sisters':
        current = current.copyWith(sisters: value.toString());
        break;
      case 'familyType':
        current = current.copyWith(familyType: value.toString());
        break;
      case 'familyValues':
        current = current.copyWith(familyValues: value.toString());
        break;
      case 'marriedSister':
        current = current.copyWith(marriedSister: value.toString());
        break;
      case 'uncleName':
        current = current.copyWith(uncleName: value.toString());
        break;
      case 'brothersDetails':
        if (value is List<BrotherDetail>) {
          current = current.copyWith(
            brothersDetails: value,
            brothers: value.length.toString(),
          );
        }
        break;
      case 'sistersDetails':
        if (value is List<SisterDetail>) {
          final mCount = value.where((s) => s.isMarried).length;
          current = current.copyWith(
            sistersDetails: value,
            sisters: value.length.toString(),
            marriedSister: mCount.toString(),
          );
        }
        break;
      case 'maternalUnclesDetails':
        if (value is List<UncleDetail>) {
          current = current.copyWith(
            maternalUnclesDetails: value,
            maternalUncle: value.isNotEmpty ? value.first.name : '',
          );
        }
        break;
      case 'unclesDetails':
        if (value is List<UncleDetail>) {
          current = current.copyWith(
            unclesDetails: value,
            uncleName: value.isNotEmpty ? value.first.name : '',
          );
        }
        break;
    }

    state = state.copyWith(
      profile: current,
      isDirty: true,
      validationErrors: errors,
      completionPercentage: current.calculateCompletionPercentage(),
    );
  }

  void updateBrothers(List<BrotherDetail> brothers) {
    final current = state.profile.copyWith(
      brothersDetails: brothers,
      brothers: brothers.length.toString(),
    );
    state = state.copyWith(
      profile: current,
      isDirty: true,
      completionPercentage: current.calculateCompletionPercentage(),
    );
  }

  void updateSisters(List<SisterDetail> sisters) {
    final marriedCount = sisters.where((s) => s.isMarried).length;
    final current = state.profile.copyWith(
      sistersDetails: sisters,
      sisters: sisters.length.toString(),
      marriedSister: marriedCount.toString(),
    );
    state = state.copyWith(
      profile: current,
      isDirty: true,
      completionPercentage: current.calculateCompletionPercentage(),
    );
  }

  void updateMaternalUncles(List<UncleDetail> uncles) {
    final current = state.profile.copyWith(
      maternalUnclesDetails: uncles,
      maternalUncle: uncles.isNotEmpty ? uncles.first.name : '',
    );
    state = state.copyWith(
      profile: current,
      isDirty: true,
      completionPercentage: current.calculateCompletionPercentage(),
    );
  }

  void updateUncles(List<UncleDetail> uncles) {
    final current = state.profile.copyWith(
      unclesDetails: uncles,
      uncleName: uncles.isNotEmpty ? uncles.first.name : '',
    );
    state = state.copyWith(
      profile: current,
      isDirty: true,
      completionPercentage: current.calculateCompletionPercentage(),
    );
  }

  Future<bool> saveProfile() async {
    if (state.validationErrors.isNotEmpty) {
      state = state.copyWith(
        errorMessage: 'Please fix validation errors before saving.',
      );
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);
    try {
      final profileMap = await _repository.saveProfile(state.profile);
      final updatedProfile = ProfileModel.fromJson(profileMap);
      _syncUserWithProfile(profileMap, updatedProfile);

      state = state.copyWith(
        profile: updatedProfile,
        isSaving: false,
        isDirty: false,
        completionPercentage: updatedProfile.calculateCompletionPercentage(),
        successMessage: 'Profile updated successfully',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Unable to update profile. Please try again.',
      );
      return false;
    }
  }

  Future<void> uploadPhoto(XFile file) async {
    if (state.profile.photos.length >= 6) {
      state = state.copyWith(
        errorMessage: 'Maximum 6 profile photos are allowed.',
      );
      return;
    }

    state = state.copyWith(
      isPhotoUploading: true,
      errorMessage: null,
      successMessage: null,
    );

    try {
      final uploadedUrl = await _repository.uploadPhoto(file);
      final currentPhotos = List<String>.from(state.profile.photos);

      if (!currentPhotos.contains(uploadedUrl)) {
        currentPhotos.add(uploadedUrl);
      }

      final updatedProfile = state.profile.copyWith(photos: currentPhotos);

      try {
        final currentUser = _ref.read(authControllerProvider).user;
        if (currentUser != null) {
          _ref.read(authControllerProvider.notifier).updateUser(
            currentUser.copyWith(photos: currentPhotos),
          );
        }
      } catch (_) {}

      state = state.copyWith(
        profile: updatedProfile,
        isPhotoUploading: false,
        // Preserve any unrelated unsaved profile edits.
        isDirty: state.isDirty,
        completionPercentage: updatedProfile.calculateCompletionPercentage(),
        successMessage: 'Photo uploaded successfully.',
      );
    } catch (e) {
      state = state.copyWith(
        isPhotoUploading: false,
        errorMessage: 'Failed to upload photo: $e',
      );
    }
  }


  Future<void> removePhoto(int index) async {
    final currentPhotos = List<String>.from(state.profile.photos);

    if (index < 0 || index >= currentPhotos.length) {
      return;
    }

    final photoUrl = currentPhotos[index];
    currentPhotos.removeAt(index);

    // Update the UI immediately.
    final updatedProfile = state.profile.copyWith(photos: currentPhotos);

    try {
      final currentUser = _ref.read(authControllerProvider).user;
      if (currentUser != null) {
        _ref.read(authControllerProvider.notifier).updateUser(
          currentUser.copyWith(photos: currentPhotos),
        );
      }
    } catch (_) {}

    state = state.copyWith(
      profile: updatedProfile,
      errorMessage: null,
      successMessage: null,
      completionPercentage: updatedProfile.calculateCompletionPercentage(),
    );

    try {
      // Confirm the deletion on the backend.
      await _repository.deletePhoto(photoUrl);

      state = state.copyWith(
        successMessage: 'Photo deleted successfully.',
      );
    } catch (e) {
      // Restore the photo if the backend deletion fails.
      final latestPhotos = List<String>.from(state.profile.photos);

      if (!latestPhotos.contains(photoUrl)) {
        final restoreIndex = index.clamp(0, latestPhotos.length);
        latestPhotos.insert(restoreIndex, photoUrl);
      }

      final restoredProfile = state.profile.copyWith(photos: latestPhotos);

      try {
        final currentUser = _ref.read(authControllerProvider).user;
        if (currentUser != null) {
          _ref.read(authControllerProvider.notifier).updateUser(
            currentUser.copyWith(photos: latestPhotos),
          );
        }
      } catch (_) {}

      state = state.copyWith(
        profile: restoredProfile,
        errorMessage: 'Unable to delete photo. It has been restored. Please try again.',
        completionPercentage: restoredProfile.calculateCompletionPercentage(),
      );
    }
  }


  void reorderPhotos(int oldIndex, int newIndex) {
    final currentPhotos = List<String>.from(state.profile.photos);

    if (oldIndex < 0 ||
        oldIndex >= currentPhotos.length ||
        newIndex < 0 ||
        newIndex > currentPhotos.length) {
      return;
    }

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = currentPhotos.removeAt(oldIndex);
    currentPhotos.insert(newIndex, item);

    final updatedProfile = state.profile.copyWith(photos: currentPhotos);

    try {
      final currentUser = _ref.read(authControllerProvider).user;
      if (currentUser != null) {
        _ref.read(authControllerProvider.notifier).updateUser(
          currentUser.copyWith(photos: currentPhotos),
        );
      }
    } catch (_) {}

    state = state.copyWith(profile: updatedProfile, isDirty: true);
  }

  Future<bool> uploadDocumentFile(String docId, List<int> bytes, String fileName) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);
    try {
      final savedProfileMap = await _repository.uploadDocumentFile(docId, bytes, fileName);
      final updatedProfile = ProfileModel.fromJson(savedProfileMap);
      _syncUserWithProfile(savedProfileMap, updatedProfile);
      state = state.copyWith(
        profile: updatedProfile,
        isSaving: false,
        completionPercentage: updatedProfile.calculateCompletionPercentage(),
        successMessage: 'Document uploaded. Verification pending.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to upload document: ${e.toString().replaceAll('Exception: ', '')}',
      );
      return false;
    }
  }

  Future<bool> removeDocument(String docId) async {
    state = state.copyWith(isSaving: true, errorMessage: null, successMessage: null);
    try {
      final savedProfileMap = await _repository.deleteDocument(docId);
      final updatedProfile = ProfileModel.fromJson(savedProfileMap);
      _syncUserWithProfile(savedProfileMap, updatedProfile);
      state = state.copyWith(
        profile: updatedProfile,
        isSaving: false,
        completionPercentage: updatedProfile.calculateCompletionPercentage(),
        successMessage: 'Document removed successfully.',
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to remove document: ${e.toString().replaceAll('Exception: ', '')}',
      );
      return false;
    }
  }

  void clearFeedback() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

final profileControllerProvider =
StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileController(repo, ref);
});
