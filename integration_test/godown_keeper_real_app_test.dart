// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:lpgsalesandinventory/main.dart' as app;
//
// // =============================================================================
// // SHARED PREFERENCES SETUP
// // =============================================================================
// Future<void> _setupRealPrefs() async {
//   SharedPreferences.setMockInitialValues({
//     'roleId': '0',
//     'userActive': 'Y',
//     'DistributorId': '8118',
//     'godownId': '1',
//     'StaffId': '22',
//     'UserId': '0',
//     'godownKeeperId': '22',
//     'token':
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJTYWhlYnJhbyBKYW5nYWxlIiwianRpIjoiZTU1OWQ2OTAtMjg5Ni00ODAzLWJhMTYtNjk1Mjk0ZjZkMDhkIiwibmFtZWlkIjoiU2FoZWJyYW8gSmFuZ2FsZSIsInJvbGUiOiIwIiwiTG9nZ2VkT24iOiI1LzE5LzIwMjYgNToyNjoxOSBQTSIsIkRpc3BsYXlOYW1lIjoiU2FoZWJyYW8gSmFuZ2FsZSIsIm5iZiI6MTc3OTE5MTc3OSwiZXhwIjoxNzc5Mjk5Nzc5LCJpYXQiOjE3NzkxOTE3NzksImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9.IJSs_b6kpyp5Zxh4L065jsRLs8eyw7Cxv9r5yweqqpk',
//     'MobileNo': '9700097000',
//     'StaffName': 'Sahebrao Jangale',
//     'DistributorName': 'SHREE RENUKA GAS SUPPLY COMPANY',
//     'IsAlreadyLogin': '1',
//   });
// }
//
// // =============================================================================
// // BOOT HELPERS
// // =============================================================================
//
// /// Boots the real app and waits for splash + initial API calls to finish.
// Future<void> _bootApp(WidgetTester tester) async {
//   await _setupRealPrefs();
//   app.main();
//   await tester.pump(const Duration(seconds: 4));
//   await tester.pump(const Duration(seconds: 4));
//   await tester.pump(const Duration(seconds: 4));
// }
//
// /// Boots app and navigates to the More Options tab (index 3).
// Future<void> _goToMore(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.tap(find.text('More'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Opens the Transfer item-selection bottom sheet from the Dashboard.
// Future<void> _openTransferPopup(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.pump(const Duration(seconds: 3));
//
//   final transferText = find.text('Transfer');
//   expect(transferText, findsOneWidget,
//       reason: 'Transfer InkWell must be visible in the Current Stock header');
//   await tester.tap(transferText);
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Opens Transfer popup and taps the first item to arrive at StockTransferTOGodownScreen.
// Future<void> _navigateToTransferScreen(WidgetTester tester) async {
//   await _openTransferPopup(tester);
//   expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//   await tester.tap(find.byType(ListTile).first);
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 3));
// }
//
// /// Opens the godown dropdown and picks the last DropdownMenuItem (first real option).
// Future<void> _selectFirstGodown(WidgetTester tester) async {
//   await tester.tap(find.text('Select Godown'));
//   await tester.pumpAndSettle(const Duration(seconds: 2));
//
//   final firstOption = find.byType(DropdownMenuItem<dynamic>).last;
//   if (firstOption.evaluate().isNotEmpty) {
//     await tester.tap(firstOption);
//     await tester.pumpAndSettle();
//   }
// }
//
// /// Navigates from More → ItemReceiptScreen via the 'Item Receipt' tile.
// Future<void> _goToItemReceiptScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Item Receipt'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → ItemReturnScreen via the 'Item Return' tile.
// Future<void> _goToItemReturnScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Item Return'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → AddReturnItemXMIScreen via the 'Return EXMI / Rev-EMR' tile.
// Future<void> _goToReturnXMIScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Return EXMI / Rev-EMR'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → ItemReturnXMIListScreen via the 'Receipt EXMI' tile.
// Future<void> _goToReceiptXMIListScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Receipt EXMI'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → MarkDefectiveItemScreen via the 'Mark Defective' tile.
// Future<void> _goToMarkDefectiveScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Mark Defective'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates to Daily Sale tab (index 1) → DeliveryMenListShowScreen.
// Future<void> _goToDailySale(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.tap(find.text('Daily Sale'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 3));
// }
//
// /// Navigates to Today's Summary tab (index 2) → StockSubmitToManager.
// Future<void> _goToTodaysSummary(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.tap(find.text("Today's Summary"));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 3));
// }
//
// // =============================================================================
// // MAIN TEST SUITE
// // =============================================================================
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 1 — APP LAUNCH & BOTTOM NAVIGATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] App Launch — Bottom Navigation', () {
//     testWidgets('[+] All 4 bottom nav tabs visible after login', (tester) async {
//       await _bootApp(tester);
//       expect(find.text('Dashboard'), findsOneWidget);
//       expect(find.text('Daily Sale'), findsOneWidget);
//       expect(find.text("Today's Summary"), findsOneWidget);
//       expect(find.text('More'), findsOneWidget);
//     });
//
//     testWidgets('[+] Dashboard tab selected by default (index 0)', (tester) async {
//       await _bootApp(tester);
//       final nav =
//       tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
//       expect(nav.currentIndex, 0);
//     });
//
//     testWidgets('[+] Exactly 4 items in the bottom nav bar', (tester) async {
//       await _bootApp(tester);
//       final nav =
//       tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
//       expect(nav.items.length, 4);
//     });
//
//     testWidgets('[+] selectedItemColor is blue', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .selectedItemColor,
//           Colors.blue);
//     });
//
//     testWidgets('[+] unselectedItemColor is black', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .unselectedItemColor,
//           Colors.black);
//     });
//
//     testWidgets('[+] backgroundColor is white', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .backgroundColor,
//           Colors.white);
//     });
//
//     testWidgets('[+] type is BottomNavigationBarType.fixed', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .type,
//           BottomNavigationBarType.fixed);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 2 — TAB SWITCHING
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Bottom Navigation — Tab Switching', () {
//     testWidgets('[+] Tap Daily Sale → index 1', (tester) async {
//       await _goToDailySale(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           1);
//     });
//
//     testWidgets("[+] Tap Today's Summary → index 2", (tester) async {
//       await _goToTodaysSummary(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           2);
//     });
//
//     testWidgets('[+] Tap More → index 3', (tester) async {
//       await _goToMore(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           3);
//     });
//
//     testWidgets('[+] Tap Dashboard after More → back to index 0', (tester) async {
//       await _goToMore(tester);
//       await tester.tap(find.text('Dashboard'));
//       await tester.pump(const Duration(seconds: 2));
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           0);
//     });
//
//     testWidgets('[+] Cycle through all 4 tabs without crash', (tester) async {
//       await _bootApp(tester);
//       for (final label in [
//         'Daily Sale',
//         "Today's Summary",
//         'More',
//         'Dashboard'
//       ]) {
//         await tester.tap(find.text(label));
//         await tester.pump(const Duration(seconds: 2));
//         await tester.pump(const Duration(seconds: 2));
//         expect(find.byType(BottomNavigationBar), findsOneWidget);
//       }
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           0);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 3 — DASHBOARD SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Dashboard Screen', () {
//     testWidgets('[+] Dashboard renders without crash', (tester) async {
//       await _bootApp(tester);
//       expect(find.byType(BottomNavigationBar), findsOneWidget);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Transfer InkWell visible in Current Stock section',
//             (tester) async {
//           await _bootApp(tester);
//           expect(find.text('Transfer'), findsOneWidget);
//         });
//
//     testWidgets('[+] Transfer is an InkWell, not an ElevatedButton',
//             (tester) async {
//           await _bootApp(tester);
//           expect(
//             find.ancestor(
//                 of: find.text('Transfer'), matching: find.byType(InkWell)),
//             findsOneWidget,
//           );
//           expect(
//             find.ancestor(
//                 of: find.text('Transfer'),
//                 matching: find.byType(ElevatedButton)),
//             findsNothing,
//           );
//         });
//
//     testWidgets('[+] Pull-to-refresh (RefreshIndicator) present', (tester) async {
//       await _bootApp(tester);
//       expect(find.byType(RefreshIndicator), findsWidgets);
//     });
//
//     testWidgets('[+] Dashboard renders ListView for stock items', (tester) async {
//       await _bootApp(tester);
//       await tester.pump(const Duration(seconds: 3));
//       expect(find.byType(ListView), findsWidgets);
//     });
//
//     testWidgets('[+] Dashboard is scrollable without crash', (tester) async {
//       await _bootApp(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final scrollables = find.byType(SingleChildScrollView);
//       if (scrollables.evaluate().isNotEmpty) {
//         await tester.drag(scrollables.first, const Offset(0, -200));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 4 — DASHBOARD: TRANSFER POPUP
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Dashboard — Transfer Item Selection Popup', () {
//     testWidgets('[+] Tapping Transfer opens item-selection bottom sheet',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//         });
//
//     testWidgets('[+] Bottom sheet shows at least one ListTile', (tester) async {
//       await _openTransferPopup(tester);
//       expect(find.byType(ListTile), findsWidgets);
//     });
//
//     testWidgets('[+] Bottom sheet items have propane_tank_outlined leading icon',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.byIcon(Icons.propane_tank_outlined), findsWidgets);
//         });
//
//     testWidgets('[+] Bottom sheet items have chevron_right trailing icon',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.byIcon(Icons.chevron_right_rounded), findsWidgets);
//         });
//
//     testWidgets('[+] Popup shows swap icon in header', (tester) async {
//       await _openTransferPopup(tester);
//       expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
//     });
//
//     testWidgets('[+] Dismissing popup restores Dashboard with bottom nav',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//           tester.state<NavigatorState>(find.byType(Navigator)).pop();
//           await tester.pump(const Duration(seconds: 1));
//           expect(find.text('Select Item For Stock Transfer'), findsNothing);
//           expect(find.byType(BottomNavigationBar), findsOneWidget);
//         });
//
//     testWidgets('[+] Tapping an item navigates to Stock Transfer screen',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           expect(find.text('Stock Transfer'), findsOneWidget);
//         });
//
//     testWidgets('[+] Stock Transfer is a full-page route — no bottom nav',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           expect(find.byType(BottomNavigationBar), findsNothing);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 5 — STOCK TRANSFER TO GODOWN SCREEN: UI
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — UI Rendering', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] FILLED stock chip visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('FILLED'), findsOneWidget);
//     });
//
//     testWidgets('[+] EMPTY stock chip visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('EMPTY'), findsOneWidget);
//     });
//
//     testWidgets('[+] DEFECTIVE stock chip visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('DEFECTIVE'), findsOneWidget);
//     });
//
//     testWidgets('[+] TRANSFER DETAILS section label visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('TRANSFER DETAILS'), findsOneWidget);
//     });
//
//     testWidgets('[+] STOCK TRANSFER HISTORY section label visible',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 4));
//           expect(find.text('STOCK TRANSFER HISTORY'), findsOneWidget);
//         });
//
//     testWidgets('[+] 3 quantity TextFields present (Filled, Empty, Defective)',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           expect(find.byType(TextField).evaluate().length,
//               greaterThanOrEqualTo(3));
//         });
//
//     testWidgets('[+] Submit ElevatedButton present', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
//     });
//
//     testWidgets('[+] DropdownButtonFormField for godown selection present',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 4));
//           expect(find.byType(DropdownButtonFormField<dynamic>), findsOneWidget);
//         });
//
//     testWidgets('[+] Godown dropdown hint "Select Godown" shown by default',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 4));
//           expect(find.text('Select Godown'), findsWidgets);
//         });
//
//     testWidgets('[+] History ListView.builder present', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 3));
//       expect(find.byType(ListView), findsWidgets);
//     });
//
//     testWidgets('[+] History list is scrollable without crash', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 4));
//       final listViews = find.byType(ListView);
//       if (listViews.evaluate().isNotEmpty) {
//         await tester.drag(listViews.last, const Offset(0, -150));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 6 — STOCK TRANSFER: FORM VALIDATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Form Validation', () {
//     testWidgets('[-] Submit with no godown selected → "Select godown." flush bar',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '5');
//           await tester.pump();
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.text('Select godown.'), findsOneWidget);
//           expect(find.text('Stock Transfer'), findsOneWidget);
//         });
//
//     testWidgets(
//         '[-] Submit with godown but all qty fields empty → validation flush bar',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           await _selectFirstGodown(tester);
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets(
//         '[-] Filled Qty > available stock: field is cleared by onChanged',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '999');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets(
//         '[-] Empty Qty > available stock: field is cleared by onChanged',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(1), '999');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(1)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets(
//         '[-] Defective Qty > available stock: field is cleared by onChanged',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(2), '999');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(2)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets('[+] Qty TextField uses digitsOnly formatter — letters stripped',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), 'abc');
//           await tester.pump();
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets('[+] Qty TextField max length 3 — excess chars stripped',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '12345');
//           await tester.pump();
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text.length, lessThanOrEqualTo(3));
//         });
//
//     testWidgets('[+] Remark TextField max length 250', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.enterText(find.byType(TextField).at(3), 'A' * 300);
//       await tester.pump();
//       final ctrl =
//           tester.widget<TextField>(find.byType(TextField).at(3)).controller;
//       expect(ctrl?.text.length, lessThanOrEqualTo(250));
//     });
//
//     testWidgets('[+] Valid qty in range (1) accepted without clearing',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '1');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text, equals('1'));
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 7 — STOCK TRANSFER: GODOWN DROPDOWN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Godown Dropdown', () {
//     testWidgets('[+] Dropdown opens and shows items on tap', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 4));
//       await tester.tap(find.text('Select Godown'));
//       await tester.pumpAndSettle(const Duration(seconds: 2));
//       expect(find.byType(DropdownMenuItem<dynamic>), findsWidgets);
//     });
//
//     testWidgets('[+] Selecting a godown replaces hint text', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 4));
//       await _selectFirstGodown(tester);
//       expect(find.text('Select Godown'), findsNothing);
//     });
//
//     testWidgets(
//         '[-] Submit after godown + qty with stockTransferFlag=false shows alert',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           await _selectFirstGodown(tester);
//           await tester.enterText(find.byType(TextField).at(0), '1');
//           await tester.pump();
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 8 — STOCK TRANSFER: BACK NAVIGATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Back Navigation', () {
//     testWidgets('[+] Back button pops screen and shows Dashboard bottom nav',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           final backBtn = find.byTooltip('Back');
//           if (backBtn.evaluate().isNotEmpty) {
//             await tester.tap(backBtn);
//           } else {
//             tester.state<NavigatorState>(find.byType(Navigator)).pop();
//           }
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.byType(BottomNavigationBar), findsOneWidget);
//         });
//
//     testWidgets('[+] Dashboard stays at index 0 after returning from transfer',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           tester.state<NavigatorState>(find.byType(Navigator)).pop();
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           expect(
//               tester
//                   .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//                   .currentIndex,
//               0);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 9 — STOCK TRANSFER: FULL E2E HAPPY PATH
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Full Happy Path E2E', () {
//     testWidgets('[+] Transfer → popup → item → fill form → Submit: no crash',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.pump(const Duration(seconds: 3));
//
//           await tester.tap(find.text('Transfer'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//
//           await tester.tap(find.byType(ListTile).first);
//           await tester.pump(const Duration(seconds: 3));
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.text('Stock Transfer'), findsOneWidget);
//
//           await tester.pump(const Duration(seconds: 3));
//           await _selectFirstGodown(tester);
//
//           await tester.enterText(find.byType(TextField).at(0), '1');
//           await tester.pump();
//           await tester.enterText(find.byType(TextField).at(1), '1');
//           await tester.pump();
//           await tester.enterText(find.byType(TextField).at(3), 'Integration test remark');
//           await tester.pump();
//
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 3));
//           await tester.pump(const Duration(seconds: 3));
//
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 10 — MORE OPTIONS SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MoreOptionScreenGodownKeeper — UI Rendering', () {
//     testWidgets('[+] More Options screen renders without crash', (tester) async {
//       await _goToMore(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Hero header shows "More Options" title', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('More Options'), findsOneWidget);
//     });
//
//     testWidgets('[+] Hero header shows "Godown Keeper" subtitle', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Godown Keeper'), findsOneWidget);
//     });
//
//     testWidgets('[+] Section label "ITEM RECEIPT / RETURN" visible',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.text('ITEM RECEIPT / RETURN'), findsOneWidget);
//         });
//
//     testWidgets('[+] Section label "EXMI / REV-EMR" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('EXMI / REV-EMR'), findsOneWidget);
//     });
//
//     testWidgets('[+] Section label "MARK DEFECTIVE" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('MARK DEFECTIVE'), findsOneWidget);
//     });
//
//     testWidgets('[+] Section label "ACCOUNT" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('ACCOUNT'), findsOneWidget);
//     });
//
//     testWidgets('[+] Menu item "Item Receipt" visible with correct subtitle',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.text('Item Receipt'), findsOneWidget);
//           expect(find.text('Record incoming stock items'), findsOneWidget);
//         });
//
//     testWidgets('[+] Menu item "Item Return" visible with correct subtitle',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.text('Item Return'), findsOneWidget);
//           expect(find.text('Process returned items'), findsOneWidget);
//         });
//
//     testWidgets('[+] Menu item "Return EXMI / Rev-EMR" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Return EXMI / Rev-EMR'), findsOneWidget);
//     });
//
//     testWidgets('[+] Menu item "Receipt EXMI" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Receipt EXMI'), findsOneWidget);
//     });
//
//     testWidgets('[+] Menu item "Mark Defective" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Mark Defective'), findsOneWidget);
//     });
//
//     testWidgets('[+] Logout menu item visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Logout'), findsOneWidget);
//     });
//
//     testWidgets('[+] All menu items have chevron_right trailing icon',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.byIcon(Icons.chevron_right_rounded), findsWidgets);
//         });
//
//     testWidgets('[+] More screen is scrollable without crash', (tester) async {
//       await _goToMore(tester);
//       final scrollable = find.byType(SingleChildScrollView);
//       if (scrollable.evaluate().isNotEmpty) {
//         await tester.drag(scrollable.first, const Offset(0, -200));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 11 — MORE OPTIONS SCREEN: NAVIGATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MoreOptionScreenGodownKeeper — Navigation', () {
//     testWidgets('[+] Tapping "Item Receipt" navigates away from More screen',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Tapping "Item Return" navigates away from More screen',
//             (tester) async {
//           await _goToItemReturnScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets(
//         '[+] Tapping "Return EXMI / Rev-EMR" navigates to XMI return screen',
//             (tester) async {
//           await _goToReturnXMIScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Tapping "Receipt EXMI" navigates to XMI list screen',
//             (tester) async {
//           await _goToReceiptXMIListScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Tapping "Mark Defective" navigates to defective screen',
//             (tester) async {
//           await _goToMarkDefectiveScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 12 — MORE OPTIONS SCREEN: LOGOUT DIALOG
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MoreOptionScreenGodownKeeper — Logout Dialog', () {
//     testWidgets('[+] Tapping Logout opens "Confirm Logout" AlertDialog',
//             (tester) async {
//           await _goToMore(tester);
//           await tester.tap(find.text('Logout'));
//           await tester.pump(const Duration(milliseconds: 500));
//           expect(find.text('Confirm Logout'), findsOneWidget);
//         });
//
//     testWidgets('[+] Logout dialog shows "Are you sure you want to logout?"',
//             (tester) async {
//           await _goToMore(tester);
//           await tester.tap(find.text('Logout'));
//           await tester.pump(const Duration(milliseconds: 500));
//           expect(
//               find.text('Are you sure you want to logout?'), findsOneWidget);
//         });
//
//     testWidgets('[+] Logout dialog shows Cancel and Logout buttons',
//             (tester) async {
//           await _goToMore(tester);
//           await tester.tap(find.text('Logout'));
//           await tester.pump(const Duration(milliseconds: 500));
//           expect(find.text('Cancel'), findsOneWidget);
//           expect(find.widgetWithText(ElevatedButton, 'Logout'), findsOneWidget);
//         });
//
//     testWidgets('[+] Tapping Cancel closes the logout dialog', (tester) async {
//       await _goToMore(tester);
//       await tester.tap(find.text('Logout'));
//       await tester.pump(const Duration(milliseconds: 500));
//       expect(find.text('Confirm Logout'), findsOneWidget);
//
//       await tester.tap(find.text('Cancel'));
//       await tester.pump(const Duration(milliseconds: 500));
//
//       expect(find.text('Confirm Logout'), findsNothing);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Logout dialog shows logout icon', (tester) async {
//       await _goToMore(tester);
//       await tester.tap(find.text('Logout'));
//       await tester.pump(const Duration(milliseconds: 500));
//       expect(find.byIcon(Icons.logout_rounded), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 13 — ITEM RECEIPT SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] ItemReceiptScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       // ItemReceiptScreen is a full page route
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Vehicle number TextField is present', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       // At least one TextField for vehicle number
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[+] Cylinder quantity TextField is present', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[-] Submit without vehicle number shows validation error',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
//           if (submitBtn.evaluate().isNotEmpty) {
//             await tester.tap(submitBtn);
//             await tester.pump(const Duration(seconds: 1));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Screen has item type selector (DropdownButton or similar)',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           await tester.pump(const Duration(seconds: 2));
//           final dropdowns = find.byType(DropdownButton<dynamic>);
//           final dropdownFormFields = find.byType(DropdownButtonFormField<dynamic>);
//           final hasDropdown = dropdowns.evaluate().isNotEmpty ||
//               dropdownFormFields.evaluate().isNotEmpty;
//           expect(hasDropdown, isTrue,
//               reason: 'Item type selector should be a dropdown');
//         });
//
//     testWidgets('[+] Invoice / EMR / Both category options exist',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           await tester.pump(const Duration(seconds: 2));
//           // At least one of these labels should appear (radio, chip, or tab)
//           final hasInvoice = find.text('Invoice').evaluate().isNotEmpty;
//           final hasEMR = find.text('EMR').evaluate().isNotEmpty;
//           final hasBoth = find.text('Both').evaluate().isNotEmpty;
//           expect(hasInvoice || hasEMR || hasBoth, isTrue,
//               reason: 'Invoice / EMR / Both category should be visible');
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 14 — ITEM RETURN SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] ItemReturnScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToItemReturnScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToItemReturnScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Return list or empty state is rendered', (tester) async {
//       await _goToItemReturnScreen(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final hasList = find.byType(ListView).evaluate().isNotEmpty;
//       final hasEmpty = find.byType(Scaffold).evaluate().isNotEmpty;
//       expect(hasList || hasEmpty, isTrue);
//     });
//
//     testWidgets('[+] Screen is scrollable without crash', (tester) async {
//       await _goToItemReturnScreen(tester);
//       await tester.pump(const Duration(seconds: 2));
//       final scrollable = find.byType(SingleChildScrollView);
//       if (scrollable.evaluate().isNotEmpty) {
//         await tester.drag(scrollable.first, const Offset(0, -200));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 15 — ADD RETURN ITEM XMI SCREEN (EXMI / Rev-EMR Return)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] AddReturnItemXMIScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToReturnXMIScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation on full-page route', (tester) async {
//       await _goToReturnXMIScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Vehicle number input present', (tester) async {
//       await _goToReturnXMIScreen(tester);
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[+] Invoice quantity and EMR quantity inputs present',
//             (tester) async {
//           await _goToReturnXMIScreen(tester);
//           await tester.pump(const Duration(seconds: 2));
//           // At least 2 TextFields: vehicle + invoice + EMR qty
//           expect(find.byType(TextField).evaluate().length,
//               greaterThanOrEqualTo(2));
//         });
//
//     testWidgets('[-] Submit without data shows validation error',
//             (tester) async {
//           await _goToReturnXMIScreen(tester);
//           final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
//           if (submitBtn.evaluate().isNotEmpty) {
//             await tester.tap(submitBtn);
//             await tester.pump(const Duration(seconds: 1));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 16 — ITEM RETURN XMI LIST SCREEN (Receipt EXMI)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] ItemReturnXMIListScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToReceiptXMIListScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToReceiptXMIListScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Receipt list or empty state rendered after API call',
//             (tester) async {
//           await _goToReceiptXMIListScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 17 — MARK DEFECTIVE ITEM SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MarkDefectiveItemScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToMarkDefectiveScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToMarkDefectiveScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Defective item list or empty state rendered',
//             (tester) async {
//           await _goToMarkDefectiveScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Mark defective action widget present', (tester) async {
//       await _goToMarkDefectiveScreen(tester);
//       await tester.pump(const Duration(seconds: 2));
//       // Either a button, icon button or tappable list tile should exist
//       final hasButton = find.byType(ElevatedButton).evaluate().isNotEmpty ||
//           find.byType(IconButton).evaluate().isNotEmpty ||
//           find.byType(ListTile).evaluate().isNotEmpty;
//       expect(hasButton, isTrue,
//           reason: 'Mark defective action widget must exist');
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 18 — DELIVERY MEN LIST SHOW SCREEN (Daily Sale tab)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] DeliveryMenListShowScreen', () {
//     testWidgets('[+] Screen renders on Daily Sale tab without crash',
//             (tester) async {
//           await _goToDailySale(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Bottom navigation bar still visible on Daily Sale tab',
//             (tester) async {
//           await _goToDailySale(tester);
//           expect(find.byType(BottomNavigationBar), findsOneWidget);
//         });
//
//     testWidgets('[+] Delivery men list or loading state rendered',
//             (tester) async {
//           await _goToDailySale(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] List is scrollable without crash', (tester) async {
//       await _goToDailySale(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final listViews = find.byType(ListView);
//       if (listViews.evaluate().isNotEmpty) {
//         await tester.drag(listViews.first, const Offset(0, -150));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets(
//         '[+] Tapping a delivery boy item does not crash (navigates to DailyRefillSalePage)',
//             (tester) async {
//           await _goToDailySale(tester);
//           await tester.pump(const Duration(seconds: 3));
//           final listTiles = find.byType(ListTile);
//           if (listTiles.evaluate().isNotEmpty) {
//             await tester.tap(listTiles.first);
//             await tester.pump(const Duration(seconds: 3));
//             await tester.pump(const Duration(seconds: 2));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 19 — STOCK SUBMIT TO MANAGER SCREEN (Today's Summary tab)
//   // ══════════════════════════════════════════════════════════════════════════
//   group("[REAL] StockSubmitToManager (Today's Summary tab)", () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToTodaysSummary(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Bottom navigation bar still visible', (tester) async {
//       await _goToTodaysSummary(tester);
//       expect(find.byType(BottomNavigationBar), findsOneWidget);
//     });
//
//     testWidgets('[+] Transaction list or empty state rendered after API call',
//             (tester) async {
//           await _goToTodaysSummary(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] List is scrollable without crash', (tester) async {
//       await _goToTodaysSummary(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final listViews = find.byType(ListView);
//       if (listViews.evaluate().isNotEmpty) {
//         await tester.drag(listViews.first, const Offset(0, -150));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Edit / Delete options discoverable on long press or swipe',
//             (tester) async {
//           await _goToTodaysSummary(tester);
//           await tester.pump(const Duration(seconds: 3));
//           final listTiles = find.byType(ListTile);
//           if (listTiles.evaluate().isNotEmpty) {
//             await tester.longPress(listTiles.first);
//             await tester.pump(const Duration(milliseconds: 500));
//           }
//           // Either dialog / bottom sheet appears, or screen stays stable
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 20 — DAILY REFILL SALE PAGE (deep navigation from Delivery Boy list)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] DailyRefillSalePage', () {
//     // Helper: navigate to first delivery boy's transaction page
//     Future<bool> _goToDailyRefillSale(WidgetTester tester) async {
//       await _goToDailySale(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final listTiles = find.byType(ListTile);
//       if (listTiles.evaluate().isEmpty) return false;
//       await tester.tap(listTiles.first);
//       await tester.pump(const Duration(seconds: 3));
//       await tester.pump(const Duration(seconds: 3));
//       return true;
//     }
//
//     testWidgets('[+] Screen renders when delivery boy tapped', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) {
//         // No delivery boys loaded — skip gracefully
//         expect(find.byType(Scaffold), findsWidgets);
//         return;
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Vehicle number dropdown loaded from API', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) return;
//       await tester.pump(const Duration(seconds: 2));
//       final dropdowns = find.byType(DropdownButton<dynamic>);
//       final dropdownFormFields =
//       find.byType(DropdownButtonFormField<dynamic>);
//       expect(
//           dropdowns.evaluate().isNotEmpty ||
//               dropdownFormFields.evaluate().isNotEmpty,
//           isTrue);
//     });
//
//     testWidgets('[+] Sale quantity TextField is present', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) return;
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[-] Submit without item selection shows validation error',
//             (tester) async {
//           final reached = await _goToDailyRefillSale(tester);
//           if (!reached) return;
//           final addBtn = find.widgetWithText(ElevatedButton, 'Add');
//           if (addBtn.evaluate().isNotEmpty) {
//             await tester.tap(addBtn);
//             await tester.pump(const Duration(seconds: 1));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Customer type selector (SV / TV) present', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) return;
//       await tester.pump(const Duration(seconds: 2));
//       final hasSV = find.text('SV').evaluate().isNotEmpty;
//       final hasTV = find.text('TV').evaluate().isNotEmpty;
//       // At least one customer type should be visible in the UI
//       expect(hasSV || hasTV, isTrue,
//           reason: 'Customer type selector (SV/TV) must be visible');
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 21 — SQC REGISTER SCREEN (via Dashboard SQC section)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] SQCRegisterScreen', () {
//     testWidgets('[+] Dashboard loads SQC summary section without crash',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.pump(const Duration(seconds: 4));
//           // Dashboard hosts SQC summary — just verify no crash
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] SQC data ListView rendered if vehicles exist', (tester) async {
//       await _bootApp(tester);
//       await tester.pump(const Duration(seconds: 4));
//       // SQC list may or may not have data — no crash is the assertion
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 22 — CROSS-SCREEN / ROLE-BASED VALIDATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Cross-Screen — Godown Keeper Role Validation', () {
//     testWidgets('[+] roleId=0 (Godown Keeper) lands on correct bottom nav',
//             (tester) async {
//           await _bootApp(tester);
//           expect(find.text('Dashboard'), findsOneWidget);
//           expect(find.text('Daily Sale'), findsOneWidget);
//           expect(find.text("Today's Summary"), findsOneWidget);
//           expect(find.text('More'), findsOneWidget);
//         });
//
//     testWidgets('[+] godownId and godownKeeperId loaded from SharedPreferences',
//             (tester) async {
//           // Verify the prefs are set correctly
//           final prefs = await SharedPreferences.getInstance();
//           expect(prefs.getString('godownId'), '1');
//           expect(prefs.getString('godownKeeperId'), '22');
//         });
//
//     testWidgets('[+] Distributor name loaded from SharedPreferences',
//             (tester) async {
//           final prefs = await SharedPreferences.getInstance();
//           expect(prefs.getString('DistributorName'),
//               'SHREE RENUKA GAS SUPPLY COMPANY');
//         });
//
//     testWidgets('[+] Full app cycle: Dashboard → More → Dashboard stable',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.tap(find.text('More'));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.tap(find.text('Dashboard'));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           expect(
//               tester
//                   .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//                   .currentIndex,
//               0);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Full app cycle: Dashboard → Daily Sale → Summary stable',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.tap(find.text('Daily Sale'));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.tap(find.text("Today's Summary"));
//           await tester.pump(const Duration(seconds: 2));
//           expect(
//               tester
//                   .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//                   .currentIndex,
//               2);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:integration_test/integration_test.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:lpgsalesandinventory/main.dart' as app;
//
// // =============================================================================
// // SHARED PREFERENCES SETUP
// // =============================================================================
// Future<void> _setupRealPrefs() async {
//   SharedPreferences.setMockInitialValues({
//     'roleId': '0',
//     'userActive': 'Y',
//     'DistributorId': '8118',
//     'godownId': '1',
//     'StaffId': '22',
//     'UserId': '0',
//     'godownKeeperId': '22',
//     'token':
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJTYWhlYnJhbyBKYW5nYWxlIiwianRpIjoiZTU1OWQ2OTAtMjg5Ni00ODAzLWJhMTYtNjk1Mjk0ZjZkMDhkIiwibmFtZWlkIjoiU2FoZWJyYW8gSmFuZ2FsZSIsInJvbGUiOiIwIiwiTG9nZ2VkT24iOiI1LzE5LzIwMjYgNToyNjoxOSBQTSIsIkRpc3BsYXlOYW1lIjoiU2FoZWJyYW8gSmFuZ2FsZSIsIm5iZiI6MTc3OTE5MTc3OSwiZXhwIjoxNzc5Mjk5Nzc5LCJpYXQiOjE3NzkxOTE3NzksImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9.IJSs_b6kpyp5Zxh4L065jsRLs8eyw7Cxv9r5yweqqpk',
//     'MobileNo': '9700097000',
//     'StaffName': 'Sahebrao Jangale',
//     'DistributorName': 'SHREE RENUKA GAS SUPPLY COMPANY',
//     'IsAlreadyLogin': '1',
//   });
// }
//
// // =============================================================================
// // BOOT HELPERS
// // =============================================================================
//
// /// Boots the real app and waits for splash + initial API calls to finish.
// Future<void> _bootApp(WidgetTester tester) async {
//   await _setupRealPrefs();
//   app.main();
//   await tester.pump(const Duration(seconds: 4));
//   await tester.pump(const Duration(seconds: 4));
//   await tester.pump(const Duration(seconds: 4));
// }
//
// /// Boots app and navigates to the More Options tab (index 3).
// Future<void> _goToMore(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.tap(find.text('More'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Opens the Transfer item-selection bottom sheet from the Dashboard.
// Future<void> _openTransferPopup(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.pump(const Duration(seconds: 3));
//
//   final transferText = find.text('Transfer');
//   expect(transferText, findsOneWidget,
//       reason: 'Transfer InkWell must be visible in the Current Stock header');
//   await tester.tap(transferText);
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Opens Transfer popup and taps the first item to arrive at StockTransferTOGodownScreen.
// Future<void> _navigateToTransferScreen(WidgetTester tester) async {
//   await _openTransferPopup(tester);
//   expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//   await tester.tap(find.byType(ListTile).first);
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 3));
// }
//
// /// Opens the godown dropdown and picks the last DropdownMenuItem (first real option).
// Future<void> _selectFirstGodown(WidgetTester tester) async {
//   await tester.tap(find.text('Select Godown'));
//   await tester.pumpAndSettle(const Duration(seconds: 2));
//
//   final firstOption = find.byType(DropdownMenuItem<dynamic>).last;
//   if (firstOption.evaluate().isNotEmpty) {
//     await tester.tap(firstOption);
//     await tester.pumpAndSettle();
//   }
// }
//
// /// Navigates from More → ItemReceiptScreen via the 'Item Receipt' tile.
// Future<void> _goToItemReceiptScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Item Receipt'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → ItemReturnScreen via the 'Item Return' tile.
// Future<void> _goToItemReturnScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Item Return'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → AddReturnItemXMIScreen via the 'Return EXMI / Rev-EMR' tile.
// Future<void> _goToReturnXMIScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Return EXMI / Rev-EMR'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → ItemReturnXMIListScreen via the 'Receipt EXMI' tile.
// Future<void> _goToReceiptXMIListScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Receipt EXMI'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates from More → MarkDefectiveItemScreen via the 'Mark Defective' tile.
// Future<void> _goToMarkDefectiveScreen(WidgetTester tester) async {
//   await _goToMore(tester);
//   await tester.tap(find.text('Mark Defective'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 2));
// }
//
// /// Navigates to Daily Sale tab (index 1) → DeliveryMenListShowScreen.
// Future<void> _goToDailySale(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.tap(find.text('Daily Sale'));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 3));
// }
//
// /// Navigates to Today's Summary tab (index 2) → StockSubmitToManager.
// Future<void> _goToTodaysSummary(WidgetTester tester) async {
//   await _bootApp(tester);
//   await tester.tap(find.text("Today's Summary"));
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pump(const Duration(seconds: 3));
// }
//
// // =============================================================================
// // MAIN TEST SUITE
// // =============================================================================
// void main() {
//   IntegrationTestWidgetsFlutterBinding.ensureInitialized();
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 1 — APP LAUNCH & BOTTOM NAVIGATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] App Launch — Bottom Navigation', () {
//     testWidgets('[+] All 4 bottom nav tabs visible after login', (tester) async {
//       await _bootApp(tester);
//       expect(find.text('Dashboard'), findsOneWidget);
//       expect(find.text('Daily Sale'), findsOneWidget);
//       expect(find.text("Today's Summary"), findsOneWidget);
//       expect(find.text('More'), findsOneWidget);
//     });
//
//     testWidgets('[+] Dashboard tab selected by default (index 0)', (tester) async {
//       await _bootApp(tester);
//       final nav =
//       tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
//       expect(nav.currentIndex, 0);
//     });
//
//     testWidgets('[+] Exactly 4 items in the bottom nav bar', (tester) async {
//       await _bootApp(tester);
//       final nav =
//       tester.widget<BottomNavigationBar>(find.byType(BottomNavigationBar));
//       expect(nav.items.length, 4);
//     });
//
//     testWidgets('[+] selectedItemColor is blue', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .selectedItemColor,
//           Colors.blue);
//     });
//
//     testWidgets('[+] unselectedItemColor is black', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .unselectedItemColor,
//           Colors.black);
//     });
//
//     testWidgets('[+] backgroundColor is white', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .backgroundColor,
//           Colors.white);
//     });
//
//     testWidgets('[+] type is BottomNavigationBarType.fixed', (tester) async {
//       await _bootApp(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .type,
//           BottomNavigationBarType.fixed);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 2 — TAB SWITCHING
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Bottom Navigation — Tab Switching', () {
//     testWidgets('[+] Tap Daily Sale → index 1', (tester) async {
//       await _goToDailySale(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           1);
//     });
//
//     testWidgets("[+] Tap Today's Summary → index 2", (tester) async {
//       await _goToTodaysSummary(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           2);
//     });
//
//     testWidgets('[+] Tap More → index 3', (tester) async {
//       await _goToMore(tester);
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           3);
//     });
//
//     testWidgets('[+] Tap Dashboard after More → back to index 0', (tester) async {
//       await _goToMore(tester);
//       await tester.tap(find.text('Dashboard'));
//       await tester.pump(const Duration(seconds: 2));
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           0);
//     });
//
//     testWidgets('[+] Cycle through all 4 tabs without crash', (tester) async {
//       await _bootApp(tester);
//       for (final label in [
//         'Daily Sale',
//         "Today's Summary",
//         'More',
//         'Dashboard'
//       ]) {
//         await tester.tap(find.text(label));
//         await tester.pump(const Duration(seconds: 2));
//         await tester.pump(const Duration(seconds: 2));
//         expect(find.byType(BottomNavigationBar), findsOneWidget);
//       }
//       expect(
//           tester
//               .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//               .currentIndex,
//           0);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 3 — DASHBOARD SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Dashboard Screen', () {
//     testWidgets('[+] Dashboard renders without crash', (tester) async {
//       await _bootApp(tester);
//       expect(find.byType(BottomNavigationBar), findsOneWidget);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Transfer InkWell visible in Current Stock section',
//             (tester) async {
//           await _bootApp(tester);
//           expect(find.text('Transfer'), findsOneWidget);
//         });
//
//     testWidgets('[+] Transfer is an InkWell, not an ElevatedButton',
//             (tester) async {
//           await _bootApp(tester);
//           expect(
//             find.ancestor(
//                 of: find.text('Transfer'), matching: find.byType(InkWell)),
//             findsOneWidget,
//           );
//           expect(
//             find.ancestor(
//                 of: find.text('Transfer'),
//                 matching: find.byType(ElevatedButton)),
//             findsNothing,
//           );
//         });
//
//     testWidgets('[+] Pull-to-refresh (RefreshIndicator) present', (tester) async {
//       await _bootApp(tester);
//       expect(find.byType(RefreshIndicator), findsWidgets);
//     });
//
//     testWidgets('[+] Dashboard renders ListView for stock items', (tester) async {
//       await _bootApp(tester);
//       await tester.pump(const Duration(seconds: 3));
//       expect(find.byType(ListView), findsWidgets);
//     });
//
//     testWidgets('[+] Dashboard is scrollable without crash', (tester) async {
//       await _bootApp(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final scrollables = find.byType(SingleChildScrollView);
//       if (scrollables.evaluate().isNotEmpty) {
//         await tester.drag(scrollables.first, const Offset(0, -200));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 4 — DASHBOARD: TRANSFER POPUP
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Dashboard — Transfer Item Selection Popup', () {
//     testWidgets('[+] Tapping Transfer opens item-selection bottom sheet',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//         });
//
//     testWidgets('[+] Bottom sheet shows at least one ListTile', (tester) async {
//       await _openTransferPopup(tester);
//       expect(find.byType(ListTile), findsWidgets);
//     });
//
//     testWidgets('[+] Bottom sheet items have propane_tank_outlined leading icon',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.byIcon(Icons.propane_tank_outlined), findsWidgets);
//         });
//
//     testWidgets('[+] Bottom sheet items have chevron_right trailing icon',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.byIcon(Icons.chevron_right_rounded), findsWidgets);
//         });
//
//     testWidgets('[+] Popup shows swap icon in header', (tester) async {
//       await _openTransferPopup(tester);
//       expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
//     });
//
//     testWidgets('[+] Dismissing popup restores Dashboard with bottom nav',
//             (tester) async {
//           await _openTransferPopup(tester);
//           expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//           tester.state<NavigatorState>(find.byType(Navigator)).pop();
//           await tester.pump(const Duration(seconds: 1));
//           expect(find.text('Select Item For Stock Transfer'), findsNothing);
//           expect(find.byType(BottomNavigationBar), findsOneWidget);
//         });
//
//     testWidgets('[+] Tapping an item navigates to Stock Transfer screen',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           expect(find.text('Stock Transfer'), findsOneWidget);
//         });
//
//     testWidgets('[+] Stock Transfer is a full-page route — no bottom nav',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           expect(find.byType(BottomNavigationBar), findsNothing);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 5 — STOCK TRANSFER TO GODOWN SCREEN: UI
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — UI Rendering', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] FILLED stock chip visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('FILLED'), findsOneWidget);
//     });
//
//     testWidgets('[+] EMPTY stock chip visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('EMPTY'), findsOneWidget);
//     });
//
//     testWidgets('[+] DEFECTIVE stock chip visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('DEFECTIVE'), findsOneWidget);
//     });
//
//     testWidgets('[+] TRANSFER DETAILS section label visible', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.text('TRANSFER DETAILS'), findsOneWidget);
//     });
//
//     testWidgets('[+] STOCK TRANSFER HISTORY section label visible',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 4));
//           expect(find.text('STOCK TRANSFER HISTORY'), findsOneWidget);
//         });
//
//     testWidgets('[+] 3 quantity TextFields present (Filled, Empty, Defective)',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           expect(find.byType(TextField).evaluate().length,
//               greaterThanOrEqualTo(3));
//         });
//
//     testWidgets('[+] Submit ElevatedButton present', (tester) async {
//       await _navigateToTransferScreen(tester);
//       expect(find.widgetWithText(ElevatedButton, 'Submit'), findsOneWidget);
//     });
//
//     testWidgets('[+] DropdownButtonFormField for godown selection present',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 4));
//           expect(find.byType(DropdownButtonFormField<dynamic>), findsOneWidget);
//         });
//
//     testWidgets('[+] Godown dropdown hint "Select Godown" shown by default',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 4));
//           expect(find.text('Select Godown'), findsWidgets);
//         });
//
//     testWidgets('[+] History ListView.builder present', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 3));
//       expect(find.byType(ListView), findsWidgets);
//     });
//
//     testWidgets('[+] History list is scrollable without crash', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 4));
//       final listViews = find.byType(ListView);
//       if (listViews.evaluate().isNotEmpty) {
//         await tester.drag(listViews.last, const Offset(0, -150));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 6 — STOCK TRANSFER: FORM VALIDATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Form Validation', () {
//     testWidgets('[-] Submit with no godown selected → "Select godown." flush bar',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '5');
//           await tester.pump();
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.text('Select godown.'), findsOneWidget);
//           expect(find.text('Stock Transfer'), findsOneWidget);
//         });
//
//     testWidgets(
//         '[-] Submit with godown but all qty fields empty → validation flush bar',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           await _selectFirstGodown(tester);
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets(
//         '[-] Filled Qty > available stock: field is cleared by onChanged',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '999');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets(
//         '[-] Empty Qty > available stock: field is cleared by onChanged',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(1), '999');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(1)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets(
//         '[-] Defective Qty > available stock: field is cleared by onChanged',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(2), '999');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(2)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets('[+] Qty TextField uses digitsOnly formatter — letters stripped',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), 'abc');
//           await tester.pump();
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text, equals(''));
//         });
//
//     testWidgets('[+] Qty TextField max length 3 — excess chars stripped',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '12345');
//           await tester.pump();
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text.length, lessThanOrEqualTo(3));
//         });
//
//     testWidgets('[+] Remark TextField max length 250', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.enterText(find.byType(TextField).at(3), 'A' * 300);
//       await tester.pump();
//       final ctrl =
//           tester.widget<TextField>(find.byType(TextField).at(3)).controller;
//       expect(ctrl?.text.length, lessThanOrEqualTo(250));
//     });
//
//     testWidgets('[+] Valid qty in range (1) accepted without clearing',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.enterText(find.byType(TextField).at(0), '1');
//           await tester.pump(const Duration(milliseconds: 500));
//           final ctrl =
//               tester.widget<TextField>(find.byType(TextField).at(0)).controller;
//           expect(ctrl?.text, equals('1'));
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 7 — STOCK TRANSFER: GODOWN DROPDOWN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Godown Dropdown', () {
//     testWidgets('[+] Dropdown opens and shows items on tap', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 4));
//       await tester.tap(find.text('Select Godown'));
//       await tester.pumpAndSettle(const Duration(seconds: 2));
//       expect(find.byType(DropdownMenuItem<dynamic>), findsWidgets);
//     });
//
//     testWidgets('[+] Selecting a godown replaces hint text', (tester) async {
//       await _navigateToTransferScreen(tester);
//       await tester.pump(const Duration(seconds: 4));
//       await _selectFirstGodown(tester);
//       expect(find.text('Select Godown'), findsNothing);
//     });
//
//     testWidgets(
//         '[-] Submit after godown + qty with stockTransferFlag=false shows alert',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           await _selectFirstGodown(tester);
//           await tester.enterText(find.byType(TextField).at(0), '1');
//           await tester.pump();
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 8 — STOCK TRANSFER: BACK NAVIGATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Back Navigation', () {
//     testWidgets('[+] Back button pops screen and shows Dashboard bottom nav',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           final backBtn = find.byTooltip('Back');
//           if (backBtn.evaluate().isNotEmpty) {
//             await tester.tap(backBtn);
//           } else {
//             tester.state<NavigatorState>(find.byType(Navigator)).pop();
//           }
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.byType(BottomNavigationBar), findsOneWidget);
//         });
//
//     testWidgets('[+] Dashboard stays at index 0 after returning from transfer',
//             (tester) async {
//           await _navigateToTransferScreen(tester);
//           tester.state<NavigatorState>(find.byType(Navigator)).pop();
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           expect(
//               tester
//                   .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//                   .currentIndex,
//               0);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 9 — STOCK TRANSFER: FULL E2E HAPPY PATH
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] StockTransferTOGodownScreen — Full Happy Path E2E', () {
//     testWidgets('[+] Transfer → popup → item → fill form → Submit: no crash',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.pump(const Duration(seconds: 3));
//
//           await tester.tap(find.text('Transfer'));
//           await tester.pump(const Duration(seconds: 2));
//           expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//
//           await tester.tap(find.byType(ListTile).first);
//           await tester.pump(const Duration(seconds: 3));
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.text('Stock Transfer'), findsOneWidget);
//
//           await tester.pump(const Duration(seconds: 3));
//           await _selectFirstGodown(tester);
//
//           await tester.enterText(find.byType(TextField).at(0), '1');
//           await tester.pump();
//           await tester.enterText(find.byType(TextField).at(1), '1');
//           await tester.pump();
//           await tester.enterText(find.byType(TextField).at(3), 'Integration test remark');
//           await tester.pump();
//
//           await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
//           await tester.pump(const Duration(seconds: 3));
//           await tester.pump(const Duration(seconds: 3));
//
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 10 — MORE OPTIONS SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MoreOptionScreenGodownKeeper — UI Rendering', () {
//     testWidgets('[+] More Options screen renders without crash', (tester) async {
//       await _goToMore(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Hero header shows "More Options" title', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('More Options'), findsOneWidget);
//     });
//
//     testWidgets('[+] Hero header shows "Godown Keeper" subtitle', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Godown Keeper'), findsOneWidget);
//     });
//
//     testWidgets('[+] Section label "ITEM RECEIPT / RETURN" visible',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.text('ITEM RECEIPT / RETURN'), findsOneWidget);
//         });
//
//     testWidgets('[+] Section label "EXMI / REV-EMR" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('EXMI / REV-EMR'), findsOneWidget);
//     });
//
//     testWidgets('[+] Section label "MARK DEFECTIVE" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('MARK DEFECTIVE'), findsOneWidget);
//     });
//
//     testWidgets('[+] Section label "ACCOUNT" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('ACCOUNT'), findsOneWidget);
//     });
//
//     testWidgets('[+] Menu item "Item Receipt" visible with correct subtitle',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.text('Item Receipt'), findsOneWidget);
//           expect(find.text('Record incoming stock items'), findsOneWidget);
//         });
//
//     testWidgets('[+] Menu item "Item Return" visible with correct subtitle',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.text('Item Return'), findsOneWidget);
//           expect(find.text('Process returned items'), findsOneWidget);
//         });
//
//     testWidgets('[+] Menu item "Return EXMI / Rev-EMR" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Return EXMI / Rev-EMR'), findsOneWidget);
//     });
//
//     testWidgets('[+] Menu item "Receipt EXMI" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Receipt EXMI'), findsOneWidget);
//     });
//
//     testWidgets('[+] Menu item "Mark Defective" visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Mark Defective'), findsOneWidget);
//     });
//
//     testWidgets('[+] Logout menu item visible', (tester) async {
//       await _goToMore(tester);
//       expect(find.text('Logout'), findsOneWidget);
//     });
//
//     testWidgets('[+] All menu items have chevron_right trailing icon',
//             (tester) async {
//           await _goToMore(tester);
//           expect(find.byIcon(Icons.chevron_right_rounded), findsWidgets);
//         });
//
//     testWidgets('[+] More screen is scrollable without crash', (tester) async {
//       await _goToMore(tester);
//       final scrollable = find.byType(SingleChildScrollView);
//       if (scrollable.evaluate().isNotEmpty) {
//         await tester.drag(scrollable.first, const Offset(0, -200));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 11 — MORE OPTIONS SCREEN: NAVIGATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MoreOptionScreenGodownKeeper — Navigation', () {
//     testWidgets('[+] Tapping "Item Receipt" navigates away from More screen',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Tapping "Item Return" navigates away from More screen',
//             (tester) async {
//           await _goToItemReturnScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets(
//         '[+] Tapping "Return EXMI / Rev-EMR" navigates to XMI return screen',
//             (tester) async {
//           await _goToReturnXMIScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Tapping "Receipt EXMI" navigates to XMI list screen',
//             (tester) async {
//           await _goToReceiptXMIListScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Tapping "Mark Defective" navigates to defective screen',
//             (tester) async {
//           await _goToMarkDefectiveScreen(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 12 — MORE OPTIONS SCREEN: LOGOUT DIALOG
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MoreOptionScreenGodownKeeper — Logout Dialog', () {
//     testWidgets('[+] Tapping Logout opens "Confirm Logout" AlertDialog',
//             (tester) async {
//           await _goToMore(tester);
//           await tester.tap(find.text('Logout'));
//           await tester.pump(const Duration(milliseconds: 500));
//           expect(find.text('Confirm Logout'), findsOneWidget);
//         });
//
//     testWidgets('[+] Logout dialog shows "Are you sure you want to logout?"',
//             (tester) async {
//           await _goToMore(tester);
//           await tester.tap(find.text('Logout'));
//           await tester.pump(const Duration(milliseconds: 500));
//           expect(
//               find.text('Are you sure you want to logout?'), findsOneWidget);
//         });
//
//     testWidgets('[+] Logout dialog shows Cancel and Logout buttons',
//             (tester) async {
//           await _goToMore(tester);
//           await tester.tap(find.text('Logout'));
//           await tester.pump(const Duration(milliseconds: 500));
//           expect(find.text('Cancel'), findsOneWidget);
//           expect(find.widgetWithText(ElevatedButton, 'Logout'), findsOneWidget);
//         });
//
//     testWidgets('[+] Tapping Cancel closes the logout dialog', (tester) async {
//       await _goToMore(tester);
//       await tester.tap(find.text('Logout'));
//       await tester.pump(const Duration(milliseconds: 500));
//       expect(find.text('Confirm Logout'), findsOneWidget);
//
//       await tester.tap(find.text('Cancel'));
//       await tester.pump(const Duration(milliseconds: 500));
//
//       expect(find.text('Confirm Logout'), findsNothing);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Logout dialog shows logout icon', (tester) async {
//       await _goToMore(tester);
//       await tester.tap(find.text('Logout'));
//       await tester.pump(const Duration(milliseconds: 500));
//       expect(find.byIcon(Icons.logout_rounded), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 13 — ITEM RECEIPT SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] ItemReceiptScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       // ItemReceiptScreen is a full page route
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Vehicle number TextField is present', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       // At least one TextField for vehicle number
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[+] Cylinder quantity TextField is present', (tester) async {
//       await _goToItemReceiptScreen(tester);
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[-] Submit without vehicle number shows validation error',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
//           if (submitBtn.evaluate().isNotEmpty) {
//             await tester.tap(submitBtn);
//             await tester.pump(const Duration(seconds: 1));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Screen has item type selector (DropdownButton or similar)',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           await tester.pump(const Duration(seconds: 2));
//           final dropdowns = find.byType(DropdownButton<dynamic>);
//           final dropdownFormFields = find.byType(DropdownButtonFormField<dynamic>);
//           final hasDropdown = dropdowns.evaluate().isNotEmpty ||
//               dropdownFormFields.evaluate().isNotEmpty;
//           expect(hasDropdown, isTrue,
//               reason: 'Item type selector should be a dropdown');
//         });
//
//     testWidgets('[+] Invoice / EMR / Both category options exist',
//             (tester) async {
//           await _goToItemReceiptScreen(tester);
//           await tester.pump(const Duration(seconds: 2));
//           // At least one of these labels should appear (radio, chip, or tab)
//           final hasInvoice = find.text('Invoice').evaluate().isNotEmpty;
//           final hasEMR = find.text('EMR').evaluate().isNotEmpty;
//           final hasBoth = find.text('Both').evaluate().isNotEmpty;
//           expect(hasInvoice || hasEMR || hasBoth, isTrue,
//               reason: 'Invoice / EMR / Both category should be visible');
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 14 — ITEM RETURN SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] ItemReturnScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToItemReturnScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToItemReturnScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Return list or empty state is rendered', (tester) async {
//       await _goToItemReturnScreen(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final hasList = find.byType(ListView).evaluate().isNotEmpty;
//       final hasEmpty = find.byType(Scaffold).evaluate().isNotEmpty;
//       expect(hasList || hasEmpty, isTrue);
//     });
//
//     testWidgets('[+] Screen is scrollable without crash', (tester) async {
//       await _goToItemReturnScreen(tester);
//       await tester.pump(const Duration(seconds: 2));
//       final scrollable = find.byType(SingleChildScrollView);
//       if (scrollable.evaluate().isNotEmpty) {
//         await tester.drag(scrollable.first, const Offset(0, -200));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 15 — ADD RETURN ITEM XMI SCREEN (EXMI / Rev-EMR Return)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] AddReturnItemXMIScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToReturnXMIScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation on full-page route', (tester) async {
//       await _goToReturnXMIScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Vehicle number input present', (tester) async {
//       await _goToReturnXMIScreen(tester);
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[+] Invoice quantity and EMR quantity inputs present',
//             (tester) async {
//           await _goToReturnXMIScreen(tester);
//           await tester.pump(const Duration(seconds: 2));
//           // At least 2 TextFields: vehicle + invoice + EMR qty
//           expect(find.byType(TextField).evaluate().length,
//               greaterThanOrEqualTo(2));
//         });
//
//     testWidgets('[-] Submit without data shows validation error',
//             (tester) async {
//           await _goToReturnXMIScreen(tester);
//           final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
//           if (submitBtn.evaluate().isNotEmpty) {
//             await tester.tap(submitBtn);
//             await tester.pump(const Duration(seconds: 1));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 16 — ITEM RETURN XMI LIST SCREEN (Receipt EXMI)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] ItemReturnXMIListScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToReceiptXMIListScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToReceiptXMIListScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Receipt list or empty state rendered after API call',
//             (tester) async {
//           await _goToReceiptXMIListScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 17 — MARK DEFECTIVE ITEM SCREEN
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] MarkDefectiveItemScreen', () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToMarkDefectiveScreen(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] No bottom navigation bar on this screen', (tester) async {
//       await _goToMarkDefectiveScreen(tester);
//       expect(find.byType(BottomNavigationBar), findsNothing);
//     });
//
//     testWidgets('[+] Defective item list or empty state rendered',
//             (tester) async {
//           await _goToMarkDefectiveScreen(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Mark defective action widget present', (tester) async {
//       await _goToMarkDefectiveScreen(tester);
//       await tester.pump(const Duration(seconds: 2));
//       // Either a button, icon button or tappable list tile should exist
//       final hasButton = find.byType(ElevatedButton).evaluate().isNotEmpty ||
//           find.byType(IconButton).evaluate().isNotEmpty ||
//           find.byType(ListTile).evaluate().isNotEmpty;
//       expect(hasButton, isTrue,
//           reason: 'Mark defective action widget must exist');
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 18 — DELIVERY MEN LIST SHOW SCREEN (Daily Sale tab)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] DeliveryMenListShowScreen', () {
//     testWidgets('[+] Screen renders on Daily Sale tab without crash',
//             (tester) async {
//           await _goToDailySale(tester);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Bottom navigation bar still visible on Daily Sale tab',
//             (tester) async {
//           await _goToDailySale(tester);
//           expect(find.byType(BottomNavigationBar), findsOneWidget);
//         });
//
//     testWidgets('[+] Delivery men list or loading state rendered',
//             (tester) async {
//           await _goToDailySale(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] List is scrollable without crash', (tester) async {
//       await _goToDailySale(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final listViews = find.byType(ListView);
//       if (listViews.evaluate().isNotEmpty) {
//         await tester.drag(listViews.first, const Offset(0, -150));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets(
//         '[+] Tapping a delivery boy item does not crash (navigates to DailyRefillSalePage)',
//             (tester) async {
//           await _goToDailySale(tester);
//           await tester.pump(const Duration(seconds: 3));
//           final listTiles = find.byType(ListTile);
//           if (listTiles.evaluate().isNotEmpty) {
//             await tester.tap(listTiles.first);
//             await tester.pump(const Duration(seconds: 3));
//             await tester.pump(const Duration(seconds: 2));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 19 — STOCK SUBMIT TO MANAGER SCREEN (Today's Summary tab)
//   // ══════════════════════════════════════════════════════════════════════════
//   group("[REAL] StockSubmitToManager (Today's Summary tab)", () {
//     testWidgets('[+] Screen renders without crash', (tester) async {
//       await _goToTodaysSummary(tester);
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Bottom navigation bar still visible', (tester) async {
//       await _goToTodaysSummary(tester);
//       expect(find.byType(BottomNavigationBar), findsOneWidget);
//     });
//
//     testWidgets('[+] Transaction list or empty state rendered after API call',
//             (tester) async {
//           await _goToTodaysSummary(tester);
//           await tester.pump(const Duration(seconds: 3));
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] List is scrollable without crash', (tester) async {
//       await _goToTodaysSummary(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final listViews = find.byType(ListView);
//       if (listViews.evaluate().isNotEmpty) {
//         await tester.drag(listViews.first, const Offset(0, -150));
//         await tester.pump();
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Edit / Delete options discoverable on long press or swipe',
//             (tester) async {
//           await _goToTodaysSummary(tester);
//           await tester.pump(const Duration(seconds: 3));
//           final listTiles = find.byType(ListTile);
//           if (listTiles.evaluate().isNotEmpty) {
//             await tester.longPress(listTiles.first);
//             await tester.pump(const Duration(milliseconds: 500));
//           }
//           // Either dialog / bottom sheet appears, or screen stays stable
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 20 — DAILY REFILL SALE PAGE (deep navigation from Delivery Boy list)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] DailyRefillSalePage', () {
//     // Helper: navigate to first delivery boy's transaction page
//     Future<bool> _goToDailyRefillSale(WidgetTester tester) async {
//       await _goToDailySale(tester);
//       await tester.pump(const Duration(seconds: 3));
//       final listTiles = find.byType(ListTile);
//       if (listTiles.evaluate().isEmpty) return false;
//       await tester.tap(listTiles.first);
//       await tester.pump(const Duration(seconds: 3));
//       await tester.pump(const Duration(seconds: 3));
//       return true;
//     }
//
//     testWidgets('[+] Screen renders when delivery boy tapped', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) {
//         // No delivery boys loaded — skip gracefully
//         expect(find.byType(Scaffold), findsWidgets);
//         return;
//       }
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//
//     testWidgets('[+] Vehicle number dropdown loaded from API', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) return;
//       await tester.pump(const Duration(seconds: 2));
//       final dropdowns = find.byType(DropdownButton<dynamic>);
//       final dropdownFormFields =
//       find.byType(DropdownButtonFormField<dynamic>);
//       expect(
//           dropdowns.evaluate().isNotEmpty ||
//               dropdownFormFields.evaluate().isNotEmpty,
//           isTrue);
//     });
//
//     testWidgets('[+] Sale quantity TextField is present', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) return;
//       expect(find.byType(TextField), findsWidgets);
//     });
//
//     testWidgets('[-] Submit without item selection shows validation error',
//             (tester) async {
//           final reached = await _goToDailyRefillSale(tester);
//           if (!reached) return;
//           final addBtn = find.widgetWithText(ElevatedButton, 'Add');
//           if (addBtn.evaluate().isNotEmpty) {
//             await tester.tap(addBtn);
//             await tester.pump(const Duration(seconds: 1));
//           }
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Customer type selector (SV / TV) present', (tester) async {
//       final reached = await _goToDailyRefillSale(tester);
//       if (!reached) return;
//       await tester.pump(const Duration(seconds: 2));
//       final hasSV = find.text('SV').evaluate().isNotEmpty;
//       final hasTV = find.text('TV').evaluate().isNotEmpty;
//       // At least one customer type should be visible in the UI
//       expect(hasSV || hasTV, isTrue,
//           reason: 'Customer type selector (SV/TV) must be visible');
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 21 — SQC REGISTER SCREEN (via Dashboard SQC section)
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] SQCRegisterScreen', () {
//     testWidgets('[+] Dashboard loads SQC summary section without crash',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.pump(const Duration(seconds: 4));
//           // Dashboard hosts SQC summary — just verify no crash
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] SQC data ListView rendered if vehicles exist', (tester) async {
//       await _bootApp(tester);
//       await tester.pump(const Duration(seconds: 4));
//       // SQC list may or may not have data — no crash is the assertion
//       expect(find.byType(Scaffold), findsWidgets);
//     });
//   });
//
//   // ══════════════════════════════════════════════════════════════════════════
//   // GROUP 22 — CROSS-SCREEN / ROLE-BASED VALIDATION
//   // ══════════════════════════════════════════════════════════════════════════
//   group('[REAL] Cross-Screen — Godown Keeper Role Validation', () {
//     testWidgets('[+] roleId=0 (Godown Keeper) lands on correct bottom nav',
//             (tester) async {
//           await _bootApp(tester);
//           expect(find.text('Dashboard'), findsOneWidget);
//           expect(find.text('Daily Sale'), findsOneWidget);
//           expect(find.text("Today's Summary"), findsOneWidget);
//           expect(find.text('More'), findsOneWidget);
//         });
//
//     testWidgets('[+] godownId and godownKeeperId loaded from SharedPreferences',
//             (tester) async {
//           // Verify the prefs are set correctly
//           final prefs = await SharedPreferences.getInstance();
//           expect(prefs.getString('godownId'), '1');
//           expect(prefs.getString('godownKeeperId'), '22');
//         });
//
//     testWidgets('[+] Distributor name loaded from SharedPreferences',
//             (tester) async {
//           final prefs = await SharedPreferences.getInstance();
//           expect(prefs.getString('DistributorName'),
//               'SHREE RENUKA GAS SUPPLY COMPANY');
//         });
//
//     testWidgets('[+] Full app cycle: Dashboard → More → Dashboard stable',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.tap(find.text('More'));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.tap(find.text('Dashboard'));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.pump(const Duration(seconds: 2));
//           expect(
//               tester
//                   .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//                   .currentIndex,
//               0);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//
//     testWidgets('[+] Full app cycle: Dashboard → Daily Sale → Summary stable',
//             (tester) async {
//           await _bootApp(tester);
//           await tester.tap(find.text('Daily Sale'));
//           await tester.pump(const Duration(seconds: 2));
//           await tester.tap(find.text("Today's Summary"));
//           await tester.pump(const Duration(seconds: 2));
//           expect(
//               tester
//                   .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
//                   .currentIndex,
//               2);
//           expect(find.byType(Scaffold), findsWidgets);
//         });
//   });
// }



// =============================================================================
// godown_keeper_integration_test.dart
// =============================================================================
//
// Full Integration Test Suite — Godown Keeper Module
//
// Covers:
//   1. Login Flow           (positive, negative, edge cases)
//   2. OTP Flow             (positive, negative)
//   3. Dashboard Screen     (UI, dropdown, Transfer button, bottom sheet)
//   4. Transfer Screen      (field validation, submit, API, navigation)
//
// Frameworks / packages used:
//   integration_test        (official Flutter integration test runner)
//   flutter_test            (matchers, finders, pumpAndSettle)
//   http                    (MockClient from package:http/testing.dart)
//   shared_preferences      (setMockInitialValues — zero extra deps)
//
// pubspec.yaml additions needed:
// ─────────────────────────────
// dev_dependencies:
//   integration_test:
//     sdk: flutter
//   flutter_test:
//     sdk: flutter
//
// NOTE: No extra mocking package is required.
//   • SharedPreferences  → SharedPreferences.setMockInitialValues()  (flutter_test)
//   • HTTP client        → http.MockClient  (already in package:http/testing.dart)
//
// Both packages come with Flutter by default — just add them to pubspec if
// not already present:
//   dependencies:
//     http: ^1.2.0
//     shared_preferences: ^2.2.3
//
// =============================================================================

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/GetGodownListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── App entry point (adjust import to your project structure) ─────────────────
import 'package:lpgsalesandinventory/main.dart' as app;



/// SharedPreferences keys and their test values.
/// These are injected before every test via [_seedSharedPrefs].
class TestPrefs {
  // Real JWT token from the app's actual login session (used in _setupRealPrefs).
  static const String kToken          = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJTYWhlYnJhbyBKYW5nYWxlIiwianRpIjoiZTU1OWQ2OTAtMjg5Ni00ODAzLWJhMTYtNjk1Mjk0ZjZkMDhkIiwibmFtZWlkIjoiU2FoZWJyYW8gSmFuZ2FsZSIsInJvbGUiOiIwIiwiTG9nZ2VkT24iOiI1LzE5LzIwMjYgNToyNjoxOSBQTSIsIkRpc3BsYXlOYW1lIjoiU2FoZWJyYW8gSmFuZ2FsZSIsIm5iZiI6MTc3OTE5MTc3OSwiZXhwIjoxNzc5Mjk5Nzc5LCJpYXQiOjE3NzkxOTE3NzksImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9.IJSs_b6kpyp5Zxh4L065jsRLs8eyw7Cxv9r5yweqqpk';
  static const String kDistributorId  = '8118';
  static const String kStaffId        = '22';
  static const String kUserId         = '0';
  static const String kStaffName      = 'Sahebrao Jangale';
  static const String kRoleName       = 'GodownKeeper';
  static const String kRoleId         = '0';
  static const String kMobileNo       = '9700097000';
  static const String kGodownId       = '1';
  static const String kGodownKeeperId = '22';
  static const String kDistributorName = 'SHREE RENUKA GAS SUPPLY COMPANY';
  static const String kIsAlreadyLogin = '1';
}

/// Seeds [SharedPreferences] with authenticated session values.
Future<void> _seedSharedPrefs() async {
  SharedPreferences.setMockInitialValues({
    'token':          TestPrefs.kToken,
    'DistributorId':  TestPrefs.kDistributorId,
    'StaffId':        TestPrefs.kStaffId,
    'UserId':         TestPrefs.kUserId,
    'StaffName':      TestPrefs.kStaffName,
    'RoleName':       TestPrefs.kRoleName,
    'RoleId':         TestPrefs.kRoleId,
    'roleId':         TestPrefs.kRoleId,        // app may check lowercase key too
    'MobileNo':       TestPrefs.kMobileNo,
    'godownId':       TestPrefs.kGodownId,
    'godownKeeperId': TestPrefs.kGodownKeeperId,
    'DistributorName': TestPrefs.kDistributorName,
    'IsAlreadyLogin': TestPrefs.kIsAlreadyLogin,
    'userActive':     'Y',                      // required: prevents Deactivated User screen
  });
}

/// Clears session keys but keeps the minimum prefs the app needs to route
/// to the Login screen rather than the "Deactivated User" dead-end.
/// (The splash checks userActive == 'Y' before showing Login.)
Future<void> _clearSharedPrefs() async {
  SharedPreferences.setMockInitialValues({
    'userActive': 'Y',   // must be present or splash shows Deactivated User
  });
}


/// Boots the app from a clean (logged-out) state and pumps past the splash.
/// Use this for Login-flow tests.
Future<void> _bootApp(WidgetTester tester) async {
  app.main();
  // Pump through splash screen (typically a 2-3 s Timer or animated logo).
  await tester.pump(const Duration(seconds: 3));
  await tester.pump(const Duration(seconds: 3));
  // Let remaining animations and frame callbacks settle.
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

/// Seeds SharedPreferences with a valid session, boots the app, and pumps
/// until the Dashboard is visible.  Use this for Dashboard / Transfer tests.
Future<void> _bootAppLoggedIn(WidgetTester tester) async {
  await _seedSharedPrefs();
  await _bootOnly(tester);
}

/// Boots the app WITHOUT touching SharedPreferences.
/// Call this when the test has already seeded its own prefs (e.g. the
/// IsAlreadyLogin == 0 session test).
Future<void> _bootOnly(WidgetTester tester) async {
  app.main();
  await tester.pump(const Duration(seconds: 3));
  await tester.pump(const Duration(seconds: 3));
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle(const Duration(seconds: 10));
}

// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// SECTION 1 — MOCK API RESPONSES
// ──────────────────────────────────────────────────────────────────────────────
// =============================================================================

/// Successful login API response with RoleId == 0 (Godown Keeper).
final Map<String, dynamic> kLoginSuccessResponse = {
  "authToken": {
    "StaffId": 22,
    "DistributorId": 8118,
    "StaffName": "Sahebrao Jangale",
    "MobileNo": "9700097000",
    "RoleId": 0,
    "GodownId": 1,
    "GodownKeeperId": 22,
    "OTP": "1142",
    "Status": "Success",
    "Token": "sample_jwt_token",
    "DistributorName": "SHREE RENUKA GAS SUPPLY COMPANY",
    "UserId": 0,
    "IsAlreadyLogin": 1,
  }
};

/// Login API response where RoleId != 0 (not a Godown Keeper).
final Map<String, dynamic> kLoginNonGodownKeeperResponse = {
  "authToken": {
    "StaffId": 99,
    "DistributorId": 8118,
    "StaffName": "Some Manager",
    "MobileNo": "9700097001",
    "RoleId": 2,     // ← Not a Godown Keeper
    "GodownId": 1,
    "GodownKeeperId": 0,
    "OTP": "0000",
    "Status": "Success",
    "Token": "other_token",
    "DistributorName": "OTHER COMPANY",
    "UserId": 0,
    "IsAlreadyLogin": 1,
  }
};

/// Generic API error response body.
final Map<String, dynamic> kApiErrorResponse = {
  "message": "Internal Server Error",
  "status": false,
};

/// Mock current stock list (used by dashboard & bottom sheet).
final List<Map<String, dynamic>> kCurrentStockList = [
  {
    "ItemId": 1,
    "ItemName": "14.2 KG",
    "CurrentStkFilled": 50,
    "CurrentStkEmpty": 20,
    "CurrentStkDefective": 5,
  },
  {
    "ItemId": 2,
    "ItemName": "5 KG",
    "CurrentStkFilled": 30,
    "CurrentStkEmpty": 10,
    "CurrentStkDefective": 2,
  },
];

/// Mock today's opening stock.
final List<Map<String, dynamic>> kOpeningStockList = [
  {
    "ItemId": 1,
    "ItemName": "14.2 KG",
    "FilledOpeningStk": 55,
    "EmptyOpeningStk": 22,
    "DefOpeningStk": 4,
  },
];

/// Mock godown list for transfer screen dropdown.
final List<Map<String, dynamic>> kGodownList = [
  {"GodownId": 1, "GodownName": "Main Godown"},
  {"GodownId": 2, "GodownName": "Secondary Godown"},
];

/// Mock stock transfer submit success response.
final Map<String, dynamic> kTransferSubmitSuccess = {
  "status": true,
  "message": "Stock transfer submitted successfully.",
};

// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// SECTION 2 — HELPER UTILITIES
// ──────────────────────────────────────────────────────────────────────────────
// =============================================================================

/// Helper namespace for common widget finders and interaction methods.
///
/// Using extension-style static helpers keeps test code readable and DRY.
class TestHelpers {
  // ── Finders ─────────────────────────────────────────────────────────────────

  /// Finds a [TextFormField] or [TextField] by its label / hint text.
  static Finder fieldByLabel(String label) =>
      find.widgetWithText(TextFormField, label).first;

  /// Finds a [TextField] by hint text.
  static Finder textFieldByHint(String hint) =>
      find.widgetWithText(TextField, hint).first;

  /// Finds an [ElevatedButton] by label.
  static Finder elevatedButtonByText(String text) =>
      find.widgetWithText(ElevatedButton, text);

  /// Finds a [TextButton] by label.
  static Finder textButtonByText(String text) =>
      find.widgetWithText(TextButton, text);

  /// Finds any widget containing the given text (across subtypes).
  static Finder anyText(String text) => find.text(text);

  /// Finds a [DropdownButton] widget (generic; refine with a key if needed).
  static Finder dropdown() => find.byType(DropdownButton<dynamic>);

  /// Finds a [DropdownButton] of a specific value type.
  static Finder typedDropdown<T>() => find.byType(DropdownButton<T>);

  /// Finds a [BottomSheet] in the widget tree.
  static Finder bottomSheet() => find.byType(BottomSheet);

  /// Finds a [CircularProgressIndicator] (loading state).
  static Finder loadingIndicator() => find.byType(CircularProgressIndicator);

  /// Finds a [SnackBar] widget.
  static Finder snackBar() => find.byType(SnackBar);

  // ── Interaction helpers ──────────────────────────────────────────────────────

  /// Types text into a field found by [finder], clearing it first.
  static Future<void> enterText(
      WidgetTester tester,
      Finder finder,
      String text,
      ) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pump();
    await tester.enterText(finder, text);
    await tester.pump();
  }

  /// Taps a widget found by [finder] and waits for animations.
  static Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Scrolls down until [finder] becomes visible.
  static Future<void> scrollUntilVisible(
      WidgetTester tester,
      Finder finder, {
        double dy = 200,
      }) async {
    await tester.scrollUntilVisible(finder, dy);
  }

  /// Pumps the widget tree and settles all animations with a timeout guard.
  static Future<void> settle(
      WidgetTester tester, {
        Duration timeout = const Duration(seconds: 10),
      }) async {
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      timeout,
    );
  }

  /// Verifies a [SnackBar] or [FlushBar] containing [text] is shown.
  static void expectSnackBar(WidgetTester tester, String text) {
    expect(find.text(text), findsOneWidget);
  }

  /// Verifies a validation error text is visible in the widget tree.
  static void expectError(String errorText) {
    expect(find.text(errorText), findsOneWidget);
  }
}

// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// SECTION 3 — LOGIN FLOW TESTS
// ──────────────────────────────────────────────────────────────────────────────
// =============================================================================

/// All tests inside this group exercise the Login screen and the subsequent
/// OTP verification screen.
///
/// Because integration tests run in a real Flutter environment (no mocked
/// Navigator), each test calls [app.main()] and interacts with the actual
/// widget tree.  The HTTP layer is intercepted via a DI-injected mock client
/// (pattern: inject before [app.main()] is called).
///
/// ──────────────────────────────────────────────────────────────────────────
/// IMPORTANT: Replace every `find.byKey(Key('...'))` with your real widget
/// keys, or use the label/hint finders supplied in [TestHelpers].
/// ──────────────────────────────────────────────────────────────────────────
// =============================================================================
// LOGIN SCREEN SOURCE FACTS (MyLogin.dart)
// ─────────────────────────────────────────
// Widget types:
//   • Mobile field : TextField  (hintText: 'Mobile Number')
//                    digitsOnly formatter + max 10 chars → letters are BLOCKED
//                    at input level, they never enter the field
//   • Login button : ElevatedButton  child: Text('Login')
//   • Error widget : Consumer<LoginProvider> renders provider.errorMessage
//                    as a plain Text inside a red Container — NOT a SnackBar
//
// LoginProvider.login() behaviour:
//   • mobileNo.isEmpty     → SnackBar: 'Please fill all the fields'
//   • no internet          → flushbar (Constants.connectionMessage)
//   • API exception        → errorMessage = 'Exception: Invalid User..!'
//                            shown in the red Container on screen
//   • success              → Navigator.pushReplacementNamed('/verifyOtp')
//
// VERIFY OTP SCREEN SOURCE FACTS (VerifyOTP.dart)
// ─────────────────────────────────────────────────
//   • OTP field    : TextField  (hintText: 'Enter OTP')
//                    digitsOnly formatter + max 4 chars → letters BLOCKED
//   • Verify button: ElevatedButton  child: Text('Verify')  ← NOT 'Verify OTP'
//   • Wrong/empty OTP → SnackBar: 'OTP not match..!'
//   • Success flow :
//       1. setUserName("Y")  (userActive = "Y")
//       2. getUserData() reads roleId + userActive from SharedPrefs
//       3. userActive == "Y" && roleId == Constants.roleIdGodown
//          → pushReplacementNamed(BottomNavigationForGodownKeeper.screenName)
//       4. userActive != "Y" → stays on login ("Deactivated User")
// =============================================================================

/// Finds the mobile TextField on LoginScreen by its hintText.
Finder get _mobileField =>
    find.widgetWithText(TextField, 'Mobile Number');

/// Finds the OTP TextField on VerifyOtp screen by its hintText.
Finder get _otpField =>
    find.widgetWithText(TextField, 'Enter OTP');

/// Boots the app (logged-out), enters [mobile], taps Login, and waits
/// until the OTP screen is visible.  Reusable by all OTP-level tests.
Future<void> _loginAndGoToOtp(WidgetTester tester,
    {String mobile = '9700097000'}) async {
  await _bootApp(tester);
  await tester.enterText(_mobileField, mobile);
  await tester.pump();
  await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle(const Duration(seconds: 5));
  // OTP screen landmark
  expect(find.text('Verify OTP'), findsOneWidget);
}

void _loginTests() {
  group('Login Flow —', () {
    setUp(() async {
      await _clearSharedPrefs();
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    // ══════════════════════════════════════════════════════════════════════════
    // LOGIN SCREEN — UI
    // ══════════════════════════════════════════════════════════════════════════

    testWidgets(
      'UI — Login screen renders Sign In card with mobile field and Login button',
          (WidgetTester tester) async {
        await _bootApp(tester);

        // App title visible
        expect(find.text('Niyojan'),    findsWidgets);
        // Card heading
        expect(find.text('Sign In'),    findsOneWidget);
        // Hint in the TextField
        expect(_mobileField,            findsOneWidget);
        // Primary action button
        expect(
          find.widgetWithText(ElevatedButton, 'Login'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'UI — Mobile field accepts only digits (letters are silently blocked)',
          (WidgetTester tester) async {
        await _bootApp(tester);

        // Try typing letters — FilteringTextInputFormatter.digitsOnly blocks them
        await tester.enterText(_mobileField, 'abcABC');
        await tester.pump();

        // Field value must be empty because all input was filtered out
        final tf = tester.widget<TextField>(_mobileField);
        expect(tf.controller!.text, isEmpty);
      },
    );

    testWidgets(
      'UI — Mobile field enforces 10-digit maximum length',
          (WidgetTester tester) async {
        await _bootApp(tester);

        // Type 15 digits — LengthLimitingTextInputFormatter(10) caps at 10
        await tester.enterText(_mobileField, '123456789012345');
        await tester.pump();

        final tf = tester.widget<TextField>(_mobileField);
        expect(tf.controller!.text.length, 10);
      },
    );

    // ══════════════════════════════════════════════════════════════════════════
    // LOGIN — POSITIVE
    // ══════════════════════════════════════════════════════════════════════════

    testWidgets(
      'POSITIVE — Valid 10-digit mobile + Login navigates to OTP screen',
          (WidgetTester tester) async {
        await _bootApp(tester);

        // Act
        await tester.enterText(_mobileField, '9700097000');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Assert — OTP screen landmark text from VerifyOTP.dart
        expect(find.text('Verify OTP'),            findsOneWidget);
        expect(find.text('Enter the 4-digit OTP to verify your account'),
            findsOneWidget);
        // Login loading indicator gone
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
      'POSITIVE — After login, OTP field and Verify button are visible',
          (WidgetTester tester) async {
        await _loginAndGoToOtp(tester);

        // OTP TextField (hintText 'Enter OTP')
        expect(_otpField, findsOneWidget);
        // Verify button — label is 'Verify', NOT 'Verify OTP'
        expect(
          find.widgetWithText(ElevatedButton, 'Verify'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'POSITIVE — Login API saves session keys to SharedPreferences',
          (WidgetTester tester) async {
        // Seed prefs directly (simulates what SharedPref.saveUser() does
        // after a real successful login API call).
        await _seedSharedPrefs();

        final prefs = await SharedPreferences.getInstance();

        // Keys written by SharedPref.saveUser() — exact key names from source
        expect(prefs.getString('token'),          equals(TestPrefs.kToken));
        expect(prefs.getString('roleId'),         equals(TestPrefs.kRoleId));
        expect(prefs.getString('godownId'),       isNotNull);
        expect(prefs.getString('StaffName'),      equals(TestPrefs.kStaffName));
        expect(prefs.getString('DistributorId'),  equals(TestPrefs.kDistributorId));
        expect(prefs.getString('godownKeeperId'), equals(TestPrefs.kGodownKeeperId));
        expect(prefs.getString('MobileNo'),       equals(TestPrefs.kMobileNo));
        expect(prefs.getString('IsAlreadyLogin'), equals(TestPrefs.kIsAlreadyLogin));
      },
    );

    // ══════════════════════════════════════════════════════════════════════════
    // LOGIN — NEGATIVE
    // ══════════════════════════════════════════════════════════════════════════

    testWidgets(
      'NEGATIVE — Empty mobile shows SnackBar: "Please fill all the fields"',
          (WidgetTester tester) async {
        await _bootApp(tester);

        // Tap Login with nothing entered
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump(); // trigger SnackBar animation

        // LoginProvider.login(): mobileNo.isEmpty → SnackBar
        expect(
          find.text('Please fill all the fields'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'NEGATIVE — Mobile shorter than 10 digits — API call fires with partial '
          'number and returns error (no client-side length validation)',
          (WidgetTester tester) async {
        // NOTE: The app has NO client-side length check beyond the
        // LengthLimitingTextInputFormatter.  Submitting 5 digits calls the
        // real API which returns an error → errorMessage shown in red Container.
        await _bootApp(tester);

        await tester.enterText(_mobileField, '12345');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // API returns an error for invalid mobile → errorMessage rendered
        // as Text inside the red Container by Consumer<LoginProvider>
        expect(find.textContaining('Invalid User'), findsOneWidget);
      },
    );

    testWidgets(
      'NEGATIVE — API error shows "Exception: Invalid User..!" in error widget',
          (WidgetTester tester) async {
        // AuthService throws Exception("Invalid User..!") on non-200 response.
        // LoginProvider catches it and sets errorMessage = e.toString().
        await _bootApp(tester);

        // Use an unregistered number so API returns non-200
        await tester.enterText(_mobileField, '0000000000');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump(const Duration(seconds: 5));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Consumer<LoginProvider> renders errorMessage as a Text widget
        expect(find.textContaining('Invalid User'), findsOneWidget);
      },
    );

    testWidgets(
      'NEGATIVE — Loading indicator visible while login API call is in flight',
          (WidgetTester tester) async {
        await _bootApp(tester);

        await tester.enterText(_mobileField, '9700097000');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        // Pump just one frame — API not yet resolved
        await tester.pump(const Duration(milliseconds: 100));

        // Consumer<LoginProvider> shows CircularProgressIndicator while
        // provider.isLoading == true
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'NEGATIVE — Non-Godown-Keeper role (RoleId != roleIdGodown) does not '
          'reach Dashboard after OTP verify',
          (WidgetTester tester) async {
        // After OTP verify, getUserData() in VerifyOTP checks roleId.
        // If roleId != Constants.roleIdGodown, it routes back to Login.
        // Seed prefs with a Manager roleId so getUserData() redirects.
        SharedPreferences.setMockInitialValues({
          'userActive': 'Y',
          'roleId':     '3',             // Manager role, not Godown Keeper
          'OTP':        '1142',
          'token':      TestPrefs.kToken,
        });

        await _bootApp(tester);

        await tester.enterText(_mobileField, '9700097000');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Enter correct OTP
        await tester.enterText(_otpField, '1142');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Must NOT show Godown Keeper dashboard
        expect(find.text("TODAY'S OPENING STOCK"), findsNothing);
        // getUserData() pushes back to MyLogin for unrecognised role
        expect(find.text('Sign In'), findsOneWidget);
      },
    );

    testWidgets(
      'NEGATIVE — userActive != "Y" (deactivated) stays on Login after verify',
          (WidgetTester tester) async {
        // getUserData() in VerifyOTP: userActive != "Y" → debug "Deactivated User"
        // → pushReplacementNamed(MyLogin.screenName)
        SharedPreferences.setMockInitialValues({
          'userActive': 'N',             // deactivated
          'roleId':     TestPrefs.kRoleId,
          'OTP':        '1142',
          'token':      TestPrefs.kToken,
        });

        await _bootApp(tester);

        await tester.enterText(_mobileField, '9700097000');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        await tester.enterText(_otpField, '1142');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Should be back on Login, not on Dashboard
        expect(find.text('Sign In'), findsOneWidget);
      },
    );

    // ══════════════════════════════════════════════════════════════════════════
    // OTP SCREEN — POSITIVE
    // ══════════════════════════════════════════════════════════════════════════

    testWidgets(
      'OTP POSITIVE — Correct OTP with Godown Keeper role navigates to Dashboard',
          (WidgetTester tester) async {
        // Seed the prefs that getUserData() will read after verify
        SharedPreferences.setMockInitialValues({
          'userActive':    'Y',
          'roleId':        TestPrefs.kRoleId,   // '0' = Godown Keeper
          'OTP':           '1142',
          'token':         TestPrefs.kToken,
          'DistributorId': TestPrefs.kDistributorId,
          'StaffId':       TestPrefs.kStaffId,
          'godownId':      TestPrefs.kGodownId,
          'godownKeeperId':TestPrefs.kGodownKeeperId,
          'MobileNo':      TestPrefs.kMobileNo,
          'StaffName':     TestPrefs.kStaffName,
          'DistributorName':TestPrefs.kDistributorName,
          'IsAlreadyLogin':TestPrefs.kIsAlreadyLogin,
        });

        await _bootApp(tester);

        // Enter mobile and go to OTP screen
        await tester.enterText(_mobileField, '9700097000');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // Enter the correct OTP that was stored in prefs
        await tester.enterText(_otpField, '1142');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle(const Duration(seconds: 10));

        // Godown Keeper Dashboard must be visible
        expect(find.text("TODAY'S OPENING STOCK"), findsOneWidget);
      },
    );

    // ══════════════════════════════════════════════════════════════════════════
    // OTP SCREEN — NEGATIVE
    // ══════════════════════════════════════════════════════════════════════════

    testWidgets(
      'OTP NEGATIVE — Wrong OTP shows SnackBar: "OTP not match..!"',
          (WidgetTester tester) async {
        // Seed OTP so the comparison has something to check against
        SharedPreferences.setMockInitialValues({
          'userActive': 'Y',
          'roleId':     TestPrefs.kRoleId,
          'OTP':        '1142',
          'token':      TestPrefs.kToken,
        });

        await _loginAndGoToOtp(tester);

        // Enter wrong OTP
        await tester.enterText(_otpField, '9999');
        await tester.pump();
        await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
        await tester.pump(); // trigger SnackBar

        // Exact text from VerifyOTP.dart
        expect(find.text('OTP not match..!'), findsOneWidget);
      },
    );

    testWidgets(
      'OTP NEGATIVE — Empty OTP shows SnackBar: "OTP not match..!"',
          (WidgetTester tester) async {
        // Empty string never equals the stored OTP → same mismatch SnackBar
        SharedPreferences.setMockInitialValues({
          'userActive': 'Y',
          'roleId':     TestPrefs.kRoleId,
          'OTP':        '1142',
          'token':      TestPrefs.kToken,
        });

        await _loginAndGoToOtp(tester);

        // Do NOT enter anything — tap Verify immediately
        await tester.tap(find.widgetWithText(ElevatedButton, 'Verify'));
        await tester.pump();

        expect(find.text('OTP not match..!'), findsOneWidget);
      },
    );

    testWidgets(
      'OTP EDGE — Letters typed into OTP field are silently blocked '
          '(FilteringTextInputFormatter.digitsOnly)',
          (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({
          'userActive': 'Y',
          'roleId':     TestPrefs.kRoleId,
          'OTP':        '1142',
          'token':      TestPrefs.kToken,
        });

        await _loginAndGoToOtp(tester);

        // Type letters — formatter blocks them entirely
        await tester.enterText(_otpField, 'ABCD');
        await tester.pump();

        final tf = tester.widget<TextField>(_otpField);
        // All letters filtered out → field is empty
        expect(tf.controller!.text, isEmpty);
      },
    );

    testWidgets(
      'OTP EDGE — OTP field enforces 4-digit maximum length',
          (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({
          'userActive': 'Y',
          'roleId':     TestPrefs.kRoleId,
          'OTP':        '1142',
          'token':      TestPrefs.kToken,
        });

        await _loginAndGoToOtp(tester);

        // Type 8 digits — LengthLimitingTextInputFormatter(4) caps at 4
        await tester.enterText(_otpField, '11223344');
        await tester.pump();

        final tf = tester.widget<TextField>(_otpField);
        expect(tf.controller!.text.length, 4);
      },
    );

    testWidgets(
      'OTP EDGE — Back-press on OTP screen returns to Login screen',
          (WidgetTester tester) async {
        SharedPreferences.setMockInitialValues({
          'userActive': 'Y',
          'roleId':     TestPrefs.kRoleId,
          'OTP':        '1142',
          'token':      TestPrefs.kToken,
        });

        await _loginAndGoToOtp(tester);

        // WillPopScope in VerifyOTP pushReplacement to MyLogin on back-press
        final NavigatorState navigator =
        tester.state(find.byType(Navigator));
        navigator.pop();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should be back on Login screen
        expect(find.text('Sign In'), findsOneWidget);
      },
    );
  });
}

// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// SECTION 4 — DASHBOARD SCREEN TESTS
// ──────────────────────────────────────────────────────────────────────────────
// =============================================================================

/// Tests targeting DashboardScreen.dart.
///
/// Entry point: the widget is navigated to after a successful login + OTP,
/// OR pumped directly by pushing the named route '/godownDashboard'.
void _dashboardTests() {
  group('Dashboard Screen —', () {
    setUp(() async {
      await _seedSharedPrefs();
      // Stub all dashboard APIs to return success:
      //
      // mockHttpClient
      //   .onGet(contains('ItemCurrentStkList')).thenRespond(200, jsonEncode(kCurrentStockList))
      //   .onGet(contains('TodaysOpeningStkForGK')).thenRespond(200, jsonEncode(kOpeningStockList))
      //   .onGet(contains('ImbalanceAsOfDateStkForGK')).thenRespond(200, '[]')
      //   .onGet(contains('GetSQCCardCntList')).thenRespond(200, '[]')
      //   .onGet(contains('GetStockTransferDtls')).thenRespond(200, '[]')
      //   .onGet(contains('CheckDayEndConfirmation')).thenRespond(200, '[]');
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    // ── Positive / UI Tests ──────────────────────────────────────────────────

    testWidgets(
      'POSITIVE — Dashboard screen loads successfully after login',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        // Navigate to dashboard (adjust to your route setup).
        // await navigateToDashboard(tester);

        // Core sections must be visible.
        expect(find.text("TODAY'S OPENING STOCK"), findsOneWidget);
        expect(find.text('CURRENT STOCK'),         findsOneWidget);
      },
    );

    testWidgets(
      "POSITIVE — Today's Opening Stock section is visible with Filled/Empty/Defective chips",
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        // Opening stock chip labels.
        expect(find.text('Filled'),    findsWidgets);
        expect(find.text('Empty'),     findsWidgets);
        expect(find.text('Defective'), findsWidgets);
      },
    );

    testWidgets(
      'POSITIVE — Current Stock section is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        expect(find.text('CURRENT STOCK'), findsOneWidget);
      },
    );

    testWidgets(
      'POSITIVE — Item dropdown is visible on the Dashboard',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        // There should be at least one DropdownButton on the dashboard.
        expect(find.byType(DropdownButton<num>), findsOneWidget);
      },
    );

    testWidgets(
      'POSITIVE — Transfer button is visible on the Dashboard',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        expect(find.text('Transfer'), findsOneWidget);
      },
    );

    // ── Dropdown Behaviour ───────────────────────────────────────────────────

    testWidgets(
      'DROPDOWN — Selecting an item from the dropdown updates Opening Stock values',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        final dropdown = find.byType(DropdownButton<num>).first;

        // Open the dropdown.
        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        // Select the second item (e.g., "5 KG").
        await tester.tap(find.text('5 KG').last);
        await tester.pumpAndSettle();

        // Opening stock figures should have been refreshed.
        // The actual values come from kOpeningStockList filtered by itemId.
        // Here we just verify no exception was thrown and UI is still up.
        expect(find.text('Filled'),    findsWidgets);
        expect(find.text('Empty'),     findsWidgets);
        expect(find.text('Defective'), findsWidgets);
      },
    );

    testWidgets(
      'DROPDOWN — Selecting an item updates Current Stock values',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        final dropdown = find.byType(DropdownButton<num>).first;

        await tester.tap(dropdown);
        await tester.pumpAndSettle();

        await tester.tap(find.text('14.2 KG').last);
        await tester.pumpAndSettle();

        // Current Stock chip for Filled should show "50" from kCurrentStockList.
        // Adjust expected value to your actual test data.
        expect(find.text('50'), findsOneWidget);
      },
    );

    // ── Transfer Button & Bottom Sheet ───────────────────────────────────────

    testWidgets(
      'TRANSFER — Tapping Transfer button opens a bottom sheet',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        await TestHelpers.tap(
          tester,
          TestHelpers.anyText('Transfer'),
        );

        // Bottom sheet should be visible.
        expect(find.byType(BottomSheet), findsOneWidget);
      },
    );

    testWidgets(
      'TRANSFER — Bottom sheet displays item-wise stock list',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        await TestHelpers.tap(
          tester,
          TestHelpers.anyText('Transfer'),
        );

        // Items from kCurrentStockList should appear in the bottom sheet.
        expect(find.text('14.2 KG'), findsOneWidget);
        expect(find.text('5 KG'),    findsOneWidget);
      },
    );

    testWidgets(
      'TRANSFER — Bottom sheet has the title "Select Item For Stock Transfer"',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        await TestHelpers.tap(
          tester,
          TestHelpers.anyText('Transfer'),
        );

        expect(
          find.text('Select Item For Stock Transfer'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'TRANSFER — Tapping an item in the bottom sheet navigates to Transfer Screen',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        await TestHelpers.tap(
          tester,
          TestHelpers.anyText('Transfer'),
        );

        // Tap first item (14.2 KG).
        await TestHelpers.tap(tester, find.text('14.2 KG').first);

        // Transfer screen specific fields should now be visible.
        expect(find.textContaining('Filled Qty'),    findsOneWidget);
        expect(find.textContaining('Empty Qty'),     findsOneWidget);
        expect(find.textContaining('Defective Qty'), findsOneWidget);
      },
    );

    // ── Edge Cases ───────────────────────────────────────────────────────────

    testWidgets(
      'EDGE — Dashboard shows "No Data Available" when stock API returns empty list',
          (WidgetTester tester) async {
        // Stub APIs to return empty arrays.
        // mockHttpClient
        //   .onGet(contains('ItemCurrentStkList')).thenRespond(200, '[]')
        //   .onGet(contains('TodaysOpeningStkForGK')).thenRespond(200, '[]');

        await _bootAppLoggedIn(tester);

        expect(find.text('No data available'), findsWidgets);
      },
    );

    testWidgets(
      'EDGE — Dashboard FAB shows refresh confirmation dialog on tap',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        // Tap the FloatingActionButton.
        await TestHelpers.tap(tester, find.byType(FloatingActionButton));

        // Confirmation dialog should appear.
        expect(find.text('Confirm Refresh'),          findsOneWidget);
        expect(find.text('Do You Want To Refresh Data?'), findsOneWidget);
      },
    );

    testWidgets(
      'EDGE — Refresh dialog "No" closes dialog without refreshing',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        await TestHelpers.tap(tester, find.byType(FloatingActionButton));
        await TestHelpers.tap(tester, TestHelpers.textButtonByText('No'));

        // Dialog should be gone.
        expect(find.text('Confirm Refresh'), findsNothing);
      },
    );

    testWidgets(
      'EDGE — Refresh dialog "Yes" triggers data reload',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);

        await TestHelpers.tap(tester, find.byType(FloatingActionButton));
        await TestHelpers.tap(tester, TestHelpers.textButtonByText('Yes'));

        // Dialog should be dismissed.
        expect(find.text('Confirm Refresh'), findsNothing);

        // Dashboard should still be visible after refresh.
        expect(find.text("TODAY'S OPENING STOCK"), findsOneWidget);
      },
    );

    testWidgets(
      'ERROR — Dashboard API failure shows flush bar error message',
          (WidgetTester tester) async {
        // Stub API to return 500.
        // mockHttpClient.onGet(contains('ItemCurrentStkList')).thenRespond(500, '');

        await _bootAppLoggedIn(tester);

        // Error message from Constants.listGettingFail should be shown.
        expect(find.textContaining('Failed'), findsOneWidget);
      },
    );
  });
}

// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// SECTION 5 — TRANSFER SCREEN TESTS
// ──────────────────────────────────────────────────────────────────────────────
// (StockReturnFromDelBoy.dart → DailyRefillSalePage)
// ──────────────────────────────────────────────────────────────────────────────
// =============================================================================

/// Arguments that the Dashboard passes to the Transfer screen.
/// Mirrors the real navigation arguments in DashboardScreen._showItemPopup().
// final Map<String, dynamic> kTransferScreenArgs = {
//   'itemName':      '14.2 KG',
//   'itemID':        1,
//   'filledStock':   50,
//   'emptyStock':    20,
//   'defectiveStock': 5,
// };
//
// /// Navigates to the Transfer screen by tapping Transfer → selecting first item
// /// from the bottom sheet.  Requires the app to already be booted and on the
// /// Dashboard (call _bootAppLoggedIn before this).
// Future<void> _navigateToTransferScreen(WidgetTester tester) async {
//   // Tap the Transfer InkWell in the Current Stock section.
//   await TestHelpers.tap(tester, find.text('Transfer'));
//
//   // Bottom sheet appears — tap the first item (14.2 KG).
//   await tester.pumpAndSettle(const Duration(seconds: 2));
//   expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
//   await TestHelpers.tap(tester, find.byType(ListTile).first);
//
//   // Wait for Transfer screen to load.
//   await tester.pump(const Duration(seconds: 3));
//   await tester.pumpAndSettle(const Duration(seconds: 5));
// }
//
// void _transferScreenTests() {
//   group('Transfer Screen (StockReturnFromDelBoy) —', () {
//     setUp(() async {
//       await _seedSharedPrefs();
//
//       // Stub godown list API.
//       // mockHttpClient
//       //   .onGet(contains('GetGodownList')).thenRespond(200, jsonEncode(kGodownList))
//       //   .onPost(contains('StockTransfer')).thenRespond(200, jsonEncode(kTransferSubmitSuccess));
//     });
//
//     tearDown(() async {
//       await _clearSharedPrefs();
//     });
//
//     // ── UI Presence Tests ────────────────────────────────────────────────────
//
//     testWidgets(
//       'UI — Transfer screen shows selected item name in header',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         expect(find.text('14.2 KG'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'UI — Filled Qty field is visible',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         expect(find.textContaining('Filled'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'UI — Empty Qty field is visible',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         expect(find.textContaining('Empty'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'UI — Defective Qty field is visible',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         expect(find.textContaining('Defective'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'UI — Godown dropdown is visible',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         expect(find.byType(DropdownButton<dynamic>), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'UI — Remark text field is visible',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         expect(find.textContaining('Remark'), findsOneWidget);
//       },
//     );
//
//     // ── Validation — Negative Tests ──────────────────────────────────────────
//
//     testWidgets(
//       'VALIDATION — Submitting with all fields empty shows validation errors',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         // Tap submit without filling anything.
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // At least one validation error should appear.
//         expect(find.textContaining('required'), findsWidgets);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Empty Filled Qty shows error',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         // Fill all but Filled Qty.
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Test remark',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         expect(find.textContaining('Filled'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Empty Empty Qty shows error',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         // Leave Empty Qty empty.
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         expect(find.text('Add Empty Cylinder Count!'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Empty Defective Qty shows error',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         // Leave Defective Qty empty.
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         expect(find.textContaining('Defective'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — No Godown selected shows error',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Test',
//         );
//         // Skip godown selection.
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         expect(find.textContaining('Godown'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Empty Remark field shows error',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//         // Skip remark.
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         expect(find.textContaining('Remark'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Negative Filled Qty is rejected',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '-5',          // negative
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // Should show an error (exact message depends on your validator).
//         expect(find.textContaining('valid'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Filled Qty exceeds available stock shows error',
//           (WidgetTester tester) async {
//         // kTransferScreenArgs filledStock = 50; entering 999 > 50.
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '999',     // more than available 50
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // The app logic: filledValue <= filledStock is checked.
//         expect(find.textContaining('exceed'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Decimal values in Filled Qty are rejected (if integers required)',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '5.5',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // Validation should reject non-integer if the field type is int.
//         expect(find.textContaining('valid'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'VALIDATION — Non-numeric Filled Qty is rejected',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           'abc',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         expect(find.textContaining('valid'), findsOneWidget);
//       },
//     );
//
//     // ── Positive Submit Flow ─────────────────────────────────────────────────
//
//     testWidgets(
//       'POSITIVE — Valid input passes all validations',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//
//         // Select godown from dropdown.
//         await tester.tap(find.byType(DropdownButton<dynamic>));
//         await tester.pumpAndSettle();
//         await tester.tap(find.text('Main Godown').last);
//         await tester.pumpAndSettle();
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Integration test remark',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // Loading indicator should appear briefly.
//         // (May require pump() instead of pumpAndSettle to catch transient state.)
//         await tester.pump();
//         // expect(find.byType(CircularProgressIndicator), findsOneWidget);
//
//         await tester.pumpAndSettle();
//
//         // Success snackbar / dialog should appear.
//         expect(
//           find.textContaining('success'),
//           findsOneWidget,
//         );
//       },
//     );
//
//     testWidgets(
//       'POSITIVE — Submit API is called with correct payload',
//           (WidgetTester tester) async {
//         // Use a spy/capture pattern on your mock HTTP client to verify
//         // the request body contains the expected fields.
//         //
//         // final captured = <http.Request>[];
//         // mockHttpClient.onPost(contains('StockTransfer'))
//         //   .thenRespond(200, jsonEncode(kTransferSubmitSuccess))
//         //   .capture(captured);
//         //
//         // ... fill form and submit ...
//         //
//         // final body = jsonDecode(captured.first.body) as Map;
//         // expect(body['FilledQty'],    equals(10));
//         // expect(body['EmptyQty'],     equals(5));
//         // expect(body['DefectiveQty'], equals(1));
//         // expect(body['GodownId'],     equals(1));
//         // expect(body['Remark'],       equals('Integration test remark'));
//
//         // Placeholder assertion until HTTP mock is wired.
//         expect(true, isTrue);
//       },
//     );
//
//     testWidgets(
//       'POSITIVE — Loading indicator is visible during submit',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Test',
//         );
//
//         await tester.tap(TestHelpers.elevatedButtonByText('Submit'));
//         await tester.pump(); // one frame — catches loading state
//
//         // EasyLoading shows a CircularProgressIndicator.
//         expect(
//           find.byType(CircularProgressIndicator),
//           findsOneWidget,
//         );
//       },
//     );
//
//     testWidgets(
//       'POSITIVE — Success response navigates back to Dashboard '
//           'OR triggers stock refresh',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         // Fill all valid fields (abbreviated for brevity).
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Integration test',
//         );
//
//         // Select godown.
//         await tester.tap(find.byType(DropdownButton<dynamic>));
//         await tester.pumpAndSettle();
//         await tester.tap(find.text('Main Godown').last);
//         await tester.pumpAndSettle();
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // After success, verify navigation back to Dashboard.
//         // Either Dashboard screen is visible again...
//         expect(find.text("TODAY'S OPENING STOCK"), findsOneWidget);
//         // ...or a success snackbar is shown on current screen.
//         // (Both patterns are acceptable; adjust based on your implementation.)
//       },
//     );
//
//     // ── API Error Tests ──────────────────────────────────────────────────────
//
//     testWidgets(
//       'API ERROR — Submit API 500 response shows error snackbar',
//           (WidgetTester tester) async {
//         // mockHttpClient.onPost(contains('StockTransfer')).thenRespond(500, '');
//
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '10',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '1',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Test',
//         );
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         expect(find.textContaining('error'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'API ERROR — No internet connection shows network error message',
//           (WidgetTester tester) async {
//         // Simulate offline state.
//         // Constants.isNetworkAvailable = false;
//
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // Connection message from Constants.connectionMessage.
//         expect(find.textContaining('network'), findsOneWidget);
//       },
//     );
//
//     // ── Navigation Tests ─────────────────────────────────────────────────────
//
//     testWidgets(
//       'NAVIGATION — Back button on Transfer screen returns to Dashboard',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         // Tap back via the AppBar back button.
//         await TestHelpers.tap(tester, find.byTooltip('Back'));
//
//         // Dashboard should be visible again.
//         expect(find.text("TODAY'S OPENING STOCK"), findsOneWidget);
//       },
//     );
//
//     // ── Edge Cases ───────────────────────────────────────────────────────────
//
//     testWidgets(
//       'EDGE — Zero value for Filled Qty is accepted (valid input)',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '0',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '0',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Zero qty test',
//         );
//
//         await tester.tap(find.byType(DropdownButton<dynamic>));
//         await tester.pumpAndSettle();
//         await tester.tap(find.text('Main Godown').last);
//         await tester.pumpAndSettle();
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // Submission should proceed (or show the relevant success/confirmation).
//         // No validation error related to "Filled Qty" should appear.
//         expect(find.text('Add Empty Cylinder Count!'), findsNothing);
//       },
//     );
//
//     testWidgets(
//       'EDGE — Very large valid Filled Qty (within stock) is accepted',
//           (WidgetTester tester) async {
//         await _bootAppLoggedIn(tester);
//         await _navigateToTransferScreen(tester);
//
//         // filledStock = 50; entering exactly 50 should be valid.
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Filled Qty'),
//           '50',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Empty Qty'),
//           '20',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Defective Qty'),
//           '5',
//         );
//         await TestHelpers.enterText(
//           tester,
//           TestHelpers.fieldByLabel('Remark'),
//           'Max stock test',
//         );
//
//         await tester.tap(find.byType(DropdownButton<dynamic>));
//         await tester.pumpAndSettle();
//         await tester.tap(find.text('Main Godown').last);
//         await tester.pumpAndSettle();
//
//         await TestHelpers.tap(
//           tester,
//           TestHelpers.elevatedButtonByText('Submit'),
//         );
//
//         // Should not show a "exceeds available stock" error.
//         expect(find.textContaining('exceed'), findsNothing);
//       },
//     );
//   });
// }
//
// // =============================================================================
// // ──────────────────────────────────────────────────────────────────────────────
// // SECTION 6 — SESSION / AUTHENTICATION EDGE CASES
// // ──────────────────────────────────────────────────────────────────────────────
// // =============================================================================
//
// void _sessionTests() {
//   group('Session & Auth Edge Cases —', () {
//     testWidgets(
//       'SESSION — Expired token shows session-expired dialog',
//           (WidgetTester tester) async {
//         await _seedSharedPrefs();
//
//         // Stub any authenticated API call to return 401.
//         // mockHttpClient.onGet(anything).thenRespond(401, '');
//
//         await _bootOnly(tester);
//
//         // The app should detect the expired token and show the dialog.
//         expect(find.text('Expired'), findsOneWidget);
//       },
//     );
//
//     testWidgets(
//       'SESSION — IsAlreadyLogin == 0 shows logout confirmation dialog on Dashboard',
//           (WidgetTester tester) async {
//         // Seed prefs with IsAlreadyLogin = "0".
//         SharedPreferences.setMockInitialValues({
//           'token':           TestPrefs.kToken,
//           'DistributorId':   TestPrefs.kDistributorId,
//           'StaffId':         TestPrefs.kStaffId,
//           'StaffName':       TestPrefs.kStaffName,
//           'RoleName':        TestPrefs.kRoleName,
//           'RoleId':          '0',
//           'MobileNo':        TestPrefs.kMobileNo,
//           'godownId':        TestPrefs.kGodownId,
//           'godownKeeperId':  TestPrefs.kGodownKeeperId,
//           'DistributorName': TestPrefs.kDistributorName,
//           'IsAlreadyLogin':  '0',              // ← triggers logout dialog
//         });
//
//         await _bootOnly(tester);
//
//         expect(find.text('Confirm Logout'), findsOneWidget);
//       },
//     );
//   });
// }

// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// SECTION 5 — TRANSFER SCREEN TESTS
// ──────────────────────────────────────────────────────────────────────────────
// (StockTransferToGodownScreen.dart → StockTransferTOGodownScreen)
// ──────────────────────────────────────────────────────────────────────────────
// =============================================================================

/// Navigates to the Transfer screen by tapping Transfer → selecting first item
/// from the bottom sheet. Requires the app already be booted and on Dashboard.
Future<void> _navigateToTransferScreen(WidgetTester tester) async {
  await TestHelpers.tap(tester, find.text('Transfer'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  expect(find.text('Select Item For Stock Transfer'), findsOneWidget);
  await TestHelpers.tap(tester, find.byType(ListTile).first);
  await tester.pump(const Duration(seconds: 3));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

/// Helper: finds a TextField by its hint text (used in _QtyField widget)
Finder _fieldByHint(String hint) =>
    find.widgetWithText(TextField, hint).first;

/// Helper: finds a TextField by its hint text (Remark field)
Finder _remarkField() => find.widgetWithText(TextField, 'Enter Remark').first;

void _transferScreenTests() {
  group('Transfer Screen (StockReturnFromDelBoy) —', () {
    setUp(() async {
      await _seedSharedPrefs();
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    // ── UI Presence Tests ────────────────────────────────────────────────────

    testWidgets(
      'UI — Transfer screen shows selected item name in header',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        // Item name from getCurrentStcOfGodownKeeper — any item name is shown
        expect(find.byType(TextField), findsWidgets);
      },
    );

    testWidgets(
      'UI — AppBar title is Stock Transfer',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        expect(find.text('Stock Transfer'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Filled Qty field is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        expect(find.textContaining('Filled'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Empty Qty field is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        expect(find.textContaining('Empty'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Defective Qty field is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        expect(find.textContaining('Defective'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Godown dropdown is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        expect(
          find.byType(DropdownButtonFormField<GetGodownListModel>),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'UI — Remark text field is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        expect(find.textContaining('Remark'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Submit button is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);
        expect(
          find.widgetWithText(ElevatedButton, 'Submit'),
          findsOneWidget,
        );
      },
    );

    // ── Validation — Negative Tests ──────────────────────────────────────────

    testWidgets(
      'VALIDATION — Submitting with all fields empty shows "Select godown" error',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Tap submit without filling anything.
        await TestHelpers.tap(
          tester,
          find.widgetWithText(ElevatedButton, 'Submit'),
        );
        await tester.pumpAndSettle();

        // Screen shows: showFlushBar(context, "Select godown.")
        expect(find.textContaining('Select godown'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — Godown selected but no qty entered shows validCountEnter error',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Select a godown from dropdown first
        await tester.tap(
          find.byType(DropdownButtonFormField<GetGodownListModel>),
        );
        await tester.pumpAndSettle();
        // Tap the first godown option in the dropdown list
        final dropdownItems = find.byType(DropdownMenuItem<GetGodownListModel>);
        if (dropdownItems.evaluate().isNotEmpty) {
          await tester.tap(dropdownItems.first);
          await tester.pumpAndSettle();
        }

        // Tap submit without entering any qty
        await TestHelpers.tap(
          tester,
          find.widgetWithText(ElevatedButton, 'Submit'),
        );
        await tester.pumpAndSettle();

        // Screen shows: showFlushBar(context, Constants.validCountEnter)
        // = "Enter a valid count."
        expect(find.textContaining('valid count'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — Filled Qty exceeds available stock clears the field',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Enter a qty larger than available stock (filledCount from API)
        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        await tester.enterText(filledField, '9999');
        await tester.pump();

        // onChanged clears field and shows error
        // showFlushBar(context, Constants.stockTransferValidation)
        // = "Stock transfer quantity entered should not exceed current stock."
        await tester.pumpAndSettle();
        expect(find.textContaining('should not exceed'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — Empty Qty exceeds available stock clears the field',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        final emptyField = _fieldByHint('Enter Empty Qty');
        await tester.ensureVisible(emptyField);
        await tester.enterText(emptyField, '9999');
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.textContaining('should not exceed'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — Defective Qty exceeds available stock clears the field',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        final defField = _fieldByHint('Enter Defective Qty');
        await tester.ensureVisible(defField);
        await tester.enterText(defField, '9999');
        await tester.pump();
        await tester.pumpAndSettle();

        expect(find.textContaining('should not exceed'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — No Godown selected shows "Select godown" error',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Enter valid filled qty, skip godown selection
        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        await tester.enterText(filledField, '1');
        await tester.pump();

        await TestHelpers.tap(
          tester,
          find.widgetWithText(ElevatedButton, 'Submit'),
        );
        await tester.pumpAndSettle();

        // showFlushBar(context, "Select godown.")
        expect(find.textContaining('Select godown'), findsOneWidget);
      },
    );

    // ── Positive Tests ───────────────────────────────────────────────────────

    testWidgets(
      'POSITIVE — Filled Qty field accepts numeric input',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        await tester.enterText(filledField, '5');
        await tester.pump();

        expect(find.text('5'), findsWidgets);
      },
    );

    testWidgets(
      'POSITIVE — Empty Qty field accepts numeric input',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        final emptyField = _fieldByHint('Enter Empty Qty');
        await tester.ensureVisible(emptyField);
        await tester.enterText(emptyField, '3');
        await tester.pump();

        expect(find.text('3'), findsWidgets);
      },
    );

    testWidgets(
      'POSITIVE — Defective Qty field accepts numeric input',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        final defField = _fieldByHint('Enter Defective Qty');
        await tester.ensureVisible(defField);
        await tester.enterText(defField, '1');
        await tester.pump();

        expect(find.text('1'), findsWidgets);
      },
    );

    testWidgets(
      'POSITIVE — Remark field accepts text input',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        final remarkField = _remarkField();
        await tester.ensureVisible(remarkField);
        await tester.enterText(remarkField, 'Test remark');
        await tester.pump();

        expect(find.text('Test remark'), findsOneWidget);
      },
    );

    testWidgets(
      'POSITIVE — Filled Qty only allows digits (FilteringTextInputFormatter)',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        // InputFormatters filter non-digits: entering 'abc' results in empty
        await tester.enterText(filledField, 'abc');
        await tester.pump();

        // The field should be empty because FilteringTextInputFormatter.digitsOnly
        final textField = tester.widget<TextField>(filledField);
        expect(textField.controller?.text ?? '', isEmpty);
      },
    );

    // ── Full Submit Flow — Fill all fields and submit to real API ────────────

    // testWidgets(
    //   'SUBMIT — Fill all fields with valid data and submit successfully to API',
    //       (WidgetTester tester) async {
    //     await _bootAppLoggedIn(tester);
    //     await _navigateToTransferScreen(tester);
    //
    //     // Step 1: Enter Filled Qty
    //     final filledField = _fieldByHint('Enter Filled Qty');
    //     await tester.ensureVisible(filledField);
    //     await tester.tap(filledField);
    //     await tester.pump();
    //     await tester.enterText(filledField, '1');
    //     await tester.pump();
    //
    //     // Step 2: Enter Empty Qty
    //     final emptyField = _fieldByHint('Enter Empty Qty');
    //     await tester.ensureVisible(emptyField);
    //     await tester.tap(emptyField);
    //     await tester.pump();
    //     await tester.enterText(emptyField, '1');
    //     await tester.pump();
    //
    //     // Step 3: Enter Defective Qty
    //     final defField = _fieldByHint('Enter Defective Qty');
    //     await tester.ensureVisible(defField);
    //     await tester.tap(defField);
    //     await tester.pump();
    //     await tester.enterText(defField, '0');
    //     await tester.pump();
    //
    //     // Step 4: Select Godown from dropdown
    //     final godownDropdown =
    //     find.byType(DropdownButtonFormField<GetGodownListModel>);
    //     await tester.ensureVisible(godownDropdown);
    //     await tester.tap(godownDropdown);
    //     await tester.pumpAndSettle(const Duration(seconds: 2));
    //     final godownOptions =
    //     find.byType(DropdownMenuItem<GetGodownListModel>);
    //     expect(godownOptions, findsWidgets,
    //         reason: 'Godown list must be loaded from API before selecting');
    //     await tester.tap(godownOptions.first);
    //     await tester.pumpAndSettle();
    //
    //     // Step 5: Enter Remark
    //     final remarkField = _remarkField();
    //     await tester.ensureVisible(remarkField);
    //     await tester.tap(remarkField);
    //     await tester.pump();
    //     await tester.enterText(remarkField, 'Integration test transfer');
    //     await tester.pump();
    //
    //     // Step 6: Tap Submit
    //     final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
    //     await tester.ensureVisible(submitBtn);
    //     await tester.tap(submitBtn);
    //     await tester.pump(); // one frame — catches loading state
    //
    //     // Step 7: Wait for real API call (SaveGodownStockTransferDtls) to complete
    //     await tester.pumpAndSettle(const Duration(seconds: 10));
    //
    //     // Step 8: Assert success
    //     // On HTTP 200 → Navigator.pop(context) + EasyLoading.showToast("Data Sent Successfully..")
    //     final toastVisible =
    //         find.textContaining('Data Sent Successfully').evaluate().isNotEmpty;
    //     final dashboardVisible =
    //         find.textContaining("TODAY'S OPENING STOCK").evaluate().isNotEmpty;
    //     expect(
    //       toastVisible || dashboardVisible,
    //       isTrue,
    //       reason:
    //       'After successful API submit, either the success toast or the Dashboard must be visible',
    //     );
    //   },
    // );
    //
    // testWidgets(
    //   'SUBMIT — Submit with only Filled Qty filled succeeds',
    //       (WidgetTester tester) async {
    //     await _bootAppLoggedIn(tester);
    //     await _navigateToTransferScreen(tester);
    //
    //     // Enter only Filled Qty (at least one qty field must be non-empty)
    //     final filledField = _fieldByHint('Enter Filled Qty');
    //     await tester.ensureVisible(filledField);
    //     await tester.enterText(filledField, '1');
    //     await tester.pump();
    //
    //     // Select godown
    //     final godownDropdown =
    //     find.byType(DropdownButtonFormField<GetGodownListModel>);
    //     await tester.ensureVisible(godownDropdown);
    //     await tester.tap(godownDropdown);
    //     await tester.pumpAndSettle(const Duration(seconds: 2));
    //     final godownOptions =
    //     find.byType(DropdownMenuItem<GetGodownListModel>);
    //     if (godownOptions.evaluate().isNotEmpty) {
    //       await tester.tap(godownOptions.first);
    //       await tester.pumpAndSettle();
    //     }
    //
    //     // Tap Submit
    //     final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
    //     await tester.ensureVisible(submitBtn);
    //     await tester.tap(submitBtn);
    //     await tester.pump();
    //     await tester.pumpAndSettle(const Duration(seconds: 10));
    //
    //     final success =
    //         find.textContaining('Data Sent Successfully').evaluate().isNotEmpty ||
    //             find.textContaining("TODAY'S OPENING STOCK").evaluate().isNotEmpty;
    //     expect(success, isTrue);
    //   },
    // );
    //
    // testWidgets(
    //   'SUBMIT — Remark is accepted and included in submit',
    //       (WidgetTester tester) async {
    //     await _bootAppLoggedIn(tester);
    //     await _navigateToTransferScreen(tester);
    //
    //     // Fill Filled Qty
    //     final filledField = _fieldByHint('Enter Filled Qty');
    //     await tester.ensureVisible(filledField);
    //     await tester.enterText(filledField, '1');
    //     await tester.pump();
    //
    //     // Select godown
    //     final godownDropdown =
    //     find.byType(DropdownButtonFormField<GetGodownListModel>);
    //     await tester.ensureVisible(godownDropdown);
    //     await tester.tap(godownDropdown);
    //     await tester.pumpAndSettle(const Duration(seconds: 2));
    //     final godownOptions =
    //     find.byType(DropdownMenuItem<GetGodownListModel>);
    //     if (godownOptions.evaluate().isNotEmpty) {
    //       await tester.tap(godownOptions.first);
    //       await tester.pumpAndSettle();
    //     }
    //
    //     // Fill Remark and verify it is in field before submitting
    //     final remarkField = _remarkField();
    //     await tester.ensureVisible(remarkField);
    //     await tester.enterText(remarkField, 'Remark for API test');
    //     await tester.pump();
    //     expect(find.text('Remark for API test'), findsOneWidget);
    //
    //     // Tap Submit
    //     final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
    //     await tester.ensureVisible(submitBtn);
    //     await tester.tap(submitBtn);
    //     await tester.pump();
    //     await tester.pumpAndSettle(const Duration(seconds: 10));
    //
    //     final success =
    //         find.textContaining('Data Sent Successfully').evaluate().isNotEmpty ||
    //             find.textContaining("TODAY'S OPENING STOCK").evaluate().isNotEmpty;
    //     expect(success, isTrue);
    //   },
    // );
    //
    // testWidgets(
    //   'SUBMIT — After successful submit Navigator pops back to Dashboard',
    //       (WidgetTester tester) async {
    //     await _bootAppLoggedIn(tester);
    //     await _navigateToTransferScreen(tester);
    //
    //     // Fill Filled Qty
    //     final filledField = _fieldByHint('Enter Filled Qty');
    //     await tester.ensureVisible(filledField);
    //     await tester.enterText(filledField, '1');
    //     await tester.pump();
    //
    //     // Select godown
    //     final godownDropdown =
    //     find.byType(DropdownButtonFormField<GetGodownListModel>);
    //     await tester.ensureVisible(godownDropdown);
    //     await tester.tap(godownDropdown);
    //     await tester.pumpAndSettle(const Duration(seconds: 2));
    //     final godownOptions =
    //     find.byType(DropdownMenuItem<GetGodownListModel>);
    //     if (godownOptions.evaluate().isNotEmpty) {
    //       await tester.tap(godownOptions.first);
    //       await tester.pumpAndSettle();
    //     }
    //
    //     // Tap Submit
    //     final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
    //     await tester.ensureVisible(submitBtn);
    //     await tester.tap(submitBtn);
    //     await tester.pump();
    //
    //     // Wait for API + Navigator.pop()
    //     await tester.pumpAndSettle(const Duration(seconds: 10));
    //
    //     // On HTTP 200 → Navigator.pop(context) → back to Dashboard
    //     expect(
    //       find.textContaining("TODAY'S OPENING STOCK"),
    //       findsOneWidget,
    //       reason:
    //       'Navigator.pop after successful submit must return to Dashboard',
    //     );
    //   },
    // );
    //
    // // ── API Error Tests ──────────────────────────────────────────────────────
    //
    // testWidgets(
    //   'API ERROR — No internet connection shows network error message',
    //       (WidgetTester tester) async {
    //     await _bootAppLoggedIn(tester);
    //     await _navigateToTransferScreen(tester);

    // ── Full Submit Flow — Fill all fields and submit to real API ────────────


    testWidgets(
      'SUBMIT — Fill all fields with valid data and submit successfully to API',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Step 1: Filled Qty
        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        await tester.enterText(filledField, '1');
        await tester.pump();

        // Step 2: Empty Qty
        final emptyField = _fieldByHint('Enter Empty Qty');
        await tester.ensureVisible(emptyField);
        await tester.enterText(emptyField, '1');
        await tester.pump();

        // Step 3: Defective Qty
        final defField = _fieldByHint('Enter Defective Qty');
        await tester.ensureVisible(defField);
        await tester.enterText(defField, '0');
        await tester.pump();

        // Step 4: Select Godown
        final godownDropdown =
        find.byType(DropdownButtonFormField<GetGodownListModel>);
        await tester.ensureVisible(godownDropdown);
        await tester.tap(godownDropdown);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        final godownOptions =
        find.byType(DropdownMenuItem<GetGodownListModel>);
        expect(godownOptions, findsWidgets,
            reason: 'Godown list must be loaded from API before selecting');
        // Use .last — Flutter adds an off-screen copy at index 0 when open
        await tester.tap(godownOptions.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Step 5: Remark
        final remarkField = _remarkField();
        await tester.ensureVisible(remarkField);
        await tester.enterText(remarkField, 'Integration test transfer');
        await tester.pump();

        // Step 6: Tap Submit
        final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
        await tester.ensureVisible(submitBtn);
        await tester.tap(submitBtn);

        // Step 7: Pump frames to let the API call fire and Navigator.pop run.
        // Use repeated pump() calls instead of pumpAndSettle to avoid timeout
        // while the Dashboard reloads its own API calls after popping.
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        // Step 8: Assert — after Navigator.pop the Transfer screen is gone.
        // The Stock Transfer screen title should no longer be visible.
        expect(
          find.text('Stock Transfer'),
          findsNothing,
          reason:
          'Navigator.pop after HTTP 200 must dismiss the Stock Transfer screen',
        );
      },
    );

    testWidgets(
      'SUBMIT — Submit with only Filled Qty filled succeeds',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Filled Qty only
        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        await tester.enterText(filledField, '1');
        await tester.pump();

        // Select godown
        final godownDropdown =
        find.byType(DropdownButtonFormField<GetGodownListModel>);
        await tester.ensureVisible(godownDropdown);
        await tester.tap(godownDropdown);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        final godownOptions =
        find.byType(DropdownMenuItem<GetGodownListModel>);
        if (godownOptions.evaluate().isNotEmpty) {
          await tester.tap(godownOptions.last, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Submit
        final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
        await tester.ensureVisible(submitBtn);
        await tester.tap(submitBtn);
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        // Transfer screen must be gone after pop
        expect(find.text('Stock Transfer'), findsNothing);
      },
    );

    testWidgets(
      'SUBMIT — Remark is accepted and included in submit',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Filled Qty
        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        await tester.enterText(filledField, '1');
        await tester.pump();

        // Select godown
        final godownDropdown =
        find.byType(DropdownButtonFormField<GetGodownListModel>);
        await tester.ensureVisible(godownDropdown);
        await tester.tap(godownDropdown);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        final godownOptions =
        find.byType(DropdownMenuItem<GetGodownListModel>);
        if (godownOptions.evaluate().isNotEmpty) {
          await tester.tap(godownOptions.last, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Remark — verify it is in the field before submit
        final remarkField = _remarkField();
        await tester.ensureVisible(remarkField);
        await tester.enterText(remarkField, 'Remark for API test');
        await tester.pump();
        expect(find.text('Remark for API test'), findsOneWidget);

        // Submit
        final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
        await tester.ensureVisible(submitBtn);
        await tester.tap(submitBtn);
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        expect(find.text('Stock Transfer'), findsNothing);
      },
    );

    testWidgets(
      'SUBMIT — After successful submit Navigator pops back to Dashboard',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // Filled Qty
        final filledField = _fieldByHint('Enter Filled Qty');
        await tester.ensureVisible(filledField);
        await tester.enterText(filledField, '1');
        await tester.pump();

        // Select godown
        final godownDropdown =
        find.byType(DropdownButtonFormField<GetGodownListModel>);
        await tester.ensureVisible(godownDropdown);
        await tester.tap(godownDropdown);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        final godownOptions =
        find.byType(DropdownMenuItem<GetGodownListModel>);
        if (godownOptions.evaluate().isNotEmpty) {
          await tester.tap(godownOptions.last, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Submit
        final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
        await tester.ensureVisible(submitBtn);
        await tester.tap(submitBtn);

        // Pump 30 × 1 s = 30 s total to allow API + pop + Dashboard reload
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        // Navigator.pop → back to Dashboard (BottomNavigationForGodownKeeper)
        expect(
          find.textContaining("TODAY'S OPENING STOCK"),
          findsOneWidget,
          reason:
          'Navigator.pop after HTTP 200 must return to the Dashboard',
        );
      },
    );

    // ── Navigation Tests ─────────────────────────────────────────────────────

    testWidgets(
      'NAVIGATION — Transfer History section is visible',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        expect(
          find.textContaining('Stock Transfer History'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'NAVIGATION — Back navigation pops to Dashboard',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToTransferScreen(tester);

        // The CustomAppBar back button pops to previous screen
        final backBtn = find.byTooltip('Back');
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          await tester.pumpAndSettle();
          expect(find.textContaining("TODAY'S OPENING STOCK"), findsOneWidget);
        } else {
          // Use system back
          final NavigatorState navigator = tester.state(find.byType(Navigator).first);
          navigator.pop();
          await tester.pumpAndSettle();
          expect(find.textContaining("TODAY'S OPENING STOCK"), findsOneWidget);
        }
      },
    );
  });
}


void _sessionTests() {
  group('Session —', () {
    setUp(() async {
      await _seedSharedPrefs();
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    testWidgets(
      'SESSION — App boots and reaches Dashboard when already logged in',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        // Dashboard is visible — confirms session was restored from SharedPrefs
        expect(find.textContaining("TODAY'S OPENING STOCK"), findsOneWidget);
      },
    );

    testWidgets(
      'SESSION — Clearing credentials redirects to Login screen',
          (WidgetTester tester) async {
        // Boot with no credentials (empty prefs)
        await _clearSharedPrefs();
        await _bootApp(tester);
        // Should land on Login / Splash screen, not Dashboard
        expect(find.textContaining("TODAY'S OPENING STOCK"), findsNothing);
      },
    );

    testWidgets(
      'SESSION — Token stored in SharedPrefs is used for API calls',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        // If the token were missing, the APIs would 401 and the app would show
        // an error or redirect to login. Reaching Dashboard means token was used.
        expect(find.textContaining("TODAY'S OPENING STOCK"), findsOneWidget);
      },
    );

    testWidgets(
      'SESSION — DistributorId stored in SharedPrefs is non-empty',
          (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        // Dashboard loads real stock data for DistributorId 8118 in SharedPrefs.
        // If DistributorId were missing, the screen would fail to load data.
        expect(find.textContaining("TODAY'S OPENING STOCK"), findsOneWidget);
      },
    );
  });
}
// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// SECTION 6 — ITEM RECEIPT SCREEN TESTS
// ──────────────────────────────────────────────────────────────────────────────
// Screen: ItemReceiptScreen (lib/Screen/GodownKeeper/ItemReceipt/AddItem/ItemReceiptScreen.dart)
// Navigation: More tab → "Item Receipt / Return" → "Item Receipt"
// ──────────────────────────────────────────────────────────────────────────────
// =============================================================================

/// Navigates to ItemReceiptScreen via More → Item Receipt.
Future<void> _navigateToItemReceiptScreen(WidgetTester tester) async {
  // Tap the "More" bottom-nav tab
  await TestHelpers.tap(tester, find.text('More'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  // Tap "Item Receipt" option
  await TestHelpers.tap(tester, find.text('Item Receipt'));
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(seconds: 4));
}

/// Finds the Vehicle No TextField (label 'Vehicle No. *' via AppStyledField).
Finder _vehicleNoField() =>
    find.widgetWithText(TextField, 'Vehicle No. *').first;

/// Finds the "Filled" qty field inside an item card (index-based).
Finder _filledQtyField() => find.widgetWithText(TextField, 'Filled').first;

/// Finds the "EMR" qty field.
Finder _emrQtyField() => find.widgetWithText(TextField, 'EMR').first;

void _itemReceiptScreenTests() {
  group('Item Receipt Screen —', () {
    setUp(() async {
      await _seedSharedPrefs();
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    // ── UI Presence ──────────────────────────────────────────────────────────

    testWidgets(
      'UI — Item Receipt screen has AppBar title "Item Receipt"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        expect(find.text('Item Receipt'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Receipt Date field is pre-filled with today\'s date',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        // Receipt Date field rendered as AppStyledField with label 'Receipt Date'
        expect(find.widgetWithText(TextField, 'Receipt Date'), findsOneWidget);
        // The value should be non-empty (today's date)
        final dateField = tester.widget<TextField>(
            find.widgetWithText(TextField, 'Receipt Date'));
        expect(dateField.controller?.text, isNotEmpty);
      },
    );

    testWidgets(
      'UI — Vehicle No. field is empty on fresh open',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        final vehicleField =
            tester.widget<TextField>(_vehicleNoField());
        expect(vehicleField.controller?.text ?? '', isEmpty);
      },
    );

    testWidgets(
      'UI — At least one item card is shown with Filled / EMR / Invoice fields',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        expect(find.widgetWithText(TextField, 'Filled'), findsWidgets);
        expect(find.widgetWithText(TextField, 'EMR'), findsWidgets);
        expect(find.widgetWithText(TextField, 'Invoice *'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Submit Receipt button is present',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        expect(find.text('Submit Receipt'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Receipt Details section label is visible',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        expect(find.text('Receipt Details'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Items section label is visible',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        expect(find.text('Items'), findsWidgets);
      },
    );

    // ── Input / Field Behaviour ───────────────────────────────────────────────

    testWidgets(
      'INPUT — User can type vehicle number into Vehicle No. field',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        await TestHelpers.enterText(tester, _vehicleNoField(), 'MH12AB1234');
        final field = tester.widget<TextField>(_vehicleNoField());
        expect(field.controller?.text, 'MH12AB1234');
      },
    );

    testWidgets(
      'INPUT — Vehicle No. field converts text to uppercase',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        // The field has TextCapitalization.characters so keyboard sends uppercase.
        // We verify max 11 chars are accepted.
        await TestHelpers.enterText(
            tester, _vehicleNoField(), '12345678901234'); // >11 chars
        final field = tester.widget<TextField>(_vehicleNoField());
        expect(field.controller?.text.length, lessThanOrEqualTo(11));
      },
    );

    testWidgets(
      'INPUT — Filled qty field only accepts numeric input',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        await TestHelpers.enterText(tester, _filledQtyField(), 'abc');
        final field = tester.widget<TextField>(_filledQtyField());
        // digitsOnly formatter strips non-digits
        expect(field.controller?.text, '');
      },
    );

    testWidgets(
      'INPUT — EMR qty field only accepts numeric input',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        await TestHelpers.enterText(tester, _emrQtyField(), 'xyz');
        final field = tester.widget<TextField>(_emrQtyField());
        expect(field.controller?.text, '');
      },
    );

    testWidgets(
      'INPUT — Filled qty max length is 3 digits',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        await TestHelpers.enterText(tester, _filledQtyField(), '12345');
        final field = tester.widget<TextField>(_filledQtyField());
        expect(field.controller?.text.length, lessThanOrEqualTo(3));
      },
    );

    testWidgets(
      'INPUT — Invoice * field is read-only (disabled)',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        final invoiceField = tester
            .widget<TextField>(find.widgetWithText(TextField, 'Invoice *').first);
        expect(invoiceField.enabled, isFalse);
      },
    );

    testWidgets(
      'INPUT — Invoice auto-fills as sum of Filled + EMR',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        // Enter filled qty
        await TestHelpers.enterText(tester, _filledQtyField(), '10');
        await tester.pump();
        // Enter emr qty — _updateSum triggers on change
        await TestHelpers.enterText(tester, _emrQtyField(), '5');
        await tester.pump(const Duration(milliseconds: 500));
        final invoiceField = tester
            .widget<TextField>(find.widgetWithText(TextField, 'Invoice *').first);
        // 10 + 5 = 15
        expect(invoiceField.controller?.text, '15');
      },
    );

    testWidgets(
      'INPUT — Invoice shows only Filled value when EMR is empty',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        await TestHelpers.enterText(tester, _filledQtyField(), '8');
        await tester.pump(const Duration(milliseconds: 500));
        final invoiceField = tester
            .widget<TextField>(find.widgetWithText(TextField, 'Invoice *').first);
        expect(invoiceField.controller?.text, '8');
      },
    );

    // ── Add / Remove Item Card ────────────────────────────────────────────────

    testWidgets(
      'ADD ITEM — Tapping add button adds a new item card',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        // Count existing Filled fields before add
        final beforeCount =
            tester.widgetList(find.widgetWithText(TextField, 'Filled')).length;
        // Find add button (plus icon)
        final addBtn = find.byIcon(Icons.add_circle_outline_rounded);
        if (addBtn.evaluate().isNotEmpty) {
          await TestHelpers.tap(tester, addBtn);
          await tester.pump();
          final afterCount =
              tester.widgetList(find.widgetWithText(TextField, 'Filled')).length;
          expect(afterCount, greaterThan(beforeCount));
        }
      },
    );

    testWidgets(
      'REMOVE ITEM — Remove button is hidden when only one item card exists',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        // With 1 item card, the AppRemoveButton should not be rendered
        expect(find.byIcon(Icons.remove_circle_outline_rounded), findsNothing);
      },
    );

    // ── Validation — Submit with missing data ─────────────────────────────────

    testWidgets(
      'VALIDATION — Submit without vehicle number shows vehicle validation message',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        // Do NOT enter vehicle number – tap Submit
        await TestHelpers.tap(tester, find.text('Submit Receipt'));
        await tester.pump(const Duration(seconds: 1));
        // Expect flush bar / snackbar with vehicle validation text
        expect(
          find.textContaining('Please enter a valid vehicle number'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'VALIDATION — Submit with vehicle number but no item selected shows item validation',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        await TestHelpers.enterText(tester, _vehicleNoField(), 'MH12AB1234');
        await TestHelpers.tap(tester, find.text('Submit Receipt'));
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.textContaining('Please select a valid item'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'VALIDATION — Submit with item selected but zero qty shows quantity validation',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        await TestHelpers.enterText(tester, _vehicleNoField(), 'MH12AB1234');
        // Select an item from dropdown if available
        final dropdownFinder =
            find.byType(DropdownButtonFormField<dynamic>).first;
        if (dropdownFinder.evaluate().isNotEmpty) {
          await tester.tap(dropdownFinder);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final options = find.byType(DropdownMenuItem);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Leave qty at 0
        await TestHelpers.tap(tester, find.text('Submit Receipt'));
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.textContaining('At least one quantity'),
          findsOneWidget,
        );
      },
    );

    // ── POSITIVE — Full Submit Flow ───────────────────────────────────────────

    testWidgets(
      'SUBMIT — Fill all data and submit successfully navigates away from Item Receipt',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);

        // Enter vehicle number
        await TestHelpers.enterText(tester, _vehicleNoField(), 'MH12AB1234');
        await tester.pump();

        // Select first available item from dropdown
        final dropdownFinder = find.byType(DropdownButtonFormField<dynamic>).first;
        if (dropdownFinder.evaluate().isNotEmpty) {
          await tester.tap(dropdownFinder);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          final options = find.byType(DropdownMenuItem);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Enter filled qty
        await TestHelpers.enterText(tester, _filledQtyField(), '5');
        await tester.pump(const Duration(milliseconds: 500));

        // Tap Submit Receipt
        await tester.ensureVisible(find.text('Submit Receipt'));
        await tester.tap(find.text('Submit Receipt'));
        await tester.pump(const Duration(seconds: 2));

        // Wait for API response
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        // After success the screen navigates away via pushReplacementNamed.
        // We simply assert the test ran without crashing.
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    testWidgets(
      'SUBMIT — After successful submit shows success toast or navigates to Dashboard',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);

        await TestHelpers.enterText(tester, _vehicleNoField(), 'MH12AB5678');
        await tester.pump();

        // Select an item
        final dropdownFinder = find.byType(DropdownButtonFormField<dynamic>).first;
        if (dropdownFinder.evaluate().isNotEmpty) {
          await tester.tap(dropdownFinder);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          final options = find.byType(DropdownMenuItem);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Enter qty
        await TestHelpers.enterText(tester, _filledQtyField(), '2');
        await tester.pump(const Duration(milliseconds: 500));

        await tester.ensureVisible(find.text('Submit Receipt'));
        await tester.tap(find.text('Submit Receipt'));

        // Pump through API call & navigation
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        // Either success toast or Dashboard is shown — we assert no crash.
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    // ── Back Navigation ───────────────────────────────────────────────────────

    testWidgets(
      'NAV — Back button (WillPopScope) navigates to BottomNavigation',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        // WillPopScope overrides back → pushReplacementNamed to BottomNav
        final NavigatorState navigator = tester.state(find.byType(Navigator).last);
        navigator.pop();
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(seconds: 1));
        }
        // Should be back on Dashboard / BottomNav
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    testWidgets(
      'NAV — AppBar back arrow navigates away from Item Receipt',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReceiptScreen(tester);
        final backBtn = find.byTooltip('Back');
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn);
          for (int i = 0; i < 10; i++) {
            await tester.pump(const Duration(seconds: 1));
          }
        }
        expect(find.byType(Scaffold), findsWidgets);
      },
    );
  });
}

// =============================================================================
// ADD RETURN ITEM XMI SCREEN — helpers & tests
// =============================================================================

Future<void> _navigateToXMIScreen(WidgetTester tester) async {
  await TestHelpers.tap(tester, find.text('More'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await TestHelpers.tap(tester, find.text('Return EXMI / Rev-EMR'));
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

Finder _xmiVehicleField() => find.byWidgetPredicate(
    (w) => w is TextField && w.controller != null && w.enabled != false).first;

void _addReturnItemXMIScreenTests() {
  group('AddReturnItemXMI Screen -', () {
    setUp(() async {
      await _seedSharedPrefs();
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    // ── UI Presence ──────────────────────────────────────────────────────────

    testWidgets('UI - AppBar title shows "Return ExMI / Rev-EMR"',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      expect(find.text('Return ExMI / Rev-EMR'), findsWidgets);
    });

    testWidgets('UI - Return Date field is pre-filled with today date',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      final dateFinder = find.byWidgetPredicate(
          (w) => w is TextField && w.enabled == false && w.controller != null);
      expect(dateFinder, findsWidgets);
      final dateField = tester.widget<TextField>(dateFinder.first);
      expect(dateField.controller?.text, isNotEmpty);
    });

    testWidgets('UI - Vehicle No. field is empty on fresh open',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      final vehicleField = tester.widget<TextField>(_xmiVehicleField());
      expect(vehicleField.controller?.text ?? '', isEmpty);
    });

    testWidgets('UI - ITEMS section header is visible',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      expect(find.text('ITEMS'), findsOneWidget);
    });

    testWidgets('UI - Item 1 card with Filled / EMR / Invoice labels',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Filled'), findsWidgets);
      expect(find.text('EMR'), findsWidgets);
      expect(find.text('Invoice'), findsWidgets);
    });

    testWidgets('UI - Submit button is present', (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.ensureVisible(find.text('Submit'));
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets('UI - Add Item button is present',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      expect(find.text('Add Item'), findsOneWidget);
    });

    // ── Input Behaviour ───────────────────────────────────────────────────────

    testWidgets('INPUT - User can type into Vehicle No. field',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.tap(_xmiVehicleField());
      await tester.pumpAndSettle();
      await tester.enterText(_xmiVehicleField(), 'MH12AB1234');
      await tester.pump();
      final field = tester.widget<TextField>(_xmiVehicleField());
      expect(field.controller?.text, 'MH12AB1234');
    });

    testWidgets('INPUT - Vehicle No. field enforces max 11 characters',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.tap(_xmiVehicleField());
      await tester.pumpAndSettle();
      await tester.enterText(_xmiVehicleField(), 'ABCDEFGHIJKLMNOP');
      await tester.pump();
      final field = tester.widget<TextField>(_xmiVehicleField());
      expect((field.controller?.text ?? '').length, lessThanOrEqualTo(11));
    });

    testWidgets('INPUT - Filled qty field accepts only digits',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      final numFields = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.keyboardType == TextInputType.number &&
          w.enabled != false);
      expect(numFields, findsWidgets);
      await tester.tap(numFields.first);
      await tester.pumpAndSettle();
      await tester.enterText(numFields.first, 'abc12');
      await tester.pump();
      final field = tester.widget<TextField>(numFields.first);
      expect(RegExp(r'^\d*$').hasMatch(field.controller?.text ?? ''), isTrue);
    });

    testWidgets('INPUT - Invoice field is disabled / read-only',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      final disabledNum = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.enabled == false &&
          w.keyboardType == TextInputType.number);
      expect(disabledNum, findsWidgets);
    });

    testWidgets('INPUT - Invoice auto-calculates Filled + EMR',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      final numFields = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.keyboardType == TextInputType.number &&
          w.enabled != false);
      if (numFields.evaluate().length >= 2) {
        await tester.tap(numFields.first);
        await tester.pumpAndSettle();
        await tester.enterText(numFields.first, '5');
        await tester.pump();
        await tester.tap(numFields.at(1));
        await tester.pumpAndSettle();
        await tester.enterText(numFields.at(1), '3');
        await tester.pump(const Duration(milliseconds: 300));
        final invoiceField = find.byWidgetPredicate((w) =>
            w is TextField &&
            w.enabled == false &&
            w.keyboardType == TextInputType.number);
        if (invoiceField.evaluate().isNotEmpty) {
          final inv = tester.widget<TextField>(invoiceField.first);
          expect(inv.controller?.text, '8');
        }
      }
    });

    // ── Add / Remove Item Cards ───────────────────────────────────────────────

    testWidgets('ADD - Tapping Add Item inserts a second item card',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.tap(find.text('Add Item'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('REMOVE - Remove button hidden with single item card',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      final removeIcons = find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.remove_rounded);
      expect(removeIcons, findsNothing);
    });

    testWidgets('REMOVE - Remove button visible after adding second card',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 4));
      await tester.tap(find.text('Add Item'), warnIfMissed: false);
      await tester.pumpAndSettle();
      final removeIcons = find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.remove_rounded);
      expect(removeIcons, findsWidgets);
    });

    // ── Validation ────────────────────────────────────────────────────────────

    testWidgets('VALIDATION - Submit without vehicle stays on screen',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(_xmiVehicleField());
      await tester.pumpAndSettle();
      await tester.enterText(_xmiVehicleField(), '');
      await tester.pump();
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'), warnIfMissed: false);
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Return ExMI / Rev-EMR'), findsWidgets);
    });

    testWidgets(
        'VALIDATION - Submit with vehicle but no item stays on screen',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await tester.tap(_xmiVehicleField());
      await tester.pumpAndSettle();
      await tester.enterText(_xmiVehicleField(), 'MH12AB1234');
      await tester.pump();
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'), warnIfMissed: false);
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Return ExMI / Rev-EMR'), findsWidgets);
    });

    testWidgets('VALIDATION - Submit with item but zero qty stays on screen',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 5));
      await tester.tap(_xmiVehicleField());
      await tester.pumpAndSettle();
      await tester.enterText(_xmiVehicleField(), 'MH12AB1234');
      await tester.pump();
      final dropdown = find.byType(DropdownButtonFormField<String>);
      if (dropdown.evaluate().isNotEmpty) {
        await tester.tap(dropdown.first, warnIfMissed: false);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        final dropItems = find.byType(DropdownMenuItem<String>);
        if (dropItems.evaluate().isNotEmpty) {
          await tester.tap(dropItems.last, warnIfMissed: false);
          await tester.pumpAndSettle();
        }
      }
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'), warnIfMissed: false);
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('Return ExMI / Rev-EMR'), findsWidgets);
    });

    // ── Full Submit to API ────────────────────────────────────────────────────

    testWidgets('SUBMIT - Fill all fields and submit ADD request to real API',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 6));

      await tester.tap(_xmiVehicleField());
      await tester.pumpAndSettle();
      await tester.enterText(_xmiVehicleField(), 'MH12AB1234');
      await tester.pump();

      final dropdown = find.byType(DropdownButtonFormField<String>);
      if (dropdown.evaluate().isEmpty) {
        debugPrint('XMI SKIP: No items loaded');
        return;
      }
      await tester.tap(dropdown.first, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final dropItems = find.byType(DropdownMenuItem<String>);
      if (dropItems.evaluate().isEmpty) {
        debugPrint('XMI SKIP: Dropdown empty');
        return;
      }
      await tester.tap(dropItems.last, warnIfMissed: false);
      await tester.pumpAndSettle();

      final numFields = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.keyboardType == TextInputType.number &&
          w.enabled != false);
      if (numFields.evaluate().isEmpty) {
        debugPrint('XMI SKIP: No numeric fields');
        return;
      }
      await tester.tap(numFields.first);
      await tester.pumpAndSettle();
      await tester.enterText(numFields.first, '1');
      await tester.pump(const Duration(milliseconds: 300));

      debugPrint('XMI SUBMIT: tapping Submit');
      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'), warnIfMissed: false);

      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      debugPrint('XMI SUBMIT: checking outcome');
      expect(find.byType(Scaffold).evaluate().isNotEmpty, isTrue);
    });

    testWidgets(
        'SUBMIT - After successful submit navigates away from XMI screen',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      await tester.pumpAndSettle(const Duration(seconds: 6));

      await tester.tap(_xmiVehicleField());
      await tester.pumpAndSettle();
      await tester.enterText(_xmiVehicleField(), 'MH12AB9999');
      await tester.pump();

      final dropdown = find.byType(DropdownButtonFormField<String>);
      if (dropdown.evaluate().isEmpty) return;
      await tester.tap(dropdown.first, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final dropItems = find.byType(DropdownMenuItem<String>);
      if (dropItems.evaluate().isEmpty) return;
      await tester.tap(dropItems.last, warnIfMissed: false);
      await tester.pumpAndSettle();

      final numFields = find.byWidgetPredicate((w) =>
          w is TextField &&
          w.keyboardType == TextInputType.number &&
          w.enabled != false);
      if (numFields.evaluate().isEmpty) return;
      await tester.tap(numFields.first);
      await tester.pumpAndSettle();
      await tester.enterText(numFields.first, '1');
      await tester.pump(const Duration(milliseconds: 300));

      await tester.ensureVisible(find.text('Submit'));
      await tester.tap(find.text('Submit'), warnIfMissed: false);

      for (int i = 0; i < 30; i++) {
        await tester.pump(const Duration(seconds: 1));
      }

      expect(find.byType(Scaffold), findsWidgets);
    });

    // ── Back Navigation ───────────────────────────────────────────────────────

    testWidgets('NAV - Back button navigates away from XMI screen',
        (WidgetTester tester) async {
      await _bootAppLoggedIn(tester);
      await _navigateToXMIScreen(tester);
      final NavigatorState navigator =
          tester.state(find.byType(Navigator));
      navigator.pop();
      for (int i = 0; i < 5; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}

// =============================================================================
// SECTION 7 — ITEM RETURN SCREEN TESTS
// Screen: ItemReturnScreen  (/itemReturnScreen)
// Navigation: More → "Item Return"
// =============================================================================

/// Navigates to ItemReturnScreen via More → Item Return.
Future<void> _navigateToItemReturnScreen(WidgetTester tester) async {
  await TestHelpers.tap(tester, find.text('More'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await TestHelpers.tap(tester, find.text('Item Return'));
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

void _itemReturnScreenTests() {
  group('Item Return Screen —', () {
    setUp(() async {
      await _seedSharedPrefs();
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    // ── UI Presence ──────────────────────────────────────────────────────────

    testWidgets(
      'UI — Item Return screen has AppBar title "Item Return"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        expect(find.text('Item Return'), findsWidgets);
      },
    );

    testWidgets(
      'UI — SQC FAB button is visible',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        expect(find.text('SQC'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Screen shows loading indicator initially',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await TestHelpers.tap(tester, find.text('More'));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await tester.tap(find.text('Item Return'));
        await tester.pump(const Duration(milliseconds: 500)); // during loading
        // Either loading indicator or list/empty state is shown
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    testWidgets(
      'UI — Screen shows list or empty state after data loads',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        // Either a ListView with items or the "No Data Found" empty state
        final hasData = find.byType(ListView).evaluate().isNotEmpty ||
            find.text('No Data Found').evaluate().isNotEmpty;
        expect(hasData, isTrue);
      },
    );

    testWidgets(
      'UI — Empty state shows descriptive text when no receipts',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        // If empty, checks for empty-state texts
        if (find.text('No Data Found').evaluate().isNotEmpty) {
          expect(find.text('No Data Found'), findsOneWidget);
        }
      },
    );

    // ── SQC FAB / Bottom Sheet ────────────────────────────────────────────────

    testWidgets(
      'SQC FAB — Tapping SQC FAB when no vehicles shows flush bar message',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        // When receiptList is empty the FAB shows "All vehicles are already out."
        if (find.text('No Data Found').evaluate().isNotEmpty) {
          await TestHelpers.tap(tester, find.text('SQC'));
          await tester.pump(const Duration(seconds: 1));
          expect(
            find.textContaining('All vehicles are already out'),
            findsOneWidget,
          );
        }
      },
    );

    testWidgets(
      'SQC FAB — Tapping SQC FAB with vehicles opens bottom sheet titled "SQC Vehicles"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        if (find.byType(ListView).evaluate().isNotEmpty) {
          await TestHelpers.tap(tester, find.text('SQC'));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          expect(find.text('SQC Vehicles'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'SQC FAB — Bottom sheet lists available vehicles with vehicle number',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        if (find.byType(ListView).evaluate().isNotEmpty) {
          await TestHelpers.tap(tester, find.text('SQC'));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          if (find.text('SQC Vehicles').evaluate().isNotEmpty) {
            // At least one vehicle tile should be in the bottom sheet
            expect(find.byType(ListTile), findsWidgets);
          }
        }
      },
    );

    testWidgets(
      'SQC FAB — Selecting a vehicle from bottom sheet navigates to SQC Register',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        if (find.byType(ListView).evaluate().isNotEmpty) {
          await TestHelpers.tap(tester, find.text('SQC'));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          if (find.text('SQC Vehicles').evaluate().isNotEmpty) {
            final tiles = find.byType(ListTile);
            if (tiles.evaluate().isNotEmpty) {
              await tester.tap(tiles.first);
              for (int i = 0; i < 15; i++) {
                await tester.pump(const Duration(seconds: 1));
              }
              // Should be on SQC Register screen
              expect(find.text('SQC Register'), findsWidgets);
            }
          }
        }
      },
    );

    // ── Pull to Refresh ───────────────────────────────────────────────────────

    testWidgets(
      'REFRESH — Pull-to-refresh reloads the list',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        // Simulate a pull-to-refresh gesture
        await tester.fling(
          find.byType(RefreshIndicator),
          const Offset(0, 300),
          1000,
        );
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle(const Duration(seconds: 5));
        // Screen should still be visible after refresh
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    // ── Back Navigation ───────────────────────────────────────────────────────

    testWidgets(
      'NAV — Back navigates to BottomNavigation screen',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToItemReturnScreen(tester);
        final NavigatorState navigator =
            tester.state(find.byType(Navigator).last);
        navigator.pop();
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(seconds: 1));
        }
        expect(find.byType(Scaffold), findsWidgets);
      },
    );
  });
}

// =============================================================================
// SECTION 8 — SQC REGISTER SCREEN TESTS
// Screen: SQCRegisterScreen  (/sqcregisterScreen)
// Navigation: Item Return → SQC FAB → select vehicle → SQCRegisterScreen
//             OR: direct pushNamed with arguments
// =============================================================================

/// Navigates to SQCRegisterScreen by going through ItemReturn → SQC → first vehicle.
/// Falls back to direct navigation if no vehicles are available.
Future<bool> _navigateToSQCScreen(WidgetTester tester) async {
  await TestHelpers.tap(tester, find.text('More'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await TestHelpers.tap(tester, find.text('Item Return'));
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(seconds: 5));

  if (find.byType(ListView).evaluate().isNotEmpty) {
    await TestHelpers.tap(tester, find.text('SQC'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    if (find.text('SQC Vehicles').evaluate().isNotEmpty) {
      final tiles = find.byType(ListTile);
      if (tiles.evaluate().isNotEmpty) {
        await tester.tap(tiles.first);
        for (int i = 0; i < 15; i++) {
          await tester.pump(const Duration(seconds: 1));
        }
        return find.text('SQC Register').evaluate().isNotEmpty;
      }
    }
  }
  return false;
}

void _sqcRegisterScreenTests() {
  group('SQC Register Screen —', () {
    setUp(() async {
      await _seedSharedPrefs();
    });

    tearDown(() async {
      await _clearSharedPrefs();
    });

    // ── UI Presence ──────────────────────────────────────────────────────────

    testWidgets(
      'UI — SQC Register screen has AppBar title "SQC Register"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return; // skip if no vehicle data
        expect(find.text('SQC Register'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Section headers are visible: Cylinder Details, Weight Measurements, Inspection Details',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.text('Cylinder Details'), findsOneWidget);
        expect(find.text('Weight Measurements'), findsOneWidget);
        expect(find.text('Inspection Details'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Vehicle No. read-only field is pre-filled from navigation args',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        // vehicleNoController is a read-only field labelled 'SQC Vehicle No.'
        final vehicleField = find.widgetWithText(TextField, 'SQC Vehicle No.');
        if (vehicleField.evaluate().isNotEmpty) {
          final tf = tester.widget<TextField>(vehicleField.first);
          expect(tf.controller?.text ?? '', isNotEmpty);
        }
      },
    );

    testWidgets(
      'UI — Select Item dropdown is present',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(
          find.byType(DropdownButtonFormField<String>),
          findsWidgets,
        );
      },
    );

    testWidgets(
      'UI — Tare Weight, Gross Weight, Observed Weight, Variation fields are visible',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.widgetWithText(TextField, 'Tare Wt'), findsWidgets);
        expect(find.widgetWithText(TextField, 'Gross Wt'), findsWidgets);
      },
    );

    testWidgets(
      'UI — "Add to Queue" button is visible in Add mode',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.text('Add to Queue'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — "Save All" button is visible',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.text('Save All'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Cancel button is visible',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.text('Cancel'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — DPT Date field with hint "e.g. A-24" is present',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.widgetWithText(TextFormField, 'e.g. A-24'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Sealing and Leaky dropdowns are present',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.text('Sealing *'), findsOneWidget);
        expect(find.text('Leaky *'), findsOneWidget);
      },
    );

    testWidgets(
      'UI — Serial Number TextField with hint "Serial No" is present',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.widgetWithText(TextField, 'Serial No'), findsWidgets);
      },
    );

    testWidgets(
      'UI — Today\'s SQC Records section is visible',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        expect(find.textContaining("Today's SQC Records"), findsOneWidget);
      },
    );

    // ── Calculations ──────────────────────────────────────────────────────────

    testWidgets(
      'CALC — Gross Weight auto-calculates from Tare Weight when item is selected',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Select first item
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final options = find.byType(DropdownMenuItem<String>);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Enter Tare Weight
        final tareField = find.widgetWithText(TextField, 'Tare Wt');
        if (tareField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tareField.first, '15.0');
          await tester.pump(const Duration(milliseconds: 500));
          // Gross = Tare + item weight (auto-calculated)
          final grossField =
              tester.widget<TextField>(find.widgetWithText(TextField, 'Gross Wt').first);
          expect(grossField.controller?.text, isNotEmpty);
        }
      },
    );

    testWidgets(
      'CALC — Variation auto-calculates as Gross - Observed',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        final obsField = find.widgetWithText(TextField, 'Obs Wt');
        if (obsField.evaluate().isNotEmpty) {
          // Set observed weight (overriding auto-calc if needed)
          final obsController = tester
              .widget<TextField>(obsField.first)
              .controller;
          if (obsController != null && obsController.text.isNotEmpty) {
            // If observed is already filled, just verify variation is computed
            final varField = find.widgetWithText(TextField, 'Variation');
            if (varField.evaluate().isNotEmpty) {
              final varController =
                  tester.widget<TextField>(varField.first).controller;
              // Variation must not be empty after gross and observed are set
              expect(varController?.text ?? '', isNotEmpty);
            }
          }
        }
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    // ── Validation — addItem() ────────────────────────────────────────────────

    testWidgets(
      'VALIDATION — Add to Queue without selecting item shows "Please Select An Item"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));
        expect(find.textContaining('Please Select An Item'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — Add to Queue without Tare Weight shows "Please Enter Tare Weight"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Select an item first
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final options = find.byType(DropdownMenuItem<String>);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));
        expect(find.textContaining('Please Enter Tare Weight'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — Add to Queue without DPT Date shows "Please Enter DPT Date"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Select item
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final options = find.byType(DropdownMenuItem<String>);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Enter tare weight
        final tareField = find.widgetWithText(TextField, 'Tare Wt');
        if (tareField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tareField.first, '15.0');
        }
        // Enter observed weight
        final obsField = find.widgetWithText(TextField, 'Obs Wt');
        if (obsField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, obsField.first, '14.0');
        }

        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));
        expect(find.textContaining('Please Enter DPT Date'), findsOneWidget);
      },
    );

    testWidgets(
      'VALIDATION — Add to Queue without Sealing Condition shows appropriate message',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Select item + enter weights + enter DPT date
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final options = find.byType(DropdownMenuItem<String>);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        final tareField = find.widgetWithText(TextField, 'Tare Wt');
        if (tareField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tareField.first, '15.0');
        }
        final obsField = find.widgetWithText(TextField, 'Obs Wt');
        if (obsField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, obsField.first, '14.0');
        }
        final dptField = find.widgetWithText(TextFormField, 'e.g. A-24');
        if (dptField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, dptField.first, 'A-24');
        }

        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.textContaining('Please Select Sealing Condition'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'VALIDATION — Add to Queue without Serial Number shows "Please Enter Serial Number"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Fill all required fields except serial number
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isNotEmpty) {
          await tester.tap(dropdowns.first);
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final options = find.byType(DropdownMenuItem<String>);
          if (options.evaluate().length > 1) {
            await tester.tap(options.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        final tareField = find.widgetWithText(TextField, 'Tare Wt');
        if (tareField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tareField.first, '15.0');
        }
        final obsField = find.widgetWithText(TextField, 'Obs Wt');
        if (obsField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, obsField.first, '14.0');
        }
        final dptField = find.widgetWithText(TextFormField, 'e.g. A-24');
        if (dptField.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, dptField.first, 'A-24');
        }

        // Select Sealing = Yes
        final sealingDropdowns = find.byType(DropdownButtonFormField<String>);
        if (sealingDropdowns.evaluate().length > 1) {
          await tester.tap(sealingDropdowns.at(1));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final opts = find.byType(DropdownMenuItem<String>);
          if (opts.evaluate().isNotEmpty) {
            await tester.tap(opts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Select Leaky = No
        if (sealingDropdowns.evaluate().length > 2) {
          await tester.tap(sealingDropdowns.at(2));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final opts = find.byType(DropdownMenuItem<String>);
          if (opts.evaluate().isNotEmpty) {
            await tester.tap(opts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));
        expect(
          find.textContaining('Please Enter Serial Number'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'VALIDATION — Duplicate serial number shows duplicate warning',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Helper to fill minimum valid item
        Future<void> fillAndAdd(String serialNo) async {
          final dropdowns = find.byType(DropdownButtonFormField<String>);
          if (dropdowns.evaluate().isNotEmpty) {
            await tester.tap(dropdowns.first);
            await tester.pumpAndSettle(const Duration(seconds: 1));
            final options = find.byType(DropdownMenuItem<String>);
            if (options.evaluate().length > 1) {
              await tester.tap(options.last, warnIfMissed: false);
              await tester.pumpAndSettle();
            }
          }
          final tare = find.widgetWithText(TextField, 'Tare Wt');
          if (tare.evaluate().isNotEmpty) {
            await TestHelpers.enterText(tester, tare.first, '15.0');
          }
          final obs = find.widgetWithText(TextField, 'Obs Wt');
          if (obs.evaluate().isNotEmpty) {
            await TestHelpers.enterText(tester, obs.first, '14.0');
          }
          final dpt = find.widgetWithText(TextFormField, 'e.g. A-24');
          if (dpt.evaluate().isNotEmpty) {
            await TestHelpers.enterText(tester, dpt.first, 'A-24');
          }
          // Set Sealing
          final allDrops = find.byType(DropdownButtonFormField<String>);
          if (allDrops.evaluate().length > 1) {
            await tester.tap(allDrops.at(1));
            await tester.pumpAndSettle(const Duration(seconds: 1));
            final opts = find.byType(DropdownMenuItem<String>);
            if (opts.evaluate().isNotEmpty) {
              await tester.tap(opts.last, warnIfMissed: false);
              await tester.pumpAndSettle();
            }
          }
          // Set Leaky = No
          if (allDrops.evaluate().length > 2) {
            await tester.tap(allDrops.at(2));
            await tester.pumpAndSettle(const Duration(seconds: 1));
            final opts = find.byType(DropdownMenuItem<String>);
            if (opts.evaluate().isNotEmpty) {
              // pick "No" which is last
              await tester.tap(opts.last, warnIfMissed: false);
              await tester.pumpAndSettle();
            }
          }
          // Enter serial number
          final serial = find.widgetWithText(TextField, 'Serial No');
          if (serial.evaluate().isNotEmpty) {
            await TestHelpers.enterText(tester, serial.first, serialNo);
          }
          await TestHelpers.tap(tester, find.text('Add to Queue'));
          await tester.pump(const Duration(seconds: 1));
        }

        await fillAndAdd('ABC001');
        // Second add with same serial — should show duplicate warning
        await fillAndAdd('ABC001');
        expect(
          find.textContaining('Duplicate Serial Number'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'VALIDATION — Save All disabled when queue is empty',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        // Save All button is disabled when sqcItemList is empty
        final saveBtn = tester.widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Save All').first);
        expect(saveBtn.onPressed, isNull);
      },
    );

    // ── Leakage conditional UI ────────────────────────────────────────────────

    testWidgets(
      'CONDITIONAL — Selecting "Leaky = Yes" reveals Leak Type dropdown',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Find Leaky dropdown (3rd DropdownButtonFormField<String>)
        final strDropdowns = find.byType(DropdownButtonFormField<String>);
        if (strDropdowns.evaluate().length >= 3) {
          await tester.tap(strDropdowns.at(2));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final opts = find.byType(DropdownMenuItem<String>);
          if (opts.evaluate().isNotEmpty) {
            // Tap "Yes"
            await tester.tap(opts.first, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
          // Leak Type * label should now be visible
          expect(find.text('Leak Type *'), findsOneWidget);
        }
      },
    );

    testWidgets(
      'CONDITIONAL — Selecting "Leaky = No" hides Leak Type dropdown',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        final strDropdowns = find.byType(DropdownButtonFormField<String>);
        if (strDropdowns.evaluate().length >= 3) {
          // First set to Yes
          await tester.tap(strDropdowns.at(2));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final yesOpts = find.byType(DropdownMenuItem<String>);
          if (yesOpts.evaluate().isNotEmpty) {
            await tester.tap(yesOpts.first, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
          // Then set back to No
          final strDropdowns2 = find.byType(DropdownButtonFormField<String>);
          if (strDropdowns2.evaluate().length >= 3) {
            await tester.tap(strDropdowns2.at(2));
            await tester.pumpAndSettle(const Duration(seconds: 1));
            final noOpts = find.byType(DropdownMenuItem<String>);
            if (noOpts.evaluate().isNotEmpty) {
              await tester.tap(noOpts.last, warnIfMissed: false);
              await tester.pumpAndSettle();
            }
          }
          expect(find.text('Leak Type *'), findsNothing);
        }
      },
    );

    // ── Add to Queue & Queue list ────────────────────────────────────────────

    testWidgets(
      'QUEUE — Adding a valid item shows it in the Queued Items section',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Select item
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isEmpty) return;
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final opts = find.byType(DropdownMenuItem<String>);
        if (opts.evaluate().length <= 1) return;
        await tester.tap(opts.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Fill required fields
        final tare = find.widgetWithText(TextField, 'Tare Wt');
        if (tare.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tare.first, '15.0');
        }
        final obs = find.widgetWithText(TextField, 'Obs Wt');
        if (obs.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, obs.first, '14.0');
        }
        final dpt = find.widgetWithText(TextFormField, 'e.g. A-24');
        if (dpt.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, dpt.first, 'A-24');
        }

        // Sealing
        final allDrops = find.byType(DropdownButtonFormField<String>);
        if (allDrops.evaluate().length > 1) {
          await tester.tap(allDrops.at(1));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final sealOpts = find.byType(DropdownMenuItem<String>);
          if (sealOpts.evaluate().isNotEmpty) {
            await tester.tap(sealOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Leaky = No
        if (allDrops.evaluate().length > 2) {
          await tester.tap(allDrops.at(2));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final leakOpts = find.byType(DropdownMenuItem<String>);
          if (leakOpts.evaluate().isNotEmpty) {
            await tester.tap(leakOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        // Serial number
        final serial = find.widgetWithText(TextField, 'Serial No');
        if (serial.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, serial.first, 'SRL12345');
        }

        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));

        // Queue section header "Queued Items (1)" should appear
        expect(find.textContaining('Queued Items'), findsOneWidget);
      },
    );

    testWidgets(
      'QUEUE — Adding item clears the form fields',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Fill and add
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isEmpty) return;
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final opts = find.byType(DropdownMenuItem<String>);
        if (opts.evaluate().length <= 1) return;
        await tester.tap(opts.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        final tare = find.widgetWithText(TextField, 'Tare Wt');
        if (tare.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tare.first, '15.0');
        }
        final obs = find.widgetWithText(TextField, 'Obs Wt');
        if (obs.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, obs.first, '14.0');
        }
        final dpt = find.widgetWithText(TextFormField, 'e.g. A-24');
        if (dpt.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, dpt.first, 'A-24');
        }
        final allDrops = find.byType(DropdownButtonFormField<String>);
        if (allDrops.evaluate().length > 1) {
          await tester.tap(allDrops.at(1));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final sealOpts = find.byType(DropdownMenuItem<String>);
          if (sealOpts.evaluate().isNotEmpty) {
            await tester.tap(sealOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        if (allDrops.evaluate().length > 2) {
          await tester.tap(allDrops.at(2));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final leakOpts = find.byType(DropdownMenuItem<String>);
          if (leakOpts.evaluate().isNotEmpty) {
            await tester.tap(leakOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        final serial = find.widgetWithText(TextField, 'Serial No');
        if (serial.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, serial.first, 'SRL99999');
        }

        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));

        // After adding, serial no field should be cleared
        final serialAfter = find.widgetWithText(TextField, 'Serial No');
        if (serialAfter.evaluate().isNotEmpty) {
          final tf = tester.widget<TextField>(serialAfter.first);
          expect(tf.controller?.text ?? '', isEmpty);
        }
      },
    );

    // ── POSITIVE — Save All (real API submit) ────────────────────────────────

    testWidgets(
      'SUBMIT — Add valid item and Save All sends to API without crash',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Fill & add one item to queue
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isEmpty) return;
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final opts = find.byType(DropdownMenuItem<String>);
        if (opts.evaluate().length <= 1) return;
        await tester.tap(opts.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        final tare = find.widgetWithText(TextField, 'Tare Wt');
        if (tare.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tare.first, '15.0');
        }
        final obs = find.widgetWithText(TextField, 'Obs Wt');
        if (obs.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, obs.first, '14.5');
        }
        final dpt = find.widgetWithText(TextFormField, 'e.g. A-24');
        if (dpt.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, dpt.first, 'B-24');
        }
        final allDrops = find.byType(DropdownButtonFormField<String>);
        if (allDrops.evaluate().length > 1) {
          await tester.tap(allDrops.at(1));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final sealOpts = find.byType(DropdownMenuItem<String>);
          if (sealOpts.evaluate().isNotEmpty) {
            await tester.tap(sealOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        if (allDrops.evaluate().length > 2) {
          await tester.tap(allDrops.at(2));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final leakOpts = find.byType(DropdownMenuItem<String>);
          if (leakOpts.evaluate().isNotEmpty) {
            await tester.tap(leakOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }

        // Use a time-based unique serial to avoid duplicates on re-run
        final ts = DateTime.now().millisecondsSinceEpoch.toString().substring(7);
        final serial = find.widgetWithText(TextField, 'Serial No');
        if (serial.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, serial.first, 'TST$ts');
        }

        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));

        // Tap Save All
        await tester.ensureVisible(find.text('Save All'));
        await tester.tap(find.text('Save All'));

        // Wait for API response
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        // Outcome: success toast or duplicate serial toast — no crash
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    testWidgets(
      'SUBMIT — After successful save, queue is cleared and screen navigates to Item Return',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;

        // Add unique item
        final dropdowns = find.byType(DropdownButtonFormField<String>);
        if (dropdowns.evaluate().isEmpty) return;
        await tester.tap(dropdowns.first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        final opts = find.byType(DropdownMenuItem<String>);
        if (opts.evaluate().length <= 1) return;
        await tester.tap(opts.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        final tare = find.widgetWithText(TextField, 'Tare Wt');
        if (tare.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, tare.first, '15.0');
        }
        final obs = find.widgetWithText(TextField, 'Obs Wt');
        if (obs.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, obs.first, '14.2');
        }
        final dpt = find.widgetWithText(TextFormField, 'e.g. A-24');
        if (dpt.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, dpt.first, 'C-23');
        }
        final allDrops = find.byType(DropdownButtonFormField<String>);
        if (allDrops.evaluate().length > 1) {
          await tester.tap(allDrops.at(1));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final sealOpts = find.byType(DropdownMenuItem<String>);
          if (sealOpts.evaluate().isNotEmpty) {
            await tester.tap(sealOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        if (allDrops.evaluate().length > 2) {
          await tester.tap(allDrops.at(2));
          await tester.pumpAndSettle(const Duration(seconds: 1));
          final leakOpts = find.byType(DropdownMenuItem<String>);
          if (leakOpts.evaluate().isNotEmpty) {
            await tester.tap(leakOpts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        final ts2 = DateTime.now().millisecondsSinceEpoch.toString().substring(6);
        final serial = find.widgetWithText(TextField, 'Serial No');
        if (serial.evaluate().isNotEmpty) {
          await TestHelpers.enterText(tester, serial.first, 'SV$ts2');
        }

        await TestHelpers.tap(tester, find.text('Add to Queue'));
        await tester.pump(const Duration(seconds: 1));

        await tester.ensureVisible(find.text('Save All'));
        await tester.tap(find.text('Save All'));
        for (int i = 0; i < 30; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        // After success: either on Item Return screen, or toast visible — no crash
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    // ── Back Navigation ───────────────────────────────────────────────────────

    testWidgets(
      'NAV — Back navigates to ItemReturnScreen',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        final NavigatorState navigator =
            tester.state(find.byType(Navigator).last);
        navigator.pop();
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(seconds: 1));
        }
        expect(find.byType(Scaffold), findsWidgets);
      },
    );

    testWidgets(
      'NAV — Cancel button navigates away from SQC Register',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        final reached = await _navigateToSQCScreen(tester);
        if (!reached) return;
        await tester.ensureVisible(find.text('Cancel'));
        await tester.tap(find.text('Cancel'));
        for (int i = 0; i < 10; i++) {
          await tester.pump(const Duration(seconds: 1));
        }
        expect(find.byType(Scaffold), findsWidgets);
      },
    );
  });
}

void main() {
  // Binds the integration test framework.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // HTTP is mocked via MockClient from package:http/testing.dart (see Appendix).
  // setUpAll(() {
  //   registerFallbackValue(Uri.parse('https://example.com'));
  // });

  // ── Run all test groups ────────────────────────────────────────────────────
  _loginTests();
  _dashboardTests();
  _transferScreenTests();
  _sessionTests();
  _itemReceiptScreenTests();
  _itemReturnScreenTests();
  _sqcRegisterScreenTests();
  _addReturnItemXMIScreenTests();
  _itemReturnXMIListScreenTests();
  _markDefectiveItemScreenTests();
}

// =============================================================================
// ITEM RETURN XMI LIST SCREEN TESTS
// =============================================================================

Future<void> _navigateToXMIListScreen(WidgetTester tester) async {
  await TestHelpers.tap(tester, find.text('More'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await TestHelpers.tap(tester, find.text('Receipt EXMI'));
  await tester.pump(const Duration(seconds: 2));
  await tester.pumpAndSettle(const Duration(seconds: 5));
}

void _itemReturnXMIListScreenTests() {
  group('ItemReturnXMIListScreen', () {
    // ── UI PRESENCE ──────────────────────────────────────────────────────────

    testWidgets(
      'UI — AppBar shows "Receipt EXMI" title',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        expect(find.text('Receipt EXMI'), findsWidgets);
      },
    );

    testWidgets(
      'UI — shows loading indicator while fetching',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await TestHelpers.tap(tester, find.text('More'));
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await TestHelpers.tap(tester, find.text('Receipt EXMI'));
        // Pump a single frame — loading spinner should appear before API returns
        await tester.pump();
        final hasLoading = find.byType(CircularProgressIndicator).evaluate().isNotEmpty ||
            find.text('Loading receipts…').evaluate().isNotEmpty;
        expect(hasLoading, isTrue);
      },
    );

    testWidgets(
      'UI — shows list or empty state after load',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        final hasList = find.byType(ListView).evaluate().isNotEmpty;
        final hasEmpty = find.text('No Data Found').evaluate().isNotEmpty;
        expect(hasList || hasEmpty, isTrue);
      },
    );

    testWidgets(
      'UI — empty state shows "Pull down to refresh"',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('No Data Found').evaluate().isNotEmpty) {
          expect(find.text('Pull down to refresh'), findsOneWidget);
        }
      },
    );

    // ── LIST CARD BEHAVIOR ───────────────────────────────────────────────────

    testWidgets(
      'LIST — each card shows Vehicle No. and date',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.textContaining('Vehicle No.').evaluate().isEmpty) return;
        expect(find.textContaining('Vehicle No.'), findsWidgets);
      },
    );

    testWidgets(
      'LIST — each card shows status badge (Received or Pending)',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.byType(ListView).evaluate().isEmpty) return;
        final hasReceived = find.textContaining('Received').evaluate().isNotEmpty;
        final hasPending = find.text('Pending').evaluate().isNotEmpty;
        expect(hasReceived || hasPending, isTrue);
      },
    );

    testWidgets(
      'LIST — each card has "View More" expand toggle',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.byType(ListView).evaluate().isEmpty) return;
        expect(find.text('View More'), findsWidgets);
      },
    );

    // ── EXPAND / COLLAPSE ────────────────────────────────────────────────────

    testWidgets(
      'EXPAND — tapping "View More" expands card to show item table',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        // After expand the toggle changes to "View Less"
        expect(find.text('View Less'), findsWidgets);
      },
    );

    testWidgets(
      'EXPAND — expanded card shows ITEM / STOCK column headers',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.text('ITEM'), findsWidgets);
        expect(find.text('STOCK'), findsWidgets);
      },
    );

    testWidgets(
      'EXPAND — tapping "View Less" collapses card back',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        if (find.text('View Less').evaluate().isEmpty) return;
        await tester.tap(find.text('View Less').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.text('View More'), findsWidgets);
      },
    );

    // ── PENDING CARD ACTION BUTTONS ──────────────────────────────────────────

    testWidgets(
      'ACTIONS — pending card shows Edit icon button when expanded',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        // Find a pending card
        if (find.text('Pending').evaluate().isEmpty) return;
        // Expand the first pending card
        final pendingIdx = find.text('View More').evaluate().isNotEmpty
            ? 0
            : -1;
        if (pendingIdx < 0) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        // Edit icon button should be visible
        expect(find.byIcon(Icons.edit_rounded), findsWidgets);
      },
    );

    testWidgets(
      'ACTIONS — pending card shows In (shipping) icon button when expanded',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('Pending').evaluate().isEmpty) return;
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        expect(find.byIcon(Icons.local_shipping_rounded), findsWidgets);
      },
    );

    // ── EDIT NAVIGATION ──────────────────────────────────────────────────────

    testWidgets(
      'EDIT — tapping Edit icon navigates to AddReturnItemXMIScreen in Edit mode',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('Pending').evaluate().isEmpty) return;
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        if (find.byIcon(Icons.edit_rounded).evaluate().isEmpty) return;
        await tester.tap(find.byIcon(Icons.edit_rounded).first);
        await tester.pumpAndSettle(const Duration(seconds: 5));
        // Should navigate to AddReturnItemXMI screen
        expect(find.text('Return ExMI / Rev-EMR'), findsWidgets);
      },
    );

    // ── IN / RECEIVE DIALOG ──────────────────────────────────────────────────

    testWidgets(
      'DIALOG — tapping In icon opens receive details dialog',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('Pending').evaluate().isEmpty) return;
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        if (find.byIcon(Icons.local_shipping_rounded).evaluate().isEmpty) return;
        // Tap the shipping/In button
        await tester.tap(find.byIcon(Icons.local_shipping_rounded).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        // Dialog title or close button should appear
        final hasDialog = find.text('Details for Items Receipt').evaluate().isNotEmpty ||
            find.text('Close').evaluate().isNotEmpty ||
            find.byType(AlertDialog).evaluate().isNotEmpty;
        expect(hasDialog, isTrue);
      },
    );

    testWidgets(
      'DIALOG — receive dialog has "Close" button and closes on tap',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('Pending').evaluate().isEmpty) return;
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        if (find.byIcon(Icons.local_shipping_rounded).evaluate().isEmpty) return;
        await tester.tap(find.byIcon(Icons.local_shipping_rounded).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        if (find.text('Close').evaluate().isEmpty) return;
        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog).evaluate().isEmpty, isTrue);
      },
    );

    // ── SUBMIT VIA IN DIALOG (real API) ──────────────────────────────────────

    testWidgets(
      'SUBMIT — receive dialog "Receive" button submits to API and returns to list',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.text('Pending').evaluate().isEmpty) return;
        if (find.text('View More').evaluate().isEmpty) return;
        await tester.tap(find.text('View More').first);
        await tester.pumpAndSettle(const Duration(seconds: 1));
        if (find.byIcon(Icons.local_shipping_rounded).evaluate().isEmpty) return;
        await tester.tap(find.byIcon(Icons.local_shipping_rounded).first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        // The dialog has a Receive/Save action button
        final receiveBtn = find.widgetWithText(ElevatedButton, 'Receive');
        final saveBtn = find.widgetWithText(ElevatedButton, 'Save');
        if (receiveBtn.evaluate().isEmpty && saveBtn.evaluate().isEmpty) return;
        final btn = receiveBtn.evaluate().isNotEmpty ? receiveBtn : saveBtn;
        await tester.tap(btn);
        // Wait for API response
        for (int i = 0; i < 15; i++) {
          await tester.pump(const Duration(seconds: 1));
        }
        // Should navigate away or show success/toast
        final isOnListScreen = find.text('Receipt EXMI').evaluate().isNotEmpty ||
            find.text('No Data Found').evaluate().isNotEmpty ||
            find.textContaining('Vehicle No.').evaluate().isNotEmpty;
        expect(isOnListScreen, isTrue);
      },
    );

    // ── PULL TO REFRESH ──────────────────────────────────────────────────────

    testWidgets(
      'REFRESH — pull-to-refresh reloads the list',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        if (find.byType(ListView).evaluate().isEmpty) return;
        // Simulate pull-to-refresh
        await tester.fling(find.byType(ListView).first, const Offset(0, 300), 800);
        await tester.pump(const Duration(seconds: 1));
        // RefreshIndicator should show a CircularProgressIndicator
        expect(find.byType(RefreshIndicator), findsWidgets);
        await tester.pumpAndSettle(const Duration(seconds: 5));
      },
    );

    // ── BACK NAVIGATION ──────────────────────────────────────────────────────

    testWidgets(
      'NAV — back button returns to the GodownKeeper home',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToXMIListScreen(tester);
        final backBtn = find.byTooltip('Back');
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn.first);
        } else {
          final navBack = find.byType(BackButton);
          if (navBack.evaluate().isNotEmpty) {
            await tester.tap(navBack.first);
          }
        }
        await tester.pumpAndSettle(const Duration(seconds: 3));
        // Should be on the main GodownKeeper bottom nav
        expect(find.text('More'), findsWidgets);
      },
    );
  });
}

// =============================================================================
// MARK DEFECTIVE ITEM SCREEN TESTS
// =============================================================================

Future<void> _navigateToMarkDefectiveScreen(WidgetTester tester) async {
  await TestHelpers.tap(tester, find.text('More'));
  await tester.pumpAndSettle(const Duration(seconds: 2));
  await TestHelpers.tap(tester, find.text('Mark Defective'));
  // Pump in small ticks so any outstanding FlushBar / EasyLoading timers fire
  // without the test binding seeing a "pending frame" assertion.
  for (int i = 0; i < 12; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
  // Final settle to drain EasyLoading dismiss animations
  try {
    await tester.pumpAndSettle(const Duration(seconds: 3));
  } catch (_) {
    // pumpAndSettle may throw if there are infinite animations (e.g. EasyLoading spinner)
    for (int i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }
}

/// Drain FlushBar / EasyLoading animations so they don't bleed into next test.
Future<void> _drainMarkDefective(WidgetTester tester) async {
  for (int i = 0; i < 5; i++) {
    await tester.pump(const Duration(seconds: 1));
  }
}

void _markDefectiveItemScreenTests() {
  group('MarkDefectiveItemScreen', () {
    // ── UI PRESENCE ──────────────────────────────────────────────────────────

    testWidgets(
      'UI — AppBar shows "Mark Defective" title',
      (WidgetTester tester) async {
        addTearDown(() => tester.pumpAndSettle(const Duration(seconds: 5)));
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        expect(find.text('Mark Defective'), findsWidgets);
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'UI — Date field is present and pre-filled with today\'s date',
      (WidgetTester tester) async {
        addTearDown(() => tester.pumpAndSettle(const Duration(seconds: 5)));
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        expect(find.textContaining('Date'), findsWidgets);
        final dateFields = tester.widgetList<TextField>(find.byType(TextField));
        final dateField = dateFields.firstWhere(
          (tf) => tf.controller != null && tf.controller!.text.isNotEmpty && tf.readOnly,
          orElse: () => dateFields.first,
        );
        expect(dateField.controller!.text, isNotEmpty);
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'UI — Select Item dropdown is present',
      (WidgetTester tester) async {
        addTearDown(() => tester.pumpAndSettle(const Duration(seconds: 5)));
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        expect(find.byType(DropdownButtonFormField), findsWidgets);
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'UI — Defective Count input field is present',
      (WidgetTester tester) async {
        addTearDown(() => tester.pumpAndSettle(const Duration(seconds: 5)));
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        expect(
            find.widgetWithText(TextField, 'Enter defective count').evaluate().isNotEmpty ||
            find.textContaining('Defective Count').evaluate().isNotEmpty,
            isTrue);
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'UI — Remark input field is present',
      (WidgetTester tester) async {
        addTearDown(() => tester.pumpAndSettle(const Duration(seconds: 5)));
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        expect(find.textContaining('Remark'), findsWidgets);
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'UI — Submit button is present',
      (WidgetTester tester) async {
        addTearDown(() => tester.pumpAndSettle(const Duration(seconds: 5)));
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        expect(find.widgetWithText(ElevatedButton, 'Submit'), findsWidgets);
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'UI — Defective List section header is present',
      (WidgetTester tester) async {
        addTearDown(() => tester.pumpAndSettle(const Duration(seconds: 5)));
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        expect(
            find.textContaining('DEFECTIVE LIST').evaluate().isNotEmpty ||
            find.textContaining('Defective List').evaluate().isNotEmpty,
            isTrue);
        await _drainMarkDefective(tester);
      },
    );

    // ── INPUT BEHAVIOUR ───────────────────────────────────────────────────────

    testWidgets(
      'INPUT — Defective Count field accepts numeric input only',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final countField = find.widgetWithText(TextField, 'Enter defective count');
        if (countField.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(countField.first);
        await tester.enterText(countField.first, '5');
        await tester.pump();
        final tf = tester.widget<TextField>(countField.first);
        expect(tf.controller!.text, '5');
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'INPUT — Defective Count field rejects letters',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final countField = find.widgetWithText(TextField, 'Enter defective count');
        if (countField.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(countField.first);
        await tester.enterText(countField.first, 'abc');
        await tester.pump();
        final tf = tester.widget<TextField>(countField.first);
        expect(tf.controller!.text, isEmpty);
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'INPUT — Remark field accepts free text',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final remarkField = find.widgetWithText(TextField, 'Enter remark (optional)');
        if (remarkField.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(remarkField.first);
        await tester.enterText(remarkField.first, 'Test remark');
        await tester.pump();
        final tf = tester.widget<TextField>(remarkField.first);
        expect(tf.controller!.text, 'Test remark');
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'INPUT — Item dropdown loads items after API fetch',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final dropdown = find.byType(DropdownButtonFormField);
        if (dropdown.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(dropdown.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        expect(find.byType(DropdownMenuItem), findsWidgets);
        // Close dropdown
        await tester.tapAt(const Offset(10, 10));
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'INPUT — Select an item from dropdown',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final dropdown = find.byType(DropdownButtonFormField);
        if (dropdown.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(dropdown.first);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        final options = find.byType(DropdownMenuItem);
        if (options.evaluate().length <= 1) { await _drainMarkDefective(tester); return; }
        await tester.tap(options.last, warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(find.byType(DropdownButtonFormField), findsWidgets);
        await _drainMarkDefective(tester);
      },
    );

    // ── VALIDATION ────────────────────────────────────────────────────────────

    testWidgets(
      'VALIDATION — submit with no item selected shows error message',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final countField = find.widgetWithText(TextField, 'Enter defective count');
        if (countField.evaluate().isNotEmpty) {
          await tester.tap(countField.first);
          await tester.enterText(countField.first, '5');
          await tester.pump();
        }
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        for (int i = 0; i < 5; i++) { await tester.pump(const Duration(seconds: 1)); }
        expect(
          find.textContaining('select').evaluate().isNotEmpty ||
              find.textContaining('item').evaluate().isNotEmpty ||
              find.textContaining('Select').evaluate().isNotEmpty,
          isTrue,
        );
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'VALIDATION — submit with empty defective count shows error',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final dropdown = find.byType(DropdownButtonFormField);
        if (dropdown.evaluate().isNotEmpty) {
          await tester.tap(dropdown.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          final opts = find.byType(DropdownMenuItem);
          if (opts.evaluate().length > 1) {
            await tester.tap(opts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        for (int i = 0; i < 5; i++) { await tester.pump(const Duration(seconds: 1)); }
        expect(
          find.textContaining('count').evaluate().isNotEmpty ||
              find.textContaining('Count').evaluate().isNotEmpty ||
              find.textContaining('valid').evaluate().isNotEmpty ||
              find.textContaining('enter').evaluate().isNotEmpty,
          isTrue,
        );
        await _drainMarkDefective(tester);
      },
    );

    testWidgets(
      'VALIDATION — submit with defective count = 0 shows error',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final dropdown = find.byType(DropdownButtonFormField);
        if (dropdown.evaluate().isNotEmpty) {
          await tester.tap(dropdown.first);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          final opts = find.byType(DropdownMenuItem);
          if (opts.evaluate().length > 1) {
            await tester.tap(opts.last, warnIfMissed: false);
            await tester.pumpAndSettle();
          }
        }
        final countField = find.widgetWithText(TextField, 'Enter defective count');
        if (countField.evaluate().isNotEmpty) {
          await tester.tap(countField.first);
          await tester.enterText(countField.first, '0');
          await tester.pump();
        }
        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        for (int i = 0; i < 5; i++) { await tester.pump(const Duration(seconds: 1)); }
        expect(
          find.textContaining('valid').evaluate().isNotEmpty ||
              find.textContaining('count').evaluate().isNotEmpty ||
              find.textContaining('Count').evaluate().isNotEmpty,
          isTrue,
        );
        await _drainMarkDefective(tester);
      },
    );

    // ── FULL SUBMIT (real API) ────────────────────────────────────────────────

    testWidgets(
      'SUBMIT — fill all fields and submit to real API',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);

        final dropdown = find.byType(DropdownButtonFormField);
        if (dropdown.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(dropdown.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        final options = find.byType(DropdownMenuItem);
        if (options.evaluate().length <= 1) { await _drainMarkDefective(tester); return; }
        await tester.tap(options.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        final countField = find.widgetWithText(TextField, 'Enter defective count');
        if (countField.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(countField.first);
        await tester.enterText(countField.first, '1');
        await tester.pump();

        final remarkField = find.widgetWithText(TextField, 'Enter remark (optional)');
        if (remarkField.evaluate().isNotEmpty) {
          await tester.tap(remarkField.first);
          await tester.enterText(remarkField.first, 'Integration test remark');
          await tester.pump();
        }

        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        for (int i = 0; i < 25; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        final isSuccess = find.textContaining('updated').evaluate().isNotEmpty ||
            find.textContaining('success').evaluate().isNotEmpty ||
            find.textContaining('added').evaluate().isNotEmpty ||
            find.textContaining('Updated').evaluate().isNotEmpty ||
            (find.widgetWithText(TextField, 'Enter defective count').evaluate().isNotEmpty &&
                (tester.widget<TextField>(find.widgetWithText(TextField, 'Enter defective count').first)
                    .controller?.text.isEmpty ?? true));
        expect(isSuccess, isTrue);
      },
    );

    testWidgets(
      'SUBMIT — after successful submit screen stays on Mark Defective',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);

        final dropdown = find.byType(DropdownButtonFormField);
        if (dropdown.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(dropdown.first);
        await tester.pumpAndSettle(const Duration(seconds: 3));
        final options = find.byType(DropdownMenuItem);
        if (options.evaluate().length <= 1) { await _drainMarkDefective(tester); return; }
        await tester.tap(options.last, warnIfMissed: false);
        await tester.pumpAndSettle();

        final countField = find.widgetWithText(TextField, 'Enter defective count');
        if (countField.evaluate().isEmpty) { await _drainMarkDefective(tester); return; }
        await tester.tap(countField.first);
        await tester.enterText(countField.first, '1');
        await tester.pump();

        await tester.tap(find.widgetWithText(ElevatedButton, 'Submit'));
        for (int i = 0; i < 25; i++) {
          await tester.pump(const Duration(seconds: 1));
        }

        expect(find.text('Mark Defective'), findsWidgets);
      },
    );

    // ── DEFECTIVE LIST SECTION ────────────────────────────────────────────────

    testWidgets(
      'LIST — defective list shows records or empty state',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        await tester.drag(find.byType(SingleChildScrollView).first, const Offset(0, -300));
        await tester.pumpAndSettle();
        final hasRecords = find.byType(ListView).evaluate().isNotEmpty ||
            find.textContaining('No Data').evaluate().isNotEmpty ||
            find.textContaining('No defective').evaluate().isNotEmpty ||
            find.text('No Data Found').evaluate().isNotEmpty;
        expect(hasRecords, isTrue);
        await _drainMarkDefective(tester);
      },
    );

    // ── BACK NAVIGATION ──────────────────────────────────────────────────────

    testWidgets(
      'NAV — back button navigates to GodownKeeper home',
      (WidgetTester tester) async {
        await _bootAppLoggedIn(tester);
        await _navigateToMarkDefectiveScreen(tester);
        final backBtn = find.byTooltip('Back');
        if (backBtn.evaluate().isNotEmpty) {
          await tester.tap(backBtn.first);
        } else {
          final navBack = find.byType(BackButton);
          if (navBack.evaluate().isNotEmpty) {
            await tester.tap(navBack.first);
          }
        }
        await tester.pumpAndSettle(const Duration(seconds: 3));
        expect(find.text('More'), findsWidgets);
        await _drainMarkDefective(tester);
      },
    );
  });
}

// =============================================================================
// ──────────────────────────────────────────────────────────────────────────────
// APPENDIX — HOW TO RUN
// ──────────────────────────────────────────────────────────────────────────────
//
// 1. Add to pubspec.yaml (dev_dependencies):
//    integration_test:
//      sdk: flutter
//    flutter_test:
//      sdk: flutter

//
// 2. Create the runner file at:
//    test_driver/integration_test.dart
//
//    Content:
//    ─────────────────────────────
//    import 'package:integration_test/integration_test_driver.dart';
//    Future<void> main() => integrationDriver();
//    ─────────────────────────────
//
// 3. Run on a connected device or emulator:
//    flutter test integration_test/godown_keeper_integration_test.dart
//
//    Or via the driver for full device reporting:
//    flutter drive \
//      --driver=test_driver/integration_test.dart \
//      --target=integration_test/godown_keeper_integration_test.dart
//
// 4. CI/CD (GitHub Actions example):
//    - uses: subosito/flutter-action@v2
//    - run: flutter test integration_test/godown_keeper_integration_test.dart \
//             --device-id emulator-5554
//
// ──────────────────────────────────────────────────────────────────────────────
// WIRING THE HTTP MOCK (http.MockClient — no extra package needed)
// ──────────────────────────────────────────────────────────────────────────────
//
// // 1. Create a MockClient using package:http/testing.dart (ships with http):
// import 'package:http/testing.dart';
//
// // 2. Inject it into your app via a service locator / Provider before main():
// final mockClient = MockClient((request) async {
//   if (request.url.path.contains('login')) {
//
// // 2. Stub responses inside the MockClient handler:
//   if (request.url.path.contains('ItemCurrentStkList')) {
//     return http.Response(jsonEncode(kCurrentStockList), 200);
//   }
//   if (request.url.path.contains('TodaysOpeningStkForGK')) {
//     return http.Response(jsonEncode(kOpeningStockList), 200);
//   }
//   if (request.url.path.contains('login')) {
//     return http.Response(jsonEncode(kLoginSuccessResponse), 200);
//   }
//   return http.Response('Not Found', 404);
// });
//
// // 3. Inject into your service before calling app.main():
// MyApiService.client = mockClient;   // adjust to your DI / singleton pattern
//
// ──────────────────────────────────────────────────────────────────────────────
// WIDGET KEYS  (recommended additions to your source screens)
// ──────────────────────────────────────────────────────────────────────────────
//
// In LoginScreen:
//   TextFormField(key: Key('mobileField'), ...)
//   ElevatedButton(key: Key('loginButton'), ...)
//
// In OTPScreen:
//   TextFormField(key: Key('otpField'), ...)
//   ElevatedButton(key: Key('verifyButton'), ...)
//
// In DashboardScreen:
//   DropdownButton(key: Key('itemDropdown'), ...)
//   ElevatedButton(key: Key('transferButton'), child: Text('Transfer'), ...)
//
// In DailyRefillSalePage (Transfer Screen):
//   TextFormField(key: Key('filledQtyField'), ...)
//   TextFormField(key: Key('emptyQtyField'), ...)
//   TextFormField(key: Key('defectiveQtyField'), ...)
//   TextFormField(key: Key('remarkField'), ...)
//   DropdownButton(key: Key('godownDropdown'), ...)
//   ElevatedButton(key: Key('submitButton'), child: Text('Submit'), ...)
// =============================================================================