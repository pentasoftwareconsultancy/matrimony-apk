import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/data/dummy_profiles.dart';
import 'home_controller.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

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
  final String type; // 'match', 'interest', 'activity'
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
      id: json['id'],
      profileId: json['profileId'],
      profileImage: json['profileImage'],
      title: json['title'],
      subtitle: json['subtitle'],
      time: json['time'],
      type: json['type'],
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
      id: json['id'],
      senderId: json['senderId'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
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
      partnerId: json['partnerId'],
      partnerName: json['partnerName'],
      partnerAvatar: json['partnerAvatar'],
      messages: msgsJson.map((m) => MessageItem.fromJson(m)).toList(),
    );
  }
}

// ==========================================
// DUMMY GENERATORS
// ==========================================

List<NotificationItem> _generateDummyNotifications() {
  final list = <NotificationItem>[];

  // Interest updates
  list.add(NotificationItem(
    id: 'n_1',
    profileId: dummyProfiles[1].id,
    profileImage: dummyProfiles[1].photos.first,
    title: 'Interest Accepted — Sneha accepted your interest request!',
    subtitle: 'Tap to view details & respond.',
    time: '1 hr ago',
    type: 'interest',
  ));
  list.add(NotificationItem(
    id: 'n_2',
    profileId: dummyProfiles[2].id,
    profileImage: dummyProfiles[2].photos.first,
    title: 'Received Interest — Priya sent you an interest request!',
    subtitle: 'Tap to view details & respond.',
    time: '3 hrs ago',
    type: 'interest',
  ));

  // Profile views
  list.add(NotificationItem(
    id: 'n_3',
    profileId: dummyProfiles[3].id,
    profileImage: dummyProfiles[3].photos.first,
    title: 'Kavita Joshi (30, Architect) viewed your profile.',
    subtitle: 'Tap to view profile.',
    time: '2 hrs ago',
    type: 'views',
  ));
  list.add(NotificationItem(
    id: 'n_4',
    profileId: dummyProfiles[4].id,
    profileImage: dummyProfiles[4].photos.first,
    title: 'Anjali Rao (28, Doctor) checked your profile.',
    subtitle: 'Tap to view profile.',
    time: '5 hrs ago',
    type: 'views',
  ));

  // Match alert
  list.add(NotificationItem(
    id: 'n_5',
    profileId: dummyProfiles[0].id,
    profileImage: dummyProfiles[0].photos.first,
    title: 'You and Siya (89% match) both love travel & classical music!',
    subtitle: 'Tap to view details & respond.',
    time: '2 min ago',
    type: 'match',
  ));

  // Admin message
  list.add(NotificationItem(
    id: 'n_6',
    profileId: dummyProfiles[0].id,
    profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    title: 'Welcome Message from Admin',
    subtitle: 'Welcome to Soyrik Matrimony! Explore matching profiles and start communicating today.',
    time: '1 day ago',
    type: 'admin',
  ));

  // Verification status
  list.add(NotificationItem(
    id: 'n_7',
    profileId: dummyProfiles[0].id,
    profileImage: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
    title: 'Aadhaar Verification Status Successful',
    subtitle: 'Congratulations! Your profile has been verified successfully. A green badge is now visible on your card.',
    time: '2 days ago',
    type: 'verification',
  ));

  return list;
}

List<ConversationItem> _generateDummyConversations() {
  final conversations = <ConversationItem>[];
  
  for (int i = 0; i < 15; i++) {
    final p = dummyProfiles[i % dummyProfiles.length];
    final messages = <MessageItem>[];
    
    if (i == 0) {
      messages.addAll([
        MessageItem(id: 'msg_0_1', senderId: p.id, text: 'Hi Anmol, I liked your profile.', timestamp: DateTime.now().subtract(const Duration(hours: 5))),
        MessageItem(id: 'msg_0_2', senderId: 'me', text: 'Hello Riya! Thank you. I liked yours too.', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
        MessageItem(id: 'msg_0_3', senderId: p.id, text: 'Great! Are you open to relocating to Pune?', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
        MessageItem(id: 'msg_0_4', senderId: 'me', text: 'Yes, Pune works perfectly for me.', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
        MessageItem(id: 'msg_0_5', senderId: p.id, text: 'Awesome! Let\'s chat here.', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
        MessageItem(id: 'msg_0_6', senderId: 'me', text: 'Sure, tell me more about your family.', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
      ]);
    } else if (i == 1) {
      messages.addAll([
        MessageItem(id: 'msg_1_1', senderId: p.id, text: 'Hello, are you open to connect?', timestamp: DateTime.now().subtract(const Duration(hours: 8))),
        MessageItem(id: 'msg_1_2', senderId: 'me', text: 'Yes, sure! Tell me about yourself.', timestamp: DateTime.now().subtract(const Duration(hours: 7))),
        MessageItem(id: 'msg_1_3', senderId: p.id, text: 'I am a software engineer in Pune.', timestamp: DateTime.now().subtract(const Duration(hours: 6))),
        MessageItem(id: 'msg_1_4', senderId: 'me', text: 'Nice, me too!', timestamp: DateTime.now().subtract(const Duration(hours: 5))),
        MessageItem(id: 'msg_1_5', senderId: p.id, text: 'Let\'s connect on WhatsApp.', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
      ]);
    } else if (i == 2) {
      messages.addAll([
        MessageItem(id: 'msg_2_1', senderId: p.id, text: 'Hi, nice meeting you.', timestamp: DateTime.now().subtract(const Duration(hours: 12))),
        MessageItem(id: 'msg_2_2', senderId: 'me', text: 'Likewise, how is your day?', timestamp: DateTime.now().subtract(const Duration(hours: 11))),
        MessageItem(id: 'msg_2_3', senderId: p.id, text: 'Busy with work, what about you?', timestamp: DateTime.now().subtract(const Duration(hours: 10))),
        MessageItem(id: 'msg_2_4', senderId: 'me', text: 'Just wrapping up coding.', timestamp: DateTime.now().subtract(const Duration(hours: 9))),
      ]);
    } else if (i == 3) {
      messages.addAll([
        MessageItem(id: 'msg_3_1', senderId: p.id, text: 'Hey there!', timestamp: DateTime.now().subtract(const Duration(hours: 24))),
        MessageItem(id: 'msg_3_2', senderId: 'me', text: 'Hello, how can I help you?', timestamp: DateTime.now().subtract(const Duration(hours: 23))),
        MessageItem(id: 'msg_3_3', senderId: p.id, text: 'Just wanted to say hi.', timestamp: DateTime.now().subtract(const Duration(hours: 22))),
      ]);
    } else if (i == 4) {
      messages.addAll([
        MessageItem(id: 'msg_4_1', senderId: p.id, text: 'Hi, liked your profile details.', timestamp: DateTime.now().subtract(const Duration(days: 2))),
        MessageItem(id: 'msg_4_2', senderId: 'me', text: 'Thanks! Let me know if you want to connect.', timestamp: DateTime.now().subtract(const Duration(days: 1))),
        MessageItem(id: 'msg_4_3', senderId: p.id, text: 'Yes, sure.', timestamp: DateTime.now().subtract(const Duration(hours: 15))),
      ]);
    } else if (i < 12) {
      messages.addAll([
        MessageItem(id: 'msg_${i}_1', senderId: p.id, text: 'Hello!', timestamp: DateTime.now().subtract(const Duration(days: 3))),
        MessageItem(id: 'msg_${i}_2', senderId: 'me', text: 'Hi, nice to connect with you.', timestamp: DateTime.now().subtract(const Duration(days: 2))),
      ]);
    } else {
      messages.add(
        MessageItem(id: 'msg_${i}_1', senderId: p.id, text: 'Hi, would love to connect!', timestamp: DateTime.now().subtract(const Duration(days: 4))),
      );
      if (i == 13 || i == 14) {
        messages.add(
          MessageItem(id: 'msg_${i}_2', senderId: 'me', text: 'Hello! I accepted your request.', timestamp: DateTime.now().subtract(const Duration(days: 3))),
        );
      }
    }

    conversations.add(ConversationItem(
      partnerId: p.id,
      partnerName: p.fullName,
      partnerAvatar: p.photos.first,
      messages: messages,
    ));
  }
  return conversations;
}

// ==========================================
// STATE NOTIFIERS
// ==========================================

class FavouriteNotifier extends StateNotifier<List<String>> {
  final Ref _ref;

  FavouriteNotifier(this._ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList('favourites');
    if (favs != null) {
      state = favs;
    } else {
      // Mock pre-populated likes
      final defaultLikes = [dummyProfiles[0].id, dummyProfiles[1].id, dummyProfiles[2].id];
      state = defaultLikes;
      await prefs.setStringList('favourites', defaultLikes);
    }
  }

  Future<void> toggle(String id) async {
    final updated = List<String>.from(state);
    if (updated.contains(id)) {
      updated.remove(id);
    } else {
      updated.add(id);
    }
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favourites', updated);
    
    // Sync back to homeController
    _ref.read(homeControllerProvider.notifier).syncFavourites(updated);
  }
}

class NotificationNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = prefs.getString('notifications');
    if (listJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(listJson);
        state = decoded.map((item) => NotificationItem.fromJson(item)).toList();
      } catch (_) {
        _initDummy();
      }
    } else {
      _initDummy();
    }
  }

  Future<void> _initDummy() async {
    state = _generateDummyNotifications();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = jsonEncode(state.map((item) => item.toJson()).toList());
    await prefs.setString('notifications', listJson);
  }

  Future<void> markAsRead(String id) async {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(isRead: true);
      }
      return item;
    }).toList();
    await _save();
  }

  Future<void> clearAllUnread() async {
    state = state.map((item) => item.copyWith(isRead: true)).toList();
    await _save();
  }

  int getUnreadCount() {
    return state.where((item) => !item.isRead).length;
  }
}

class MessageNotifier extends StateNotifier<List<ConversationItem>> {
  MessageNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = prefs.getString('conversations');
    if (listJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(listJson);
        state = decoded.map((item) => ConversationItem.fromJson(item)).toList();
      } catch (_) {
        _initDummy();
      }
    } else {
      _initDummy();
    }
  }

  Future<void> _initDummy() async {
    state = _generateDummyConversations();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final listJson = jsonEncode(state.map((item) => item.toJson()).toList());
    await prefs.setString('conversations', listJson);
  }

  Future<void> sendMessage(String partnerId, String text) async {
    final exists = state.any((c) => c.partnerId == partnerId);
    if (!exists) {
      final profile = dummyProfiles.firstWhere(
        (p) => 'dummy_${p.fullName.hashCode}' == partnerId || p.id == partnerId,
        orElse: () => dummyProfiles.first,
      );
      state = [
        ...state,
        ConversationItem(
          partnerId: partnerId,
          partnerName: profile.fullName,
          partnerAvatar: profile.photos.first,
          messages: [],
        )
      ];
    }

    state = state.map((c) {
      if (c.partnerId == partnerId) {
        final updatedMsgs = List<MessageItem>.from(c.messages)
          ..add(MessageItem(
            id: 'msg_user_${DateTime.now().millisecondsSinceEpoch}',
            senderId: 'me',
            text: text,
            timestamp: DateTime.now(),
          ));
        return c.copyWith(messages: updatedMsgs);
      }
      return c;
    }).toList();
    await _save();

    // Trigger simulated reply after 1.2 seconds
    Future.delayed(const Duration(milliseconds: 1200), () async {
      state = state.map((c) {
        if (c.partnerId == partnerId) {
          final updatedMsgs = List<MessageItem>.from(c.messages)
            ..add(MessageItem(
              id: 'msg_reply_${DateTime.now().millisecondsSinceEpoch}',
              senderId: partnerId,
              text: 'Hey! Thanks for messaging. I really like your background too.',
              timestamp: DateTime.now(),
            ));
          return c.copyWith(messages: updatedMsgs);
        }
        return c;
      }).toList();
      await _save();
    });
  }
}

class ProfileViewNotifier extends StateNotifier<List<String>> {
  final Ref _ref;

  ProfileViewNotifier(this._ref) : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final views = prefs.getStringList('viewedProfileIds');
    if (views != null) {
      state = views;
    } else {
      // Prepopulate view history with first 6 profiles to match "13 viewed" layout mockup
      final initialViews = List.generate(6, (i) => dummyProfiles[i].id);
      state = initialViews;
      await prefs.setStringList('viewedProfileIds', initialViews);
    }
  }

  Future<void> addView(String id) async {
    final updated = List<String>.from(state);
    updated.remove(id);
    updated.insert(0, id);
    state = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('viewedProfileIds', updated);
    
    // Sync with homeController
    _ref.read(homeControllerProvider.notifier).syncViews(updated);
  }
}

// ==========================================
// PROVIDERS DEFINITIONS
// ==========================================

final favouriteProvider = StateNotifierProvider<FavouriteNotifier, List<String>>((ref) {
  return FavouriteNotifier(ref);
});

final notificationProvider = StateNotifierProvider<NotificationNotifier, List<NotificationItem>>((ref) {
  return NotificationNotifier();
});

final messageProvider = StateNotifierProvider<MessageNotifier, List<ConversationItem>>((ref) {
  return MessageNotifier();
});

final profileViewProvider = StateNotifierProvider<ProfileViewNotifier, List<String>>((ref) {
  return ProfileViewNotifier(ref);
});

final homeProvider = homeControllerProvider;

// ==========================================
// NEW SETTINGS MODELS & PROVIDERS
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
  PrivacySettingsNotifier() : super(PrivacySettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('privacySettings');
    if (jsonStr != null) {
      try {
        state = PrivacySettings.fromJson(jsonDecode(jsonStr));
      } catch (_) {}
    }
  }

  Future<void> save(PrivacySettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('privacySettings', jsonEncode(settings.toJson()));
  }
}

final privacySettingsProvider = StateNotifierProvider<PrivacySettingsNotifier, PrivacySettings>((ref) {
  return PrivacySettingsNotifier();
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
  NotificationPrefsNotifier() : super(NotificationPrefs()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('notificationPrefs');
    if (jsonStr != null) {
      try {
        state = NotificationPrefs.fromJson(jsonDecode(jsonStr));
      } catch (_) {}
    }
  }

  Future<void> save(NotificationPrefs prefsData) async {
    state = prefsData;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notificationPrefs', jsonEncode(prefsData.toJson()));
  }
}

final notificationPrefsProvider = StateNotifierProvider<NotificationPrefsNotifier, NotificationPrefs>((ref) {
  return NotificationPrefsNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('English') {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('appLanguage') ?? 'English';
  }

  Future<void> save(String lang) async {
    state = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appLanguage', lang);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class BlockedUsersNotifier extends StateNotifier<List<String>> {
  BlockedUsersNotifier() : super([]) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('blockedUsers');
    if (list != null) {
      state = list;
    } else {
      final defaultBlocked = ['p7', 'p8'];
      state = defaultBlocked;
      await prefs.setStringList('blockedUsers', defaultBlocked);
    }
  }

  Future<void> block(String id) async {
    if (!state.contains(id)) {
      state = [...state, id];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('blockedUsers', state);
    }
  }

  Future<void> unblock(String id) async {
    state = state.where((item) => item != id).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('blockedUsers', state);
  }
}

final blockedUsersProvider = StateNotifierProvider<BlockedUsersNotifier, List<String>>((ref) {
  return BlockedUsersNotifier();
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
  PartnerPreferenceNotifier() : super(PartnerPreference()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('partnerPreference');
    if (jsonStr != null) {
      try {
        state = PartnerPreference.fromJson(jsonDecode(jsonStr));
      } catch (_) {}
    }
  }

  Future<void> save(PartnerPreference prefsData) async {
    state = prefsData;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('partnerPreference', jsonEncode(prefsData.toJson()));
  }
}

final partnerPreferenceProvider = StateNotifierProvider<PartnerPreferenceNotifier, PartnerPreference>((ref) {
  return PartnerPreferenceNotifier();
});

// Dynamic Profile score calculation
final profileCompletionProvider = Provider<int>((ref) {
  final authState = ref.watch(authControllerProvider);
  final partnerPref = ref.watch(partnerPreferenceProvider);
  final user = authState.user;
  if (user == null) return 0;

  int score = 0;

  // 1. Photo: 10%
  if (user.photos != null && user.photos!.isNotEmpty) {
    score += 10;
  }

  // 2. Personal Details: 20%
  if (user.fullName != null && user.fullName!.isNotEmpty &&
      user.gender != null && user.dob != null &&
      user.religion != null && user.religion!.isNotEmpty) {
    score += 20;
  }

  // 3. Professional Details: 20%
  if (user.qualification != null && user.qualification!.isNotEmpty &&
      user.occupation != null && user.occupation!.isNotEmpty &&
      user.annualIncome != null && user.annualIncome!.isNotEmpty) {
    score += 20;
  }

  // 4. Documents: 20%
  if (user.aadharNumber != null && user.aadharNumber!.isNotEmpty) {
    score += 20;
  }

  // 5. Partner Preference: 20%
  if (partnerPref.religion.isNotEmpty && partnerPref.caste.isNotEmpty) {
    score += 20;
  }

  // 6. Verification: 10%
  if (user.isVerified) {
    score += 10;
  }

  return score;
});
