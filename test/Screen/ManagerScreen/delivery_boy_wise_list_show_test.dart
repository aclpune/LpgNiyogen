import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/DeliveryBoyWiseListShow.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DeliveryBoyWiseListShow', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({
        'StaffName': 'Test Staff',
        'DistributorName': 'Test Distributor',
        'RoleId': '1',
        'IsUserActive': '1',
        'userActivet': '1',
        'DistributorId': '8118',
        'token': 'test-token',
      });
    });

    Widget buildWidget() {
      return const MaterialApp(home: DeliveryBoyWiseListShow(disableNetworkCallsForTest: true));
    }

    test('screenName constant is correct', () {
      expect(DeliveryBoyWiseListShow.screenName, '/deliveryBoyWiseListShow');
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(const DeliveryBoyWiseListShow(), isA<StatefulWidget>());
    });

    testWidgets('mounts without throwing', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      expect(find.byType(DeliveryBoyWiseListShow), findsOneWidget);
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
