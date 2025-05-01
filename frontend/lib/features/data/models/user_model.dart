import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel(super.bio, super.rating, super.id, super.name);

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(map['bio'],map['rating'],id, map['name']);
  }

  Map<String, dynamic> toMap() => {'name': name};
}