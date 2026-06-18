// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/models/dashboard_models.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/stock_progress_card.dart';
//
// void main() {
//   group('StockProgressCard', () {
//     Widget buildWidget() => const MaterialApp(
//           home: Scaffold(
//             body: StockProgressCard(
//               stock: StockSummary(filled: 998, empty: 205, defective: 7, weightKg: 14.2),
//             ),
//           ),
//         );
//
//     testWidgets('renders header and labels', (tester) async {
//       await tester.pumpWidget(buildWidget());
//       expect(find.text('Cylinder Stock Status'), findsOneWidget);
//       expect(find.text('Filled'), findsOneWidget);
//       expect(find.text('Empty'), findsOneWidget);
//       expect(find.text('Defective'), findsOneWidget);
//     });
//
//     testWidgets('renders counts', (tester) async {
//       await tester.pumpWidget(buildWidget());
//       expect(find.text('998'), findsOneWidget);
//       expect(find.text('205'), findsOneWidget);
//       expect(find.text('7'), findsOneWidget);
//     });
//
//     testWidgets('is a StatefulWidget', (tester) async {
//       expect(const StockProgressCard(stock: StockSummary(filled: 1, empty: 1, defective: 1, weightKg: 14.2)), isA<StatefulWidget>());
//     });
//   });
// }
//
