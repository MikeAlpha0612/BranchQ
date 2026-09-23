import 'package:branchq/features/queue/models.dart';
import 'package:branchq/features/queue/queue_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BranchListScreen extends StatelessWidget {
  const BranchListScreen({super.key, required this.repository});

  final QueueRepository repository;

  @override
  Widget build(BuildContext context) {
    final branches = repository.listBranches();

    return Scaffold(
      appBar: AppBar(title: const Text('Branches')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: branches.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final branch = branches[index];
          return BranchCard(
            branch: branch,
            onTap: () => context.push('/branches/${branch.id}/services'),
          );
        },
      ),
    );
  }
}

class BranchCard extends StatelessWidget {
  const BranchCard({super.key, required this.branch, required this.onTap});

  final Branch branch;
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
        title: Text(branch.name, style: theme.textTheme.titleMedium),
        subtitle: Text(branch.address),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
