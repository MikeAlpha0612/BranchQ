import 'package:branchq/core/router/app_router.dart';
import 'package:branchq/core/theme/app_theme.dart';
import 'package:branchq/features/queue/in_memory_queue_repository.dart';
import 'package:branchq/features/queue/queue_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BranchQApp extends StatefulWidget {
  const BranchQApp({super.key, this.repository});

  final QueueRepository? repository;

  @override
  State<BranchQApp> createState() => _BranchQAppState();
}

class _BranchQAppState extends State<BranchQApp> {
  late final QueueRepository _repository =
      widget.repository ?? InMemoryQueueRepository();
  late final GoRouter _router = createAppRouter(_repository);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BranchQ',
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}
