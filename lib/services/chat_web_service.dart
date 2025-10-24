import 'dart:async';
import 'dart:convert';
import 'package:web_socket_client/web_socket_client.dart';

import '../model/search_result.dart';

class ChatWebService {
  static final _instance = ChatWebService._internal();
  WebSocket? _socket;

  factory ChatWebService() => _instance;

  ChatWebService._internal();

  final _searchResultController = StreamController<List<SearchResult>>.broadcast();
  final _contentController = StreamController<String>.broadcast();

  Stream<List<SearchResult>> get searchResultStream => _searchResultController.stream;
  Stream<String> get contentStream => _contentController.stream;

  void connect() {
    _socket = WebSocket(Uri.parse("ws://192.168.1.11:8001/ws/chat"));

    _socket!.messages.listen((message) {
      try {
        final data = json.decode(message);

        if (data['type'] == 'search_result') {
          final results = (data['data'] as List)
              .map((e) => SearchResult.fromJson(e))
              .toList();
          _searchResultController.add(results);
        } else if (data['type'] == 'content') {
          _contentController.add(data['data']);
        }
      } catch (e) {
        print('[ERROR] Failed to decode message: $e');
      }
    });
  }

  void chat(String query) {
    if (_socket == null) return;
    final message = json.encode({'query': query});
    _socket!.send(message);
  }
}

