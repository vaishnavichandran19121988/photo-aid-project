import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../../data/models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore firestore;
  UserRepositoryImpl(this.firestore);

  @override
  Future<UserEntity> getUser(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!, doc.id);
    } else {
      throw Exception('User not found');
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final model = UserModel(user.bio,user.rating,user.id,user.name);
    await firestore.collection('users').doc(user.id).update(model.toMap());
  }
}
