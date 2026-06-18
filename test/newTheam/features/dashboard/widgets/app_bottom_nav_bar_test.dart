// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:lpgsalesandinventory/newTheam/features/dashboard/widgets/app_bottom_nav_bar.dart';
//
// void main() {
//   group('AppBottomNavBar', () {
//     Widget buildWidget({required int currentIndex, required ValueChanged<int> onTap}) =>
//         MaterialApp(home: Scaffold(bottomNavigationBar: AppBottomNavBar(currentIndex: currentIndex, onTap: onTap)));
//
//     testWidgets('renders five labels', (tester) async {
//       await tester.pumpWidget(buildWidget(currentIndex: 0, onTap: (_) {}));
//       expect(find.text('Dashboard'), findsOneWidget);
//       expect(find.text('Bookings'), findsOneWidget);
//       expect(find.text('Stock'), findsOneWidget);
//       expect(find.text('Payments'), findsOneWidget);
//       expect(find.text('More'), findsOneWidget);
//     });
//
//     testWidgets('tap triggers callback with index', (tester) async {
//       int? tappedIndex;
//       await tester.pumpWidget(buildWidget(currentIndex: 0, onTap: (i) => tappedIndex = i));
//       await tester.tap(find.text('Payments'));
//       expect(tappedIndex, 3);
//     });
//   });
// }
//
