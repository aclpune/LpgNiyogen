import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerSingleItemUI/FilledInwardStockItemUI.dart';

GetCurrentStockDetailManagerModel _buildModel({
  String itemName = '14.2 KG',
  num totalInvoiceCnt = 324,
  num filledEMRCnt = 10,
}) =>
    GetCurrentStockDetailManagerModel(
      itemName: itemName,
      totalInvoiceCnt: totalInvoiceCnt,
      filledEMRCnt: filledEMRCnt,
    );

Widget _buildWidget({GetCurrentStockDetailManagerModel? model}) => MaterialApp(
      home: Scaffold(body: FilledInwardStockItemUI(model ?? _buildModel())),
    );

void main() {
  group('FilledInwardStockItemUI', () {
    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(_buildWidget());
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(FilledInwardStockItemUI(_buildModel()), isA<StatefulWidget>());
    });

    testWidgets('renders totalInvoiceCnt', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(totalInvoiceCnt: 324)));
      expect(find.text('324'), findsOneWidget);
    });

    testWidgets('renders filledEMRCnt', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(filledEMRCnt: 10)));
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('renders itemName', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(itemName: '14.2 KG')));
      expect(find.text('14.2 KG'), findsOneWidget);
    });

    testWidgets('renders both counts together', (tester) async {
      await tester.pumpWidget(_buildWidget(
          model: _buildModel(totalInvoiceCnt: 100, filledEMRCnt: 5)));
      expect(find.text('100'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('renders different itemName', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(itemName: '5 KG')));
      expect(find.text('5 KG'), findsOneWidget);
      expect(find.text('14.2 KG'), findsNothing);
    });

    testWidgets('renders zero values', (tester) async {
      await tester.pumpWidget(
          _buildWidget(model: _buildModel(totalInvoiceCnt: 0, filledEMRCnt: 0)));
      expect(find.text('0'), findsNWidgets(2));
    });

    testWidgets('renders a Card widget', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('card has elevation 4', (tester) async {
      await tester.pumpWidget(_buildWidget());
      final card = tester.widget<Card>(find.byType(Card));
      expect(card.elevation, 4);
    });

    testWidgets('contains inner Padding with EdgeInsets.all(8)', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(
        find.byWidgetPredicate((w) => w is Padding && w.padding == const EdgeInsets.all(8.0)),
        findsWidgets,
      );
    });

    testWidgets('filteredSales totalInvoiceCnt propagated', (tester) async {
      final model = _buildModel(totalInvoiceCnt: 77);
      await tester.pumpWidget(_buildWidget(model: model));
      expect(
        tester.widget<FilledInwardStockItemUI>(find.byType(FilledInwardStockItemUI))
            .filteredSales
            .totalInvoiceCnt,
        77,
      );
    });

    testWidgets('filteredSales filledEMRCnt propagated', (tester) async {
      final model = _buildModel(filledEMRCnt: 33);
      await tester.pumpWidget(_buildWidget(model: model));
      expect(
        tester.widget<FilledInwardStockItemUI>(find.byType(FilledInwardStockItemUI))
            .filteredSales
            .filledEMRCnt,
        33,
      );
    });

    testWidgets('can be disposed without error', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pumpWidget(const SizedBox());
    });
  });
}

