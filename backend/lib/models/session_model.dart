/// Represents a user-to-user session request in the system.
/// Maps directly to the `sessions` table:
///  id, requester_id, helper_id, timestamp, location, status
class SessionModel {

  SessionModel({
    required this.id,
    required this.requesterId,
    required this.helperId,
    required this.timestamp,
    this.location,
    required this.status,
  });

  /// Construct a SessionModel from a database row.
  /// Expects columns in order: id, requester_id, helper_id, timestamp, location, status.
  factory SessionModel.fromRow(List<Object?> row) {
    return SessionModel(
      id: row[0] as int,
      requesterId: row[1] as int,
      helperId: row[2] as int,
      timestamp: row[3] as DateTime,
      location: row[4] as String?,
      status: row[5] as String,
    );
  }

  /// Construct a SessionModel from JSON map (optional use-case).
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as int,
      requesterId: json['requesterId'] as int,
      helperId: json['helperId'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      location: json['location'] as String?,
      status: json['status'] as String,
    );
  }
  /// Unique session identifier.
  final int id;

  /// ID of the user who requested the session.
  final int requesterId;

  /// ID of the helper user for the session.
  final int helperId;

  /// Timestamp when the session was created.
  final DateTime timestamp;

  /// Optional text description of the session location.
  final String? location;

  /// Current status of the session: pending, accepted, completed, or cancelled.
  final String status;

  /// Convert this SessionModel into a JSON-serializable map.
  /// Uses camelCase keys to match Dart/Flutter conventions.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterId': requesterId,
      'helperId': helperId,
      'timestamp': timestamp.toIso8601String(),
      'location': location,
      'status': status,
    };
  }
}