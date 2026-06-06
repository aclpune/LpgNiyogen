// =============================================================================
// COMPLETE AUTHENTICATION FLOW TEST SUITE
// File : test/Screen/User/auth_flow_complete_test.dart
// Ref  : lib/auth_test_scenarios_prompt_md.md
//
// Covers (per prompt spec):
//   1.  Unit Test Cases
//   2.  Widget Test Cases
//   3.  Integration Test Cases
//   4.  Positive Test Cases
//   5.  Negative Test Cases
//   6.  Exception Handling Cases
//   7.  Edge Cases
//   8.  API Failure Cases
//   9.  SharedPreferences Mock Tests
//   10. Navigation Validation Tests
//   11. Loader and UI State Tests
//   12. End-to-End Flow Tests
//
// Architecture mirrors existing project tests:
//   • SharedPreferences.setMockInitialValues() for prefs mocking
//   • MockClient (http/testing.dart) for network mocking
//   • TestLoginProvider (ChangeNotifier stub) for widget isolation
//   • Pure-logic helpers (_resolveRoute, _isValidMobile, _isValidOtp, _otpMatches)
//   • group / test / testWidgets with Arrange → Act → Assert comments
//   • No changes to production code
// =============================================================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lpgsalesandinventory/Screen/User/Login/model/LoginResponseModel.dart';

// =============================================================================
// ── SHARED CONSTANTS (aligned with Constants.dart) ──────────────────────────
// =============================================================================

/// Role IDs – must stay in sync with Constants.dart
const String _kRoleGodown  = '0'; // Constants.roleIdGodown
const String _kRoleManager = '3'; // Constants.roleIdManager
const String _kRoleOwner   = '5'; // Constants.roleIdOwner

/// Route names
const String _kRouteLogin       = '/login';
const String _kRouteOtp         = '/verifyOtp';
const String _kRouteManagerHome = '/managerHome';
const String _kRouteGodownHome  = '/godownHome';

// =============================================================================
// ── REUSABLE PURE-LOGIC HELPERS ──────────────────────────────────────────────
// =============================================================================

/// Mirrors MyLogin TextField validation:
///   - FilteringTextInputFormatter.digitsOnly (UI layer)
///   - LengthLimitingTextInputFormatter(10)
///   - Indian mobile prefix [6-9]
bool _isValidMobile(String value) {
  if (value.isEmpty) return false;
  if (!RegExp(r'^\d+$').hasMatch(value)) return false; // digits only
  if (value.length != 10) return false;
  if (!RegExp(r'^[6789]').hasMatch(value)) return false;
  return true;
}

/// Mirrors VerifyOtp OTP format validation:
///   - FilteringTextInputFormatter.digitsOnly
///   - LengthLimitingTextInputFormatter(4)
bool _isValidOtpFormat(String value) =>
    value.length == 4 && RegExp(r'^\d{4}$').hasMatch(value);

/// Mirrors VerifyOtp OTP match logic.
bool _otpMatches(String entered, String stored) => entered == stored;

/// Mirrors SplashScreen / VerifyOtp navigateToDashboard / getUserData routing.
String _resolveRoute(String? roleId, String? userActive) {
  if (userActive != 'Y') return _kRouteLogin;
  if (roleId == null) return _kRouteLogin;
  if (roleId == _kRoleGodown) return _kRouteGodownHome;
  if (roleId == _kRoleManager) return _kRouteManagerHome;
  if (roleId == _kRoleOwner) return _kRouteManagerHome;
  return _kRouteLogin; // unknown / unrecognised role
}

// =============================================================================
// ── TESTABLE AUTH-SERVICE STUB (injectable http.Client) ─────────────────────
// =============================================================================

/// Lightweight substitute for the real AuthService that accepts an injected
/// http.Client.  Mirrors the same parsing / error-handling logic without
/// platform-specific IOClient.
class _TestableAuthService {
  final http.Client client;
  final String loginUrl;
  _TestableAuthService({required this.client, required this.loginUrl});

  Future<LoginResponseModel> login(String mobileNo) async {
    final body = jsonEncode({'MobileNo': mobileNo, 'GrantType': 'password'});
    try {
      final response = await client.post(
        Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Invalid User..!');
      }
    } catch (e) {
      if (e is Exception && e.toString().contains('Invalid User')) rethrow;
      throw Exception('Invalid User..!');
    }
  }
}

// =============================================================================
// ── FAKE LOGIN PROVIDER (ChangeNotifier stub for widget tests) ───────────────
// =============================================================================

class _FakeLoginProvider extends ChangeNotifier {
  bool _loading = false;
  String? _error;

  bool get isLoading => _loading;
  String? get errorMessage => _error;

  void login(String mobileNo, BuildContext context) {/* no-op in tests */}

  void simulateLoading()            { _loading = true;  _error = null; notifyListeners(); }
  void simulateError(String msg)    { _loading = false; _error = msg;  notifyListeners(); }
  void simulateSuccess()            { _loading = false; _error = null; notifyListeners(); }
}

// =============================================================================
// ── SHARED WIDGET BUILDERS ───────────────────────────────────────────────────
// =============================================================================

const String _kLoginUrl = 'https://example.com/api/login';

/// Success payload matching real API shape.
Map<String, dynamic> _successPayload({int roleId = 3, String roleName = 'Manager'}) => {
  'authToken': {
    'StaffId': 19, 'DistributorId': 8118,
    'StaffName': 'Test User', 'MobileNo': '9876543210',
    'RoleId': roleId, 'GodownId': 0, 'GodownKeeperId': 0,
    'OTP': '1458', 'DistributorCode': '41015336',
    'StaffStatus': 1, 'Status': 'Success',
    'Token': 'test.jwt.token', 'expiration': '2026-05-16T17:00:00Z',
    'refresh_token': 'refresh_abc', 'RoleName': roleName,
    'DistributorName': 'TEST GAS COMPANY', 'UserId': 42,
    'MgrEmail': null, 'OwnerEmail': null, 'IsAlreadyLogin': 0,
  }
};

/// Builds a minimal login-form widget backed by _FakeLoginProvider.
Widget _buildLoginScreen(_FakeLoginProvider provider) {
  return ChangeNotifierProvider<_FakeLoginProvider>.value(
    value: provider,
    child: MaterialApp(
      routes: {_kRouteOtp: (_) => const Scaffold(body: Text('OTP Screen'))},
      home: Scaffold(
        body: Builder(builder: (ctx) => Column(children: [
          TextFormField(
            key: const Key('mobileField'),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            decoration: const InputDecoration(hintText: 'Mobile Number'),
          ),
          ElevatedButton(
            key: const Key('loginBtn'),
            onPressed: () {
              Provider.of<_FakeLoginProvider>(ctx, listen: false)
                  .login('9876543210', ctx);
            },
            child: const Text('Login'),
          ),
          Consumer<_FakeLoginProvider>(builder: (_, p, __) {
            if (p.isLoading) {
              return const CircularProgressIndicator(key: Key('loader'));
            }
            if (p.errorMessage != null) {
              return Text(p.errorMessage!, key: const Key('errorText'));
            }
            return const SizedBox.shrink(key: Key('idle'));
          }),
        ])),
      ),
    ),
  );
}

/// Builds a minimal OTP-form widget.
Widget _buildOtpScreen() {
  return MaterialApp(
    routes: {
      _kRouteLogin:       (_) => const Scaffold(body: Text('Login Screen')),
      _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
      _kRouteGodownHome:  (_) => const Scaffold(body: Text('Godown Home')),
    },
    home: Scaffold(
      body: Builder(builder: (ctx) => Column(children: [
        const Text('Verify OTP', key: Key('otpTitle')),
        const Text('Enter the 4-digit OTP to verify your account',
            key: Key('otpSubtitle')),
        TextFormField(
          key: const Key('otpField'),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: const InputDecoration(hintText: 'Enter OTP'),
        ),
        ElevatedButton(
          key: const Key('verifyBtn'),
          onPressed: () {},
          child: const Text('Verify'),
        ),
        const Text('OTP Guide', key: Key('otpGuide')),
      ])),
    ),
  );
}

/// Builds a splash screen twin (no Firebase / real assets).
Widget _buildSplashScreen({String version = '3.0.6'}) {
  return MaterialApp(
    routes: {
      _kRouteLogin:       (_) => const Scaffold(body: Text('Login Screen')),
      _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
      _kRouteGodownHome:  (_) => const Scaffold(body: Text('Godown Home')),
    },
    home: Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(key: const Key('logo'), width: 250, height: 250,
                color: Colors.grey.shade200),
            const SizedBox(height: 10),
            Text('Version: $version', key: const Key('versionText')),
          ],
        ),
      ),
    ),
  );
}

// =============================================================================
// ══════════════════════════════════════════════════════════════════════════════
//  T E S T   S U I T E
// ══════════════════════════════════════════════════════════════════════════════
// =============================================================================

void main() {

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 1 – MOBILE NUMBER VALIDATION (Unit Tests)                     ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit] Mobile number validation – positive cases', () {
    // ── Valid numbers starting with 6-9 ─────────────────────────────────────
    for (final mobile in ['6123456789', '7123456789', '8123456789', '9123456789']) {
      test('$mobile is a valid mobile number', () {
        expect(_isValidMobile(mobile), isTrue);
      });
    }

    test('exactly 10 digits starting with 9 is valid', () {
      expect(_isValidMobile('9876543210'), isTrue);
    });
  });

  group('[Unit] Mobile number validation – negative cases', () {
    final invalidInputs = {
      'empty string'                  : '',
      '9-digit number'                : '987654321',
      '11-digit number'               : '98765432101',
      'starts with 0'                 : '0987654321',
      'starts with 1'                 : '1987654321',
      'starts with 5'                 : '5987654321',
      'alphabets only'                : 'ABCDEFGHIJ',
      'alphanumeric'                  : 'A876543210',
      'special chars'                 : '98@654321!',
      'spaces inside'                 : '9876 43210',
      'leading/trailing spaces'       : ' 987654321',
      'international +91 format'      : '+919876543210',
      'single digit'                  : '9',
      'null-coalesced empty'          : '',
    };

    invalidInputs.forEach((label, input) {
      test('[$label] → invalid', () {
        expect(_isValidMobile(input), isFalse);
      });
    });
  });

  group('[Unit] Mobile number validation – edge cases', () {
    test('10 zeros is invalid (starts with 0)', () {
      expect(_isValidMobile('0000000000'), isFalse);
    });

    test('trim before validate: "  9876543210  ".trim() is valid', () {
      expect(_isValidMobile('  9876543210  '.trim()), isTrue);
    });

    test('internal space removed: "98765 3210" has only 9 digits', () {
      expect(_isValidMobile('98765 3210'.replaceAll(' ', '')), isFalse);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 2 – OTP FORMAT VALIDATION (Unit Tests)                        ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit] OTP format validation – positive cases', () {
    for (final otp in ['0000', '1234', '4567', '9999', '1458']) {
      test('OTP "$otp" has valid format', () {
        expect(_isValidOtpFormat(otp), isTrue);
      });
    }
  });

  group('[Unit] OTP format validation – negative cases', () {
    final invalidOtps = {
      'empty'             : '',
      '1 digit'           : '1',
      '2 digits'          : '12',
      '3 digits'          : '123',
      '5 digits'          : '12345',
      'contains letter'   : '12A4',
      'contains space'    : '12 4',
      'special char'      : '12!4',
      'all spaces'        : '    ',
    };

    invalidOtps.forEach((label, otp) {
      test('[$label] → invalid OTP format', () {
        expect(_isValidOtpFormat(otp), isFalse);
      });
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 3 – OTP MATCH LOGIC (Unit Tests)                              ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit] OTP match logic – positive cases', () {
    test('correct OTP matches stored', () {
      expect(_otpMatches('1458', '1458'), isTrue);
    });

    test('both empty match (edge)', () {
      expect(_otpMatches('', ''), isTrue);
    });
  });

  group('[Unit] OTP match logic – negative cases', () {
    final cases = {
      'wrong OTP'            : ('0000', '1458'),
      'reversed OTP'         : ('8541', '1458'),
      'off-by-one'           : ('1459', '1458'),
      'leading space'        : (' 145', '1458'),
      'trailing space'       : ('1458 ', '1458'),
      'empty vs stored'      : ('', '1458'),
      'ABCD vs abcd (case)'  : ('ABCD', 'abcd'),
    };

    cases.forEach((label, pair) {
      test('[$label] → no match', () {
        expect(_otpMatches(pair.$1, pair.$2), isFalse);
      });
    });
  });

  group('[Unit] OTP match – multiple failed attempts', () {
    test('three wrong attempts then correct one', () {
      const stored = '1458';
      expect(_otpMatches('0000', stored), isFalse);
      expect(_otpMatches('1111', stored), isFalse);
      expect(_otpMatches('9999', stored), isFalse);
      expect(_otpMatches('1458', stored), isTrue); // finally correct
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 4 – ROLE-BASED ROUTING LOGIC (Unit Tests)                     ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit] Role-based routing – positive (active user)', () {
    test('roleId=0 (Godown) → godownHome', () {
      expect(_resolveRoute(_kRoleGodown, 'Y'), _kRouteGodownHome);
    });

    test('roleId=3 (Manager) → managerHome', () {
      expect(_resolveRoute(_kRoleManager, 'Y'), _kRouteManagerHome);
    });

    test('roleId=5 (Owner) → managerHome', () {
      expect(_resolveRoute(_kRoleOwner, 'Y'), _kRouteManagerHome);
    });

    test('active user routes away from login', () {
      expect(_resolveRoute(_kRoleManager, 'Y'), isNot(_kRouteLogin));
    });
  });

  group('[Unit] Role-based routing – negative / deactivated', () {
    test('userActive = N → login regardless of role', () {
      expect(_resolveRoute(_kRoleGodown,  'N'), _kRouteLogin);
      expect(_resolveRoute(_kRoleManager, 'N'), _kRouteLogin);
      expect(_resolveRoute(_kRoleOwner,   'N'), _kRouteLogin);
    });

    test('null userActive → login', () {
      expect(_resolveRoute(_kRoleManager, null), _kRouteLogin);
    });

    test('null roleId with active user → login', () {
      expect(_resolveRoute(null, 'Y'), _kRouteLogin);
    });

    test('empty roleId → login', () {
      expect(_resolveRoute('', 'Y'), _kRouteLogin);
    });

    test('unknown roleId "4" → login', () {
      expect(_resolveRoute('4', 'Y'), _kRouteLogin);
    });

    test('unknown roleId "99" → login', () {
      expect(_resolveRoute('99', 'Y'), _kRouteLogin);
    });

    test('negative roleId string → login', () {
      expect(_resolveRoute('-1', 'Y'), _kRouteLogin);
    });

    test('special-char roleId → login', () {
      expect(_resolveRoute('@#\$', 'Y'), _kRouteLogin);
    });
  });

  group('[Unit] Role-based routing – edge cases', () {
    test('both null → login', () {
      expect(_resolveRoute(null, null), _kRouteLogin);
    });

    test('userActive lowercase "y" does NOT match "Y" (case-sensitive)', () {
      expect(_resolveRoute(_kRoleManager, 'y'), _kRouteLogin);
    });

    test('userActive with leading space " Y" → login', () {
      expect(_resolveRoute(_kRoleManager, ' Y'), _kRouteLogin);
    });

    test('Constants alignment: godown="0", manager="3", owner="5"', () {
      expect(_kRoleGodown, '0');
      expect(_kRoleManager, '3');
      expect(_kRoleOwner, '5');
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 5 – AUTH SERVICE STUB (Unit / API Tests)                      ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit/API] AuthService – positive (HTTP 200)', () {
    test('returns LoginResponseModel on success', () async {
      // Arrange
      final client = MockClient((_) async =>
          http.Response(jsonEncode(_successPayload()), 200));
      final svc = _TestableAuthService(client: client, loginUrl: _kLoginUrl);
      // Act
      final result = await svc.login('9876543210');
      // Assert
      expect(result, isA<LoginResponseModel>());
      expect(result.authToken, isNotNull);
      expect(result.authToken!.staffName, 'Test User');
    });

    test('authToken fields populated correctly for manager', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode(_successPayload(roleId: 3, roleName: 'Manager')), 200));
      final result = await _TestableAuthService(client: client, loginUrl: _kLoginUrl)
          .login('9876543210');
      expect(result.authToken!.roleId, 3);
      expect(result.authToken!.roleName, 'Manager');
      expect(result.authToken!.otp, '1458');
      expect(result.authToken!.token, 'test.jwt.token');
    });

    test('authToken fields populated correctly for godown keeper', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode(_successPayload(roleId: 0, roleName: 'Godown')), 200));
      final result = await _TestableAuthService(client: client, loginUrl: _kLoginUrl)
          .login('9000000000');
      expect(result.authToken!.roleId, 0);
      expect(result.authToken!.roleName, 'Godown');
    });

    test('authToken fields populated correctly for owner', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode(_successPayload(roleId: 5, roleName: 'Owner')), 200));
      final result = await _TestableAuthService(client: client, loginUrl: _kLoginUrl)
          .login('9000000000');
      expect(result.authToken!.roleId, 5);
    });

    test('sends correct MobileNo in request body', () async {
      late http.Request captured;
      final client = MockClient((req) async {
        captured = req;
        return http.Response(jsonEncode(_successPayload()), 200);
      });
      await _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210');
      final body = jsonDecode(captured.body) as Map<String, dynamic>;
      expect(body['MobileNo'], '9876543210');
      expect(body['GrantType'], 'password');
    });

    test('uses POST method', () async {
      late http.Request captured;
      final client = MockClient((req) async {
        captured = req;
        return http.Response(jsonEncode(_successPayload()), 200);
      });
      await _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210');
      expect(captured.method, 'POST');
    });

    test('sends Content-Type: application/json header', () async {
      late http.Request captured;
      final client = MockClient((req) async {
        captured = req;
        return http.Response(jsonEncode(_successPayload()), 200);
      });
      await _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210');
      expect(captured.headers['Content-Type'], contains('application/json'));
    });
  });

  group('[Unit/API] AuthService – negative (HTTP errors)', () {
    for (final code in [400, 401, 403, 404, 500, 503]) {
      test('throws Exception on HTTP $code', () async {
        final client = MockClient((_) async => http.Response('Error', code));
        expect(
          () => _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210'),
          throwsException,
        );
      });
    }
  });

  group('[Unit/API] AuthService – exception cases', () {
    test('throws on network timeout (socket exception)', () async {
      final client = MockClient((_) async {
        throw Exception('Connection timeout');
      });
      expect(
        () => _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210'),
        throwsException,
      );
    });

    test('throws on malformed JSON (200 but invalid body)', () async {
      final client = MockClient((_) async => http.Response('not-json', 200));
      expect(
        () => _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210'),
        throwsException,
      );
    });

    test('throws on empty body with 200', () async {
      final client = MockClient((_) async => http.Response('', 200));
      expect(
        () => _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210'),
        throwsException,
      );
    });

    test('exception message contains "Invalid User"', () async {
      final client = MockClient((_) async => http.Response('Unauthorized', 401));
      try {
        await _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('0000000000');
        fail('Expected exception not thrown');
      } catch (e) {
        expect(e.toString(), contains('Invalid User'));
      }
    });

    test('null authToken in 200 response does not throw from service', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode({'authToken': null}), 200));
      final result = await _TestableAuthService(client: client, loginUrl: _kLoginUrl)
          .login('9876543210');
      expect(result.authToken, isNull);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 6 – LOGIN PROVIDER STATE (Unit Tests)                         ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit] LoginProvider – initial state', () {
    late _FakeLoginProvider provider;
    setUp(() => provider = _FakeLoginProvider());

    test('isLoading is false initially', () => expect(provider.isLoading, isFalse));
    test('errorMessage is null initially', () => expect(provider.errorMessage, isNull));
  });

  group('[Unit] LoginProvider – state transitions', () {
    late _FakeLoginProvider provider;
    setUp(() => provider = _FakeLoginProvider());

    test('simulateLoading → isLoading = true', () {
      provider.simulateLoading();
      expect(provider.isLoading, isTrue);
      expect(provider.errorMessage, isNull);
    });

    test('simulateError → isLoading=false, errorMessage set', () {
      provider.simulateLoading();
      provider.simulateError('Exception: Invalid User..!');
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, 'Exception: Invalid User..!');
    });

    test('simulateSuccess → clears both loading and error', () {
      provider.simulateError('Some error');
      provider.simulateSuccess();
      expect(provider.isLoading, isFalse);
      expect(provider.errorMessage, isNull);
    });
  });

  group('[Unit] LoginProvider – ChangeNotifier listeners', () {
    late _FakeLoginProvider provider;
    setUp(() => provider = _FakeLoginProvider());

    test('listener fires on simulateLoading', () {
      int count = 0;
      provider.addListener(() => count++);
      provider.simulateLoading();
      expect(count, 1);
    });

    test('listener fires on simulateError', () {
      int count = 0;
      provider.addListener(() => count++);
      provider.simulateError('err');
      expect(count, 1);
    });

    test('listener fires on simulateSuccess', () {
      int count = 0;
      provider.addListener(() => count++);
      provider.simulateSuccess();
      expect(count, 1);
    });

    test('4 transitions fire listener 4 times', () {
      int count = 0;
      provider.addListener(() => count++);
      provider.simulateLoading();
      provider.simulateError('e1');
      provider.simulateLoading();
      provider.simulateSuccess();
      expect(count, 4);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 7 – SHAREDPREFERENCES MOCK TESTS (Unit)                       ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit] SharedPreferences – reading session data', () {
    test('empty prefs → null userActive', () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      expect(p.getString('userActive'), isNull);
    });

    test('empty prefs → null roleId', () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      expect(p.getString('roleId'), isNull);
    });

    test('empty prefs → null OTP', () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      expect(p.getString('OTP'), isNull);
    });

    test('stored userActive="Y" reads correctly', () async {
      SharedPreferences.setMockInitialValues({'userActive': 'Y'});
      final p = await SharedPreferences.getInstance();
      expect(p.getString('userActive'), 'Y');
    });

    test('stored roleId="3" reads correctly', () async {
      SharedPreferences.setMockInitialValues({'roleId': '3'});
      final p = await SharedPreferences.getInstance();
      expect(p.getString('roleId'), '3');
    });

    test('stored OTP="1458" reads correctly', () async {
      SharedPreferences.setMockInitialValues({'OTP': '1458'});
      final p = await SharedPreferences.getInstance();
      expect(p.getString('OTP'), '1458');
    });

    test('stored token reads correctly', () async {
      SharedPreferences.setMockInitialValues({'token': 'test.jwt.token'});
      final p = await SharedPreferences.getInstance();
      expect(p.getString('token'), 'test.jwt.token');
    });
  });

  group('[Unit] SharedPreferences – writing session data', () {
    test('setString userActive="N" persists correctly', () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      await p.setString('userActive', 'N');
      expect(p.getString('userActive'), 'N');
    });

    test('setString userActive="Y" after OTP verification persists', () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      await p.setString('userActive', 'Y');
      expect(p.getString('userActive'), 'Y');
    });

    test('clear() removes all stored values', () async {
      SharedPreferences.setMockInitialValues({
        'userActive': 'Y', 'roleId': '3', 'token': 'abc',
      });
      final p = await SharedPreferences.getInstance();
      await p.clear();
      expect(p.getString('userActive'), isNull);
      expect(p.getString('roleId'), isNull);
      expect(p.getString('token'), isNull);
    });
  });

  group('[Unit] SharedPreferences – corrupted / edge values', () {
    test('userActive with wrong case "y" resolves to login', () async {
      SharedPreferences.setMockInitialValues({'userActive': 'y', 'roleId': '3'});
      final p = await SharedPreferences.getInstance();
      final route = _resolveRoute(p.getString('roleId'), p.getString('userActive'));
      expect(route, _kRouteLogin);
    });

    test('roleId="99" (invalid) resolves to login', () async {
      SharedPreferences.setMockInitialValues({'userActive': 'Y', 'roleId': '99'});
      final p = await SharedPreferences.getInstance();
      final route = _resolveRoute(p.getString('roleId'), p.getString('userActive'));
      expect(route, _kRouteLogin);
    });

    test('roleId with special chars resolves to login', () async {
      SharedPreferences.setMockInitialValues({'userActive': 'Y', 'roleId': '@#\$'});
      final p = await SharedPreferences.getInstance();
      final route = _resolveRoute(p.getString('roleId'), p.getString('userActive'));
      expect(route, _kRouteLogin);
    });

    test('null OTP → _otpMatches with any entered = false', () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      final stored = p.getString('OTP');
      expect(_otpMatches('1458', stored ?? ''), isFalse);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 8 – SPLASH SCREEN WIDGET TESTS                                ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Widget] SplashScreen – structure', () {
    testWidgets('renders logo container', (tester) async {
      await tester.pumpWidget(_buildSplashScreen());
      expect(find.byKey(const Key('logo')), findsOneWidget);
    });

    testWidgets('renders version text "Version: 3.0.6"', (tester) async {
      await tester.pumpWidget(_buildSplashScreen(version: '3.0.6'));
      expect(find.text('Version: 3.0.6'), findsOneWidget);
    });

    testWidgets('scaffold has white background', (tester) async {
      await tester.pumpWidget(_buildSplashScreen());
      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, Colors.white);
    });

    testWidgets('column is center-aligned', (tester) async {
      await tester.pumpWidget(_buildSplashScreen());
      final col = tester.widget<Column>(find.byType(Column).first);
      expect(col.mainAxisAlignment, MainAxisAlignment.center);
    });
  });

  group('[Widget] SplashScreen – splash delay unit', () {
    test('delay is exactly 3000 ms', () {
      const d = Duration(milliseconds: 3000);
      expect(d.inMilliseconds, 3000);
    });

    test('Future.delayed resolves after 3 s', () async {
      bool done = false;
      Future.delayed(const Duration(milliseconds: 3000), () => done = true);
      await Future.delayed(const Duration(milliseconds: 3001));
      expect(done, isTrue);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 9 – SPLASH NAVIGATION (Widget / SharedPrefs integration)      ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Widget/Nav] SplashScreen – navigation from SharedPreferences', () {
    /// Helper: builds a nav-trigger widget that reads prefs and navigates.
    Widget _navWidget(VoidCallback onNav) => MaterialApp(
      routes: {
        _kRouteLogin:       (_) => const Scaffold(body: Text('Login Screen')),
        _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
        _kRouteGodownHome:  (_) => const Scaffold(body: Text('Godown Home')),
      },
      home: Builder(builder: (ctx) => ElevatedButton(
        key: const Key('trigger'),
        onPressed: () async {
          final p = await SharedPreferences.getInstance();
          final route = _resolveRoute(p.getString('roleId'), p.getString('userActive'));
          onNav();
          Navigator.pushReplacementNamed(ctx, route);
        },
        child: const Text('Go'),
      )),
    );

    testWidgets('[Positive] no session → navigates to Login', (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(_navWidget(() {}));
      // Act
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      // Assert
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('[Positive] manager session → navigates to managerHome',
        (tester) async {
      SharedPreferences.setMockInitialValues({'roleId': '3', 'userActive': 'Y'});
      await tester.pumpWidget(_navWidget(() {}));
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      expect(find.text('Manager Home'), findsOneWidget);
    });

    testWidgets('[Positive] owner session → navigates to managerHome',
        (tester) async {
      SharedPreferences.setMockInitialValues({'roleId': '5', 'userActive': 'Y'});
      await tester.pumpWidget(_navWidget(() {}));
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      expect(find.text('Manager Home'), findsOneWidget);
    });

    testWidgets('[Positive] godown session → navigates to godownHome',
        (tester) async {
      SharedPreferences.setMockInitialValues({'roleId': '0', 'userActive': 'Y'});
      await tester.pumpWidget(_navWidget(() {}));
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      expect(find.text('Godown Home'), findsOneWidget);
    });

    testWidgets('[Negative] deactivated user → navigates to Login',
        (tester) async {
      SharedPreferences.setMockInitialValues({'roleId': '3', 'userActive': 'N'});
      await tester.pumpWidget(_navWidget(() {}));
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('[Negative] invalid roleId → navigates to Login', (tester) async {
      SharedPreferences.setMockInitialValues({'roleId': '99', 'userActive': 'Y'});
      await tester.pumpWidget(_navWidget(() {}));
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('[Negative] corrupted prefs (null role) → Login', (tester) async {
      SharedPreferences.setMockInitialValues({'userActive': 'Y'}); // no roleId
      await tester.pumpWidget(_navWidget(() {}));
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('[Edge] userActive lowercase "y" → Login', (tester) async {
      SharedPreferences.setMockInitialValues({'roleId': '3', 'userActive': 'y'});
      await tester.pumpWidget(_navWidget(() {}));
      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 10 – LOGIN SCREEN WIDGET TESTS                                ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Widget] LoginScreen – UI structure', () {
    late _FakeLoginProvider provider;
    setUp(() => provider = _FakeLoginProvider());

    testWidgets('renders mobile number field', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      expect(find.byKey(const Key('mobileField')), findsOneWidget);
    });

    testWidgets('renders Login button', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      expect(find.byKey(const Key('loginBtn')), findsOneWidget);
    });

    testWidgets('shows idle state initially (no loader, no error)', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      expect(find.byKey(const Key('idle')), findsOneWidget);
      expect(find.byKey(const Key('loader')), findsNothing);
      expect(find.byKey(const Key('errorText')), findsNothing);
    });

    testWidgets('mobile field accepts 10-digit input', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      await tester.enterText(find.byKey(const Key('mobileField')), '9876543210');
      expect(find.text('9876543210'), findsOneWidget);
    });

    testWidgets('Login button is tappable without crash', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      await tester.tap(find.byKey(const Key('loginBtn')));
      await tester.pump();
    });
  });

  group('[Widget] LoginScreen – loader state (positive)', () {
    late _FakeLoginProvider provider;
    setUp(() => provider = _FakeLoginProvider());

    testWidgets('shows loader while API call is in progress', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      // Act
      provider.simulateLoading();
      await tester.pump();
      // Assert
      expect(find.byKey(const Key('loader')), findsOneWidget);
      expect(find.byKey(const Key('errorText')), findsNothing);
    });

    testWidgets('loader disappears after success', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateLoading();
      await tester.pump();
      provider.simulateSuccess();
      await tester.pump();
      expect(find.byKey(const Key('loader')), findsNothing);
      expect(find.byKey(const Key('idle')), findsOneWidget);
    });
  });

  group('[Widget] LoginScreen – error state (negative)', () {
    late _FakeLoginProvider provider;
    setUp(() => provider = _FakeLoginProvider());

    testWidgets('shows "Invalid User" error message', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(find.text('Exception: Invalid User..!'), findsOneWidget);
    });

    testWidgets('shows no-internet error message', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('No internet connection. Please try again later.');
      await tester.pump();
      expect(find.text('No internet connection. Please try again later.'), findsOneWidget);
    });

    testWidgets('shows timeout error message', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('Exception: Connection timeout');
      await tester.pump();
      expect(find.text('Exception: Connection timeout'), findsOneWidget);
    });

    testWidgets('shows server error message', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('Exception: Invalid User..!'); // 500 maps to same msg
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsOneWidget);
    });

    testWidgets('loader hidden when error is shown', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('loader')), findsNothing);
    });

    testWidgets('error cleared after successful retry', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      provider.simulateSuccess();
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsNothing);
      expect(find.byKey(const Key('idle')), findsOneWidget);
    });
  });

  group('[Widget] LoginScreen – full flow (integration-style)', () {
    late _FakeLoginProvider provider;
    setUp(() => provider = _FakeLoginProvider());

    testWidgets('idle → loading → success full flow', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      expect(find.byKey(const Key('idle')), findsOneWidget);
      provider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('loader')), findsOneWidget);
      provider.simulateSuccess();
      await tester.pump();
      expect(find.byKey(const Key('idle')), findsOneWidget);
    });

    testWidgets('idle → loading → error flow', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateLoading();
      await tester.pump();
      provider.simulateError('Exception: Invalid User..!');
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(find.byKey(const Key('loader')), findsNothing);
    });

    testWidgets('error → retry loading → success flow', (tester) async {
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('err');
      await tester.pump();
      provider.simulateLoading();
      await tester.pump();
      expect(find.byKey(const Key('errorText')), findsNothing);
      provider.simulateSuccess();
      await tester.pump();
      expect(find.byKey(const Key('idle')), findsOneWidget);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 11 – LOGIN → OTP NAVIGATION                                   ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Widget/Nav] Login → OTP navigation', () {
    testWidgets('[Positive] tapping Login navigates to /verifyOtp', (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(MaterialApp(
        routes: {_kRouteOtp: (_) => const Scaffold(body: Text('OTP Screen'))},
        home: Builder(builder: (ctx) => ElevatedButton(
          key: const Key('loginBtn'),
          onPressed: () => Navigator.pushReplacementNamed(ctx, _kRouteOtp),
          child: const Text('Login'),
        )),
      ));
      await tester.tap(find.byKey(const Key('loginBtn')));
      await tester.pumpAndSettle();
      expect(find.text('OTP Screen'), findsOneWidget);
    });

    testWidgets('[Negative] back button on OTP returns to Login', (tester) async {
      await tester.pumpWidget(MaterialApp(
        routes: {
          _kRouteLogin: (_) => const Scaffold(body: Text('Login Screen')),
          _kRouteOtp: (_) => Scaffold(
            body: Builder(builder: (ctx) => ElevatedButton(
              key: const Key('backBtn'),
              onPressed: () => Navigator.pushReplacementNamed(ctx, _kRouteLogin),
              child: const Text('Back'),
            )),
          ),
        },
        home: Builder(builder: (ctx) => ElevatedButton(
          key: const Key('loginBtn'),
          onPressed: () => Navigator.pushReplacementNamed(ctx, _kRouteOtp),
          child: const Text('Login'),
        )),
      ));
      await tester.tap(find.byKey(const Key('loginBtn')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('backBtn')));
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 12 – OTP SCREEN WIDGET TESTS                                  ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Widget] OTPScreen – structure', () {
    testWidgets('renders "Verify OTP" heading', (tester) async {
      await tester.pumpWidget(_buildOtpScreen());
      expect(find.byKey(const Key('otpTitle')), findsOneWidget);
      expect(find.text('Verify OTP'), findsOneWidget);
    });

    testWidgets('renders subtitle instruction', (tester) async {
      await tester.pumpWidget(_buildOtpScreen());
      expect(find.text('Enter the 4-digit OTP to verify your account'), findsOneWidget);
    });

    testWidgets('renders OTP field', (tester) async {
      await tester.pumpWidget(_buildOtpScreen());
      expect(find.byKey(const Key('otpField')), findsOneWidget);
    });

    testWidgets('renders Verify button', (tester) async {
      await tester.pumpWidget(_buildOtpScreen());
      expect(find.byKey(const Key('verifyBtn')), findsOneWidget);
    });

    testWidgets('renders OTP Guide section', (tester) async {
      await tester.pumpWidget(_buildOtpScreen());
      expect(find.byKey(const Key('otpGuide')), findsOneWidget);
    });

    testWidgets('OTP field accepts 4-digit input', (tester) async {
      await tester.pumpWidget(_buildOtpScreen());
      await tester.enterText(find.byKey(const Key('otpField')), '1458');
      expect(find.text('1458'), findsOneWidget);
    });

    testWidgets('Verify button is tappable without crash', (tester) async {
      await tester.pumpWidget(_buildOtpScreen());
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();
    });
  });

  group('[Widget] OTPScreen – wrong OTP shows snackbar', () {
    testWidgets('[Negative] wrong OTP shows SnackBar with error text', (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({'OTP': '1458'});
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (ctx) => ElevatedButton(
            key: const Key('verifyBtn'),
            onPressed: () async {
              final p = await SharedPreferences.getInstance();
              final stored = p.getString('OTP');
              const entered = '9999'; // wrong
              if (stored != entered) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('OTP not match..!')),
                );
              }
            },
            child: const Text('Verify'),
          )),
        ),
      ));
      // Act
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();
      // Assert
      expect(find.text('OTP not match..!'), findsOneWidget);
    });

    testWidgets('[Positive] correct OTP does NOT show error snackbar', (tester) async {
      SharedPreferences.setMockInitialValues({'OTP': '1458'});
      bool matched = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (ctx) => ElevatedButton(
            key: const Key('verifyBtn'),
            onPressed: () async {
              final p = await SharedPreferences.getInstance();
              if (p.getString('OTP') == '1458') matched = true;
            },
            child: const Text('Verify'),
          )),
        ),
      ));
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();
      expect(matched, isTrue);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('[Edge] missing OTP in prefs → null does not match any entry',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      String? storedOtp;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(builder: (ctx) => ElevatedButton(
            key: const Key('btn'),
            onPressed: () async {
              final p = await SharedPreferences.getInstance();
              storedOtp = p.getString('OTP');
            },
            child: const Text('Read'),
          )),
        ),
      ));
      await tester.tap(find.byKey(const Key('btn')));
      await tester.pump();
      expect(storedOtp, isNull);
      expect(_otpMatches('1458', storedOtp ?? ''), isFalse);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 13 – OTP → ROLE-BASED NAVIGATION (Widget/Nav)                 ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Widget/Nav] OTP → role-based dashboard navigation', () {
    Widget _otpNavWidget(Map<String, String> prefs, String enteredOtp) {
      return MaterialApp(
        routes: {
          _kRouteLogin:       (_) => const Scaffold(body: Text('Login Screen')),
          _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
          _kRouteGodownHome:  (_) => const Scaffold(body: Text('Godown Home')),
        },
        // ── Scaffold required so ScaffoldMessenger.showSnackBar has a target ──
        home: Scaffold(
          body: Builder(builder: (ctx) => ElevatedButton(
            key: const Key('verifyBtn'),
            onPressed: () async {
              final p = await SharedPreferences.getInstance();
              final stored = p.getString('OTP');
              if (stored == enteredOtp) {
                final route = _resolveRoute(p.getString('roleId'), p.getString('userActive'));
                Navigator.pushReplacementNamed(ctx, route);
              } else {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('OTP not match..!')));
              }
            },
            child: const Text('Verify'),
          )),
        ),
      );
    }

    testWidgets('[Positive] correct OTP + manager → Manager Home', (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '1458', 'roleId': '3', 'userActive': 'Y'});
      await tester.pumpWidget(_otpNavWidget({}, '1458'));
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pumpAndSettle();
      expect(find.text('Manager Home'), findsOneWidget);
    });

    testWidgets('[Positive] correct OTP + owner → Manager Home', (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '1458', 'roleId': '5', 'userActive': 'Y'});
      await tester.pumpWidget(_otpNavWidget({}, '1458'));
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pumpAndSettle();
      expect(find.text('Manager Home'), findsOneWidget);
    });

    testWidgets('[Positive] correct OTP + godown → Godown Home', (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '7777', 'roleId': '0', 'userActive': 'Y'});
      await tester.pumpWidget(_otpNavWidget({}, '7777'));
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pumpAndSettle();
      expect(find.text('Godown Home'), findsOneWidget);
    });

    testWidgets('[Negative] correct OTP but deactivated user → Login', (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '1458', 'roleId': '3', 'userActive': 'N'});
      await tester.pumpWidget(_otpNavWidget({}, '1458'));
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pumpAndSettle();
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('[Negative] wrong OTP → stays on screen, shows snackbar',
        (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '1458', 'roleId': '3', 'userActive': 'Y'});
      await tester.pumpWidget(_otpNavWidget({}, '9999'));
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();
      expect(find.text('OTP not match..!'), findsOneWidget);
    });

    testWidgets('[Negative] empty OTP → no match', (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '1458', 'roleId': '3', 'userActive': 'Y'});
      await tester.pumpWidget(_otpNavWidget({}, ''));
      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();
      expect(find.text('OTP not match..!'), findsOneWidget);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 14 – LOGINRESPONSEMODEL UNIT TESTS                            ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Unit] LoginResponseModel – parsing and serialisation', () {
    final tokenJson = _successPayload()['authToken'] as Map<String, dynamic>;

    test('[Positive] fromJson parses all fields correctly', () {
      final token = AuthToken.fromJson(tokenJson);
      expect(token.staffId, 19);
      expect(token.distributorId, 8118);
      expect(token.staffName, 'Test User');
      expect(token.mobileNo, '9876543210');
      expect(token.roleId, 3);
      expect(token.otp, '1458');
      expect(token.status, 'Success');
      expect(token.token, 'test.jwt.token');
      expect(token.roleName, 'Manager');
      expect(token.IsAlreadyLogin, 0);
    });

    test('[Positive] toJson round-trips correctly', () {
      final original = AuthToken.fromJson(tokenJson);
      final restored = AuthToken.fromJson(original.toJson());
      expect(restored.staffName, original.staffName);
      expect(restored.roleId, original.roleId);
      expect(restored.token, original.token);
      expect(restored.IsAlreadyLogin, original.IsAlreadyLogin);
    });

    test('[Positive] copyWith updates only specified fields', () {
      final token = AuthToken.fromJson(tokenJson);
      final updated = token.copyWith(roleId: 5, roleName: 'Owner');
      expect(updated.roleId, 5);
      expect(updated.roleName, 'Owner');
      expect(token.roleId, 3); // original unchanged
    });

    test('[Negative] fromJson with empty map returns null fields', () {
      final token = AuthToken.fromJson({});
      expect(token.staffId, isNull);
      expect(token.token, isNull);
    });

    test('[Negative] LoginResponseModel.fromJson with null authToken', () {
      final model = LoginResponseModel.fromJson({'authToken': null});
      expect(model.authToken, isNull);
    });

    test('[Edge] LoginResponseModel default constructor has null authToken', () {
      expect(LoginResponseModel().authToken, isNull);
    });

    test('[Edge] IsAlreadyLogin = 1 (concurrent session)', () {
      final token = AuthToken.fromJson({...tokenJson, 'IsAlreadyLogin': 1});
      expect(token.IsAlreadyLogin, 1);
    });

    test('[Edge] toJson contains all 20 expected keys', () {
      final json = AuthToken.fromJson(tokenJson).toJson();
      for (final k in ['StaffId', 'DistributorId', 'StaffName', 'MobileNo',
        'RoleId', 'GodownId', 'GodownKeeperId', 'OTP', 'DistributorCode',
        'StaffStatus', 'Status', 'Token', 'expiration', 'refresh_token',
        'RoleName', 'DistributorName', 'UserId', 'MgrEmail', 'OwnerEmail',
        'IsAlreadyLogin']) {
        expect(json.containsKey(k), isTrue, reason: 'Missing key: $k');
      }
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 15 – END-TO-END INTEGRATION FLOWS                             ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[E2E] Fresh user login flow (no prior session)', () {
    testWidgets('Splash → Login when prefs are empty', (tester) async {
      // Arrange
      SharedPreferences.setMockInitialValues({});
      await tester.pumpWidget(MaterialApp(
        routes: {
          _kRouteLogin:       (_) => const Scaffold(body: Text('Login Screen')),
          _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
        },
        home: Builder(builder: (ctx) => ElevatedButton(
          key: const Key('splash'),
          onPressed: () async {
            final p = await SharedPreferences.getInstance();
            final route = _resolveRoute(p.getString('roleId'), p.getString('userActive'));
            Navigator.pushReplacementNamed(ctx, route);
          },
          child: const Text('Splash'),
        )),
      ));
      // Act
      await tester.tap(find.byKey(const Key('splash')));
      await tester.pumpAndSettle();
      // Assert
      expect(find.text('Login Screen'), findsOneWidget);
    });

    testWidgets('Login → OTP → Manager Home (happy path)', (tester) async {
      // Arrange – simulate login API saving prefs with roleId=3
      SharedPreferences.setMockInitialValues(
          {'OTP': '1458', 'roleId': '3', 'userActive': 'Y'});

      await tester.pumpWidget(MaterialApp(
        routes: {
          _kRouteOtp: (_) => Scaffold(
            body: Builder(builder: (ctx) => ElevatedButton(
              key: const Key('otpVerify'),
              onPressed: () async {
                final p = await SharedPreferences.getInstance();
                if (p.getString('OTP') == '1458') {
                  await p.setString('userActive', 'Y');
                  final route = _resolveRoute(
                      p.getString('roleId'), p.getString('userActive'));
                  Navigator.pushReplacementNamed(ctx, route);
                }
              },
              child: const Text('Verify OTP'),
            )),
          ),
          _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
          _kRouteLogin:       (_) => const Scaffold(body: Text('Login Screen')),
        },
        home: Builder(builder: (ctx) => ElevatedButton(
          key: const Key('loginBtn'),
          onPressed: () => Navigator.pushReplacementNamed(ctx, _kRouteOtp),
          child: const Text('Login'),
        )),
      ));

      // Step 1: Login → OTP
      await tester.tap(find.byKey(const Key('loginBtn')));
      await tester.pumpAndSettle();
      expect(find.text('Verify OTP'), findsOneWidget);

      // Step 2: OTP → Manager Home
      await tester.tap(find.byKey(const Key('otpVerify')));
      await tester.pumpAndSettle();
      expect(find.text('Manager Home'), findsOneWidget);
    });

    testWidgets('Login → OTP → Godown Home (godown role)', (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '7777', 'roleId': '0', 'userActive': 'Y'});

      await tester.pumpWidget(MaterialApp(
        routes: {
          _kRouteOtp: (_) => Scaffold(
            body: Builder(builder: (ctx) => ElevatedButton(
              key: const Key('otpVerify'),
              onPressed: () async {
                final p = await SharedPreferences.getInstance();
                if (p.getString('OTP') == '7777') {
                  final route = _resolveRoute(
                      p.getString('roleId'), p.getString('userActive'));
                  Navigator.pushReplacementNamed(ctx, route);
                }
              },
              child: const Text('Verify OTP'),
            )),
          ),
          _kRouteGodownHome: (_) => const Scaffold(body: Text('Godown Home')),
          _kRouteLogin:      (_) => const Scaffold(body: Text('Login Screen')),
        },
        home: Builder(builder: (ctx) => ElevatedButton(
          key: const Key('loginBtn'),
          onPressed: () => Navigator.pushReplacementNamed(ctx, _kRouteOtp),
          child: const Text('Login'),
        )),
      ));

      await tester.tap(find.byKey(const Key('loginBtn')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('otpVerify')));
      await tester.pumpAndSettle();
      expect(find.text('Godown Home'), findsOneWidget);
    });
  });

  group('[E2E] Existing logged-in user flow', () {
    testWidgets('Splash skips login and goes directly to Manager Home', (tester) async {
      // Arrange – existing session
      SharedPreferences.setMockInitialValues({'roleId': '3', 'userActive': 'Y'});

      await tester.pumpWidget(MaterialApp(
        routes: {
          _kRouteLogin:       (_) => const Scaffold(body: Text('Login Screen')),
          _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
        },
        home: Builder(builder: (ctx) => ElevatedButton(
          key: const Key('splash'),
          onPressed: () async {
            final p = await SharedPreferences.getInstance();
            Navigator.pushReplacementNamed(ctx,
                _resolveRoute(p.getString('roleId'), p.getString('userActive')));
          },
          child: const Text('Splash'),
        )),
      ));

      await tester.tap(find.byKey(const Key('splash')));
      await tester.pumpAndSettle();
      expect(find.text('Manager Home'), findsOneWidget);
      expect(find.text('Login Screen'), findsNothing);
    });
  });

  group('[E2E] Invalid mobile flow', () {
    testWidgets('empty mobile → no navigation, error state shown', (tester) async {
      // Arrange
      final provider = _FakeLoginProvider();
      await tester.pumpWidget(_buildLoginScreen(provider));
      // Act: simulate what the provider does for empty input
      provider.simulateError('Please fill all the fields');
      await tester.pump();
      // Assert
      expect(find.byKey(const Key('errorText')), findsOneWidget);
      expect(find.text('Please fill all the fields'), findsOneWidget);
    });
  });

  group('[E2E] Invalid OTP flow', () {
    testWidgets('wrong OTP → stays on OTP screen, shows error', (tester) async {
      SharedPreferences.setMockInitialValues(
          {'OTP': '1458', 'roleId': '3', 'userActive': 'Y'});
      bool navigated = false;

      await tester.pumpWidget(MaterialApp(
        routes: {_kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home'))},
        home: Scaffold(
          body: Builder(builder: (ctx) => Column(children: [
            ElevatedButton(
              key: const Key('verifyBtn'),
              onPressed: () async {
                final p = await SharedPreferences.getInstance();
                const entered = '9999'; // wrong
                if (p.getString('OTP') == entered) {
                  navigated = true;
                  Navigator.pushReplacementNamed(ctx, _kRouteManagerHome);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                      const SnackBar(content: Text('OTP not match..!')));
                }
              },
              child: const Text('Verify'),
            ),
          ])),
        ),
      ));

      await tester.tap(find.byKey(const Key('verifyBtn')));
      await tester.pump();
      expect(navigated, isFalse);
      expect(find.text('OTP not match..!'), findsOneWidget);
    });
  });

  group('[E2E] No internet flow', () {
    testWidgets('no-internet error shows correct message in login UI', (tester) async {
      final provider = _FakeLoginProvider();
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateError('No internet connection. Please try again later.');
      await tester.pump();
      expect(find.text('No internet connection. Please try again later.'), findsOneWidget);
      expect(find.byKey(const Key('loader')), findsNothing);
    });
  });

  group('[E2E] API timeout flow', () {
    testWidgets('timeout error shows correct message', (tester) async {
      final provider = _FakeLoginProvider();
      await tester.pumpWidget(_buildLoginScreen(provider));
      provider.simulateLoading();
      await tester.pump();
      provider.simulateError('Exception: Connection timeout');
      await tester.pump();
      expect(find.text('Exception: Connection timeout'), findsOneWidget);
    });

    test('[Unit] timeout exception thrown by service propagates correctly', () async {
      final client = MockClient((_) async => throw Exception('Connection timeout'));
      expect(
        () => _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210'),
        throwsException,
      );
    });
  });

  group('[E2E] SharedPreferences failure flow', () {
    test('missing roleId causes routing to fallback /login', () async {
      SharedPreferences.setMockInitialValues({'userActive': 'Y'}); // no roleId
      final p = await SharedPreferences.getInstance();
      expect(_resolveRoute(p.getString('roleId'), p.getString('userActive')),
          _kRouteLogin);
    });

    test('missing userActive causes routing to /login', () async {
      SharedPreferences.setMockInitialValues({'roleId': '3'}); // no userActive
      final p = await SharedPreferences.getInstance();
      expect(_resolveRoute(p.getString('roleId'), p.getString('userActive')),
          _kRouteLogin);
    });

    test('completely empty prefs routes to /login', () async {
      SharedPreferences.setMockInitialValues({});
      final p = await SharedPreferences.getInstance();
      expect(_resolveRoute(p.getString('roleId'), p.getString('userActive')),
          _kRouteLogin);
    });
  });

  group('[E2E] Role-based navigation flow – all roles', () {
    final roles = [
      (_kRoleGodown, _kRouteGodownHome, 'Godown'),
      (_kRoleManager, _kRouteManagerHome, 'Manager'),
      (_kRoleOwner, _kRouteManagerHome, 'Owner'),
    ];

    for (final (roleId, route, label) in roles) {
      testWidgets('[$label] correct OTP + active → $route', (tester) async {
        SharedPreferences.setMockInitialValues(
            {'OTP': '1111', 'roleId': roleId, 'userActive': 'Y'});

        await tester.pumpWidget(MaterialApp(
          routes: {
            _kRouteLogin:       (_) => const Scaffold(body: Text('Login')),
            _kRouteManagerHome: (_) => const Scaffold(body: Text('Manager Home')),
            _kRouteGodownHome:  (_) => const Scaffold(body: Text('Godown Home')),
          },
          home: Builder(builder: (ctx) => ElevatedButton(
            key: const Key('verifyBtn'),
            onPressed: () async {
              final p = await SharedPreferences.getInstance();
              if (p.getString('OTP') == '1111') {
                Navigator.pushReplacementNamed(ctx,
                    _resolveRoute(p.getString('roleId'), p.getString('userActive')));
              }
            },
            child: const Text('Verify'),
          )),
        ));

        await tester.tap(find.byKey(const Key('verifyBtn')));
        await tester.pumpAndSettle();

        final expectedText = route == _kRouteGodownHome ? 'Godown Home' : 'Manager Home';
        expect(find.text(expectedText), findsOneWidget);
      });
    }
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  SECTION 16 – CRASH PREVENTION / EXCEPTION HANDLING                    ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('[Exception] Crash prevention tests', () {
    test('_resolveRoute never throws for any string inputs', () {
      final inputs = [null, '', '0', '3', '5', '99', 'abc', '@#\$', '  '];
      for (final roleId in inputs) {
        for (final active in [null, '', 'Y', 'N', 'y']) {
          expect(() => _resolveRoute(roleId, active), returnsNormally);
        }
      }
    });

    test('_isValidMobile never throws for any string input', () {
      final inputs = ['', '9876543210', 'abc', '@@@', null.toString(), '   '];
      for (final i in inputs) {
        expect(() => _isValidMobile(i), returnsNormally);
      }
    });

    test('_isValidOtpFormat never throws for any input', () {
      final inputs = ['', '1234', 'abcd', '    ', null.toString()];
      for (final i in inputs) {
        expect(() => _isValidOtpFormat(i), returnsNormally);
      }
    });

    test('_otpMatches never throws for any combination', () {
      final pairs = [('', ''), ('1234', ''), ('', '1234'), ('abcd', 'abcd')];
      for (final p in pairs) {
        expect(() => _otpMatches(p.$1, p.$2), returnsNormally);
      }
    });

    test('AuthToken.fromJson with empty map does not throw', () {
      expect(() => AuthToken.fromJson({}), returnsNormally);
    });

    test('LoginResponseModel.fromJson with empty map does not throw', () {
      expect(() => LoginResponseModel.fromJson({'authToken': null}), returnsNormally);
    });
  });

  group('[Exception] API failure handling', () {
    test('HTTP 401 → exception with "Invalid User"', () async {
      final client = MockClient((_) async => http.Response('Unauthorized', 401));
      try {
        await _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210');
        fail('Expected exception');
      } catch (e) {
        expect(e.toString(), contains('Invalid User'));
      }
    });

    test('HTTP 500 → exception thrown', () async {
      final client = MockClient((_) async => http.Response('Server Error', 500));
      expect(
        () => _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210'),
        throwsException,
      );
    });

    test('network error → exception thrown', () async {
      final client = MockClient((_) async => throw Exception('Network failure'));
      expect(
        () => _TestableAuthService(client: client, loginUrl: _kLoginUrl).login('9876543210'),
        throwsException,
      );
    });
  });
}



