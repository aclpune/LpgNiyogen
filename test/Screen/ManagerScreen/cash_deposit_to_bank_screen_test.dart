 import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:lpgsalesandinventory/Screen/ManagerScreen/CashDepositToBankScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CashDepositToBankScreen', () {
    late MockClient mockClient;

    setUp(() {
      SharedPreferences.setMockInitialValues({
        'DistributorId': '8118',
        'token': 'test-token',
      });
      mockClient = MockClient((request) async {
        return http.Response('[]', 200);
      });
    });

    Widget buildWidget() {
      return MaterialApp(home: CashDepositToBankScreen(httpClient: mockClient));
    }

    test('screenName constant is correct', () {
      expect(CashDepositToBankScreen.screenName, '/cashDepositToBankScreen');
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(const CashDepositToBankScreen(), isA<StatefulWidget>());
    });

    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      expect(find.byType(CashDepositToBankScreen), findsOneWidget);
    });

    testWidgets('contains a Scaffold', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      expect(find.byType(Scaffold), findsWidgets);
    });

    testWidgets('can be disposed without errors', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
    });
  });
}
