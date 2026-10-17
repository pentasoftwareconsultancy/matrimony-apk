  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import '../../../../core/theme/app_colors.dart';
  import '../../../../core/data/dummy_profiles.dart';
  import '../../../../features/auth/presentation/controllers/auth_controller.dart';
  import '../controllers/home_controller.dart';
  import 'profile_details_screen.dart';
  import 'profile_views_screen.dart';
  import 'chat_screen.dart';
  import 'notifications_screen.dart';
  import '../controllers/app_providers.dart';
  import '../../../profile/presentation/screens/profile_screen.dart';
  import '../../../events/presentation/screens/events_screen.dart';

  import '../../../../core/network/socket_service.dart';
  
  class HomeScreen extends ConsumerStatefulWidget {
    const HomeScreen({super.key});
  
    @override
    ConsumerState<HomeScreen> createState() => _HomeScreenState();
  }
  
  class _HomeScreenState extends ConsumerState<HomeScreen> {
    final TextEditingController _searchController = TextEditingController();
    final TextEditingController _favSearchController = TextEditingController();
    String _favSearchQuery = '';
    final TextEditingController _chatSearchController = TextEditingController();
    String _chatSearchQuery = '';
  
    @override
    void initState() {
      super.initState();
      _searchController.addListener(() {
        ref.read(homeControllerProvider.notifier).setSearchQuery(_searchController.text);
      });
      _favSearchController.addListener(() {
        setState(() {
          _favSearchQuery = _favSearchController.text;
        });
      });
      _chatSearchController.addListener(() {
        setState(() {
          _chatSearchQuery = _chatSearchController.text;
        });
      });

    }
  
    @override
    void dispose() {
      _searchController.dispose();
      _favSearchController.dispose();
      _chatSearchController.dispose();
      super.dispose();
    }
  
    MatrimonialProfile _getOwnProfile(dynamic user) {
      List<String> photosList = [];
      if (user.photos != null && (user.photos as List).isNotEmpty) {
        photosList = (user.photos as List).map((p) => p.toString()).toList();
      }
      List<String> hobbiesList = [];
      if (user.hobbies != null && (user.hobbies as List).isNotEmpty) {
        hobbiesList = (user.hobbies as List).map((h) => h.toString()).toList();
      }
  
      return MatrimonialProfile(
        id: (user.id ?? user.sId ?? '').toString(),
        fullName: (user.fullName ?? user.name ?? 'User').toString(),
        age: user.age is int ? user.age : (int.tryParse(user.age?.toString() ?? '') ?? 25),
        gender: (user.gender ?? 'Female').toString(),
        religion: (user.religion ?? '').toString(),
        caste: (user.caste ?? '').toString(),
        maritalStatus: (user.maritalStatus ?? '').toString(),
        bloodGroup: (user.bloodGroup ?? '').toString(),
        height: (user.height ?? '').toString(),
        qualification: (user.qualification ?? '').toString(),
        occupation: (user.occupation ?? '').toString(),
        annualIncome: (user.annualIncome ?? '').toString(),
        incomeValue: (user.incomeValue is num) ? (user.incomeValue as num).toDouble() : 0.0,
        city: (user.city ?? '').toString(),
        state: (user.state ?? '').toString(),
        country: (user.country ?? 'India').toString(),
        about: (user.about ?? '').toString(),
        photos: photosList,
        isPremium: user.isPremium == true,
        premiumTier: (user.premiumTier ?? 'Free').toString(),
        compatibilityScore: 100,
        compatibilityTags: const ['Self'],
        rashi: (user.rashi ?? '').toString(),
        nakshatra: (user.nakshatra ?? '').toString(),
        manglik: user.manglik == true,
        familyType: (user.familyType ?? '').toString(),
        education: (user.education ?? user.qualification ?? '').toString(),
        diet: (user.diet ?? '').toString(),
        smoking: (user.smoking ?? 'No').toString(),
        drinking: (user.drinking ?? 'No').toString(),
        fatherName: (user.fatherName ?? '').toString(),
        motherName: (user.motherName ?? '').toString(),
        siblings: (user.siblings ?? '').toString(),
        hobbies: hobbiesList,
        isVerified: user.isVerified == true,
        workLocation: (user.workLocation ?? (user.city != null ? "${user.city}, India" : '')).toString(),
        nativePlace: (user.nativePlace ?? (user.city ?? '')).toString(),
        familyStatus: (user.familyStatus ?? '').toString(),
      );
    }
  
    Future<void> _showExitDialog(BuildContext context) async {
      final exitApp = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit Application?'),
          content: const Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Exit'),
            ),
          ],
        ),
      );
      if (exitApp == true) {
        SystemNavigator.pop();
      }
    }
  
    @override
    Widget build(BuildContext context) {
      final homeState = ref.watch(homeControllerProvider);
      final authState = ref.watch(authControllerProvider);
      final user = authState.user;
  
      final screens = [
        _buildHomeTab(context, homeState, user),
        _buildFavouritesTab(context, homeState),
        _buildChatTab(context),
        _buildProfileTab(context, user),
      ];
  
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            if (homeState.bottomTabIndex != 0) {
              ref.read(homeControllerProvider.notifier).setBottomTab(0);
            } else {
              _showExitDialog(context);
            }
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFFFFDF9),
          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: homeState.bottomTabIndex,
              children: screens,
            ),
          ),
          bottomNavigationBar: _buildCustomBottomNavBar(homeState),
        ),
      );
    }
  
    // Header / Top Section welcome
    Widget _buildTopSection(dynamic user) {
      final unreadCount = ref.watch(notificationProvider).where((n) => !n.isRead).length;
  
      final userPhoto = (user?.photos != null && (user.photos as List).isNotEmpty)
          ? user.photos.first.toString()
          : null;
  
      final userName = (user?.fullName != null && user.fullName.toString().isNotEmpty)
          ? user.fullName.toString()
          : (user?.name != null && user.name.toString().isNotEmpty ? user.name.toString() : 'User');
  
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  backgroundImage: userPhoto != null
                      ? NetworkImage(userPhoto)
                      : const NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100'),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Soyrik',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                // Notification bell with badge dot
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.black),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                          );
                        },
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }
  
    // Home Screen Tab
    Widget _buildHomeTab(BuildContext context, HomeState homeState, dynamic user) {
      final filteredProfiles = ref.watch(filteredProfilesProvider);
  
      return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: _buildTopSection(user),
            ),
            if (homeState.categoryTab == 'Near me') ...[
              SliverToBoxAdapter(
                child: _buildMatchmakingEventsBanner(),
              ),
              SliverToBoxAdapter(
                child: _buildProfileViewsSection(context),
              ),
            ] else if (homeState.categoryTab == 'Recommendation') ...[
              SliverToBoxAdapter(
                child: _buildCuratedPicksBanner(),
              ),
            ] else if (homeState.categoryTab == 'Premium') ...[
              SliverToBoxAdapter(
                child: _buildPremiumBanner(),
              ),
            ],
          ];
        },
        body: Column(
          children: [
            // Sticky Search bar & filters
            _buildSearchBarAndFilter(context, homeState),
  
            // Sticky Category Tabs
            _buildCategoryTabs(homeState),
  
            // Grid of profiles
            Expanded(
              child: filteredProfiles.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.62,
                ),
                itemCount: filteredProfiles.length,
                itemBuilder: (context, index) {
                  final profile = filteredProfiles[index];
                  return _buildProfileCard(context, profile, homeState);
                },
              ),
            )
          ],
        ),
      );
    }
  
    Widget _buildMatchmakingEventsBanner() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EventsScreen()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4A0010), Color(0xFF800A23)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EXCLUSIVE',
                      style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Matchmaking Events',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upcoming & past events near you →',
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '4+\nUpcoming',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  
    Widget _buildProfileViewsSection(BuildContext context) {
      final viewState = ref.watch(profileViewProvider);
  
  // Use ONLY actual profiles returned by the backend.
  // Deduplicate by the real MongoDB profile ID.
      final uniqueProfiles = <String, MatrimonialProfile>{};
  
      for (final profile in viewState.viewerProfiles) {
        final id = profile.id.trim();
  
        if (id.isNotEmpty) {
          uniqueProfiles[id] = profile;
        }
      }
  
      final viewerProfiles = uniqueProfiles.values.toList();
  
  // The HomeScreen count must represent actual unique people,
  // not a stale/local/different count.
      final count = viewerProfiles.length;
  
      String subtitle;
      if (count == 0 || viewerProfiles.isEmpty) {
        subtitle = 'No one has viewed your profile yet';
      } else if (viewerProfiles.length == 1) {
        final firstName = viewerProfiles.first.fullName.trim().split(' ').first;
        subtitle = '$firstName checked your profile';
      } else if (viewerProfiles.length == 2) {
        final firstName = viewerProfiles[0].fullName.trim().split(' ').first;
        final secondName = viewerProfiles[1].fullName.trim().split(' ').first;
        subtitle = '$firstName & $secondName checked your profile';
      } else {
        final firstName = viewerProfiles[0].fullName.trim().split(' ').first;
        final secondName = viewerProfiles[1].fullName.trim().split(' ').first;
        final remaining = count > 2 ? count - 2 : viewerProfiles.length - 2;
        subtitle = '$firstName, $secondName & $remaining others checked your profile';
      }
  
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PROFILE VIEWS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  '$count viewed',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: GestureDetector(
              onTap: () async {
                await ref.read(profileViewProvider.notifier).loadViews();
                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProfileViewsScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECEF).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFECEF)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (viewerProfiles.isNotEmpty)
                            SizedBox(
                              width: 90,
                              height: 32,
                              child: Stack(
                                children: [
                                  for (int i = 0; i < viewerProfiles.take(3).length; i++)
                                    Positioned(
                                      left: i * 18.0,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundImage: NetworkImage(
                                          viewerProfiles[i].photos.first,
                                        ),
                                      ),
                                    ),
                                  if (count > 3)
                                    Positioned(
                                      left: 54,
                                      child: CircleAvatar(
                                        radius: 16,
                                        backgroundColor: AppColors.primary,
                                        child: Text(
                                          '+${count - 3}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          else
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(0xFFFFECEF),
                              child: Icon(
                                Icons.remove_red_eye_outlined,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$count ${count == 1 ? 'person' : 'people'} viewed you',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
  
    Widget _buildCuratedPicksBanner() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFECEF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
          ),
          child: Row(
            children: const [
              Icon(Icons.star, color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Text(
                'Curated picks based on your profile',
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
  
    Widget _buildPremiumBanner() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.workspace_premium, color: Colors.orange.shade700, size: 16),
              const SizedBox(width: 8),
              Text(
                'Premium verified profiles only',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
  
    // Favourites Screen Tab
    Widget _buildFavouritesTab(BuildContext context, HomeState homeState) {
      final favAsync = ref.watch(favoriteProfilesProvider);
      var favProfiles = favAsync.asData?.value ?? [];
      if (_favSearchQuery.isNotEmpty) {
        final q = _favSearchQuery.toLowerCase();
        favProfiles = favProfiles.where((p) =>
        p.fullName.toLowerCase().contains(q) ||
            p.city.toLowerCase().contains(q) ||
            p.occupation.toLowerCase().contains(q) ||
            p.religion.toLowerCase().contains(q)
        ).toList();
      }
  
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        ref.read(homeControllerProvider.notifier).setBottomTab(0);
                      },
                    ),
                    const Text(
                      'Favorite',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFECEF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${favProfiles.length} saved',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
  
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _favSearchController,
                      decoration: const InputDecoration(
                        hintText: 'Search favorites...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
  
          Expanded(
            child: favProfiles.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites selected yet',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.62,
              ),
              itemCount: favProfiles.length,
              itemBuilder: (context, index) {
                final profile = favProfiles[index];
                return _buildProfileCard(context, profile, homeState);
              },
            ),
          ),
        ],
      );
    }
  
    // Chat Screen Tab (Inbox)
    Widget _buildChatTab(BuildContext context) {
      final conversations = ref.watch(messageProvider);
      final messageNotifier = ref.read(messageProvider.notifier);

      var activeConversations = conversations;

      if (_chatSearchQuery.isNotEmpty) {
        final q = _chatSearchQuery.toLowerCase();

        activeConversations = conversations.where((conversation) {
          return conversation.partnerName
              .toLowerCase()
              .contains(q);
        }).toList();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --------------------------------------------------
          // HEADER
          // --------------------------------------------------

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    ref
                        .read(homeControllerProvider.notifier)
                        .setBottomTab(0);
                  },
                ),
                const Text(
                  'Messages',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // SEARCH BAR
          // --------------------------------------------------

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _chatSearchController,
                      decoration: const InputDecoration(
                        hintText: 'Search messages...',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --------------------------------------------------
          // CONVERSATION LIST
          // --------------------------------------------------

          Expanded(
            child: activeConversations.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No messages found',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: activeConversations.length,
              itemBuilder: (context, idx) {
                final conversation =
                activeConversations[idx];

                // ------------------------------------------------
                // LAST MESSAGE
                // ------------------------------------------------

                final lastMsg =
                conversation.messages.isNotEmpty
                    ? conversation.messages.last
                    : null;

                // ------------------------------------------------
                // UNREAD COUNT
                // ------------------------------------------------

                final unreadCount =
                messageNotifier.getUnreadCount(
                  conversation,
                );

                // ------------------------------------------------
                // LAST MESSAGE TIME
                // Convert UTC → device local time (IST)
                // ------------------------------------------------

                String timeStr = '';

                if (lastMsg != null) {
                  final localTime =
                  lastMsg.timestamp.toLocal();

                  final hour = localTime.hour;
                  final minute = localTime.minute;

                  final hour12 = hour == 0
                      ? 12
                      : (hour > 12
                      ? hour - 12
                      : hour);

                  final period =
                  hour >= 12 ? 'PM' : 'AM';

                  timeStr =
                  '$hour12:${minute.toString().padLeft(2, '0')} $period';
                }

                // ------------------------------------------------
                // CHAT TILE
                // ------------------------------------------------

                return ListTile(
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),

                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage:
                    NetworkImage(
                      conversation.partnerAvatar,
                    ),
                  ),

                  title: Text(
                    conversation.partnerName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  subtitle: Text(
                    lastMsg?.text ??
                        'No messages yet',
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                      Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight:
                      unreadCount > 0
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),

                  // ------------------------------------------------
                  // TIME + UNREAD BADGE
                  // ------------------------------------------------

                  trailing: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.end,
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          color: unreadCount > 0
                              ? AppColors.primary
                              : Colors.grey.shade400,
                          fontSize: 10,
                          fontWeight:
                          unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),

                      if (unreadCount > 0) ...[
                        const SizedBox(height: 4),

                        Container(
                          constraints:
                          const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          padding:
                          const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration:
                          const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount > 99
                                ? '99+'
                                : unreadCount
                                .toString(),
                            textAlign:
                            TextAlign.center,
                            style:
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // ------------------------------------------------
                  // OPEN CHAT
                  // ------------------------------------------------

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChatDetailScreen(
                              partnerId:
                              conversation.partnerId,
                              name:
                              conversation.partnerName,
                              avatarUrl:
                              conversation.partnerAvatar,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    }
    Widget _buildProfileTab(BuildContext context, dynamic user) {
      return const ProfileScreen();
    }
  
  
  
  
    // Profile Card Component matching UI designs
    Widget _buildProfileCard(BuildContext context, MatrimonialProfile profile, HomeState homeState) {
      final isFav = homeState.favouriteIds.contains(profile.id);
  
      return GestureDetector(
        onTap: () {
          ref.read(profileViewProvider.notifier).recordView(profile.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileDetailsScreen(profile: profile),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Photo & Overlay badges
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(profile.photos.first),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Compatibility Tag or Premium Tier top left overlay
                    if (homeState.categoryTab == 'Recommendation') ...[
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${profile.compatibilityScore}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ] else if (profile.isPremium) ...[
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: profile.premiumTier == 'Platinum'
                                ? const Color(0xFF4A90E2)
                                : (profile.premiumTier == 'Gold' ? const Color(0xFFD4AF37) : const Color(0xFF9B59B6)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.white, size: 8),
                              const SizedBox(width: 3),
                              Text(
                                profile.premiumTier,
                                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
  
                    // Favorite Heart Button (Top Right)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          ref.read(homeControllerProvider.notifier).toggleFavourite(profile.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? AppColors.primary : Colors.grey,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
  
                    // Bottom small alignment tags on photo
                    if (homeState.categoryTab == 'Recommendation' && profile.compatibilityTags.isNotEmpty) ...[
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            profile.compatibilityTags.first,
                            style: const TextStyle(color: Colors.white, fontSize: 8),
                          ),
                        ),
                      )
                    ] else if (homeState.categoryTab == 'New matches') ...[
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.check_circle_outline, color: Colors.green, size: 8),
                              SizedBox(width: 3),
                              Text('Compatible horoscope', style: TextStyle(color: Colors.white, fontSize: 8)),
                            ],
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              ),
  
              // Text Details
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            profile.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (profile.isPremium) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.check_circle, color: Colors.green, size: 12),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Age ${profile.age}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${profile.maritalStatus} • ${profile.occupation}',
                      style: const TextStyle(color: Colors.grey, fontSize: 9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      profile.annualIncome,
                      style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 9),
                    ),
                    Text(
                      '${profile.city}, ${profile.state}',
                      style: const TextStyle(color: Colors.grey, fontSize: 9),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  
    // Search input bar and filters sheet trigger button
    Widget _buildSearchBarAndFilter(BuildContext context, HomeState homeState) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search for your perfect match',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Filter sheet icon trigger button
            GestureDetector(
              onTap: () => _showFiltersBottomSheet(context, homeState),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: const Icon(Icons.tune, color: Colors.black),
              ),
            ),
          ],
        ),
      );
    }
  
    // Filters bottom sheet exactly matching style
    void _showFiltersBottomSheet(BuildContext context, HomeState currentHomeState) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        builder: (context) {
          return FilterBottomSheetWidget(initialFilters: currentHomeState.filters);
        },
      );
    }
  
    // Category Selector Tabs
    Widget _buildCategoryTabs(HomeState homeState) {
      final categories = ['Near me', 'New matches', 'Recommendation', 'Premium'];
  
      return Container(
        height: 52,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isSelected = homeState.categoryTab == cat;
  
            return GestureDetector(
              onTap: () {
                ref.read(homeControllerProvider.notifier).setCategoryTab(cat);
              },
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                  ),
                  boxShadow: isSelected
                      ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                      : [],
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  
    // Empty state for filters or searches
    Widget _buildEmptyState() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No matching profiles found',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Try adjusting your search or filter values', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );
    }
  
    // Custom premium looking navigation bar
    Widget _buildCustomBottomNavBar(HomeState homeState) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(0, Icons.home_rounded, 'Home', homeState),
            _buildNavItem(1, Icons.favorite_rounded, 'Likes', homeState),
            _buildNavItem(2, Icons.chat_bubble_rounded, 'Message', homeState),
            _buildNavItem(3, Icons.person_rounded, 'Profile', homeState),
          ],
        ),
      );
    }
  
    Widget _buildNavItem(int index, IconData icon, String label, HomeState homeState) {
      final isSelected = homeState.bottomTabIndex == index;
  
      if (isSelected) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      } else {
        return IconButton(
          icon: Icon(icon, color: Colors.grey.shade400, size: 22),
          onPressed: () {
            ref.read(homeControllerProvider.notifier).setBottomTab(index);
          },
        );
      }
    }
  }
  
  // Stateful bottom sheet widget to maintain temporary filter states
  class FilterBottomSheetWidget extends ConsumerStatefulWidget {
    final ProfileFilters initialFilters;
  
    const FilterBottomSheetWidget({super.key, required this.initialFilters});
  
    @override
    ConsumerState<FilterBottomSheetWidget> createState() => _FilterBottomSheetWidgetState();
  }
  
  class _FilterBottomSheetWidgetState extends ConsumerState<FilterBottomSheetWidget> {
    late int _ageMin;
    late int _ageMax;
    String? _maritalStatus;
    String? _height;
    String? _city;
    String? _state;
    String? _country;
    String? _profession;
    late double _incomeLPA;
    String? _education;
    String? _manglik;
    String? _familyType;
    String? _religion;
    String? _caste;
    String? _diet;
  
    @override
    void initState() {
      super.initState();
      final f = widget.initialFilters;
      _ageMin = f.ageMin;
      _ageMax = f.ageMax;
      _maritalStatus = f.maritalStatus;
      _height = f.height;
      _city = f.city;
      _state = f.state;
      _country = f.country;
      _profession = f.profession;
      _incomeLPA = f.expectedIncomeLPA < 1 ? 1.0 : (f.expectedIncomeLPA > 50 ? 50.0 : f.expectedIncomeLPA.toDouble());
      _education = f.education;
      _manglik = f.manglik;
      _familyType = f.familyType;
      _religion = f.religion;
      _caste = f.caste;
      _diet = f.diet;
    }
  
    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.tune, color: Colors.black, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Filters',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _ageMin = 22;
                        _ageMax = 35;
                        _maritalStatus = null;
                        _height = null;
                        _city = null;
                        _state = null;
                        _country = null;
                        _profession = null;
                        _incomeLPA = 1.0;
                        _education = null;
                        _manglik = 'Any';
                        _familyType = null;
                        _religion = null;
                        _caste = null;
                        _diet = null;
                      });
                    },
                    child: const Text('Reset all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(),
  
              // Scrollable Filters Options
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),
  
                      // Age range row selector
                      const Text('Age range', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _ageMin,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: List.generate(24, (index) => index + 18)
                                  .map((age) => DropdownMenuItem(value: age, child: Text('$age')))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _ageMin = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              value: _ageMax,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              items: List.generate(24, (index) => index + 18)
                                  .map((age) => DropdownMenuItem(value: age, child: Text('$age')))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _ageMax = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
  
                      // Marital Status dropdown
                      const Text('Marital status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _maritalStatus,
                        hint: const Text('Select marital status', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Never Married', 'Divorced', 'Widowed', 'Awaiting Divorce']
                            .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                            .toList(),
                        onChanged: (val) => setState(() => _maritalStatus = val),
                      ),
                      const SizedBox(height: 16),
  
                      // Height Selector
                      const Text('Height', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _height,
                        decoration: InputDecoration(
                          hintText: 'Enter height (e.g. 5\'6")',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (val) => setState(() => _height = val.trim().isEmpty ? null : val),
                      ),
                      const SizedBox(height: 16),
  
                      // City Selector
                      const Text('City', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _city,
                        hint: const Text('Select city', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Pune', 'Ahmedabad', 'Hyderabad', 'Kochi', 'Chandigarh', 'Lucknow', 'Kolkata', 'Jaipur', 'Mumbai', 'Bengaluru', 'Delhi', 'Goa', 'Amritsar', 'Mysuru']
                            .map((city) => DropdownMenuItem(value: city, child: Text(city)))
                            .toList(),
                        onChanged: (val) => setState(() => _city = val),
                      ),
                      const SizedBox(height: 16),
  
                      // State input
                      const Text('State', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _state,
                        decoration: InputDecoration(
                          hintText: 'Enter state',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (val) => setState(() => _state = val.trim().isEmpty ? null : val),
                      ),
                      const SizedBox(height: 16),
  
                      // Country input
                      const Text('Country', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _country,
                        decoration: InputDecoration(
                          hintText: 'Enter country',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (val) => setState(() => _country = val.trim().isEmpty ? null : val),
                      ),
                      const SizedBox(height: 16),
  
                      // Profession Dropdown
                      const Text('Profession', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _profession,
                        hint: const Text('Select profession', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Software Engineer', 'Doctor (Gynecologist)', 'Data Analyst', 'Bank Manager', 'Registered Nurse', 'Researcher', 'Architect', 'Chartered Accountant', 'Marketing Director', 'Lead Data Scientist', 'Government Agro Officer', 'Export-Import Business', 'Hotel Manager', 'Hardware Chip Designer', 'Automobile Engineer']
                            .map((prof) => DropdownMenuItem(value: prof, child: Text(prof)))
                            .toList(),
                        onChanged: (val) => setState(() => _profession = val),
                      ),
                      const SizedBox(height: 16),
  
                      // Expected Income Range with Slider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Expected income', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                          Text('${_incomeLPA.toInt()} LPA', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Slider(
                        value: _incomeLPA.clamp(1.0, 50.0),
                        min: 1,
                        max: 50,
                        activeColor: AppColors.primary,
                        inactiveColor: Colors.grey.shade200,
                        onChanged: (val) => setState(() => _incomeLPA = val),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('1 LPA', style: TextStyle(fontSize: 10, color: Colors.grey)),
                          Text('50 LPA', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 16),
  
                      // Education level dropdown
                      const Text('Education', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _education,
                        hint: const Text('Select education level', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['B.Tech', 'Doctorate', 'M.B.A', 'Master\'s', 'Bachelor\'s']
                            .map((edu) => DropdownMenuItem(value: edu, child: Text(edu)))
                            .toList(),
                        onChanged: (val) => setState(() => _education = val),
                      ),
                      const SizedBox(height: 16),
  
                      // Religion dropdown
                      const Text('Religion', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _religion,
                        hint: const Text('Select religion', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Hindu', 'Christian', 'Muslim', 'Sikh', 'Jain', 'Buddhist']
                            .map((rel) => DropdownMenuItem(value: rel, child: Text(rel)))
                            .toList(),
                        onChanged: (val) => setState(() => _religion = val),
                      ),
                      const SizedBox(height: 16),
  
                      // Caste input
                      const Text('Caste', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _caste,
                        decoration: InputDecoration(
                          hintText: 'Enter caste',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onChanged: (val) => setState(() => _caste = val.trim().isEmpty ? null : val),
                      ),
                      const SizedBox(height: 16),
  
                      // Diet dropdown
                      const Text('Diet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _diet,
                        hint: const Text('Select diet', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: ['Vegetarian', 'Non-Vegetarian', 'Eggetarian', 'Vegan']
                            .map((diet) => DropdownMenuItem(value: diet, child: Text(diet)))
                            .toList(),
                        onChanged: (val) => setState(() => _diet = val),
                      ),
                      const SizedBox(height: 16),
  
                      // Manglik Status Selector
                      const Text('Manglik status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Any', 'Yes', 'No'].map((m) {
                          final isSel = _manglik == m;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _manglik = m),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isSel ? AppColors.primary : Colors.grey.shade300),
                                ),
                                child: Text(
                                  m,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
  
                      // Family Type
                      const Text('Family type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black)),
                      const SizedBox(height: 8),
                      Row(
                        children: ['Nuclear', 'Joint'].map((t) {
                          final isSel = _familyType == t;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _familyType = isSel ? null : t),
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSel ? AppColors.primary : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: isSel ? AppColors.primary : Colors.grey.shade300),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
  
              // Action Buttons
              ElevatedButton(
                onPressed: () {
                  final newFilters = ProfileFilters(
                    ageMin: _ageMin,
                    ageMax: _ageMax,
                    maritalStatus: _maritalStatus,
                    height: _height,
                    city: _city,
                    state: _state,
                    country: _country,
                    profession: _profession,
                    expectedIncomeLPA: _incomeLPA.toInt(),
                    education: _education,
                    manglik: _manglik,
                    familyType: _familyType,
                    religion: _religion,
                    caste: _caste,
                    diet: _diet,
                  );
                  ref.read(homeControllerProvider.notifier).applyFilters(newFilters);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Apply Filters', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }
  }
