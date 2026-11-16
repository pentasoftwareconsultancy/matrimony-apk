import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../profile/domain/models/profile_model.dart';
import '../controllers/registration_controller.dart';
import '../../../home/presentation/controllers/home_controller.dart';

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

  // Text controllers for steps
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late TextEditingController _casteController;
  late TextEditingController _religionController;
  late TextEditingController _bloodGroupController;
  late TextEditingController _addressController;
  late TextEditingController _rashiController;
  late TextEditingController _nakshatraController;
  late TextEditingController _ageController;

  late TextEditingController _qualificationController;
  late TextEditingController _occupationController;
  late TextEditingController _incomeController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;

  late TextEditingController _fatherNameController;
  late TextEditingController _motherNameController;
  late TextEditingController _siblingsController;

  // Maternal and Paternal Uncles dynamic state
  int _maternalUncleCount = 0;
  int _paternalUncleCount = 0;
  final List<Map<String, TextEditingController>> _maternalUncleControllers = [];
  final List<Map<String, TextEditingController>> _paternalUncleControllers = [];

  late TextEditingController _aadharNumberController;

  // Password visibility state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Inline editing state on Review Screen
  String? _editingFieldKey;

  // Temp inline editing variables
  String _tempAccountType = '';
  String _tempGender = '';
  String _tempMaritalStatus = '';
  DateTime? _tempDob;
  String _tempReligion = '';
  String _tempBloodGroup = '';
  String _tempRashi = '';
  bool _tempManglik = false;
  String _tempFamilyType = '';

  String _tempAadharCardName = '';
  List<int>? _tempAadharBytes;

  String _tempCasteCertificatePath = '';
  String _tempCasteCertificateName = '';
  List<int>? _tempCasteCertificateBytes;

  List<String> _tempPhotos = [];
  List<Map<String, dynamic>>? _tempPickedPhotosData;

  @override
  void initState() {
    super.initState();
    final regState = ref.read(registrationControllerProvider);

    _fullNameController = TextEditingController(text: regState.fullName);
    _phoneController = TextEditingController(text: regState.phone);
    _emailController = TextEditingController(text: regState.email);
    _passwordController = TextEditingController(text: regState.password);
    _confirmPasswordController = TextEditingController(text: regState.confirmPassword);

    _casteController = TextEditingController(text: regState.caste);
    _religionController = TextEditingController(text: regState.religion);
    _bloodGroupController = TextEditingController(text: regState.bloodGroup);
    _addressController = TextEditingController(text: regState.address);
    _rashiController = TextEditingController(text: regState.rashi);
    _nakshatraController = TextEditingController(text: regState.nakshatra);
    _ageController = TextEditingController(text: regState.age?.toString() ?? '');

    _qualificationController = TextEditingController(text: regState.qualification);
    _occupationController = TextEditingController(text: regState.occupation);
    _incomeController = TextEditingController(text: regState.annualIncome);
    _stateController = TextEditingController(text: regState.state);
    _cityController = TextEditingController(text: regState.city);

    _fatherNameController = TextEditingController(text: regState.fatherName);
    _motherNameController = TextEditingController(text: regState.motherName);
    _siblingsController = TextEditingController(text: regState.siblings.toString());

    _maternalUncleCount = regState.maternalUnclesDetails.length;
    for (final u in regState.maternalUnclesDetails) {
      _maternalUncleControllers.add({
        'name': TextEditingController(text: u.name),
        'profession': TextEditingController(text: u.occupation),
      });
    }

    _paternalUncleCount = regState.paternalUnclesDetails.length;
    for (final u in regState.paternalUnclesDetails) {
      _paternalUncleControllers.add({
        'name': TextEditingController(text: u.name),
        'profession': TextEditingController(text: u.occupation),
      });
    }

    _aadharNumberController = TextEditingController(text: regState.aadharNumber);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _casteController.dispose();
    _religionController.dispose();
    _bloodGroupController.dispose();
    _addressController.dispose();
    _rashiController.dispose();
    _nakshatraController.dispose();
    _ageController.dispose();
    _qualificationController.dispose();
    _occupationController.dispose();
    _incomeController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _siblingsController.dispose();
    for (final map in _maternalUncleControllers) {
      map['name']?.dispose();
      map['profession']?.dispose();
    }
    for (final map in _paternalUncleControllers) {
      map['name']?.dispose();
      map['profession']?.dispose();
    }
    _aadharNumberController.dispose();
    super.dispose();
  }

  void _updateMaternalUncleCount(int newCount) {
    if (newCount < 0) newCount = 0;
    setState(() {
      _maternalUncleCount = newCount;
      while (_maternalUncleControllers.length < newCount) {
        _maternalUncleControllers.add({
          'name': TextEditingController(),
          'profession': TextEditingController(),
        });
      }
      while (_maternalUncleControllers.length > newCount) {
        final removed = _maternalUncleControllers.removeLast();
        removed['name']?.dispose();
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
          'profession': TextEditingController(),
        });
      }
      while (_paternalUncleControllers.length > newCount) {
        final removed = _paternalUncleControllers.removeLast();
        removed['name']?.dispose();
        removed['profession']?.dispose();
      }
    });
  }

  void _startEditingField(String fieldKey, RegistrationState regState) {
    if (fieldKey == 'maternalUnclesCount' || fieldKey == 'paternalUnclesCount') {
      ref.read(registrationControllerProvider.notifier).setStep(3);
      return;
    }
    setState(() {
      _editingFieldKey = fieldKey;

      _tempAccountType = regState.accountType;
      _tempGender = regState.gender;
      _tempMaritalStatus = regState.maritalStatus;
      _tempDob = regState.dob;
      _tempReligion = regState.religion;
      _tempBloodGroup = regState.bloodGroup;
      _tempRashi = regState.rashi;
      _tempManglik = regState.manglik;
      _tempFamilyType = regState.familyType;

      _tempAadharCardName = regState.aadharCardName;
      _tempAadharBytes = regState.aadharBytes;
      _tempCasteCertificatePath = regState.casteCertificatePath;
      _tempCasteCertificateName = regState.casteCertificateName;
      _tempCasteCertificateBytes = regState.casteCertificateBytes;
      _tempPhotos = List<String>.from(regState.photos);
      _tempPickedPhotosData = regState.pickedPhotosData != null ? List<Map<String, dynamic>>.from(regState.pickedPhotosData!) : [];

      _fullNameController.text = regState.fullName;
      _phoneController.text = regState.phone;
      _emailController.text = regState.email;
      _casteController.text = regState.caste;
      _religionController.text = regState.religion;
      _bloodGroupController.text = regState.bloodGroup;
      _addressController.text = regState.address;
      _rashiController.text = regState.rashi;
      _nakshatraController.text = regState.nakshatra;
      _ageController.text = regState.age?.toString() ?? '';
      _qualificationController.text = regState.qualification;
      _occupationController.text = regState.occupation;
      _incomeController.text = regState.annualIncome;
      _stateController.text = regState.state;
      _cityController.text = regState.city;
      _fatherNameController.text = regState.fatherName;
      _motherNameController.text = regState.motherName;
      _siblingsController.text = regState.siblings.toString();
      _aadharNumberController.text = regState.aadharNumber;
    });
  }

  void _nextStep(int currentStep) async {
    if (currentStep == 0) {
      if (_step1Key.currentState!.validate()) {
        ref.read(registrationControllerProvider.notifier).updateStep1(
              fullName: _fullNameController.text,
              phone: _phoneController.text,
              email: _emailController.text,
              password: _passwordController.text,
              confirmPassword: _confirmPasswordController.text,
            );
        ref.read(registrationControllerProvider.notifier).nextStep();
      }
    } else if (currentStep == 1) {
      if (_step2Key.currentState!.validate()) {
        final regState = ref.read(registrationControllerProvider);
        ref.read(registrationControllerProvider.notifier).updateStep2(
              caste: _casteController.text,
              religion: _religionController.text,
              bloodGroup: _bloodGroupController.text,
              address: _addressController.text,
              rashi: _rashiController.text,
              nakshatra: _nakshatraController.text.isNotEmpty ? _nakshatraController.text : regState.nakshatra,
            );
        ref.read(registrationControllerProvider.notifier).nextStep();
      }
    } else if (currentStep == 2) {
      if (_step3Key.currentState!.validate()) {
        final regState = ref.read(registrationControllerProvider);
        ref.read(registrationControllerProvider.notifier).updateStep3(
              qualification: _qualificationController.text,
              occupation: _occupationController.text,
              annualIncome: _incomeController.text,
              stateVal: _stateController.text.isNotEmpty ? _stateController.text : regState.state,
              city: _cityController.text.isNotEmpty ? _cityController.text : regState.city,
            );
        ref.read(registrationControllerProvider.notifier).nextStep();
      }
    } else if (currentStep == 3) {
      if (_step4Key.currentState!.validate()) {
        final maternalUncles = <UncleDetail>[];
        for (int i = 0; i < _maternalUncleCount; i++) {
          final name = _maternalUncleControllers[i]['name']!.text.trim();
          final profession = _maternalUncleControllers[i]['profession']!.text.trim();
          if (name.isNotEmpty || profession.isNotEmpty) {
            maternalUncles.add(UncleDetail(
              name: name,
              occupation: profession,
            ));
          }
        }
        final paternalUncles = <UncleDetail>[];
        for (int i = 0; i < _paternalUncleCount; i++) {
          final name = _paternalUncleControllers[i]['name']!.text.trim();
          final profession = _paternalUncleControllers[i]['profession']!.text.trim();
          if (name.isNotEmpty || profession.isNotEmpty) {
            paternalUncles.add(UncleDetail(
              name: name,
              occupation: profession,
            ));
          }
        }

        ref.read(registrationControllerProvider.notifier).updateStep4(
              fatherName: _fatherNameController.text,
              motherName: _motherNameController.text,
              siblings: int.tryParse(_siblingsController.text) ?? 0,
              maternalUnclesDetails: maternalUncles,
              paternalUnclesDetails: paternalUncles,
            );
        ref.read(registrationControllerProvider.notifier).nextStep();
      }
    } else if (currentStep == 4) {
      if (_step5Key.currentState!.validate()) {
        final regState = ref.read(registrationControllerProvider);
        if (regState.aadharBytes == null && regState.aadharCardUrl.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please upload Aadhar card document')),
          );
          return;
        }
        if (regState.casteCertificateName.isEmpty && regState.casteCertificateUrl.isEmpty && regState.casteCertificatePath.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Caste Certificate is required.')),
          );
          return;
        }
        if (regState.photos.length < 3 && (regState.pickedPhotosData == null || regState.pickedPhotosData!.length < 3)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please upload at least 3 profile photos (minimum 3, maximum 6)')),
          );
          return;
        }
        if ((regState.pickedPhotosData?.length ?? 0) > 6) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You can upload a maximum of 6 profile photos')),
          );
          return;
        }

        ref.read(registrationControllerProvider.notifier).updateStep5(
              aadharNumber: _aadharNumberController.text,
            );
        ref.read(registrationControllerProvider.notifier).nextStep();
      }
    }
  }

  void _prevStep() {
    ref.read(registrationControllerProvider.notifier).prevStep();
  }

  Future<void> _pickAadharCard() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
      if (picked != null) {
        final bytes = await picked.readAsBytes();
        ref.read(registrationControllerProvider.notifier).updateStep5(
              aadharCardName: picked.name,
              aadharBytes: bytes,
            );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick Aadhar card: $e')),
      );
    }
  }

  Future<void> _pickCasteCertificate() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.size > 10 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File size must be less than 10 MB')),
          );
          return;
        }

        final bytes = file.bytes;
        final path = kIsWeb ? '' : (file.path ?? '');
        final name = file.name;

        ref.read(registrationControllerProvider.notifier).updateCasteCertificate(
              path: path,
              name: name,
              bytes: bytes,
            );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick Caste Certificate: $e')),
      );
    }
  }

  void _previewCasteCertificate(RegistrationState regState) {
    final bytes = regState.casteCertificateBytes;
    final name = regState.casteCertificateName;
    final path = regState.casteCertificatePath;
    final url = regState.casteCertificateUrl;
    
    if (name.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) {
        final isImage = name.toLowerCase().endsWith('.png') ||
            name.toLowerCase().endsWith('.jpg') ||
            name.toLowerCase().endsWith('.jpeg');
            
        Widget content;
        if (isImage) {
          if (bytes != null) {
            content = Image.memory(Uint8List.fromList(bytes), fit: BoxFit.contain);
          } else if (!kIsWeb && path.isNotEmpty) {
            content = Image.file(File(path), fit: BoxFit.contain);
          } else if (url.isNotEmpty) {
            content = Image.network(url, fit: BoxFit.contain);
          } else {
            content = const Center(child: Text("No image data available"));
          }
        } else {
          content = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.picture_as_pdf, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "PDF Document Preview\n(Size check and format valid)",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          );
        }

        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(name, style: const TextStyle(color: Colors.black, fontSize: 14)),
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                padding: const EdgeInsets.all(16),
                child: content,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickProfilePhotos() async {
    try {
      final picker = ImagePicker();
      final List<XFile> pickedList = await picker.pickMultiImage(imageQuality: 80);
      if (pickedList.isNotEmpty) {
        final regState = ref.read(registrationControllerProvider);
        final List<Map<String, dynamic>> currentPicked = List.from(regState.pickedPhotosData ?? []);
        final List<String> currentPaths = List.from(regState.photos);

        for (final file in pickedList) {
          if (currentPicked.length >= 6) break;
          final bytes = await file.readAsBytes();
          currentPicked.add({
            'bytes': bytes,
            'fileName': file.name,
          });
          currentPaths.add(file.path);
        }

        ref.read(registrationControllerProvider.notifier).updateStep5(
              pickedPhotosData: currentPicked,
              photos: currentPaths,
            );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick photos: $e')),
      );
    }
  }

  void _removePhoto(int index) {
    final regState = ref.read(registrationControllerProvider);
    final List<Map<String, dynamic>> currentPicked = List.from(regState.pickedPhotosData ?? []);
    final List<String> currentPaths = List.from(regState.photos);

    if (index < currentPicked.length) {
      currentPicked.removeAt(index);
    }
    if (index < currentPaths.length) {
      currentPaths.removeAt(index);
    }

    ref.read(registrationControllerProvider.notifier).updateStep5(
          pickedPhotosData: currentPicked,
          photos: currentPaths,
        );
  }

  // Helper to build dropdown sheet selection list
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
                child: Text(title, style: AppTextStyles.titleMedium),
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

  @override
  Widget build(BuildContext context) {
    final regState = ref.watch(registrationControllerProvider);
    final currentStep = regState.currentStep;

    ref.listen(registrationControllerProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
        ref.read(registrationControllerProvider.notifier).clearError();
      }
    });

    final bool isReviewScreen = currentStep == 5;

    // Step-specific details mapping
    final double progressPercent = currentStep == 0
        ? 0.10
        : currentStep == 1
            ? 0.35
            : currentStep == 2
                ? 0.45
                : currentStep == 3
                    ? 0.55
                    : 0.60;
                
    final String stepBadgeText = currentStep == 0
        ? '10% completed'
        : currentStep == 1
            ? '35% completed'
            : currentStep == 2
                ? '45% completed'
                : currentStep == 3
                    ? '55% completed'
                    : '60% completed';

    final String stepSubtitle = currentStep == 0
        ? '• Account creation'
        : currentStep == 1
            ? '• Basic profile'
            : currentStep == 2
                ? '• Education details'
                : currentStep == 3
                    ? '• Family details'
                    : '• Photos and documents';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (currentStep > 0) {
          _prevStep();
        } else {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: currentStep > 0 ? _prevStep : () => context.go('/login'),
          ),
          title: Text(
            isReviewScreen ? 'Review details' : 'Register',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (!isReviewScreen) ...[
                // Progress Bar & Section Bullet
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            stepSubtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECEF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              stepBadgeText,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppSpacing.verticalSm,
                      Stack(
                        children: [
                          Container(
                            height: 6,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 6,
                            width: MediaQuery.of(context).size.width * progressPercent,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Review header subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Please verify all information before submitting your profile.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              ],
              
              // Step Views
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _buildStepForm(currentStep, regState),
                  ),
                ),
              ),
              
              // Bottom Action buttons (only for steps 1-5)
              if (!isReviewScreen)
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      if (currentStep > 0) ...[
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: _prevStep,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 54),
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(27),
                              ),
                            ),
                            child: Text('Back', style: AppTextStyles.bodyLarge.copyWith(color: Colors.black)),
                          ),
                        ),
                        AppSpacing.horizontalMd,
                      ],
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: regState.isLoading ? null : () => _nextStep(currentStep),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(27),
                            ),
                          ),
                          child: regState.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Save and Next'),
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
        return _buildReviewScreen(regState);
      default:
        return const SizedBox.shrink();
    }
  }

  // Label text builder with red asterisk for required fields
  Widget _buildLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: RichText(
        text: TextSpan(
          text: text,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
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

  // ----------------------------------------------------
  // STEP 1 - ACCOUNT CREATION
  // ----------------------------------------------------
  Widget _buildStep1(RegistrationState regState) {
    return Form(
      key: _step1Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel('Register as'),
          InkWell(
            onTap: () => _showDropdownSelection(
              title: 'Register as',
              options: const ['Bride', 'Groom', 'Parent', 'Guardian', 'Sibling', 'Friend', 'Relative'],
              selectedValue: regState.accountType,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep1(accountType: val);
              },
            ),
            child: InputDecorator(
              decoration: const InputDecoration(hintText: 'Select relation'),
              child: Text(regState.accountType.isEmpty ? 'Select relation' : regState.accountType),
            ),
          ),
          AppSpacing.verticalMd,

          _buildLabel('Full name'),
          TextFormField(
            controller: _fullNameController,
            decoration: const InputDecoration(hintText: 'Enter full name'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Full name is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Phone number'),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(hintText: 'Enter phone number'),
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Phone number is required';
              if (val.trim().length != 10) return 'Phone number must be exactly 10 digits';
              return null;
            },
          ),
          AppSpacing.verticalMd,

          _buildLabel('Email id'),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Enter email id'),
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Email is required';
              if (!val.contains('@')) return 'Email must contain @';
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+com$', caseSensitive: false).hasMatch(val.trim())) {
                return 'Please enter a valid email ending with .com';
              }
              return null;
            },
          ),
          AppSpacing.verticalMd,

          _buildLabel('New password'),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Enter password',
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            validator: (val) {
              if (val == null || val.isEmpty) return 'Password is required';
              if (val.length < 8) return 'Password must be at least 8 characters';
              if (!RegExp(r'[A-Z]').hasMatch(val)) return 'Password must contain at least 1 uppercase letter';
              if (!RegExp(r'[a-z]').hasMatch(val)) return 'Password must contain at least 1 lowercase letter';
              return null;
            },
          ),
          AppSpacing.verticalMd,

          _buildLabel('Confirm password'),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Confirm password',
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
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
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 2 - BASIC PROFILE
  // ----------------------------------------------------
  Widget _buildStep2(RegistrationState regState) {
    return Form(
      key: _step2Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel('Gender'),
          InkWell(
            onTap: () => _showDropdownSelection(
              title: 'Gender',
              options: const ['Male', 'Female', 'Other'],
              selectedValue: regState.gender,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep2(gender: val);
              },
            ),
            child: InputDecorator(
              decoration: const InputDecoration(hintText: 'Select gender'),
              child: Text(regState.gender.isEmpty ? 'Select gender' : regState.gender),
            ),
          ),
          AppSpacing.verticalMd,

          _buildLabel('DOB'),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: regState.dob ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                final today = DateTime.now();
                int ageVal = today.year - picked.year;
                if (today.month < picked.month || (today.month == picked.month && today.day < picked.day)) {
                  ageVal--;
                }
                ref.read(registrationControllerProvider.notifier).updateStep2(
                      dob: picked,
                      age: ageVal,
                    );
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(hintText: 'Select DOB'),
              child: Text(regState.dob == null
                  ? 'Select DOB'
                  : '${regState.dob!.day}/${regState.dob!.month}/${regState.dob!.year}'),
            ),
          ),
          AppSpacing.verticalMd,

          _buildLabel('Religion'),
          TextFormField(
            controller: _religionController,
            decoration: const InputDecoration(hintText: 'Enter religion'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Religion is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Caste'),
          TextFormField(
            controller: _casteController,
            decoration: const InputDecoration(hintText: 'Enter caste'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Caste is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Marital Status'),
          InkWell(
            onTap: () => _showDropdownSelection(
              title: 'Marital Status',
              options: const ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce'],
              selectedValue: regState.maritalStatus,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep2(maritalStatus: val);
              },
            ),
            child: InputDecorator(
              decoration: const InputDecoration(hintText: 'Select marital status'),
              child: Text(regState.maritalStatus.isEmpty ? 'Select marital status' : regState.maritalStatus),
            ),
          ),
          AppSpacing.verticalMd,

          _buildLabel('Blood group'),
          DropdownButtonFormField<String>(
            value: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].contains(_bloodGroupController.text)
                ? _bloodGroupController.text
                : (const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].contains(regState.bloodGroup)
                    ? regState.bloodGroup
                    : null),
            decoration: const InputDecoration(hintText: 'Select blood group'),
            items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                _bloodGroupController.text = val;
                ref.read(registrationControllerProvider.notifier).updateStep2(bloodGroup: val);
              }
            },
            validator: (val) => val == null || val.trim().isEmpty ? 'Blood group is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Address', isRequired: false),
          TextFormField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(hintText: 'Enter address'),
          ),
          AppSpacing.verticalMd,

          _buildLabel('Rashi'),
          TextFormField(
            controller: _rashiController,
            decoration: const InputDecoration(hintText: 'Enter rashi'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Rashi is required' : null,
          ),
          AppSpacing.verticalMd,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLabel('Manglik', isRequired: false),
              Switch(
                value: regState.manglik,
                activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                activeColor: AppColors.primary,
                onChanged: (val) {
                  ref.read(registrationControllerProvider.notifier).updateStep2(manglik: val);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 3 - EDUCATION & CAREER
  // ----------------------------------------------------
  Widget _buildStep3(RegistrationState regState) {
    return Form(
      key: _step3Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel('Highest qualification'),
          TextFormField(
            controller: _qualificationController,
            decoration: const InputDecoration(hintText: 'Enter qualification'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Qualification is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Occupation'),
          TextFormField(
            controller: _occupationController,
            decoration: const InputDecoration(hintText: 'Enter occupation'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Occupation is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Annual income'),
          TextFormField(
            controller: _incomeController,
            decoration: const InputDecoration(hintText: 'Enter annual income (e.g. 800000 or 8 LPA)'),
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Annual income is required';
              if (!RegExp(r'\d').hasMatch(val)) return 'Enter a numeric annual income (e.g. 800000 or 8 LPA)';
              return null;
            },
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 4 - FAMILY DETAILS
  // ----------------------------------------------------
  Widget _buildStep4(RegistrationState regState) {
    return Form(
      key: _step4Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel('Father full name'),
          TextFormField(
            controller: _fatherNameController,
            decoration: const InputDecoration(hintText: 'Enter father\'s name'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Father name is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Mother full name'),
          TextFormField(
            controller: _motherNameController,
            decoration: const InputDecoration(hintText: 'Enter mother\'s name'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Mother name is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Number of siblings'),
          TextFormField(
            controller: _siblingsController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: const InputDecoration(hintText: 'Enter number of siblings'),
            validator: (val) => val == null || val.trim().isEmpty ? 'Siblings number is required' : null,
          ),
          AppSpacing.verticalMd,

          _buildLabel('Family type'),
          InkWell(
            onTap: () => _showDropdownSelection(
              title: 'Family type',
              options: const ['Joint', 'Nuclear', 'Extended'],
              selectedValue: regState.familyType,
              onSelected: (val) {
                ref.read(registrationControllerProvider.notifier).updateStep4(familyType: val);
              },
            ),
            child: InputDecorator(
              decoration: const InputDecoration(hintText: 'Select family type'),
              child: Text(regState.familyType.isEmpty ? 'Select family type' : regState.familyType),
            ),
          ),
          AppSpacing.verticalMd,

          _buildLabel('Number of Maternal Uncles', isRequired: false),
          DropdownButtonFormField<int>(
            key: const Key('maternal_uncles_count_field'),
            value: _maternalUncleCount,
            decoration: const InputDecoration(hintText: 'Select number of maternal uncles'),
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
              AppSpacing.verticalMd,
              _buildLabel('Maternal Uncle ${i + 1} Name'),
              TextFormField(
                key: Key('maternal_uncle_name_$i'),
                controller: _maternalUncleControllers[i]['name'],
                decoration: InputDecoration(hintText: 'Enter Maternal Uncle ${i + 1} name'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Maternal Uncle ${i + 1} Name is required' : null,
              ),
              AppSpacing.verticalMd,
              _buildLabel('Maternal Uncle ${i + 1} Profession', isRequired: false),
              TextFormField(
                key: Key('maternal_uncle_profession_$i'),
                controller: _maternalUncleControllers[i]['profession'],
                decoration: InputDecoration(hintText: 'Enter Maternal Uncle ${i + 1} profession'),
              ),
            ],
          ],
          AppSpacing.verticalMd,

          _buildLabel('Number of Paternal Uncles', isRequired: false),
          DropdownButtonFormField<int>(
            key: const Key('paternal_uncles_count_field'),
            value: _paternalUncleCount,
            decoration: const InputDecoration(hintText: 'Select number of paternal uncles'),
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
              AppSpacing.verticalMd,
              _buildLabel('Paternal Uncle ${i + 1} Name'),
              TextFormField(
                key: Key('paternal_uncle_name_$i'),
                controller: _paternalUncleControllers[i]['name'],
                decoration: InputDecoration(hintText: 'Enter Paternal Uncle ${i + 1} name'),
                validator: (val) => val == null || val.trim().isEmpty ? 'Paternal Uncle ${i + 1} Name is required' : null,
              ),
              AppSpacing.verticalMd,
              _buildLabel('Paternal Uncle ${i + 1} Profession', isRequired: false),
              TextFormField(
                key: Key('paternal_uncle_profession_$i'),
                controller: _paternalUncleControllers[i]['profession'],
                decoration: InputDecoration(hintText: 'Enter Paternal Uncle ${i + 1} profession'),
              ),
            ],
          ],
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // STEP 5 - DOCUMENTS & PHOTOS
  // ----------------------------------------------------
  Widget _buildStep5(RegistrationState regState) {
    return Form(
      key: _step5Key,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel('Aadhar Card number'),
          TextFormField(
            controller: _aadharNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(12),
            ],
            decoration: const InputDecoration(hintText: 'Enter Aadhar card number'),
            validator: (val) {
              if (val == null || val.trim().isEmpty) return 'Aadhar card number is required';
              if (val.trim().length != 12) return 'Aadhar number must be exactly 12 digits';
              return null;
            },
          ),
          AppSpacing.verticalMd,

          _buildLabel('Upload Aadhar card'),
          InkWell(
            onTap: _pickAadharCard,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: regState.aadharCardName.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            regState.aadharCardName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Uploaded', style: TextStyle(color: Colors.green, fontSize: 11)),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade400, size: 36),
                        const SizedBox(height: 8),
                        const Text('Upload Card', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      ],
                    ),
            ),
          ),
          AppSpacing.verticalMd,

          _buildLabel('Caste Certificate'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: regState.casteCertificateName.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.description, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              regState.casteCertificateName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Uploaded', style: TextStyle(color: Colors.green, fontSize: 11)),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 8),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          TextButton.icon(
                            onPressed: () => _previewCasteCertificate(regState),
                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 18,
                              color: Colors.blue,
                            ),
                            label: const Text(
                              '',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _pickCasteCertificate,
                            icon: const Icon(
                              Icons.refresh_outlined,
                              size: 18,
                              color: Colors.orange,
                            ),
                            label: const Text(
                              '',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              ref
                                  .read(registrationControllerProvider.notifier)
                                  .removeCasteCertificate();
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: Colors.red,
                            ),
                            label: const Text(
                              '',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      )

                    ],
                  )
                : InkWell(
                    onTap: _pickCasteCertificate,
                    child: Column(
                      children: [
                        Icon(Icons.cloud_upload_outlined, color: Colors.grey.shade400, size: 36),
                        const SizedBox(height: 8),
                        const Text('Upload Caste Certificate', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
          ),
          AppSpacing.verticalMd,

          _buildLabel('Upload Photos (Min 3, Max 6)'),
          const Text(
            'Add at least 3 photos to activate your profile',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          AppSpacing.verticalMd,
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ...List.generate(regState.photos.length, (index) {
                final Uint8List? bytes =
                    (regState.pickedPhotosData != null && index < regState.pickedPhotosData!.length)
                        ? regState.pickedPhotosData![index]['bytes'] as Uint8List?
                        : null;
                return Stack(
                  children: [
                    Container(
                      width: 90,
                      height: 120,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: _resolvePhotoProvider(regState.photos[index], bytes: bytes),
                          fit: BoxFit.cover,
                          onError: (e, s) {},
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, color: Colors.white, size: 14),
                        ),
                      ),
                    )
                  ],
                );
              }),
              if (regState.photos.length < 6)
                GestureDetector(
                  onTap: _pickProfilePhotos,
                  child: Container(
                    width: 90,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: Colors.grey.shade400),
                        const SizedBox(height: 4),
                        const Text('Add Photo', style: TextStyle(color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // REVIEW DETAILS & CONFIRM PROFILE
  // ----------------------------------------------------
  String _formatDob(DateTime? date) {
    if (date == null) return '-';
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  bool _isConfirmEnabled(RegistrationState regState) {
    // 1. Terms & Conditions checkbox is checked
    if (!regState.isConfirmDetailsAccepted) return false;
    if (regState.isLoading) return false;

    // 2. All required fields are completed
    // Step 1
    if (regState.accountType.isEmpty) return false;
    if (regState.fullName.trim().isEmpty) return false;
    if (regState.phone.trim().isEmpty) return false;
    if (regState.email.trim().isEmpty) return false;
    if (regState.password.isEmpty) return false;
    // Step 2
    if (regState.gender.isEmpty) return false;
    if (regState.dob == null) return false;
    if (regState.religion.trim().isEmpty) return false;
    if (regState.caste.trim().isEmpty) return false;
    if (regState.maritalStatus.isEmpty) return false;
    if (regState.bloodGroup.trim().isEmpty) return false;
    // Step 3
    if (regState.qualification.trim().isEmpty) return false;
    if (regState.occupation.trim().isEmpty) return false;
    if (regState.annualIncome.trim().isEmpty) return false;
    // Step 4
    if (regState.fatherName.trim().isEmpty) return false;
    if (regState.motherName.trim().isEmpty) return false;
    if (regState.familyType.isEmpty) return false;
    
    // 3. Aadhaar uploaded
    if (regState.aadharNumber.trim().isEmpty) return false;
    final hasAadharDoc = regState.aadharBytes != null || regState.aadharCardUrl.isNotEmpty;
    if (!hasAadharDoc) return false;

    // Caste Certificate uploaded
    final hasCasteDoc = regState.casteCertificateBytes != null || regState.casteCertificateUrl.isNotEmpty || regState.casteCertificatePath.isNotEmpty;
    if (!hasCasteDoc) return false;

    // 4. Minimum 3 profile photos uploaded
    final totalPhotosCount = regState.photos.length;
    if (totalPhotosCount < 3) return false;

    return true;
  }

  Widget _buildReviewScreen(RegistrationState regState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildReviewSectionHeader('PERSONAL INFO'),
        _buildReviewCard([
          _buildInlineEditableRow(
            label: 'REGISTER AS',
            value: regState.accountType,
            fieldKey: 'accountType',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep1(accountType: _tempAccountType),
            editorWidget: DropdownButtonFormField<String>(
              value: const ['Bride', 'Groom', 'Parent', 'Guardian', 'Sibling', 'Friend', 'Relative'].contains(_tempAccountType) ? _tempAccountType : null,
              items: const ['Bride', 'Groom', 'Parent', 'Guardian', 'Sibling', 'Friend', 'Relative'].map((val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _tempAccountType = val);
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          _buildInlineEditableRow(
            label: 'FULL NAME',
            value: regState.fullName,
            fieldKey: 'fullName',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep1(fullName: _fullNameController.text),
            editorWidget: TextFormField(
              controller: _fullNameController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter full name'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'PHONE NUMBER',
            value: regState.phone,
            fieldKey: 'phone',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep1(phone: _phoneController.text),
            editorWidget: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter phone number'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'EMAIL ID',
            value: regState.email,
            fieldKey: 'email',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep1(email: _emailController.text),
            editorWidget: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter email id'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'NEW PASSWORD',
            value: '••••••••••',
            fieldKey: 'password',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep1(password: _passwordController.text, confirmPassword: _passwordController.text),
            editorWidget: TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter new password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
            ),
          ),
          _buildInlineEditableRow(
            label: 'GENDER',
            value: regState.gender,
            fieldKey: 'gender',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(gender: _tempGender),
            editorWidget: Row(
              children: ['Male', 'Female', 'Other'].map((g) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: g,
                      groupValue: _tempGender,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _tempGender = val);
                        }
                      },
                    ),
                    Text(g),
                    const SizedBox(width: 8),
                  ],
                );
              }).toList(),
            ),
          ),
          _buildInlineEditableRow(
            label: 'DATE OF BIRTH',
            value: _formatDob(regState.dob),
            fieldKey: 'dob',
            onSave: () {
              final today = DateTime.now();
              int? ageVal;
              if (_tempDob != null) {
                ageVal = today.year - _tempDob!.year;
                if (today.month < _tempDob!.month || (today.month == _tempDob!.month && today.day < _tempDob!.day)) {
                  ageVal--;
                }
              }
              ref.read(registrationControllerProvider.notifier).updateStep2(dob: _tempDob, age: ageVal);
            },
            editorWidget: GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _tempDob ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _tempDob = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_tempDob == null ? 'Select Date' : '${_tempDob!.day}/${_tempDob!.month}/${_tempDob!.year}'),
                    const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          _buildInlineEditableRow(
            label: 'RELIGION',
            value: regState.religion,
            fieldKey: 'religion',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(religion: _tempReligion),
            editorWidget: GestureDetector(
              onTap: () {
                _showSearchableBottomSheet(
                  title: 'Select Religion',
                  options: const ['Hindu', 'Muslim', 'Christian', 'Sikh', 'Buddhist', 'Jain', 'Parsi', 'Other'],
                  selectedValue: _tempReligion,
                  onSelected: (val) {
                    setState(() {
                      _tempReligion = val;
                    });
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_tempReligion.isEmpty ? 'Select Religion' : _tempReligion),
                    const Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          _buildInlineEditableRow(
            label: 'CASTE',
            value: regState.caste,
            fieldKey: 'caste',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(caste: _casteController.text),
            editorWidget: TextFormField(
              controller: _casteController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter caste'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'MARITAL STATUS',
            value: regState.maritalStatus,
            fieldKey: 'maritalStatus',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(maritalStatus: _tempMaritalStatus),
            editorWidget: Wrap(
              spacing: 12,
              children: const ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce'].map((ms) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Radio<String>(
                      value: ms,
                      groupValue: _tempMaritalStatus,
                      activeColor: AppColors.primary,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _tempMaritalStatus = val);
                        }
                      },
                    ),
                    Text(ms),
                  ],
                );
              }).toList(),
            ),
          ),
          _buildInlineEditableRow(
            label: 'BLOOD GROUP',
            value: regState.bloodGroup,
            fieldKey: 'bloodGroup',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(bloodGroup: _tempBloodGroup),
            editorWidget: DropdownButtonFormField<String>(
              value: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].contains(_tempBloodGroup)
                  ? _tempBloodGroup
                  : null,
              items: const ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((bg) => DropdownMenuItem(value: bg, child: Text(bg)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _tempBloodGroup = val);
              },
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Select blood group'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'ADDRESS',
            value: regState.address,
            fieldKey: 'address',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(address: _addressController.text),
            editorWidget: TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter address'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'RASHI',
            value: regState.rashi,
            fieldKey: 'rashi',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(rashi: _tempRashi),
            editorWidget: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemCount: 12,
              itemBuilder: (context, idx) {
                final r = const ['Mesh', 'Vrushabh', 'Mithun', 'Kark', 'Sinh', 'Kanya', 'Tula', 'Vrushchik', 'Dhanu', 'Makar', 'Kumbh', 'Meen'][idx];
                final isSelected = _tempRashi == r;
                return GestureDetector(
                  onTap: () => setState(() => _tempRashi = r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFECEF) : Colors.white,
                      border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        r,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          _buildInlineEditableRow(
            label: 'MANGLIK',
            value: regState.manglik ? 'Yes' : 'No',
            fieldKey: 'manglik',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep2(manglik: _tempManglik),
            editorWidget: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _tempManglik = true),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: _tempManglik ? const Color(0xFFFFECEF) : null,
                      side: BorderSide(color: _tempManglik ? AppColors.primary : Colors.grey.shade300),
                    ),
                    child: Text('Yes', style: TextStyle(color: _tempManglik ? AppColors.primary : Colors.black87)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _tempManglik = false),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !_tempManglik ? const Color(0xFFFFECEF) : null,
                      side: BorderSide(color: !_tempManglik ? AppColors.primary : Colors.grey.shade300),
                    ),
                    child: Text('No', style: TextStyle(color: !_tempManglik ? AppColors.primary : Colors.black87)),
                  ),
                ),
              ],
            ),
          ),
        ]),
        AppSpacing.verticalMd,

        _buildReviewSectionHeader('PROFESSIONAL INFO'),
        _buildReviewCard([
          _buildInlineEditableRow(
            label: 'HIGHEST QUALIFICATION',
            value: regState.qualification,
            fieldKey: 'qualification',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep3(qualification: _qualificationController.text),
            editorWidget: TextFormField(
              controller: _qualificationController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter qualification'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'OCCUPATION',
            value: regState.occupation,
            fieldKey: 'occupation',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep3(occupation: _occupationController.text),
            editorWidget: TextFormField(
              controller: _occupationController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter occupation'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'ANNUAL INCOME',
            value: regState.annualIncome,
            fieldKey: 'annualIncome',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep3(annualIncome: _incomeController.text),
            editorWidget: TextFormField(
              controller: _incomeController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter annual income'),
            ),
          ),
        ]),
        AppSpacing.verticalMd,

        _buildReviewSectionHeader('FAMILY DETAILS'),
        _buildReviewCard([
          _buildInlineEditableRow(
            label: 'FATHER\'S FULL NAME',
            value: regState.fatherName,
            fieldKey: 'fatherName',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep4(fatherName: _fatherNameController.text),
            editorWidget: TextFormField(
              controller: _fatherNameController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter father\'s name'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'MOTHER\'S FULL NAME',
            value: regState.motherName,
            fieldKey: 'motherName',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep4(motherName: _motherNameController.text),
            editorWidget: TextFormField(
              controller: _motherNameController,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter mother\'s name'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'NUMBER OF SIBLINGS',
            value: regState.siblings.toString(),
            fieldKey: 'siblings',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep4(siblings: int.tryParse(_siblingsController.text) ?? 0),
            editorWidget: TextFormField(
              controller: _siblingsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter number of siblings'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'FAMILY TYPE',
            value: regState.familyType,
            fieldKey: 'familyType',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep4(familyType: _tempFamilyType),
            editorWidget: Row(
              children: ['Joint', 'Nuclear'].map((ft) {
                final isSelected = _tempFamilyType == ft;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _tempFamilyType = ft),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFFFECEF) : Colors.white,
                        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(ft == 'Joint' ? 'Joint Family' : 'Nuclear Family', style: TextStyle(color: isSelected ? AppColors.primary : Colors.black87, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          _buildInlineEditableRow(
            label: 'NUMBER OF MATERNAL UNCLES',
            value: regState.maternalUnclesDetails.length.toString(),
            fieldKey: 'maternalUnclesCount',
            editText: 'Edit in Form',
            onSave: () {},
            editorWidget: InkWell(
              onTap: () {
                ref.read(registrationControllerProvider.notifier).setStep(3);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Tap to edit Maternal Uncles in Family Details form', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          ...List.generate(regState.maternalUnclesDetails.length, (i) {
            final u = regState.maternalUnclesDetails[i];
            return _buildInlineEditableRow(
              label: 'MATERNAL UNCLE ${i + 1}',
              value: u.occupation.isNotEmpty ? '${u.name} (${u.occupation})' : u.name,
              fieldKey: 'maternalUncle_$i',
              editText: '',
              onSave: () {},
              editorWidget: const SizedBox.shrink(),
            );
          }),
          _buildInlineEditableRow(
            label: 'NUMBER OF PATERNAL UNCLES',
            value: regState.paternalUnclesDetails.length.toString(),
            fieldKey: 'paternalUnclesCount',
            editText: 'Edit in Form',
            onSave: () {},
            editorWidget: InkWell(
              onTap: () {
                ref.read(registrationControllerProvider.notifier).setStep(3);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Tap to edit Paternal Uncles in Family Details form', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          ...List.generate(regState.paternalUnclesDetails.length, (i) {
            final u = regState.paternalUnclesDetails[i];
            return _buildInlineEditableRow(
              label: 'PATERNAL UNCLE ${i + 1}',
              value: u.occupation.isNotEmpty ? '${u.name} (${u.occupation})' : u.name,
              fieldKey: 'paternalUncle_$i',
              editText: '',
              onSave: () {},
              editorWidget: const SizedBox.shrink(),
            );
          }),
        ]),
        AppSpacing.verticalMd,

        _buildReviewSectionHeader('DOCUMENTS & PHOTOS'),
        _buildReviewCard([
          _buildInlineEditableRow(
            label: 'AADHAR CARD NUMBER',
            value: 'XXXX XXXX ${regState.aadharNumber.length >= 4 ? regState.aadharNumber.substring(regState.aadharNumber.length - 4) : regState.aadharNumber}',
            fieldKey: 'aadharNumber',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep5(aadharNumber: _aadharNumberController.text),
            editorWidget: TextFormField(
              controller: _aadharNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Enter 12-digit Aadhar number'),
            ),
          ),
          _buildInlineEditableRow(
            label: 'UPLOAD AADHAR CARD',
            value: regState.aadharCardName,
            fieldKey: 'aadharCardDoc',
            editText: 'Change',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep5(aadharBytes: _tempAadharBytes, aadharCardName: _tempAadharCardName),
            customValueWidget: regState.aadharCardName.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.picture_as_pdf, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          regState.aadharCardName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Uploaded',
                            style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    'Not uploaded',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
            editorWidget: InkWell(
              onTap: () async {
                try {
                  final picker = ImagePicker();
                  final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                  if (picked != null) {
                    final bytes = await picked.readAsBytes();
                    setState(() {
                      _tempAadharCardName = picked.name;
                      _tempAadharBytes = bytes;
                    });
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      _tempAadharCardName.isEmpty ? 'Upload Aadhaar Card Image' : _tempAadharCardName,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildInlineEditableRow(
            label: 'CASTE CERTIFICATE',
            value: regState.casteCertificateName,
            fieldKey: 'casteCertificate',
            editText: 'Change',
            onSave: () {
              ref.read(registrationControllerProvider.notifier).updateCasteCertificate(
                path: _tempCasteCertificatePath,
                name: _tempCasteCertificateName,
                bytes: _tempCasteCertificateBytes,
              );
            },
            customValueWidget: regState.casteCertificateName.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.description, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          regState.casteCertificateName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Uploaded',
                            style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () => _previewCasteCertificate(regState),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Preview',
                            style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Text(
                    'Not uploaded',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
            editorWidget: InkWell(
              onTap: () async {
                try {
                  final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                    withData: true,
                  );
                  if (result != null && result.files.isNotEmpty) {
                    final file = result.files.first;
                    if (file.size > 10 * 1024 * 1024) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('File size must be less than 10 MB')),
                      );
                      return;
                    }
                    setState(() {
                      _tempCasteCertificatePath = kIsWeb ? '' : (file.path ?? '');
                      _tempCasteCertificateName = file.name;
                      _tempCasteCertificateBytes = file.bytes;
                    });
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_upload_outlined, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      _tempCasteCertificateName.isEmpty ? 'Upload Caste Certificate' : _tempCasteCertificateName,
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildInlineEditableRow(
            label: 'UPLOAD PHOTOS',
            value: '${regState.photos.length} photos',
            fieldKey: 'photos',
            onSave: () => ref.read(registrationControllerProvider.notifier).updateStep5(photos: _tempPhotos, pickedPhotosData: _tempPickedPhotosData),
            customValueWidget: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...regState.photos.map((p) => _buildPhotoThumbnail(p)),
                if (regState.photos.length < 6)
                  _buildAddPhotoBox(
                    onTap: () {
                      _startEditingField('photos', regState);
                    },
                  ),
              ],
            ),
            editorWidget: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...List.generate(
                  _tempPhotos.length,
                  (idx) => GestureDetector(
                    onTap: () async {
                      try {
                        final picker = ImagePicker();
                        final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
                        if (file != null) {
                          final bytes = await file.readAsBytes();
                          setState(() {
                            if (idx < _tempPickedPhotosData!.length) {
                              _tempPickedPhotosData![idx] = {'bytes': bytes, 'fileName': file.name};
                            } else {
                              _tempPickedPhotosData!.add({'bytes': bytes, 'fileName': file.name});
                            }
                            _tempPhotos[idx] = file.path;
                          });
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                      }
                    },
                    child: _buildPhotoThumbnail(_tempPhotos[idx], deleteIndex: idx),
                  ),
                ),
                if (_tempPhotos.length < 6)
                  _buildAddPhotoBox(
                    onTap: () async {
                      try {
                        final picker = ImagePicker();
                        final pickedList = await picker.pickMultiImage(imageQuality: 80);
                        for (final file in pickedList) {
                          if (_tempPhotos.length >= 6) break;
                          final bytes = await file.readAsBytes();
                          setState(() {
                            _tempPickedPhotosData!.add({'bytes': bytes, 'fileName': file.name});
                            _tempPhotos.add(file.path);
                          });
                        }
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                      }
                    },
                  ),
              ],
            ),
          ),
        ]),
        AppSpacing.verticalLg,

        // Terms & Conditions Checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: regState.isConfirmDetailsAccepted,
              activeColor: AppColors.primary,
              onChanged: (val) {
                ref.read(registrationControllerProvider.notifier).setConfirmDetailsAccepted(val ?? false);
              },
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black54, fontSize: 12, height: 1.4),
                  children: [
                    const TextSpan(text: 'I confirm that all the details provided are accurate and I agree to the '),
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()..onTap = () {},
                    ),
                    const TextSpan(text: '.'),
                  ],
                ),
              ),
            ),
          ],
        ),
        AppSpacing.verticalLg,

        // Confirm & Submit Button
        ElevatedButton(
          onPressed: !_isConfirmEnabled(regState)
              ? null
              : () async {
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
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(27),
            ),
          ),
          child: regState.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : const Text('Confirm and Create profile'),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildReviewSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildReviewCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildInlineEditableRow({
    required String label,
    required String value,
    required String fieldKey,
    required Widget editorWidget,
    required VoidCallback onSave,
    String editText = 'Edit',
    Widget? customValueWidget,
  }) {
    final isEditing = _editingFieldKey == fieldKey;
    final regState = ref.read(registrationControllerProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (!isEditing)
                GestureDetector(
                  onTap: () {
                    _startEditingField(fieldKey, regState);
                  },
                  child: Text(
                    editText,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          if (!isEditing) ...[
            customValueWidget ??
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ] else ...[
            editorWidget,
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _editingFieldKey = null;
                    });
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    onSave();
                    setState(() {
                      _editingFieldKey = null;
                    });
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 4),
          const Divider(height: 1),
        ],
      ),
    );
  }

  // Searchable Bottom Sheet helper
  void _showSearchableBottomSheet({
    required String title,
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelected,
  }) {
    String searchQuery = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filteredOptions = options
                .where((opt) => opt.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (val) {
                          setSheetState(() {
                            searchQuery = val;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredOptions.length,
                          itemBuilder: (context, idx) {
                            final opt = filteredOptions[idx];
                            final isSel = opt == selectedValue;
                            return ListTile(
                              title: Text(opt, style: TextStyle(fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                              trailing: isSel ? const Icon(Icons.check, color: AppColors.primary) : null,
                              onTap: () {
                                onSelected(opt);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  ImageProvider _resolvePhotoProvider(String path, {Uint8List? bytes}) {
    if (bytes != null) {
      return MemoryImage(bytes);
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    if (!kIsWeb && path.isNotEmpty) {
      return FileImage(File(path));
    }
    return NetworkImage(path);
  }

  // Photo Thumbnail Widget Builder for Inline Editing
  Widget _buildPhotoThumbnail(String path, {int? deleteIndex}) {
    final Uint8List? bytes = (deleteIndex != null &&
            _tempPickedPhotosData != null &&
            deleteIndex < _tempPickedPhotosData!.length)
        ? _tempPickedPhotosData![deleteIndex]['bytes'] as Uint8List?
        : null;
    return Stack(
      children: [
        Container(
          width: 72,
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade200),
            image: DecorationImage(
              image: _resolvePhotoProvider(path, bytes: bytes),
              fit: BoxFit.cover,
              onError: (e, s) {},
            ),
          ),
        ),
        if (deleteIndex != null)
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (deleteIndex < _tempPickedPhotosData!.length) {
                    _tempPickedPhotosData!.removeAt(deleteIndex);
                  }
                  _tempPhotos.removeAt(deleteIndex);
                });
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 10),
              ),
            ),
          ),
      ],
    );
  }

  // Dashed Photo Add Box Builder
  Widget _buildAddPhotoBox({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 72,
        height: 96,
        decoration: BoxDecoration(
          color: const Color(0xFFFFECEF),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppColors.primary, size: 24),
            SizedBox(height: 4),
            Text(
              'Add',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
