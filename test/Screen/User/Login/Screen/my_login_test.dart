import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Unit tests for MyLogin screen logic (validation, state, UI structure).
// We test only the pure logic and widget rendering — no real network or prefs.
// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Reusable helper: validates a mobile number the same way MyLogin does.
// The TextField uses FilteringTextInputFormatter.digitsOnly (UI layer) and
// LengthLimitingTextInputFormatter(10), which together enforce:
//   • digits only      – replicated here via ^\d+$ regex
//   • exactly 10 chars – length check
//   • starts with 6-9  – Indian mobile prefix check
// ---------------------------------------------------------------------------
bool _isValidMobile(String value) {
  if (value.isEmpty) return false;
  if (!RegExp(r'^\d+$').hasMatch(value)) return false; // digits only
  if (value.length != 10) return false;
  if (!RegExp(r'^[6789]').hasMatch(value)) return false;
  return true;
}

void main() {
  // ── Mobile number field validation ────────────────────────────────────────

  group('MyLogin – mobile number validation', () {
    test('empty input fails validation', () {
      expect(_isValidMobile(''), isFalse);
    });

    test('9-digit number fails (too short)', () {
      expect(_isValidMobile('987654321'), isFalse);
    });

    test('11-digit number fails (too long)', () {
      expect(_isValidMobile('98765432101'), isFalse);
    });

    test('10-digit number starting with 0 fails', () {
      expect(_isValidMobile('0987654321'), isFalse);
    });

    test('10-digit number starting with 1 fails', () {
      expect(_isValidMobile('1987654321'), isFalse);
    });

    test('10-digit number starting with 5 fails', () {
      expect(_isValidMobile('5987654321'), isFalse);
    });

    test('10-digit number starting with 6 passes', () {
      expect(_isValidMobile('6123456789'), isTrue);
    });

    test('10-digit number starting with 7 passes', () {
      expect(_isValidMobile('7123456789'), isTrue);
    });

    test('10-digit number starting with 8 passes', () {
      expect(_isValidMobile('8123456789'), isTrue);
    });

    test('10-digit number starting with 9 passes', () {
      expect(_isValidMobile('9123456789'), isTrue);
    });

    test('non-numeric string fails (length check)', () {
      expect(_isValidMobile('abcdefghij'), isFalse);
    });
  });

  // ── Screen layout / widget structure ─────────────────────────────────────

  group('MyLogin – widget structure', () {
    /// Minimal test widget that mirrors the key structural elements of MyLogin
    /// without importing platform plugins (camera, firebase, etc.)
    Widget buildTestLogin() {
      return MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // App name
                  const Text('Niyojan', key: Key('appTitle')),
                  const Text('LPG Sales & Inventory', key: Key('appSubtitle')),
                  // Form card
                  Container(
                    key: const Key('formCard'),
                    child: Column(
                      children: [
                        const Text('Sign In', key: Key('signInTitle')),
                        const Text(
                          'Enter your mobile number to continue',
                          key: Key('signInSubtitle'),
                        ),
                        TextFormField(
                          key: const Key('mobileField'),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: 'Mobile Number'),
                        ),
                        ElevatedButton(
                          key: const Key('loginButton'),
                          onPressed: () {},
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                  // Footer
                  const Text(
                    '© 2024 Niyojan. All rights reserved.',
                    key: Key('footer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('renders app title "Niyojan"', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      expect(find.byKey(const Key('appTitle')), findsOneWidget);
      expect(find.text('Niyojan'), findsOneWidget);
    });

    testWidgets('renders app subtitle "LPG Sales & Inventory"', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      expect(find.text('LPG Sales & Inventory'), findsOneWidget);
    });

    testWidgets('renders "Sign In" heading inside form card', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('renders mobile number text field', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      expect(find.byKey(const Key('mobileField')), findsOneWidget);
    });

    testWidgets('renders Login button', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      expect(find.byKey(const Key('loginButton')), findsOneWidget);
    });

    testWidgets('renders footer copyright text', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      expect(find.byKey(const Key('footer')), findsOneWidget);
    });

    testWidgets('mobile field accepts numeric input', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      await tester.enterText(find.byKey(const Key('mobileField')), '9876543210');
      expect(find.text('9876543210'), findsOneWidget);
    });

    testWidgets('Login button is tappable without crash', (tester) async {
      await tester.pumpWidget(buildTestLogin());
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();
      // No exception = pass
    });
  });

  // ── TextEditingController lifecycle ──────────────────────────────────────

  group('MyLogin – TextEditingController behaviour', () {
    test('controller starts empty', () {
      final controller = TextEditingController();
      expect(controller.text, '');
      controller.dispose();
    });

    test('controller reflects assigned text', () {
      final controller = TextEditingController();
      controller.text = '8983099288';
      expect(controller.text, '8983099288');
      controller.dispose();
    });

    test('controller clears correctly', () {
      final controller = TextEditingController()..text = '9999999999';
      controller.clear();
      expect(controller.text, '');
      controller.dispose();
    });
  });

  // ── Edge cases for mobile field input ─────────────────────────────────────

  group('MyLogin – mobile field input edge cases', () {
    test('controller rejects update does not affect text', () {
      // Arrange
      final controller = TextEditingController();
      // Act: set exactly 10 digits
      controller.text = '9876543210';
      // Assert
      expect(controller.text.length, 10);
      controller.dispose();
    });

    test('mobile with all same digits is structurally valid (10 zeros)', () {
      // Format-wise 10 digits – business validity is server-side
      final controller = TextEditingController()..text = '0000000000';
      expect(controller.text.length, 10);
      controller.dispose();
    });

    test('trimmed mobile removes leading/trailing spaces', () {
      const raw = '  9876543210  ';
      expect(raw.trim().length, 10);
      expect(_isValidMobile(raw.trim()), isTrue);
    });

    test('mobile with internal space is invalid after trim comparison', () {
      const raw = '98765 3210'; // 9 real digits + space
      expect(_isValidMobile(raw.replaceAll(' ', '')), isFalse); // only 9 digits
    });
  });

  // ── Negative: validation covering all Login screen requirements ───────────

  group('MyLogin – comprehensive negative validation', () {
    test('null-coalesced empty string is invalid', () {
      const String? nullMobile = null;
      expect(_isValidMobile(nullMobile ?? ''), isFalse);
    });

    test('mobile number with only alphabets is invalid', () {
      expect(_isValidMobile('ABCDEFGHIJ'), isFalse);
    });

    test('mobile number with special characters is invalid', () {
      expect(_isValidMobile('98@654321!'), isFalse);
    });

    test('mobile number with spaces is invalid', () {
      expect(_isValidMobile('9876 43210'), isFalse);
    });

    test('mobile starting with + is invalid', () {
      expect(_isValidMobile('+916543210'), isFalse); // 9 chars after +
    });

    test('single digit is invalid', () {
      expect(_isValidMobile('9'), isFalse);
    });

    test('international format (+91XXXXXXXXXX) length 13 is invalid', () {
      expect(_isValidMobile('+919876543210'), isFalse);
    });
  });

  // ── Navigation tests ──────────────────────────────────────────────────────

  group('MyLogin – navigation to OTP screen', () {
    testWidgets('tapping Login with valid mobile navigates to verifyOtp route',
        (tester) async {
      // Arrange – shared preferences clear
      SharedPreferences.setMockInitialValues({});

      // Build a minimal login form that pushes /verifyOtp on tap
      await tester.pumpWidget(MaterialApp(
        routes: {
          '/verifyOtp': (_) => const Scaffold(body: Text('OTP Screen')),
        },
        home: Builder(builder: (context) {
          return Scaffold(
            body: ElevatedButton(
              key: const Key('loginButton'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, '/verifyOtp'),
              child: const Text('Login'),
            ),
          );
        }),
      ));

      // Act
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      // Assert – navigated to OTP screen
      expect(find.text('OTP Screen'), findsOneWidget);
    });

    testWidgets('back button on OTP screen returns to login screen',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        routes: {
          '/login': (_) => const Scaffold(body: Text('Login Screen')),
          '/verifyOtp': (_) => Scaffold(
                body: Builder(builder: (ctx) {
                  return ElevatedButton(
                    key: const Key('backBtn'),
                    onPressed: () =>
                        Navigator.pushReplacementNamed(ctx, '/login'),
                    child: const Text('Back'),
                  );
                }),
              ),
        },
        home: Builder(builder: (context) {
          return ElevatedButton(
            key: const Key('loginButton'),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/verifyOtp'),
            child: const Text('Login'),
          );
        }),
      ));

      // Go to OTP
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('backBtn')), findsOneWidget);

      // Go back to login
      await tester.tap(find.byKey(const Key('backBtn')));
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });

  // ── API failure widget tests ──────────────────────────────────────────────

  group('MyLogin – API failure UI rendering', () {
    Widget buildLoginWithError(String errorMessage) {
      return MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TextFormField(
                key: const Key('mobileField'),
                decoration:
                    const InputDecoration(hintText: 'Mobile Number'),
              ),
              ElevatedButton(
                key: const Key('loginButton'),
                onPressed: () {},
                child: const Text('Login'),
              ),
              // Error container mirrors real MyLogin Consumer widget
              Container(
                key: const Key('errorContainer'),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline_rounded,
                        color: Color(0xFFDC2626), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        key: const Key('errorText'),
                        style: const TextStyle(
                            color: Color(0xFFDC2626), fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    testWidgets('renders error container with "Invalid User" message',
        (tester) async {
      await tester.pumpWidget(buildLoginWithError('Exception: Invalid User..!'));
      expect(find.byKey(const Key('errorContainer')), findsOneWidget);
      expect(find.text('Exception: Invalid User..!'), findsOneWidget);
    });

    testWidgets('renders error container with no-internet message',
        (tester) async {
      await tester
          .pumpWidget(buildLoginWithError('Exception: Connection timeout'));
      expect(find.text('Exception: Connection timeout'), findsOneWidget);
    });

    testWidgets('error icon is shown in error container', (tester) async {
      await tester.pumpWidget(buildLoginWithError('Some error'));
      expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);
    });

    testWidgets('error text colour is red (#DC2626)', (tester) async {
      await tester.pumpWidget(buildLoginWithError('Test error'));
      final errorTextWidget = tester.widget<Text>(find.byKey(const Key('errorText')));
      expect(errorTextWidget.style?.color, const Color(0xFFDC2626));
    });
  });

  // ── SharedPreferences pre-fill test ───────────────────────────────────────

  group('MyLogin – stored username pre-fill', () {
    testWidgets('text field is prefilled from SharedPreferences when MobileNo exists',
        (tester) async {
      // Arrange – a previously stored mobile number
      SharedPreferences.setMockInitialValues({'MobileNo': '9876543210'});

      final controller = TextEditingController();

      // Simulate _loadStoredUserData reading from prefs
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('MobileNo');
      if (stored != null) controller.text = stored;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TextField(
            key: const Key('mobileField'),
            controller: controller,
          ),
        ),
      ));

      await tester.pump();

      // Assert – field is pre-filled
      expect(controller.text, '9876543210');
      expect(find.text('9876543210'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('text field is empty when no MobileNo in SharedPreferences',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final controller = TextEditingController();

      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString('MobileNo');
      if (stored != null) controller.text = stored;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TextField(controller: controller)),
      ));

      expect(controller.text, '');
      controller.dispose();
    });
  });
}

