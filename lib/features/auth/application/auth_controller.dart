import 'package:branchq/features/auth/domain/auth_repository.dart';
import 'package:branchq/features/auth/domain/session.dart';
import 'package:branchq/features/auth/domain/user.dart';
import 'package:flutter/foundation.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository);

  final AuthRepository _repository;
  Session? session;

  User? get user {
    final current = session;
    if (current == null) return null;
    return _repository.findUser(current.userId);
  }

  Future<void> restore() async {
    session = await _repository.currentSession();
    notifyListeners();
  }

  Future<void> signIn({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    session = await _repository.signIn(
      email: email,
      password: password,
      role: role,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await _repository.signOut();
    session = null;
    notifyListeners();
  }
}
