import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/mini_card_grid.dart';

void main() {
  group('MiniCardGrid / DataListCard', () {
    testWidgets('MiniCardGrid renders both labels', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: MiniCardGrid(
            left: MiniCardData(label: 'Left', value: '1', valueColor: AppColors.blue, sub: 'L'),
            right: MiniCardData(label: 'Right', value: '2', valueColor: AppColors.green, sub: 'R'),
          ),
        ),
      ));
      expect(find.text('LEFT'), findsOneWidget);
      expect(find.text('RIGHT'), findsOneWidget);
    });

    testWidgets('MiniCard action tap triggers callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MiniCardGrid(
            left: MiniCardData(label: 'Left', value: 'Tap', valueColor: AppColors.blue, sub: 'L', onTap: () => tapped = true),
            right: const MiniCardData(label: 'Right', value: '2', valueColor: AppColors.green, sub: 'R'),
          ),
        ),
      ));
      await tester.tap(find.text('Tap'));
      expect(tapped, isTrue);
    });

    testWidgets('DataListCard renders rows', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: DataListCard(
            rows: [
              DataRowItem(
                label: 'SV Pending Status',
                subtitle: 'Stock verification orders',
                value: '36',
                dotColor: AppColors.blue,
                badgeLabel: 'SV',
                badgeBg: AppColors.blueXL,
                badgeFg: AppColors.blue,
              ),
            ],
          ),
        ),
      ));
      expect(find.text('SV Pending Status'), findsOneWidget);
      expect(find.text('36'), findsOneWidget);
      expect(find.text('SV'), findsOneWidget);
    });
  });
}

