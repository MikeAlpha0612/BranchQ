import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:branchq/features/auth/domain/auth_repository.dart';
import 'package:branchq/features/auth/domain/demo_accounts.dart';
import 'package:branchq/features/auth/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    super.key,
    required this.authController,
    required this.role,
  });

  final AuthController authController;
  final UserRole role;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final staff = widget.role == UserRole.staff;
    final demoEmail = staff
        ? DemoAccounts.staffEmail
        : DemoAccounts.customerEmail;
    final demoPassword = staff
        ? DemoAccounts.staffPassword
        : DemoAccounts.customerPassword;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            staff ? 'Staff sign in' : 'Customer sign in',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            staff
                ? 'Sign in to open your branch counter.'
                : 'Sign in to see your own token.',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            onSubmitted: (_) => _submit(),
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            Text(
              _error!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: const Text('Sign in'),
          ),
          const SizedBox(height: 24),
          Text(
            'Demo account: $demoEmail / $demoPassword',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter your email and password.');
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });

    try {
      await widget.authController.signIn(
        email: email,
        password: password,
        role: widget.role,
      );
      if (!mounted) return;
      if (widget.role == UserRole.staff) {
        context.go('/staff');
      } else {
        context.go('/branches');
      }
    } on AuthException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
