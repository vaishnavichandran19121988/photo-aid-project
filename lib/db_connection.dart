import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

final _env = DotEnv()..load();

PostgreSQLConnection getDatabaseConnection() {
  final host = _env['DB_HOST']!;
  final port = int.parse(_env['DB_PORT']!);
  final dbName = _env['DB_NAME']!;
  final user = _env['DB_USER']!;
  final password = _env['DB_PASSWORD']!;

  return PostgreSQLConnection(
    host,
    port,
    dbName,
    username: user,
    password: password,
  );
}
