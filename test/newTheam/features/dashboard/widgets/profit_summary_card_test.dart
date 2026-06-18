// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/models/dashboard_models.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/profit_summary_card.dart';
//
// void main() {
//   group('ProfitSummaryCard', () {
//     Widget buildWidget() => const MaterialApp(
//           home: Scaffold(
//             body: ProfitSummaryCard(
//               rows: [
//                 ProfitRow(label: 'NC', grossRevenue: 1000, grossProfit: 100),
//                 ProfitRow(label: 'ARB', grossRevenue: 2000, grossProfit: 150),
//               ],
//               totalExpenses: 50,
//               netProfit: 200,
//             ),
//           ),
//         );
//
//     testWidgets('renders headers and rows', (tester) async {
//       await tester.pumpWidget(buildWidget());
//       expect(find.text('Category'), findsOneWidget);
//       expect(find.text('Gross Revenue'), findsOneWidget);
//       expect(find.text('Gross Profit'), findsOneWidget);
//       expect(find.text('NC'), findsOneWidget);
//       expect(find.text('ARB'), findsOneWidget);
//     });
//
//     testWidgets('renders total expenses and net profit labels', (tester) async {
//       await tester.pumpWidget(buildWidget());
//       expect(find.text('Total Expenses'), findsOneWidget);
//       expect(find.text('Net Profit This Month'), findsOneWidget);
//     });
//   });
// }
//
