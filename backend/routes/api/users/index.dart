import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:backend/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return onGet(context);
    case HttpMethod.post:
      return onPost(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

/// GET /api/users
Future<Response> onGet(RequestContext context) async {
  final repo = UserRepository(() => context.read());
  try {
    final users = await repo.fetchAll();
    // map models to JSON
    final data = users.map((u) => u.toJson()).toList();
    return Response.json(body: {'users': data});
  } catch (e) {
    print('Error fetching users: \$e\n\$st');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error fetching users'},
    );
  }
}

/// POST /api/users
Future<Response> onPost(RequestContext context) async {
  // 1️ Parse and validate body
  final body = await context.request.json() as Map<String, dynamic>;
  final name = (body['name'] as String?)?.trim();
  final email = (body['email'] as String?)?.trim();
  if (name == null || name.isEmpty || email == null || email.isEmpty) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Missing or empty name/email'},
    );
  }

  // 2️ Create user
  final repo = UserRepository(() => context.read());
  try {
    final newId = await repo.create(name, email);
    return Response.json(
      statusCode: HttpStatus.created,
      body: {'id': newId, 'name': name, 'email': email},
    );
  } catch (e) {
    print('Error creating user: \$e\n\$st');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error creating user'},
    );
  }
}
