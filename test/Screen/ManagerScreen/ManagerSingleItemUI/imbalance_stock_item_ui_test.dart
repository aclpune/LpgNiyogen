import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetManagerDashboarDetailModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerSingleItemUI/ImbalanceStockItemUI.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';

GetManagerDashboarDetailModel _buildModel({
  String itemName = '14.2 KG',
  num todayImbQty = 3,
  num asOfDateImbQty = 172,
  num? itemId = 1,
}) =>
    GetManagerDashboarDetailModel(
      itemName: itemName,
      todayImbQty: todayImbQty,
      asOfDateImbQty: asOfDateImbQty,
      itemId: itemId,
    );

Widget _buildWidget({
  required bool isLastItem,
  GetManagerDashboarDetailModel? model,
  Map<String, Widget Function(BuildContext)>? routes,
}) =>
    MaterialApp(
      routes: routes ?? {},
      home: Scaffold(body: ImbalanceStockItemUI(model ?? _buildModel(), isLastItem: isLastItem)),
    );

void main() {
  group('ImbalanceStockItemUI', () {
    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(ImbalanceStockItemUI(_buildModel(), isLastItem: true), isA<StatefulWidget>());
    });

    testWidgets('renders todayImbQty', (tester) async {
      await tester.pumpWidget(
          _buildWidget(isLastItem: true, model: _buildModel(todayImbQty: 3)));
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders asOfDateImbQty', (tester) async {
      await tester.pumpWidget(
          _buildWidget(isLastItem: true, model: _buildModel(asOfDateImbQty: 172)));
      expect(find.text('172'), findsOneWidget);
    });

    testWidgets('renders itemName', (tester) async {
      await tester.pumpWidget(
          _buildWidget(isLastItem: true, model: _buildModel(itemName: '14.2 KG')));
      expect(find.text('14.2 KG'), findsOneWidget);
    });

    testWidgets('renders both qty values together', (tester) async {
      await tester.pumpWidget(_buildWidget(
        isLastItem: true,
        model: _buildModel(todayImbQty: 7, asOfDateImbQty: 200),
      ));
      expect(find.text('7'), findsOneWidget);
      expect(find.text('200'), findsOneWidget);
    });

    testWidgets('renders zero today imbalance qty', (tester) async {
      await tester.pumpWidget(
          _buildWidget(isLastItem: true, model: _buildModel(todayImbQty: 0)));
      expect(find.text('0'), findsWidgets);
    });

    testWidgets('renders different itemName', (tester) async {
      await tester.pumpWidget(
          _buildWidget(isLastItem: true, model: _buildModel(itemName: '19 KG')));
      expect(find.text('19 KG'), findsOneWidget);
      expect(find.text('14.2 KG'), findsNothing);
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

    testWidgets('contains GestureDetector for navigation', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('contains Expanded widget', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(find.byType(Expanded), findsWidgets);
    });

    testWidgets('SizedBox(height:15) spacing present', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(find.byWidgetPredicate((w) => w is SizedBox && w.height == 15), findsWidgets);
    });

    testWidgets('isLastItem=true stored on widget', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      expect(
          tester.widget<ImbalanceStockItemUI>(find.byType(ImbalanceStockItemUI)).isLastItem,
          isTrue);
    });

    testWidgets('isLastItem=false stored on widget', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: false));
      expect(
          tester.widget<ImbalanceStockItemUI>(find.byType(ImbalanceStockItemUI)).isLastItem,
          isFalse);
    });

    testWidgets('filteredSales itemName propagated', (tester) async {
      final model = _buildModel(itemName: 'Prop Test');
      await tester.pumpWidget(_buildWidget(isLastItem: true, model: model));
      expect(
          tester.widget<ImbalanceStockItemUI>(find.byType(ImbalanceStockItemUI))
              .filteredSales
              .itemName,
          'Prop Test');
    });

    testWidgets('can be disposed without error', (tester) async {
      await tester.pumpWidget(_buildWidget(isLastItem: true));
      await tester.pumpWidget(const SizedBox());
    });
  });
}

