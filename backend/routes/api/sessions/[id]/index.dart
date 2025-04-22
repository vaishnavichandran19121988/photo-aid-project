import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:backend/repositories/session_repository.dart';

/// Handle all requests to this route
Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return onPut(context, id);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

/// PUT /api/sessions/:id — Accept or reject a session request
Future<Response> onPut(RequestContext context, String id) async {
  // 1️ Validate path parameter (session ID must be positive integer)
  final sessionId = int.tryParse(id);
  if (sessionId == null || sessionId <= 0) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid session ID'},
    );
  }

  // 2️ Parse and validate JSON body
  final body = await context.request.json() as Map<String, dynamic>;
  final newStatus = (body['status'] as String?)?.trim();
  const allowedStatuses = {'pending', 'accepted', 'completed', 'cancelled'};
  if (newStatus == null || !allowedStatuses.contains(newStatus)) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': r'Status must be one of $allowedStatuses'},
    );
  }

  // 3️ Delegate update to repository in try/catch
  final repo = SessionRepository(() => context.read());
  try {
    final updatedCount = await repo.updateStatus(sessionId, newStatus);
    if (updatedCount == 0) {
      // 4️ Handle not-found case
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Session not found'},
      );
    }
    // 5️ Return number of rows updated
    return Response.json(body: {'updated': updatedCount});
  } catch (e) {
    print('Error updating session status: \$e\n\$st');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error updating session'},
    );
  }
}
