import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/CutomeAppBarManagerBottomNavigationBar.dart';
import 'package:lpgsalesandinventory/Screen/Utils/constants.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('AppBarCustom', () {
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
          home: Scaffold(appBar: AppBarCustom()),
        );

    test('preferredSize height is 60', () {
      expect(const AppBarCustom().preferredSize.height, 60.0);
    });

    testWidgets('is a StatefulWidget', (tester) async {
      expect(const AppBarCustom(), isA<StatefulWidget>());
    });

    testWidgets('renders app title', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text(Constants.AppBarTitle), findsOneWidget);
    });

    testWidgets('renders stored user name after load', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpAndSettle();
      expect(find.text('Rahul'), findsOneWidget);
    });
  });
}

