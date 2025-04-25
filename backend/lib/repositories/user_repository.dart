import 'package:backend/models/user.dart';
import 'package:postgres/postgres.dart';

/// Encapsulates all database operations for the `users` table.
/// Uses execute() for both reads and writes in postgres v3.
class UserRepository {

  UserRepository(this._connectionProvider);
  /// Provides the active database Connection.
  final Connection Function() _connectionProvider;

  /// Fetches a single user by their ID.
  /// Returns a [User] or null if no match.
  Future<User?> fetchById(int id) async {
    final conn = _connectionProvider();
    final result = await conn.execute(
      '''
      SELECT id, name, email, phone, user_type, profile_pic, last_known_location
        FROM users
       WHERE id = @id
      ''',
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    return User.fromRow(result.first);
  }

  /// Fetches all users in the system.
  Future<List<User>> fetchAll() async {
    final conn = _connectionProvider();
    final result = await conn.execute(
      '''
      SELECT id, name, email, phone, user_type, profile_pic, last_known_location
        FROM users
      ''',
    );
    return result.map(User.fromRow).toList();
  }

  /// Creates a new user and returns their assigned ID.
  Future<int> create(String name, String email) async {
    final conn = _connectionProvider();
    final result = await conn.execute(
      '''
      INSERT INTO users (name, email)
      VALUES (@name, @email)
      RETURNING id
      ''',
      parameters: {'name': name, 'email': email},
    );
    return result.first[0]! as int;
  }

  /// Saves user preferences in the `user_settings` table (upsert).
  /// Returns the number of rows affected.
  Future<int> saveSettings(int userId, Map<String, dynamic> prefs) async {
    final conn = _connectionProvider();
    final result = await conn.execute(
      '''
      INSERT INTO user_settings (user_id, prefs)
      VALUES (@uid, @prefs::json)
      ON CONFLICT (user_id) DO UPDATE
        SET prefs = @prefs::json
      ''',
      parameters: {'uid': userId, 'prefs': prefs},
    );
    return result.affectedRows;
  }
}
