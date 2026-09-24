import 'package:branchq/features/auth/domain/user.dart';

class Session {
  const Session({
    required this.userId,
    required this.role,
    required this.token,
    required this.expiresAt,
    this.branchId,
  });

  final String userId;
  final UserRole role;
  final String? branchId;
  final String token;
  final DateTime expiresAt;

  bool isExpiredAt(DateTime now) => !expiresAt.isAfter(now);

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'role': role.name,
      'branchId': branchId,
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  static Session? fromJson(Map<String, Object?> json) {
    final userId = json['userId'];
    final roleName = json['role'];
    final token = json['token'];
    final expiresAt = json['expiresAt'];
    if (userId is! String ||
        roleName is! String ||
        token is! String ||
        expiresAt is! String) {
      return null;
    }
    final role = UserRole.values
        .where((value) => value.name == roleName)
        .firstOrNull;
    final expiry = DateTime.tryParse(expiresAt);
    if (role == null || expiry == null) return null;
    final branchId = json['branchId'];
    return Session(
      userId: userId,
      role: role,
      branchId: branchId is String ? branchId : null,
      token: token,
      expiresAt: expiry,
    );
  }
}
