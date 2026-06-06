import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/features/dashboard/models/dashboard_models.dart';
import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/alert_action_card.dart';

void main() {
  group('AlertActionCard', () {
    Widget buildWidget(VoidCallback? onTap) => MaterialApp(
          home: Scaffold(
            body: AlertActionCard(
              item: AlertItem(
                title: 'Postpaid Verification Pending',
                subtitle: '98 parties · awaiting verification',
                value: '₹7,25,256.00',
                severity: AlertSeverity.danger,
                icon: Icons.warning_amber_rounded,
                onTap: onTap,
              ),
              animationDelay: Duration.zero,
            ),
          ),
        );

    testWidgets('renders title subtitle and value', (tester) async {
      await tester.pumpWidget(buildWidget(null));
      await tester.pump();
      expect(find.text('Postpaid Verification Pending'), findsOneWidget);
      expect(find.text('98 parties · awaiting verification'), findsOneWidget);
      expect(find.text('₹7,25,256.00'), findsOneWidget);
    });

    testWidgets('tapping calls callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(buildWidget(() => tapped = true));
      await tester.pump();
      await tester.tap(find.byType(InkWell));
      expect(tapped, isTrue);
    });
  });
}

