import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:branchq/features/auth/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key, required this.authController});

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signedIn = authController.user;

    return Scaffold(
      appBar: AppBar(title: const Text('BranchQ')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Continue as', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Choose how you will use this branch.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (signedIn != null) ...[
              const SizedBox(height: 16),
              Text(
                'Signed in as ${signedIn.name}',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => _signOut(context),
                child: const Text('Sign out'),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push('/branches'),
              child: const Text('Customer'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.push('/sign-in?role=customer'),
              child: const Text('Sign in'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => _openStaff(context),
              child: const Text('Staff'),
            ),
          ],
        ),
      ),
    );
  }

  void _openStaff(BuildContext context) {
    final session = authController.session;
    final signedInStaff =
        session != null &&
        session.role == UserRole.staff &&
        !session.isExpiredAt(DateTime.now());
    if (signedInStaff) {
      context.go('/staff');
      return;
    }
    context.push('/sign-in?role=staff');
  }

  Future<void> _signOut(BuildContext context) async {
    await authController.signOut();
    if (context.mounted) context.go('/role');
  }
}
