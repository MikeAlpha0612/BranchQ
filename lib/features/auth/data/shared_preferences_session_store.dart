import 'dart:convert';

import 'package:branchq/features/auth/data/session_store.dart';
import 'package:branchq/features/auth/domain/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSessionStore implements SessionStore {
  static const _key = 'branchq.session';

  @override
  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_key);
  }

  @override
  Future<Session?> read() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_key);
    if (raw == null) return null;
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return null;
    return Session.fromJson(decoded.cast<String, Object?>());
  }

  @override
  Future<void> write(Session session) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_key, jsonEncode(session.toJson()));
  }
}
