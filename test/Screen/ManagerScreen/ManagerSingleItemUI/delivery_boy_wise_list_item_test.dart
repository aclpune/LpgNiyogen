import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/DailySaleSaummaryListModel.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerSingleItemUI/DeliveryBoyWiseListItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

DailySaleSaummaryListModel _buildModel({
  String staffName = 'Rahul',
  String statusStr = 'Accepted',
  num totalSVQty = 2,
  num totalTVQty = 0,
  num totalFilledQty = 43,
  num totalDefQty = 1,
  num totalActualSaleQty = 43,
  num totalAmt = 34636.50,
  num totRecievedcAmt = 34636.50,
  num dailySaleStatus = 2,
  num cashAmt = 0,
  num prepaidAmt = 0,
  num postPaidAmt = 0,
  num retiCrAmt = 0,
}) =>
    DailySaleSaummaryListModel(
      staffName: staffName,
      statusStr: statusStr,
      totalSVQty: totalSVQty,
      totalTVQty: totalTVQty,
      totalFilledQty: totalFilledQty,
      totalDefQty: totalDefQty,
      totalActualSaleQty: totalActualSaleQty,
      totalAmt: totalAmt,
      totRecievedcAmt: totRecievedcAmt,
      dailySaleStatus: dailySaleStatus,
      cashAmt: cashAmt,
      prepaidAmt: prepaidAmt,
      postPaidAmt: postPaidAmt,
      retiCrAmt: retiCrAmt,
    );

Widget _buildWidget({DailySaleSaummaryListModel? model}) => MaterialApp(
      home: Scaffold(
        body: DeliveryBoyWiseListItem(
          model ?? _buildModel(),
          enableNetworkCalls: false,
        ),
      ),
    );

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('DeliveryBoyWiseListItem', () {
    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(
        DeliveryBoyWiseListItem(
          _buildModel(),
          enableNetworkCalls: false,
        ),
        isA<StatefulWidget>(),
      );
    });

    testWidgets('renders staffName', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(staffName: 'Rahul')));
      await tester.pump();
      expect(find.text('Rahul'), findsOneWidget);
    });

    testWidgets('renders Status label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      expect(find.text('Status: '), findsOneWidget);
    });

    testWidgets('renders statusStr value', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(statusStr: 'Accepted')));
      await tester.pump();
      expect(find.text('Accepted'), findsOneWidget);
    });

    testWidgets('renders SV TV Sale Def Act.Sale column labels', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      expect(find.text('SV'), findsOneWidget);
      expect(find.text('TV'), findsOneWidget);
      expect(find.text('Sale'), findsOneWidget);
      expect(find.text('Def.'), findsOneWidget);
      expect(find.text('Act. Sale'), findsOneWidget);
    });

    testWidgets('renders totalSVQty value', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(totalSVQty: 2)));
      await tester.pump();
      expect(find.text('2'), findsWidgets);
    });

    testWidgets('renders Total Amt. label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      expect(find.text('Total Amt.: '), findsOneWidget);
    });

    testWidgets('renders Rcvd. Amt. label', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      expect(find.text('Rcvd. Amt.: '), findsOneWidget);
    });

    testWidgets('renders View More toggle initially', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      expect(find.text('View More'), findsOneWidget);
    });

    testWidgets('toggles to View Less after tapping View More', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      await tester.tap(find.text('View More'));
      await tester.pump();
      expect(find.text('View Less'), findsOneWidget);
    });

    testWidgets('shows payment breakdown after expanding', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      await tester.tap(find.text('View More'));
      await tester.pump();
      expect(find.text('Cash'), findsOneWidget);
      expect(find.text('Online/Prepaid'), findsOneWidget);
      expect(find.text('Merchant QR'), findsOneWidget);
      expect(find.text('Credit'), findsOneWidget);
    });

    testWidgets('hides payment breakdown after collapse', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      await tester.tap(find.text('View More'));
      await tester.pump();
      await tester.tap(find.text('View Less'));
      await tester.pump();
      expect(find.text('View More'), findsOneWidget);
      expect(find.text('Cash'), findsNothing);
    });

    testWidgets('shows Update for dailySaleStatus=2', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(dailySaleStatus: 2)));
      await tester.pump();
      expect(find.text('Update'), findsOneWidget);
    });

    testWidgets('shows Accept for dailySaleStatus=1', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(dailySaleStatus: 1)));
      await tester.pump();
      expect(find.text('Accept'), findsOneWidget);
    });

    testWidgets('shows Correction button for non-terminal status', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(dailySaleStatus: 2)));
      await tester.pump();
      expect(find.text('Correction'), findsOneWidget);
    });

    testWidgets('filteredSales staffName propagated to widget', (tester) async {
      final model = _buildModel(staffName: 'Test Staff');
      await tester.pumpWidget(_buildWidget(model: model));
      await tester.pump();
      expect(
          tester.widget<DeliveryBoyWiseListItem>(find.byType(DeliveryBoyWiseListItem))
              .filteredSales
              .staffName,
          'Test Staff');
    });

    testWidgets('different staffName rendered correctly', (tester) async {
      await tester.pumpWidget(_buildWidget(model: _buildModel(staffName: 'Suresh')));
      await tester.pump();
      expect(find.text('Suresh'), findsOneWidget);
      expect(find.text('Rahul'), findsNothing);
    });

    testWidgets('can be disposed without error', (tester) async {
      await tester.pumpWidget(_buildWidget());
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
    });
  });
}

