import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/data/dummy_profiles.dart';
import '../controllers/home_controller.dart';
import '../controllers/app_providers.dart';
import '../../../../core/network/api_client.dart';
import 'chat_screen.dart'; // We will create ChatDetailScreen here or import it

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

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      debugPrint(
        'PROFILE OPENED => '
            'name=${widget.profile.fullName}, '
            'id="${widget.profile.id}"',
      );

      ref
          .read(profileViewProvider.notifier)
          .recordView(widget.profile.id);
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

      debugPrint(
        '[Interest] Sending interest for profile: ${widget.profile.id}',
      );

      final response = await apiClient.post(
        '/connections/interest/${widget.profile.id}',
      );

      debugPrint(
        '[Interest] Response: ${response.statusCode}',
      );

      debugPrint(
        '[Interest] Data: ${response.data}',
      );

      if (!mounted) {
        return;
      }

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
      debugPrint('[Interest] ERROR: $e');

      if (!mounted) {
        return;
      }

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
    final profile = widget.profile;
    final homeState = ref.watch(homeControllerProvider);
    final isFav = homeState.favouriteIds.contains(profile.id);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF9),
      body: Stack(
        children: [
          // Scrollable Profile Details Content
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 96), // Spacing for sticky bottom buttons
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Gallery Section
                  Stack(
                    children: [
                      // Main Large Image
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              profile.photos.isNotEmpty ? profile.photos[_selectedPhotoIndex] : '',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Gradient overlay
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.4),
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
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
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      // Favourite Heart Button (Top Right)
                      Positioned(
                        top: 48,
                        right: 16,
                        child: GestureDetector(
                          onTap: () {
                            ref.read(homeControllerProvider.notifier).toggleFavourite(profile.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
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
                      Positioned(
                        right: 12,
                        bottom: 80,
                        child: Column(
                          children: List.generate(profile.photos.length, (index) {
                            final isSel = index == _selectedPhotoIndex;
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
                                    image: NetworkImage(profile.photos[index]),
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
                        right: 120, // Leave space for match indicator
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              profile.fullName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${profile.age} yrs • ${profile.height} • ${profile.religion}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${profile.city}, ${profile.state}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Match percentage circle indicator (Bottom Right of photo)
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
                                '${profile.compatibilityScore}%',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'MATCH',
                                style: TextStyle(
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
                              const Text(
                                'ABOUT ME',
                                style: TextStyle(
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
                        
                        // Tag chips list
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildInfoChip(profile.qualification, Icons.school_outlined),
                            _buildInfoChip(profile.occupation, Icons.work_outline),
                            _buildInfoChip('${profile.familyType} family', Icons.people_outline),
                            _buildInfoChip(profile.diet, Icons.restaurant_menu),
                            _buildInfoChip(profile.maritalStatus, Icons.favorite_border),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // PERSONAL DETAILS Card
                        _buildSectionHeader('PERSONAL DETAILS'),
                        _buildDetailsCard([
                          _buildDetailRow('DATE OF BIRTH', '14 March 1997'), // deterministic fallback dob
                          _buildDetailRow('RELIGION / CASTE', '${profile.religion} • ${profile.caste}'),
                          _buildDetailRow('HEIGHT', profile.height),
                          _buildDetailRow('MARITAL STATUS', profile.maritalStatus),
                          _buildDetailRow('DIET', profile.diet),
                          _buildDetailRow('SMOKING', profile.smoking),
                          _buildDetailRow('DRINKING', profile.drinking),
                        ]),
                        const SizedBox(height: 20),

                        // PROFESSIONAL DETAILS Card
                        _buildSectionHeader('PROFESSIONAL DETAILS'),
                        _buildDetailsCard([
                          _buildDetailRow('EDUCATION', profile.qualification),
                          _buildDetailRow('OCCUPATION', profile.occupation),
                          _buildDetailRow('ANNUAL INCOME', profile.annualIncome),
                          _buildDetailRow('WORK LOCATION', profile.workLocation),
                        ]),
                        const SizedBox(height: 20),

                        // LOCATION Card
                        _buildSectionHeader('LOCATION'),
                        _buildDetailsCard([
                          _buildDetailRow('CITY', profile.city),
                          _buildDetailRow('STATE', profile.state),
                          _buildDetailRow('COUNTRY', profile.country),
                        ]),
                        const SizedBox(height: 20),

                        // FAMILY DETAILS Card
                        _buildSectionHeader('FAMILY DETAILS'),
                        _buildDetailsCard([
                          _buildDetailRow('FATHER\'S NAME', profile.fatherName),
                          _buildDetailRow('MOTHER\'S NAME', profile.motherName),
                          _buildDetailRow('SIBLINGS', profile.siblings),
                          _buildDetailRow('FAMILY TYPE', profile.familyType),
                        ]),
                      ],
                    ),
                  )
                ],
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
              child: Row(
                children: [
                  // Express Interest Outlined Pink Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _interestExpressed
                          ? null
                          : _expressInterest,

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
                        _interestExpressed
                            ? Icons.check
                            : Icons.favorite_border,
                        color: _interestExpressed
                            ? Colors.grey
                            : AppColors.primary,
                        size: 16,
                      ),

                      label: Text(
                        _interestExpressed
                            ? 'Interest Sent'
                            : 'Express Interest',
                      ),

                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(
                          color: _interestExpressed
                              ? Colors.grey.shade300
                              : AppColors.primary,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
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
                        // Open ChatDetailScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatDetailScreen(
                              partnerId: profile.id,
                              name: profile.fullName,
                              avatarUrl: profile.photos.first,
                            )
                          ),
                        );
                      },
                      icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 16),
                      label: const Text('Message'),
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
            label,
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
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildDetailsCard(List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: List.generate(rows.length, (index) {
          return Column(
            children: [
              rows[index],
              if (index < rows.length - 1)
                Divider(color: Colors.grey.shade100, height: 1),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

