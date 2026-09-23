import 'package:branchq/features/queue/models.dart';
import 'package:branchq/features/queue/queue_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StaffHomeScreen extends StatelessWidget {
  const StaffHomeScreen({
    super.key,
    required this.repository,
    required this.branchId,
  });

  final QueueRepository repository;
  final String branchId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final branch = repository
        .listBranches()
        .where((item) => item.id == branchId)
        .firstOrNull;
    final services = repository.listServices(branchId);
    final counters = repository
        .listCounters(branchId)
        .where((counter) => counter.isOpen);

    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(branch?.name ?? branchId, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(
            'Open counters',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          for (final counter in counters) ...[
            CounterCard(
              counter: counter,
              serviceName:
                  services
                      .where((service) => service.id == counter.activeServiceId)
                      .firstOrNull
                      ?.name ??
                  counter.activeServiceId,
              onTap: () => context.push('/staff/counter', extra: counter.id),
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
    required this.counter,
    required this.serviceName,
    required this.onTap,
  });

  final Counter counter;
  final String serviceName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(Icons.desk_outlined, color: theme.colorScheme.primary),
        title: Text(counter.name, style: theme.textTheme.titleMedium),
        subtitle: Text(serviceName),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
