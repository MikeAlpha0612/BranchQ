import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:branchq/features/auth/domain/access_policy.dart';
import 'package:branchq/features/auth/domain/demo_accounts.dart';
import 'package:branchq/features/auth/domain/user.dart';
import 'package:branchq/features/auth/presentation/sign_in_screen.dart';
import 'package:branchq/features/branch/branch_list_screen.dart';
import 'package:branchq/features/branch/service_list_screen.dart';
import 'package:branchq/features/queue/token_screen.dart';
import 'package:branchq/features/shell/role_screen.dart';
import 'package:branchq/features/shell/splash_screen.dart';
import 'package:branchq/features/staff/counter_screen.dart';
import 'package:branchq/features/staff/staff_home_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter(AuthController authController) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authController,
    redirect: (context, state) {
      final path = state.uri.path;
      final staffArea = path == '/staff' || path.startsWith('/staff/');
      if (!staffArea) return null;
      final session = authController.session;
      final now = DateTime.now();
      if (AccessPolicy.canOpenStaffRoutes(session, now: now)) return null;
      if (session != null &&
          session.role == UserRole.customer &&
          !session.isExpiredAt(now)) {
        return '/role';
      }
      return '/sign-in?role=staff';
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/role',
        builder: (context, state) => RoleScreen(authController: authController),
      ),
      GoRoute(
        path: '/sign-in',
        builder: (context, state) {
          final roleName = state.uri.queryParameters['role'];
          final role = roleName == UserRole.customer.name
              ? UserRole.customer
              : UserRole.staff;
          return SignInScreen(authController: authController, role: role);
        },
      ),
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
          return ServiceListScreen(
            branchId: branchId,
            branchName: branchName,
            authController: authController,
          );
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
            authController: authController,
          );
        },
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) {
          final branchId =
              authController.session?.branchId ?? DemoAccounts.staffBranchId;
          return StaffHomeScreen(
            branchName: DemoAccounts.branchName(branchId),
            authController: authController,
          );
        },
      ),
      GoRoute(
        path: '/staff/counter',
        builder: (context, state) {
          final counterName = state.extra is String
              ? state.extra! as String
              : 'Counter 1';
          final branchId =
              authController.session?.branchId ?? DemoAccounts.staffBranchId;
          return CounterScreen(
            counterName: counterName,
            branchId: branchId,
            authController: authController,
          );
        },
      ),
    ],
  );
}
