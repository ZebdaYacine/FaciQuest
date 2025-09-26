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
  Future<void> signUp(UserEntity user) {
    return authDataSource.signUp(user);
  }

  @override
  Stream<UserEntity?> get user => authDataSource.user;

  @override
  Future<void> setNewPassword(String password) {
    return authDataSource.setNewPassword(password);
  }

  @override
  Future<void> verifyOtp(String otp, {ConfirmAccountReasons reason = ConfirmAccountReasons.singUp}) {
    return authDataSource.verifyOtp(otp, reason: reason);
  }

  @override
  Future<UserEntity?> signInWithCredentials(String token) {
    return authDataSource.signInWithCredentials(token);
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) {
    return authDataSource.updateUser(user);
  }
}
