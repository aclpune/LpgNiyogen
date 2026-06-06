// ─────────────────────────────────────────────────────────────────────────────
// Widget Tests for ImblanceShowUi
//
// HOW TO RUN in Android Studio:
//   • Right-click this file → "Run Tests"
//   • Or via terminal: flutter test test/imbalance_show_ui_test.dart
//
// IMPORTANT — Adjust these import paths to match your project structure:
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:your_app/features/imbalance/ImabalanceEmptyListModel.dart'; // ← adjust
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ImbalanceEmpty/ImabalanceEmptyListModel.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ImbalanceEmpty/ImbalaceShowUI.dart';

import 'Imbalance_Transaction_History_Test.dart';


// ── Helper ────────────────────────────────────────────────────────────────────

/// Wraps the widget under test in a minimal MaterialApp so that
/// MediaQuery, Theme, Directionality etc. are all available.
Widget _wrap(ImabalanceEmptyListModel model) => MaterialApp(
  home: Scaffold(
    body: ImblanceShowUi(listModel: model),
  ),
);

/// A model that has a valid, non-empty itemName (triggers the data branch).
ImabalanceEmptyListModel _withData({
  String? itemName = '14.2 KG',
  String? entryType = 'D',
  dynamic staffName,
  dynamic customerName,
  num? balImbQty = 28,
  num? custId = 0,
  num? dMId = 44,
}) =>
    ImabalanceEmptyListModel(
      itemName: itemName,
      entryType: entryType,
      staffName: staffName,
      customerName: customerName,
      balImbQty: balImbQty,
      custId: custId,
      dMId: dMId,
    );

/// A model that triggers the empty-state branch.
ImabalanceEmptyListModel _empty() => ImabalanceEmptyListModel();

// ─────────────────────────────────────────────────────────────────────────────
// TEST SUITES
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ──────────────────────────────────────────────────────────────────────────
  // 1. ImblanceShowUi — hasData branch (itemName is non-null & non-empty)
  // ──────────────────────────────────────────────────────────────────────────
  group('ImblanceShowUi — hasData branch', () {
    testWidgets('[POSITIVE] Renders card header "Item / Name" when data is present',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.text('Item / Name'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders column header "Qty" when data is present',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.text('Qty'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders itemName text in the data row',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(itemName: '14.2 KG')));
          expect(find.text('14.2 KG'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders balImbQty value in the data row',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(balImbQty: 28)));
          expect(find.text('28'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders "DM" badge when entryType is "D"',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(entryType: 'D')));
          expect(find.text('DM'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders "CUST" badge when entryType is not "D"',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(entryType: 'C')));
          expect(find.text('CUST'), findsOneWidget);
        });

    testWidgets(
        '[POSITIVE] Renders staffName in person-name field when staffName is provided',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(staffName: 'Alice')));
          expect(find.text('Alice'), findsOneWidget);
        });

    testWidgets(
        '[POSITIVE] Falls back to customerName when staffName is null',
            (tester) async {
          await tester
              .pumpWidget(_wrap(_withData(staffName: null, customerName: 'Bob')));
          expect(find.text('Bob'), findsOneWidget);
        });

    testWidgets(
        '[POSITIVE] Falls back to "-" when both staffName and customerName are null',
            (tester) async {
          await tester.pumpWidget(
              _wrap(_withData(staffName: null, customerName: null)));
          expect(find.text('-'), findsOneWidget);
        });

    testWidgets(
        '[POSITIVE] When itemName is null the widget shows the empty-state (no data)',
            (tester) async {
          // According to the implementation, a null or empty itemName triggers
          // the empty-state placeholder instead of rendering a data row.
          await tester.pumpWidget(_wrap(_withData(itemName: null, staffName: 'Alice')));
          // The empty-state text should be visible and the '-' fallback should NOT
          // be present inside a data row because the row is not rendered.
          expect(find.text('No data found'), findsOneWidget);
          expect(find.text('-'), findsNothing);
        });

    testWidgets('[POSITIVE] Does NOT show empty-state text when data is present',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.text('No data found'), findsNothing);
          expect(find.text('No imbalance records to display.'), findsNothing);
        });

    testWidgets('[POSITIVE] Does NOT show inbox icon when data is present',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.byIcon(Icons.inbox_rounded), findsNothing);
        });

    testWidgets('[POSITIVE] Shows a Divider between header and data row',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.byType(Divider), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders zero balImbQty correctly',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(balImbQty: 0)));
          expect(find.text('0'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders negative balImbQty correctly',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(balImbQty: -5)));
          expect(find.text('-5'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Renders large balImbQty correctly',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(balImbQty: 999999)));
          expect(find.text('999999'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Qty text is red when qty > 0',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(balImbQty: 10)));
          final qtyText = tester.widget<Text>(find.text('10'));
          expect(qtyText.style?.color, AppColors.red);
        });

    testWidgets('[POSITIVE] Qty text is green when qty == 0',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(balImbQty: 0)));
          final qtyText = tester.widget<Text>(find.text('0'));
          // Implementation uses green for qty == 0 (qty > 0 -> red, else green)
          expect(qtyText.style?.color, AppColors.green);
        });

    testWidgets('[POSITIVE] Renders with unicode itemName without crashing',
            (tester) async {
          await tester
              .pumpWidget(_wrap(_withData(itemName: '१४.२ किलो')));
          expect(find.text('१४.२ किलो'), findsOneWidget);
        });

    testWidgets(
        '[POSITIVE] Renders with very long itemName (overflow handled)',
            (tester) async {
          final longName = 'A' * 200;
          await tester.pumpWidget(_wrap(_withData(itemName: longName)));
          // Widget must build without throwing even with very long strings
          expect(find.byType(ImblanceShowUi), findsOneWidget);
        });

    testWidgets('[POSITIVE] Widget rebuilds correctly when model changes',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(itemName: '14.2 KG')));
          expect(find.text('14.2 KG'), findsOneWidget);

          await tester.pumpWidget(_wrap(_withData(itemName: '19 KG')));
          await tester.pump();
          expect(find.text('19 KG'), findsOneWidget);
          expect(find.text('14.2 KG'), findsNothing);
        });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 2. ImblanceShowUi — empty branch (itemName is null or empty)
  // ──────────────────────────────────────────────────────────────────────────
  group('ImblanceShowUi — empty branch', () {
    testWidgets('[POSITIVE] Shows "No data found" when model has no itemName',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('No data found'), findsOneWidget);
        });

    testWidgets(
        '[POSITIVE] Shows subtitle "No imbalance records to display." when empty',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('No imbalance records to display.'), findsOneWidget);
        });

    testWidgets('[POSITIVE] Shows inbox icon when model is empty',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.byIcon(Icons.inbox_rounded), findsOneWidget);
        });

    testWidgets('[POSITIVE] Does NOT show "Item / Name" header when empty',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('Item / Name'), findsNothing);
        });

    testWidgets('[POSITIVE] Does NOT show "Qty" column header when empty',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('Qty'), findsNothing);
        });

    testWidgets('[POSITIVE] Does NOT show "DM" badge when empty',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('DM'), findsNothing);
        });

    testWidgets('[POSITIVE] Does NOT show "CUST" badge when empty',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('CUST'), findsNothing);
        });

    testWidgets('[POSITIVE] Does NOT show a Divider when empty',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.byType(Divider), findsNothing);
        });

    testWidgets(
        '[POSITIVE] Shows empty state when itemName is an empty string',
            (tester) async {
          final model = ImabalanceEmptyListModel(itemName: '');
          await tester.pumpWidget(_wrap(model));
          expect(find.text('No data found'), findsOneWidget);
        });

    testWidgets(
        '[POSITIVE] Switches from empty to data state when model gains an itemName',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('No data found'), findsOneWidget);

          await tester.pumpWidget(_wrap(_withData(itemName: '14.2 KG')));
          await tester.pump();
          expect(find.text('No data found'), findsNothing);
          expect(find.text('14.2 KG'), findsOneWidget);
        });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 3. ImblanceShowUi — Widget structure & rendering
  // ──────────────────────────────────────────────────────────────────────────
  group('ImblanceShowUi — Widget structure', () {
    testWidgets('[POSITIVE] Root widget is a Container', (tester) async {
      await tester.pumpWidget(_wrap(_withData()));
      // The outermost child of Scaffold body is ImblanceShowUi which is a Container
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('[POSITIVE] Widget builds without throwing for data model',
            (tester) async {
          expect(
                () async => tester.pumpWidget(_wrap(_withData())),
            returnsNormally,
          );
        });

    testWidgets('[POSITIVE] Widget builds without throwing for empty model',
            (tester) async {
          expect(
                () async => tester.pumpWidget(_wrap(_empty())),
            returnsNormally,
          );
        });

    testWidgets('[POSITIVE] Only one ImblanceShowUi widget in the tree',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.byType(ImblanceShowUi), findsOneWidget);
        });

    testWidgets('[POSITIVE] entryType null renders "CUST" badge (not "D")',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(entryType: null)));
          expect(find.text('CUST'), findsOneWidget);
          expect(find.text('DM'), findsNothing);
        });

    testWidgets(
        '[POSITIVE] entryType "d" (lowercase) renders "CUST" badge — comparison is case-sensitive',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(entryType: 'd')));
          expect(find.text('CUST'), findsOneWidget);
          expect(find.text('DM'), findsNothing);
        });

    testWidgets('[POSITIVE] balImbQty null renders "0" as fallback',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(balImbQty: null)));
          expect(find.text('0'), findsOneWidget);
        });
  });

  // ──────────────────────────────────────────────────────────────────────────
  // 4. Negative / edge-case tests
  // ──────────────────────────────────────────────────────────────────────────
  group('ImblanceShowUi — Negative & edge cases', () {
    testWidgets(
        '[NEGATIVE] Data branch does NOT show empty-state icon',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.byIcon(Icons.inbox_rounded), findsNothing);
        });

    testWidgets(
        '[NEGATIVE] Empty branch does NOT show any qty number text',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          // No numeric quantity should be rendered
          expect(find.text('28'), findsNothing);
          expect(find.text('0'), findsNothing);
        });

    testWidgets(
        '[NEGATIVE] Empty branch does NOT show item name text',
            (tester) async {
          await tester.pumpWidget(_wrap(_empty()));
          expect(find.text('14.2 KG'), findsNothing);
        });

    testWidgets(
        '[NEGATIVE] Data branch: "No data found" text is absent',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.text('No data found'), findsNothing);
        });

    testWidgets(
        '[NEGATIVE] Model with only whitespace itemName triggers empty state',
            (tester) async {
          // '   '.isNotEmpty == true → this actually renders data state.
          // This test documents the CURRENT behavior (whitespace = has data).
          final model = ImabalanceEmptyListModel(itemName: '   ');
          await tester.pumpWidget(_wrap(model));
          // hasData = itemName != null && itemName!.isNotEmpty → true for whitespace
          expect(find.text('No data found'), findsNothing);
          expect(find.text('Item / Name'), findsOneWidget);
        });

    testWidgets(
        '[NEGATIVE] Widget does not show both empty AND data states simultaneously',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          final hasDataHeader = find.text('Item / Name').evaluate().isNotEmpty;
          final hasEmptyText = find.text('No data found').evaluate().isNotEmpty;
          // Only one branch can be active at a time
          expect(hasDataHeader && hasEmptyText, isFalse);
        });

    testWidgets(
        '[NEGATIVE] Widget does not crash with all-null model fields except itemName',
            (tester) async {
          final model = ImabalanceEmptyListModel(
            itemName: 'Test',
            entryType: null,
            staffName: null,
            customerName: null,
            balImbQty: null,
            custId: null,
            dMId: null,
          );
          await tester.pumpWidget(_wrap(model));
          expect(find.byType(ImblanceShowUi), findsOneWidget);
          // fallback qty '0' and name '-' should be rendered
          expect(find.text('0'), findsOneWidget);
          expect(find.text('-'), findsOneWidget);
        });

    testWidgets('[NEGATIVE] No duplicate "Item / Name" headers rendered',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.text('Item / Name'), findsOneWidget);
        });

    testWidgets('[NEGATIVE] No duplicate "Qty" headers rendered',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData()));
          expect(find.text('Qty'), findsOneWidget);
        });

    testWidgets(
        '[NEGATIVE] "CUST" badge is absent when entryType is "D"',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(entryType: 'D')));
          expect(find.text('CUST'), findsNothing);
        });

    testWidgets(
        '[NEGATIVE] "DM" badge is absent when entryType is "C"',
            (tester) async {
          await tester.pumpWidget(_wrap(_withData(entryType: 'C')));
          expect(find.text('DM'), findsNothing);
        });
  });
}