// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/models/dashboard_models.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/kpi_card.dart';
//
// void main() {
//   group('KpiCard', () {
//     Widget buildWidget(VoidCallback? onTap) => MaterialApp(
//           home: Scaffold(
//             body: KpiCard(
//               kpi: FinancialKpi(
//                 label: "Today's Revenue",
//                 value: '₹0.00',
//                 subtitle: 'NC · ARB · Refill combined',
//                 badgeLabel: 'No Data',
//                 badgeColor: AppColors.orangeXL,
//                 badgeFg: AppColors.orange,
//                 iconBg: AppColors.blueXL,
//                 icon: Icons.currency_rupee_rounded,
//                 onTap: onTap,
//               ),
//             ),
//           ),
//         );
//
//     testWidgets('renders label value and badge', (tester) async {
//       await tester.pumpWidget(buildWidget(null));
//       expect(find.text("Today's Revenue"), findsOneWidget);
//       expect(find.text('₹0.00'), findsOneWidget);
//       expect(find.text('No Data'), findsOneWidget);
//     });
//
//     testWidgets('tap triggers callback', (tester) async {
//       var tapped = false;
//       await tester.pumpWidget(buildWidget(() => tapped = true));
//       await tester.tap(find.byType(InkWell));
//       expect(tapped, isTrue);
//     });
//   });
// }
//
