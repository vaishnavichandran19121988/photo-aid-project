import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final int sessionId;
  final int currentUserId; // 👈 your logged-in user ID
  final int otherUserId; // 👈 who you’re chatting with

  const ChatScreen({
    super.key,
    required this.sessionId,
    required this.currentUserId,
    required this.otherUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, dynamic>> messages = [];

  final String baseUrl = 'http://10.0.2.2:8080'; // for Android emulator

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    final res = await http.get(
      Uri.parse('$baseUrl/chats?session_id=${widget.sessionId}'),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        messages = List<Map<String, dynamic>>.from(data['messages']);
      });
    }
  }

  Future<void> sendMessage() async {
    final msg = _messageController.text.trim();
    if (msg.isEmpty) return;

    final res = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'session_id': widget.sessionId,
        'sender_id': widget.currentUserId,
        'receiver_id': widget.otherUserId,
        'message': msg,
      }),
    );

    if (res.statusCode == 200) {
      _messageController.clear();
      fetchMessages(); // refresh after sending
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['sender_id'] == widget.currentUserId;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue.shade100 : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(msg['message']),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
