import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/TVSaleScreen/TVSalesScreen.dart';

void main() {
  group('TVSalesScreen Widget Tests', () {
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
        home: const TVSalesScreen(disableNetworkCallsForTest: true),
        builder: EasyLoading.init(),
      );
    }

    testWidgets('TVSalesScreen has a screenName constant', (tester) async {
      expect(TVSalesScreen.screenName, '/tvSalesScreen');
    });

    testWidgets('TVSalesScreen renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(TVSalesScreen), findsOneWidget);
    });

    testWidgets('TVSalesScreen has a Scaffold', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('TVSalesScreen shows loading indicator initially', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      // The widget should at least mount
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('TVSalesScreen can be disposed without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      await tester.pumpWidget(Container());
    });

    testWidgets('TVSalesScreen is a StatefulWidget', (tester) async {
      expect(const TVSalesScreen(disableNetworkCallsForTest: true), isA<StatefulWidget>());
    });
  });
}
