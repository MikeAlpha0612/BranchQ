import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:branchq/features/auth/domain/access_policy.dart';
import 'package:branchq/features/queue/token_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ServiceListScreen extends StatelessWidget {
  const ServiceListScreen({
    super.key,
    required this.branchId,
    required this.branchName,
    required this.authController,
  });

  final String branchId;
  final String branchName;
  final AuthController authController;

  static const _servicesByBranch = {
    'central': [
      _SampleService(name: 'Cash', detail: 'About 5 minutes'),
      _SampleService(name: 'Account opening', detail: 'About 15 minutes'),
      _SampleService(name: 'Consultation', detail: 'About 10 minutes'),
    ],
    'north': [
      _SampleService(name: 'Cash', detail: 'About 5 minutes'),
      _SampleService(name: 'Loan inquiry', detail: 'About 12 minutes'),
    ],
    'riverside': [
      _SampleService(name: 'Consultation', detail: 'About 10 minutes'),
      _SampleService(name: 'Document pickup', detail: 'About 8 minutes'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final services = _servicesByBranch[branchId] ?? const <_SampleService>[];

    return Scaffold(
      appBar: AppBar(title: Text(branchName)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: services.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final service = services[index];
          return ServiceCard(
            name: service.name,
            detail: service.detail,
            onTap: () {
              final allowed = AccessPolicy.canJoinQueue(
                authController.session,
                now: DateTime.now(),
              );
              if (!allowed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Staff accounts use the counter.'),
                  ),
                );
                return;
              }
              context.push(
                '/tokens/A012',
                extra: TokenRouteArgs(
                  branchName: branchName,
                  serviceName: service.name,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.name,
    required this.detail,
    required this.onTap,
  });

  final String name;
  final String detail;
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
        title: Text(name, style: theme.textTheme.titleMedium),
        subtitle: Text(detail),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class _SampleService {
  const _SampleService({required this.name, required this.detail});

  final String name;
  final String detail;
}
