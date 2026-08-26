import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/data/dummy_profiles.dart';
import 'home_controller.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/socket_service.dart';

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
  final String type;
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
      profileImage: json['profileImage'] ??
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
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
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;

  final String status;
  final DateTime? deliveredAt;
  final DateTime? readAt;

  MessageItem({
    required this.id,
    required this.senderId,
    this.receiverId = '',
    required this.text,
    required this.timestamp,
    this.status = 'sent',
    this.deliveredAt,
    this.readAt,
  });

  MessageItem copyWith({
    String? senderId,
    String? receiverId,
    String? text,
    DateTime? timestamp,
    String? status,
    DateTime? deliveredAt,
    DateTime? readAt,
  }) {
    return MessageItem(
      id: id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      readAt: readAt ?? this.readAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'deliveredAt': deliveredAt?.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
    };
  }

  factory MessageItem.fromJson(
      Map<String, dynamic> json,
      ) {
    return MessageItem(
      id: json['id'] ??
          json['_id'] ??
          'msg_${DateTime.now().millisecondsSinceEpoch}',

      senderId:
      json['senderId'] ?? 'me',

      receiverId:
      json['receiverId'] ?? '',

      text:
      json['text'] ??
          json['content'] ??
          '',

      timestamp:
      json['timestamp'] != null
          ? DateTime.tryParse(
        json['timestamp'].toString(),
      ) ??
          DateTime.now()
          : DateTime.now(),

      status:
      json['status'] ?? 'sent',

      deliveredAt:
      json['deliveredAt'] != null
          ? DateTime.tryParse(
        json['deliveredAt'].toString(),
      )
          : null,

      readAt:
      json['readAt'] != null
          ? DateTime.tryParse(
        json['readAt'].toString(),
      )
          : null,
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

  ConversationItem copyWith({
    List<MessageItem>? messages,
  }) {
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
      partnerAvatar: json['partnerAvatar'] ??
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
      messages: msgsJson
          .map((m) => MessageItem.fromJson(
        m as Map<String, dynamic>,
      ))
          .toList(),
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
      _ref
          .read(homeControllerProvider.notifier)
          .syncFavourites(state);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      final favs = prefs.getStringList('favourites');
      state = favs ?? [];
    }
  }


  Future<void> toggle(String id) async {
    final wasFavourite = state.contains(id);

    // 1. Optimistic local update
    final updated = List<String>.from(state);

    if (wasFavourite) {
      updated.remove(id);
    } else {
      updated.add(id);
    }

    state = updated;

    // 2. Send request to backend
    try {
      final apiClient = _ref.read(apiClientProvider);

      await apiClient.post('/favorites/$id/toggle');
      _ref.invalidate(favoriteProfilesProvider);

    } catch (error) {
      // 3. Backend failed → rollback to previous state
      final rollback = List<String>.from(state);

      if (wasFavourite) {
        // It was liked before → restore liked state
        if (!rollback.contains(id)) {
          rollback.add(id);
        }
      } else {
        // It was not liked before → restore unliked state
        rollback.remove(id);
      }

      state = rollback;
    }
  }
}

// ============================================================
// NOTIFICATION NOTIFIER
// ============================================================

class NotificationNotifier
    extends StateNotifier<List<NotificationItem>> {
  final Ref _ref;

  NotificationNotifier(this._ref) : super([]) {
    _load();
  }

  // ============================================================
  // LOAD NOTIFICATIONS
  // ============================================================

  Future<void> _load() async {
    try {
      final apiClient = _ref.read(apiClientProvider);

      final response =
      await apiClient.get('/notifications');

      final data = response.data['data'];

      if (data is! List) {
        debugPrint(
          'Notifications API returned invalid data',
        );

        state = [];
        return;
      }

      final notifications = data
          .map(
            (item) => NotificationItem.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();

      state = notifications;

      debugPrint(
        'NOTIFICATIONS LOADED: ${notifications.length}',
      );

      for (final notification in notifications) {
        debugPrint(
          'Notification => '
              'title=${notification.title}, '
              'type=${notification.type}, '
              'isRead=${notification.isRead}, '
              'profileId=${notification.profileId}',
        );
      }
    } catch (error, stackTrace) {
      debugPrint(
        'Notification load error: $error',
      );

      debugPrint(
        stackTrace.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await _load();
  }

  // ============================================================
  // MARK ONE AS READ
  // ============================================================

  Future<void> markAsRead(String id) async {
    try {
      final apiClient = _ref.read(apiClientProvider);

      final response = await apiClient.put(
        '/notifications/$id/read',
      );

      final data = response.data['data'];

      if (data is! List) {
        return;
      }

      state = data
          .map(
            (item) => NotificationItem.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();
    } catch (error) {
      debugPrint(
        'Mark notification as read error: $error',
      );

      state = state
          .map(
            (item) {
          if (item.id == id) {
            return item.copyWith(
              isRead: true,
            );
          }

          return item;
        },
      )
          .toList();
    }
  }

  // ============================================================
  // DELETE ONE NOTIFICATION
  // ============================================================

  Future<void> deleteNotification(String id) async {
    try {
      final apiClient = _ref.read(apiClientProvider);

      debugPrint(
        '[Notification] Deleting notification: $id',
      );

      final response = await apiClient.delete(
        '/notifications/$id',
      );

      debugPrint(
        '[Notification] Delete response: '
            '${response.statusCode}',
      );

      final data = response.data['data'];

      if (data is List) {
        state = data
            .map(
              (item) => NotificationItem.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
            .toList();
      } else {
        // Fallback: remove it locally if the backend
        // successfully deleted it but did not return a list.
        state = state
            .where((notification) => notification.id != id)
            .toList();
      }

      debugPrint(
        '[Notification] Deleted successfully: $id',
      );
    } catch (error, stackTrace) {
      debugPrint(
        '[Notification] Delete error: $error',
      );

      debugPrint(
        stackTrace.toString(),
      );

      rethrow;
    }
  }

  // ============================================================
  // MARK ALL AS READ
  // ============================================================

  Future<void> clearAllUnread() async {
    try {
      final apiClient = _ref.read(apiClientProvider);

      final response = await apiClient.put(
        '/notifications/read-all',
      );

      final data = response.data['data'];

      if (data is! List) {
        return;
      }

      state = data
          .map(
            (item) => NotificationItem.fromJson(
          Map<String, dynamic>.from(item),
        ),
      )
          .toList();
    } catch (error) {
      debugPrint(
        'Clear notifications error: $error',
      );

      state = state
          .map(
            (item) => item.copyWith(
          isRead: true,
        ),
      )
          .toList();
    }
  }

  // ============================================================
  // UNREAD COUNT
  // ============================================================

  int getUnreadCount() {
    return state
        .where(
          (item) => !item.isRead,
    )
        .length;
  }
}

// ============================================================
// MESSAGE NOTIFIER
// ============================================================
class MessageNotifier
    extends StateNotifier<List<ConversationItem>> {
  final Ref _ref;

  MessageNotifier(this._ref) : super([]) {
    _load();
    _initializeSocket();
  }

  // ============================================================
  // LOAD MESSAGE HISTORY
  // ============================================================

  Future<void> _load() async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.get(
        '/messages/conversations',
      );

      final list =
      response.data['data'] as List<dynamic>;

      state = list
          .map(
            (item) =>
            ConversationItem.fromJson(
              item as Map<String, dynamic>,
            ),
      )
          .toList();

      debugPrint(
        '[Messages] Conversations loaded: '
            '${state.length}',
      );
    } catch (error) {
      debugPrint(
        '[Messages] Load error: $error',
      );
    }
  }

  // ============================================================
  // INITIALIZE SOCKET
  // ============================================================

  Future<void> _initializeSocket() async {
    try {
      final socket =
      _ref.read(socketServiceProvider);

      await socket.connect();

      debugPrint(
        '[Messages] Socket connected',
      );

      // --------------------------------------------
      // NEW MESSAGE
      // --------------------------------------------

      socket.on(
        'newMessage',
        _handleNewMessage,
      );

      // --------------------------------------------
      // MESSAGE DELIVERED
      // --------------------------------------------

      socket.on(
        'messageDelivered',
        _handleMessageDelivered,
      );

      // --------------------------------------------
      // MESSAGE READ
      // --------------------------------------------

      socket.on(
        'messageRead',
        _handleMessageRead,
      );

    } catch (error) {
      debugPrint(
        '[Messages] Socket initialization error: $error',
      );
    }
  }

  // ============================================================
  // RECEIVE NEW MESSAGE
  // ============================================================

  void _handleNewMessage(dynamic data) {
    try {
      if (data is! Map) {
        return;
      }

      final messageData =
      Map<String, dynamic>.from(data);

      debugPrint(
        '[Messages] 📩 New message: $messageData',
      );

      final message =
      MessageItem.fromJson(
        messageData,
      );

      final senderId =
          message.senderId;

      // --------------------------------------------
      // Find conversation
      // --------------------------------------------

      final conversationIndex =
      state.indexWhere(
            (conversation) =>
        conversation.partnerId ==
            senderId,
      );

      // --------------------------------------------
      // Conversation doesn't exist
      // --------------------------------------------

      if (conversationIndex == -1) {
        state = [
          ...state,
          ConversationItem(
            partnerId: senderId,
            partnerName: 'Member',
            partnerAvatar:
            'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
            messages: [
              message,
            ],
          ),
        ];

        // ----------------------------------------
        // Mark received message as delivered
        // ----------------------------------------

        _markMessageDelivered(
          message.id,
        );

        return;
      }

      // --------------------------------------------
      // Add message to existing conversation
      // --------------------------------------------

      final conversation =
      state[conversationIndex];

      // Prevent duplicate message
      final alreadyExists =
      conversation.messages.any(
            (item) => item.id == message.id,
      );

      if (alreadyExists) {
        return;
      }

      final updatedMessages =
      List<MessageItem>.from(
        conversation.messages,
      )..add(message);

      final updatedConversation =
      conversation.copyWith(
        messages: updatedMessages,
      );

      final updatedState =
      List<ConversationItem>.from(
        state,
      );

      updatedState[conversationIndex] =
          updatedConversation;

      state = updatedState;

      // --------------------------------------------
      // Mark delivered
      // --------------------------------------------

      _markMessageDelivered(
        message.id,
      );

    } catch (error) {
      debugPrint(
        '[Messages] New message error: $error',
      );
    }
  }

  // ============================================================
  // MARK MESSAGE DELIVERED
  // ============================================================

  void _markMessageDelivered(
      String messageId,
      ) {
    final socket =
    _ref.read(socketServiceProvider);

    socket.emit(
      'messageDelivered',
      {
        'messageId': messageId,
      },
    );
  }

  // ============================================================
  // MESSAGE DELIVERED UPDATE
  // ============================================================

  void _handleMessageDelivered(
      dynamic data,
      ) {
    try {
      if (data is! Map) {
        return;
      }

      final update =
      Map<String, dynamic>.from(data);

      final messageId =
      update['messageId']?.toString();

      if (messageId == null) {
        return;
      }

      debugPrint(
        '[Messages] ✓✓ Delivered: $messageId',
      );

      _updateMessage(
        messageId,
            (message) {
          return message.copyWith(
            status:
            update['status'] ?? 'delivered',
            deliveredAt:
            update['deliveredAt'] != null
                ? DateTime.tryParse(
              update['deliveredAt']
                  .toString(),
            )
                : message.deliveredAt,
          );
        },
      );
    } catch (error) {
      debugPrint(
        '[Messages] Delivery update error: $error',
      );
    }
  }

  // ============================================================
  // MESSAGE READ UPDATE
  // ============================================================

  void _handleMessageRead(
      dynamic data,
      ) {
    try {
      if (data is! Map) {
        return;
      }

      final update =
      Map<String, dynamic>.from(data);

      final messageId =
      update['messageId']?.toString();

      if (messageId == null) {
        return;
      }

      debugPrint(
        '[Messages] 🔴✓✓ Read: $messageId',
      );

      _updateMessage(
        messageId,
            (message) {
          return message.copyWith(
            status:
            update['status'] ?? 'read',
            readAt:
            update['readAt'] != null
                ? DateTime.tryParse(
              update['readAt']
                  .toString(),
            )
                : message.readAt,
          );
        },
      );
    } catch (error) {
      debugPrint(
        '[Messages] Read update error: $error',
      );
    }
  }

  // ============================================================
  // UPDATE MESSAGE IN STATE
  // ============================================================

  void _updateMessage(
      String messageId,
      MessageItem Function(
          MessageItem,
          ) updater,
      ) {
    state = state.map(
          (conversation) {
        final containsMessage =
        conversation.messages.any(
              (message) =>
          message.id == messageId,
        );

        if (!containsMessage) {
          return conversation;
        }

        return conversation.copyWith(
          messages:
          conversation.messages.map(
                (message) {
              if (message.id == messageId) {
                return updater(message);
              }

              return message;
            },
          ).toList(),
        );
      },
    ).toList();
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> sendMessage(
      String partnerId,
      String text,
      ) async {
    if (text.trim().isEmpty) {
      return;
    }

    try {
      final socket =
      _ref.read(socketServiceProvider);

      // --------------------------------------------
      // Make sure socket is connected
      // --------------------------------------------

      if (!socket.isConnected) {
        await socket.connect();
      }

      if (!socket.isConnected) {
        debugPrint(
          '[Messages] Socket not connected',
        );
        return;
      }

      debugPrint(
        '[Messages] 📤 Sending message',
      );

      // --------------------------------------------
      // Send through Socket.IO
      // --------------------------------------------

      socket.socket!.emitWithAck(
        'sendMessage',
        {
          'receiverId': partnerId,
          'text': text.trim(),
        },
        ack: (response) {
          debugPrint(
            '[Messages] Server ACK: $response',
          );

          if (response is Map &&
              response['success'] == true) {
            final messageData =
            response['message'];

            if (messageData is Map) {
              _addOwnMessage(
                partnerId,
                Map<String, dynamic>.from(
                  messageData,
                ),
              );
            }
          }
        },
      );

    } catch (error) {
      debugPrint(
        '[Messages] Send error: $error',
      );
    }
  }

  // ============================================================
  // ADD OWN MESSAGE
  // ============================================================

  void _addOwnMessage(
      String partnerId,
      Map<String, dynamic> data,
      ) {
    final message =
    MessageItem.fromJson({
      ...data,
      'receiverId':
      data['receiverId'] ?? partnerId,
      'senderId':
      data['senderId'] ?? 'me',
      'status':
      data['status'] ?? 'sent',
    });

    final conversationIndex =
    state.indexWhere(
          (conversation) =>
      conversation.partnerId ==
          partnerId,
    );

    // --------------------------------------------
    // New conversation
    // --------------------------------------------

    if (conversationIndex == -1) {
      state = [
        ...state,
        ConversationItem(
          partnerId: partnerId,
          partnerName: 'Member',
          partnerAvatar:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=100',
          messages: [
            message,
          ],
        ),
      ];

      return;
    }

    // --------------------------------------------
    // Existing conversation
    // --------------------------------------------

    final conversation =
    state[conversationIndex];

    final alreadyExists =
    conversation.messages.any(
          (item) => item.id == message.id,
    );

    if (alreadyExists) {
      return;
    }

    final updatedMessages =
    List<MessageItem>.from(
      conversation.messages,
    )..add(message);

    final updatedState =
    List<ConversationItem>.from(
      state,
    );

    updatedState[conversationIndex] =
        conversation.copyWith(
          messages: updatedMessages,
        );

    state = updatedState;
  }

  // ============================================================
  // MARK MESSAGE AS READ
  // ============================================================

  void markMessageAsRead(
      String messageId,
      ) {
    final socket =
    _ref.read(socketServiceProvider);

    socket.emit(
      'messageRead',
      {
        'messageId': messageId,
      },
    );
  }
}

// ============================================================
// PROFILE VIEW STATE
// ============================================================

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
      viewerProfiles:
      viewerProfiles ?? this.viewerProfiles,
      isLoading:
      isLoading ?? this.isLoading,
    );
  }
}

// ============================================================
// PROFILE VIEW NOTIFIER
// ============================================================

class ProfileViewNotifier
    extends StateNotifier<ProfileViewState> {
  final Ref _ref;

  // ------------------------------------------------------------
  // Profiles currently being recorded.
  //
  // This prevents:
  //
  // POST /profile/views/id
  // POST /profile/views/id
  //
  // from happening simultaneously.
  // ------------------------------------------------------------

  final Set<String> _viewsInProgress = <String>{};

  ProfileViewNotifier(this._ref)
      : super(ProfileViewState()) {
    loadViews();
  }

  // ============================================================
  // LOAD PROFILE VIEWS
  // ============================================================

  Future<void> loadViews() async {
    debugPrint('==============================================');
    debugPrint('PROFILE VIEWS: LOAD STARTED');
    debugPrint('==============================================');

    state = state.copyWith(isLoading: true);

    try {
      final apiClient = _ref.read(apiClientProvider);

      debugPrint('[ProfileViews] Calling GET /profile/views');

      final response = await apiClient.get('/profile/views');

      debugPrint('[ProfileViews] STATUS: ${response.statusCode}');
      debugPrint('[ProfileViews] RAW RESPONSE: ${response.data}');

      final responseData = response.data;

      if (responseData is! Map<String, dynamic>) {
        debugPrint('[ProfileViews] ERROR: response is not a Map');
        return;
      }

      final data = responseData['data'];

      debugPrint('[ProfileViews] DATA: $data');

      if (data is! Map<String, dynamic>) {
        debugPrint('[ProfileViews] ERROR: data is not a Map');
        return;
      }

      final count = data['count'] is int
          ? data['count'] as int
          : int.tryParse(data['count']?.toString() ?? '') ?? 0;

      final viewsList = data['views'] is List
          ? data['views'] as List<dynamic>
          : <dynamic>[];

      debugPrint('[ProfileViews] COUNT: $count');
      debugPrint('[ProfileViews] VIEWS LENGTH: ${viewsList.length}');

      final List<MatrimonialProfile> profiles = [];

      for (int i = 0; i < viewsList.length; i++) {
        final item = viewsList[i];

        debugPrint('----------------------------------------------');
        debugPrint('[ProfileViews] VIEW #$i');
        debugPrint('RAW VIEW: $item');

        if (item is! Map) {
          debugPrint('[ProfileViews] SKIPPED: view is not a Map');
          continue;
        }

        final profileData = item['profile'];

        debugPrint('[ProfileViews] PROFILE RAW: $profileData');

        if (profileData == null) {
          debugPrint('[ProfileViews] SKIPPED: profile is null');
          continue;
        }

        if (profileData is! Map) {
          debugPrint('[ProfileViews] SKIPPED: profile is not a Map');
          continue;
        }

        final profileMap =
        Map<String, dynamic>.from(profileData);

        debugPrint(
          '[ProfileViews] PROFILE ID: '
              '${profileMap['_id'] ?? profileMap['id']}',
        );

        debugPrint(
          '[ProfileViews] PROFILE NAME: '
              '${profileMap['fullName'] ?? profileMap['name']}',
        );

        try {
          final profile =
          MatrimonialProfile.fromJson(profileMap);

          debugPrint(
            '[ProfileViews] PARSED ID: ${profile.id}',
          );

          debugPrint(
            '[ProfileViews] PARSED NAME: ${profile.fullName}',
          );

          profiles.add(profile);
        } catch (e, stackTrace) {
          debugPrint(
            '[ProfileViews] PROFILE PARSE ERROR: $e',
          );
          debugPrint('$stackTrace');
        }
      }

      debugPrint('==============================================');
      debugPrint('[ProfileViews] FINAL PROFILES: ${profiles.length}');

      for (final profile in profiles) {
        debugPrint(
          'PROFILE => id=${profile.id}, '
              'name=${profile.fullName}',
        );
      }

      debugPrint('==============================================');

      state = ProfileViewState(
        count: count,
        viewerProfiles: profiles,
        isLoading: false,
      );
    } catch (e, stackTrace) {
      debugPrint('==============================================');
      debugPrint('[ProfileViews] LOAD ERROR: $e');
      debugPrint('$stackTrace');
      debugPrint('==============================================');

      state = state.copyWith(isLoading: false);
    }
  }

  // ============================================================
  // RECORD PROFILE VIEW
  // ============================================================

  Future<void> recordView(
      String targetProfileId,
      ) async {
    // ----------------------------------------------------------
    // Validate ID
    // ----------------------------------------------------------

    final profileId =
    targetProfileId.trim();

    if (profileId.isEmpty) {
      debugPrint(
        'Profile view skipped: empty profile ID',
      );
      return;
    }

    // ----------------------------------------------------------
    // Prevent duplicate requests while one is already running.
    // ----------------------------------------------------------

    if (_viewsInProgress.contains(profileId)) {
      debugPrint(
        'Profile view skipped: already recording '
            'profile=$profileId',
      );
      return;
    }

    _viewsInProgress.add(profileId);

    try {
      debugPrint(
        'Recording profile view: profile=$profileId',
      );

      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.post(
        '/profile/views/$profileId',
      );

      debugPrint(
        'Profile view response: '
            '${response.statusCode} '
            'profile=$profileId',
      );
    } catch (error) {
      debugPrint(
        'Profile view error: '
            'profile=$profileId '
            'error=$error',
      );
    } finally {
      _viewsInProgress.remove(profileId);
    }
  }
}

// ==========================================
// PROVIDERS DEFINITIONS
// ==========================================

final favouriteProvider =
StateNotifierProvider<FavouriteNotifier, List<String>>(
      (ref) {
    return FavouriteNotifier(ref);
  },
);

final favoriteProfilesProvider =
FutureProvider<List<MatrimonialProfile>>(
      (ref) async {
    try {
      final apiClient =
      ref.watch(apiClientProvider);

      final response =
      await apiClient.get('/favorites/profiles');

      final list =
      response.data['data'] as List<dynamic>;

      return list
          .map(
            (e) => MatrimonialProfile.fromJson(
          Map<String, dynamic>.from(e),
        ),
      )
          .toList();
    } catch (_) {
      return [];
    }
  },
);

final notificationProvider =
StateNotifierProvider<
    NotificationNotifier,
    List<NotificationItem>>(
      (ref) {
    return NotificationNotifier(ref);
  },
);

final messageProvider =
StateNotifierProvider<
    MessageNotifier,
    List<ConversationItem>>(
      (ref) {
    return MessageNotifier(ref);
  },
);

final profileViewProvider =
StateNotifierProvider<
    ProfileViewNotifier,
    ProfileViewState>(
      (ref) {
    return ProfileViewNotifier(ref);
  },
);

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
      hidePhone:
      hidePhone ?? this.hidePhone,
      hideEmail:
      hideEmail ?? this.hideEmail,
      hidePhotos:
      hidePhotos ?? this.hidePhotos,
      hideIncome:
      hideIncome ?? this.hideIncome,
      hideLastSeen:
      hideLastSeen ?? this.hideLastSeen,
      hideOnlineStatus:
      hideOnlineStatus ??
          this.hideOnlineStatus,
      hideProfile:
      hideProfile ?? this.hideProfile,
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

  factory PrivacySettings.fromJson(
      Map<String, dynamic> json,
      ) =>
      PrivacySettings(
        hidePhone:
        json['hidePhone'] ?? false,
        hideEmail:
        json['hideEmail'] ?? false,
        hidePhotos:
        json['hidePhotos'] ?? false,
        hideIncome:
        json['hideIncome'] ?? false,
        hideLastSeen:
        json['hideLastSeen'] ?? false,
        hideOnlineStatus:
        json['hideOnlineStatus'] ?? false,
        hideProfile:
        json['hideProfile'] ?? false,
      );
}

class PrivacySettingsNotifier
    extends StateNotifier<PrivacySettings> {
  final Ref _ref;

  PrivacySettingsNotifier(this._ref)
      : super(PrivacySettings()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.get('/settings');

      final data = response.data['data']
      ['privacySettings'] as Map<String, dynamic>;

      state =
          PrivacySettings.fromJson(data);
    } catch (_) {}
  }

  Future<void> save(
      PrivacySettings settings,
      ) async {
    state = settings;

    try {
      final apiClient =
      _ref.read(apiClientProvider);

      await apiClient.put(
        '/settings/privacy',
        data: settings.toJson(),
      );
    } catch (_) {}
  }
}

final privacySettingsProvider =
StateNotifierProvider<
    PrivacySettingsNotifier,
    PrivacySettings>(
      (ref) {
    return PrivacySettingsNotifier(ref);
  },
);

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
      whatsapp:
      whatsapp ?? this.whatsapp,
    );
  }

  Map<String, dynamic> toJson() => {
    'push': push,
    'email': email,
    'whatsapp': whatsapp,
  };

  factory NotificationPrefs.fromJson(
      Map<String, dynamic> json,
      ) =>
      NotificationPrefs(
        push: json['push'] ?? true,
        email: json['email'] ?? true,
        whatsapp:
        json['whatsapp'] ?? false,
      );
}

class NotificationPrefsNotifier
    extends StateNotifier<NotificationPrefs> {
  final Ref _ref;

  NotificationPrefsNotifier(this._ref)
      : super(NotificationPrefs()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.get('/settings');

      final data = response.data['data']
      ['notificationPrefs'] as Map<String, dynamic>;

      state =
          NotificationPrefs.fromJson(data);
    } catch (_) {}
  }

  Future<void> save(
      NotificationPrefs prefsData,
      ) async {
    state = prefsData;

    try {
      final apiClient =
      _ref.read(apiClientProvider);

      await apiClient.put(
        '/settings/notifications',
        data: prefsData.toJson(),
      );
    } catch (_) {}
  }
}

final notificationPrefsProvider =
StateNotifierProvider<
    NotificationPrefsNotifier,
    NotificationPrefs>(
      (ref) {
    return NotificationPrefsNotifier(ref);
  },
);

class LanguageNotifier
    extends StateNotifier<String> {
  final Ref _ref;

  LanguageNotifier(this._ref)
      : super('English') {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.get('/settings');

      state =
          response.data['data']['language'] ??
              'English';
    } catch (_) {
      final prefs =
      await SharedPreferences.getInstance();

      state =
          prefs.getString('appLanguage') ??
              'English';
    }
  }

  Future<void> save(String lang) async {
    state = lang;

    try {
      final apiClient =
      _ref.read(apiClientProvider);

      await apiClient.put(
        '/settings/language',
        data: {
          'language': lang,
        },
      );
    } catch (_) {
      final prefs =
      await SharedPreferences.getInstance();

      await prefs.setString(
        'appLanguage',
        lang,
      );
    }
  }
}

final languageProvider =
StateNotifierProvider<
    LanguageNotifier,
    String>(
      (ref) {
    return LanguageNotifier(ref);
  },
);

class BlockedUsersNotifier
    extends StateNotifier<List<String>> {
  final Ref _ref;

  BlockedUsersNotifier(this._ref)
      : super([]) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.get('/blocked');

      final list =
      response.data['data'] as List<dynamic>;

      state =
          list.map((e) => e.toString()).toList();
    } catch (_) {}
  }

  Future<void> block(String id) async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.post('/blocked/$id');

      final list =
      response.data['data'] as List<dynamic>;

      state =
          list.map((e) => e.toString()).toList();
    } catch (_) {
      if (!state.contains(id)) {
        state = [
          ...state,
          id,
        ];
      }
    }
  }

  Future<void> unblock(String id) async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.delete('/blocked/$id');

      final list =
      response.data['data'] as List<dynamic>;

      state =
          list.map((e) => e.toString()).toList();
    } catch (_) {
      state = state
          .where(
            (item) => item != id,
      )
          .toList();
    }
  }
}

final blockedUsersProvider =
StateNotifierProvider<
    BlockedUsersNotifier,
    List<String>>(
      (ref) {
    return BlockedUsersNotifier(ref);
  },
);

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
      education:
      education ?? this.education,
      occupation:
      occupation ?? this.occupation,
      income: income ?? this.income,
      maritalStatus:
      maritalStatus ?? this.maritalStatus,
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

  factory PartnerPreference.fromJson(
      Map<String, dynamic> json,
      ) =>
      PartnerPreference(
        ageMin:
        json['ageMin'] ?? 22,
        ageMax:
        json['ageMax'] ?? 32,
        height:
        json['height'] ??
            '5\'2" - 6\'0"',
        religion:
        json['religion'] ?? 'Hindu',
        caste:
        json['caste'] ?? 'Any',
        city:
        json['city'] ?? 'Pune',
        education:
        json['education'] ??
            'Bachelor\'s',
        occupation:
        json['occupation'] ??
            'Software Engineer',
        income:
        json['income'] ??
            '5 LPA - 20 LPA',
        maritalStatus:
        json['maritalStatus'] ??
            'Never Married',
        diet:
        json['diet'] ??
            'Vegetarian',
        manglik:
        json['manglik'] ?? 'No',
      );
}

class PartnerPreferenceNotifier
    extends StateNotifier<PartnerPreference> {
  final Ref _ref;

  PartnerPreferenceNotifier(this._ref)
      : super(PartnerPreference()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final apiClient =
      _ref.read(apiClientProvider);

      final response =
      await apiClient.get('/profile/me');

      final data =
      response.data['data']['profile']
      ['partnerPreference']
      as Map<String, dynamic>?;

      if (data != null) {
        state =
            PartnerPreference.fromJson(data);
      }
    } catch (_) {}
  }

  Future<void> save(
      PartnerPreference pref,
      ) async {
    state = pref;

    try {
      final apiClient =
      _ref.read(apiClientProvider);

      await apiClient.post(
        '/profile/partner-preference',
        data: pref.toJson(),
      );
    } catch (_) {}
  }
}

final partnerPreferenceProvider =
StateNotifierProvider<
    PartnerPreferenceNotifier,
    PartnerPreference>(
      (ref) {
    return PartnerPreferenceNotifier(ref);
  },
);