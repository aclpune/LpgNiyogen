import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/CustomAppBar.dart';
import 'package:lpgsalesandinventory/Screen/Utils/constants.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

void main() {
  group('CustomAppBar', () {
    setUpAll(() {
      SizeConfig().init(const BoxConstraints(maxWidth: 400, maxHeight: 800), Orientation.portrait);
    });

    Widget buildWidget() => MaterialApp(
          home: Scaffold(appBar: CustomAppBar(title: 'Screen Title')),
        );

    test('preferredSize height is 60', () {
      expect(CustomAppBar(title: 'X').preferredSize.height, 60);
    });

    testWidgets('renders provided title', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Screen Title'), findsOneWidget);
    });

    testWidgets('renders app name', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text(Constants.appName), findsOneWidget);
    });

    // testWidgets('contains back button icon', (tester) async {
    //   await tester.pumpWidget(buildWidget());
    //   expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    // });

    testWidgets('contains back button icon', (tester) async {
      await tester.pumpWidget(buildWidget());
      // ✅ Matches the actual icon used in CustomAppBar
      expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
    });

    testWidgets('is a PreferredSizeWidget', (tester) async {
      expect(CustomAppBar(title: 'X'), isA<PreferredSizeWidget>());
    });
  });
}

