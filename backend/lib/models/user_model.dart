class User {
  final int id;
  final String name;
  final String email;
  final String? phone;

  final String? profilePic;
  final String? lastKnownLocation;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePic,
    this.lastKnownLocation,
    required this.password,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      profilePic: map['profile_pic'],
      lastKnownLocation: map['last_known_location'],
      password: map['password'],
    );
  }

  // ✅ Safe version (no password)
  Map<String, dynamic> toSafeMap() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'profile_pic': profilePic,
        'last_known_location': lastKnownLocation,
      };

  // ✅ JSON alias
  Map<String, dynamic> toJson() => toSafeMap();
}
