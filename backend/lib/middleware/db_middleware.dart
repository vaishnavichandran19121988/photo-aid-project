import 'package:backend/db_connection.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

/// Middleware that provides database connection access to routes.
///
/// This middleware adds a database handler to the request context,
/// allowing route handlers to easily access the database.
Handler dbMiddleware(Handler handler) {
  return handler.use(
    provider<DatabaseExecutor>((context) => DatabaseExecutor()),
  );
}

/// A helper class that provides methods to execute database operations.
class DatabaseExecutor {
  /// Executes a database operation with the proper connection strategy.
  ///
  /// This method automatically uses either the singleton connection or
  /// connection pool based on your environment configuration.
  Future<T> execute<T>(Future<T> Function(Session) fn) async {
    return withDb(fn);
  }
}

/// Extension to easily access database from the request context.
extension DatabaseRequestContextExtension on RequestContext {
  /// Returns the database executor from the request context.
  DatabaseExecutor get db => read<DatabaseExecutor>();
}
