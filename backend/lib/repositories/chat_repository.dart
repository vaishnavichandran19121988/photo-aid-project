import 'package:dart_frog/dart_frog.dart'; // for Sql.named()
import 'package:backend/models/chat_model.dart'; // for ChatMessage
import 'package:backend/db_connection.dart'; // for withDb()
import 'package:postgres/postgres.dart';

abstract class ChatRepository {
  Future<void> sendMessage({
    required int sessionId,
    required int senderId,
    required int receiverId,
    required String message,
  });

  Future<List<ChatMessage>> getMessagesForSession(int sessionId);
}
