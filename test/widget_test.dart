import 'package:branchq/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Customer path reaches the sample token', (tester) async {
    await tester.pumpWidget(const BranchQApp());

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

  testWidgets('Staff path reaches the counter', (tester) async {
    await tester.pumpWidget(const BranchQApp());

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Staff'));
    await tester.pumpAndSettle();

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
  });
}
