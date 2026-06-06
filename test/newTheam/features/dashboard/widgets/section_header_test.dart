import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/section_header.dart';

void main() {
  group('SectionHeader', () {
    testWidgets('renders uppercase title', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: SectionHeader(title: 'Needs Attention', dotColor: AppColors.red)),
      ));
      expect(find.text('NEEDS ATTENTION'), findsOneWidget);
    });

    testWidgets('renders see all label when provided', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(body: SectionHeader(title: 'Financial Overview', dotColor: AppColors.blue, seeAllLabel: 'View All ›')),
      ));
      expect(find.text('View All ›'), findsOneWidget);
    });

    testWidgets('tap see all triggers callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Inventory',
            dotColor: AppColors.teal,
            seeAllLabel: 'Details ›',
            onSeeAll: () => tapped = true,
          ),
        ),
      ));
      await tester.tap(find.text('Details ›'));
      expect(tapped, isTrue);
    });
  });
}

