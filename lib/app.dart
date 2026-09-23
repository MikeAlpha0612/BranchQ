import 'package:branchq/core/router/app_router.dart';
import 'package:branchq/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BranchQApp extends StatefulWidget {
  const BranchQApp({super.key});

  @override
  State<BranchQApp> createState() => _BranchQAppState();
}

class _BranchQAppState extends State<BranchQApp> {
  late final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BranchQ',
      theme: AppTheme.light(),
      routerConfig: _router,
    );
  }
}
