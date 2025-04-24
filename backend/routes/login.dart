import 'package:dart_frog/dart_frog.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:backend/repositories/user_repository.dart';
import 'package:backend/db_connection.dart'; // ✅ contains dbConnectionProvider()

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method == HttpMethod.options) {
    // 🔓 Preflight request (CORS)
    return Response(statusCode: 204);
  }

  if (context.request.method != HttpMethod.post) {
    return Response(statusCode: 405);
  }

  try {
    final body = await context.request.json();
    final email = body['email'];
    final password = body['password'];

    print('✅ Received login: $email');
    // ✅ ADD THIS LINE BELOW — defines 'user'
    final repo = UserRepository(() => dbConnectionProvider());
    final user = await repo.getUserByEmail(email);
    // ✅ Password check
    if (user == null || !BCrypt.checkpw(password, user.password)) {
      return Response.json(
        statusCode: 401,
        body: {'error': 'Invalid credentials'},
      );
    }

    // Proceed with DB check...
    return Response.json(
        body: {'message': 'Login successful', 'user': user.toSafeMap()});
  } catch (e) {
    print('❌ JSON parse failed: $e');
    return Response.json(
      statusCode: 400,
      body: {'error': 'Invalid JSON format'},
    );
  }
}
