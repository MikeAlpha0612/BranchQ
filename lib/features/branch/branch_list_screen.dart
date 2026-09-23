import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BranchListScreen extends StatelessWidget {
  const BranchListScreen({super.key});

  static const _branches = [
    _SampleBranch(
      id: 'central',
      name: 'Central Branch',
      address: '12 Market Road',
    ),
    _SampleBranch(id: 'north', name: 'North Branch', address: '88 Hill Street'),
    _SampleBranch(
      id: 'riverside',
      name: 'Riverside Branch',
      address: '4 Bridge Lane',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Branches')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _branches.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final branch = _branches[index];
          return BranchCard(
            name: branch.name,
            address: branch.address,
            onTap: () => context.push(
              '/branches/${branch.id}/services',
              extra: branch.name,
            ),
          );
        },
      ),
    );
  }
}

class BranchCard extends StatelessWidget {
  const BranchCard({
    super.key,
    required this.name,
    required this.address,
    required this.onTap,
  });

  final String name;
  final String address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          Icons.storefront_outlined,
          color: theme.colorScheme.primary,
        ),
        title: Text(name, style: theme.textTheme.titleMedium),
        subtitle: Text(address),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SampleBranch {
  const _SampleBranch({
    required this.id,
    required this.name,
    required this.address,
  });

  final String id;
  final String name;
  final String address;
}
