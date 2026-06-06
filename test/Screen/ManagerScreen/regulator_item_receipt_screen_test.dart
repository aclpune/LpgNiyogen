import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/RegulatorItemReceiptScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('RegulatorItemReceiptScreen', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'DistributorId': '8118',
        'token': 'test-token',
      });
    });

    Widget buildWidget() {
      return const MaterialApp(home: RegulatorItemReceiptScreen(disableNetworkCallsForTest: true));
    }

    test('screenName constant is correct', () {
      expect(RegulatorItemReceiptScreen.screenName, '/regulatorItemReceiptScreen');
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(const RegulatorItemReceiptScreen(), isA<StatefulWidget>());
    });

    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      expect(find.byType(RegulatorItemReceiptScreen), findsOneWidget);
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
