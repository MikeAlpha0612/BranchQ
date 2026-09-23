import 'package:branchq/features/queue/models.dart';
import 'package:branchq/features/queue/queue_repository.dart';
import 'package:branchq/features/queue/queue_rules.dart';

/// Seeded branch data kept in fields on this object. A new app start creates a new instance.
class InMemoryQueueRepository implements QueueRepository {
  InMemoryQueueRepository() {
    _branches.addAll(_seedBranches);
    _services.addAll(_seedServices);
    _counters.addAll(_seedCounters);
  }

  static const centralBranchId = 'central';
  static const centralCashServiceId = 'central-cash';
  static const centralCashCounterId = 'central-1';

  final List<Branch> _branches = [];
  final List<Service> _services = [];
  final List<Counter> _counters = [];
  final List<Token> _tokens = [];
  var _nextTokenId = 1;

  static const _seedBranches = [
    Branch(
      id: centralBranchId,
      name: 'Central Branch',
      address: '12 Market Road',
      isOpen: true,
    ),
    Branch(
      id: 'north',
      name: 'North Branch',
      address: '88 Hill Street',
      isOpen: true,
    ),
    Branch(
      id: 'riverside',
      name: 'Riverside Branch',
      address: '4 Bridge Lane',
      isOpen: true,
    ),
  ];

  static const _seedServices = [
    Service(
      id: centralCashServiceId,
      branchId: centralBranchId,
      name: 'Cash',
      averageServiceMinutes: 5,
    ),
    Service(
      id: 'central-account',
      branchId: centralBranchId,
      name: 'Account opening',
      averageServiceMinutes: 15,
    ),
    Service(
      id: 'central-consultation',
      branchId: centralBranchId,
      name: 'Consultation',
      averageServiceMinutes: 10,
    ),
    Service(
      id: 'north-cash',
      branchId: 'north',
      name: 'Cash',
      averageServiceMinutes: 5,
    ),
    Service(
      id: 'north-loan',
      branchId: 'north',
      name: 'Loan inquiry',
      averageServiceMinutes: 12,
    ),
    Service(
      id: 'riverside-consultation',
      branchId: 'riverside',
      name: 'Consultation',
      averageServiceMinutes: 10,
    ),
    Service(
      id: 'riverside-documents',
      branchId: 'riverside',
      name: 'Document pickup',
      averageServiceMinutes: 8,
    ),
  ];

  static const _seedCounters = [
    Counter(
      id: centralCashCounterId,
      branchId: centralBranchId,
      name: 'Counter 1',
      activeServiceId: centralCashServiceId,
      isOpen: true,
    ),
    Counter(
      id: 'central-2',
      branchId: centralBranchId,
      name: 'Counter 2',
      activeServiceId: 'central-account',
      isOpen: true,
    ),
  ];

  @override
  List<Branch> listBranches() => List.unmodifiable(_branches);

  @override
  List<Service> listServices(String branchId) {
    return List.unmodifiable(
      _services.where((service) => service.branchId == branchId),
    );
  }

  @override
  List<Counter> listCounters(String branchId) {
    return List.unmodifiable(
      _counters.where((counter) => counter.branchId == branchId),
    );
  }

  @override
  List<Token> listTokens({
    required String branchId,
    required String serviceId,
  }) {
    return List.unmodifiable(
      _tokens.where(
        (token) => token.branchId == branchId && token.serviceId == serviceId,
      ),
    );
  }

  @override
  Token joinQueue({
    required String branchId,
    required String serviceId,
    DateTime? now,
  }) {
    final branch = _branches.where((item) => item.id == branchId).firstOrNull;
    if (branch == null) {
      throw ArgumentError('Unknown branch: $branchId');
    }
    final service = _services
        .where((item) => item.id == serviceId && item.branchId == branchId)
        .firstOrNull;
    if (service == null) {
      throw ArgumentError('Unknown service: $serviceId');
    }

    final createdAt = now ?? DateTime.now();
    final token = Token(
      id: 'token-$_nextTokenId',
      displayNumber: QueueRules.nextDisplayNumber(
        tokens: _tokens,
        branchId: branchId,
        serviceId: serviceId,
        now: createdAt,
      ),
      branchId: branchId,
      serviceId: serviceId,
      status: TokenStatus.waiting,
      createdAt: createdAt,
    );
    _nextTokenId += 1;
    _tokens.add(token);
    return token;
  }

  @override
  Token? watchToken(String tokenId) {
    return _tokens.where((token) => token.id == tokenId).firstOrNull;
  }

  @override
  Token? callNext(String counterId) {
    final counter = _requireCounter(counterId);
    if (QueueRules.activeToken(_tokens, counterId) != null) return null;

    final waiting = _tokens.where((token) {
      return token.branchId == counter.branchId &&
          token.serviceId == counter.activeServiceId &&
          token.status == TokenStatus.waiting;
    }).toList()..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    if (waiting.isEmpty) return null;

    final called = QueueRules.call(
      token: waiting.first,
      counterId: counterId,
      tokensAtCounter: _tokens,
    );
    _replace(called);
    return called;
  }

  @override
  Token? markServed(String counterId) {
    final active = QueueRules.activeToken(_tokens, counterId);
    if (active == null) return null;
    final served = QueueRules.markServed(active);
    _replace(served);
    return served;
  }

  @override
  Token? skip(String counterId) {
    final active = QueueRules.activeToken(_tokens, counterId);
    if (active == null) return null;
    final skipped = QueueRules.skip(active);
    _replace(skipped);
    return skipped;
  }

  Counter _requireCounter(String counterId) {
    final counter = _counters.where((item) => item.id == counterId).firstOrNull;
    if (counter == null) {
      throw ArgumentError('Unknown counter: $counterId');
    }
    return counter;
  }

  void _replace(Token token) {
    final index = _tokens.indexWhere((item) => item.id == token.id);
    _tokens[index] = token;
  }
}
