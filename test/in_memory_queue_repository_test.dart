import 'package:branchq/features/queue/in_memory_queue_repository.dart';
import 'package:branchq/features/queue/models.dart';
import 'package:test/test.dart';

void main() {
  test(
    'two customers receive A001 and A002, then staff serves them in order',
    () {
      final repository = InMemoryQueueRepository();
      final now = DateTime(2026, 9, 23, 10);

      final first = repository.joinQueue(
        branchId: InMemoryQueueRepository.centralBranchId,
        serviceId: InMemoryQueueRepository.centralCashServiceId,
        now: now,
      );
      final second = repository.joinQueue(
        branchId: InMemoryQueueRepository.centralBranchId,
        serviceId: InMemoryQueueRepository.centralCashServiceId,
        now: now.add(const Duration(minutes: 1)),
      );

      expect(first.displayNumber, 'A001');
      expect(second.displayNumber, 'A002');
      expect(first.status, TokenStatus.waiting);

      final called = repository.callNext(
        InMemoryQueueRepository.centralCashCounterId,
      );
      expect(called?.displayNumber, 'A001');
      expect(called?.status, TokenStatus.called);
      expect(called?.counterId, InMemoryQueueRepository.centralCashCounterId);
      expect(
        repository.callNext(InMemoryQueueRepository.centralCashCounterId),
        isNull,
      );

      final served = repository.markServed(
        InMemoryQueueRepository.centralCashCounterId,
      );
      expect(served?.status, TokenStatus.served);

      final next = repository.callNext(
        InMemoryQueueRepository.centralCashCounterId,
      );
      expect(next?.displayNumber, 'A002');
      expect(next?.status, TokenStatus.called);
    },
  );

  test('a new repository restores seed branches and an empty queue', () {
    final repository = InMemoryQueueRepository();

    expect(repository.listBranches().map((branch) => branch.name), [
      'Central Branch',
      'North Branch',
      'Riverside Branch',
    ]);
    expect(
      repository.listTokens(
        branchId: InMemoryQueueRepository.centralBranchId,
        serviceId: InMemoryQueueRepository.centralCashServiceId,
      ),
      isEmpty,
    );
  });
}
