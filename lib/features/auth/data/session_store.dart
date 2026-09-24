import 'package:branchq/features/auth/domain/session.dart';

abstract interface class SessionStore {
  Future<Session?> read();

  Future<void> write(Session session);

  Future<void> clear();
}

class MemorySessionStore implements SessionStore {
  Session? _session;

  @override
  Future<void> clear() async {
    _session = null;
  }

  @override
  Future<Session?> read() async => _session;

  @override
  Future<void> write(Session session) async {
    _session = session;
  }
}
