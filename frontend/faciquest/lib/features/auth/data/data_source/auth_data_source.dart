import 'package:faciquest/features/features.dart';

abstract class AuthDataSource {
  Stream<UserEntity?> get user;
  Future<UserEntity> signIn(String email, String password);
  Future<void> signUp(UserEntity user);
  Future<void> signOut();
  Future<void> forgotPassword(String email);
  Future<void> setNewPassword(String password);
  Future<void> verifyOtp(String otp);
  Future<UserEntity?> signInWithCredentials(String token);

}
