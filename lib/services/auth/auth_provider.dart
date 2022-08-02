import 'auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initialize()async{}
  Future<AuthUser> login({
    required String email,
    required String password,
  });
  Future<AuthUser> signup({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<void> sendEmailVerification();
}
