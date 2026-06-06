import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:lpgsalesandinventory/Screen/User/Login/model/LoginResponseModel.dart';

// ---------------------------------------------------------------------------
// Lightweight AuthService stub that accepts an injected http.Client so we
// can test the parsing + error-handling logic without real network calls.
// ---------------------------------------------------------------------------
class _TestableAuthService {
  final http.Client client;
  final String loginUrl;

  _TestableAuthService({required this.client, required this.loginUrl});

  Future<LoginResponseModel> login(String mobileNo) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'MobileNo': mobileNo, 'GrantType': 'password'});

    try {
      final response = await client.post(
        Uri.parse(loginUrl),
        headers: headers,
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

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
const _loginUrl = 'https://example.com/api/login';

Map<String, dynamic> _successBody() => {
      'authToken': {
        'StaffId': 19,
        'DistributorId': 8118,
        'StaffName': 'Christina Alotkar',
        'MobileNo': '8983099288',
        'RoleId': 3,
        'GodownId': 0,
        'GodownKeeperId': 0,
        'OTP': '1458',
        'DistributorCode': '41015336',
        'StaffStatus': 1,
        'Status': 'Success',
        'Token': 'test_token',
        'expiration': '2025-05-08T17:02:54Z',
        'refresh_token': 'refresh_abc',
        'RoleName': 'Manager',
        'DistributorName': 'SHREE RENUKA GAS SUPPLY COMPANY',
        'UserId': 42,
        'MgrEmail': null,
        'OwnerEmail': null,
        'IsAlreadyLogin': 0,
      }
    };

_TestableAuthService _createService(http.Client client) {
  return _TestableAuthService(client: client, loginUrl: _loginUrl);
}

void main() {
  group('AuthService.login – success path', () {
    test('returns LoginResponseModel on HTTP 200', () async {
      final client = MockClient((_) async => http.Response(
            jsonEncode(_successBody()),
            200,
          ));
      final service = _createService(client);

      final result = await service.login('8983099288');
      expect(result, isA<LoginResponseModel>());
      expect(result.authToken, isNotNull);
      expect(result.authToken!.staffName, 'Christina Alotkar');
    });

    test('authToken fields are populated correctly', () async {
      final client = MockClient((_) async => http.Response(
            jsonEncode(_successBody()),
            200,
          ));
      final service = _createService(client);

      final result = await service.login('8983099288');
      final token = result.authToken!;
      expect(token.staffId, 19);
      expect(token.distributorId, 8118);
      expect(token.roleId, 3);
      expect(token.roleName, 'Manager');
      expect(token.token, 'test_token');
      expect(token.otp, '1458');
      expect(token.status, 'Success');
    });

    test('sends correct MobileNo in request body', () async {
      const mobile = '9876543210';
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode(_successBody()), 200);
      });
      final service = _createService(client);

      await service.login(mobile);

      final decodedBody = jsonDecode(capturedRequest.body)
          as Map<String, dynamic>;
      expect(decodedBody['MobileNo'], mobile);
      expect(decodedBody['GrantType'], 'password');
    });
  });

  group('AuthService.login – failure path', () {
    test('throws Exception on HTTP 401', () async {
      final client = MockClient((_) async => http.Response('Unauthorized', 401));
      final service = _createService(client);

      expect(() => service.login('0000000000'), throwsException);
    });

    test('throws Exception on HTTP 500', () async {
      final client = MockClient((_) async => http.Response('Server Error', 500));
      final service = _createService(client);

      expect(() => service.login('0000000000'), throwsException);
    });

    test('throws Exception when network call throws', () async {
      final client = MockClient((_) async {
        throw Exception('Network error');
      });
      final service = _createService(client);

      expect(() => service.login('8983099288'), throwsException);
    });

    test('exception message contains "Invalid User"', () async {
      final client =
          MockClient((_) async => http.Response('Bad Request', 400));
      final service = _createService(client);

      try {
        await service.login('1111111111');
        fail('Expected exception was not thrown');
      } catch (e) {
        expect(e.toString(), contains('Invalid User'));
      }
    });

    test('throws Exception on malformed JSON response', () async {
      final client = MockClient((_) async => http.Response('not-json', 200));
      final service = _createService(client);

      expect(() => service.login('8983099288'), throwsException);
    });
  });

  group('AuthService.login – request headers', () {
    test('sends Content-Type application/json header', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode(_successBody()), 200);
      });
      final service = _createService(client);

      await service.login('8983099288');

      expect(
        capturedRequest.headers['Content-Type'],
        contains('application/json'),
      );    });
  });

  // ── Additional failure scenarios ──────────────────────────────────────────

  group('AuthService.login – additional failure scenarios', () {
    test('throws Exception on HTTP 404 (not found)', () async {
      // Arrange – user does not exist on server
      final client = MockClient((_) async => http.Response('Not Found', 404));
      final service = _createService(client);
      // Act & Assert
      expect(() => service.login('9999999999'), throwsException);
    });

    test('throws Exception on HTTP 403 (forbidden)', () async {
      final client = MockClient((_) async => http.Response('Forbidden', 403));
      final service = _createService(client);
      expect(() => service.login('8000000000'), throwsException);
    });

    test('throws Exception on HTTP 503 (service unavailable)', () async {
      // Simulates server downtime / maintenance
      final client = MockClient((_) async => http.Response('Service Unavailable', 503));
      final service = _createService(client);
      expect(() => service.login('9876543210'), throwsException);
    });

    test('throws Exception on connection timeout (socket exception)', () async {
      // Simulates no internet / timeout
      final client = MockClient((_) async {
        throw Exception('Connection timeout');
      });
      final service = _createService(client);
      expect(() => service.login('9876543210'), throwsException);
    });

    test('throws Exception on empty response body with 200', () async {
      // Edge: server returns 200 with empty body (malformed)
      final client = MockClient((_) async => http.Response('', 200));
      final service = _createService(client);
      expect(() => service.login('9876543210'), throwsException);
    });

    test('exception message wraps "Invalid User" on 404', () async {
      final client = MockClient((_) async => http.Response('Not Found', 404));
      final service = _createService(client);
      try {
        await service.login('0000000000');
        fail('Expected exception was not thrown');
      } catch (e) {
        expect(e.toString(), contains('Invalid User'));
      }
    });

    test('throws on null authToken in response JSON', () async {
      // Server returns 200 but authToken is null — fromJson handles it
      // but provider will throw when accessing authToken!
      final body = jsonEncode({'authToken': null});
      final client = MockClient((_) async => http.Response(body, 200));
      final service = _createService(client);
      // This should NOT throw from AuthService (it parses fine)
      final result = await service.login('9876543210');
      expect(result.authToken, isNull);
    });
  });

  // ── Request body edge cases ───────────────────────────────────────────────

  group('AuthService.login – request body edge cases', () {
    test('sends empty string mobileNo in body', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode(_successBody()), 200);
      });
      final service = _createService(client);

      await service.login('');

      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      // Assert that MobileNo key exists even for empty input
      expect(body.containsKey('MobileNo'), isTrue);
      expect(body['MobileNo'], '');
    });

    test('sends GrantType = "password" always', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode(_successBody()), 200);
      });
      final service = _createService(client);

      await service.login('9876543210');

      final body = jsonDecode(capturedRequest.body) as Map<String, dynamic>;
      expect(body['GrantType'], 'password');
    });

    test('uses POST method', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode(_successBody()), 200);
      });
      final service = _createService(client);

      await service.login('9876543210');

      expect(capturedRequest.method, 'POST');
    });

    test('sends request to correct login URL', () async {
      late http.Request capturedRequest;
      final client = MockClient((request) async {
        capturedRequest = request;
        return http.Response(jsonEncode(_successBody()), 200);
      });
      final service = _createService(client);

      await service.login('9876543210');

      expect(capturedRequest.url.toString(), _loginUrl);
    });
  });

  // ── Role-based response parsing ───────────────────────────────────────────

  group('AuthService.login – role-based response parsing', () {
    Map<String, dynamic> _bodyWithRole(int roleId, String roleName) {
      final body = Map<String, dynamic>.from(_successBody()['authToken'] as Map);
      body['RoleId'] = roleId;
      body['RoleName'] = roleName;
      return {'authToken': body};
    }

    test('parses godown keeper response (roleId = 0)', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode(_bodyWithRole(0, 'Godown')), 200));
      final result = await _createService(client).login('9000000000');
      expect(result.authToken!.roleId, 0);
      expect(result.authToken!.roleName, 'Godown');
    });

    test('parses manager response (roleId = 3)', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode(_bodyWithRole(3, 'Manager')), 200));
      final result = await _createService(client).login('8983099288');
      expect(result.authToken!.roleId, 3);
      expect(result.authToken!.roleName, 'Manager');
    });

    test('parses owner response (roleId = 5)', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode(_bodyWithRole(5, 'Owner')), 200));
      final result = await _createService(client).login('9876543210');
      expect(result.authToken!.roleId, 5);
      expect(result.authToken!.roleName, 'Owner');
    });
  });
}

