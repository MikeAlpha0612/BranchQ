import 'package:branchq/app.dart';
import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:branchq/features/auth/data/in_memory_auth_repository.dart';
import 'package:branchq/features/auth/data/shared_preferences_session_store.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authController = AuthController(
    InMemoryAuthRepository(SharedPreferencesSessionStore()),
  );
  await authController.restore();
  runApp(BranchQApp(authController: authController));
}
