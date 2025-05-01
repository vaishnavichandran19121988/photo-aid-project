import 'package:photoaid/features/domain/repositories/user_repository.dart';
import 'package:photoaid/features/domain/repositories/user_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/entities/user_entity.dart';
import '../domain/usecases/get_user_use_case.dart';
import '../domain/usecases/update_user_use_case.dart';


final firebaseProvider = Provider((ref) => FirebaseFirestore.instance);

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.read(firebaseProvider));
});

final getUserUseCaseProvider = Provider((ref) => GetUserUseCase(ref.read(userRepositoryProvider)));
final updateUserUseCaseProvider = Provider((ref) => UpdateUserUseCase(ref.read(userRepositoryProvider)));

final userFutureProvider = FutureProvider.family<UserEntity, String>((ref, id) {
  return ref.read(getUserUseCaseProvider)(id);
});