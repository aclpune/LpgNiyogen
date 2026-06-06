import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/CustomeAlertDialog.dart';

void main() {
  group('CustomAlertDialog', () {
    Widget buildWidget() => MaterialApp(
          home: Scaffold(body: CustomAlertDialog(message: 'Hello world')),
        );

    testWidgets('renders message text', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Hello world'), findsOneWidget);
    });

    testWidgets('renders close button', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('contains Dialog widget', (tester) async {
      await tester.pumpWidget(buildWidget());
      expect(find.byType(Dialog), findsOneWidget);
    });

    testWidgets('showCustomAlert displays dialog', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => CustomAlertDialog.showCustomAlert(context, 'Dynamic message'),
            child: const Text('Open'),
          ),
        ),
      ));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Dynamic message'), findsOneWidget);
    });
  });
}

