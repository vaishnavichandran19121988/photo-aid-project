import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:backend/repositories/session_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.post:
      return onPost(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

/// POST /api/sessions — Create a new session request
/// Uses Dart Frog's onPost to avoid manual HTTP method checks.
Future<Response> onPost(RequestContext context) async {
  // 1️ Parse and validate JSON body
  final body = await context.request.json() as Map<String, dynamic>;
  final senderId = body['sender_id'] as int?;
  final receiverId = body['receiver_id'] as int?;

  if (senderId == null ||
      senderId <= 0 ||
      receiverId == null ||
      receiverId <= 0) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Missing or invalid sender_id/receiver_id'},
    );
  }

  // 2️ Delegate creation to repository, scoping DB call in try/catch
  final repo = SessionRepository(() => context.read());
  try {
    final newSessionId = await repo.create(senderId, receiverId);
    // 3️ Return created resource ID
    return Response.json(
      statusCode: HttpStatus.created,
      body: {'session_id': newSessionId},
    );
  } catch (e) {
    // 4️ Log error details for debugging
    print('Error creating session: \$e\n\$st');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error creating session'},
    );
  }
}
