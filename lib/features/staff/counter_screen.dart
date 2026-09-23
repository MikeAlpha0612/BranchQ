import 'package:branchq/features/queue/models.dart';
import 'package:branchq/features/queue/queue_repository.dart';
import 'package:branchq/features/queue/queue_rules.dart';
import 'package:flutter/material.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({
    super.key,
    required this.repository,
    required this.counterId,
  });

  final QueueRepository repository;
  final String counterId;

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final counter = _findCounter();
    final service = counter == null ? null : _findService(counter);
    final active = counter == null
        ? null
        : QueueRules.activeToken(
            widget.repository.listTokens(
              branchId: counter.branchId,
              serviceId: counter.activeServiceId,
            ),
            counter.id,
          );

    return Scaffold(
      appBar: AppBar(title: Text(counter?.name ?? 'Counter')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (service != null)
              Text(
                service.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Now serving',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              active?.displayNumber ?? 'No token yet',
              style: active == null
                  ? theme.textTheme.headlineSmall
                  : theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: active == null ? _callNext : null,
              child: const Text('Call next'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: active == null ? null : _markServed,
              child: const Text('Served'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: active == null ? null : _skip,
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }

  Counter? _findCounter() {
    for (final branch in widget.repository.listBranches()) {
      for (final counter in widget.repository.listCounters(branch.id)) {
        if (counter.id == widget.counterId) return counter;
      }
    }
    return null;
  }

  Service? _findService(Counter counter) {
    return widget.repository
        .listServices(counter.branchId)
        .where((service) => service.id == counter.activeServiceId)
        .firstOrNull;
  }

  void _callNext() {
    widget.repository.callNext(widget.counterId);
    setState(() {});
  }

  void _markServed() {
    widget.repository.markServed(widget.counterId);
    setState(() {});
  }

  void _skip() {
    widget.repository.skip(widget.counterId);
    setState(() {});
  }
}
