import 'package:branchq/features/branch/branch_list_screen.dart';
import 'package:branchq/features/branch/service_list_screen.dart';
import 'package:branchq/features/queue/in_memory_queue_repository.dart';
import 'package:branchq/features/queue/queue_repository.dart';
import 'package:branchq/features/queue/token_screen.dart';
import 'package:branchq/features/shell/role_screen.dart';
import 'package:branchq/features/shell/splash_screen.dart';
import 'package:branchq/features/staff/counter_screen.dart';
import 'package:branchq/features/staff/staff_home_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter(QueueRepository repository) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/role', builder: (context, state) => const RoleScreen()),
      GoRoute(
        path: '/branches',
        builder: (context, state) => BranchListScreen(repository: repository),
      ),
      GoRoute(
        path: '/branches/:id/services',
        builder: (context, state) {
          return ServiceListScreen(
            repository: repository,
            branchId: state.pathParameters['id']!,
          );
        },
      ),
      GoRoute(
        path: '/tokens/:id',
        builder: (context, state) {
          return TokenScreen(
            repository: repository,
            tokenId: state.pathParameters['id']!,
          );
        },
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) {
          return StaffHomeScreen(
            repository: repository,
            branchId: InMemoryQueueRepository.centralBranchId,
          );
        },
      ),
      GoRoute(
        path: '/staff/counter',
        builder: (context, state) {
          final counterId = state.extra is String
              ? state.extra! as String
              : InMemoryQueueRepository.centralCashCounterId;
          return CounterScreen(repository: repository, counterId: counterId);
        },
      ),
    ],
  );
}
