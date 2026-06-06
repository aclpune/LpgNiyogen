import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleReportScreen.dart';

void main() {
  group('SVSaleReportScreen Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'UserId': '1',
        'StaffId': '1',
        'DistributorId': '8118',
        'token': 'test-token',
      });
    });

    Widget buildTestWidget() {
      return MaterialApp(
        home: const SVSaleReportScreen(disableNetworkCallsForTest: true),
        builder: EasyLoading.init(),
      );
    }

    test('SVSaleReportScreen has correct screenName constant', () {
      expect(SVSaleReportScreen.screenName, '/svSaleReportScreen');
    });

    testWidgets('SVSaleReportScreen renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(SVSaleReportScreen), findsOneWidget);
    });

    testWidgets('SVSaleReportScreen has a Scaffold', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('SVSaleReportScreen is a StatefulWidget', (tester) async {
      expect(const SVSaleReportScreen(), isA<StatefulWidget>());
    });

    testWidgets('SVSaleReportScreen can be disposed without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      await tester.pumpWidget(Container());
    });

    testWidgets('SVSaleReportScreen mounts inside MaterialApp', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('SVSaleReportScreen mounts state without throwing', (tester) async {
      bool threw = false;
      try {
        await tester.pumpWidget(buildTestWidget());
        await tester.pump(Duration.zero);
      } catch (_) {
        threw = true;
      }
      expect(threw, isFalse);
    });
  });
}
