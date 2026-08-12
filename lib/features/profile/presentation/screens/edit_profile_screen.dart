import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/profile_controller.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_summary_card.dart';
import '../widgets/profile_section_card.dart';
import '../widgets/profile_field_row.dart';
import '../widgets/document_row.dart';
import '../widgets/edit_field_dialog.dart';
import '../widgets/photo_management_dialog.dart';
import '../widgets/document_action_sheet.dart';
import '../../../home/presentation/controllers/home_controller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _openEditDialog({
    required String title,
    required String fieldKey,
    required dynamic initialValue,
    required FieldType fieldType,
    List<String>? options,
    String? Function(String?)? validator,
  }) async {
    final result = await EditFieldDialog.show(
      context: context,
      title: title,
      fieldKey: fieldKey,
      initialValue: initialValue,
      fieldType: fieldType,
      options: options,
      validator: validator,
    );

    if (result != null) {
      ref.read(profileControllerProvider.notifier).updateField(fieldKey, result);
    }
  }

  void _showPhotoOptions() {
    final state = ref.read(profileControllerProvider);
    PhotoManagementDialog.showOptions(
      context: context,
      photos: state.profile.photos,
      onUploadPhoto: (url) {
        ref.read(profileControllerProvider.notifier).uploadPhoto(url);
      },
      onRemovePhoto: (idx) {
        ref.read(profileControllerProvider.notifier).removePhoto(idx);
      },
      onReorderPhotos: (oldIdx, newIdx) {
        ref.read(profileControllerProvider.notifier).reorderPhotos(oldIdx, newIdx);
      },
    );
  }

  void _showDocumentOptions(dynamic doc) {
    DocumentActionSheet.show(
      context: context,
      document: doc,
      onUpdateStatus: (docId, newStatus, {fileUrl}) {
        ref.read(profileControllerProvider.notifier).updateDocumentStatus(
              docId,
              newStatus,
              fileUrl: fileUrl,
            );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileControllerProvider);
    final profile = state.profile;
    final controller = ref.read(profileControllerProvider.notifier);

    // Show feedback snackbars
    ref.listen<ProfileState>(profileControllerProvider, (prev, next) {
      if (next.successMessage != null && prev?.successMessage != next.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: const Color(0xFF2E7D32),
            duration: const Duration(seconds: 2),
          ),
        );
        controller.clearFeedback();
      }
      if (next.errorMessage != null && prev?.errorMessage != next.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red.shade700,
            duration: const Duration(seconds: 3),
          ),
        );
        controller.clearFeedback();
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9), // Warm off-white background matching reference
      appBar: ProfileHeader(
        onBackTap: () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          } else {
            ref.read(homeControllerProvider.notifier).setBottomTab(3);
            context.go('/profile');
          }
        },
        onEditIconTap: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
      ),
      body: Stack(
        children: [
          // Scrollable Profile Details Content
          Positioned.fill(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.only(bottom: 120), // Spacing for floating bottom bar
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Summary Section
                  ProfileSummaryCard(
                    profile: profile,
                    onPhotoTap: _showPhotoOptions,
                    onThumbnailTap: (idx) => _showPhotoOptions(),
                    onEditBioTap: () {
                      _openEditDialog(
                        title: 'About Me',
                        fieldKey: 'aboutMe',
                        initialValue: profile.aboutMe,
                        fieldType: FieldType.text,
                      );
                    },
                  ),

                  // 1. PERSONAL DETAILS SECTION
                  ProfileSectionCard(
                    title: 'PERSONAL DETAILS',
                    children: [
                      ProfileFieldRow(
                        label: 'NAME',
                        value: profile.fullName,
                        onTap: () => _openEditDialog(
                          title: 'Full Name',
                          fieldKey: 'fullName',
                          initialValue: profile.fullName,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'AGE',
                        value: '${profile.age}',
                        onTap: () => _openEditDialog(
                          title: 'Age',
                          fieldKey: 'age',
                          initialValue: profile.age,
                          fieldType: FieldType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Age is required';
                            final n = int.tryParse(val.trim());
                            if (n == null || n < 18 || n > 100) return 'Age must be between 18 and 100';
                            return null;
                          },
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'BIRTH DATE',
                        value: profile.birthDate,
                        onTap: () => _openEditDialog(
                          title: 'Birth Date',
                          fieldKey: 'birthDate',
                          initialValue: profile.birthDate,
                          fieldType: FieldType.date,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'WORK PLACE',
                        value: profile.workPlace,
                        onTap: () => _openEditDialog(
                          title: 'Work Place',
                          fieldKey: 'workPlace',
                          initialValue: profile.workPlace,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'HOME PLACE',
                        value: profile.homePlace,
                        onTap: () => _openEditDialog(
                          title: 'Home Place',
                          fieldKey: 'homePlace',
                          initialValue: profile.homePlace,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'MARITAL STATUS',
                        value: profile.maritalStatus,
                        onTap: () => _openEditDialog(
                          title: 'Marital Status',
                          fieldKey: 'maritalStatus',
                          initialValue: profile.maritalStatus,
                          fieldType: FieldType.singleSelect,
                          options: ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'INCOME',
                        value: profile.income,
                        onTap: () => _openEditDialog(
                          title: 'Annual Income',
                          fieldKey: 'income',
                          initialValue: profile.income,
                          fieldType: FieldType.singleSelect,
                          options: [
                            '03,00,000 LPA',
                            '05,00,000 LPA',
                            '07,50,000 LPA',
                            '10,00,000 LPA',
                            '15,00,000 LPA',
                            '25,00,000+ LPA'
                          ],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'VILLAGE',
                        value: profile.village,
                        onTap: () => _openEditDialog(
                          title: 'Village',
                          fieldKey: 'village',
                          initialValue: profile.village,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'STATE',
                        value: profile.state,
                        onTap: () => _openEditDialog(
                          title: 'State',
                          fieldKey: 'state',
                          initialValue: profile.state,
                          fieldType: FieldType.searchableSelect,
                          options: [
                            'Kerala',
                            'Tamil Nadu',
                            'Maharashtra',
                            'Karnataka',
                            'Gujarat',
                            'Rajasthan',
                            'Delhi',
                            'Punjab',
                            'Uttar Pradesh',
                            'West Bengal'
                          ],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'PINCODE',
                        value: profile.pincode,
                        onTap: () => _openEditDialog(
                          title: 'Pincode',
                          fieldKey: 'pincode',
                          initialValue: profile.pincode,
                          fieldType: FieldType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Pincode is required';
                            if (!RegExp(r'^\d{6}$').hasMatch(val.trim())) return 'Pincode must be 6 digits';
                            return null;
                          },
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'OCCUPATION',
                        value: profile.occupation,
                        onTap: () => _openEditDialog(
                          title: 'Occupation',
                          fieldKey: 'occupation',
                          initialValue: profile.occupation,
                          fieldType: FieldType.searchableSelect,
                          options: [
                            'Software Engineer',
                            'Chartered Accountant',
                            'Doctor (MD/MBBS)',
                            'Architect',
                            'Bank Manager',
                            'Civil Engineer',
                            'Teacher/Professor',
                            'Business Owner',
                            'Government Officer'
                          ],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'NO. OF CHILDREN',
                        value: '${profile.children}',
                        onTap: () => _openEditDialog(
                          title: 'Number of Children',
                          fieldKey: 'children',
                          initialValue: profile.children,
                          fieldType: FieldType.singleSelect,
                          options: ['0', '1', '2', '3+'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'COMPLEXION',
                        value: profile.complexion,
                        onTap: () => _openEditDialog(
                          title: 'Complexion',
                          fieldKey: 'complexion',
                          initialValue: profile.complexion,
                          fieldType: FieldType.singleSelect,
                          options: ['Fair', 'Very Fair', 'Wheatish', 'Dark'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'BODY TYPE',
                        value: profile.bodyType,
                        onTap: () => _openEditDialog(
                          title: 'Body Type',
                          fieldKey: 'bodyType',
                          initialValue: profile.bodyType,
                          fieldType: FieldType.singleSelect,
                          options: ['Slim', 'Athletic', 'Average', 'Heavy'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'DIET',
                        value: profile.diet,
                        onTap: () => _openEditDialog(
                          title: 'Diet',
                          fieldKey: 'diet',
                          initialValue: profile.diet,
                          fieldType: FieldType.singleSelect,
                          options: ['Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Vegan'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'SPECIAL CASE',
                        value: profile.specialCase,
                        onTap: () => _openEditDialog(
                          title: 'Special Case',
                          fieldKey: 'specialCase',
                          initialValue: profile.specialCase,
                          fieldType: FieldType.singleSelect,
                          options: ['No', 'Physically Challenged', 'Visually Impaired', 'Hearing Impaired'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'DRINKING/SMOKING',
                        value: profile.drinkingSmoking,
                        onTap: () => _openEditDialog(
                          title: 'Drinking / Smoking',
                          fieldKey: 'drinkingSmoking',
                          initialValue: profile.drinkingSmoking,
                          fieldType: FieldType.singleSelect,
                          options: ['No', 'Yes', 'Occasionally'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'MOTHER TONGUE',
                        value: profile.motherTongue,
                        onTap: () => _openEditDialog(
                          title: 'Mother Tongue',
                          fieldKey: 'motherTongue',
                          initialValue: profile.motherTongue,
                          fieldType: FieldType.searchableSelect,
                          options: [
                            'Marathi',
                            'Hindi',
                            'Gujarati',
                            'Tamil',
                            'Malayalam',
                            'Telugu',
                            'Kannada',
                            'Bengali',
                            'Punjabi',
                            'English'
                          ],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'PHONE NUMBER',
                        value: profile.phone,
                        onTap: () => _openEditDialog(
                          title: 'Phone Number',
                          fieldKey: 'phone',
                          initialValue: profile.phone,
                          fieldType: FieldType.number,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Phone number is required';
                            if (!RegExp(r'^\d{10}$').hasMatch(val.trim())) return 'Phone number must be exactly 10 digits';
                            return null;
                          },
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'ALT. PHONE',
                        value: profile.altPhone,
                        onTap: () => _openEditDialog(
                          title: 'Alternate Phone Number',
                          fieldKey: 'altPhone',
                          initialValue: profile.altPhone,
                          fieldType: FieldType.number,
                          validator: (val) {
                            if (val != null && val.trim().isNotEmpty && !RegExp(r'^\d{10}$').hasMatch(val.trim())) {
                              return 'Alt phone number must be 10 digits';
                            }
                            return null;
                          },
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'EMAIL',
                        value: profile.email,
                        onTap: () => _openEditDialog(
                          title: 'Email Address',
                          fieldKey: 'email',
                          initialValue: profile.email,
                          fieldType: FieldType.text,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Email is required';
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+com$', caseSensitive: false).hasMatch(val.trim())) {
                              return 'Email must be a valid address ending with .com';
                            }
                            return null;
                          },
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'HOBBIES',
                        value: profile.hobbies.join(', '),
                        onTap: () => _openEditDialog(
                          title: 'Hobbies',
                          fieldKey: 'hobbies',
                          initialValue: profile.hobbies,
                          fieldType: FieldType.multiSelect,
                          options: [
                            'Painting',
                            'cooking',
                            'dancing',
                            'Reading',
                            'Travelling',
                            'Music',
                            'Sports',
                            'Photography',
                            'Yoga',
                            'Gardening'
                          ],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'RELIGION',
                        value: profile.religion,
                        onTap: () => _openEditDialog(
                          title: 'Religion',
                          fieldKey: 'religion',
                          initialValue: profile.religion,
                          fieldType: FieldType.searchableSelect,
                          options: ['Hindu', 'Muslim', 'Christian', 'Sikh', 'Jain', 'Buddhist'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'AGRI. LAND',
                        value: profile.agriLand,
                        onTap: () => _openEditDialog(
                          title: 'Agricultural Land',
                          fieldKey: 'agriLand',
                          initialValue: profile.agriLand,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'WEIGHT',
                        value: profile.weight,
                        onTap: () => _openEditDialog(
                          title: 'Weight',
                          fieldKey: 'weight',
                          initialValue: profile.weight,
                          fieldType: FieldType.singleSelect,
                          options: ['50 kg', '55 kg', '60 kg', '65 kg', '70 kg', '75 kg', '80 kg'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'HEIGHT',
                        value: profile.height,
                        onTap: () => _openEditDialog(
                          title: 'Height',
                          fieldKey: 'height',
                          initialValue: profile.height,
                          fieldType: FieldType.heightPicker,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'CASTE',
                        value: profile.caste,
                        isLast: true,
                        onTap: () => _openEditDialog(
                          title: 'Caste',
                          fieldKey: 'caste',
                          initialValue: profile.caste,
                          fieldType: FieldType.searchableSelect,
                          options: ['Hindu', 'Kunbi', 'Brahmin', 'Maratha', 'Nair', 'Ezhava', 'Lingayat', 'Rajput'],
                        ),
                      ),
                    ],
                  ),

                  // 2. EDUCATIONAL DETAILS SECTION
                  ProfileSectionCard(
                    title: 'EDUCATIONAL DETAILS',
                    children: [
                      ProfileFieldRow(
                        label: 'HIGHEST EDU',
                        value: profile.highestEdu,
                        onTap: () => _openEditDialog(
                          title: 'Highest Education',
                          fieldKey: 'highestEdu',
                          initialValue: profile.highestEdu,
                          fieldType: FieldType.singleSelect,
                          options: ['MBA', 'B.Tech', 'M.Tech', 'MBBS', 'Ph.D', 'B.Com', 'M.Com', 'B.Sc'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'PROFESSION',
                        value: profile.profession,
                        onTap: () => _openEditDialog(
                          title: 'Profession',
                          fieldKey: 'profession',
                          initialValue: profile.profession,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'UNIVERSITY',
                        value: profile.university,
                        onTap: () => _openEditDialog(
                          title: 'University',
                          fieldKey: 'university',
                          initialValue: profile.university,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'ORGANIZATION',
                        value: profile.organization,
                        onTap: () => _openEditDialog(
                          title: 'Organization / Company',
                          fieldKey: 'organization',
                          initialValue: profile.organization,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'COMPANY ADDRESS',
                        value: profile.companyAddress,
                        onTap: () => _openEditDialog(
                          title: 'Company Address',
                          fieldKey: 'companyAddress',
                          initialValue: profile.companyAddress,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'EDU. FIELD',
                        value: profile.eduField,
                        onTap: () => _openEditDialog(
                          title: 'Education Field',
                          fieldKey: 'eduField',
                          initialValue: profile.eduField,
                          fieldType: FieldType.singleSelect,
                          options: ['IT', 'Engineering', 'Management', 'Medical', 'Finance', 'Arts', 'Science'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'DESIGNATION',
                        value: profile.designation,
                        isLast: true,
                        onTap: () => _openEditDialog(
                          title: 'Designation',
                          fieldKey: 'designation',
                          initialValue: profile.designation,
                          fieldType: FieldType.text,
                        ),
                      ),
                    ],
                  ),

                  // 3. HOROSCOPE SECTION
                  ProfileSectionCard(
                    title: 'HOROSCOPE',
                    children: [
                      ProfileFieldRow(
                        label: 'BIRTH TIME',
                        value: profile.birthTime,
                        onTap: () => _openEditDialog(
                          title: 'Birth Time',
                          fieldKey: 'birthTime',
                          initialValue: profile.birthTime,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'RASHI',
                        value: profile.rashi,
                        onTap: () => _openEditDialog(
                          title: 'Rashi',
                          fieldKey: 'rashi',
                          initialValue: profile.rashi,
                          fieldType: FieldType.singleSelect,
                          options: [
                            'Simha (Leo)',
                            'Mesh (Aries)',
                            'Vrishabh (Taurus)',
                            'Mithun (Gemini)',
                            'Kark (Cancer)',
                            'Kanya (Virgo)',
                            'Tula (Libra)',
                            'Vrishchik (Scorpio)',
                            'Dhanu (Sagittarius)',
                            'Makar (Capricorn)',
                            'Kumbh (Aquarius)',
                            'Meen (Pisces)'
                          ],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'CHARAN',
                        value: profile.charan,
                        onTap: () => _openEditDialog(
                          title: 'Charan',
                          fieldKey: 'charan',
                          initialValue: profile.charan,
                          fieldType: FieldType.singleSelect,
                          options: ['1', '2', '3', '4'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'NAKSHATRA',
                        value: profile.nakshatra,
                        onTap: () => _openEditDialog(
                          title: 'Nakshatra',
                          fieldKey: 'nakshatra',
                          initialValue: profile.nakshatra,
                          fieldType: FieldType.searchableSelect,
                          options: [
                            'Magha',
                            'Ashwini',
                            'Bharani',
                            'Krittika',
                            'Rohini',
                            'Mrigashira',
                            'Ardra',
                            'Punarvasu',
                            'Pushya',
                            'Ashlesha'
                          ],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'PLACE OF BIRTH',
                        value: profile.placeOfBirth,
                        onTap: () => _openEditDialog(
                          title: 'Place of Birth',
                          fieldKey: 'placeOfBirth',
                          initialValue: profile.placeOfBirth,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'GOTRA',
                        value: profile.gotra,
                        onTap: () => _openEditDialog(
                          title: 'Gotra',
                          fieldKey: 'gotra',
                          initialValue: profile.gotra,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'MANGLIK',
                        value: profile.manglik,
                        onTap: () => _openEditDialog(
                          title: 'Manglik Status',
                          fieldKey: 'manglik',
                          initialValue: profile.manglik,
                          fieldType: FieldType.singleSelect,
                          options: ['No', 'Yes', 'Anshik/Partial'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'GAN',
                        value: profile.gan,
                        onTap: () => _openEditDialog(
                          title: 'Gan',
                          fieldKey: 'gan',
                          initialValue: profile.gan,
                          fieldType: FieldType.singleSelect,
                          options: ['Rakshasa', 'Deva', 'Manushya'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'PARTNER PRIORITY',
                        value: profile.partnerPriority,
                        isSpecialFormat: true,
                        isLast: true,
                        onTap: () => _openEditDialog(
                          title: 'Partner Priority',
                          fieldKey: 'partnerPriority',
                          initialValue: profile.partnerPriority,
                          fieldType: FieldType.singleSelect,
                          options: ['✨ High', 'Medium', 'Low'],
                        ),
                      ),
                    ],
                  ),

                  // 4. FAMILY DETAILS SECTION
                  ProfileSectionCard(
                    title: 'FAMILY DETAILS',
                    children: [
                      ProfileFieldRow(
                        label: "FATHER'S NAME",
                        value: profile.fatherName,
                        onTap: () => _openEditDialog(
                          title: "Father's Name",
                          fieldKey: 'fatherName',
                          initialValue: profile.fatherName,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: "MOTHER'S NAME",
                        value: profile.motherName,
                        onTap: () => _openEditDialog(
                          title: "Mother's Name",
                          fieldKey: 'motherName',
                          initialValue: profile.motherName,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'BROTHERS',
                        value: profile.brothers,
                        onTap: () => _openEditDialog(
                          title: 'Brothers',
                          fieldKey: 'brothers',
                          initialValue: profile.brothers,
                          fieldType: FieldType.singleSelect,
                          options: ['No', '1', '2', '3+'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'MATERNAL UNCLE',
                        value: profile.maternalUncle,
                        onTap: () => _openEditDialog(
                          title: 'Maternal Uncle Name',
                          fieldKey: 'maternalUncle',
                          initialValue: profile.maternalUncle,
                          fieldType: FieldType.text,
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'UNCLE PHONE',
                        value: profile.unclePhone,
                        onTap: () => _openEditDialog(
                          title: "Uncle's Phone Number",
                          fieldKey: 'unclePhone',
                          initialValue: profile.unclePhone,
                          fieldType: FieldType.number,
                        ),
                      ),
                      ProfileFieldRow(
                        label: "FATHER'S EDU.",
                        value: profile.fatherEdu,
                        onTap: () => _openEditDialog(
                          title: "Father's Education",
                          fieldKey: 'fatherEdu',
                          initialValue: profile.fatherEdu,
                          fieldType: FieldType.singleSelect,
                          options: ['IT', 'Graduate', 'Post Graduate', 'Doctorate', 'Schooling'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: "MOTHER'S OCC.",
                        value: profile.motherOcc,
                        onTap: () => _openEditDialog(
                          title: "Mother's Occupation",
                          fieldKey: 'motherOcc',
                          initialValue: profile.motherOcc,
                          fieldType: FieldType.singleSelect,
                          options: ['Housewife', 'Teacher', 'Business', 'Service', 'Retired'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'SISTERS',
                        value: profile.sisters,
                        onTap: () => _openEditDialog(
                          title: 'Sisters',
                          fieldKey: 'sisters',
                          initialValue: profile.sisters,
                          fieldType: FieldType.singleSelect,
                          options: ['No', '1', '2', '3+'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'FAMILY TYPE',
                        value: profile.familyType,
                        onTap: () => _openEditDialog(
                          title: 'Family Type',
                          fieldKey: 'familyType',
                          initialValue: profile.familyType,
                          fieldType: FieldType.singleSelect,
                          options: ['Nuclear', 'Joint'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'FAMILY VALUES',
                        value: profile.familyValues,
                        onTap: () => _openEditDialog(
                          title: 'Family Values',
                          fieldKey: 'familyValues',
                          initialValue: profile.familyValues,
                          fieldType: FieldType.singleSelect,
                          options: ['Moderate', 'Traditional', 'Liberal'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'MARRIED SISTER',
                        value: profile.marriedSister,
                        onTap: () => _openEditDialog(
                          title: 'Married Sisters',
                          fieldKey: 'marriedSister',
                          initialValue: profile.marriedSister,
                          fieldType: FieldType.singleSelect,
                          options: ['0', '1', '2', '3+'],
                        ),
                      ),
                      ProfileFieldRow(
                        label: 'UNCLE NAME',
                        value: profile.uncleName,
                        isLast: true,
                        onTap: () => _openEditDialog(
                          title: 'Uncle Name',
                          fieldKey: 'uncleName',
                          initialValue: profile.uncleName,
                          fieldType: FieldType.text,
                        ),
                      ),
                    ],
                  ),

                  // 5. DOCUMENTS SECTION
                  ProfileSectionCard(
                    title: 'DOCUMENTS',
                    children: [
                      for (int i = 0; i < profile.documents.length; i++)
                        DocumentRow(
                          document: profile.documents[i],
                          isLast: i == profile.documents.length - 1,
                          onTap: () => _showDocumentOptions(profile.documents[i]),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Floating Save Banner (when changes are made)
          if (state.isDirty)
            Positioned(
              left: 20,
              right: 20,
              bottom: 85,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Unsaved profile changes',
                        style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: state.isSaving
                          ? null
                          : () async {
                              await controller.saveProfile();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC9003F),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(100, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: state.isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Text('Save Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),

          // FLOATING BOTTOM NAVIGATION BAR matching reference screenshot exactly
          Positioned(
            left: 24,
            right: 24,
            bottom: 20,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Tab 0: Home
                  GestureDetector(
                    onTap: () {
                      ref.read(homeControllerProvider.notifier).setBottomTab(0);
                      context.go('/home');
                    },
                    child: const Icon(Icons.home_outlined, color: Colors.grey, size: 24),
                  ),

                  // Tab 1: Favourites/Matches
                  GestureDetector(
                    onTap: () {
                      ref.read(homeControllerProvider.notifier).setBottomTab(1);
                      context.go('/home');
                    },
                    child: const Icon(Icons.favorite_border, color: Colors.grey, size: 22),
                  ),

                  // Tab 2: Messages/Chat
                  GestureDetector(
                    onTap: () {
                      ref.read(homeControllerProvider.notifier).setBottomTab(2);
                      context.go('/home');
                    },
                    child: const Icon(Icons.chat_bubble_outline, color: Colors.grey, size: 22),
                  ),

                  // Tab 3: Active Profile Pill matching reference screenshot
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9003F), // Deep crimson red
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.person, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
