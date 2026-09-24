import 'package:branchq/features/auth/data/session_store.dart';
import 'package:branchq/features/auth/domain/auth_repository.dart';
import 'package:branchq/features/auth/domain/demo_accounts.dart';
import 'package:branchq/features/auth/domain/session.dart';
import 'package:branchq/features/auth/domain/user.dart';

class _Account {
  const _Account({required this.user, required this.password});

  final User user;
  final String password;
}

class InMemoryAuthRepository implements AuthRepository {
  InMemoryAuthRepository(
    this._store, {
    DateTime Function()? now,
    String Function()? newToken,
  }) : _now = now ?? DateTime.now,
       _newToken = newToken ?? _defaultToken;

  final SessionStore _store;
  final DateTime Function() _now;
  final String Function() _newToken;

  static const _sessionLifetime = Duration(days: 7);

  static final _accounts = [
    _Account(
      user: const User(
        id: 'user-staff',
        name: 'Asha',
        email: DemoAccounts.staffEmail,
        role: UserRole.staff,
        branchId: DemoAccounts.staffBranchId,
      ),
      password: DemoAccounts.staffPassword,
    ),
    _Account(
      user: const User(
        id: 'user-customer',
        name: 'Ravi',
        email: DemoAccounts.customerEmail,
        role: UserRole.customer,
      ),
      password: DemoAccounts.customerPassword,
    ),
  ];

  static String _defaultToken() =>
      'token-${DateTime.now().microsecondsSinceEpoch}';

  @override
  User? findUser(String userId) {
    return _accounts
        .where((account) => account.user.id == userId)
        .firstOrNull
        ?.user;
  }

  @override
  Future<Session?> currentSession() async {
    final session = await _store.read();
    if (session == null) return null;
    if (session.isExpiredAt(_now()) || findUser(session.userId) == null) {
      await _store.clear();
      return null;
    }
    return session;
  }

  @override
  Future<Session> signIn({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    final account = _accounts
        .where((item) => item.user.email == email.trim().toLowerCase())
        .firstOrNull;
    if (account == null || account.password != password) {
      throw const AuthException('Email or password is incorrect.');
    }
    if (account.user.role != role) {
      throw const AuthException('This account cannot be used here.');
    }

    final session = Session(
      userId: account.user.id,
      role: account.user.role,
      branchId: account.user.branchId,
      token: _newToken(),
      expiresAt: _now().add(_sessionLifetime),
    );
    await _store.write(session);
    return session;
  }

  @override
  Future<void> signOut() => _store.clear();
}
