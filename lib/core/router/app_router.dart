import 'package:branchq/features/branch/branch_list_screen.dart';
import 'package:branchq/features/branch/service_list_screen.dart';
import 'package:branchq/features/queue/token_screen.dart';
import 'package:branchq/features/shell/role_screen.dart';
import 'package:branchq/features/shell/splash_screen.dart';
import 'package:branchq/features/staff/counter_screen.dart';
import 'package:branchq/features/staff/staff_home_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/role', builder: (context, state) => const RoleScreen()),
      GoRoute(
        path: '/branches',
        builder: (context, state) => const BranchListScreen(),
      ),
      GoRoute(
        path: '/branches/:id/services',
        builder: (context, state) {
          final branchId = state.pathParameters['id']!;
          final branchName = state.extra is String
              ? state.extra! as String
              : branchId;
          return ServiceListScreen(branchId: branchId, branchName: branchName);
        },
      ),
      GoRoute(
        path: '/tokens/:id',
        builder: (context, state) {
          final args = tokenRouteArgsOf(state.extra);
          return TokenScreen(
            tokenId: state.pathParameters['id']!,
            branchName: args?.branchName,
            serviceName: args?.serviceName,
          );
        },
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) =>
            const StaffHomeScreen(branchName: 'Central Branch'),
      ),
      GoRoute(
        path: '/staff/counter',
        builder: (context, state) {
          final counterName = state.extra is String
              ? state.extra! as String
              : 'Counter 1';
          return CounterScreen(counterName: counterName);
        },
      ),
    ],
  );
}
