import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../storage/secure_storage_service.dart';

class SocketService {
  IO.Socket? _socket;

  final SecureStorageService _secureStorage;

  SocketService(this._secureStorage);

  // ==================================================
  // GET SOCKET
  // ==================================================

  IO.Socket? get socket => _socket;

  // ==================================================
  // CHECK CONNECTION
  // ==================================================

  bool get isConnected =>
      _socket?.connected ?? false;

  // ==================================================
  // SOCKET SERVER URL
  // ==================================================

  String getSocketUrl() {
    // Flutter Web development
    return 'http://127.0.0.1:8000';
  }

  // ==================================================
  // CONNECT
  // ==================================================
  Future<void> connect() async {
    if (_socket?.connected == true) {
      debugPrint('[Socket] Already connected');
      return;
    }

    final token = await _secureStorage.getToken();

    debugPrint(
      '[Socket] JWT available: ${token != null && token.isNotEmpty}',
    );

    if (token == null || token.isEmpty) {
      debugPrint('[Socket] No JWT token found');
      return;
    }

    const socketUrl = 'http://127.0.0.1:8000';

    debugPrint('[Socket] Connecting to $socketUrl');

    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({
        'token': token,
      })
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(1000)
          .build(),
    );

    _socket!.onConnect((_) {
      debugPrint('================================');
      debugPrint('[Socket] 🟢 CONNECTED');
      debugPrint(
        '[Socket] Socket ID: ${_socket!.id}',
      );
      debugPrint('================================');
    });

    _socket!.onConnectError((error) {
      debugPrint('================================');
      debugPrint('[Socket] 🔴 CONNECTION ERROR');
      debugPrint('[Socket] $error');
      debugPrint('================================');
    });

    _socket!.onDisconnect((reason) {
      debugPrint(
        '[Socket] 🔴 Disconnected: $reason',
      );
    });

    _socket!.onError((error) {
      debugPrint(
        '[Socket] 🔴 Socket error: $error',
      );
    });

    debugPrint('[Socket] Starting socket.connect()...');

    _socket!.connect();

    debugPrint('[Socket] socket.connect() called');

    // Wait for the connection attempt to complete.
    try {
      await _waitForConnection();

      debugPrint(
        '[Socket] ✅ Connection process completed',
      );
    } catch (error) {
      debugPrint(
        '[Socket] ❌ Connection process failed: $error',
      );
    }
  }

  // ==================================================
  // WAIT FOR SOCKET CONNECTION
  // ==================================================

  Future<void> _waitForConnection() async {
    final socket = _socket;

    if (socket == null) {
      throw Exception(
        'Socket has not been initialized',
      );
    }

    if (socket.connected) {
      return;
    }

    final completer = Completer<void>();

    void handleConnect(dynamic _) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    void handleError(dynamic error) {
      if (!completer.isCompleted) {
        completer.completeError(error);
      }
    }

    socket.once(
      'connect',
      handleConnect,
    );

    socket.once(
      'connect_error',
      handleError,
    );

    try {
      await completer.future.timeout(
        const Duration(seconds: 10),
      );
    } finally {
      socket.off(
        'connect',
        handleConnect,
      );

      socket.off(
        'connect_error',
        handleError,
      );
    }
  }

  // ==================================================
  // DISCONNECT
  // ==================================================

  void disconnect() {
    if (_socket == null) {
      return;
    }

    debugPrint(
      '[Socket] Disconnecting...',
    );

    _socket!.disconnect();

    _socket!.dispose();

    _socket = null;
  }

  // ==================================================
  // EMIT EVENT
  // ==================================================

  void emit(
      String event, [
        dynamic data,
      ]) {
    if (!isConnected) {
      debugPrint(
        '[Socket] Cannot emit $event - not connected',
      );
      return;
    }

    debugPrint(
      '[Socket] Emit: $event',
    );

    _socket!.emit(
      event,
      data,
    );
  }

  // ==================================================
  // LISTEN TO EVENT
  // ==================================================

  void on(
      String event,
      Function(dynamic) callback,
      ) {
    debugPrint(
      '[Socket] Listening: $event',
    );

    _socket?.on(
      event,
      callback,
    );
  }

  // ==================================================
  // REMOVE EVENT LISTENER
  // ==================================================

  void off(
      String event, [
        Function(dynamic)? callback,
      ]) {
    if (callback != null) {
      _socket?.off(
        event,
        callback,
      );
    } else {
      _socket?.off(event);
    }
  }
}


// ==================================================
// RIVERPOD SOCKET PROVIDER
// ==================================================

final socketServiceProvider =
Provider<SocketService>((ref) {
  final secureStorage =
  ref.watch(
    secureStorageProvider,
  );

  final service =
  SocketService(
    secureStorage,
  );

  ref.onDispose(() {
    service.disconnect();
  });

  return service;
});