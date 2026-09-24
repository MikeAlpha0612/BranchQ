import 'package:branchq/features/auth/domain/session.dart';
import 'package:branchq/features/auth/domain/user.dart';

abstract interface class AuthRepository {
  Future<Session> signIn({
    required String email,
    required String password,
    required UserRole role,
  });

  Future<void> signOut();

  Future<Session?> currentSession();

  User? findUser(String userId);
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;
}
