import 'package:amazone_clone/services/auth/auth_provider.dart';
import 'package:amazone_clone/services/auth/auth_user.dart';
import 'package:amazone_clone/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<void> initialize() async {
    await provider.initialize();
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    return await provider.login(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await provider.logout();
  }

  @override
  Future<void> sendEmailVerification() async {
    await provider.sendEmailVerification();
  }

  @override
  Future<AuthUser> signup({
    required String email,
    required String password,
  }) async {
    return await provider.signup(
      email: email,
      password: password,
    );
  }
}
