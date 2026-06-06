import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/model/LoginResponseModel.dart';

// ---------------------------------------------------------------------------
// Top-level fixtures – shared across all groups
// ---------------------------------------------------------------------------
const Map<String, dynamic> _tokenJson = {
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
  'Token': 'test_token_abc123',
  'expiration': '2025-05-08T17:02:54Z',
  'refresh_token': '07f40198a2bb4db89b28599999b53e17',
  'RoleName': 'Manager',
  'DistributorName': 'SHREE RENUKA GAS SUPPLY COMPANY',
  'UserId': 42,
  'MgrEmail': 'manager@test.com',
  'OwnerEmail': 'owner@test.com',
  'IsAlreadyLogin': 0,
};

const Map<String, dynamic> _validJson = {
  'authToken': _tokenJson,
};

void main() {
  group('LoginResponseModel', () {
    // Use top-level _validJson fixture
    final Map<String, dynamic> validJson = _validJson;

    // ── LoginResponseModel ──────────────────────────────────────────────────

    test('fromJson parses authToken correctly', () {
      final model = LoginResponseModel.fromJson(validJson);
      expect(model.authToken, isNotNull);
      expect(model.authToken!.staffName, 'Christina Alotkar');
    });

    test('fromJson with null authToken sets authToken to null', () {
      final model = LoginResponseModel.fromJson({'authToken': null});
      expect(model.authToken, isNull);
    });

    test('fromJson with missing authToken key sets authToken to null', () {
      final model = LoginResponseModel.fromJson({});
      expect(model.authToken, isNull);
    });

    test('toJson returns map with authToken key', () {
      final model = LoginResponseModel.fromJson(validJson);
      final json = model.toJson();
      expect(json.containsKey('authToken'), isTrue);
      expect(json['authToken'], isA<Map<String, dynamic>>());
    });

    test('toJson without authToken returns empty map', () {
      final model = LoginResponseModel();
      final json = model.toJson();
      expect(json.containsKey('authToken'), isFalse);
    });

    test('copyWith replaces authToken', () {
      final model = LoginResponseModel.fromJson(validJson);
      final newToken = AuthToken(staffName: 'New Name');
      final copy = model.copyWith(authToken: newToken);
      expect(copy.authToken!.staffName, 'New Name');
    });

    test('copyWith without args keeps original authToken', () {
      final model = LoginResponseModel.fromJson(validJson);
      final copy = model.copyWith();
      expect(copy.authToken!.staffName, 'Christina Alotkar');
    });
  });

  // ── AuthToken ──────────────────────────────────────────────────────────────

  group('AuthToken', () {
    // Use top-level _tokenJson fixture
    final Map<String, dynamic> tokenJson = _tokenJson;

    test('fromJson maps all fields correctly', () {
      final token = AuthToken.fromJson(tokenJson);
      expect(token.staffId, 19);
      expect(token.distributorId, 8118);
      expect(token.staffName, 'Christina Alotkar');
      expect(token.mobileNo, '8983099288');
      expect(token.roleId, 3);
      expect(token.godownId, 0);
      expect(token.godownKeeperId, 0);
      expect(token.otp, '1458');
      expect(token.distributorCode, '41015336');
      expect(token.staffStatus, 1);
      expect(token.status, 'Success');
      expect(token.token, 'test_token_abc123');
      expect(token.expiration, '2025-05-08T17:02:54Z');
      expect(token.refreshToken, '07f40198a2bb4db89b28599999b53e17');
      expect(token.roleName, 'Manager');
      expect(token.distributorName, 'SHREE RENUKA GAS SUPPLY COMPANY');
      expect(token.userId, 42);
      expect(token.MgrEmail, 'manager@test.com');
      expect(token.OwnerEmail, 'owner@test.com');
      expect(token.IsAlreadyLogin, 0);
    });

    test('fromJson handles null optional fields', () {
      final token = AuthToken.fromJson({});
      expect(token.staffId, isNull);
      expect(token.staffName, isNull);
      expect(token.token, isNull);
      expect(token.roleName, isNull);
    });

    test('toJson returns correct key-value pairs', () {
      final token = AuthToken.fromJson(tokenJson);
      final json = token.toJson();
      expect(json['StaffId'], 19);
      expect(json['StaffName'], 'Christina Alotkar');
      expect(json['MobileNo'], '8983099288');
      expect(json['RoleId'], 3);
      expect(json['OTP'], '1458');
      expect(json['Token'], 'test_token_abc123');
      expect(json['RoleName'], 'Manager');
      expect(json['refresh_token'], '07f40198a2bb4db89b28599999b53e17');
      expect(json['expiration'], '2025-05-08T17:02:54Z');
    });

    test('toJson round-trips correctly (fromJson → toJson → fromJson)', () {
      final original = AuthToken.fromJson(tokenJson);
      final json = original.toJson();
      final restored = AuthToken.fromJson(json);
      expect(restored.staffName, original.staffName);
      expect(restored.token, original.token);
      expect(restored.roleName, original.roleName);
      expect(restored.distributorName, original.distributorName);
    });

    test('copyWith replaces only provided fields', () {
      final token = AuthToken.fromJson(tokenJson);
      final copy = token.copyWith(staffName: 'John Doe', roleId: 1);
      expect(copy.staffName, 'John Doe');
      expect(copy.roleId, 1);
      // untouched fields preserved
      expect(copy.mobileNo, '8983099288');
      expect(copy.distributorId, 8118);
      expect(copy.token, 'test_token_abc123');
    });

    test('copyWith without args preserves all fields', () {
      final token = AuthToken.fromJson(tokenJson);
      final copy = token.copyWith();
      expect(copy.staffName, token.staffName);
      expect(copy.token, token.token);
      expect(copy.roleName, token.roleName);
    });

    test('constructor sets fields via named parameters', () {
      final token = AuthToken(
        staffId: 1,
        staffName: 'Test User',
        roleId: 3,
        mobileNo: '9876543210',
        status: 'Success',
      );
      expect(token.staffId, 1);
      expect(token.staffName, 'Test User');
      expect(token.roleId, 3);
      expect(token.mobileNo, '9876543210');
      expect(token.status, 'Success');
    });

    test('status field differentiates success vs failure', () {
      final successToken = AuthToken.fromJson({...tokenJson, 'Status': 'Success'});
      final failToken = AuthToken.fromJson({...tokenJson, 'Status': 'Fail'});
      expect(successToken.status, 'Success');
      expect(failToken.status, 'Fail');
    });

    test('IsAlreadyLogin field parsed as num', () {
      final token = AuthToken.fromJson({...tokenJson, 'IsAlreadyLogin': 1});
      expect(token.IsAlreadyLogin, 1);
    });

    test('numeric fields accept decimal values from JSON', () {
      final token = AuthToken.fromJson({...tokenJson, 'StaffId': 19.0});
      expect(token.staffId, 19.0);
    });
  });

  // ── Constants.dart role ID alignment ─────────────────────────────────────

  group('AuthToken – Constants.dart role IDs', () {
    // Validates that AuthToken can carry each role defined in Constants.dart.

    test('roleId = 0 maps to godown keeper role', () {
      final token = AuthToken.fromJson({..._tokenJson, 'RoleId': 0, 'RoleName': 'Godown'});
      expect(token.roleId, 0);
      expect(token.roleName, 'Godown');
    });

    test('roleId = 3 maps to manager role', () {
      final token = AuthToken.fromJson({..._tokenJson, 'RoleId': 3, 'RoleName': 'Manager'});
      expect(token.roleId, 3);
      expect(token.roleName, 'Manager');
    });

    test('roleId = 5 maps to owner role', () {
      final token = AuthToken.fromJson({..._tokenJson, 'RoleId': 5, 'RoleName': 'Owner'});
      expect(token.roleId, 5);
      expect(token.roleName, 'Owner');
    });

    test('toJson preserves roleId = 0', () {
      final token = AuthToken(roleId: 0, roleName: 'Godown');
      final json = token.toJson();
      expect(json['RoleId'], 0);
    });

    test('toJson preserves roleId = 3', () {
      final token = AuthToken(roleId: 3, roleName: 'Manager');
      expect(token.toJson()['RoleId'], 3);
    });

    test('toJson preserves roleId = 5', () {
      final token = AuthToken(roleId: 5, roleName: 'Owner');
      expect(token.toJson()['RoleId'], 5);
    });
  });

  // ── IsAlreadyLogin edge cases ─────────────────────────────────────────────

  group('AuthToken – IsAlreadyLogin edge cases', () {
    test('IsAlreadyLogin = 0 means first login', () {
      final token = AuthToken.fromJson({..._tokenJson, 'IsAlreadyLogin': 0});
      expect(token.IsAlreadyLogin, 0);
    });

    test('IsAlreadyLogin = 1 means already logged in elsewhere', () {
      final token = AuthToken.fromJson({..._tokenJson, 'IsAlreadyLogin': 1});
      expect(token.IsAlreadyLogin, 1);
    });

    test('IsAlreadyLogin null in JSON stores as null', () {
      final json = Map<String, dynamic>.from(_tokenJson);
      json['IsAlreadyLogin'] = null;
      final token = AuthToken.fromJson(json);
      expect(token.IsAlreadyLogin, isNull);
    });

    test('copyWith can update IsAlreadyLogin from 0 to 1', () {
      final token = AuthToken.fromJson({..._tokenJson, 'IsAlreadyLogin': 0});
      final updated = token.copyWith(IsAlreadyLogin: 1);
      expect(updated.IsAlreadyLogin, 1);
      expect(token.IsAlreadyLogin, 0); // original unchanged
    });
  });

  // ── LoginResponseModel roundtrip ─────────────────────────────────────────

  group('LoginResponseModel – full roundtrip', () {
    test('fromJson → toJson → fromJson preserves all authToken fields', () {
      // Arrange
      final original = LoginResponseModel.fromJson(_validJson);
      // Act: serialize then re-parse
      final json = original.toJson();
      final restored = LoginResponseModel.fromJson(json);
      // Assert
      expect(restored.authToken!.staffId, original.authToken!.staffId);
      expect(restored.authToken!.staffName, original.authToken!.staffName);
      expect(restored.authToken!.roleId, original.authToken!.roleId);
      expect(restored.authToken!.otp, original.authToken!.otp);
      expect(restored.authToken!.token, original.authToken!.token);
      expect(restored.authToken!.refreshToken, original.authToken!.refreshToken);
      expect(restored.authToken!.MgrEmail, original.authToken!.MgrEmail);
      expect(restored.authToken!.OwnerEmail, original.authToken!.OwnerEmail);
      expect(restored.authToken!.IsAlreadyLogin, original.authToken!.IsAlreadyLogin);
    });
  });
}

