import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/Widget.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

void main() {
  group('Widget.dart helpers', () {
    setUpAll(() {
      SizeConfig().init(
          const BoxConstraints(maxWidth: 400, maxHeight: 800),
          Orientation.portrait);
    });

    test('verticalDividerSmallest returns Container with expected constraints', () {
      final widget = verticalDividerSmallest() as Container;
      expect(widget.constraints?.minWidth, 1.0);
      expect(widget.constraints?.maxWidth, 1.0);
      expect(widget.constraints?.minHeight, 20.0);
      expect(widget.constraints?.maxHeight, 20.0);
    });

    test('verticalDividerSmallestRed returns Container with expected constraints', () {
      final widget = verticalDividerSmallestRed() as Container;
      expect(widget.constraints?.minWidth, 2.0);
      expect(widget.constraints?.maxWidth, 2.0);
      expect(widget.constraints?.minHeight, 15.0);
      expect(widget.constraints?.maxHeight, 15.0);
    });

    test('buildInputDecoration sets hint text and prefix icon', () {
      final decoration = buildInputDecoration('Enter name', Icons.person);
      expect(decoration.hintText, 'Enter name');
      expect(decoration.prefixIcon, isA<Icon>());
    });

    testWidgets('myElevButton renders title and triggers callback',
        (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                myElevButton(context, 'Save', () => tapped = true),
          ),
        ),
      ));
      expect(find.text('Save'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await tester.pump();
      expect(tapped, isTrue);
    });

    testWidgets('bodyTitleBlue renders provided text', (tester) async {
      await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: bodyTitleBlue('Heading'))));
      expect(find.text('Heading'), findsOneWidget);
    });
  });
}
