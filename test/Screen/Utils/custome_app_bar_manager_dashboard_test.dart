import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/CustomeAppBarManagerDashboard.dart';
import 'package:lpgsalesandinventory/Screen/Utils/constants.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CustomeAppBarmanagerDashboard', () {
    setUpAll(() {
      SizeConfig().init(const BoxConstraints(maxWidth: 400, maxHeight: 800), Orientation.portrait);
    });

    setUp(() {
      SharedPreferences.setMockInitialValues({
        'StaffName': 'Rahul',
        'RoleName': 'Manager',
        'DistributorName': 'Test Distributor',
        'roleId': '3',
      });
    });

    Widget buildWidget() => const MaterialApp(
          home: Scaffold(appBar: CustomeAppBarmanagerDashboard()),
        );

    test('preferredSize height is 60', () {
      expect(const CustomeAppBarmanagerDashboard().preferredSize.height, 60.0);
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(const CustomeAppBarmanagerDashboard(), isA<StatefulWidget>());
    });

    testWidgets('renders app bar title text', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pump();
      expect(find.text(Constants.AppBarTitle), findsOneWidget);
    });

    testWidgets('renders stored user name after async load', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text('Rahul'), findsOneWidget);
    });
  });
}

