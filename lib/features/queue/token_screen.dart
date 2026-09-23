import 'package:flutter/material.dart';

class TokenScreen extends StatelessWidget {
  const TokenScreen({
    super.key,
    required this.tokenId,
    this.branchName,
    this.serviceName,
  });

  final String tokenId;
  final String? branchName;
  final String? serviceName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final place = [
      if (branchName != null) branchName,
      if (serviceName != null) serviceName,
    ].join(' · ');

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
                    Text(tokenId, style: theme.textTheme.headlineLarge),
                    if (place.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(place, textAlign: TextAlign.center),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const QueueFact(
              icon: Icons.people_outline,
              label: '4 people ahead',
            ),
            const SizedBox(height: 12),
            const QueueFact(
              icon: Icons.schedule_outlined,
              label: 'About 16 minutes',
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

class TokenRouteArgs {
  const TokenRouteArgs({required this.branchName, required this.serviceName});

  final String branchName;
  final String serviceName;
}

TokenRouteArgs? tokenRouteArgsOf(Object? extra) {
  return extra is TokenRouteArgs ? extra : null;
}
