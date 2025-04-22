import 'package:backend/middleware/db_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Application-level middleware stack
///
/// This middleware is applied to all routes in the application.
/// Add any global middleware in this chain.
Handler middleware(Handler handler) {
  // Apply database middleware
  final updatedHandler = dbMiddleware(handler);

  // Add more application-level middleware here if needed
  // final finalHandler = someOtherMiddleware(updatedHandler);

  return updatedHandler;
}
