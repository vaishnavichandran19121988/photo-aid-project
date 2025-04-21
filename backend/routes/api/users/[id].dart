import 'dart:io';
import 'package:backend/middleware/db_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// GET /api/users/:id - Get a user by ID
Future<Response> onRequest(RequestContext context, String id) async {
  // Currently only handling GET requests
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  return _getUserById(context, id);
}

/// Fetch a user by ID from the database
Future<Response> _getUserById(RequestContext context, String id) async {
  try {
    // Convert string ID to integer
    final userId = int.tryParse(id);
    if (userId == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Invalid user ID format'},
      );
    }

    // Query the database for the user
    final user = await context.db.execute((conn) async {
      final result = await conn.execute(
        'SELECT id, name, email, phone, user_type, profile_pic, last_known_location '
        'FROM users WHERE id = @id',
        parameters: {'id': userId},
      );

      // Check if user was found
      if (result.isEmpty) {
        return null;
      }

      // Map row to user object (only public info)
      final row = result.first;
      return {
        'id': row[0],
        'name': row[1],
        'email': row[2],
        'phone': row[3],
        'user_type': row[4],
        'profile_pic': row[5],
        'last_known_location': row[6],
      };
    });

    // Return 404 if user not found
    if (user == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'User not found'},
      );
    }

    // Return the user data
    return Response.json(body: {'user': user});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Failed to fetch user: ${e.toString()}'},
    );
  }
}
