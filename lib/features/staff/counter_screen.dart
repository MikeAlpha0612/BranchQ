import 'package:flutter/material.dart';

class CounterScreen extends StatelessWidget {
  const CounterScreen({super.key, required this.counterName});

  final String counterName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            FilledButton(onPressed: () {}, child: const Text('Call next')),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () {}, child: const Text('Served')),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () {}, child: const Text('Skip')),
          ],
        ),
      ),
    );
  }
}
