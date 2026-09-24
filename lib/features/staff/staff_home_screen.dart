import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StaffHomeScreen extends StatelessWidget {
  const StaffHomeScreen({
    super.key,
    required this.branchName,
    required this.authController,
  });

  final String branchName;
  final AuthController authController;

  static const _counters = [
    _SampleCounter(name: 'Counter 1', service: 'Cash'),
    _SampleCounter(name: 'Counter 2', service: 'Account opening'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff'),
        actions: [
          TextButton(
            onPressed: () async {
              await authController.signOut();
              if (context.mounted) context.go('/role');
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(branchName, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Open counters',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final counter in _counters) ...[
            CounterCard(
              name: counter.name,
              service: counter.service,
              onTap: () => context.push('/staff/counter', extra: counter.name),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class CounterCard extends StatelessWidget {
  const CounterCard({
    super.key,
    required this.name,
    required this.service,
    required this.onTap,
  });

  final String name;
  final String service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Icons.desk_outlined, color: theme.colorScheme.primary),
        title: Text(name, style: theme.textTheme.titleMedium),
        subtitle: Text(service),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SampleCounter {
  const _SampleCounter({required this.name, required this.service});

  final String name;
  final String service;
}
