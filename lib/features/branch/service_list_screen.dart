import 'package:branchq/features/queue/models.dart';
import 'package:branchq/features/queue/queue_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({
    super.key,
    required this.repository,
    required this.branchId,
  });

  final QueueRepository repository;
  final String branchId;

  @override
  Widget build(BuildContext context) {
    final branch = repository
        .listBranches()
        .where((item) => item.id == branchId)
        .firstOrNull;
    final services = repository.listServices(branchId);

    return Scaffold(
      appBar: AppBar(title: Text(branch?.name ?? branchId)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCard(
            service: service,
            onTap: () {
              final token = repository.joinQueue(
                branchId: branchId,
                serviceId: service.id,
              );
              context.push('/tokens/${token.id}');
            },
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({super.key, required this.service, required this.onTap});

  final Service service;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          Icons.room_service_outlined,
          color: theme.colorScheme.primary,
        ),
        title: Text(service.name, style: theme.textTheme.titleMedium),
        subtitle: Text('About ${service.averageServiceMinutes} minutes'),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
