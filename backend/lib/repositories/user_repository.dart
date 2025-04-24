import 'package:postgres/postgres.dart';
import 'package:backend/models/user_model.dart';
import 'package:bcrypt/bcrypt.dart';

class UserRepository {
  final Future<Connection> Function() _connectionProvider;

  UserRepository(this._connectionProvider);

  // ✅ Get user by email
  Future<User?> getUserByEmail(String email) async {
    final conn = await _connectionProvider();
    final result = await conn.execute(
      Sql.named('SELECT * FROM users WHERE email = @email'),
      parameters: {'email': email},
    );
    if (result.isEmpty) return null;
    return User.fromMap(result.first.toColumnMap());
  }

  // ✅ Get user by ID
  Future<User?> getUserById(int id) async {
    final conn = await _connectionProvider();
    final result = await conn.execute(
      Sql.named('SELECT * FROM users WHERE id = @id'),
      parameters: {'id': id},
    );
    if (result.isEmpty) return null;
    return User.fromMap(result.first.toColumnMap());
  }

  // ✅ Create full user
  Future<User> createUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? profilePic,
    String? lastKnownLocation,
  }) async {
    final conn = await _connectionProvider();
    final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

    await conn.execute(
      Sql.named('''
        INSERT INTO users (name, email, password, phone,profile_pic, last_known_location)
        VALUES (@name, @email, @password, @phone,@profile_pic, @last_known_location)
      '''),
      parameters: {
        'name': name,
        'email': email,
        'password': hashedPassword,
        'phone': phone,
        'profile_pic': profilePic,
        'last_known_location': lastKnownLocation,
      },
    );

    return await getUserByEmail(email) as User;
  }

  // ✅ Create user with just name + email (used in one of your routes)
  Future<int> create(String name, String email) async {
    final conn = await _connectionProvider();
    final result = await conn.execute(
      Sql.named('''
        INSERT INTO users (name, email, password)
        VALUES (@name, @email, @password)
        RETURNING id
      '''),
      parameters: {
        'name': name,
        'email': email,
        'password':
            BCrypt.hashpw('default123', BCrypt.gensalt()), // Can adjust later
      },
    );
    return result.first.toColumnMap()['id'] as int;
  }

  // ✅ Fetch all users
  Future<List<User>> fetchAll() async {
    final conn = await _connectionProvider();
    final result = await conn.execute(
      Sql.named('SELECT * FROM users'),
    );
    return result.map((row) => User.fromMap(row.toColumnMap())).toList();
  }

  // ✅ Fetch by ID (alias of getUserById)
  Future<User?> fetchById(int id) async {
    return getUserById(id);
  }

  // ✅ Save settings (e.g. location)
  Future<void> saveSettings(int userId, Map<String, dynamic> prefs) async {
    final conn = await _connectionProvider();
    await conn.execute(
      Sql.named('''
        UPDATE users
        SET last_known_location = @location
        WHERE id = @id
      '''),
      parameters: {
        'location': prefs['last_known_location'],
        'id': userId,
      },
    );
  }
}
