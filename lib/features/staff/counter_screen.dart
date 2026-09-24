import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:branchq/features/auth/domain/access_policy.dart';
import 'package:flutter/material.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({
    super.key,
    required this.counterName,
    required this.branchId,
    required this.authController,
  });

  final String counterName;
  final String branchId;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = authController.session;
    final now = DateTime.now();
    final canCall = AccessPolicy.canCallNext(
      session,
      branchId: branchId,
      now: now,
    );
    final canServe = AccessPolicy.canMarkServed(
      session,
      branchId: branchId,
      now: now,
    );
    final canSkip = AccessPolicy.canSkip(session, branchId: branchId, now: now);

    return Scaffold(
      appBar: AppBar(title: Text(counterName)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Now serving',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text('A011', style: theme.textTheme.headlineLarge),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: canCall ? () {} : null,
              child: const Text('Call next'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: canServe ? () {} : null,
              child: const Text('Served'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: canSkip ? () {} : null,
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
