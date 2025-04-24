import 'package:backend/middleware/db_middleware.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';
import 'dart:developer'; // 👈 this is needed for log()

Handler middleware(Handler handler) {
  return handler.use(requestLogger()).use(dbMiddleware).use((handler) {
    return (context) {
      log('🔁 Route hit: ${context.request.uri}');
      return handler(context);
    };
  }).use(cors());
}
