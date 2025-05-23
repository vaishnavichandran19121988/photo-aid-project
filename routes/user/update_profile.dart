import 'dart:convert';
import 'dart:io';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/jwt_utils.dart';

Future<void> handleUpdateProfile(HttpRequest request) async {
  final authHeader = request.headers.value('authorization');
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    request.response
      ..statusCode = 401
      ..write(jsonEncode({'success': false, 'message': 'Missing or invalid token'}))
      ..close();
    return;
  }

  final token = authHeader.substring(7);
  final userId = JwtUtils.getUserIdFromToken(token);
  if (userId == null) {
    request.response
      ..statusCode = 401
      ..write(jsonEncode({'success': false, 'message': 'Invalid or expired token'}))
      ..close();
    return;
  }

  try {
    final content = await utf8.decoder.bind(request).join();

    // This assumes frontend sends a JSON payload, not multipart.
    // To switch back to file uploads later, let me know.

    final data = jsonDecode(content);
    final fullName = data['fullName'] as String?;
    final email = data['email'] as String?;
    final bio = data['bio'] as String?;
    final profileImageUrl = data['profileImageUrl'] as String?; // optional

    final result = await AuthService().updateProfile(
      userId: userId,
      fullName: fullName,
      bio: bio,
      email: email,
      profileImageUrl: profileImageUrl,
    );

    request.response
      ..statusCode = result['success'] ? 200 : 400
      ..headers.contentType = ContentType.json
      ..write(jsonEncode(result))
      ..close();
  } catch (e) {
    print('❌ Error in updateProfile: $e');
    request.response
      ..statusCode = 500
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'success': false, 'message': 'Server error: $e'}))
      ..close();
  }
}
