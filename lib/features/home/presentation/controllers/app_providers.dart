import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/data/dummy_profiles.dart';
import 'home_controller.dart';

// ==========================================
// MODELS
// ==========================================

class NotificationItem {
  final String id;
  final String profileId;
  final String profileImage;
  final String title;
  final String subtitle;
  final String time;
  final String type; // 'match', 'interest', 'views', 'admin', 'verification'
  final bool isRead;

  NotificationItem({
    required this.id,
    required this.profileId,
    required this.profileImage,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      profileId: profileId,
      profileImage: profileImage,
      title: title,
      subtitle: subtitle,
      time: time,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'profileImage': profileImage,
      'title': title,
      'subtitle': subtitle,
      'time': time,
      'type': type,
      'isRead': isRead,
    };
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? json['_id'] ?? 'n_${DateTime.now().millisecondsSinceEpoch}',
      profileId: json['profileId'] ?? '',
      profileImage: json['profileImage'] ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      time: json['time'] ?? 'Just now',
      type: json['type'] ?? 'interest',
      isRead: json['isRead'] ?? false,
    );
  }
}

class MessageItem {
  final String id;
  final String senderId; // 'me' or partnerId
  final String text;
  final DateTime timestamp;

  MessageItem({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageItem.fromJson(Map<String, dynamic> json) {
    return MessageItem(
      id: json['id'] ?? json['_id'] ?? 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: json['senderId'] ?? 'me',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class ConversationItem {
  final String partnerId;
  final String partnerName;
  final String partnerAvatar;
  final List<MessageItem> messages;

  ConversationItem({
    required this.partnerId,
    required this.partnerName,
    required this.partnerAvatar,
    required this.messages,
  });

  ConversationItem copyWith({List<MessageItem>? messages}) {
    return ConversationItem(
      partnerId: partnerId,
      partnerName: partnerName,
      partnerAvatar: partnerAvatar,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partnerId': partnerId,
      'partnerName': partnerName,
      'partnerAvatar': partnerAvatar,
      'messages': messages.map((m) => m.toJson()).toList(),
    };
  }

  factory ConversationItem.fromJson(Map<String, dynamic> json) {
    final List<dynamic> msgsJson = json['messages'] ?? [];
    return ConversationItem(
      partnerId: json['partnerId'] ?? '',
      partnerName: json['partnerName'] ?? 'Member',
      partnerAvatar: json['partnerAvatar'] ?? 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      messages: msgsJson.map((m) => MessageItem.fromJson(m as Map<String, dynamic>)).toList(),
    );
  }
}

// ==========================================
// STATE NOTIFIERS CONNECTED TO BACKEND
// ==========================================

class FavouriteNotifier extends StateNotifier<List<String>> {
  final Ref _ref;

  FavouriteNotifier(this._ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/favorites');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((e) => e.toString()).toList();
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final favs = prefs.getStringList('favourites');
      state = favs ?? [];
    }
  }

  Future<void> toggle(String id) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.post('/favorites/$id/toggle');
      final list = response.data['data']['favorites'] as List<dynamic>;
      state = list.map((e) => e.toString()).toList();
    } catch (_) {
      final updated = List<String>.from(state);
      if (updated.contains(id)) {
        updated.remove(id);
      } else {
        updated.add(id);
      }
      state = updated;
    }
    _ref.read(homeControllerProvider.notifier).syncFavourites(state);
  }
}

class NotificationNotifier extends StateNotifier<List<NotificationItem>> {
  final Ref _ref;

  NotificationNotifier(this._ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/notifications');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((item) => NotificationItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.put('/notifications/$id/read');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((item) => NotificationItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      state = state.map((item) => item.id == id ? item.copyWith(isRead: true) : item).toList();
    }
  }

  Future<void> clearAllUnread() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.put('/notifications/read-all');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((item) => NotificationItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      state = state.map((item) => item.copyWith(isRead: true)).toList();
    }
  }

  int getUnreadCount() {
    return state.where((item) => !item.isRead).length;
  }
}

class MessageNotifier extends StateNotifier<List<ConversationItem>> {
  final Ref _ref;

  MessageNotifier(this._ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/messages/conversations');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((item) => ConversationItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {}
  }

  Future<void> sendMessage(String partnerId, String text) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.post('/messages/$partnerId', data: {'text': text});
      await _load();
    } catch (_) {
      // Fallback local update
      final exists = state.any((c) => c.partnerId == partnerId);
      if (!exists) {
        state = [
          ...state,
          ConversationItem(
            partnerId: partnerId,
            partnerName: 'Member',
            partnerAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
            messages: [],
          )
        ];
      }
      state = state.map((c) {
        if (c.partnerId == partnerId) {
          final updated = List<MessageItem>.from(c.messages)
            ..add(MessageItem(
              id: 'msg_user_${DateTime.now().millisecondsSinceEpoch}',
              senderId: 'me',
              text: text,
              timestamp: DateTime.now(),
            ));
          return c.copyWith(messages: updated);
        }
        return c;
      }).toList();
    }
  }
}

class ProfileViewState {
  final int count;
  final List<MatrimonialProfile> viewerProfiles;
  final bool isLoading;

  ProfileViewState({
    this.count = 0,
    this.viewerProfiles = const [],
    this.isLoading = false,
  });

  ProfileViewState copyWith({
    int? count,
    List<MatrimonialProfile>? viewerProfiles,
    bool? isLoading,
  }) {
    return ProfileViewState(
      count: count ?? this.count,
      viewerProfiles: viewerProfiles ?? this.viewerProfiles,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProfileViewNotifier extends StateNotifier<ProfileViewState> {
  final Ref _ref;

  ProfileViewNotifier(this._ref) : super(ProfileViewState()) {
    loadViews();
  }

  Future<void> loadViews() async {
    state = state.copyWith(isLoading: true);
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/profile/views');
      final data = response.data['data'];
      final count = data['count'] is int ? data['count'] as int : 0;
      final viewsList = data['views'] as List<dynamic>? ?? [];

      final List<MatrimonialProfile> profiles = [];
      for (var item in viewsList) {
        if (item['profile'] != null) {
          profiles.add(MatrimonialProfile.fromJson(Map<String, dynamic>.from(item['profile'])));
        }
      }
      state = ProfileViewState(count: count, viewerProfiles: profiles, isLoading: false);
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> recordView(String targetProfileId) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.post('/profile/views/$targetProfileId');
    } catch (_) {}
  }
}

// ==========================================
// PROVIDERS DEFINITIONS
// ==========================================

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, List<String>>((ref) {
  return FavouriteNotifier(ref);
});

final favoriteProfilesProvider = FutureProvider<List<MatrimonialProfile>>((ref) async {
  try {
    final apiClient = ref.watch(apiClientProvider);
    final response = await apiClient.get('/favorites/profiles');
    final list = response.data['data'] as List<dynamic>;
    return list.map((e) => MatrimonialProfile.fromJson(Map<String, dynamic>.from(e))).toList();
  } catch (_) {
    return [];
  }
});

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationItem>>((ref) {
  return NotificationNotifier(ref);
});

final messageProvider = StateNotifierProvider<MessageNotifier, List<ConversationItem>>((ref) {
  return MessageNotifier(ref);
});

final profileViewProvider = StateNotifierProvider<ProfileViewNotifier, ProfileViewState>((ref) {
  return ProfileViewNotifier(ref);
});

final homeProvider = homeControllerProvider;

// ==========================================
// SETTINGS MODELS & PROVIDERS
// ==========================================

class PrivacySettings {
  final bool hidePhone;
  final bool hideEmail;
  final bool hidePhotos;
  final bool hideIncome;
  final bool hideLastSeen;
  final bool hideOnlineStatus;
  final bool hideProfile;

  PrivacySettings({
    this.hidePhone = false,
    this.hideEmail = false,
    this.hidePhotos = false,
    this.hideIncome = false,
    this.hideLastSeen = false,
    this.hideOnlineStatus = false,
    this.hideProfile = false,
  });

  PrivacySettings copyWith({
    bool? hidePhone,
    bool? hideEmail,
    bool? hidePhotos,
    bool? hideIncome,
    bool? hideLastSeen,
    bool? hideOnlineStatus,
    bool? hideProfile,
  }) {
    return PrivacySettings(
      hidePhone: hidePhone ?? this.hidePhone,
      hideEmail: hideEmail ?? this.hideEmail,
      hidePhotos: hidePhotos ?? this.hidePhotos,
      hideIncome: hideIncome ?? this.hideIncome,
      hideLastSeen: hideLastSeen ?? this.hideLastSeen,
      hideOnlineStatus: hideOnlineStatus ?? this.hideOnlineStatus,
      hideProfile: hideProfile ?? this.hideProfile,
    );
  }

  Map<String, dynamic> toJson() => {
    'hidePhone': hidePhone,
    'hideEmail': hideEmail,
    'hidePhotos': hidePhotos,
    'hideIncome': hideIncome,
    'hideLastSeen': hideLastSeen,
    'hideOnlineStatus': hideOnlineStatus,
    'hideProfile': hideProfile,
  };

  factory PrivacySettings.fromJson(Map<String, dynamic> json) => PrivacySettings(
    hidePhone: json['hidePhone'] ?? false,
    hideEmail: json['hideEmail'] ?? false,
    hidePhotos: json['hidePhotos'] ?? false,
    hideIncome: json['hideIncome'] ?? false,
    hideLastSeen: json['hideLastSeen'] ?? false,
    hideOnlineStatus: json['hideOnlineStatus'] ?? false,
    hideProfile: json['hideProfile'] ?? false,
  );
}

class PrivacySettingsNotifier extends StateNotifier<PrivacySettings> {
  final Ref _ref;

  PrivacySettingsNotifier(this._ref) : super(PrivacySettings()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/settings');
      final data = response.data['data']['privacySettings'] as Map<String, dynamic>;
      state = PrivacySettings.fromJson(data);
    } catch (_) {}
  }

  Future<void> save(PrivacySettings settings) async {
    state = settings;
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.put('/settings/privacy', data: settings.toJson());
    } catch (_) {}
  }
}

final privacySettingsProvider = StateNotifierProvider<PrivacySettingsNotifier, PrivacySettings>((ref) {
  return PrivacySettingsNotifier(ref);
});

class NotificationPrefs {
  final bool push;
  final bool email;
  final bool whatsapp;

  NotificationPrefs({
    this.push = true,
    this.email = true,
    this.whatsapp = false,
  });

  NotificationPrefs copyWith({
    bool? push,
    bool? email,
    bool? whatsapp,
  }) {
    return NotificationPrefs(
      push: push ?? this.push,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
    );
  }

  Map<String, dynamic> toJson() => {
    'push': push,
    'email': email,
    'whatsapp': whatsapp,
  };

  factory NotificationPrefs.fromJson(Map<String, dynamic> json) => NotificationPrefs(
    push: json['push'] ?? true,
    email: json['email'] ?? true,
    whatsapp: json['whatsapp'] ?? false,
  );
}

class NotificationPrefsNotifier extends StateNotifier<NotificationPrefs> {
  final Ref _ref;

  NotificationPrefsNotifier(this._ref) : super(NotificationPrefs()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/settings');
      final data = response.data['data']['notificationPrefs'] as Map<String, dynamic>;
      state = NotificationPrefs.fromJson(data);
    } catch (_) {}
  }

  Future<void> save(NotificationPrefs prefsData) async {
    state = prefsData;
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.put('/settings/notifications', data: prefsData.toJson());
    } catch (_) {}
  }
}

final notificationPrefsProvider = StateNotifierProvider<NotificationPrefsNotifier, NotificationPrefs>((ref) {
  return NotificationPrefsNotifier(ref);
});

class LanguageNotifier extends StateNotifier<String> {
  final Ref _ref;

  LanguageNotifier(this._ref) : super('English') {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/settings');
      state = response.data['data']['language'] ?? 'English';
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      state = prefs.getString('appLanguage') ?? 'English';
    }
  }

  Future<void> save(String lang) async {
    state = lang;
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.put('/settings/language', data: {'language': lang});
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('appLanguage', lang);
    }
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier(ref);
});

class BlockedUsersNotifier extends StateNotifier<List<String>> {
  final Ref _ref;

  BlockedUsersNotifier(this._ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/blocked');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((e) => e.toString()).toList();
    } catch (_) {}
  }

  Future<void> block(String id) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.post('/blocked/$id');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((e) => e.toString()).toList();
    } catch (_) {
      if (!state.contains(id)) state = [...state, id];
    }
  }

  Future<void> unblock(String id) async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.delete('/blocked/$id');
      final list = response.data['data'] as List<dynamic>;
      state = list.map((e) => e.toString()).toList();
    } catch (_) {
      state = state.where((item) => item != id).toList();
    }
  }
}

final blockedUsersProvider = StateNotifierProvider<BlockedUsersNotifier, List<String>>((ref) {
  return BlockedUsersNotifier(ref);
});

class PartnerPreference {
  final int ageMin;
  final int ageMax;
  final String height;
  final String religion;
  final String caste;
  final String city;
  final String education;
  final String occupation;
  final String income;
  final String maritalStatus;
  final String diet;
  final String manglik;

  PartnerPreference({
    this.ageMin = 22,
    this.ageMax = 32,
    this.height = '5\'2" - 6\'0"',
    this.religion = 'Hindu',
    this.caste = 'Any',
    this.city = 'Pune',
    this.education = 'Bachelor\'s',
    this.occupation = 'Software Engineer',
    this.income = '5 LPA - 20 LPA',
    this.maritalStatus = 'Never Married',
    this.diet = 'Vegetarian',
    this.manglik = 'No',
  });

  PartnerPreference copyWith({
    int? ageMin,
    int? ageMax,
    String? height,
    String? religion,
    String? caste,
    String? city,
    String? education,
    String? occupation,
    String? income,
    String? maritalStatus,
    String? diet,
    String? manglik,
  }) {
    return PartnerPreference(
      ageMin: ageMin ?? this.ageMin,
      ageMax: ageMax ?? this.ageMax,
      height: height ?? this.height,
      religion: religion ?? this.religion,
      caste: caste ?? this.caste,
      city: city ?? this.city,
      education: education ?? this.education,
      occupation: occupation ?? this.occupation,
      income: income ?? this.income,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      diet: diet ?? this.diet,
      manglik: manglik ?? this.manglik,
    );
  }

  Map<String, dynamic> toJson() => {
    'ageMin': ageMin,
    'ageMax': ageMax,
    'height': height,
    'religion': religion,
    'caste': caste,
    'city': city,
    'education': education,
    'occupation': occupation,
    'income': income,
    'maritalStatus': maritalStatus,
    'diet': diet,
    'manglik': manglik,
  };

  factory PartnerPreference.fromJson(Map<String, dynamic> json) => PartnerPreference(
    ageMin: json['ageMin'] ?? 22,
    ageMax: json['ageMax'] ?? 32,
    height: json['height'] ?? '5\'2" - 6\'0"',
    religion: json['religion'] ?? 'Hindu',
    caste: json['caste'] ?? 'Any',
    city: json['city'] ?? 'Pune',
    education: json['education'] ?? 'Bachelor\'s',
    occupation: json['occupation'] ?? 'Software Engineer',
    income: json['income'] ?? '5 LPA - 20 LPA',
    maritalStatus: json['maritalStatus'] ?? 'Never Married',
    diet: json['diet'] ?? 'Vegetarian',
    manglik: json['manglik'] ?? 'No',
  );
}

class PartnerPreferenceNotifier extends StateNotifier<PartnerPreference> {
  final Ref _ref;

  PartnerPreferenceNotifier(this._ref) : super(PartnerPreference()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);
      final response = await apiClient.get('/profile/me');
      final data = response.data['data']['profile']['partnerPreference'] as Map<String, dynamic>?;
      if (data != null) state = PartnerPreference.fromJson(data);
    } catch (_) {}
  }

  Future<void> save(PartnerPreference pref) async {
    state = pref;
    try {
      final apiClient = _ref.read(apiClientProvider);
      await apiClient.post('/profile/partner-preference', data: pref.toJson());
    } catch (_) {}
  }
}

final partnerPreferenceProvider = StateNotifierProvider<PartnerPreferenceNotifier, PartnerPreference>((ref) {
  return PartnerPreferenceNotifier(ref);
});
