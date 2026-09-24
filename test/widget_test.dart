import 'package:branchq/app.dart';
import 'package:branchq/features/auth/application/auth_controller.dart';
import 'package:branchq/features/auth/data/in_memory_auth_repository.dart';
import 'package:branchq/features/auth/data/session_store.dart';
import 'package:branchq/features/auth/domain/access_policy.dart';
import 'package:branchq/features/auth/domain/auth_repository.dart';
import 'package:branchq/features/auth/domain/demo_accounts.dart';
import 'package:branchq/features/auth/domain/session.dart';
import 'package:branchq/features/auth/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('staff can call next only at their own branch', () {
    final now = DateTime(2026, 9, 24);
    final session = SessionForTest.staff(
      expiresAt: now.add(const Duration(hours: 1)),
    );

    expect(
      AccessPolicy.canCallNext(
        session,
        branchId: DemoAccounts.staffBranchId,
        now: now,
      ),
      isTrue,
    );
    expect(
      AccessPolicy.canCallNext(session, branchId: 'north', now: now),
      isFalse,
    );
    expect(
      AccessPolicy.canOpenStaffRoutes(SessionForTest.customer(), now: now),
      isFalse,
    );
    expect(AccessPolicy.canJoinQueue(session, now: now), isFalse);
    expect(AccessPolicy.canWatchToken(session, now: now), isFalse);
    expect(AccessPolicy.canJoinQueue(null, now: now), isTrue);
  });

  test(
    'wrong password stays signed out and a session survives a new repository',
    () async {
      final store = MemorySessionStore();
      final now = DateTime(2026, 9, 24, 9);
      final repository = InMemoryAuthRepository(store, now: () => now);

    expect(
      repository.signIn(
        email: DemoAccounts.staffEmail,
        password: 'wrong',
        role: UserRole.staff,
      ),
      throwsA(isA<AuthException>()),
    );

      final session = await repository.signIn(
        email: DemoAccounts.staffEmail,
        password: DemoAccounts.staffPassword,
        role: UserRole.staff,
      );
      expect(session.role, UserRole.staff);
      expect(session.branchId, DemoAccounts.staffBranchId);
      expect(session.token, isNotEmpty);

      final restored = InMemoryAuthRepository(store, now: () => now);
      final current = await restored.currentSession();
      expect(current?.userId, session.userId);

      await restored.signOut();
      expect(await restored.currentSession(), isNull);
    },
  );

  test('an expired session is cleared on restore', () async {
    final store = MemorySessionStore();
    var now = DateTime(2026, 9, 24, 9);
    final repository = InMemoryAuthRepository(store, now: () => now);
    await repository.signIn(
      email: DemoAccounts.customerEmail,
      password: DemoAccounts.customerPassword,
      role: UserRole.customer,
    );

    now = now.add(const Duration(days: 8));
    expect(await repository.currentSession(), isNull);
  });

  testWidgets('Customer path reaches the sample token', (tester) async {
    await _pumpApp(tester);

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customer'));
    await tester.pumpAndSettle();

    expect(find.text('Central Branch'), findsOneWidget);
    expect(find.text('North Branch'), findsOneWidget);
    expect(find.text('Riverside Branch'), findsOneWidget);

    await tester.tap(find.text('Central Branch'));
    await tester.pumpAndSettle();

    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Account opening'), findsOneWidget);
    expect(find.text('Loan inquiry'), findsNothing);

    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();

    expect(find.text('A012'), findsOneWidget);
    expect(find.text('4 people ahead'), findsOneWidget);
    expect(find.text('About 16 minutes'), findsOneWidget);
  });

  testWidgets('Wrong password stays on the sign-in screen', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField).at(0),
      DemoAccounts.staffEmail,
    );
    await tester.enterText(find.byType(TextField).at(1), 'wrong');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Email or password is incorrect.'), findsOneWidget);
    expect(find.text('Counter 1'), findsNothing);
  });

  testWidgets('Staff sign-in reaches the counter and sign-out closes it', (
    tester,
  ) async {
    await _pumpApp(tester);
    await _signIn(
      tester,
      email: DemoAccounts.staffEmail,
      password: DemoAccounts.staffPassword,
    );

    expect(find.text('Central Branch'), findsOneWidget);
    expect(find.text('Counter 1'), findsOneWidget);
    expect(find.text('Counter 2'), findsOneWidget);

    await tester.tap(find.text('Counter 1'));
    await tester.pumpAndSettle();

    expect(find.text('A011'), findsOneWidget);
    expect(find.text('Call next'), findsOneWidget);
    expect(find.text('Served'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Call next'));
    await tester.pumpAndSettle();
    expect(find.text('A011'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Counter 1'), findsNothing);
  });

  testWidgets('A customer session cannot open the counter', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();
    await _enterAccount(
      tester,
      email: DemoAccounts.customerEmail,
      password: DemoAccounts.customerPassword,
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Central Branch'), findsOneWidget);

    GoRouter.of(tester.element(find.text('Central Branch')))
        .go('/staff/counter');
    await tester.pumpAndSettle();

    expect(find.text('A011'), findsNothing);
    expect(find.text('Continue as'), findsOneWidget);
  });
}

Future<void> _pumpApp(WidgetTester tester) async {
  final authController = AuthController(
    InMemoryAuthRepository(MemorySessionStore()),
  );
  await authController.restore();
  await tester.pumpWidget(BranchQApp(authController: authController));
}

Future<void> _signIn(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Staff'));
  await tester.pumpAndSettle();
  await _enterAccount(tester, email: email, password: password);
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await tester.pumpAndSettle();
}

Future<void> _enterAccount(
  WidgetTester tester, {
  required String email,
  required String password,
}) async {
  await tester.enterText(find.byType(TextField).at(0), email);
  await tester.enterText(find.byType(TextField).at(1), password);
}

class SessionForTest {
  static Session staff({required DateTime expiresAt}) {
    return Session(
      userId: 'user-staff',
      role: UserRole.staff,
      branchId: DemoAccounts.staffBranchId,
      token: 'token',
      expiresAt: expiresAt,
    );
  }

  static Session customer() {
    return Session(
      userId: 'user-customer',
      role: UserRole.customer,
      token: 'token',
      expiresAt: DateTime(2026, 9, 25),
    );
  }
}
