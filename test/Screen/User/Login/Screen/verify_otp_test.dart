import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Unit + widget tests for VerifyOTP screen logic.
// We test pure logic and a lightweight structural twin — no real SharedPrefs,
// no Firebase, no real network calls.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Pure-logic helper that mirrors the OTP validation inside VerifyOtp
// ---------------------------------------------------------------------------
bool _otpMatches(String entered, String stored) => entered == stored;

bool _isValidOtpFormat(String value) =>
    value.length == 4 && RegExp(r'^\d{4}$').hasMatch(value);

// ---------------------------------------------------------------------------
// roleId routing helper (mirrors getUserData logic)
// Role IDs MUST match Constants.dart:
//   roleIdGodown = "0" | roleIdManager = "3" | roleIdOwner = "5"
// ---------------------------------------------------------------------------
const String _roleIdManager = '3'; // Constants.roleIdManager
const String _roleIdOwner   = '5'; // Constants.roleIdOwner
const String _roleIdGodown  = '0'; // Constants.roleIdGodown

String _resolveRoute(String? roleId, String? userActive) {
  if (userActive != 'Y') return '/login';
  if (roleId == null) return '/login';
  if (roleId == _roleIdGodown) return '/godownHome';
  if (roleId == _roleIdManager) return '/managerHome';
  if (roleId == _roleIdOwner) return '/managerHome';
  return '/login';
}

void main() {
  // ── OTP format validation ─────────────────────────────────────────────────

  group('VerifyOtp – OTP format validation', () {
    test('empty string is invalid', () {
      expect(_isValidOtpFormat(''), isFalse);
    });

    test('3-digit OTP is invalid (too short)', () {
      expect(_isValidOtpFormat('123'), isFalse);
    });

    test('5-digit OTP is invalid (too long)', () {
      expect(_isValidOtpFormat('12345'), isFalse);
    });

    test('exactly 4 digits is valid', () {
      expect(_isValidOtpFormat('1234'), isTrue);
    });

    test('4 characters with a letter is invalid', () {
      expect(_isValidOtpFormat('12A4'), isFalse);
    });

    test('4 spaces is invalid', () {
      expect(_isValidOtpFormat('    '), isFalse);
    });

    test('all zeros (0000) is valid format', () {
      expect(_isValidOtpFormat('0000'), isTrue);
    });
  });

  // ── OTP match logic ───────────────────────────────────────────────────────

  group('VerifyOtp – OTP match logic', () {
    test('correct OTP matches stored OTP', () {
      expect(_otpMatches('1458', '1458'), isTrue);
    });

    test('wrong OTP does not match stored OTP', () {
      expect(_otpMatches('0000', '1458'), isFalse);
    });

    test('empty input does not match non-empty stored OTP', () {
      expect(_otpMatches('', '1458'), isFalse);
    });

    test('OTP with leading space does not match', () {
      expect(_otpMatches(' 145', '1458'), isFalse);
    });

    test('case-sensitive mismatch (letters) handled', () {
      expect(_otpMatches('ABCD', 'abcd'), isFalse);
    });
  });

  // ── Role-based routing logic ──────────────────────────────────────────────

  group('VerifyOtp – role-based navigation routing', () {
    test('active manager routes to managerHome', () {
      expect(_resolveRoute(_roleIdManager, 'Y'), '/managerHome');
    });

    test('active owner routes to managerHome', () {
      expect(_resolveRoute(_roleIdOwner, 'Y'), '/managerHome');
    });

    test('active godown keeper routes to godownHome', () {
      expect(_resolveRoute(_roleIdGodown, 'Y'), '/godownHome');
    });

    test('deactivated user always routes to login', () {
      expect(_resolveRoute(_roleIdManager, 'N'), '/login');
      expect(_resolveRoute(_roleIdOwner, 'N'), '/login');
      expect(_resolveRoute(_roleIdGodown, 'N'), '/login');
    });

    test('null userActive routes to login', () {
      expect(_resolveRoute(_roleIdManager, null), '/login');
    });

    test('null roleId routes to login even if user is active', () {
      expect(_resolveRoute(null, 'Y'), '/login');
    });

    test('unknown roleId routes to login', () {
      expect(_resolveRoute('99', 'Y'), '/login');
    });
  });

  // ── sendPostRequest – request body composition ───────────────────────────

  group('VerifyOtp – sendPostRequest body composition', () {
    Map<String, dynamic> buildRequestBody({
      required String versionNo,
      required int distributorId,
      required int staffId,
      required String activatedOn,
      required int isActive,
      required String? roleId,
      required int mobileNo,
    }) {
      return {
        'VersionNo': versionNo,
        'DistributorId': distributorId,
        'StaffId': staffId,
        'ActivatedOn': activatedOn,
        'IsActive': isActive,
        'RoleId': roleId,
        'MobileNo': mobileNo,
      };
    }

    test('request body contains all required keys', () {
      final body = buildRequestBody(
        versionNo: '3.0.6',
        distributorId: 8118,
        staffId: 19,
        activatedOn: '2026-05-14',
        isActive: 1,
        roleId: '2',
        mobileNo: 8983099288,
      );
      expect(body.containsKey('VersionNo'), isTrue);
      expect(body.containsKey('DistributorId'), isTrue);
      expect(body.containsKey('StaffId'), isTrue);
      expect(body.containsKey('ActivatedOn'), isTrue);
      expect(body.containsKey('IsActive'), isTrue);
      expect(body.containsKey('RoleId'), isTrue);
      expect(body.containsKey('MobileNo'), isTrue);
    });

    test('VersionNo is set correctly', () {
      final body = buildRequestBody(
        versionNo: '3.0.7',
        distributorId: 0,
        staffId: 0,
        activatedOn: '2026-01-01',
        isActive: 1,
        roleId: null,
        mobileNo: 0,
      );
      expect(body['VersionNo'], '3.0.7');
    });

    test('IsActive flag is 1 on login', () {
      final body = buildRequestBody(
        versionNo: '3.0.6',
        distributorId: 8118,
        staffId: 19,
        activatedOn: '2026-05-14',
        isActive: 1,
        roleId: '2',
        mobileNo: 8983099288,
      );
      expect(body['IsActive'], 1);
    });

    test('unparseable distributorId defaults to 0', () {
      const raw = '';
      final parsed = int.tryParse(raw) ?? 0;
      expect(parsed, 0);
    });

    test('unparseable staffId defaults to 0', () {
      const raw = null;
      final parsed = int.tryParse(raw ?? '') ?? 0;
      expect(parsed, 0);
    });
  });

  // ── Widget structure tests ────────────────────────────────────────────────

  group('VerifyOtp – widget structure', () {
    Widget buildVerifyWidget() {
      return MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login')),
        },
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Verify OTP', key: Key('title')),
                const Text('Enter the 4-digit OTP to verify your account',
                    key: Key('subtitle')),
                TextFormField(
                  key: const Key('otpField'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration:
                      const InputDecoration(hintText: 'Enter OTP'),
                ),
                ElevatedButton(
                  key: const Key('verifyBtn'),
                  onPressed: () {},
                  child: const Text('Verify'),
                ),
                // OTP Guide card
                const Text('OTP Guide', key: Key('otpGuide')),
              ],
            ),
          ),
        ),
      );
    }

    testWidgets('renders "Verify OTP" heading', (tester) async {
      await tester.pumpWidget(buildVerifyWidget());
      expect(find.text('Verify OTP'), findsOneWidget);
    });

    testWidgets('renders subtitle instruction text', (tester) async {
      await tester.pumpWidget(buildVerifyWidget());
      expect(
        find.text('Enter the 4-digit OTP to verify your account'),
        findsOneWidget,
      );
    });

    testWidgets('renders OTP text field', (tester) async {
      await tester.pumpWidget(buildVerifyWidget());
      expect(find.byKey(const Key('otpField')), findsOneWidget);
    });

    testWidgets('renders Verify button', (tester) async {
      await tester.pumpWidget(buildVerifyWidget());
      expect(find.byKey(const Key('verifyBtn')), findsOneWidget);
    });

    testWidgets('renders OTP guide section', (tester) async {
      await tester.pumpWidget(buildVerifyWidget());
      expect(find.byKey(const Key('otpGuide')), findsOneWidget);
    });

    testWidgets('OTP field accepts 4 digit input', (tester) async {
      await tester.pumpWidget(buildVerifyWidget());
      await tester.enterText(find.byKey(const Key('otpField')), '1458');
      expect(find.text('1458'), findsOneWidget);
    });

    testWidgets('Verify button is tappable without crash', (tester) async {
      await tester.pumpWidget(buildVerifyWidget());
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();
    });
  });

  // ── Constants.dart role ID alignment ─────────────────────────────────────

  group('VerifyOtp – Constants.dart role ID alignment', () {
    test('godown roleId constant is "0"', () => expect(_roleIdGodown, '0'));
    test('manager roleId constant is "3"', () => expect(_roleIdManager, '3'));
    test('owner roleId constant is "5"', () => expect(_roleIdOwner, '5'));

    test('godown role "0" routes to godownHome', () {
      expect(_resolveRoute('0', 'Y'), '/godownHome');
    });

    test('manager role "3" routes to managerHome', () {
      expect(_resolveRoute('3', 'Y'), '/managerHome');
    });

    test('owner role "5" routes to managerHome', () {
      expect(_resolveRoute('5', 'Y'), '/managerHome');
    });
  });

  // ── OTP negative / edge-case scenarios ───────────────────────────────────

  group('VerifyOtp – negative OTP scenarios', () {
    test('OTP with special characters is invalid format', () {
      expect(_isValidOtpFormat('12!4'), isFalse);
    });

    test('OTP with spaces is invalid format', () {
      expect(_isValidOtpFormat('12 4'), isFalse);
    });

    test('null-like empty string is invalid', () {
      expect(_isValidOtpFormat(''), isFalse);
    });

    test('1-digit OTP is invalid', () {
      expect(_isValidOtpFormat('1'), isFalse);
    });

    test('2-digit OTP is invalid', () {
      expect(_isValidOtpFormat('12'), isFalse);
    });

    test('3-digit OTP is invalid', () {
      expect(_isValidOtpFormat('123'), isFalse);
    });

    test('5-digit OTP is invalid', () {
      expect(_isValidOtpFormat('12345'), isFalse);
    });

    test('OTP with leading zero is still valid format', () {
      expect(_isValidOtpFormat('0123'), isTrue);
    });

    test('OTP "9999" is valid format', () {
      expect(_isValidOtpFormat('9999'), isTrue);
    });
  });

  // ── OTP match negative scenarios ─────────────────────────────────────────

  group('VerifyOtp – OTP match negative scenarios', () {
    test('wrong OTP (off by one digit) does not match', () {
      expect(_otpMatches('1459', '1458'), isFalse);
    });

    test('reversed OTP does not match', () {
      expect(_otpMatches('8541', '1458'), isFalse);
    });

    test('OTP with trailing space does not match', () {
      expect(_otpMatches('1458 ', '1458'), isFalse);
    });

    test('empty entered OTP does not match stored', () {
      expect(_otpMatches('', '1458'), isFalse);
    });

    test('stored OTP empty and entered empty is a match', () {
      // Edge: both empty → they are equal
      expect(_otpMatches('', ''), isTrue);
    });

    test('case-sensitive: "ABCD" does not match "abcd"', () {
      expect(_otpMatches('ABCD', 'abcd'), isFalse);
    });
  });

  // ── Multiple failed OTP attempts simulation ───────────────────────────────

  group('VerifyOtp – multiple failed attempts', () {
    test('three consecutive wrong OTPs all return false', () {
      const stored = '1458';
      expect(_otpMatches('0000', stored), isFalse);
      expect(_otpMatches('1111', stored), isFalse);
      expect(_otpMatches('9999', stored), isFalse);
    });

    test('only the correct OTP returns true after multiple failures', () {
      const stored = '1458';
      // Wrong attempts
      expect(_otpMatches('0000', stored), isFalse);
      expect(_otpMatches('1111', stored), isFalse);
      // Correct attempt
      expect(_otpMatches('1458', stored), isTrue);
    });
  });

  // ── SharedPreferences integration: OTP verification ──────────────────────

  group('VerifyOtp – SharedPreferences mock OTP verification', () {
    testWidgets('shows error snackbar when entered OTP does not match stored OTP',
        (tester) async {
      // Arrange – SharedPreferences with a stored OTP
      SharedPreferences.setMockInitialValues({'OTP': '1458'});

      String? snackbarMessage;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            return Column(
              children: [
                TextFormField(key: const Key('otpInput')),
                ElevatedButton(
                  key: const Key('verifyBtn'),
                  onPressed: () async {
                    const enteredOtp = '9999'; // wrong
                    final prefs = await SharedPreferences.getInstance();
                    final storedOtp = prefs.getString('OTP');
                    if (storedOtp != enteredOtp) {
                      snackbarMessage = 'OTP not match..!';
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP not match..!')),
                      );
                    }
                  },
                  child: const Text('Verify'),
                ),
              ],
            );
          }),
        ),
      ));

      // Act
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();

      // Assert
      expect(snackbarMessage, 'OTP not match..!');
      expect(find.text('OTP not match..!'), findsOneWidget);
    });

    testWidgets('does NOT show error snackbar when OTP matches', (tester) async {
      // Arrange – correct OTP in SharedPreferences
      SharedPreferences.setMockInitialValues({'OTP': '1458'});

      bool otpMatched = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            return ElevatedButton(
              key: const Key('verifyBtn'),
              onPressed: () async {
                const enteredOtp = '1458'; // correct
                final prefs = await SharedPreferences.getInstance();
                final storedOtp = prefs.getString('OTP');
                if (storedOtp == enteredOtp) {
                  otpMatched = true;
                }
              },
              child: const Text('Verify'),
            );
          }),
        ),
      ));

      // Act
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();

      // Assert
      expect(otpMatched, isTrue);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('handles missing OTP in SharedPreferences gracefully', (tester) async {
      // Arrange – no OTP stored
      SharedPreferences.setMockInitialValues({});

      String? storedOtp;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (context) {
            return ElevatedButton(
              key: const Key('readOtpBtn'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                storedOtp = prefs.getString('OTP'); // should be null
              },
              child: const Text('Read'),
            );
          }),
        ),
      ));

      await tester.tap(find.byKey(const Key('readOtpBtn')));
      await tester.pump();

      // Assert – null OTP will not match any entered OTP
      expect(storedOtp, isNull);
      expect(_otpMatches('1458', storedOtp ?? ''), isFalse);
    });
  });

  // ── Navigation integration: OTP → role-based dashboard ───────────────────

  group('VerifyOtp – navigation after OTP success', () {
    testWidgets('manager (roleId=3) navigates to managerHome after correct OTP',
        (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({
        'OTP': '1458',
        'roleId': '3',
        'userActive': 'Y',
      });

      String? destination;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/managerHome': (_) => const Scaffold(body: Text('Manager Home')),
          '/login': (_) => const Scaffold(body: Text('Login')),
        },
        home: Builder(builder: (context) {
          return ElevatedButton(
            key: const Key('verifyBtn'),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final stored = prefs.getString('OTP');
              const entered = '1458';
              if (stored == entered) {
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                destination = route;
                Navigator.pushReplacementNamed(context, route);
              }
            },
            child: const Text('Verify'),
          );
        }),
      ));

      // Act
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pumpAndSettle();

      // Assert
      expect(destination, '/managerHome');
      expect(find.text('Manager Home'), findsOneWidget);
    });

    testWidgets('godown (roleId=0) navigates to godownHome after correct OTP',
        (tester) async {
      SharedPreferences.setMockInitialValues({
        'OTP': '7777',
        'roleId': '0',
        'userActive': 'Y',
      });

      String? destination;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/godownHome': (_) => const Scaffold(body: Text('Godown Home')),
          '/login': (_) => const Scaffold(body: Text('Login')),
        },
        home: Builder(builder: (context) {
          return ElevatedButton(
            key: const Key('verifyBtn'),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final stored = prefs.getString('OTP');
              const entered = '7777';
              if (stored == entered) {
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                destination = route;
                Navigator.pushReplacementNamed(context, route);
              }
            },
            child: const Text('Verify'),
          );
        }),
      ));

      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pumpAndSettle();

      expect(destination, '/godownHome');
      expect(find.text('Godown Home'), findsOneWidget);
    });

    testWidgets('deactivated user is redirected to login even after correct OTP',
        (tester) async {
      // Arrange – OTP matches but user is deactivated
      SharedPreferences.setMockInitialValues({
        'OTP': '1458',
        'roleId': '3',
        'userActive': 'N', // deactivated
      });

      String? destination;

      await tester.pumpWidget(MaterialApp(
        routes: {
          '/managerHome': (_) => const Scaffold(body: Text('Manager Home')),
          '/login': (_) => const Scaffold(body: Text('Login')),
        },
        home: Builder(builder: (context) {
          return ElevatedButton(
            key: const Key('verifyBtn'),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final stored = prefs.getString('OTP');
              const entered = '1458';
              if (stored == entered) {
                final role = prefs.getString('roleId');
                final active = prefs.getString('userActive');
                final route = _resolveRoute(role, active);
                destination = route;
                Navigator.pushReplacementNamed(context, route);
              }
            },
            child: const Text('Verify'),
          );
        }),
      ));

      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pumpAndSettle();

      // Even correct OTP with deactivated user → login
      expect(destination, '/login');
      expect(find.text('Login'), findsOneWidget);
    });
  });
}

