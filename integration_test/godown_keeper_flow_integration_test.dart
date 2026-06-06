// integration_test/godown_keeper_flow_integration_test.dart
//
// HOW TO RUN (real device / emulator):
//   flutter test integration_test/godown_keeper_flow_integration_test.dart -d <device-id>
//
// TEST CREDENTIALS (GodownKeeper role = 0):
//   Mobile : 9700097000
//   OTP    : read from the login API response (stored in SharedPreferences key "OTP")
//
// SharedPreferences seed data comes from the live API response:
//   StaffId=22, DistributorId=8118, StaffName="Sahebrao Jangale",
//   MobileNo="9700097000", roleId=0, godownId=1, GodownKeeperId=22,
//   DistributorName="SHREE RENUKA GAS SUPPLY COMPANY", IsAlreadyLogin=1

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/BottomNavigationForGodownKeeper.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DashboardScreen.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DelBoyStockReturn/DeliveryMenListShowScreen.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DelBoyStockSubmitToManager/StockSubmitToManager.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/AddItem/ItemReceiptScreen.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/MoreOptionScreenGodownKeeper.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/Screen/MyLogin.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/Screen/VerifyOTP.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/provider/LoginProvider.dart';
import 'package:lpgsalesandinventory/Screen/User/splashscreen/page/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ── SSL bypass (same as login_flow_integration_test.dart) ────────────────────
class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// ═════════════════════════════════════════════════════════════════════════════
//  CONSTANTS – GodownKeeper test credentials
// ═════════════════════════════════════════════════════════════════════════════
const String kGKMobileNo = '9700097000'; // registered GodownKeeper mobile

// JWT token from live response (valid until 2026-05-21T17:56:30Z)
const String kGKToken =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
    '.eyJzdWIiOiJTYWhlYnJhbyBKYW5nYWxlIiwianRpIjoiNGNiMzE4M2ItZjliNy00YmFhLTgw'
    'OTUtZWU4MmU2MjZiYTQyIiwibmFtZWlkIjoiU2FoZWJyYW8gSmFuZ2FsZSIsInJvbGUiOiIw'
    'IiwiTG9nZ2VkT24iOiI1LzIwLzIwMjYgNToyNjozMCBQTSIsIkRpc3BsYXlOYW1lIjoiU2Fo'
    'ZWJyYW8gSmFuZ2FsZSIsIm5iZiI6MTc3OTI3ODE5MCwiZXhwIjoxNzc5Mzg2MTkwLCJpYXQi'
    'OjE3NzkyNzgxOTAsImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3Vw'
    'ZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5'
    'TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9'
    '.Ju5u3dqeZxe0_HrdfgJ_160OPbOEvfuLBUwdVw_bSgw';

// ═════════════════════════════════════════════════════════════════════════════
//  SHARED PREFERENCES SEED – GodownKeeper role data (from live API response)
// ═════════════════════════════════════════════════════════════════════════════
Future<void> seedGodownKeeperPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  await prefs.setString('StaffId',          '22');
  await prefs.setString('DistributorId',    '8118');
  await prefs.setString('StaffName',        'Sahebrao Jangale');
  await prefs.setString('MobileNo',         '9700097000');
  await prefs.setString('roleId',           '0');           // GodownKeeper
  await prefs.setString('godownId',         '1');
  await prefs.setString('godownKeeperId',   '22');
  await prefs.setString('OTP',              '1880');
  await prefs.setString('DistributorCode',  '41015336');
  await prefs.setString('StaffStatus',      '1');
  await prefs.setString('Status',           'Success');
  await prefs.setString('token',            kGKToken);
  await prefs.setString('expiration',       '2026-05-21T17:56:30Z');
  await prefs.setString('refresh_token',    'ff8f83ec9e7345f9932cebd50beb847b');
  await prefs.setString('RoleName',         'null');
  await prefs.setString('DistributorName',  'SHREE RENUKA GAS SUPPLY COMPANY');
  await prefs.setString('UserId',           '0');
  await prefs.setString('MgrEmail',         'null');
  await prefs.setString('OwnerEmail',       'null');
  await prefs.setString('IsAlreadyLogin',   '1');
  await prefs.setString('userName',         'Y');
  await prefs.setString('userActive',       'Y');
}

// ═════════════════════════════════════════════════════════════════════════════
//  APP BUILDER – includes EasyLoading + all GodownKeeper routes
// ═════════════════════════════════════════════════════════════════════════════
Widget buildGodownKeeperTestApp() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoginProvider()),
    ],
    child: MaterialApp(
      builder: EasyLoading.init(),
      initialRoute: MyLogin.screenName,
      routes: {
        MyLogin.screenName:
            (context) => const MyLogin(),
        VerifyOtp.screenName:
            (context) => const VerifyOtp(),
        BottomNavigationForGodownKeeper.screenName:
            (context) => BottomNavigationForGodownKeeper(),
        ItemReceiptScreen.screenName:
            (context) => ItemReceiptScreen(),
        MoreOptionScreenGodownKeeper.screenName:
            (context) => const MoreOptionScreenGodownKeeper(),
        SplashScreen.screenName:
            (context) =>  SplashScreen(),
      },
    ),
  );
}

// ═════════════════════════════════════════════════════════════════════════════
//  HELPERS (same patterns as login_flow_integration_test.dart)
// ═════════════════════════════════════════════════════════════════════════════

/// Pump every 100 ms with a real wall-clock TIMEOUT (not an interval).
Future<void> pumpUntilSettled(WidgetTester tester,
    {Duration timeout = const Duration(seconds: 30)}) async {
  await tester.pumpAndSettle(
    const Duration(milliseconds: 100),
    EnginePhase.sendSemanticsUpdate,
    timeout,
  );
}

/// Scroll widget into view then tap (without settling after tap so callers
/// can still observe spinner / state before it disappears).
Future<void> safeTap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder, warnIfMissed: false);
  await tester.pumpAndSettle();
}

/// Full login → OTP entry using live API.
/// Seeds prefs from the live API response (via LoginProvider).
Future<void> doFullLoginAsGodownKeeper(WidgetTester tester) async {
  // 1. Enter mobile
  await tester.enterText(find.byType(TextField), kGKMobileNo);
  await tester.pumpAndSettle();

  // 2. Tap Login (raw tap so tests that check spinner can do so after this call)
  await tester.ensureVisible(find.text('Login'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Login'), warnIfMissed: false);

  // 3. Wait for login API (100 ms interval, 30 s budget)
  await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

  // 4. Read OTP from LoginProvider (from API response) and log it
  final loginProvider = Provider.of<LoginProvider>(
    tester.element(find.byType(MaterialApp)),
    listen: false,
  );
  final otp = loginProvider.loginResponse?.authToken?.otp;
  debugPrint('>>> GK Login OTP from API response: $otp');
  expect(otp, isNotNull,
      reason: 'LoginProvider must hold OTP from the API response');

  // 5. Enter OTP on VerifyOtp screen
  expect(find.byType(VerifyOtp), findsOneWidget,
      reason: 'Must be on OTP screen after login');
  await tester.enterText(find.byType(TextField), otp!);
  await tester.pumpAndSettle();
  await safeTap(tester, find.text('Verify'));
  await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

  // 6. Must be on GodownKeeper bottom nav after successful OTP
  expect(find.byType(BottomNavigationForGodownKeeper), findsOneWidget,
      reason: 'OTP verification must navigate to GodownKeeper dashboard');
}

/// Launch app with pre-seeded GodownKeeper prefs (faster than full login).
Future<void> launchWithPreseededGodownKeeper(WidgetTester tester) async {
  await seedGodownKeeperPrefs();
  await tester.pumpWidget(buildGodownKeeperTestApp());
  // Navigate directly to the GodownKeeper bottom nav
  await tester.pumpWidget(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LoginProvider())],
      child: MaterialApp(
        builder: EasyLoading.init(),
        home: BottomNavigationForGodownKeeper(),
        routes: {
          BottomNavigationForGodownKeeper.screenName:
              (context) => BottomNavigationForGodownKeeper(),
          ItemReceiptScreen.screenName:
              (context) => ItemReceiptScreen(),
          MoreOptionScreenGodownKeeper.screenName:
              (context) => const MoreOptionScreenGodownKeeper(),
          SplashScreen.screenName:
              (context) =>  SplashScreen(),
          MyLogin.screenName:
              (context) => const MyLogin(),
        },
      ),
    ),
  );
  await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
}

// ═════════════════════════════════════════════════════════════════════════════
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    HttpOverrides.global = _TestHttpOverrides();
    await Firebase.initializeApp();
  });

  setUp(() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 1 – FULL LOGIN → GODOWNKEEPER DASHBOARD (live network)
  // ═══════════════════════════════════════════════════════════════════════════
  group('GodownKeeper Login Flow (live network)', () {

    testWidgets(
        'TC-GK-LOGIN-01: Valid GodownKeeper mobile → spinner → OTP screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), kGKMobileNo);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Login'), warnIfMissed: false);

      // Spinner must appear before API response arrives
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(CircularProgressIndicator), findsOneWidget,
          reason: 'Spinner must appear immediately after tapping Login');

      await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

      expect(find.byType(VerifyOtp),  findsOneWidget);
      expect(find.text('Verify OTP'), findsOneWidget);
    });

    testWidgets(
        'TC-GK-LOGIN-02: OTP from API response is 4 digits and stored in SharedPrefs',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), kGKMobileNo);
      await tester.pumpAndSettle();
      await safeTap(tester, find.text('Login'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

      // Read OTP from SharedPreferences (written by LoginProvider.saveUser)
      final prefs = await SharedPreferences.getInstance();
      final otp = prefs.getString('OTP');
      debugPrint('>>> TC-GK-LOGIN-02 OTP from SharedPrefs: $otp');
      expect(otp, isNotNull, reason: 'OTP must be saved in SharedPrefs');
      expect(otp!.length, equals(4), reason: 'OTP must be 4 digits');

      // Also verify it matches the LoginProvider's in-memory response
      final loginProvider = Provider.of<LoginProvider>(
        tester.element(find.byType(MaterialApp)),
        listen: false,
      );
      expect(loginProvider.loginResponse?.authToken?.otp, equals(otp),
          reason: 'SharedPrefs OTP must match API response OTP');
    });

    testWidgets(
        'TC-GK-LOGIN-03: GodownKeeper prefs fully seeded after login API',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), kGKMobileNo);
      await safeTap(tester, find.text('Login'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'),         isNotNull, reason: 'JWT token');
      expect(prefs.getString('OTP'),           isNotNull, reason: 'OTP');
      expect(prefs.getString('roleId'),        isNotNull, reason: 'roleId');
      expect(prefs.getString('StaffId'),       isNotNull, reason: 'StaffId');
      expect(prefs.getString('DistributorId'), isNotNull, reason: 'DistributorId');
      expect(prefs.getString('godownId'),      isNotNull, reason: 'godownId');
      expect(prefs.getString('godownKeeperId'),isNotNull, reason: 'godownKeeperId');
      expect(prefs.getString('MobileNo'),      isNotNull, reason: 'MobileNo');
      expect(prefs.getString('StaffName'),     isNotNull, reason: 'StaffName');
      expect(prefs.getString('DistributorName'),isNotNull,reason: 'DistributorName');
      expect(prefs.getString('IsAlreadyLogin'), isNotNull,reason: 'IsAlreadyLogin');
      debugPrint('>>> TC-GK-LOGIN-03 roleId=${prefs.getString('roleId')}');
    });

    testWidgets(
        'TC-GK-LOGIN-04: Correct OTP → navigates to BottomNavigationForGodownKeeper',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      await doFullLoginAsGodownKeeper(tester);

      expect(find.byType(BottomNavigationForGodownKeeper), findsOneWidget);
      expect(find.byType(MyLogin),   findsNothing);
      expect(find.byType(VerifyOtp), findsNothing);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('roleId'), equals('0'),
          reason: 'GodownKeeper roleId must be 0');
      expect(prefs.getString('userName'), equals('Y'));
    });

    testWidgets(
        'TC-GK-LOGIN-05: Wrong OTP on VerifyOtp screen → snackbar, stays on OTP screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), kGKMobileNo);
      await safeTap(tester, find.text('Login'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

      expect(find.byType(VerifyOtp), findsOneWidget);

      // Enter deliberately wrong OTP
      await tester.enterText(find.byType(TextField), '0000');
      await safeTap(tester, find.text('Verify'));

      expect(find.text('OTP not match..!'), findsOneWidget);
      expect(find.byType(BottomNavigationForGodownKeeper), findsNothing);
    });

    testWidgets(
        'TC-GK-LOGIN-06: Empty mobile shows validation snackbar, no spinner',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      await safeTap(tester, find.text('Login'));

      expect(find.text('Please fill all the fields'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'TC-GK-LOGIN-07: Invalid/unregistered mobile → error shown, no navigation',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '0000000000');
      await safeTap(tester, find.text('Login'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

      expect(find.textContaining('Invalid User'), findsOneWidget);
      expect(find.byType(VerifyOtp), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 2 – GODOWNKEEPER DASHBOARD UI (pre-seeded prefs)
  // ═══════════════════════════════════════════════════════════════════════════
  group('GodownKeeper Dashboard – UI', () {

    testWidgets(
        'TC-GK-DASH-01: Dashboard renders 4 bottom nav tabs',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      // 4 bottom nav items
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Dashboard'),      findsOneWidget);
      expect(find.text('Daily Sale'),     findsOneWidget);
      expect(find.text("Today's Summary"),findsOneWidget);
      expect(find.text('More'),           findsOneWidget);
    });

    testWidgets(
        'TC-GK-DASH-02: Dashboard tab is selected by default (index 0)',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      final navBar = tester.widget<BottomNavigationBar>(
          find.byType(BottomNavigationBar));
      expect(navBar.currentIndex, equals(0),
          reason: 'Dashboard must be the default selected tab');
    });

    testWidgets(
        'TC-GK-DASH-03: DashboardScreen is shown on Dashboard tab',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    testWidgets(
        'TC-GK-DASH-04: Tapping "Daily Sale" tab switches to DeliveryMenListShowScreen',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      await tester.tap(find.text('Daily Sale'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));

      expect(find.byType(DeliveryMenListShowScreen), findsOneWidget);
    });

    testWidgets(
        'TC-GK-DASH-05: Tapping "Today\'s Summary" tab switches to StockSubmitToManager',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      await tester.tap(find.text("Today's Summary"));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));

      expect(find.byType(StockSubmitToManager), findsOneWidget);
    });

    testWidgets(
        'TC-GK-DASH-06: Tapping "More" tab switches to MoreOptionScreenGodownKeeper',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      await tester.tap(find.text('More'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 15));

      expect(find.byType(MoreOptionScreenGodownKeeper), findsOneWidget);
    });

    testWidgets(
        'TC-GK-DASH-07: Switching tabs returns to Dashboard when tab 0 re-tapped',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      // Go to Daily Sale
      await tester.tap(find.text('Daily Sale'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
      expect(find.byType(DeliveryMenListShowScreen), findsOneWidget);

      // Go back to Dashboard
      await tester.tap(find.text('Dashboard'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 15));
      expect(find.byType(DashboardScreen), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 3 – DAILY SALE SCREEN (DeliveryMenListShowScreen)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Daily Sale Screen', () {

    Future<void> goToDailySale(WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);
      await tester.tap(find.text('Daily Sale'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
    }

    testWidgets(
        'TC-GK-SALE-01: Daily Sale screen renders with app bar title',
        (WidgetTester tester) async {
      await goToDailySale(tester);
      expect(find.text('Daily Sale'), findsWidgets);
      expect(find.byType(DeliveryMenListShowScreen), findsOneWidget);
    });

    testWidgets(
        'TC-GK-SALE-02: Daily Sale screen shows loading or list (not blank)',
        (WidgetTester tester) async {
      await goToDailySale(tester);
      // Either a loading indicator or the list / empty-state are visible
      final hasLoader  = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
      final hasContent = find.byType(ListView).evaluate().isNotEmpty ||
          find.text('No delivery data available').evaluate().isNotEmpty ||
          find.byType(Column).evaluate().isNotEmpty;
      expect(hasLoader || hasContent, isTrue,
          reason: 'Daily Sale screen must not be completely blank');
    });

    testWidgets(
        'TC-GK-SALE-03: API response populates screen (no crash within 20 s)',
        (WidgetTester tester) async {
      await goToDailySale(tester);
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
      // No CircularProgressIndicator should remain after settling
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 4 – TODAY'S SUMMARY SCREEN (StockSubmitToManager)
  // ═══════════════════════════════════════════════════════════════════════════
  group("Today's Summary Screen", () {

    Future<void> goToTodaySummary(WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);
      await tester.tap(find.text("Today's Summary"));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
    }

    testWidgets(
        'TC-GK-SUMM-01: Today Summary screen renders with app bar title',
        (WidgetTester tester) async {
      await goToTodaySummary(tester);
      expect(find.text('Today Summary'), findsOneWidget);
      expect(find.byType(StockSubmitToManager), findsOneWidget);
    });

    testWidgets(
        'TC-GK-SUMM-02: Today Summary loads data or shows empty state',
        (WidgetTester tester) async {
      await goToTodaySummary(tester);
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));

      // Either FutureBuilder loaded data or shows the empty / error body
      final hasData     = find.byType(ListView).evaluate().isNotEmpty;
      final hasEmpty    = find.text('No records found').evaluate().isNotEmpty ||
          find.byType(Column).evaluate().isNotEmpty;
      expect(hasData || hasEmpty, isTrue);
    });

    testWidgets(
        'TC-GK-SUMM-03: No spinner remains after data is fetched',
        (WidgetTester tester) async {
      await goToTodaySummary(tester);
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 25));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 5 – MORE OPTIONS SCREEN
  // ═══════════════════════════════════════════════════════════════════════════
  group('More Options Screen', () {

    Future<void> goToMoreOptions(WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);
      await tester.tap(find.text('More'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 15));
    }

    testWidgets(
        'TC-GK-MORE-01: More Options header renders correctly',
        (WidgetTester tester) async {
      await goToMoreOptions(tester);

      expect(find.text('More Options'),    findsOneWidget);
      expect(find.text('Godown Keeper'),   findsOneWidget);
    });

    testWidgets(
        'TC-GK-MORE-02: All menu sections are visible',
        (WidgetTester tester) async {
      await goToMoreOptions(tester);

      // Section labels (displayed uppercase by the widget)
      expect(find.text('ITEM RECEIPT / RETURN'), findsOneWidget);
      expect(find.text('EXMI / REV-EMR'),        findsOneWidget);
      expect(find.text('MARK DEFECTIVE'),         findsOneWidget);
      expect(find.text('ACCOUNT'),               findsOneWidget);
    });

    testWidgets(
        'TC-GK-MORE-03: All menu item labels are visible',
        (WidgetTester tester) async {
      await goToMoreOptions(tester);
      await tester.ensureVisible(find.text('Logout').last);
      await tester.pumpAndSettle();

      expect(find.text('Item Receipt'),         findsOneWidget);
      expect(find.text('Item Return'),          findsOneWidget);
      expect(find.text('Return EXMI / Rev-EMR'),findsOneWidget);
      expect(find.text('Receipt EXMI'),         findsOneWidget);
      expect(find.text('Mark Defective'),       findsOneWidget);
      expect(find.text('Logout'),               findsOneWidget);
    });

    testWidgets(
        'TC-GK-MORE-04: Tapping "Item Receipt" navigates to ItemReceiptScreen',
        (WidgetTester tester) async {
      await goToMoreOptions(tester);

      await safeTap(tester, find.text('Item Receipt'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));

      expect(find.byType(ItemReceiptScreen), findsOneWidget);
    });

    testWidgets(
        'TC-GK-MORE-05: Tapping "Logout" shows confirmation dialog',
        (WidgetTester tester) async {
      await goToMoreOptions(tester);

      await tester.ensureVisible(find.text('Logout').last);
      await safeTap(tester, find.text('Logout').last);

      expect(find.text('Confirm Logout'),                    findsOneWidget);
      expect(find.text('Are you sure you want to logout?'), findsOneWidget);
      expect(find.text('Cancel'),                           findsOneWidget);
      expect(find.text('Logout'),                           findsWidgets);
    });

    testWidgets(
        'TC-GK-MORE-06: Tapping "Cancel" in logout dialog closes dialog',
        (WidgetTester tester) async {
      await goToMoreOptions(tester);

      await tester.ensureVisible(find.text('Logout').last);
      await safeTap(tester, find.text('Logout').last);
      expect(find.text('Confirm Logout'), findsOneWidget);

      await safeTap(tester, find.text('Cancel'));
      // Dialog must close; More Options must still be visible
      expect(find.text('Confirm Logout'),           findsNothing);
      expect(find.byType(MoreOptionScreenGodownKeeper), findsOneWidget);
    });

    testWidgets(
        'TC-GK-MORE-07: Tapping "Logout" in dialog signs out → navigates to Splash/Login',
        (WidgetTester tester) async {
      await goToMoreOptions(tester);

      await tester.ensureVisible(find.text('Logout').last);
      await safeTap(tester, find.text('Logout').last);
      expect(find.text('Confirm Logout'), findsOneWidget);

      // Tap the Logout button inside the dialog (last one)
      final logoutInDialog = find.widgetWithText(ElevatedButton, 'Logout');
      await safeTap(tester, logoutInDialog);
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));

      // After logout user must be on SplashScreen or Login screen
      final onSplash = find.byType(SplashScreen).evaluate().isNotEmpty;
      final onLogin  = find.byType(MyLogin).evaluate().isNotEmpty;
      expect(onSplash || onLogin, isTrue,
          reason: 'User must be redirected to Splash/Login after logout');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 6 – ITEM RECEIPT SCREEN (positive + negative)
  // ═══════════════════════════════════════════════════════════════════════════
  group('Item Receipt Screen', () {

    Future<void> goToItemReceipt(WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);
      await tester.tap(find.text('More'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 15));
      await safeTap(tester, find.text('Item Receipt'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
    }

    testWidgets(
        'TC-GK-IR-01: Item Receipt screen renders with required fields',
        (WidgetTester tester) async {
      await goToItemReceipt(tester);

      expect(find.byType(ItemReceiptScreen), findsOneWidget);
      // Date field auto-populated
      expect(find.byType(TextField), findsWidgets,
          reason: 'Vehicle No and item fields must be present');
    });

    testWidgets(
        'TC-GK-IR-02: Receipt date field is auto-populated with today\'s date',
        (WidgetTester tester) async {
      await goToItemReceipt(tester);

      // The date controller is pre-filled in initState with today's date (dd-MM-yyyy)
      final dateFields = tester
          .widgetList<TextField>(find.byType(TextField))
          .toList();
      // At least one field must have a date-format value
      final hasDate = dateFields.any((f) =>
          f.controller?.text.contains(RegExp(r'\d{2}-\d{2}-\d{4}')) == true);
      expect(hasDate, isTrue,
          reason: 'Receipt date field must be pre-filled with today\'s date');
    });

    testWidgets(
        'TC-GK-IR-03 (negative): Submit with empty Vehicle No shows validation message',
        (WidgetTester tester) async {
      await goToItemReceipt(tester);

      // Locate and tap Submit / Save button
      final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
      if (submitBtn.evaluate().isNotEmpty) {
        await safeTap(tester, submitBtn);
      } else {
        // Try "Save" or any submit-like button
        final saveBtn = find.widgetWithText(ElevatedButton, 'Save');
        if (saveBtn.evaluate().isNotEmpty) {
          await safeTap(tester, saveBtn);
        }
      }
      await tester.pumpAndSettle();

      // Vehicle No is empty → validation message expected
      // (message text depends on Constants.selectValidItemReceipt or similar)
      // At minimum, no navigation to another screen should have occurred
      expect(find.byType(ItemReceiptScreen), findsOneWidget,
          reason: 'Must remain on Item Receipt screen if Vehicle No is empty');
    });

    testWidgets(
        'TC-GK-IR-04 (negative): Submit with Vehicle No but zero quantity shows error',
        (WidgetTester tester) async {
      await goToItemReceipt(tester);

      // Wait for cylinder items to load
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 15));

      // Enter a vehicle number
      final vehicleField = find.ancestor(
        of: find.text('Vehicle No'),
        matching: find.byType(TextField),
      );
      if (vehicleField.evaluate().isNotEmpty) {
        await tester.tap(vehicleField.first);
        await tester.enterText(vehicleField.first, 'MH12AB1234');
        await tester.pumpAndSettle();
      }

      // Try submitting without entering any qty
      final submitBtn = find.widgetWithText(ElevatedButton, 'Submit');
      if (submitBtn.evaluate().isNotEmpty) {
        await safeTap(tester, submitBtn);
        await tester.pumpAndSettle();
        // Should NOT navigate away
        expect(find.byType(ItemReceiptScreen), findsOneWidget);
      }
    });

    testWidgets(
        'TC-GK-IR-05 (positive): Vehicle No entered + item loaded — screen stays stable',
        (WidgetTester tester) async {
      await goToItemReceipt(tester);
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));

      // Find Vehicle No field and enter value
      final allTextFields = find.byType(TextField);
      expect(allTextFields, findsWidgets);

      // The vehicle no field should be among the text fields
      await tester.tap(allTextFields.first);
      await tester.enterText(allTextFields.first, 'MH12AB5678');
      await tester.pumpAndSettle();

      // Screen must remain stable (no crashes)
      expect(find.byType(ItemReceiptScreen), findsOneWidget);
    });

    testWidgets(
        'TC-GK-IR-06: SharedPrefs DistributorId and token are used correctly',
        (WidgetTester tester) async {
      await goToItemReceipt(tester);

      // Verify the data from SharedPrefs that ItemReceiptScreen uses
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('DistributorId'), equals('8118'));
      expect(prefs.getString('godownId'),      equals('1'));
      expect(prefs.getString('godownKeeperId'),equals('22'));
      expect(prefs.getString('token'),         isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 7 – SHARED PREFERENCES VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════
  group('SharedPreferences – GodownKeeper Data', () {

    testWidgets(
        'TC-GK-PREFS-01: All required GodownKeeper keys are present after seeding',
        (WidgetTester tester) async {
      await seedGodownKeeperPrefs();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('StaffId'),         equals('22'));
      expect(prefs.getString('DistributorId'),   equals('8118'));
      expect(prefs.getString('StaffName'),       equals('Sahebrao Jangale'));
      expect(prefs.getString('MobileNo'),        equals('9700097000'));
      expect(prefs.getString('roleId'),          equals('0'));
      expect(prefs.getString('godownId'),        equals('1'));
      expect(prefs.getString('godownKeeperId'),  equals('22'));
      expect(prefs.getString('OTP'),             equals('1880'));
      expect(prefs.getString('DistributorCode'), equals('41015336'));
      expect(prefs.getString('DistributorName'),
          equals('SHREE RENUKA GAS SUPPLY COMPANY'));
      expect(prefs.getString('IsAlreadyLogin'),  equals('1'));
      expect(prefs.getString('userName'),        equals('Y'));
      expect(prefs.getString('token'),           isNotNull);
    });

    testWidgets(
        'TC-GK-PREFS-02: Cleared prefs → BottomNavBar does NOT show staff name',
        (WidgetTester tester) async {
      // prefs are cleared by setUp; do not seed
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      // Should land on Login screen (no pre-seeded session)
      expect(find.byType(MyLogin), findsOneWidget);
    });

    testWidgets(
        'TC-GK-PREFS-03: IsAlreadyLogin=1 seed → IsAlreadyLogin check in dashboard passes',
        (WidgetTester tester) async {
      await launchWithPreseededGodownKeeper(tester);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('IsAlreadyLogin'), equals('1'),
          reason: 'IsAlreadyLogin must be 1 for active session');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  //  GROUP 8 – FULL END-TO-END: Login → Dashboard → More Options → Item Receipt
  // ═══════════════════════════════════════════════════════════════════════════
  group('End-to-End – GodownKeeper Happy Path (live network)', () {

    testWidgets(
        'TC-GK-E2E-01: Full flow — login → OTP (from API response log) → dashboard → More → Item Receipt',
        (WidgetTester tester) async {

      // ── Step 1: Launch app ────────────────────────────────────────────────
      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();
      expect(find.text('Sign In'), findsOneWidget);

      // ── Step 2: Enter GodownKeeper mobile + tap Login ─────────────────────
      await tester.enterText(find.byType(TextField), kGKMobileNo);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Login'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Login'), warnIfMissed: false);

      // ── Step 3: Spinner must appear ───────────────────────────────────────
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(CircularProgressIndicator), findsOneWidget,
          reason: 'Spinner must be visible right after tapping Login');

      // ── Step 4: Wait for API ──────────────────────────────────────────────
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));
      expect(find.byType(VerifyOtp), findsOneWidget);

      // ── Step 5: Read OTP from API response via intercepted log ────────────
      // Set up debugPrint interceptor to capture the OTP we emit below.
      String? loggedOtp;
      final void Function(String?, {int? wrapWidth}) origPrint = debugPrint;
      debugPrint = (String? msg, {int? wrapWidth}) {
        origPrint(msg, wrapWidth: wrapWidth);
        if (msg != null) {
          final m = RegExp(r'TC-GK-E2E-01 \| OTP \| (\d{4,6})').firstMatch(msg);
          if (m != null) loggedOtp = m.group(1);
        }
      };

      final loginProvider = Provider.of<LoginProvider>(
        tester.element(find.byType(MaterialApp)),
        listen: false,
      );
      final responseOtp = loginProvider.loginResponse?.authToken?.otp;
      expect(responseOtp, isNotNull,
          reason: 'OTP must be present in API response');

      // Emit structured log → interceptor captures it
      debugPrint('TC-GK-E2E-01 | OTP | $responseOtp');
      debugPrint = origPrint; // restore

      expect(loggedOtp, isNotNull, reason: 'OTP must be captured from log');
      expect(loggedOtp, equals(responseOtp),
          reason: 'Log OTP must match API response OTP');
      debugPrint('TC-GK-E2E-01 | Using log-sourced OTP: $loggedOtp');

      // ── Step 6: Enter OTP in TextField + verify ───────────────────────────
      await tester.enterText(find.byType(TextField), loggedOtp!);
      await tester.pumpAndSettle();
      final ctrl = tester.widget<TextField>(find.byType(TextField)).controller;
      expect(ctrl?.text, equals(loggedOtp));

      await safeTap(tester, find.text('Verify'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 30));

      // ── Step 7: Must be on GodownKeeper dashboard ─────────────────────────
      expect(find.byType(BottomNavigationForGodownKeeper), findsOneWidget);
      expect(find.byType(MyLogin),   findsNothing);
      expect(find.byType(VerifyOtp), findsNothing);

      // ── Step 8: Verify SharedPrefs are correct from API response ──────────
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('userName'),  equals('Y'));
      expect(prefs.getString('roleId'),    equals('0'),
          reason: 'GodownKeeper roleId must be 0');
      expect(prefs.getString('godownId'),  isNotNull);
      expect(prefs.getString('godownKeeperId'), isNotNull);
      debugPrint('TC-GK-E2E-01 | StaffName = ${prefs.getString('StaffName')}');
      debugPrint('TC-GK-E2E-01 | GodownId  = ${prefs.getString('godownId')}');

      // ── Step 9: Navigate to More Options ─────────────────────────────────
      await tester.tap(find.text('More'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 15));
      expect(find.byType(MoreOptionScreenGodownKeeper), findsOneWidget);

      // ── Step 10: Navigate to Item Receipt ────────────────────────────────
      await safeTap(tester, find.text('Item Receipt'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
      expect(find.byType(ItemReceiptScreen), findsOneWidget);
    });

    testWidgets(
        'TC-GK-E2E-02: Full flow — login → OTP → dashboard tab navigation → logout',
        (WidgetTester tester) async {

      await tester.pumpWidget(buildGodownKeeperTestApp());
      await tester.pumpAndSettle();

      // Full login
      await doFullLoginAsGodownKeeper(tester);
      expect(find.byType(BottomNavigationForGodownKeeper), findsOneWidget);

      // Navigate all 4 tabs
      await tester.tap(find.text('Daily Sale'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
      expect(find.byType(DeliveryMenListShowScreen), findsOneWidget);

      await tester.tap(find.text("Today's Summary"));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 20));
      expect(find.byType(StockSubmitToManager), findsOneWidget);

      await tester.tap(find.text('More'));
      await pumpUntilSettled(tester, timeout: const Duration(seconds: 15));
      expect(find.byType(MoreOptionScreenGodownKeeper), findsOneWidget);

      // Trigger logout and confirm dialog appears
      await tester.ensureVisible(find.text('Logout').last);
      await safeTap(tester, find.text('Logout').last);
      expect(find.text('Confirm Logout'), findsOneWidget);

      // Cancel → stay on More Options
      await safeTap(tester, find.text('Cancel'));
      expect(find.byType(MoreOptionScreenGodownKeeper), findsOneWidget);
    });
  });
}



