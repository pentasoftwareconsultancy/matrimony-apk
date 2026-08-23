import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/profile_repository.dart';
import '../../domain/models/profile_model.dart';

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

  ProfileController(this._repository)
      : super(ProfileState(
          profile: ProfileModel.empty(),
          completionPercentage: 0.0,
        )) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final loaded = await _repository.getProfile();
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
        current = current.copyWith(fatherEdu: value.toString());
        break;
      case 'motherOcc':
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
    }

    state = state.copyWith(
      profile: current,
      isDirty: true,
      validationErrors: errors,
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
      await _repository.saveProfile(state.profile);
      state = state.copyWith(
        isSaving: false,
        isDirty: false,
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

  Future<void> uploadPhoto(String sourcePathOrUrl) async {
    state = state.copyWith(isPhotoUploading: true, errorMessage: null);
    try {
      final uploadedUrl = await _repository.uploadPhoto(sourcePathOrUrl);
      final currentPhotos = List<String>.from(state.profile.photos);
      currentPhotos.add(uploadedUrl);
      final updatedProfile = state.profile.copyWith(photos: currentPhotos);

      state = state.copyWith(
        profile: updatedProfile,
        isPhotoUploading: false,
        isDirty: true,
        completionPercentage: updatedProfile.calculateCompletionPercentage(),
        successMessage: 'Photo uploaded successfully',
      );
    } catch (e) {
      state = state.copyWith(
        isPhotoUploading: false,
        errorMessage: 'Failed to upload photo. Please try again.',
      );
    }
  }

  void removePhoto(int index) {
    final currentPhotos = List<String>.from(state.profile.photos);
    if (index >= 0 && index < currentPhotos.length) {
      currentPhotos.removeAt(index);
      final updatedProfile = state.profile.copyWith(photos: currentPhotos);
      state = state.copyWith(
        profile: updatedProfile,
        isDirty: true,
        completionPercentage: updatedProfile.calculateCompletionPercentage(),
      );
    }
  }

  void reorderPhotos(int oldIndex, int newIndex) {
    final currentPhotos = List<String>.from(state.profile.photos);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = currentPhotos.removeAt(oldIndex);
    currentPhotos.insert(newIndex, item);
    final updatedProfile = state.profile.copyWith(photos: currentPhotos);
    state = state.copyWith(profile: updatedProfile, isDirty: true);
  }

  void updateDocumentStatus(String docId, String newStatus, {String? fileUrl}) {
    final docs = state.profile.documents.map((d) {
      if (d.id == docId) {
        return d.copyWith(status: newStatus, fileUrl: fileUrl ?? d.fileUrl, updatedAt: DateTime.now());
      }
      return d;
    }).toList();

    final updatedProfile = state.profile.copyWith(documents: docs);
    state = state.copyWith(
      profile: updatedProfile,
      isDirty: true,
      completionPercentage: updatedProfile.calculateCompletionPercentage(),
    );
  }

  void clearFeedback() {
    state = state.copyWith(errorMessage: null, successMessage: null);
  }
}

final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final repo = ref.watch(profileRepositoryProvider);
  return ProfileController(repo);
});
