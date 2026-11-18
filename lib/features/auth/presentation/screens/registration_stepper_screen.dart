import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../profile/domain/models/profile_model.dart';
import '../controllers/registration_controller.dart';
import '../../../home/presentation/controllers/home_controller.dart';

const List<String> _profileCreatedForOptions = [
  'Yourself',
  'Son',
  'Daughter',
  'Brother',
  'Sister',
  'Friend',
  'Relative',
];

const List<String> _motherTongueOptions = [
  'Marathi',
  'Hindi',
  'Gujarati',
  'Kannada',
  'Telugu',
  'Tamil',
  'Malayalam',
  'Bengali',
  'Punjabi',
  'Odia',
  'Urdu',
  'English',
  'Other',
];

const List<String> _genderOptions = [
  'Male',
  'Female',
  'Other',
];

const List<String> _maritalStatusOptions = [
  'Never Married',
  'Divorced',
  'Widowed',
  'Awaiting Divorce',
];

const List<String> _heightOptions = [
  "137 cm (4'6\")",
  "140 cm (4'7\")",
  "142 cm (4'8\")",
  "145 cm (4'9\")",
  "147 cm (4'10\")",
  "150 cm (4'11\")",
  "152 cm (5'0\")",
  "155 cm (5'1\")",
  "157 cm (5'2\")",
  "160 cm (5'3\")",
  "162 cm (5'4\")",
  "165 cm (5'5\")",
  "168 cm (5'6\")",
  "170 cm (5'7\")",
  "172 cm (5'8\")",
  "175 cm (5'9\")",
  "178 cm (5'10\")",
  "180 cm (5'11\")",
  "183 cm (6'0\")",
  "185 cm (6'1\")",
  "188 cm (6'2\")",
  "191 cm (6'3\")",
  "193 cm (6'4\")",
  "196 cm (6'5\")",
  "198 cm (6'6\")",
  "201 cm (6'7\")",
  "203 cm (6'8\")",
  "206 cm (6'9\")",
  "208 cm (6'10\")",
  "211 cm (6'11\")",
  "213 cm (7'0\")",
];

const List<String> _dietOptions = [
  'Vegetarian',
  'Non-Vegetarian',
  'Eggetarian',
  'Vegan',
  'Jain',
];

const List<String> _physicalStatusOptions = [
  'Normal',
  'Physically Challenged',
  'Visually Impaired',
  'Hearing Impaired',
  'Other',
];

const List<String> _highestEducationOptions = [
  'B.E / B.Tech',
  'M.E / M.Tech',
  'B.Sc',
  'M.Sc',
  'B.Com',
  'M.Com',
  'BBA / MBA',
  'BCA / MCA',
  'MBBS / MD',
  'B.Pharm / M.Pharm',
  'LLB / LLM',
  'CA / CS',
  'Diploma',
  'Higher Secondary (12th)',
  'Secondary (10th)',
  'Doctorate (Ph.D)',
  'Other',
];

const List<String> _professionOptions = [
  'Software / IT Professional',
  'Hardware / Networking',
  'Government / Civil Services',
  'Private Sector',
  'Banking / Finance',
  'Doctor / Medical Healthcare',
  'Teacher / Professor',
  'Business / Entrepreneur',
  'Civil / Mechanical Engineer',
  'Lawyer / Legal Professional',
  'Defence / Police',
  'Agriculture / Farming',
  'Self Employed',
  'Not Working',
  'Other',
];

const List<String> _annualIncomeOptions = [
  'No Income',
  'Below 2 Lakh',
  '2 - 4 Lakh',
  '4 - 7 Lakh',
  '7 - 10 Lakh',
  '10 - 15 Lakh',
  '15 - 20 Lakh',
  '20 - 30 Lakh',
  '30 - 50 Lakh',
  '50 Lakh - 1 Crore',
  'Above 1 Crore',
];

const List<String> _indianStates = [
  'Andhra Pradesh',
  'Arunachal Pradesh',
  'Assam',
  'Bihar',
  'Chhattisgarh',
  'Goa',
  'Gujarat',
  'Haryana',
  'Himachal Pradesh',
  'Jharkhand',
  'Karnataka',
  'Kerala',
  'Madhya Pradesh',
  'Maharashtra',
  'Manipur',
  'Meghalaya',
  'Mizoram',
  'Nagaland',
  'Odisha',
  'Punjab',
  'Rajasthan',
  'Sikkim',
  'Tamil Nadu',
  'Telangana',
  'Tripura',
  'Uttar Pradesh',
  'Uttarakhand',
  'West Bengal',
  'Andaman and Nicobar Islands',
  'Chandigarh',
  'Dadra and Nagar Haveli and Daman and Diu',
  'Delhi',
  'Jammu and Kashmir',
  'Ladakh',
  'Lakshadweep',
  'Puducherry',
];

const List<String> _religionOptions = [
  'Hindu',
  'Muslim',
  'Christian',
  'Sikh',
  'Jain',
  'Buddhist',
  'Parsi',
  'Jewish',
  'Other',
];

const List<String> _casteOptions = [
  'Kunbi',
  'Maratha',
  'Brahmin',
  'Vaishya',
  'Kshatriya',
  'Nair',
  'Ezhava',
  'Lingayat',
  'Rajput',
  'Other',
];

const List<String> _familyTypeOptions = [
  'Joint',
  'Nuclear',
];

const List<String> _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
];

class RegistrationStepperScreen extends ConsumerStatefulWidget {
  const RegistrationStepperScreen({super.key});

  @override
  ConsumerState<RegistrationStepperScreen> createState() => _RegistrationStepperScreenState();
}

class _RegistrationStepperScreenState extends ConsumerState<RegistrationStepperScreen> {
  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();
  final _step4Key = GlobalKey<FormState>();
  final _step5Key = GlobalKey<FormState>();

  // Step 1 Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  int? _selectedDay;
  int? _selectedMonth;
  int? _selectedYear;
  String? _dobError;
  String? _photosError;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Step 4 Controllers
  late TextEditingController _countryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;

  // Dynamic Uncles Controllers
  int _maternalUncleCount = 0;
  int _paternalUncleCount = 0;
  final List<Map<String, TextEditingController>> _maternalUncleControllers = [];
  final List<Map<String, TextEditingController>> _paternalUncleControllers = [];

  @override
  void initState() {
    super.initState();
    final regState = ref.read(registrationControllerProvider);

    // Step 1
    _fullNameController = TextEditingController(text: regState.fullName);
    _phoneController = TextEditingController(text: regState.phone);
    _emailController = TextEditingController(text: regState.email);
    _passwordController = TextEditingController(text: regState.password);
    _confirmPasswordController = TextEditingController(text: regState.confirmPassword);

    if (regState.dob != null) {
      _selectedDay = regState.dob!.day;
      _selectedMonth = regState.dob!.month;
      _selectedYear = regState.dob!.year;
    }

    // Step 4
    _countryController = TextEditingController(text: regState.country.isNotEmpty ? regState.country : 'India');
    _stateController = TextEditingController(text: regState.state);
    _cityController = TextEditingController(text: regState.city);

    // Uncles
    _maternalUncleCount = regState.maternalUnclesDetails.length;
    for (final u in regState.maternalUnclesDetails) {
      _maternalUncleControllers.add({
        'name': TextEditingController(text: u.name),
        'mobile': TextEditingController(text: u.mobile),
        'profession': TextEditingController(text: u.occupation),
      });
    }

    _paternalUncleCount = regState.paternalUnclesDetails.length;
    for (final u in regState.paternalUnclesDetails) {
      _paternalUncleControllers.add({
        'name': TextEditingController(text: u.name),
        'mobile': TextEditingController(text: u.mobile),
        'profession': TextEditingController(text: u.occupation),
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();

    for (final map in _maternalUncleControllers) {
      map['name']?.dispose();
      map['mobile']?.dispose();
      map['profession']?.dispose();
    }
    for (final map in _paternalUncleControllers) {
      map['name']?.dispose();
      map['mobile']?.dispose();
      map['profession']?.dispose();
    }

    super.dispose();
  }

  void _updateMaternalUncleCount(int newCount) {
    if (newCount < 0) newCount = 0;
    setState(() {
      _maternalUncleCount = newCount;
      while (_maternalUncleControllers.length < newCount) {
        _maternalUncleControllers.add({
          'name': TextEditingController(),
          'mobile': TextEditingController(),
          'profession': TextEditingController(),
        });
      }
      while (_maternalUncleControllers.length > newCount) {
        final removed = _maternalUncleControllers.removeLast();
        removed['name']?.dispose();
        removed['mobile']?.dispose();
        removed['profession']?.dispose();
      }
    });
  }

  void _updatePaternalUncleCount(int newCount) {
    if (newCount < 0) newCount = 0;
    setState(() {
      _paternalUncleCount = newCount;
      while (_paternalUncleControllers.length < newCount) {
        _paternalUncleControllers.add({
          'name': TextEditingController(),
          'mobile': TextEditingController(),
          'profession': TextEditingController(),
        });
      }
      while (_paternalUncleControllers.length > newCount) {
        final removed = _paternalUncleControllers.removeLast();
        removed['name']?.dispose();
        removed['mobile']?.dispose();
        removed['profession']?.dispose();
      }
    });
  }

  void _showDropdownSelection({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(title, style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == selectedValue;
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
                      onTap: () {
                        onSelected(option);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDayPicker() {
    final days = List.generate(31, (i) => '${i + 1}');
    _showDropdownSelection(
      title: 'Select Day',
      options: days,
      selectedValue: _selectedDay != null ? '$_selectedDay' : '',
      onSelected: (val) {
        setState(() {
          _selectedDay = int.tryParse(val);
          _dobError = null;
        });
      },
    );
  }

  void _showMonthPicker() {
    _showDropdownSelection(
      title: 'Select Month',
      options: _monthNames,
      selectedValue: _selectedMonth != null ? _monthNames[_selectedMonth! - 1] : '',
      onSelected: (val) {
        setState(() {
          _selectedMonth = _monthNames.indexOf(val) + 1;
          _dobError = null;
        });
      },
    );
  }

  void _showYearPicker() {
    final currentYear = DateTime.now().year;
    final years = List.generate(65, (i) => '${currentYear - 18 - i}');
    _showDropdownSelection(
      title: 'Select Year',
      options: years,
      selectedValue: _selectedYear != null ? '$_selectedYear' : '',
      onSelected: (val) {
        setState(() {
          _selectedYear = int.tryParse(val);
          _dobError = null;
        });
      },
    );
  }

  Future<void> _pickFile({
    required Function(String name, List<int> bytes) onPicked,
    required String documentName,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.size > 5 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size must be less than 5 MB'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (file.bytes != null && file.bytes!.isNotEmpty) {
          onPicked(file.name, file.bytes!);
        } else if (!kIsWeb && file.path != null && file.path!.isNotEmpty) {
          final bytes = await File(file.path!).readAsBytes();
          onPicked(file.name, bytes);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick $documentName: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPhotoPickerSheet() {
    final regState = ref.read(registrationControllerProvider);
    final totalPhotos = (regState.pickedPhotosData?.length ?? 0) + regState.photos.length;
    if (totalPhotos >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 6 photos allowed'), backgroundColor: Colors.orange),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Upload Profile Photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickPhoto(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickPhoto(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1600,
        maxHeight: 1600,
      );
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        if (bytes.length > 5 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Photo size must be less than 5 MB'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
        ref.read(registrationControllerProvider.notifier).addPickedPhoto(
          bytes: bytes,
          fileName: picked.name,
        );
        setState(() {
          _photosError = null;
        });
      }
    } catch (_) {
      // Fallback to FilePicker if camera/gallery is unsupported or cancelled
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png'],
          withData: true,
        );
        if (result != null && result.files.isNotEmpty) {
          final file = result.files.first;
          if (file.size > 5 * 1024 * 1024) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo size must be less than 5 MB'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return;
          }
          final bytes = file.bytes ?? (file.path != null ? await File(file.path!).readAsBytes() : null);
          if (bytes != null) {
            ref.read(registrationControllerProvider.notifier).addPickedPhoto(
              bytes: bytes,
              fileName: file.name,
            );
            setState(() {
              _photosError = null;
            });
          }
        }
      } catch (err) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to pick photo: $err'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _editStep(int stepIndex) {
    ref.read(registrationControllerProvider.notifier).setEditingFromReview(true);
    ref.read(registrationControllerProvider.notifier).setStep(stepIndex);
  }

  void _nextStep(int currentStep) async {
    final regState = ref.read(registrationControllerProvider);

    if (currentStep == 0) {
      bool isDobValid = true;
      if (_selectedDay == null || _selectedMonth == null || _selectedYear == null) {
        setState(() {
          _dobError = 'Please select Day, Month, and Year';
        });
        isDobValid = false;
      } else {
        setState(() {
          _dobError = null;
        });
      }

      if (_step1Key.currentState!.validate() && isDobValid) {
        final dob = DateTime(_selectedYear!, _selectedMonth!, _selectedDay!);
        final today = DateTime.now();
        int ageVal = today.year - dob.year;
        if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
          ageVal--;
        }

        ref.read(registrationControllerProvider.notifier).updateStep1(
              fullName: _fullNameController.text.trim(),
              phone: _phoneController.text.trim(),
              dob: dob,
              age: ageVal,
              email: _emailController.text.trim(),
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            );
        if (regState.isEditingFromReview) {
          ref.read(registrationControllerProvider.notifier).setEditingFromReview(false);
          ref.read(registrationControllerProvider.notifier).setStep(5);
        } else {
          ref.read(registrationControllerProvider.notifier).nextStep();
        }
      }
    } else if (currentStep == 1) {
      if (regState.gender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Gender'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.maritalStatus.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Marital Status'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.height.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Height'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.diet.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Diet'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.physicalStatus.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Physical Status / Special Case'), backgroundColor: Colors.red),
        );
        return;
      }

      if (_step2Key.currentState!.validate()) {
        if (regState.isEditingFromReview) {
          ref.read(registrationControllerProvider.notifier).setEditingFromReview(false);
          ref.read(registrationControllerProvider.notifier).setStep(5);
        } else {
          ref.read(registrationControllerProvider.notifier).nextStep();
        }
      }
    } else if (currentStep == 2) {
      if (regState.qualification.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Highest Education'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.occupation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Profession / Occupation'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.annualIncome.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Annual Income'), backgroundColor: Colors.red),
        );
        return;
      }

      if (_step3Key.currentState!.validate()) {
        if (regState.isEditingFromReview) {
          ref.read(registrationControllerProvider.notifier).setEditingFromReview(false);
          ref.read(registrationControllerProvider.notifier).setStep(5);
        } else {
          ref.read(registrationControllerProvider.notifier).nextStep();
        }
      }
    } else if (currentStep == 3) {
      if (regState.religion.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Religion'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.caste.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Caste'), backgroundColor: Colors.red),
        );
        return;
      }
      if (regState.familyType.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select Family Type'), backgroundColor: Colors.red),
        );
        return;
      }

      if (_step4Key.currentState!.validate()) {
        final maternalUncles = <UncleDetail>[];
        for (int i = 0; i < _maternalUncleCount; i++) {
          final name = _maternalUncleControllers[i]['name']!.text.trim();
          final mobile = _maternalUncleControllers[i]['mobile']!.text.trim();
          final profession = _maternalUncleControllers[i]['profession']!.text.trim();
          if (name.isNotEmpty || mobile.isNotEmpty || profession.isNotEmpty) {
            maternalUncles.add(UncleDetail(
              name: name,
              mobile: mobile,
              occupation: profession,
            ));
          }
        }

        final paternalUncles = <UncleDetail>[];
        for (int i = 0; i < _paternalUncleCount; i++) {
          final name = _paternalUncleControllers[i]['name']!.text.trim();
          final mobile = _paternalUncleControllers[i]['mobile']!.text.trim();
          final profession = _paternalUncleControllers[i]['profession']!.text.trim();
          if (name.isNotEmpty || mobile.isNotEmpty || profession.isNotEmpty) {
            paternalUncles.add(UncleDetail(
              name: name,
              mobile: mobile,
              occupation: profession,
            ));
          }
        }

        ref.read(registrationControllerProvider.notifier).updateStep4(
              country: _countryController.text.trim(),
              stateVal: _stateController.text.trim(),
              city: _cityController.text.trim(),
              maternalUnclesDetails: maternalUncles,
              paternalUnclesDetails: paternalUncles,
            );
        if (regState.isEditingFromReview) {
          ref.read(registrationControllerProvider.notifier).setEditingFromReview(false);
          ref.read(registrationControllerProvider.notifier).setStep(5);
        } else {
          ref.read(registrationControllerProvider.notifier).nextStep();
        }
      }
    } else if (currentStep == 4) {
      if (regState.aadharBytes == null && regState.aadharCardUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload Aadhaar Card (Front)'), backgroundColor: Colors.red),
        );
        return;
      }

      if (regState.aadharBackBytes == null && regState.aadharBackUrl.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload Aadhaar Card (Back)'), backgroundColor: Colors.red),
        );
        return;
      }

      if (regState.casteCertificateBytes == null &&
          regState.casteCertificateUrl.isEmpty &&
          regState.casteCertificateName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload Caste Certificate'), backgroundColor: Colors.red),
        );
        return;
      }

      final totalPhotos = (regState.pickedPhotosData?.length ?? 0) + regState.photos.length;
      if (totalPhotos < 2) {
        setState(() {
          _photosError = 'Please upload at least 2 profile photos.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload at least 2 profile photos (Maximum 6).'), backgroundColor: Colors.red),
        );
        return;
      }
      if (totalPhotos > 6) {
        setState(() {
          _photosError = 'Maximum 6 profile photos are allowed.';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maximum 6 profile photos are allowed.'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() {
        _photosError = null;
      });

      ref.read(registrationControllerProvider.notifier).setEditingFromReview(false);
      ref.read(registrationControllerProvider.notifier).setStep(5);
    } else if (currentStep == 5) {
      _submitFinalRegistration();
    }
  }

  void _submitFinalRegistration() async {
    final regState = ref.read(registrationControllerProvider);

    // Re-verify Step 1
    if (regState.fullName.trim().isEmpty ||
        regState.phone.trim().length != 10 ||
        regState.dob == null ||
        regState.email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required Basic Details.'),
          backgroundColor: Colors.red,
        ),
      );
      _editStep(0);
      return;
    }

    // Re-verify Step 2
    if (regState.gender.isEmpty ||
        regState.maritalStatus.isEmpty ||
        regState.height.isEmpty ||
        regState.diet.isEmpty ||
        regState.physicalStatus.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required Personal Details.'),
          backgroundColor: Colors.red,
        ),
      );
      _editStep(1);
      return;
    }

    // Re-verify Step 3
    if (regState.qualification.isEmpty ||
        regState.occupation.isEmpty ||
        regState.annualIncome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required Education & Career details.'),
          backgroundColor: Colors.red,
        ),
      );
      _editStep(2);
      return;
    }

    // Re-verify Step 4
    if (regState.religion.isEmpty ||
        regState.caste.isEmpty ||
        regState.familyType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required Location & Family details.'),
          backgroundColor: Colors.red,
        ),
      );
      _editStep(3);
      return;
    }

    // Re-verify Step 5
    if (regState.aadharBytes == null && regState.aadharCardUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Aadhaar Card (Front)'), backgroundColor: Colors.red),
      );
      _editStep(4);
      return;
    }

    if (regState.aadharBackBytes == null && regState.aadharBackUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Aadhaar Card (Back)'), backgroundColor: Colors.red),
      );
      _editStep(4);
      return;
    }

    if (regState.casteCertificateBytes == null &&
        regState.casteCertificateUrl.isEmpty &&
        regState.casteCertificateName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload Caste Certificate'), backgroundColor: Colors.red),
      );
      _editStep(4);
      return;
    }

    final totalPhotos = (regState.pickedPhotosData?.length ?? 0) + regState.photos.length;
    if (totalPhotos < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload at least 2 profile photos (Maximum 6).'),
          backgroundColor: Colors.red,
        ),
      );
      _editStep(4);
      return;
    }
    if (totalPhotos > 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 6 profile photos are allowed.'),
          backgroundColor: Colors.red,
        ),
      );
      _editStep(4);
      return;
    }

    final success = await ref.read(registrationControllerProvider.notifier).submit();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile Created Successfully'),
          backgroundColor: Colors.green,
        ),
      );
      ref.read(homeControllerProvider.notifier).setBottomTab(0);
      context.go('/home');
    } else if (!success && mounted) {
      final errorMsg = ref.read(registrationControllerProvider).error ?? 'Registration failed. Please try again.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _prevStep() {
    final regState = ref.read(registrationControllerProvider);
    if (regState.isEditingFromReview) {
      ref.read(registrationControllerProvider.notifier).setEditingFromReview(false);
      ref.read(registrationControllerProvider.notifier).setStep(5);
    } else {
      ref.read(registrationControllerProvider.notifier).prevStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registrationControllerProvider);
    final currentStep = regState.currentStep.clamp(0, 5);

    return PopScope(
      canPop: currentStep == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentStep > 0) {
          _prevStep();
        } else {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFBF8F9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: currentStep > 0 ? _prevStep : () => context.go('/login'),
          ),
          title: Text(
            currentStep == 5 ? 'Review Registration' : 'Register',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              // 5-Step Stepper Header
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                child: _buildStepperHeader(currentStep),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),

              // Step Views
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (regState.isEditingFromReview && currentStep < 5) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.edit_note, size: 18, color: AppColors.primary),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Editing from Review',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref.read(registrationControllerProvider.notifier).setEditingFromReview(false);
                                    ref.read(registrationControllerProvider.notifier).setStep(5);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Return to Review',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: _buildStepForm(currentStep, regState),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Action Buttons
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Row(
                  children: [
                    if (currentStep > 0) ...[
                      Expanded(
                        flex: 1,
                        child: OutlinedButton.icon(
                          onPressed: _prevStep,
                          icon: const Icon(Icons.arrow_back, size: 18, color: AppColors.primary),
                          label: Text(
                            regState.isEditingFromReview ? 'Cancel' : 'Back',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(color: AppColors.primary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                    ],
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: regState.isLoading ? null : () => _nextStep(currentStep),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        child: regState.isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentStep == 5
                                        ? 'Submit Registration'
                                        : (regState.isEditingFromReview
                                            ? 'Save & Return to Review'
                                            : (currentStep == 4 ? 'Complete Registration' : 'Next')),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  if (currentStep < 4 && !regState.isEditingFromReview) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                                  ],
                                  if (currentStep == 5) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.check_circle_outline, size: 18, color: Colors.white),
                                  ],
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------
  // STEPPER HEADER WIDGET (Equal Expanded Slots, No Overflow)
  // ----------------------------------------------------
  Widget _buildStepperHeader(int currentStep) {
    final steps = [
      {'icon': Icons.person, 'label': 'Basic Details'},
      {'icon': Icons.favorite_border, 'label': 'Personal Details'},
      {'icon': Icons.work_outline, 'label': 'Education/Career'},
      {'icon': Icons.home_outlined, 'label': 'Location & Family'},
      {'icon': Icons.description_outlined, 'label': 'Document Details'},
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final isCompleted = index < currentStep || currentStep >= 5;
        final isActive = index == currentStep;

        Color circleBg;
        Color iconColor;
        Border? border;

        if (isActive) {
          circleBg = AppColors.primary;
          iconColor = Colors.white;
          border = null;
        } else if (isCompleted) {
          circleBg = Colors.white;
          iconColor = AppColors.primary;
          border = Border.all(color: AppColors.primary, width: 1.5);
        } else {
          circleBg = Colors.white;
          iconColor = Colors.grey.shade400;
          border = Border.all(color: Colors.grey.shade300, width: 1.5);
        }

        return Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == 0
                          ? Colors.transparent
                          : ((index <= currentStep || currentStep >= 5) ? AppColors.primary : Colors.grey.shade300),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: circleBg,
                      shape: BoxShape.circle,
                      border: border,
                    ),
                    child: Center(
                      child: Icon(
                        isCompleted ? Icons.check : (steps[index]['icon'] as IconData),
                        size: 16,
                        color: iconColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 2,
                      color: index == steps.length - 1
                          ? Colors.transparent
                          : ((index < currentStep || currentStep >= 5) ? AppColors.primary : Colors.grey.shade300),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: 26,
                child: Text(
                  steps[index]['label'] as String,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.0,
                    height: 1.1,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? AppColors.primary
                        : (isCompleted ? AppColors.primary : Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ----------------------------------------------------
  // SECTION HEADER WIDGET
  // ----------------------------------------------------
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    String? note,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.grey.shade200,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.favorite_border,
              color: AppColors.primary,
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        if (note != null) ...[
          const SizedBox(height: 3),
          Text(
            note,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        const SizedBox(height: 20),
      ],
    );
  }

  // ----------------------------------------------------
  // FORM HELPERS
  // ----------------------------------------------------
  Widget _buildLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 4.0),
      child: Text.rich(
        TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2E2E2E),
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.5),
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  Widget _buildDropdownCard({
    required String label,
    required String value,
    required String hintText,
    required VoidCallback onTap,
    Widget? prefixIcon,
    bool isRequired = true,
  }) {
    final hasValue = value.isNotEmpty && value != hintText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label, isRequired: isRequired),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                if (prefixIcon != null) ...[
                  prefixIcon,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    hasValue ? value : hintText,
                    style: TextStyle(
                      color: hasValue ? Colors.black87 : Colors.grey.shade400,
                      fontSize: 13.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600, size: 20),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildStepForm(int step, RegistrationState regState) {
    switch (step) {
      case 0:
        return _buildStep1(regState);
      case 1:
        return _buildStep2(regState);
      case 2:
        return _buildStep3(regState);
      case 3:
        return _buildStep4(regState);
      case 4:
        return _buildStep5(regState);
      case 5:
        return _buildReviewStep(regState);
      default:
        return const SizedBox.shrink();
    }
  }

  // ----------------------------------------------------
  // STEP 1 - BASIC DETAILS
  // ----------------------------------------------------
  Widget _buildStep1(RegistrationState regState) {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            icon: Icons.person,
            title: 'Basic Details',
            subtitle: 'Tell us a little about yourself',
          ),

          // Profile Created For
          _buildDropdownCard(
            label: 'Profile created for',
            value: regState.accountType,
            hintText: 'Yourself',
            prefixIcon: const Icon(Icons.people_outline, size: 18, color: AppColors.primary),
            onTap: () => _showDropdownSelection(
              title: 'Profile created for',
              options: _profileCreatedForOptions,
              selectedValue: regState.accountType,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep1(accountType: val);
              },
            ),
          ),

          // Full Name
          _buildLabel('Full Name'),
          TextFormField(
            controller: _fullNameController,
            decoration: _buildInputDecoration(
              hintText: 'Enter Full Name',
              prefixIcon: const Icon(Icons.person_outline, size: 18, color: AppColors.primary),
            ),
            validator: (val) => val == null || val.trim().isEmpty ? 'Full name is required' : null,
          ),
          const SizedBox(height: 14),

          // Mobile Number
          _buildLabel('Mobile Number'),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: _buildInputDecoration(
              hintText: 'Enter Mobile Number',
              prefixIcon: const Icon(Icons.phone_outlined, size: 18, color: AppColors.primary),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Mobile number is required';
              if (val.trim().length != 10) return 'Mobile number must be exactly 10 digits';
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Date of Birth & Mother Tongue
          _buildLabel('Date of Birth'),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _showDayPicker,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _dobError != null ? Colors.red : Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedDay != null ? '$_selectedDay' : 'Day',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: _selectedDay != null ? Colors.black87 : Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _showMonthPicker,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _dobError != null ? Colors.red : Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedMonth != null ? _monthNames[_selectedMonth! - 1] : 'Month',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: _selectedMonth != null ? Colors.black87 : Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: _showYearPicker,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _dobError != null ? Colors.red : Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedYear != null ? '$_selectedYear' : 'Year',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: _selectedYear != null ? Colors.black87 : Colors.grey.shade500,
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey.shade600),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_dobError != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(_dobError!, style: const TextStyle(color: Colors.red, fontSize: 11)),
            ),
          ],
          const SizedBox(height: 14),

          // Mother Tongue
          _buildDropdownCard(
            label: 'Mother Tongue',
            value: regState.motherTongue,
            hintText: 'Marathi',
            prefixIcon: const Icon(Icons.language, size: 18, color: AppColors.primary),
            onTap: () => _showDropdownSelection(
              title: 'Mother Tongue',
              options: _motherTongueOptions,
              selectedValue: regState.motherTongue,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep1(motherTongue: val);
              },
            ),
          ),

          // Email
          _buildLabel('Email'),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _buildInputDecoration(
              hintText: 'Enter Email Address',
              prefixIcon: const Icon(Icons.mail_outline, size: 18, color: AppColors.primary),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email is required';
              if (!val.contains('@') || !val.contains('.')) return 'Please enter a valid email address';
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Create Password
          _buildLabel('Create Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: _buildInputDecoration(
              hintText: 'Create Password',
              prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Password is required';
              if (val.length < 8) return 'Password must be at least 8 characters';
              if (!RegExp(r'[A-Z]').hasMatch(val)) return 'Password must contain at least 1 uppercase letter';
              if (!RegExp(r'[a-z]').hasMatch(val)) return 'Password must contain at least 1 lowercase letter';
              if (!RegExp(r'\d').hasMatch(val)) return 'Password must contain at least 1 number';
              return null;
            },
          ),
          const SizedBox(height: 14),

          // Confirm Password
          _buildLabel('Confirm Password'),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: _buildInputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock_outline, size: 18, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                  size: 20,
                ),
                onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Confirm password is required';
              if (val != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Password Requirements Note
          Text(
            'At least 8 characters with 1 uppercase letter, 1 lowercase letter & 1 number.',
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 2 - PERSONAL DETAILS
  // ----------------------------------------------------
  Widget _buildStep2(RegistrationState regState) {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            icon: Icons.favorite_border,
            title: 'Personal Details',
            subtitle: 'Your lifestyle and physical details',
          ),

          // Gender
          _buildDropdownCard(
            label: 'Gender',
            value: regState.gender,
            hintText: 'Select Gender',
            onTap: () => _showDropdownSelection(
              title: 'Gender',
              options: _genderOptions,
              selectedValue: regState.gender,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep2(gender: val);
              },
            ),
          ),

          // Marital Status
          _buildDropdownCard(
            label: 'Marital Status',
            value: regState.maritalStatus,
            hintText: 'Select Marital Status',
            onTap: () => _showDropdownSelection(
              title: 'Marital Status',
              options: _maritalStatusOptions,
              selectedValue: regState.maritalStatus,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep2(maritalStatus: val);
              },
            ),
          ),

          // Height
          _buildDropdownCard(
            label: 'Height',
            value: regState.height,
            hintText: 'Select Height (cm)',
            onTap: () => _showDropdownSelection(
              title: 'Height',
              options: _heightOptions,
              selectedValue: regState.height,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep2(height: val);
              },
            ),
          ),

          // Diet
          _buildDropdownCard(
            label: 'Diet',
            value: regState.diet,
            hintText: 'Select Diet',
            onTap: () => _showDropdownSelection(
              title: 'Diet',
              options: _dietOptions,
              selectedValue: regState.diet,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep2(diet: val);
              },
            ),
          ),

          // Physical Status / Special Case
          _buildDropdownCard(
            label: 'Physical Status / Special Case',
            value: regState.physicalStatus,
            hintText: 'Select Status',
            onTap: () => _showDropdownSelection(
              title: 'Physical Status / Special Case',
              options: _physicalStatusOptions,
              selectedValue: regState.physicalStatus,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep2(physicalStatus: val);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 3 - EDUCATION / CAREER
  // ----------------------------------------------------
  Widget _buildStep3(RegistrationState regState) {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            icon: Icons.work_outline,
            title: 'Education/Career',
            subtitle: 'Your education and the work you do',
          ),

          // Highest Education
          _buildDropdownCard(
            label: 'Highest Education',
            value: regState.qualification,
            hintText: 'Select Education',
            onTap: () => _showDropdownSelection(
              title: 'Highest Education',
              options: _highestEducationOptions,
              selectedValue: regState.qualification,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep3(qualification: val);
              },
            ),
          ),

          // Profession / Occupation
          _buildDropdownCard(
            label: 'Profession / Occupation',
            value: regState.occupation,
            hintText: 'Select Profession',
            onTap: () => _showDropdownSelection(
              title: 'Profession / Occupation',
              options: _professionOptions,
              selectedValue: regState.occupation,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep3(occupation: val);
              },
            ),
          ),

          // Annual Income
          _buildDropdownCard(
            label: 'Annual Income',
            value: regState.annualIncome,
            hintText: 'Select Income',
            onTap: () => _showDropdownSelection(
              title: 'Annual Income',
              options: _annualIncomeOptions,
              selectedValue: regState.annualIncome,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep3(annualIncome: val);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 4 - LOCATION & FAMILY
  // ----------------------------------------------------
  Widget _buildStep4(RegistrationState regState) {
    return Form(
      key: _step4Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            icon: Icons.home_outlined,
            title: 'Location & Family',
            subtitle: 'Where you live and the family you come from',
            note: 'Fields marked * are required.',
          ),

          // Country
          _buildLabel('Country'),
          TextFormField(
            controller: _countryController,
            decoration: _buildInputDecoration(hintText: 'India'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Country is required' : null,
          ),
          const SizedBox(height: 14),

          // State
          _buildLabel('State'),
          InkWell(
            onTap: () => _showDropdownSelection(
              title: 'Select State',
              options: _indianStates,
              selectedValue: _stateController.text,
              onSelected: (val) {
                setState(() => _stateController.text = val);
              },
            ),
            child: IgnorePointer(
              child: TextFormField(
                controller: _stateController,
                decoration: _buildInputDecoration(
                  hintText: 'e.g. Maharashtra',
                  suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? 'State is required' : null,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // City / District
          _buildLabel('City / District'),
          TextFormField(
            controller: _cityController,
            decoration: _buildInputDecoration(hintText: 'e.g. Pune'),
            validator: (val) => val == null || val.trim().isEmpty ? 'City / District is required' : null,
          ),
          const SizedBox(height: 14),

          // Religion
          _buildDropdownCard(
            label: 'Religion',
            value: regState.religion,
            hintText: 'Select Religion',
            onTap: () => _showDropdownSelection(
              title: 'Religion',
              options: _religionOptions,
              selectedValue: regState.religion,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep4(religion: val);
              },
            ),
          ),

          // Caste
          _buildDropdownCard(
            label: 'Caste',
            value: regState.caste,
            hintText: 'Select Caste',
            onTap: () => _showDropdownSelection(
              title: 'Caste',
              options: _casteOptions,
              selectedValue: regState.caste,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep4(caste: val);
              },
            ),
          ),

          // Family Type
          _buildDropdownCard(
            label: 'Family Type',
            value: regState.familyType,
            hintText: 'Select Family Type',
            onTap: () => _showDropdownSelection(
              title: 'Family Type',
              options: _familyTypeOptions,
              selectedValue: regState.familyType,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep4(familyType: val);
              },
            ),
          ),

          const Divider(height: 32),

          // Uncles (optional) Section Header
          Row(
            children: [
              const Text(
                'Uncles',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF222222)),
              ),
              const SizedBox(width: 4),
              Text(
                '(optional)',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Families often contact each other through relatives. Mobile numbers are shared only after an interest is accepted.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
          ),
          const SizedBox(height: 14),

          // Maternal Uncles Count Selector
          _buildLabel('Number of Maternal Uncles', isRequired: false),
          DropdownButtonFormField<int>(
            key: const Key('maternal_uncles_count_field'),
            value: _maternalUncleCount,
            decoration: _buildInputDecoration(hintText: 'Select number of maternal uncles'),
            items: List.generate(
              _maternalUncleCount > 10 ? _maternalUncleCount + 1 : 11,
              (i) => DropdownMenuItem<int>(
                value: i,
                child: Text('$i'),
              ),
            ),
            onChanged: (val) {
              if (val != null) {
                _updateMaternalUncleCount(val);
              }
            },
          ),
          if (_maternalUncleCount > 0) ...[
            for (int i = 0; i < _maternalUncleCount; i++) ...[
              const SizedBox(height: 12),
              _buildLabel('Maternal Uncle ${i + 1} Name', isRequired: false),
              TextFormField(
                key: Key('maternal_uncle_name_$i'),
                controller: _maternalUncleControllers[i]['name'],
                decoration: _buildInputDecoration(hintText: "Mother's brother (Mama)"),
              ),
              const SizedBox(height: 10),
              _buildLabel('Maternal Uncle ${i + 1} Mobile', isRequired: false),
              TextFormField(
                key: Key('maternal_uncle_mobile_$i'),
                controller: _maternalUncleControllers[i]['mobile'],
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: _buildInputDecoration(hintText: '10-digit mobile number'),
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty && val.trim().length != 10) {
                    return 'Mobile number must be exactly 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildLabel('Maternal Uncle ${i + 1} Profession', isRequired: false),
              TextFormField(
                key: Key('maternal_uncle_profession_$i'),
                controller: _maternalUncleControllers[i]['profession'],
                decoration: _buildInputDecoration(hintText: 'Enter profession'),
              ),
            ],
          ],
          const SizedBox(height: 16),

          // Paternal Uncles Count Selector
          _buildLabel('Number of Paternal Uncles', isRequired: false),
          DropdownButtonFormField<int>(
            key: const Key('paternal_uncles_count_field'),
            value: _paternalUncleCount,
            decoration: _buildInputDecoration(hintText: 'Select number of paternal uncles'),
            items: List.generate(
              _paternalUncleCount > 10 ? _paternalUncleCount + 1 : 11,
              (i) => DropdownMenuItem<int>(
                value: i,
                child: Text('$i'),
              ),
            ),
            onChanged: (val) {
              if (val != null) {
                _updatePaternalUncleCount(val);
              }
            },
          ),
          if (_paternalUncleCount > 0) ...[
            for (int i = 0; i < _paternalUncleCount; i++) ...[
              const SizedBox(height: 12),
              _buildLabel('Paternal Uncle ${i + 1} Name', isRequired: false),
              TextFormField(
                key: Key('paternal_uncle_name_$i'),
                controller: _paternalUncleControllers[i]['name'],
                decoration: _buildInputDecoration(hintText: "Father's brother (Kaka)"),
              ),
              const SizedBox(height: 10),
              _buildLabel('Paternal Uncle ${i + 1} Mobile', isRequired: false),
              TextFormField(
                key: Key('paternal_uncle_mobile_$i'),
                controller: _paternalUncleControllers[i]['mobile'],
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: _buildInputDecoration(hintText: '10-digit mobile number'),
                validator: (val) {
                  if (val != null && val.trim().isNotEmpty && val.trim().length != 10) {
                    return 'Mobile number must be exactly 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildLabel('Paternal Uncle ${i + 1} Profession', isRequired: false),
              TextFormField(
                key: Key('paternal_uncle_profession_$i'),
                controller: _paternalUncleControllers[i]['profession'],
                decoration: _buildInputDecoration(hintText: 'Enter profession'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 5 - DOCUMENT DETAILS & PHOTOS
  // ----------------------------------------------------
  Widget _buildStep5(RegistrationState regState) {
    final totalPhotos = (regState.pickedPhotosData?.length ?? 0) + regState.photos.length;

    return Form(
      key: _step5Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(
            icon: Icons.description_outlined,
            title: 'Document Details',
            subtitle: 'Verify your identity — only the committee sees these',
          ),

          // Upload Aadhaar Card (Front)
          _buildLabel('Upload Aadhaar Card (Front)'),
          _buildDottedUploadBox(
            fileName: regState.aadharCardName,
            isUploaded: regState.aadharBytes != null || regState.aadharCardUrl.isNotEmpty,
            onTap: () => _pickFile(
              documentName: 'Aadhaar Card (Front)',
              onPicked: (name, bytes) {
                ref.read(registrationControllerProvider.notifier).updateAadharCard(
                      name: name,
                      bytes: bytes,
                    );
              },
            ),
            onRemove: () {
              ref.read(registrationControllerProvider.notifier).removeAadharCard();
            },
          ),
          const SizedBox(height: 16),

          // Upload Aadhaar Card (Back)
          _buildLabel('Upload Aadhaar Card (Back)'),
          _buildDottedUploadBox(
            fileName: regState.aadharBackName,
            isUploaded: regState.aadharBackBytes != null || regState.aadharBackUrl.isNotEmpty,
            onTap: () => _pickFile(
              documentName: 'Aadhaar Card (Back)',
              onPicked: (name, bytes) {
                ref.read(registrationControllerProvider.notifier).updateAadharBack(
                      name: name,
                      bytes: bytes,
                    );
              },
            ),
            onRemove: () {
              ref.read(registrationControllerProvider.notifier).removeAadharBack();
            },
          ),
          const SizedBox(height: 16),

          // Upload Caste Certificate
          _buildLabel('Upload Caste Certificate'),
          _buildDottedUploadBox(
            fileName: regState.casteCertificateName,
            isUploaded: regState.casteCertificateBytes != null ||
                regState.casteCertificateUrl.isNotEmpty ||
                regState.casteCertificateName.isNotEmpty,
            onTap: () => _pickFile(
              documentName: 'Caste Certificate',
              onPicked: (name, bytes) {
                ref.read(registrationControllerProvider.notifier).updateCasteCertificate(
                      name: name,
                      bytes: bytes,
                    );
              },
            ),
            onRemove: () {
              ref.read(registrationControllerProvider.notifier).removeCasteCertificate();
            },
          ),
          const SizedBox(height: 20),

          // Upload Your Photos Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Upload Your Photos'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: totalPhotos >= 2 ? AppColors.primary.withValues(alpha: 0.1) : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: totalPhotos >= 2 ? AppColors.primary.withValues(alpha: 0.3) : Colors.orange.shade300,
                  ),
                ),
                child: Text(
                  '$totalPhotos/6 Photos',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: totalPhotos >= 2 ? AppColors.primary : Colors.orange.shade800,
                  ),
                ),
              ),
            ],
          ),
          Text(
            'Add at least 2 profile photos (maximum 6). JPG, JPEG, or PNG up to 5MB.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              // Picked photos (bytes)
              if (regState.pickedPhotosData != null)
                for (int i = 0; i < regState.pickedPhotosData!.length; i++)
                  _buildPhotoThumbnail(
                    index: i,
                    bytes: regState.pickedPhotosData![i]['bytes'] as List<int>,
                    onRemove: () {
                      ref.read(registrationControllerProvider.notifier).removePickedPhoto(i);
                    },
                  ),
              // Remote photos (URLs)
              for (int j = 0; j < regState.photos.length; j++)
                _buildRemotePhotoThumbnail(
                  index: (regState.pickedPhotosData?.length ?? 0) + j,
                  url: regState.photos[j],
                  onRemove: () {
                    ref.read(registrationControllerProvider.notifier).removePhotoUrl(j);
                  },
                ),
              // Add Photo Box (if < 6)
              if (totalPhotos < 6)
                InkWell(
                  onTap: _showPhotoPickerSheet,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, size: 26, color: AppColors.primary),
                        SizedBox(height: 4),
                        Text(
                          'Add Photo',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (_photosError != null) ...[
            const SizedBox(height: 8),
            Text(
              _photosError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildPhotoThumbnail({
    required int index,
    required List<int> bytes,
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(
            Uint8List.fromList(bytes),
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 90,
              height: 90,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, size: 28, color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Photo ${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemotePhotoThumbnail({
    required int index,
    required String url,
    required VoidCallback onRemove,
  }) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 90,
              height: 90,
              color: Colors.grey.shade200,
              child: const Icon(Icons.broken_image, size: 28, color: Colors.grey),
            ),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Photo ${index + 1}',
              style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------
  // REVIEW REGISTRATION STEP
  // ----------------------------------------------------
  Widget _buildReviewStep(RegistrationState regState) {
    final totalPhotos = (regState.pickedPhotosData?.length ?? 0) + regState.photos.length;
    final dobText = regState.dob != null
        ? '${regState.dob!.day.toString().padLeft(2, '0')}/${regState.dob!.month.toString().padLeft(2, '0')}/${regState.dob!.year}'
        : 'Not specified';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionHeader(
          icon: Icons.rate_review_outlined,
          title: 'Review Registration',
          subtitle: 'Verify your details carefully before submitting',
        ),

        // Section A: Basic Details
        _buildReviewSectionCard(
          title: 'Basic Details',
          icon: Icons.person_outline,
          onEdit: () => _editStep(0),
          children: [
            _buildReviewItem('Profile Created For', regState.accountType),
            _buildReviewItem('Full Name', regState.fullName),
            _buildReviewItem('Mobile Number', regState.phone),
            _buildReviewItem('Date of Birth', dobText),
            _buildReviewItem('Mother Tongue', regState.motherTongue),
            _buildReviewItem('Email', regState.email),
          ],
        ),
        const SizedBox(height: 16),

        // Section B: Personal Details
        _buildReviewSectionCard(
          title: 'Personal Details',
          icon: Icons.favorite_outline,
          onEdit: () => _editStep(1),
          children: [
            _buildReviewItem('Gender', regState.gender),
            _buildReviewItem('Marital Status', regState.maritalStatus),
            _buildReviewItem('Height', regState.height),
            _buildReviewItem('Diet', regState.diet),
            _buildReviewItem('Physical Status / Special Case', regState.physicalStatus),
          ],
        ),
        const SizedBox(height: 16),

        // Section C: Education / Career
        _buildReviewSectionCard(
          title: 'Education / Career',
          icon: Icons.work_outline,
          onEdit: () => _editStep(2),
          children: [
            _buildReviewItem('Highest Education', regState.qualification),
            _buildReviewItem('Profession / Occupation', regState.occupation),
            _buildReviewItem('Annual Income', regState.annualIncome),
          ],
        ),
        const SizedBox(height: 16),

        // Section D: Location & Family
        _buildReviewSectionCard(
          title: 'Location & Family',
          icon: Icons.home_outlined,
          onEdit: () => _editStep(3),
          children: [
            _buildReviewItem('Country', regState.country),
            _buildReviewItem('State', regState.state.isNotEmpty ? regState.state : 'Not specified'),
            _buildReviewItem('City / District', regState.city.isNotEmpty ? regState.city : 'Not specified'),
            _buildReviewItem('Religion', regState.religion),
            _buildReviewItem('Caste', regState.caste),
            _buildReviewItem('Family Type', regState.familyType),
            const Divider(height: 20),
            const Text(
              'Maternal Uncles (Mama):',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 4),
            if (regState.maternalUnclesDetails.isEmpty)
              const Text('None added', style: TextStyle(color: Colors.grey, fontSize: 12))
            else
              for (int i = 0; i < regState.maternalUnclesDetails.length; i++)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    '${i + 1}. ${regState.maternalUnclesDetails[i].name}${regState.maternalUnclesDetails[i].mobile.isNotEmpty ? ' (${regState.maternalUnclesDetails[i].mobile})' : ''}${regState.maternalUnclesDetails[i].occupation.isNotEmpty ? ' - ${regState.maternalUnclesDetails[i].occupation}' : ''}',
                    style: const TextStyle(fontSize: 12.5, color: Colors.black87),
                  ),
                ),
            const SizedBox(height: 8),
            const Text(
              'Paternal Uncles (Kaka):',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 4),
            if (regState.paternalUnclesDetails.isEmpty)
              const Text('None added', style: TextStyle(color: Colors.grey, fontSize: 12))
            else
              for (int i = 0; i < regState.paternalUnclesDetails.length; i++)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    '${i + 1}. ${regState.paternalUnclesDetails[i].name}${regState.paternalUnclesDetails[i].mobile.isNotEmpty ? ' (${regState.paternalUnclesDetails[i].mobile})' : ''}${regState.paternalUnclesDetails[i].occupation.isNotEmpty ? ' - ${regState.paternalUnclesDetails[i].occupation}' : ''}',
                    style: const TextStyle(fontSize: 12.5, color: Colors.black87),
                  ),
                ),
          ],
        ),
        const SizedBox(height: 16),

        // Section E: Documents
        _buildReviewSectionCard(
          title: 'Documents',
          icon: Icons.description_outlined,
          onEdit: () => _editStep(4),
          children: [
            _buildReviewDocumentItem(
              'Aadhaar Front',
              regState.aadharCardName.isNotEmpty
                  ? regState.aadharCardName
                  : (regState.aadharCardUrl.isNotEmpty ? 'Uploaded' : 'Not uploaded'),
              regState.aadharBytes != null || regState.aadharCardUrl.isNotEmpty,
            ),
            _buildReviewDocumentItem(
              'Aadhaar Back',
              regState.aadharBackName.isNotEmpty
                  ? regState.aadharBackName
                  : (regState.aadharBackUrl.isNotEmpty ? 'Uploaded' : 'Not uploaded'),
              regState.aadharBackBytes != null || regState.aadharBackUrl.isNotEmpty,
            ),
            _buildReviewDocumentItem(
              'Caste Certificate',
              regState.casteCertificateName.isNotEmpty
                  ? regState.casteCertificateName
                  : (regState.casteCertificateUrl.isNotEmpty ? 'Uploaded' : 'Not uploaded'),
              regState.casteCertificateBytes != null ||
                  regState.casteCertificateUrl.isNotEmpty ||
                  regState.casteCertificateName.isNotEmpty,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Section F: Photos
        _buildReviewSectionCard(
          title: 'Profile Photos ($totalPhotos)',
          icon: Icons.photo_library_outlined,
          onEdit: () => _editStep(4),
          children: [
            if (totalPhotos == 0)
              const Text('No photos selected', style: TextStyle(color: Colors.red, fontSize: 12.5))
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (regState.pickedPhotosData != null)
                    for (int i = 0; i < regState.pickedPhotosData!.length; i++)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          Uint8List.fromList(regState.pickedPhotosData![i]['bytes'] as List<int>),
                          width: 68,
                          height: 68,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 68,
                            height: 68,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image, size: 24, color: Colors.grey),
                          ),
                        ),
                      ),
                  for (int j = 0; j < regState.photos.length; j++)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        regState.photos[j],
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 68,
                          height: 68,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, size: 24, color: Colors.grey),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildReviewSectionCard({
    required String title,
    required IconData icon,
    required VoidCallback onEdit,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
              ),
              InkWell(
                onTap: onEdit,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 13, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildReviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Not specified',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2A2A2A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewDocumentItem(String label, String value, bool isUploaded) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            isUploaded ? Icons.check_circle : Icons.cancel,
            size: 16,
            color: isUploaded ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: isUploaded ? Colors.black87 : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dotted / Dashed Upload Box Widget
  Widget _buildDottedUploadBox({
    required String fileName,
    required bool isUploaded,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 86,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUploaded ? Colors.green.shade400 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: isUploaded
            ? Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fileName.isNotEmpty ? fileName : 'Document Uploaded',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Ready to submit',
                          style: TextStyle(color: Colors.green, fontSize: 11.5),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red, size: 20),
                    onPressed: onRemove,
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Click to upload',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'JPEG, PNG, or PDF (Max 5MB)',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
