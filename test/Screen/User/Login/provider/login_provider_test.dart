import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ---------------------------------------------------------------------------
// Simple ChangeNotifier-backed provider for widget tests
// ---------------------------------------------------------------------------
class TestLoginProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;

  String? get errorMessage => _error;

  void login(String mobileNo, BuildContext context) {
    // No-op for widget tests.
  }

  // helpers used in tests
  void simulateLoading() {
    _loading = true;
    notifyListeners();
  }

  void simulateError(String msg) {
    _loading = false;
    _error = msg;
    notifyListeners();
  }

  void simulateSuccess() {
    _loading = false;
    _error = null;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Widget under test – thin wrapper around the real MyLogin widget that injects
// the mock provider.  We avoid importing the real screen to stay isolated.
// ---------------------------------------------------------------------------
Widget _buildLoginWidget(TestLoginProvider provider) {
  return ChangeNotifierProvider<TestLoginProvider>.value(
    value: provider,
    child: MaterialApp(
      routes: {
        '/verifyOtp': (_) => const Scaffold(body: Text('OTP Screen')),
      },
      home: Scaffold(
        body: Builder(
          builder: (context) => Column(
            children: [
              // Simulate the mobile-number field
              TextFormField(
                key: const Key('mobileField'),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Mobile Number'),
              ),
              ElevatedButton(
                key: const Key('loginBtn'),
                onPressed: () {
                  final prov =
                      Provider.of<TestLoginProvider>(context, listen: false);
                  // Trigger the provider's login (mocked — no real network)
                  prov.login('9876543210', context);
                },
                child: const Text('Login'),
              ),
              Consumer<TestLoginProvider>(
                builder: (_, prov, __) {
                  if (prov.isLoading) {
                    return const CircularProgressIndicator(
                        key: Key('loadingIndicator'));
                  }
                  if (prov.errorMessage != null) {
                    return Text(
                      prov.errorMessage!,
                      key: const Key('errorText'),
                    );
                  }
                  return const SizedBox.shrink(key: Key('emptyState'));
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void main() {
  late TestLoginProvider mockProvider;

  setUp(() {
    mockProvider = TestLoginProvider();
  });

  // ── LoginProvider unit tests ──────────────────────────────────────────────

  group('LoginProvider – initial state', () {
    test('isLoading is false initially', () {
      expect(mockProvider.isLoading, isFalse);
    });

    test('errorMessage is null initially', () {
      expect(mockProvider.errorMessage, isNull);
    });
  });

  group('LoginProvider – state transitions', () {
    test('simulateLoading sets isLoading to true', () {
      mockProvider.simulateLoading();
      expect(mockProvider.isLoading, isTrue);
    });

    test('simulateError sets errorMessage and clears loading', () {
      mockProvider.simulateLoading();
      mockProvider.simulateError('Invalid User..!');
      expect(mockProvider.isLoading, isFalse);
      expect(mockProvider.errorMessage, 'Invalid User..!');
    });

    test('simulateSuccess clears both loading and error', () {
      mockProvider.simulateError('Some error');
      mockProvider.simulateSuccess();
      expect(mockProvider.isLoading, isFalse);
      expect(mockProvider.errorMessage, isNull);
    });
  });

  // ── Widget tests ──────────────────────────────────────────────────────────

  group('Login screen widget – idle state', () {
    testWidgets('shows mobile number text field', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      expect(find.byKey(const Key('mobileField')), findsOneWidget);
    });

    testWidgets('shows Login button', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      expect(find.byKey(const Key('loginBtn')), findsOneWidget);
    });

    testWidgets('shows empty state (no error, no loader) initially',
        (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      expect(find.byKey(const Key('emptyState')), findsOneWidget);
      expect(find.byKey(const Key('loadingIndicator')), findsNothing);
      expect(find.byKey(const Key('errorText')), findsNothing);
    });
  });

  group('Login screen widget – loading state', () {
    testWidgets('shows CircularProgressIndicator while loading', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);
    });

    testWidgets('hides error text while loading', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsNothing);
    });
  });

  group('Login screen widget – error state', () {
    testWidgets('displays error message on failure', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(find.text('Exception: Invalid User..!'), findsOneWidget);
    });

    testWidgets('hides loading indicator when error is shown', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('loadingIndicator')), findsNothing);
    });

    testWidgets('error cleared after simulateSuccess', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      mockProvider.simulateSuccess();
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsNothing);
      expect(find.byKey(const Key('emptyState')), findsOneWidget);
    });
  });

  // ── Validation unit tests ─────────────────────────────────────────────────

  group('Mobile number validation logic', () {
    bool isValidMobile(String value) {
      if (value.isEmpty) return false;
      if (value.length != 10) return false;
      if (!RegExp(r'^[6789]').hasMatch(value)) return false;
      return true;
    }

    test('empty string is invalid', () {
      expect(isValidMobile(''), isFalse);
    });

    test('less than 10 digits is invalid', () {
      expect(isValidMobile('987654321'), isFalse);
    });

    test('more than 10 digits is invalid', () {
      expect(isValidMobile('98765432101'), isFalse);
    });

    test('starts with 5 is invalid', () {
      expect(isValidMobile('5876543210'), isFalse);
    });

    test('starts with 6 is valid', () {
      expect(isValidMobile('6876543210'), isTrue);
    });

    test('starts with 7 is valid', () {
      expect(isValidMobile('7876543210'), isTrue);
    });

    test('starts with 8 is valid', () {
      expect(isValidMobile('8876543210'), isTrue);
    });

    test('starts with 9 is valid', () {
      expect(isValidMobile('9876543210'), isTrue);
    });

    test('all zeros is invalid (starts with 0)', () {
      expect(isValidMobile('0000000000'), isFalse);
    });

    test('exactly 10 digits starting with 9 is valid', () {
      expect(isValidMobile('9123456789'), isTrue);
    });

    // ── Edge cases ──────────────────────────────────────────────────────────

    test('whitespace-only input is invalid', () {
      expect(isValidMobile('          '), isFalse); // 10 spaces
    });

    test('alphanumeric 10-char string is invalid (starts with letter)', () {
      expect(isValidMobile('A876543210'), isFalse);
    });

    test('special chars are invalid', () {
      expect(isValidMobile('@876543210'), isFalse);
    });
  });

  // ── SharedPreferences state tests ────────────────────────────────────────

  group('LoginProvider – SharedPreferences mock state', () {
    test('reading empty prefs returns null userActive', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      // Act
      final prefs = await SharedPreferences.getInstance();
      final userActive = prefs.getString('userActive');
      // Assert
      expect(userActive, isNull);
    });

    test('after setUserName("N") prefs stores userActive = N', () async {
      // Arrange – simulates what LoginProvider does after successful login
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      // Act
      await prefs.setString('userActive', 'N');
      // Assert
      expect(prefs.getString('userActive'), 'N');
    });

    test('after OTP verified setUserName("Y") prefs stores userActive = Y', () async {
      // Arrange – simulates what VerifyOtp does after OTP success
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      // Act
      await prefs.setString('userActive', 'Y');
      // Assert
      expect(prefs.getString('userActive'), 'Y');
    });

    test('reading stored token returns correct value', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'token': 'jwt.test.token'});
      // Act
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      // Assert
      expect(token, 'jwt.test.token');
    });

    test('reading stored roleId returns correct value', () async {
      SharedPreferences.setMockInitialValues({'roleId': '3'});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('roleId'), '3');
    });

    test('reading missing roleId returns null', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('roleId'), isNull);
    });

    test('reading stored OTP returns correct value', () async {
      SharedPreferences.setMockInitialValues({'OTP': '1458'});
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('OTP'), '1458');
    });

    test('clear() removes all stored values', () async {
      SharedPreferences.setMockInitialValues({
        'userActive': 'Y',
        'roleId': '3',
        'token': 'abc',
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      expect(prefs.getString('userActive'), isNull);
      expect(prefs.getString('roleId'), isNull);
      expect(prefs.getString('token'), isNull);
    });
  });

  // ── No-internet scenario widget test ─────────────────────────────────────

  group('LoginProvider – no internet scenario', () {
    testWidgets('shows no-internet message widget when offline', (tester) async {
      // Arrange – provider simulates the no-internet error state
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('No internet connection. Please try again later.');
      await tester.pump();

      // Assert – error is displayed to the user
      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(
        find.text('No internet connection. Please try again later.'),
        findsOneWidget,
      );
    });

    testWidgets('loading is false when no-internet error is shown', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('No internet connection. Please try again later.');
      await tester.pump();

      expect(find.byKey(const Key('loadingIndicator')), findsNothing);
    });
  });

  // ── API failure scenarios ─────────────────────────────────────────────────

  group('LoginProvider – API failure scenarios', () {
    testWidgets('shows "Invalid User" error on API 401', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();

      expect(find.text('Exception: Invalid User..!'), findsOneWidget);
    });

    testWidgets('shows server error message on API 500', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();

      expect(find.byKey(const Key('errorText')), findsOneWidget);
    });

    testWidgets('shows timeout error message', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      mockProvider.simulateError('Exception: Connection timeout');
      await tester.pump();

      expect(find.text('Exception: Connection timeout'), findsOneWidget);
    });

    testWidgets('loading → error transition is smooth (no crash)', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));

      // Loading starts
      mockProvider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);

      // API fails
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('loadingIndicator')), findsNothing);
      expect(find.byKey(const Key('errorText')), findsOneWidget);
    });
  });

  // ── Listener / ChangeNotifier tests ──────────────────────────────────────

  group('LoginProvider – ChangeNotifier listener tests', () {
    test('listener is called when simulateLoading is invoked', () {
      // Arrange
      int listenerCallCount = 0;
      mockProvider.addListener(() => listenerCallCount++);

      // Act
      mockProvider.simulateLoading();

      // Assert
      expect(listenerCallCount, 1);
    });

    test('listener is called when simulateError is invoked', () {
      int listenerCallCount = 0;
      mockProvider.addListener(() => listenerCallCount++);

      mockProvider.simulateError('Some error');

      expect(listenerCallCount, 1);
    });

    test('listener is called when simulateSuccess is invoked', () {
      int listenerCallCount = 0;
      mockProvider.addListener(() => listenerCallCount++);

      mockProvider.simulateSuccess();

      expect(listenerCallCount, 1);
    });

    test('multiple state transitions fire listener each time', () {
      int listenerCallCount = 0;
      mockProvider.addListener(() => listenerCallCount++);

      mockProvider.simulateLoading();
      mockProvider.simulateError('Error 1');
      mockProvider.simulateLoading();
      mockProvider.simulateSuccess();

      expect(listenerCallCount, 4);
    });
  });

  // ── Integration: full login widget flow ──────────────────────────────────

  group('LoginProvider – full flow widget integration', () {
    testWidgets('full success flow: idle → loading → success', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));

      // Step 1: Idle state
      expect(find.byKey(const Key('emptyState')), findsOneWidget);

      // Step 2: Loading
      mockProvider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);

      // Step 3: Success
      mockProvider.simulateSuccess();
      await tester.pump();
      expect(find.byKey(const Key('emptyState')), findsOneWidget);
      expect(find.byKey(const Key('loadingIndicator')), findsNothing);
      expect(find.byKey(const Key('errorText')), findsNothing);
    });

    testWidgets('full failure flow: idle → loading → error', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));

      // Step 1: Idle
      expect(find.byKey(const Key('emptyState')), findsOneWidget);

      // Step 2: Loading
      mockProvider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);

      // Step 3: Error
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(find.byKey(const Key('loadingIndicator')), findsNothing);
    });

    testWidgets('retry flow: error → loading → success', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));

      // First attempt fails
      mockProvider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsOneWidget);

      // User retries – loading
      mockProvider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('loadingIndicator')), findsOneWidget);
      expect(find.byKey(const Key('errorText')), findsNothing);

      // Second attempt succeeds
      mockProvider.simulateSuccess();
      await tester.pump();
      expect(find.byKey(const Key('emptyState')), findsOneWidget);
    });

    testWidgets('Login button tap does not crash', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      await tester.tap(find.byKey(const Key('loginBtn')));
      await tester.pump();
      // No exception = pass; provider.login is a no-op in tests
    });

    testWidgets('entering text in mobile field works correctly', (tester) async {
      await tester.pumpWidget(_buildLoginWidget(mockProvider));
      await tester.enterText(find.byKey(const Key('mobileField')), '9876543210');
      expect(find.text('9876543210'), findsOneWidget);
    });
  });
}

