import 'package:branchq/features/queue/queue_repository.dart';
import 'package:branchq/features/queue/queue_rules.dart';
import 'package:flutter/material.dart';

class TokenScreen extends StatelessWidget {
  const TokenScreen({
    super.key,
    required this.repository,
    required this.tokenId,
  });

  final QueueRepository repository;
  final String tokenId;

  @override
  Widget build(BuildContext context) {
    final token = repository.watchToken(tokenId);
    if (token == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your token')),
        body: const Center(child: Text('Token not found')),
      );
    }

    final branch = repository
        .listBranches()
        .where((item) => item.id == token.branchId)
        .firstOrNull;
    final service = repository
        .listServices(token.branchId)
        .where((item) => item.id == token.serviceId)
        .firstOrNull;
    final ahead = QueueRules.peopleAhead(
      token,
      repository.listTokens(
        branchId: token.branchId,
        serviceId: token.serviceId,
      ),
    );
    final minutes = QueueRules.estimatedWaitMinutes(
      peopleAhead: ahead,
      averageServiceMinutes: service?.averageServiceMinutes ?? 0,
    );
    final place = [
      if (branch != null) branch.name,
      if (service != null) service.name,
    ].join(' · ');

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your token')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 16,
                ),
                child: Column(
                  children: [
                    Text(
                      'Token',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      token.displayNumber,
                      style: theme.textTheme.headlineLarge,
                    ),
                    if (place.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(place, textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            QueueFact(
              icon: Icons.people_outline,
              label: ahead == 1 ? '1 person ahead' : '$ahead people ahead',
            ),
            const SizedBox(height: 12),
            QueueFact(
              icon: Icons.schedule_outlined,
              label: minutes == 1 ? 'About 1 minute' : 'About $minutes minutes',
            ),
          ],
        ),
      ),
    );
  }
}

class QueueFact extends StatelessWidget {
  const QueueFact({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(label, style: theme.textTheme.titleMedium),
      ),
    );
  }
}
