import 'package:branchq/features/queue/models.dart';

/// Queue decisions live here so screens never change a token themselves.
class QueueRules {
  static String nextDisplayNumber({
    required Iterable<Token> tokens,
    required String branchId,
    required String serviceId,
    required DateTime now,
  }) {
    var maxNumber = 0;
    for (final token in tokens) {
      if (token.branchId != branchId || token.serviceId != serviceId) continue;
      if (!_isSameDay(token.createdAt, now)) continue;
      final number = _sequence(token.displayNumber);
      if (number != null && number > maxNumber) maxNumber = number;
    }
    final next = maxNumber + 1;
    return 'A${next.toString().padLeft(3, '0')}';
  }

  static bool canCall(Token token) => token.status == TokenStatus.waiting;

  /// Calling attaches the counter. A counter already serving a token cannot call another.
  static Token call({
    required Token token,
    required String counterId,
    required Iterable<Token> tokensAtCounter,
  }) {
    if (!canCall(token)) {
      throw StateError('Only a waiting token can be called.');
    }
    if (activeToken(tokensAtCounter, counterId) != null) {
      throw StateError('A counter serves one token at a time.');
    }
    return token.copyWith(status: TokenStatus.called, counterId: counterId);
  }

  static Token markServed(Token token) {
    _requireCalled(token);
    return token.copyWith(status: TokenStatus.served);
  }

  static Token skip(Token token) {
    _requireCalled(token);
    return token.copyWith(status: TokenStatus.skipped);
  }

  static Token? activeToken(Iterable<Token> tokens, String counterId) {
    for (final token in tokens) {
      final isAttached = token.counterId == counterId;
      final isCurrent =
          token.status == TokenStatus.called ||
          token.status == TokenStatus.serving;
      if (isAttached && isCurrent) return token;
    }
    return null;
  }

  static int peopleAhead(Token token, Iterable<Token> tokens) {
    return tokens.where((other) {
      if (other.id == token.id) return false;
      if (other.branchId != token.branchId ||
          other.serviceId != token.serviceId) {
        return false;
      }
      if (!_isStillInQueue(other.status)) return false;
      return other.createdAt.isBefore(token.createdAt);
    }).length;
  }

  static int estimatedWaitMinutes({
    required int peopleAhead,
    required int averageServiceMinutes,
  }) {
    return peopleAhead * averageServiceMinutes;
  }

  static void _requireCalled(Token token) {
    final canFinish =
        token.status == TokenStatus.called ||
        token.status == TokenStatus.serving;
    if (!canFinish) {
      throw StateError('Only the called token can be updated.');
    }
  }

  static bool _isStillInQueue(TokenStatus status) {
    return status == TokenStatus.waiting ||
        status == TokenStatus.called ||
        status == TokenStatus.serving;
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    final left = a.toLocal();
    final right = b.toLocal();
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  static int? _sequence(String displayNumber) {
    final match = RegExp(r'^A(\d+)$').firstMatch(displayNumber);
    if (match == null) return null;
    return int.tryParse(match.group(1)!);
  }
}
