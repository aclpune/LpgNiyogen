import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetManagerDashboarDetailModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerSingleItemUI/CDCMSStockItemUI.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';

GetManagerDashboarDetailModel _buildModel({
  String itemName = '14.2 KG',
  num filledDiff = 10,
  num emptyDiff = 20,
  num defectiveDiff = 2,
}) =>
    GetManagerDashboarDetailModel(
      itemName: itemName,
      filledDiff: filledDiff,
      emptyDiff: emptyDiff,
      defectiveDiff: defectiveDiff,
    );

Widget _buildWidget({required bool isLastItem, GetManagerDashboarDetailModel? model}) =>
    MaterialApp(
      home: Scaffold(body: CDCMSStockItemUI(model ?? _buildModel(), isLastItem: isLastItem)),
    );

void main() {
  group('CDCMSStockItemUI', () {
    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(CDCMSStockItemUI(_buildModel(), isLastItem: true), isA<StatefulWidget>());
    });

    testWidgets('renders filledDiff', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: _buildModel(filledDiff: 10)));
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('renders emptyDiff', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: _buildModel(emptyDiff: 20)));
      expect(find.text('20'), findsOneWidget);
    });

    testWidgets('renders defectiveDiff', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: _buildModel(defectiveDiff: 2)));
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('renders itemName', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: _buildModel(itemName: '14.2 KG')));
      expect(find.text('14.2 KG'), findsOneWidget);
    });

    testWidgets('renders F E D labels', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(find.text('F'), findsOneWidget);
      expect(find.text('E'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
    });

    testWidgets('renders all stats together', (tester) async {
      await tester.pumpWidget(_buildWidget(
        isLastItem: true,
        model: _buildModel(filledDiff: 5, emptyDiff: 15, defectiveDiff: 3),
      ));
      expect(find.text('5'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders different itemName', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: _buildModel(itemName: '19 KG')));
      expect(find.text('19 KG'), findsOneWidget);
      expect(find.text('14.2 KG'), findsNothing);
    });

    testWidgets('renders three zeros when all diffs are 0', (tester) async {
      await tester.pumpWidget(_buildWidget(
        isLastItem: true,
        model: _buildModel(filledDiff: 0, emptyDiff: 0, defectiveDiff: 0),
      ));
      expect(find.text('0'), findsNWidgets(3));
    });

    testWidgets('renders negative diff', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: _buildModel(filledDiff: -2)));
      expect(find.text('-2'), findsOneWidget);
    });

    testWidgets('trailing divider present when isLastItem=false', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: false));
      final match = find.byWidgetPredicate(
          (w) => (w is ColoredBox && w.color == AppColors.border2) ||
              (w is Container && w.color == AppColors.border2));
      expect(match.evaluate().isNotEmpty, isTrue);
    });

    testWidgets('trailing divider absent when isLastItem=true', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      final match = find.byWidgetPredicate(
          (w) => (w is ColoredBox && w.color == AppColors.border2) ||
              (w is Container && w.color == AppColors.border2));
      expect(match.evaluate().isEmpty, isTrue);
    });

    testWidgets('two internal stat dividers use AppColors.border', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      final divs = find.byWidgetPredicate((w) =>
          (w is ColoredBox && w.color == AppColors.border) ||
          (w is Container && w.color == AppColors.border));
      expect(divs.evaluate().length, greaterThanOrEqualTo(2));
    });

    testWidgets('outer Padding is EdgeInsets.all(10)', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(
          find.byWidgetPredicate((w) => w is Padding && w.padding == const EdgeInsets.all(10.0)),
          findsOneWidget);
    });

    testWidgets('stat cells have EdgeInsets.all(7) padding (3 cells)', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      final statPaddings = find.byWidgetPredicate(
          (w) => w is Padding && w.padding == const EdgeInsets.all(7.0));
      expect(statPaddings.evaluate().length, greaterThanOrEqualTo(3));
    });

    testWidgets('SizedBox(height:5) spacing present', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(find.byWidgetPredicate((w) => w is SizedBox && w.height == 5), findsWidgets);
    });

    testWidgets('isLastItem=true stored on widget', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(tester.widget<CDCMSStockItemUI>(find.byType(CDCMSStockItemUI)).isLastItem, isTrue);
    });

    testWidgets('isLastItem=false stored on widget', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: false));
      expect(tester.widget<CDCMSStockItemUI>(find.byType(CDCMSStockItemUI)).isLastItem, isFalse);
    });

    testWidgets('filteredSales itemName propagated', (tester) async {
      final model = _buildModel(itemName: 'Test Item');
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: model));
      expect(tester.widget<CDCMSStockItemUI>(find.byType(CDCMSStockItemUI)).filteredSales.itemName,
          'Test Item');
    });

    testWidgets('can be disposed without error', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      await tester.pumpWidget(const SizedBox());
    });
  });
}

