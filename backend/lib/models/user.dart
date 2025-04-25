/// Represents a user in the system, mapping to the `users` table.
class User {

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.userType,
    this.profilePic,
    this.lastKnownLocation,
  });

  /// Construct a User from a database row.
  /// Expects columns: id, name, email, phone, user_type, profile_pic, last_known_location.
  factory User.fromRow(List<Object?> row) {
    return User(
      id: row[0]! as int,
      name: row[1]! as String,
      email: row[2]! as String,
      phone: row[3] as String?,
      userType: row[4] as String?,
      profilePic: row[5] as String?,
      lastKnownLocation: row[6] as String?,
    );
  }

  /// Construct a User from JSON map (optional use-case).
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      userType: json['userType'] as String?,
      profilePic: json['profilePic'] as String?,
      lastKnownLocation: json['lastKnownLocation'] as String?,
    );
  }
  /// Unique user identifier.
  final int id;

  /// User's full name.
  final String name;

  /// User's email address.
  final String email;

  /// Optional phone number.
  final String? phone;

  /// Optional user type or role.
  final String? userType;

  /// Optional URL to the profile picture.
  final String? profilePic;

  /// Optional last known location description.
  final String? lastKnownLocation;

  /// Convert this User into a JSON-serializable map.
  /// Uses camelCase keys.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'profilePic': profilePic,
      'lastKnownLocation': lastKnownLocation,
    };
  }
}
