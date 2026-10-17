import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/socket_service.dart';

class UserPresence {
  final String userId;
  final bool isOnline;
  final DateTime? lastSeenAt;

  const UserPresence({
    required this.userId,
    required this.isOnline,
    this.lastSeenAt,
  });

  UserPresence copyWith({
    bool? isOnline,
    DateTime? lastSeenAt,
  }) {
    return UserPresence(
      userId: userId,
      isOnline: isOnline ?? this.isOnline,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }
}

class PresenceNotifier
    extends StateNotifier<Map<String, UserPresence>> {
  final Ref _ref;

  PresenceNotifier(this._ref) : super({}) {
    _initialize();
  }

  // ============================================================
  // INITIALIZE SOCKET PRESENCE
  // ============================================================

  Future<void> _initialize() async {
    try {
      final socket =
      _ref.read(socketServiceProvider);

      await socket.connect();

      debugPrint(
        '[Presence] Socket connected',
      );

      // --------------------------------------------------------
      // USER ONLINE
      // --------------------------------------------------------

      socket.on(
        'userOnline',
        _handleUserOnline,
      );

      // --------------------------------------------------------
      // USER OFFLINE
      // --------------------------------------------------------

      socket.on(
        'userOffline',
        _handleUserOffline,
      );
    } catch (error) {
      debugPrint(
        '[Presence] Socket initialization error: $error',
      );
    }
  }

  // ============================================================
  // GET CURRENT PRESENCE FROM REST API
  // ============================================================

  Future<void> loadPresence(
      String userId,
      ) async {
    if (userId.isEmpty) {
      return;
    }

    try {
      final apiClient =
      _ref.read(apiClientProvider);

      debugPrint(
        '[Presence] Checking presence for $userId',
      );

      final response =
      await apiClient.get(
        '/messages/presence/$userId',
      );

      final data =
      response.data['data'];

      if (data == null) {
        debugPrint(
          '[Presence] No presence data returned',
        );
        return;
      }

      final presence =
      _parsePresence(
        Map<String, dynamic>.from(data),
      );

      state = {
        ...state,
        userId: presence,
      };

      debugPrint(
        '[Presence] REST result: '
            'online=${presence.isOnline}, '
            'lastSeen=${presence.lastSeenAt}',
      );
    } catch (error) {
      debugPrint(
        '[Presence] REST error: $error',
      );
    }
  }

  // ============================================================
  // PARSE PRESENCE
  // ============================================================

  UserPresence _parsePresence(
      Map<String, dynamic> data,
      ) {
    DateTime? lastSeenAt;

    final rawLastSeen =
    data['lastSeenAt'];

    if (rawLastSeen != null) {
      lastSeenAt =
          DateTime.tryParse(
            rawLastSeen.toString(),
          );
    }

    return UserPresence(
      userId:
      data['userId']?.toString() ?? '',
      isOnline:
      data['isOnline'] == true,
      lastSeenAt:
      lastSeenAt,
    );
  }

  // ============================================================
  // USER ONLINE EVENT
  // ============================================================

  void _handleUserOnline(
      dynamic data,
      ) {
    if (data is! Map) {
      return;
    }

    final userId =
    data['userId']?.toString();

    if (userId == null ||
        userId.isEmpty) {
      return;
    }

    final previous =
    state[userId];

    state = {
      ...state,
      userId: UserPresence(
        userId: userId,
        isOnline: true,

        // Keep previous last-seen timestamp.
        lastSeenAt:
        previous?.lastSeenAt,
      ),
    };

    debugPrint(
      '[Presence] 🟢 $userId is ONLINE',
    );
  }

  // ============================================================
  // USER OFFLINE EVENT
  // ============================================================

  void _handleUserOffline(
      dynamic data,
      ) {
    if (data is! Map) {
      return;
    }

    final userId =
    data['userId']?.toString();

    if (userId == null ||
        userId.isEmpty) {
      return;
    }

    DateTime? lastSeenAt;

    final rawLastSeen =
    data['lastSeenAt'];

    if (rawLastSeen != null) {
      lastSeenAt =
          DateTime.tryParse(
            rawLastSeen.toString(),
          );
    }

    // If socket event doesn't contain a
    // timestamp, preserve the existing one.
    lastSeenAt ??=
        state[userId]?.lastSeenAt;

    state = {
      ...state,
      userId: UserPresence(
        userId: userId,
        isOnline: false,
        lastSeenAt: lastSeenAt,
      ),
    };

    debugPrint(
      '[Presence] 🔴 $userId is OFFLINE',
    );

    debugPrint(
      '[Presence] Last seen: $lastSeenAt',
    );
  }

  // ============================================================
  // GET PRESENCE FROM STATE
  // ============================================================

  UserPresence? getPresence(
      String userId,
      ) {
    return state[userId];
  }

  // ============================================================
  // CLEANUP
  // ============================================================

  @override
  void dispose() {
    final socket =
    _ref.read(socketServiceProvider);

    socket.off(
      'userOnline',
      _handleUserOnline,
    );

    socket.off(
      'userOffline',
      _handleUserOffline,
    );

    super.dispose();
  }
}

// ============================================================
// PROVIDER
// ============================================================

final presenceProvider =
StateNotifierProvider<
    PresenceNotifier,
    Map<String, UserPresence>>(
      (ref) {
    return PresenceNotifier(ref);
  },
);