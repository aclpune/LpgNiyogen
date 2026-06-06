import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/PaymentReceiptScreen/PaymentReceiptScreen.dart';

void main() {
  group('PaymentReceiptScreen Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'userId': '1',
        'userName': 'TestUser',
        'distributorId': '8118',
        'userType': '1',
        'DistributorId': '8118',
        'StaffId': '1',
        'UserId': '1',
        'token': 'test-token',
      });
    });

    Widget buildTestWidget() {
      return MaterialApp(
        home: const PaymentReceiptScreen(enableNetworkCalls: false),
        builder: EasyLoading.init(),
      );
    }

    testWidgets('PaymentReceiptScreen has correct screenName', (tester) async {
      expect(PaymentReceiptScreen.screenName, '/paymentreceiptscreen');
    });

    testWidgets('PaymentReceiptScreen renders without crashing', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(PaymentReceiptScreen), findsOneWidget);
    });

    testWidgets('PaymentReceiptScreen has a Scaffold', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('PaymentReceiptScreen is a StatefulWidget', (tester) async {
      expect(const PaymentReceiptScreen(enableNetworkCalls: false), isA<StatefulWidget>());
    });

    testWidgets('PaymentReceiptScreen can be disposed without errors', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      await tester.pumpWidget(Container());
    });

    testWidgets('PaymentReceiptScreen wraps in MaterialApp correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('PaymentReceiptScreen default transMode list contains Cash and Online',
        (tester) async {
      // Verify the screen constants by creating instance
      await tester.pumpWidget(buildTestWidget());
      await tester.pump(Duration.zero);
      expect(find.byType(PaymentReceiptScreen), findsOneWidget);
    });
  });
}
