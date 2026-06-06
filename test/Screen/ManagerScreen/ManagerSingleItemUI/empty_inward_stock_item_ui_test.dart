import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetCurrentStockDetailManagerModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerSingleItemUI/EmptyInwardStockItemUI.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

GetCurrentStockDetailManagerModel _buildModel({
  String itemName = '14.2 KG',
  num emptyTVCnt = 5,
}) =>
    GetCurrentStockDetailManagerModel(
      itemName: itemName,
      emptyTVCnt: emptyTVCnt,
    );

Widget _buildWidget({GetCurrentStockDetailManagerModel? model}) => MaterialApp(
      home: Scaffold(body: EmptyInwardStockItemUI(model ?? _buildModel())),
    );

void main() {
  group('EmptyInwardStockItemUI', () {
    setUpAll(() {
      SizeConfig().init(const BoxConstraints(maxWidth: 400, maxHeight: 800), Orientation.portrait);
    });

    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(_buildWidget());
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(EmptyInwardStockItemUI(_buildModel()), isA<StatefulWidget>());
    });

    testWidgets('renders emptyTVCnt value', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(emptyTVCnt: 5)));
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('renders itemName', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(itemName: '14.2 KG')));
      expect(find.text('14.2 KG'), findsOneWidget);
    });

    testWidgets('renders zero emptyTVCnt', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(emptyTVCnt: 0)));
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('renders different itemName', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(itemName: '19 KG')));
      expect(find.text('19 KG'), findsOneWidget);
      expect(find.text('14.2 KG'), findsNothing);
    });

    testWidgets('renders large emptyTVCnt', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(emptyTVCnt: 999)));
      expect(find.text('999'), findsOneWidget);
    });

    testWidgets('renders a Card widget', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.byType(Card), findsOneWidget);
    });

    testWidgets('renders a Column inside Card', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('renders inner Padding with EdgeInsets.all(8)', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(
        find.byWidgetPredicate((w) => w is Padding && w.padding == const EdgeInsets.all(8.0)),
        findsWidgets,
      );
    });

    testWidgets('filteredSales emptyTVCnt propagated to widget', (tester) async {
      final model = _buildModel(emptyTVCnt: 42);
      await tester.pumpWidget(_buildWidget(model: model));
      expect(
        tester.widget<EmptyInwardStockItemUI>(find.byType(EmptyInwardStockItemUI))
            .filteredSales
            .emptyTVCnt,
        42,
      );
    });

    testWidgets('can be disposed without error', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pumpWidget(const SizedBox());
    });
  });
}
