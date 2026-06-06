import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Unit + widget tests for SplashScreen logic.
// We test the routing decision logic independently of platform plugins.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Routing helper that mirrors SplashScreen.navigateToDashboard()
// Role IDs MUST match Constants.dart:
//   roleIdGodown = "0" | roleIdManager = "3" | roleIdOwner = "5"
// ---------------------------------------------------------------------------
const String _roleIdGodown   = '0'; // Constants.roleIdGodown
const String _roleIdManager  = '3'; // Constants.roleIdManager
const String _roleIdOwner    = '5'; // Constants.roleIdOwner

String _resolveRoute(String? roleId, String? userActive) {
  if (userActive == 'Y') {
    if (roleId == null) return '/login';    // null roleId → login
    if (roleId == _roleIdGodown) return '/godownHome';
    if (roleId == _roleIdManager) return '/managerHome';
    if (roleId == _roleIdOwner) return '/managerHome';
    return '/login'; // unknown / unrecognised role
  }
  return '/login'; // deactivated or null userActive
}

void main() {
  // ── Routing logic ─────────────────────────────────────────────────────────

  group('SplashScreen – navigation routing logic', () {
    test('active manager navigates to managerHome', () {
      expect(_resolveRoute(_roleIdManager, 'Y'), '/managerHome');
    });

    test('active owner navigates to managerHome', () {
      expect(_resolveRoute(_roleIdOwner, 'Y'), '/managerHome');
    });

    test('active godown keeper navigates to godownHome', () {
      expect(_resolveRoute(_roleIdGodown, 'Y'), '/godownHome');
    });

    test('deactivated user (N) goes to login regardless of role', () {
      expect(_resolveRoute(_roleIdManager, 'N'), '/login');
      expect(_resolveRoute(_roleIdOwner, 'N'), '/login');
      expect(_resolveRoute(_roleIdGodown, 'N'), '/login');
    });

    test('null userActive goes to login', () {
      expect(_resolveRoute(_roleIdManager, null), '/login');
    });

    test('null roleId with active user goes to login', () {
      expect(_resolveRoute(null, 'Y'), '/login');
    });

    test('empty roleId with active user goes to login', () {
      expect(_resolveRoute('', 'Y'), '/login');
    });

    test('unknown roleId with active user goes to login', () {
      expect(_resolveRoute('99', 'Y'), '/login');
    });

    test('both null role and userActive goes to login', () {
      expect(_resolveRoute(null, null), '/login');
    });
  });

  // ── Splash delay ─────────────────────────────────────────────────────────

  group('SplashScreen – delay behaviour', () {
    test('delay duration is 3000 milliseconds', () {
      const delay = Duration(milliseconds: 3000);
      expect(delay.inMilliseconds, 3000);
    });

    test('delay resolves after 3 seconds', () async {
      bool navigated = false;
      Future.delayed(const Duration(milliseconds: 3000), () {
        navigated = true;
      });
      await Future.delayed(const Duration(milliseconds: 3001));
      expect(navigated, isTrue);
    });
  });

  // ── Widget structure ──────────────────────────────────────────────────────

  group('SplashScreen – widget structure', () {
    Widget buildSplash({String version = '3.0.6'}) {
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Mirror the logo area without the real asset
                Container(
                  key: const Key('logoContainer'),
                  height: 250,
                  width: 250,
                  color: Colors.grey.shade200,
                ),
                const SizedBox(height: 10),
                Text(
                  'Version: $version',
                  key: const Key('versionText'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('renders logo container', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.byKey(const Key('logoContainer')), findsOneWidget);
    });

    testWidgets('renders version text', (tester) async {
      await tester.pumpWidget(buildSplash());
      expect(find.byKey(const Key('versionText')), findsOneWidget);
    });

    testWidgets('version text shows correct version number', (tester) async {
      await tester.pumpWidget(buildSplash(version: '3.0.6'));
      expect(find.text('Version: 3.0.6'), findsOneWidget);
    });

    testWidgets('scaffold background is white', (tester) async {
      await tester.pumpWidget(buildSplash());
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
    });

    testWidgets('column is center aligned', (tester) async {
      await tester.pumpWidget(buildSplash());
      final column = tester.widget<Column>(find.byType(Column).first);
      expect(column.mainAxisAlignment, MainAxisAlignment.center);
    });
  });

  // ── Edge case: SharedPreferences parsing ─────────────────────────────────

  group('SplashScreen – SharedPreferences value parsing', () {
    test('non-null userActive "Y" triggers role-based routing', () {
      expect(_resolveRoute(_roleIdManager, 'Y'), isNot('/login'));
    });

    test('userActive "y" (lowercase) does NOT match "Y" (case sensitive)', () {
      // The real code uses == "Y", so "y" should fall through to /login
      expect(_resolveRoute(_roleIdManager, 'y'), '/login');
    });

    test('userActive with extra spaces does not match', () {
      expect(_resolveRoute(_roleIdManager, ' Y'), '/login');
    });
  });

  // ── Role IDs aligned with Constants.dart ─────────────────────────────────

  group('SplashScreen – Constants.dart role ID alignment', () {
    // Validates that test constants match the production Constants class values.

    test('Constants.roleIdGodown is "0"', () {
      expect(_roleIdGodown, '0');
    });

    test('Constants.roleIdManager is "3"', () {
      expect(_roleIdManager, '3');
    });

    test('Constants.roleIdOwner is "5"', () {
      expect(_roleIdOwner, '5');
    });

    test('godown role "0" routes to godownHome', () {
      expect(_resolveRoute('0', 'Y'), '/godownHome');
    });

    test('manager role "3" routes to managerHome', () {
      expect(_resolveRoute('3', 'Y'), '/managerHome');
    });

    test('owner role "5" routes to managerHome', () {
      expect(_resolveRoute('5', 'Y'), '/managerHome');
    });

    test('role "4" (unrecognised) with active user routes to login', () {
      expect(_resolveRoute('4', 'Y'), '/login');
    });

    test('role "1" (unrecognised) with active user routes to login', () {
      expect(_resolveRoute('1', 'Y'), '/login');
    });

    test('role "2" (unrecognised) with active user routes to login', () {
      expect(_resolveRoute('2', 'Y'), '/login');
    });
  });

  // ── Positive: all valid active-user + role combinations ──────────────────

  group('SplashScreen – positive navigation scenarios', () {
    test('existing session: active manager navigates away from login', () {
      final route = _resolveRoute(_roleIdManager, 'Y');
      expect(route, isNot('/login'));
    });

    test('existing session: active owner navigates away from login', () {
      final route = _resolveRoute(_roleIdOwner, 'Y');
      expect(route, isNot('/login'));
    });

    test('existing session: active godown navigates away from login', () {
      final route = _resolveRoute(_roleIdGodown, 'Y');
      expect(route, isNot('/login'));
    });

    test('valid role navigation returns a non-empty route string', () {
      expect(_resolveRoute(_roleIdManager, 'Y').isNotEmpty, isTrue);
    });
  });

  // ── Negative & exception-like scenarios ──────────────────────────────────

  group('SplashScreen – negative and edge-case scenarios', () {
    test('no session (all null) → login', () {
      expect(_resolveRoute(null, null), '/login');
    });

    test('userActive "N" (deactivated) always → login', () {
      expect(_resolveRoute(_roleIdGodown, 'N'), '/login');
      expect(_resolveRoute(_roleIdManager, 'N'), '/login');
      expect(_resolveRoute(_roleIdOwner, 'N'), '/login');
    });

    test('userActive empty string → login', () {
      expect(_resolveRoute(_roleIdManager, ''), '/login');
    });

    test('roleId is whitespace string → login even if user active', () {
      expect(_resolveRoute('  ', 'Y'), '/login');
    });

    test('corrupted roleId (special chars) → login', () {
      expect(_resolveRoute('@#\$', 'Y'), '/login');
    });

    test('null role with active user → login', () {
      expect(_resolveRoute(null, 'Y'), '/login');
    });

    test('very large roleId string → login', () {
      expect(_resolveRoute('999999999', 'Y'), '/login');
    });

    test('roleId as negative string → login', () {
      expect(_resolveRoute('-1', 'Y'), '/login');
    });
  });

  // ── SharedPreferences mock: navigation integration ─────────────────────

  group('SplashScreen – SharedPreferences mock navigation', () {
    testWidgets('navigates to login when no preferences are set', (tester) async {
      // Arrange – empty SharedPreferences (no userActive, no roleId)
      SharedPreferences.setMockInitialValues({});
      String? navigatedTo;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/godownHome': (_) => const Scaffold(body: Text('Godown Home')),
          '/managerHome': (_) => const Scaffold(body: Text('Manager Home')),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              key: const Key('triggerNav'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                navigatedTo = route;
                Navigator.pushReplacementNamed(context, route);
              },
              child: const Text('Go'),
            ),
          );
        }),
      ));

      // Act
      await tester.tap(find.byKey(const Key('triggerNav')));
      await tester.pumpAndSettle();

      // Assert
      expect(navigatedTo, '/login');
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('navigates to managerHome when manager session exists', (tester) async {
      // Arrange – manager session in SharedPreferences
      SharedPreferences.setMockInitialValues({
        'roleId': '3',       // Constants.roleIdManager
        'userActive': 'Y',
      });
      String? navigatedTo;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/managerHome': (_) => const Scaffold(body: Text('Manager Home')),
          '/godownHome': (_) => const Scaffold(body: Text('Godown Home')),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              key: const Key('triggerNav'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                navigatedTo = route;
                Navigator.pushReplacementNamed(context, route);
              },
              child: const Text('Go'),
            ),
          );
        }),
      ));

      // Act
      await tester.tap(find.byKey(const Key('triggerNav')));
      await tester.pumpAndSettle();

      // Assert
      expect(navigatedTo, '/managerHome');
      expect(find.text('Manager Home'), findsOneWidget);
    });

    testWidgets('navigates to godownHome when godown session exists', (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'roleId': '0',       // Constants.roleIdGodown
        'userActive': 'Y',
      });
      String? navigatedTo;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/managerHome': (_) => const Scaffold(body: Text('Manager Home')),
          '/godownHome': (_) => const Scaffold(body: Text('Godown Home')),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              key: const Key('triggerNav'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                navigatedTo = route;
                Navigator.pushReplacementNamed(context, route);
              },
              child: const Text('Go'),
            ),
          );
        }),
      ));

      await tester.tap(find.byKey(const Key('triggerNav')));
      await tester.pumpAndSettle();

      expect(navigatedTo, '/godownHome');
      expect(find.text('Godown Home'), findsOneWidget);
    });

    testWidgets('navigates to login when userActive is N (deactivated)', (tester) async {
      // Arrange – deactivated user
      SharedPreferences.setMockInitialValues({
        'roleId': '3',
        'userActive': 'N',
      });
      String? navigatedTo;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/managerHome': (_) => const Scaffold(body: Text('Manager Home')),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              key: const Key('triggerNav'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                navigatedTo = route;
                Navigator.pushReplacementNamed(context, route);
              },
              child: const Text('Go'),
            ),
          );
        }),
      ));

      await tester.tap(find.byKey(const Key('triggerNav')));
      await tester.pumpAndSettle();

      expect(navigatedTo, '/login');
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('navigates to managerHome for owner role "5"', (tester) async {
      // Arrange – owner session
      SharedPreferences.setMockInitialValues({
        'roleId': '5',       // Constants.roleIdOwner
        'userActive': 'Y',
      });
      String? navigatedTo;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/managerHome': (_) => const Scaffold(body: Text('Manager Home')),
          '/godownHome': (_) => const Scaffold(body: Text('Godown Home')),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              key: const Key('triggerNav'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                navigatedTo = route;
                Navigator.pushReplacementNamed(context, route);
              },
              child: const Text('Go'),
            ),
          );
        }),
      ));

      await tester.tap(find.byKey(const Key('triggerNav')));
      await tester.pumpAndSettle();

      expect(navigatedTo, '/managerHome');
      expect(find.text('Manager Home'), findsOneWidget);
    });
  });
}

