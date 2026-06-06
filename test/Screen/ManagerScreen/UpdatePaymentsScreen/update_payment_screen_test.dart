import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/UpdatePaymentScreen.dart';

void main() {
  group('UpdatePaymentScreen Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'UserId': '1',
        'StaffId': '1',
        'StaffName': 'TestUser',
        'DistributorId': '8118',
        'token': 'test-token',
      });
    });

    Widget buildTestWidget() {
      return MaterialApp(
        home: const UpdatePaymentScreen(disableNetworkCallsForTest: true),
        builder: EasyLoading.init(),
      );
    }

    test('UpdatePaymentScreen has correct screenName constant', () {
      expect(UpdatePaymentScreen.screenName, '/updatePaymentScreen');
    });

    testWidgets('UpdatePaymentScreen renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(UpdatePaymentScreen), findsOneWidget);
    });

    testWidgets('UpdatePaymentScreen has a Scaffold', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('UpdatePaymentScreen is a StatefulWidget', (tester) async {
      expect(const UpdatePaymentScreen(disableNetworkCallsForTest: true), isA<StatefulWidget>());
    });

    testWidgets('UpdatePaymentScreen can be disposed without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      await tester.pumpWidget(Container());
    });

    testWidgets('UpdatePaymentScreen mounts inside MaterialApp', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('UpdatePaymentScreen mounts state without throwing', (tester) async {
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
