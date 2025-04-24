import 'package:backend/models/chat_model.dart';
import 'package:backend/db_connection.dart';
import 'package:backend/repositories/chat_repository.dart';
import 'package:dart_frog/dart_frog.dart'; // ✅ this provides Sql.named()
import 'package:postgres/postgres.dart';

class PgChatRepository implements ChatRepository {
  @override
  Future<void> sendMessage({
    required int sessionId,
    required int senderId,
    required int receiverId,
    required String message,
  }) async {
    await withDb((conn) async {
      await conn.execute(
        Sql.named('''
          INSERT INTO chats (session_id, sender_id, receiver_id, message)
          VALUES (@session_id, @sender_id, @receiver_id, @message)
        '''),
        parameters: {
          'session_id': sessionId,
          'sender_id': senderId,
          'receiver_id': receiverId,
          'message': message,
        },
      );
    });
  }

  @override
  Future<List<ChatMessage>> getMessagesForSession(int sessionId) async {
    return await withDb((conn) async {
      final result = await conn.execute(
        Sql.named(
            'SELECT * FROM chats WHERE session_id = @session_id ORDER BY sent_at ASC'),
        parameters: {'session_id': sessionId},
      );

      return result
          .map((row) => ChatMessage.fromMap(row.toColumnMap()))
          .toList();
    });
  }
}
