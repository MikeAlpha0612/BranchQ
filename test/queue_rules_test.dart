import 'package:branchq/features/queue/models.dart';
import 'package:branchq/features/queue/queue_rules.dart';
import 'package:test/test.dart';

void main() {
  final today = DateTime(2026, 9, 23, 10);
  final yesterday = DateTime(2026, 9, 22, 10);

  Token token({
    required String id,
    required String displayNumber,
    required DateTime createdAt,
    TokenStatus status = TokenStatus.waiting,
    String serviceId = 'central-cash',
    String? counterId,
  }) {
    return Token(
      id: id,
      displayNumber: displayNumber,
      branchId: 'central',
      serviceId: serviceId,
      status: status,
      createdAt: createdAt,
      counterId: counterId,
    );
  }

  test('next display number is per branch and service for today', () {
    final existing = [
      token(id: '1', displayNumber: 'A001', createdAt: today),
      token(id: '2', displayNumber: 'A004', createdAt: yesterday),
      token(
        id: '3',
        displayNumber: 'A009',
        createdAt: today,
        serviceId: 'central-account',
      ),
    ];

    final next = QueueRules.nextDisplayNumber(
      tokens: existing,
      branchId: 'central',
      serviceId: 'central-cash',
      now: today.add(const Duration(hours: 1)),
    );

    expect(next, 'A002');
  });

  test('only a waiting token can be called, and the counter is attached', () {
    final waiting = token(id: '1', displayNumber: 'A001', createdAt: today);

    final called = QueueRules.call(
      token: waiting,
      counterId: 'central-1',
      tokensAtCounter: [waiting],
    );

    expect(called.status, TokenStatus.called);
    expect(called.counterId, 'central-1');
    expect(
      () => QueueRules.call(
        token: called,
        counterId: 'central-1',
        tokensAtCounter: [called],
      ),
      throwsStateError,
    );
  });

  test('a counter serves one token at a time', () {
    final called = token(
      id: '1',
      displayNumber: 'A001',
      createdAt: today,
      status: TokenStatus.called,
      counterId: 'central-1',
    );
    final waiting = token(
      id: '2',
      displayNumber: 'A002',
      createdAt: today.add(const Duration(minutes: 1)),
    );

    expect(
      () => QueueRules.call(
        token: waiting,
        counterId: 'central-1',
        tokensAtCounter: [called, waiting],
      ),
      throwsStateError,
    );
  });

  test('estimated wait is people ahead times the service average', () {
    final first = token(id: '1', displayNumber: 'A001', createdAt: today);
    final second = token(
      id: '2',
      displayNumber: 'A002',
      createdAt: today.add(const Duration(minutes: 1)),
    );

    final ahead = QueueRules.peopleAhead(second, [first, second]);

    expect(ahead, 1);
    expect(
      QueueRules.estimatedWaitMinutes(
        peopleAhead: ahead,
        averageServiceMinutes: 5,
      ),
      5,
    );

    final served = QueueRules.markServed(
      QueueRules.call(token: first, counterId: 'c', tokensAtCounter: [first]),
    );
    expect(QueueRules.peopleAhead(second, [served, second]), 0);
  });
}
