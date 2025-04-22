import 'package:postgres/postgres.dart';
import 'package:backend/models/session_model.dart';

/// Encapsulates all database operations for the `sessions` table.
/// All queries use parameter binding to prevent SQL injection.
class SessionRepository {

  SessionRepository(this._connectionProvider);
  /// Provides the active database Connection.
  final Connection Function() _connectionProvider;

  /// Creates a new session request with initial status 'pending'.
  /// Returns the generated session ID.
  Future<int> create(int requesterId, int helperId) async {
    final conn = _connectionProvider();
    final rows = await conn.execute(
      '''
      INSERT INTO sessions (requester_id, helper_id, status)
      VALUES (@req, @help, 'pending')
      RETURNING id
      ''',
      parameters: {
        'req': requesterId,
        'help': helperId,
      },
    );
    return rows.first[0]! as int;
  }

  /// Updates the status of an existing session.
  /// Returns the number of rows affected (0 if none updated).
  Future<int> updateStatus(int sessionId, String status) async {
    final conn = _connectionProvider();
    // execute() returns a Result; extract affectedRowCount
    final result = await conn.execute(
      '''
      UPDATE sessions
         SET status = @st
       WHERE id = @id
      ''',
      parameters: {
        'st': status,
        'id': sessionId,
      },
    );
    return result.affectedRows;
  }

  /// Fetches a session by its ID.
  /// Returns a [SessionModel] or null if not found.
  Future<SessionModel?> fetchById(int id) async {
    final conn = _connectionProvider();
    final rows = await conn.execute(
      '''
      SELECT id, requester_id, helper_id, timestamp, location, status
        FROM sessions
       WHERE id = @id
      ''',
      parameters: {'id': id},
    );
    if (rows.isEmpty) return null;
    return SessionModel.fromRow(rows.first);
  }

  /// Fetches all sessions.
  Future<List<SessionModel>> fetchAll() async {
    final conn = _connectionProvider();
    final rows = await conn.execute(
      '''
      SELECT id, requester_id, helper_id, timestamp, location, status
        FROM sessions
      ''',
    );
    return rows.map(SessionModel.fromRow).toList();
  }
}
