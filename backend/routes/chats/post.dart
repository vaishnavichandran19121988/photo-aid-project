import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:backend/repositories/chat_repository_impl.dart';

final _repo = PgChatRepository();

Future<Response> onRequest(RequestContext context) async {
  final body = await context.request.json();
  final sessionId = body['session_id'];
  final senderId = body['sender_id'];
  final receiverId = body['receiver_id'];
  final message = body['message'];

  if (sessionId == null ||
      senderId == null ||
      receiverId == null ||
      message == null) {
    return Response.json(statusCode: 400, body: {'error': 'Missing fields'});
  }

  await _repo.sendMessage(
    sessionId: sessionId,
    senderId: senderId,
    receiverId: receiverId,
    message: message,
  );

  return Response.json(body: {'message': 'Message sent'});
}
