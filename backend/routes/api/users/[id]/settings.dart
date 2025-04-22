import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:backend/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.put:
      return onPut(context, id);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

/// PUT /api/users/settings
Future<Response> onPut(RequestContext context, String id) async {
  // 1️ Parse and validate body
  final body = await context.request.json() as Map<String, dynamic>;
  final userId = body['user_id'] as int?;
  final prefs = body['preferences'] as Map<String, dynamic>?;
  if (userId == null || userId <= 0 || prefs == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Missing or invalid settings payload'},
    );
  }

  // 2️ Save settings in a try/catch
  final repo = UserRepository(() => context.read());
  try {
    await repo.saveSettings(userId, prefs);
    // 3️ Return success (204 No Content could also be used)
    return Response.json(body: {'ok': true});
  } catch (e) {
    print('Error saving settings: \$e\n\$st');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error saving settings'},
    );
  }
}
