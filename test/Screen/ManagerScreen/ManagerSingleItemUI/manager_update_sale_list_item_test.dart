import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerSingleItemUI/ManagerUpdateSaleListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

DilySaleSummaryDeliveryBoyWiseListModel _buildModel({
  String itemName = '14.2 KG',
  String staffName = 'Rahul',
  String userName = 'user1',
  num gDFilledSale = 20,
  num actualSaleQty = 18,
  num tVQty = 0,
  num sVQty = 2,
  num deffQty = 0,
  num amount = 15399.0,
  num cashQty = 0,
  num cashAmt = 0,
  num prepaidQty = 0,
  num prepaidAmt = 0,
  num postQty = 0,
  num postAmt = 0,
  num creditQty = 0,
  num creditAmt = 0,
  num denoCashRcvd = 0,
  num denoCashExptd = 0,
  num dailySaleStatus = 2,
  num? saleGKItemId = 1,
}) =>
    DilySaleSummaryDeliveryBoyWiseListModel(
      itemName: itemName,
      staffName: staffName,
      userName: userName,
      gDFilledSale: gDFilledSale,
      actualSaleQty: actualSaleQty,
      tVQty: tVQty,
      sVQty: sVQty,
      deffQty: deffQty,
      amount: amount,
      cashQty: cashQty,
      cashAmt: cashAmt,
      prepaidQty: prepaidQty,
      prepaidAmt: prepaidAmt,
      postQty: postQty,
      postAmt: postAmt,
      creditQty: creditQty,
      creditAmt: creditAmt,
      denoCashRcvd: denoCashRcvd,
      denoCashExptd: denoCashExptd,
      dailySaleStatus: dailySaleStatus,
      saleGKItemId: saleGKItemId,
    );

Widget _buildWidget({DilySaleSummaryDeliveryBoyWiseListModel? model}) => MaterialApp(
      home: Scaffold(
        body: ManagerUpdateSaleListItem(
          model ?? _buildModel(),
          101,
          'MH49KL7474',
          'REC001',
        ),
      ),
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('ManagerUpdateSaleListItem', () {
    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(_buildWidget());
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(
          ManagerUpdateSaleListItem(_buildModel(), 101, 'MH49KL7474', 'REC001'),
          isA<StatefulWidget>());
    });

    testWidgets('renders itemName', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(itemName: '14.2 KG')));
      expect(find.text('14.2 KG'), findsOneWidget);
    });

    testWidgets('renders userName', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(userName: 'user1')));
      expect(find.text('user1'), findsOneWidget);
    });

    testWidgets('renders Sale label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('Sale'), findsOneWidget);
    });

    testWidgets('renders TV label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('TV'), findsOneWidget);
    });

    testWidgets('renders Act.Sale label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('Act.Sale'), findsOneWidget);
    });

    testWidgets('renders Def. label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('Def.'), findsOneWidget);
    });

    testWidgets('renders SV: label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('SV:'), findsOneWidget);
    });

    testWidgets('renders Amount: label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('Amount:'), findsOneWidget);
    });

    testWidgets('renders Received Amt.: label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('Received Amt.:'), findsOneWidget);
    });

    testWidgets('renders View More toggle initially', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(find.text('View More'), findsOneWidget);
    });

    testWidgets('toggles to View Less after tap', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.tap(find.text('View More'));
      await tester.pump();
      expect(find.text('View Less'), findsOneWidget);
    });

    testWidgets('shows payment breakdown after expanding', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.tap(find.text('View More'));
      await tester.pump();
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Online/Prepaid'), findsOneWidget);
      expect(find.text('Merchant QR'), findsOneWidget);
      expect(find.text('Credit'), findsOneWidget);
    });

    testWidgets('collapses back to View More after second tap', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.tap(find.text('View More'));
      await tester.pump();
      await tester.tap(find.text('View Less'));
      await tester.pump();
      expect(find.text('View More'), findsOneWidget);
      expect(find.text('Cash'), findsNothing);
    });

    testWidgets('shows Update when all qty/amt are zero and actualSaleQty != 0',
        (tester) async {
      await tester.pumpWidget(_buildWidget(
        model: _buildModel(
          cashQty: 0,
          prepaidQty: 0,
          postQty: 0,
          creditQty: 0,
          cashAmt: 0,
          postAmt: 0,
          actualSaleQty: 18,
        ),
      ));
      expect(find.text('Update'), findsOneWidget);
    });

    testWidgets('shows Edit when cashQty != 0', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(cashQty: 5, cashAmt: 500)));
      expect(find.text('Edit'), findsOneWidget);
    });

    testWidgets('shows No Cash when actualSaleQty == 0', (tester) async {
      await tester.pumpWidget(_buildWidget(
        model: _buildModel(
          actualSaleQty: 0,
          cashQty: 0,
          prepaidQty: 0,
          postQty: 0,
          creditQty: 0,
          cashAmt: 0,
          postAmt: 0,
        ),
      ));
      expect(find.text('No Cash'), findsOneWidget);
    });

    testWidgets('formatCurrency shows 0.00 for zero amount', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(amount: 0)));
      expect(find.text('0.00'), findsWidgets);
    });

    testWidgets('filteredSales itemName propagated', (tester) async {
      final model = _buildModel(itemName: 'Prop Test');
      await tester.pumpWidget(_buildWidget(model: model));
      expect(
          tester
              .widget<ManagerUpdateSaleListItem>(find.byType(ManagerUpdateSaleListItem))
              .filteredSales
              .itemName,
          'Prop Test');
    });

    testWidgets('vehicleIDs propagated', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(
          tester
              .widget<ManagerUpdateSaleListItem>(find.byType(ManagerUpdateSaleListItem))
              .vehicleIDs,
          101);
    });

    testWidgets('vehicleNumber propagated', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(
          tester
              .widget<ManagerUpdateSaleListItem>(find.byType(ManagerUpdateSaleListItem))
              .vehicleNumber,
          'MH49KL7474');
    });

    testWidgets('receiptNoText propagated', (tester) async {
      await tester.pumpWidget(_buildWidget());
      expect(
          tester
              .widget<ManagerUpdateSaleListItem>(find.byType(ManagerUpdateSaleListItem))
              .receiptNoText,
          'REC001');
    });

    testWidgets('can be disposed without error', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pumpWidget(const SizedBox());
    });
  });
}

