import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getUser(String id);
  Future<void> updateUser(UserEntity user);
}