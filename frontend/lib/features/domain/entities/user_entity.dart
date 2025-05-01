import 'dart:ffi';

class UserEntity {

  final String id;
  final String name;
  final String bio;
  final Float rating;

  UserEntity(this.bio, this.rating, this.id, this.name);
}