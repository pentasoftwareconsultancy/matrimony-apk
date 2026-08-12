import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../features/auth/domain/models/user.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../core/data/dummy_profiles.dart';
import 'app_providers.dart';

class ProfileFilters {
  final int ageMin;
  final int ageMax;
  final String? maritalStatus;
  final String? height;
  final String? city;
  final String? state;
  final String? country;
  final String? profession;
  final int expectedIncomeLPA; // 1 to 50 LPA
  final String? education;
  final String? manglik; // "Yes", "No", "Any"
  final String? familyType;
  final String? religion;
  final String? caste;
  final String? diet;

  ProfileFilters({
    this.ageMin = 22,
    this.ageMax = 35,
    this.maritalStatus,
    this.height,
    this.city,
    this.state,
    this.country,
    this.profession,
    this.expectedIncomeLPA = 9,
    this.education,
    this.manglik = 'Any',
    this.familyType,
    this.religion,
    this.caste,
    this.diet,
  });

  ProfileFilters copyWith({
    int? ageMin,
    int? ageMax,
    String? maritalStatus,
    String? height,
    String? city,
    String? state,
    String? country,
    String? profession,
    int? expectedIncomeLPA,
    String? education,
    String? manglik,
    String? familyType,
    String? religion,
    String? caste,
    String? diet,
  }) {
    return ProfileFilters(
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      maritalStatus: maritalStatus == 'Clear' ? null : (maritalStatus ?? this.maritalStatus),
      height: height == 'Clear' ? null : (height ?? this.height),
      city: city == 'Clear' ? null : (city ?? this.city),
      state: state == 'Clear' ? null : (state ?? this.state),
      country: country == 'Clear' ? null : (country ?? this.country),
      profession: profession == 'Clear' ? null : (profession ?? this.profession),
      expectedIncomeLPA: expectedIncomeLPA ?? this.expectedIncomeLPA,
      education: education == 'Clear' ? null : (education ?? this.education),
      manglik: manglik == 'Clear' ? null : (manglik ?? this.manglik),
      familyType: familyType == 'Clear' ? null : (familyType ?? this.familyType),
      religion: religion == 'Clear' ? null : (religion ?? this.religion),
      caste: caste == 'Clear' ? null : (caste ?? this.caste),
      diet: diet == 'Clear' ? null : (diet ?? this.diet),
    );
  }
}

class HomeState {
  final List<String> favouriteIds;
  final List<String> viewedProfileIds; // List of viewed profile IDs
  final int bottomTabIndex; // 0 = Home, 1 = Favourites, 2 = Chat, 3 = Profile
  final String categoryTab; // "Near me", "New matches", "Recommendation", "Premium"
  final String searchQuery;
  final ProfileFilters filters;
  final bool isLoading;

  HomeState({
    this.favouriteIds = const [],
    this.viewedProfileIds = const [],
    this.bottomTabIndex = 0,
    this.categoryTab = 'Near me',
    this.searchQuery = '',
    ProfileFilters? filters,
    this.isLoading = false,
  }) : filters = filters ?? ProfileFilters();

  HomeState copyWith({
    List<String>? favouriteIds,
    List<String>? viewedProfileIds,
    int? bottomTabIndex,
    String? categoryTab,
    String? searchQuery,
    ProfileFilters? filters,
    bool? isLoading,
  }) {
    return HomeState(
      favouriteIds: favouriteIds ?? this.favouriteIds,
      viewedProfileIds: viewedProfileIds ?? this.viewedProfileIds,
      bottomTabIndex: bottomTabIndex ?? this.bottomTabIndex,
      categoryTab: categoryTab ?? this.categoryTab,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class HomeControllerNotifier extends StateNotifier<HomeState> {
  final Ref _ref;

  HomeControllerNotifier(this._ref) : super(HomeState()) {
    _loadFavourites();
    _loadFilters();
  }

  Future<void> _loadFavourites() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favourites') ?? [];
    final views = prefs.getStringList('viewedProfileIds') ?? [];
    state = state.copyWith(favouriteIds: favs, viewedProfileIds: views);
  }

  Future<void> _loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final filtersJsonStr = prefs.getString('savedFilters');
    if (filtersJsonStr != null) {
      try {
        final Map<String, dynamic> map = jsonDecode(filtersJsonStr);
        final loadedFilters = ProfileFilters(
          ageMin: map['ageMin'] ?? 22,
          ageMax: map['ageMax'] ?? 35,
          maritalStatus: map['maritalStatus'],
          height: map['height'],
          city: map['city'],
          state: map['state'],
          country: map['country'],
          profession: map['profession'],
          expectedIncomeLPA: map['expectedIncomeLPA'] ?? 9,
          education: map['education'],
          manglik: map['manglik'] ?? 'Any',
          familyType: map['familyType'],
          religion: map['religion'],
          caste: map['caste'],
          diet: map['diet'],
        );
        state = state.copyWith(filters: loadedFilters);
      } catch (_) {}
    }
  }

  void syncFavourites(List<String> favs) {
    state = state.copyWith(favouriteIds: favs);
  }

  void syncViews(List<String> views) {
    state = state.copyWith(viewedProfileIds: views);
  }

  Future<void> toggleFavourite(String id) async {
    await _ref.read(favouriteProvider.notifier).toggle(id);
  }

  Future<void> addProfileView(String id) async {
    await _ref.read(profileViewProvider.notifier).addView(id);
  }

  void setBottomTab(int index) {
    state = state.copyWith(bottomTabIndex: index);
  }

  void setCategoryTab(String tab) {
    state = state.copyWith(categoryTab: tab);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  Future<void> applyFilters(ProfileFilters newFilters) async {
    state = state.copyWith(filters: newFilters);
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> map = {
      'ageMin': newFilters.ageMin,
      'ageMax': newFilters.ageMax,
      'maritalStatus': newFilters.maritalStatus,
      'height': newFilters.height,
      'city': newFilters.city,
      'state': newFilters.state,
      'country': newFilters.country,
      'profession': newFilters.profession,
      'expectedIncomeLPA': newFilters.expectedIncomeLPA,
      'education': newFilters.education,
      'manglik': newFilters.manglik,
      'familyType': newFilters.familyType,
      'religion': newFilters.religion,
      'caste': newFilters.caste,
      'diet': newFilters.diet,
    };
    await prefs.setString('savedFilters', jsonEncode(map));
  }

  Future<void> resetFilters() async {
    final reset = ProfileFilters();
    state = state.copyWith(filters: reset);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('savedFilters');
  }

  // Update profile locally and refresh authenticated user state
  Future<void> updateProfileLocally(Map<String, dynamic> updatedData) async {
    final prefs = await SharedPreferences.getInstance();
    final profileJsonStr = prefs.getString('profile');
    if (profileJsonStr != null) {
      final Map<String, dynamic> currentProfile = jsonDecode(profileJsonStr);
      // Merge updated data
      currentProfile.addAll(updatedData);
      
      // Keep static required parameters
      currentProfile['profileCompleted'] = true;
      currentProfile['isVerified'] = true;
      currentProfile['isPremium'] = true;
      currentProfile['role'] = 'user';
      currentProfile['_id'] = currentProfile['_id'] ?? 'dummy_user_id';

      await prefs.setString('profile', jsonEncode(currentProfile));

      final updatedUser = User.fromJson(currentProfile);
      _ref.read(authControllerProvider.notifier).setAuthenticatedState(updatedUser);
    }
  }
}

final homeControllerProvider = StateNotifierProvider<HomeControllerNotifier, HomeState>((ref) {
  return HomeControllerNotifier(ref);
});

// A provider that computes the list of filtered profiles based on current state and search query
final filteredProfilesProvider = Provider<List<MatrimonialProfile>>((ref) {
  final homeState = ref.watch(homeControllerProvider);
  final authState = ref.watch(authControllerProvider);
  
  // Exclude current registered user if their gender is opposite or we just filter by gender
  final loggedInUser = authState.user;
  final oppositeGender = loggedInUser?.gender == 'Male' ? 'Female' : (loggedInUser?.gender == 'Female' ? 'Male' : null);

  List<MatrimonialProfile> list = dummyProfiles;

  // Filter 1: Basic gender preference (usually matrimonial lists show opposite gender matches)
  if (oppositeGender != null) {
    list = list.where((p) => p.gender == oppositeGender).toList();
  }

  // Filter 2: Search Query (Name, City, Profession, Religion)
  if (homeState.searchQuery.isNotEmpty) {
    final q = homeState.searchQuery.toLowerCase();
    list = list.where((p) {
      return p.fullName.toLowerCase().contains(q) ||
             p.city.toLowerCase().contains(q) ||
             p.occupation.toLowerCase().contains(q) ||
             p.religion.toLowerCase().contains(q);
    }).toList();
  }

  // Filter 3: Apply Filters from sheet
  final f = homeState.filters;
  list = list.where((p) {
    if (p.age < f.ageMin || p.age > f.ageMax) return false;
    
    if (f.maritalStatus != null && p.maritalStatus.toLowerCase() != f.maritalStatus!.toLowerCase()) return false;
    
    if (f.height != null && !p.height.toLowerCase().contains(f.height!.toLowerCase())) return false;
    
    if (f.city != null && p.city.toLowerCase() != f.city!.toLowerCase()) return false;
    
    if (f.state != null && p.state.toLowerCase() != f.state!.toLowerCase()) return false;
    
    if (f.country != null && p.country.toLowerCase() != f.country!.toLowerCase()) return false;
    
    if (f.profession != null && p.occupation.toLowerCase() != f.profession!.toLowerCase()) return false;
    
    // LPA income filter: list matches if profile income is greater than or equal to chosen LPA
    if (p.incomeValue < f.expectedIncomeLPA) return false;
    
    if (f.education != null && p.education.toLowerCase() != f.education!.toLowerCase()) return false;
    
    if (f.manglik != null && f.manglik != 'Any') {
      final isManglikQuery = f.manglik == 'Yes';
      if (p.manglik != isManglikQuery) return false;
    }
    
    if (f.familyType != null && p.familyType.toLowerCase() != f.familyType!.toLowerCase()) return false;
    
    if (f.religion != null && p.religion.toLowerCase() != f.religion!.toLowerCase()) return false;
    if (f.caste != null && p.caste.toLowerCase() != f.caste!.toLowerCase()) return false;
    if (f.diet != null && p.diet.toLowerCase() != f.diet!.toLowerCase()) return false;

    return true;
  }).toList();

  // Filter 4: Category Tabs
  // "Near me", "New matches", "Recommendation", "Premium"
  if (homeState.categoryTab == 'Near me') {
    // Sorted by same city as logged-in user first, then others
    final myCity = loggedInUser?.city ?? '';
    if (myCity.isNotEmpty) {
      final matchesMyCity = list.where((p) => p.city.toLowerCase() == myCity.toLowerCase()).toList();
      final otherCities = list.where((p) => p.city.toLowerCase() != myCity.toLowerCase()).toList();
      list = [...matchesMyCity, ...otherCities];
    }
  } else if (homeState.categoryTab == 'New matches') {
    // Simple mock: reverse profiles list (or sort youngest first for 'newest')
    list = List.from(list)..sort((a, b) => b.id.compareTo(a.id));
  } else if (homeState.categoryTab == 'Recommendation') {
    // Sorted by compatibility score descending
    list = List.from(list)..sort((a, b) => b.compatibilityScore.compareTo(a.compatibilityScore));
  } else if (homeState.categoryTab == 'Premium') {
    // Show only Premium profiles
    list = list.where((p) => p.isPremium).toList();
  }

  return list;
});
