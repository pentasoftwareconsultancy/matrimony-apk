import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/dummy_profiles.dart';
import '../../../../core/utils/profile_compatiblity.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/app_providers.dart';
import '../../../../core/network/api_client.dart';
import 'chat_screen.dart';
import '../../../profile/presentation/screens/edit_profile_screen.dart';
import '../../../../core/localization/l10n_helper.dart';

class ProfileDetailsScreen extends ConsumerStatefulWidget {
  final MatrimonialProfile profile;

  const ProfileDetailsScreen({super.key, required this.profile});

  @override
  ConsumerState<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends ConsumerState<ProfileDetailsScreen> {
  int _selectedPhotoIndex = 0;
  bool _interestExpressing = false;
  bool _interestExpressed = false;
  late MatrimonialProfile _profile;

  Future<void> _checkExistingInterest() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get('/connections');

      if (!mounted) return;

      final responseData = response.data;
      dynamic connections;

      if (responseData is Map) {
        final data = responseData['data'];
        if (data is Map) {
          connections = data['connections'];
        } else {
          connections = data;
        }
      }

      if (connections is List) {
        final alreadySent = connections.any((item) {
          if (item is! Map) return false;

          final fromUser = item['fromUser']?.toString();
          final toUser = item['toUser']?.toString();
          final actionType = item['actionType']?.toString();

          return fromUser != null &&
              toUser == widget.profile.id &&
              actionType == 'interest';
        });

        if (alreadySent && mounted) {
          setState(() {
            _interestExpressed = true;
          });
        }
      }
    } catch (e) {
      debugPrint('[Interest] Unable to check existing interest: $e');
    }
  }

  Future<void> _fetchFreshProfile() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      final response = await apiClient.get('/profile/${widget.profile.id}');
      if (!mounted) return;
      final body = response.data;
      if (body is Map && body['data'] is Map) {
        final profileData = body['data']['profile'];
        if (profileData is Map) {
          final fresh = MatrimonialProfile.fromJson(Map<String, dynamic>.from(profileData));
          if (mounted) {
            setState(() {
              _profile = fresh;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('[ProfileDetails] Error fetching fresh profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _profile = widget.profile;
    _checkExistingInterest();
    _fetchFreshProfile();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(profileViewProvider.notifier).recordView(widget.profile.id);
    });
  }

  Future<void> _expressInterest() async {
    if (_interestExpressing || _interestExpressed) {
      return;
    }

    setState(() {
      _interestExpressing = true;
    });

    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.post('/connections/interest/${widget.profile.id}');

      if (!mounted) return;

      setState(() {
        _interestExpressing = false;
        _interestExpressed = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Interest Sent'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _interestExpressing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to send interest: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = _profile;
    final homeState = ref.watch(homeControllerProvider);
    final currentUser = ref.watch(authControllerProvider).user;
    final ownProfile = currentUser == null ? null : profileFromUser(currentUser);
    final compatibility = ownProfile == null
        ? null
        : calculateProfileCompatibility(ownProfile, profile);
    final isFav = homeState.favouriteIds.contains(profile.id);
    final isOwner = currentUser != null && currentUser.id == profile.id;

    final validPhotos = profile.photos
        .where((p) =>
            p.trim().isNotEmpty &&
            !p.toLowerCase().contains('unsplash.com') &&
            (p.startsWith('http://') || p.startsWith('https://') || p.startsWith('blob:')))
        .toList();

    final currentPhotoIndex = validPhotos.isNotEmpty
        ? _selectedPhotoIndex.clamp(0, validPhotos.length - 1)
        : 0;

    final hasPartnerPreferences = profile.partnerMaritalStatus.isNotEmpty ||
        profile.partnerAgeRange.isNotEmpty ||
        profile.partnerComplexion.isNotEmpty ||
        profile.partnerHeight.isNotEmpty ||
        profile.partnerWeight.isNotEmpty ||
        profile.partnerDiet.isNotEmpty ||
        profile.partnerSmoking.isNotEmpty ||
        profile.partnerDrinking.isNotEmpty ||
        profile.partnerWorkingLocation.isNotEmpty ||
        profile.partnerIncome.isNotEmpty ||
        profile.partnerEducation.isNotEmpty ||
        profile.partnerProfession.isNotEmpty ||
        profile.wantsWorkingPartner;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: Stack(
        children: [
          // Scrollable Profile Details Content
          Positioned.fill(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                try {
                  ref.invalidate(favoriteProfilesProvider);
                  await Future.wait([
                    _checkExistingInterest(),
                    _fetchFreshProfile(),
                    ref.read(favoriteProfilesProvider.future),
                    ref.read(authControllerProvider.notifier).refreshCurrentUser(),
                  ]);
                } catch (_) {}
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 104),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Gallery Section
                    Stack(
                      children: [
                        // Main Large Image or Fallback Avatar Header
                        validPhotos.isNotEmpty
                            ? Container(
                                height: 400,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(validPhotos[currentPhotoIndex]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                height: 400,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFFF0F3),
                                      Color(0xFFFFD6E0),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: const BoxDecoration(
                                      color: Color(0xEBFFFFFF),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color(0x14C9003F),
                                          blurRadius: 14,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.person_rounded,
                                        color: Color(0xFFC9003F),
                                        size: 64,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                        // Gradient overlay for readability
                        Container(
                          height: 400,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.4),
                                Colors.transparent,
                                Colors.black.withOpacity(0.55),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),

                        // Back Button (Top Left)
                        Positioned(
                          top: 48,
                          left: 16,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.35),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                            ),
                          ),
                        ),

                        // Top Right Button: Edit for Owner, Favourite for Others
                        Positioned(
                          top: 48,
                          right: 16,
                          child: isOwner
                              ? GestureDetector(
                                  onTap: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                                    );
                                    _fetchFreshProfile();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    ref.read(homeControllerProvider.notifier).toggleFavourite(profile.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      isFav ? Icons.favorite : Icons.favorite_border,
                                      color: isFav ? AppColors.primary : Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                        ),

                        // Vertical thumbnail preview list (Overlay Right)
                        if (validPhotos.length > 1)
                          Positioned(
                            right: 12,
                            bottom: 80,
                            child: Column(
                              children: List.generate(validPhotos.length, (index) {
                                final isSel = index == currentPhotoIndex;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedPhotoIndex = index),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    width: 44,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSel ? AppColors.primary : Colors.white,
                                        width: 2,
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(validPhotos[index]),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                        // Name & Summary overlay at bottom of photo
                        Positioned(
                          left: 20,
                          bottom: 20,
                          right: isOwner ? 20 : 120,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.fullName.isNotEmpty ? profile.fullName : 'Profile Details',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                [
                                  if (profile.age > 0) '${profile.age} yrs',
                                  if (profile.height.isNotEmpty) profile.height,
                                  if (profile.religion.isNotEmpty) profile.religion,
                                ].join(' • '),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (profile.city.isNotEmpty || profile.state.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  [
                                    if (profile.city.isNotEmpty) profile.city,
                                    if (profile.state.isNotEmpty) profile.state,
                                  ].join(', '),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        // Match percentage circle indicator (for other profiles)
                        if (!isOwner)
                          Positioned(
                            right: 20,
                            bottom: 20,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    compatibility == null || !compatibility.hasComparableData
                                        ? '—'
                                        : '${compatibility.score}%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    context.isMarathi ? 'जुळणी' : 'MATCH',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                      ],
                    ),

                    // Profile Fields Information Content
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ABOUT ME Box
                          if (profile.about.trim().isNotEmpty) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.isMarathi ? 'माझ्याबद्दल' : 'ABOUT ME',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    profile.about,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Tag chips list
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (profile.highestEdu.isNotEmpty || profile.qualification.isNotEmpty)
                                _buildInfoChip(
                                  profile.highestEdu.isNotEmpty ? profile.highestEdu : profile.qualification,
                                  Icons.school_outlined,
                                ),
                              if (profile.profession.isNotEmpty || profile.occupation.isNotEmpty)
                                _buildInfoChip(
                                  profile.profession.isNotEmpty ? profile.profession : profile.occupation,
                                  Icons.work_outline,
                                ),
                              if (profile.familyType.isNotEmpty)
                                _buildInfoChip('${profile.familyType} family', Icons.people_outline),
                              if (profile.diet.isNotEmpty)
                                _buildInfoChip(profile.diet, Icons.restaurant_menu),
                              if (profile.maritalStatus.isNotEmpty)
                                _buildInfoChip(profile.maritalStatus, Icons.favorite_border),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // 1. PERSONAL DETAILS
                          _buildSectionHeader('PERSONAL DETAILS'),
                          _buildDetailsCard([
                            _buildDetailRow('FULL NAME', profile.fullName),
                            _buildDetailRow('GENDER', profile.gender),
                            _buildDetailRow('AGE', profile.age > 0 ? '${profile.age} Years' : ''),
                            _buildDetailRow('DATE OF BIRTH', profile.birthDate),
                            _buildDetailRow('MARITAL STATUS', profile.maritalStatus),
                            if (profile.children > 0 ||
                                profile.maritalStatus.toLowerCase().contains('divorce') ||
                                profile.maritalStatus.toLowerCase().contains('widow'))
                              _buildDetailRow('NO. OF CHILDREN', '${profile.children}'),
                            _buildDetailRow('MOTHER TONGUE', profile.motherTongue),
                            _buildDetailRow('HEIGHT', profile.height),
                            _buildDetailRow(
                              'WEIGHT',
                              profile.weight.isNotEmpty
                                  ? (profile.weight.toLowerCase().contains('kg') ? profile.weight : '${profile.weight} kg')
                                  : '',
                            ),
                            _buildDetailRow('BLOOD GROUP', profile.bloodGroup),
                            _buildDetailRow('COMPLEXION', profile.complexion),
                            _buildDetailRow('BODY TYPE', profile.bodyType),
                            _buildDetailRow('SPECIAL CASE', profile.specialCase),
                            _buildDetailRow('AGRI. LAND', profile.agriLand),
                            if (isOwner) ...[
                              _buildDetailRow('PHONE NUMBER', profile.phone),
                              if (profile.altPhone.isNotEmpty)
                                _buildDetailRow('ALT. PHONE', profile.altPhone),
                              _buildDetailRow('EMAIL', profile.email),
                            ],
                          ]),
                          const SizedBox(height: 20),

                          // 2. EDUCATION & CAREER
                          _buildSectionHeader('EDUCATION & CAREER'),
                          _buildDetailsCard([
                            _buildDetailRow(
                              'HIGHEST EDU',
                              profile.highestEdu.isNotEmpty ? profile.highestEdu : profile.qualification,
                            ),
                            _buildDetailRow('EDU. FIELD', profile.eduField),
                            _buildDetailRow('UNIVERSITY', profile.university),
                            _buildDetailRow(
                              'PROFESSION',
                              profile.profession.isNotEmpty ? profile.profession : profile.occupation,
                            ),
                            _buildDetailRow('DESIGNATION', profile.designation),
                            _buildDetailRow('ORGANIZATION', profile.organization),
                            _buildDetailRow('COMPANY ADDRESS', profile.companyAddress),
                            _buildDetailRow(
                              'ANNUAL INCOME',
                              profile.annualIncome.isNotEmpty ? profile.annualIncome : profile.income,
                            ),
                            _buildDetailRow(
                              'WORK LOCATION',
                              profile.workLocation.isNotEmpty ? profile.workLocation : profile.workPlace,
                            ),
                          ]),
                          const SizedBox(height: 20),

                          // 3. RELIGIOUS & HOROSCOPE
                          _buildSectionHeader('RELIGIOUS & HOROSCOPE'),
                          _buildDetailsCard([
                            _buildDetailRow('RELIGION', profile.religion),
                            _buildDetailRow('CASTE', profile.caste),
                            _buildDetailRow('SUB-CASTE', profile.subCaste),
                            _buildDetailRow('GOTRA', profile.gotra),
                            _buildDetailRow('RASHI', profile.rashi),
                            _buildDetailRow('NAKSHATRA', profile.nakshatra),
                            _buildDetailRow('CHARAN', profile.charan),
                            _buildDetailRow('GAN', profile.gan),
                            _buildDetailRow('NADI', profile.nadi),
                            _buildDetailRow('MANGLIK', profile.manglik ? 'Yes' : 'No'),
                            _buildDetailRow('PLACE OF BIRTH', profile.placeOfBirth),
                            _buildDetailRow('BIRTH TIME', profile.birthTime),
                            _buildDetailRow('PARTNER PRIORITY', profile.partnerPriority, isHighlighted: profile.partnerPriority.contains('✨')),
                          ]),
                          const SizedBox(height: 20),

                          // 4. LOCATION DETAILS
                          _buildSectionHeader('LOCATION DETAILS'),
                          _buildDetailsCard([
                            _buildDetailRow('COUNTRY', profile.country),
                            _buildDetailRow('STATE', profile.state),
                            _buildDetailRow('CITY', profile.city),
                            _buildDetailRow('DISTRICT', profile.district),
                            _buildDetailRow('TALUKA', profile.taluka),
                            _buildDetailRow('VILLAGE', profile.village),
                            _buildDetailRow('HOME PLACE', profile.homePlace),
                            _buildDetailRow('WORK PLACE', profile.workPlace),
                            _buildDetailRow('NATIVE PLACE', profile.nativePlace),
                            if (isOwner || profile.pincode.isNotEmpty)
                              _buildDetailRow('PINCODE', profile.pincode),
                          ]),
                          const SizedBox(height: 20),

                          // 5. FAMILY DETAILS
                          _buildSectionHeader('FAMILY DETAILS'),
                          _buildDetailsCard([
                            _buildDetailRow("FATHER'S NAME", profile.fatherName),
                            _buildDetailRow("FATHER'S OCC.", profile.fatherEdu),
                            _buildDetailRow("MOTHER'S NAME", profile.motherName),
                            _buildDetailRow("MOTHER'S OCC.", profile.motherOcc),
                            _buildDetailRow('FAMILY TYPE', profile.familyType),
                            _buildDetailRow('FAMILY VALUES', profile.familyValues),
                            if (profile.aboutFamily.isNotEmpty)
                              _buildDetailRow('ABOUT FAMILY', profile.aboutFamily),

                            // Dynamic Brothers
                            if (profile.brothersDetails.isNotEmpty) ...[
                              for (int i = 0; i < profile.brothersDetails.length; i++) ...[
                                _buildDetailRow(
                                  'BROTHER ${i + 1}',
                                  '${profile.brothersDetails[i].name}${profile.brothersDetails[i].occupation.isNotEmpty ? ' (${profile.brothersDetails[i].occupation})' : ''}',
                                ),
                              ],
                            ] else ...[
                              _buildDetailRow('BROTHERS', profile.brothers),
                            ],

                            // Dynamic Sisters
                            if (profile.sistersDetails.isNotEmpty) ...[
                              for (int i = 0; i < profile.sistersDetails.length; i++) ...[
                                _buildDetailRow(
                                  'SISTER ${i + 1}',
                                  '${profile.sistersDetails[i].name}${profile.sistersDetails[i].occupation.isNotEmpty ? ' (${profile.sistersDetails[i].occupation})' : ''}${profile.sistersDetails[i].isMarried ? ' • Married${profile.sistersDetails[i].husbandName.isNotEmpty ? ' to ${profile.sistersDetails[i].husbandName}' : ''}${profile.sistersDetails[i].husbandProfession.isNotEmpty ? ' (${profile.sistersDetails[i].husbandProfession})' : ''}' : ' • Unmarried'}',
                                ),
                              ],
                            ] else ...[
                              _buildDetailRow('SISTERS', profile.sisters),
                              if (profile.marriedSister.isNotEmpty)
                                _buildDetailRow('MARRIED SISTER', profile.marriedSister),
                            ],

                            // Dynamic Maternal Uncles (ALL member records with individual names & professions)
                            if (profile.maternalUnclesDetails.isNotEmpty) ...[
                              for (int i = 0; i < profile.maternalUnclesDetails.length; i++) ...[
                                _buildDetailRow(
                                  'MATERNAL UNCLE ${i + 1}',
                                  '${profile.maternalUnclesDetails[i].name}${profile.maternalUnclesDetails[i].profession.isNotEmpty ? ' (${profile.maternalUnclesDetails[i].profession})' : ''}',
                                ),
                              ],
                            ] else ...[
                              _buildDetailRow('MATERNAL UNCLE', profile.maternalUncle),
                            ],

                            // Dynamic Paternal Uncles (ALL member records with individual names & professions)
                            if (profile.unclesDetails.isNotEmpty) ...[
                              for (int i = 0; i < profile.unclesDetails.length; i++) ...[
                                _buildDetailRow(
                                  'PATERNAL UNCLE ${i + 1}',
                                  '${profile.unclesDetails[i].name}${profile.unclesDetails[i].profession.isNotEmpty ? ' (${profile.unclesDetails[i].profession})' : ''}',
                                ),
                              ],
                            ] else ...[
                              _buildDetailRow('PATERNAL UNCLE', profile.uncleName),
                            ],

                            if (profile.unclePhone.isNotEmpty)
                              _buildDetailRow('UNCLE PHONE', profile.unclePhone),
                          ]),
                          const SizedBox(height: 20),

                          // 6. LIFESTYLE & HABITS
                          _buildSectionHeader('LIFESTYLE & HABITS'),
                          _buildDetailsCard([
                            _buildDetailRow('DIET', profile.diet),
                            _buildDetailRow('SMOKING', profile.smoking),
                            _buildDetailRow('DRINKING', profile.drinking),
                            _buildDetailRow('DRINKING / SMOKING', profile.drinkingSmoking),
                            _buildDetailRow('HOBBIES', profile.hobbies.isNotEmpty ? profile.hobbies.join(', ') : ''),
                          ]),

                          // 7. PARTNER PREFERENCES (if specified)
                          if (hasPartnerPreferences) ...[
                            const SizedBox(height: 20),
                            _buildSectionHeader('PARTNER PREFERENCES'),
                            _buildDetailsCard([
                              if (profile.partnerMaritalStatus.isNotEmpty)
                                _buildDetailRow('EXPECTED MARITAL STATUS', profile.partnerMaritalStatus),
                              if (profile.partnerAgeRange.isNotEmpty)
                                _buildDetailRow('AGE RANGE', profile.partnerAgeRange),
                              if (profile.partnerComplexion.isNotEmpty)
                                _buildDetailRow('COMPLEXION', profile.partnerComplexion),
                              if (profile.partnerHeight.isNotEmpty)
                                _buildDetailRow('HEIGHT', profile.partnerHeight),
                              if (profile.partnerWeight.isNotEmpty)
                                _buildDetailRow('WEIGHT', profile.partnerWeight),
                              if (profile.partnerDiet.isNotEmpty)
                                _buildDetailRow('DIET', profile.partnerDiet),
                              if (profile.partnerSmoking.isNotEmpty)
                                _buildDetailRow('SMOKING', profile.partnerSmoking),
                              if (profile.partnerDrinking.isNotEmpty)
                                _buildDetailRow('DRINKING', profile.partnerDrinking),
                              if (profile.partnerEducation.isNotEmpty)
                                _buildDetailRow('EDUCATION', profile.partnerEducation),
                              if (profile.partnerProfession.isNotEmpty)
                                _buildDetailRow('PROFESSION', profile.partnerProfession),
                              if (profile.partnerIncome.isNotEmpty)
                                _buildDetailRow('ANNUAL INCOME', profile.partnerIncome),
                              if (profile.partnerWorkingLocation.isNotEmpty)
                                _buildDetailRow('WORKING LOCATION', profile.partnerWorkingLocation),
                              _buildDetailRow(
                                'WORKING PARTNER',
                                profile.wantsWorkingPartner ? 'Yes, Preferred' : 'No Preference',
                              ),
                            ]),
                          ],
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // Sticky Bottom Bar Buttons Overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  )
                ],
              ),
              child: isOwner
                  ? SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                          );
                          _fetchFreshProfile();
                        },
                        icon: const Icon(Icons.edit, color: Colors.white, size: 18),
                        label: const Text(
                          'Edit Profile',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        // Express Interest Outlined Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _interestExpressed ? null : _expressInterest,
                            icon: _interestExpressing
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    _interestExpressed ? Icons.check : Icons.favorite_border,
                                    color: _interestExpressed ? Colors.grey : AppColors.primary,
                                    size: 16,
                                  ),
                            label: Text(
                              _interestExpressed
                                  ? (context.isMarathi ? 'पसंती पाठवली' : 'Interest Sent')
                                  : (context.isMarathi ? 'पसंती पाठवा' : 'Express Interest'),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: BorderSide(
                                color: _interestExpressed ? Colors.grey.shade300 : AppColors.primary,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Message Button (Navigate to Chat UI)
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final valid = profile.photos
                                  .where((p) => p.trim().isNotEmpty && !p.toLowerCase().contains('unsplash.com'))
                                  .toList();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatDetailScreen(
                                    partnerId: profile.id,
                                    name: profile.fullName,
                                    avatarUrl: valid.isNotEmpty ? valid.first : '',
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 16),
                            label: Text(context.isMarathi ? 'संदेश' : 'Message'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon) {
    if (label.trim().isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.grey, size: 13),
          const SizedBox(width: 6),
          Text(
            context.tr(label),
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
      child: Text(
        context.tr(title),
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailsCard(List<Widget> rows) {
    final validRows = rows.where((w) => w is! SizedBox || (w.width != 0 && w.height != 0)).toList();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(validRows.length, (index) {
          return Column(
            children: [
              validRows[index],
              if (index < validRows.length - 1)
                Divider(color: Colors.grey.shade100, height: 1),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isHighlighted = false}) {
    final displayVal = value.trim().isEmpty ? 'Not Specified' : value.trim();
    final isNotSpecified = displayVal.toLowerCase() == 'not specified';
    final localizedLabel = context.tr(label);
    final localizedVal = isNotSpecified
        ? (context.isMarathi ? 'माहिती दिलेली नाही' : 'Not Specified')
        : context.tr(displayVal);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 135,
            child: Text(
              localizedLabel,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              localizedVal,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isHighlighted
                    ? AppColors.primary
                    : (isNotSpecified ? Colors.grey.shade400 : Colors.black87),
                fontSize: 12,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
