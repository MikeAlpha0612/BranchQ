import 'package:branchq/features/queue/models.dart';

abstract interface class QueueRepository {
  List<Branch> listBranches();

  List<Service> listServices(String branchId);

  List<Counter> listCounters(String branchId);

  List<Token> listTokens({required String branchId, required String serviceId});

  Token joinQueue({
    required String branchId,
    required String serviceId,
    DateTime? now,
  });

  Token? watchToken(String tokenId);

  Token? callNext(String counterId);

  Token? markServed(String counterId);

  Token? skip(String counterId);
}
