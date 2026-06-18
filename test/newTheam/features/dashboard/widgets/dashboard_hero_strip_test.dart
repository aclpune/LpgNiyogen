// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/models/dashboard_models.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/dashboard_hero_strip.dart';
//
// DashboardData buildData() => DashboardData(
//       businessName: 'Demo Niyojan',
//       ownerName: 'Snehal',
//       ownerInitials: 'SN',
//       date: DateTime(2026, 4, 24),
//       revenueToday: 0,
//       stockSummary: const StockSummary(filled: 998, empty: 205, defective: 7, weightKg: 14.2),
//       alerts: [],
//       financialKpis: [],
//       onAccountToday: 0,
//       onAccountTotal: 2783,
//       svPending: 36,
//       tvPending: 7,
//       unsettledCount: 0,
//       unsettledAmount: 0,
//       imbalanceToday: 0,
//       imbalanceTotal: 15,
//       outstandingSettlement: 1186437,
//       profitRows: [],
//       totalExpenses: 0,
//     );
//
// void main() {
//   group('DashboardHeroStrip', () {
//     Widget buildWidget() => MaterialApp(home: Scaffold(body: DashboardHeroStrip(data: buildData())));
//
//     testWidgets('renders business name and initials', (tester) async {
//       await tester.pumpWidget(buildWidget());
//       expect(find.text('Demo Niyojan'), findsOneWidget);
//       expect(find.text('SN'), findsOneWidget);
//     });
//
//     testWidgets('renders owner greeting', (tester) async {
//       await tester.pumpWidget(buildWidget());
//       expect(find.textContaining('Snehal'), findsOneWidget);
//     });
//
//     testWidgets('renders cylinders filled label', (tester) async {
//       await tester.pumpWidget(buildWidget());
//       expect(find.text('CYLINDERS FILLED'), findsOneWidget);
//     });
//   });
// }
//
//
