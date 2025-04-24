import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:backend/repositories/user_repository.dart';
import 'package:backend/db_connection.dart';

Future<Response> onRequest(RequestContext context) async {
  print('📥 /register hit');
  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final body = await context.request.json() as Map<String, dynamic>;
  final name = (body['name'] as String?)?.trim() ?? '';
  final email = (body['email'] as String?)?.trim() ?? '';
  final password = (body['password'] as String?)?.trim() ?? '';

  // ✅ Backend validation
  if (name.isEmpty || email.isEmpty || password.isEmpty) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'All fields are required'},
    );
  }

  if (!email.contains('@') || !email.contains('.')) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid email format'},
    );
  }

  if (password.length < 6) {
    return Response.json(
      statusCode: 400,
      body: {'error': 'Password must be at least 6 characters'},
    );
  }

  final repo = UserRepository(() => dbConnectionProvider());
  final existingUser = await repo.getUserByEmail(email);

  if (existingUser != null) {
    return Response.json(
      statusCode: 409,
      body: {'error': 'Email is already registered'},
    );
  }

  await repo.createUser(
    name: name,
    email: email,
    password: password,
    phone: null,
    profilePic: null,
    lastKnownLocation: null,
  );

  return Response.json(statusCode: 201, body: {
    'message': 'Register endpoint is working 🎯',
    'message': 'User registered successfully',
  });
}
