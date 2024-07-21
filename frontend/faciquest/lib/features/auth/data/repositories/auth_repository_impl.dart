import 'package:faciquest/features/features.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  AuthRepositoryImpl({required this.authDataSource});
  @override
  Future<void> forgotPassword(String email) {
    return authDataSource.forgotPassword(email);
  }

  @override
  Future<UserEntity> signIn(String email, String password) {
    return authDataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() {
    return authDataSource.signOut();
  }

  @override
  Future<void> signUp(String email, String password) {
    return authDataSource.signUp(email, password);
  }

  @override
  Stream<UserEntity?> get user => authDataSource.user;
}
