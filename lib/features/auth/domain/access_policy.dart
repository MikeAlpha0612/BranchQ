import 'package:branchq/features/auth/domain/session.dart';
import 'package:branchq/features/auth/domain/user.dart';

/// Decides which queue actions and staff screens the current session may use.
class AccessPolicy {
  static bool canJoinQueue(Session? session, {required DateTime now}) {
    if (session == null || session.isExpiredAt(now)) return true;
    return session.role == UserRole.customer;
  }

  static bool canWatchToken(Session? session, {required DateTime now}) {
    if (session == null || session.isExpiredAt(now)) return true;
    return session.role == UserRole.customer;
  }

  static bool canOpenStaffRoutes(Session? session, {required DateTime now}) {
    return session != null &&
        session.role == UserRole.staff &&
        !session.isExpiredAt(now);
  }

  static bool canCallNext(
    Session? session, {
    required String branchId,
    required DateTime now,
  }) {
    return _staffAtBranch(session, branchId: branchId, now: now);
  }

  static bool canMarkServed(
    Session? session, {
    required String branchId,
    required DateTime now,
  }) {
    return _staffAtBranch(session, branchId: branchId, now: now);
  }

  static bool canSkip(
    Session? session, {
    required String branchId,
    required DateTime now,
  }) {
    return _staffAtBranch(session, branchId: branchId, now: now);
  }

  static bool _staffAtBranch(
    Session? session, {
    required String branchId,
    required DateTime now,
  }) {
    return session != null &&
        session.role == UserRole.staff &&
        !session.isExpiredAt(now) &&
        session.branchId == branchId;
  }
}
