import 'dart:io';
import 'package:dart_frog/dart_frog.dart';

/// Root handler for `/` — provides a simple API overview and health check
Future<Response> onGet(RequestContext context) async {
  return Response.json(
    statusCode: HttpStatus.ok,
    body: {
      'message': 'Welcome to the Photo Aid API',
      'version': '1.0.0',
      'routes': [
        {
          'method': 'GET',
          'path': '/api/users',
          'description': 'List all users'
        },
        {
          'method': 'POST',
          'path': '/api/users',
          'description': 'Create a new user'
        },
        {
          'method': 'GET',
          'path': '/api/users/:id',
          'description': 'Get a user by ID'
        },
        {
          'method': 'PUT',
          'path': '/api/users/:id/settings',
          'description': 'Update user settings'
        },
        {
          'method': 'GET',
          'path': '/api/sessions',
          'description': 'List all sessions'
        },
        {
          'method': 'POST',
          'path': '/api/sessions',
          'description': 'Create a new session request'
        },
        {
          'method': 'PUT',
          'path': '/api/sessions/:id',
          'description': 'Accept/reject a session'
        },
      ],
      'health': 'OK',
    },
  );
}

/// Allow other HTTP methods to return 405
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.get) {
    return onGet(context);
  }
  return Response(statusCode: HttpStatus.methodNotAllowed);
}
