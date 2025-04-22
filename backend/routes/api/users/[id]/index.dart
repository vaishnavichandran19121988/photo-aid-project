import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:backend/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return onGet(context, id);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}
/// GET /api/users/:id
/// Uses Dart Frog's onGet to avoid manual method checks.
Future<Response> onGet(RequestContext context, String id) async {
  // 1️Validate path parameter (must be positive integer)
  final userId = int.tryParse(id);
  if (userId == null || userId <= 0) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid user ID'},
    );
  }

  // 2️ Fetch user, scoping only the DB call in try/catch
  final repo = UserRepository(() => context.read());
  try {
    final user = await repo.fetchById(userId);
    if (user == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'User not found'},
      );
    }
    // 3️ Return JSON using model.toJson()
    return Response.json(body: {'user': user.toJson()});
  } catch (e) {
    // 4️ Log error (use your logger in real code) and return 500
    print('Error fetching user: \$e\n\$st');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error fetching user'},
    );
  }
}
