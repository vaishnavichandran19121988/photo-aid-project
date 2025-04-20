import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';

final _env = DotEnv()..load();

/// A database connection pool for handling concurrent database access efficiently.
final Pool<Connection> dbPool = Pool<Connection>.withEndpoints(
  [
    Endpoint(
      host: _env['DB_HOST']!,
      port: int.parse(_env['DB_PORT']!),
      database: _env['DB_NAME']!,
      username: _env['DB_USER']!,
      password: _env['DB_PASSWORD']!,
    ),
  ],
  settings: const PoolSettings(
    maxConnectionCount: 10,
    sslMode: SslMode.disable,
  ),
);

/// Executes a database operation using a connection from the pool.
///
/// Takes a function [fn] that uses a connection to perform an operation and returns a value of type [T].
Future<T> withDb<T>(Future<T> Function(Session) fn) async {
  return dbPool.run(fn);
}
