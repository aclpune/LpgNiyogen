import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/CustomAppBarManager.dart';
import 'package:lpgsalesandinventory/Screen/Utils/constants.dart';

void main() {
  group('CustomAppBarManager', () {
    Widget buildWidget() => const MaterialApp(
          home: Scaffold(appBar: CustomAppBarManager(title: 'Manager Screen')),
        );

    test('preferredSize height is 60', () {
      expect(const CustomAppBarManager(title: 'X').preferredSize.height, 60);
    });

    testWidgets('renders provided title', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Manager Screen'), findsOneWidget);
    });

    testWidgets('renders app name', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text(Constants.appName), findsOneWidget);
    });

    testWidgets('contains back arrow icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('is a PreferredSizeWidget', (tester) async {
      expect(const CustomAppBarManager(title: 'X'), isA<PreferredSizeWidget>());
    });
  });
}

