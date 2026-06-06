import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerMoreScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ManagerMoreScree', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'StaffName': 'Test Staff',
        'DistributorName': 'Test Distributor',
        'RoleId': '1',
        'IsUserActive': '1',
        'userActivet': '1',
      });
    });

    Widget buildWidget() {
      return const MaterialApp(home: ManagerMoreScree());
    }

    test('screenName constant is correct', () {
      expect(ManagerMoreScree.screenName, '/managerMoreScree');
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(const ManagerMoreScree(), isA<StatefulWidget>());
    });

    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      expect(find.byType(ManagerMoreScree), findsOneWidget);
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

