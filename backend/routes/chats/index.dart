import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:backend/repositories/chat_repository_impl.dart';

final _repo = PgChatRepository();

Future<Response> onRequest(RequestContext context) async {
  final sessionId =
      int.tryParse(context.request.uri.queryParameters['session_id'] ?? '');
  if (sessionId == null) {
    return Response.json(
        statusCode: 400, body: {'error': 'Missing or invalid session_id'});
  }

  final messages = await _repo.getMessagesForSession(sessionId);
  return Response.json(body: {
    'messages': messages
        .map((m) => {
              'id': m.id,
              'session_id': m.sessionId,
              'sender_id': m.senderId,
              'receiver_id': m.receiverId,
              'message': m.message,
              'sent_at': m.sentAt.toIso8601String(),
            })
        .toList()
  });
}
