import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.push('/branches'),
              child: const Text('Customer'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push('/staff'),
              child: const Text('Staff'),
            ),
          ],
        ),
      ),
    );
  }
}
