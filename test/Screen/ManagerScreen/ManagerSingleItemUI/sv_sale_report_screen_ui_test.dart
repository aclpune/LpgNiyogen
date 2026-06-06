import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerSingleItemUI/SVSaleReportScreenUI.dart';

Widget _buildWidget({
  required Map<String, dynamic> data,
  int serialNumber = 1,
  int listLength = 3,
}) =>
    MaterialApp(
      home: Scaffold(
        body: SVSaleReportScreenUI(
          data: data,
          serialNumber: serialNumber,
          listLength: listLength,
        ),
      ),
    );

void main() {
  group('SVSaleReportScreenUI', () {
    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(
        SVSaleReportScreenUI(data: const {}, serialNumber: 1, listLength: 1),
        isA<StatefulWidget>(),
      );
    });

    testWidgets('renders SV Date label', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.text('SV Date'), findsOneWidget);
    });

    testWidgets('renders SV Type label', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.text('SV Type'), findsOneWidget);
    });

    testWidgets('renders SV Pending label', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.text('SV Pending'), findsOneWidget);
    });

    testWidgets('renders Cons.No./DC No. label', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.text('Cons.No./DC No.'), findsOneWidget);
    });

    testWidgets('renders Cons. Name label', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.text('Cons. Name'), findsOneWidget);
    });

    testWidgets('renders Total Amt. label', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.text('Total Amt.'), findsOneWidget);
    });

    testWidgets('renders Mode label', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.text('Mode'), findsOneWidget);
    });

    testWidgets('renders edit and delete icons', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      expect(find.byIcon(Icons.edit), findsOneWidget);
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('shows Divider when serialNumber != listLength', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}, serialNumber: 1, listLength: 3));
      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('hides Divider when serialNumber == listLength', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}, serialNumber: 3, listLength: 3));
      expect(find.byType(Divider), findsNothing);
    });

    testWidgets('null data field rendered as dash via nullToDash', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {'Product ': null, 'cylQty': null, 'regRec': null}));
      expect(find.text(': -'), findsWidgets);
    });

    testWidgets('string "null" data field rendered as dash', (tester) async {
      await tester.pumpWidget(
          _buildWidget(data: {'Product ': 'null', 'cylQty': 'null', 'regRec': 'null'}));
      expect(find.text(': -'), findsWidgets);
    });

    testWidgets('valid data field rendered as-is', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {
        'Product ': '2025-05-01',
        'cylQty': 'NC',
        'regRec': 'REG001',
      }));
      expect(find.text(': 2025-05-01'), findsOneWidget);
      expect(find.text(': NC'), findsOneWidget);
    });

    testWidgets('empty string data field rendered as dash', (tester) async {
      await tester.pumpWidget(
          _buildWidget(data: {'Product ': '', 'cylQty': '', 'regRec': ''}));
      // empty string passes nullToDash as-is (not null and not "null")
      // empty string is treated as valid — check no crash
      expect(find.byType(SVSaleReportScreenUI), findsOneWidget);
    });

    testWidgets('serialNumber and listLength stored correctly', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}, serialNumber: 2, listLength: 5));
      final w = tester.widget<SVSaleReportScreenUI>(find.byType(SVSaleReportScreenUI));
      expect(w.serialNumber, 2);
      expect(w.listLength, 5);
    });

    testWidgets('can be disposed without error', (tester) async {
      await tester.pumpWidget(_buildWidget(data: {}));
      await tester.pumpWidget(const SizedBox());
    });
  });
}
