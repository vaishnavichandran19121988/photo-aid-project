import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';
import 'package:backend/middleware/db_middleware.dart';

/// GET /api/users - Get all users
/// POST /api/users - Create a new user
Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _onGetUsers(context);
    case HttpMethod.post:
      return _onCreateUser(context);
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

/// Handle GET /api/users
Future<Response> _onGetUsers(RequestContext context) async {
  try {
    // Use the database to fetch users
    final users = await context.db.execute((conn) async {
      final result = await conn.execute('SELECT id, name, email FROM users');
      return result.map((row) {
        return {
          'id': row[0],
          'name': row[1],
          'email': row[2],
        };
      }).toList();
    });

    return Response.json(body: {'users': users});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to fetch users: ${e.toString()}'},
    );
  }
}

/// Handle POST /api/users
Future<Response> _onCreateUser(RequestContext context) async {
  try {
    // Parse the request body
    final body = await context.request.json() as Map<String, dynamic>;
    final name = body['name'] as String?;
    final email = body['email'] as String?;

    if (name == null || email == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Missing required fields: name, email'},
      );
    }

    // Use the database to create a user
    final userId = await context.db.execute((conn) async {
      final result = await conn.execute(
        'INSERT INTO users (name, email) VALUES (@name, @email) RETURNING id',
        parameters: {'name': name, 'email': email},
      );
      return result[0][0];
    });

    return Response.json(
      statusCode: HttpStatus.created,
      body: {'id': userId, 'name': name, 'email': email},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to create user: ${e.toString()}'},
    );
  }
}
