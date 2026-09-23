import 'package:branchq/app.dart';
import 'package:branchq/features/queue/token_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Two customers on one service receive A001 and A002', (
    tester,
  ) async {
    await tester.pumpWidget(const BranchQApp());
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customer'));
    await tester.pumpAndSettle();

    expect(find.text('Central Branch'), findsOneWidget);
    expect(find.text('North Branch'), findsOneWidget);
    expect(find.text('Riverside Branch'), findsOneWidget);

    await tester.tap(find.text('North Branch'));
    await tester.pumpAndSettle();
    expect(find.text('Loan inquiry'), findsOneWidget);
    expect(find.text('Account opening'), findsNothing);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Central Branch'));
    await tester.pumpAndSettle();
    expect(find.text('Cash'), findsOneWidget);
    expect(find.text('Account opening'), findsOneWidget);
    expect(find.text('Loan inquiry'), findsNothing);

    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();
    expect(find.text('A001'), findsOneWidget);
    expect(find.text('0 people ahead'), findsOneWidget);
    expect(find.text('About 0 minutes'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();
    expect(find.text('A002'), findsOneWidget);
    expect(find.text('1 person ahead'), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(TokenScreen),
        matching: find.text('About 5 minutes'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('Staff calls A001, marks it served, then calls A002', (
    tester,
  ) async {
    await tester.pumpWidget(const BranchQApp());
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Customer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Central Branch'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cash'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

    expect(find.text('Central Branch'), findsOneWidget);
    expect(find.text('Counter 1'), findsOneWidget);
    expect(find.text('Counter 2'), findsOneWidget);

    await tester.tap(find.text('Counter 1'));
    await tester.pumpAndSettle();
    expect(find.text('No token yet'), findsOneWidget);

    await tester.tap(find.text('Call next'));
    await tester.pumpAndSettle();
    expect(find.text('A001'), findsOneWidget);

    await tester.tap(find.text('Served'));
    await tester.pumpAndSettle();
    expect(find.text('A001'), findsNothing);

    await tester.tap(find.text('Call next'));
    await tester.pumpAndSettle();
    expect(find.text('A002'), findsOneWidget);
  });
}
