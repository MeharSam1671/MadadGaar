import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClient {
  final String baseUrl;
  static SocketClient? _instance;
  io.Socket? _socket;

  SocketClient._internal({this.baseUrl = ''});

  factory SocketClient({String baseUrl = ''}) {
    _instance ??= SocketClient._internal(baseUrl: baseUrl);
    return _instance!;
  }

  Future<io.Socket> connect() async {
    if (_socket != null && _socket!.connected) {
      return _socket!;
    }

    final headers = await _getHeaders();

    _socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders(headers)
          .build(),
    );

    _socket!.onConnect((_) {
      if (kDebugMode) {
        print('Socket connected');
      }
    });

    _socket!.onDisconnect((_) {
      if (kDebugMode) {
        print('Socket disconnected');
      }
    });

    _socket!.onError((error) {
      if (kDebugMode) {
        print('Socket error: $error');
      }
    });

    return _socket!;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  Future<void> emit(String event, dynamic data) async {
    final socket = await connect();
    socket.emit(event, data);
  }

  Future<void> on(String event, Function(dynamic) callback) async {
    final socket = await connect();
    socket.on(event, callback);
  }

  Future<void> off(String event) async {
    if (_socket != null) {
      _socket!.off(event);
    }
  }

  bool get isConnected => _socket?.connected ?? false;

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final headers = <String, String>{};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<void> updateAuthToken() async {
    if (_socket != null && _socket!.connected) {
      disconnect();
      await connect();
    }
  }
}
