import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/BlinkingText.dart';

void main() {
  group('BlinkingText', () {
    Widget buildWidget() => const MaterialApp(
          home: Scaffold(
            body: BlinkingText(
              text: 'Blink',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
        );

    testWidgets('is a StatefulWidget', (tester) async {
      expect(
        const BlinkingText(text: 'Blink', style: TextStyle(fontSize: 16)),
        isA<StatefulWidget>(),
      );
    });

    testWidgets('renders provided text', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Blink'), findsOneWidget);
    });

    testWidgets('contains AnimatedOpacity', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byType(AnimatedOpacity), findsOneWidget);
    });

    testWidgets('animated opacity starts visible', (tester) async {
      await tester.pumpWidget(buildWidget());
      final widget = tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
      expect(widget.opacity, 1.0);
    });

    testWidgets('can be disposed without errors', (tester) async {
      await tester.pumpWidget(buildWidget());
      await tester.pumpWidget(const SizedBox());
    });
  });
}

