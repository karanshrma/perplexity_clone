import 'dart:async';
import 'dart:convert';
import 'package:web_socket_client/web_socket_client.dart';

class ChatWebService {
  static final _instance = ChatWebService._internal();
  WebSocket? _socket;

  factory ChatWebService() => _instance;

  ChatWebService._internal();

  final _searchResultController = StreamController<Map<String, dynamic>>();
  final _contentController = StreamController<Map<String, dynamic>>();

  Stream<Map<String, dynamic>> get searchResultStream =>
      _searchResultController.stream;

  Stream<Map<String, dynamic>> get contentStream => _contentController.stream;

  void connect() {
    print('[DEBUG] Attempting to connect to WebSocket...');
    _socket = WebSocket(Uri.parse("ws://192.168.1.11:8001/ws/chat"));

    _socket!.messages.listen((message) {
      print('[DEBUG] Received raw message: $message');

      try {
        final data = json.decode(message);
        print('[DEBUG] Decoded message: $data');

        if (data['type'] == 'search_result') {
          print('[DEBUG] Adding to searchResultStream');
          _searchResultController.add(data);
        } else if (data['type'] == 'content') {
          print('[DEBUG] Adding to contentStream');
          _contentController.add(data);
        } else {
          print('[DEBUG] Unknown message type: ${data['type']}');
        }
      } catch (e) {
        print('[ERROR] Failed to decode message: $e');
      }
    }, onDone: () {
      print('[DEBUG] WebSocket connection closed');
    }, onError: (error) {
      print('[ERROR] WebSocket error: $error');
    });

    print('[DEBUG] WebSocket connection initialized');
  }

  void chat(String query) {
    print('[DEBUG] Sending chat query: $query');
    if (_socket == null) {
      print('[ERROR] Socket is not connected!');
      return;
    }

    try {
      final message = json.encode({'query': query});
      print('[DEBUG] Encoded message: $message');
      _socket!.send(message);
      print('[DEBUG] Message sent successfully');
    } catch (e) {
      print('[ERROR] Failed to send message: $e');
    }
  }
}
