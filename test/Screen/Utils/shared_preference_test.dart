import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/User/Login/model/LoginResponseModel.dart';
import 'package:lpgsalesandinventory/Screen/Utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('SharedPref', () {
    late SharedPref sharedPref;

    setUp(() {
      sharedPref = SharedPref();
      SharedPreferences.setMockInitialValues({});
    });

    AuthToken buildAuthToken() => AuthToken(
          staffId: 19,
          distributorId: 8118,
          staffName: 'Christina',
          mobileNo: '8983099288',
          roleId: 3,
          godownId: 0,
          godownKeeperId: 0,
          otp: '1458',
          distributorCode: '41015336',
          staffStatus: 1,
          status: 'Success',
          token: 'abc-token',
          expiration: '2025-05-08T17:02:54Z',
          refreshToken: 'refresh-token',
          roleName: 'Manager',
          distributorName: 'Test Distributor',
          userId: 42,
          MgrEmail: 'mgr@test.com',
          OwnerEmail: 'owner@test.com',
          IsAlreadyLogin: 1,
        );

    test('saveUser stores values successfully', () async {
      final result = await sharedPref.saveUser(buildAuthToken());
      expect(result, isTrue);
    });

    test('getAuthToken reads stored auth fields', () async {
      await sharedPref.saveUser(buildAuthToken());
      final token = await sharedPref.getAuthToken();
      expect(token.token, 'abc-token');
      expect(token.expiration, '2025-05-08T17:02:54Z');
      expect(token.refreshToken, 'refresh-token');
    });

    test('setFCMToken stores token value', () async {
      await sharedPref.setFCMToken('fcm-123');
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('fcmToken'), 'fcm-123');
    });

    test('setUserName and getUserName work', () async {
      await sharedPref.setUserName('active-user');
      final value = await sharedPref.getUserName();
      expect(value, 'active-user');
    });

    test('removeUser clears saved values', () async {
      await sharedPref.saveUser(buildAuthToken());
      sharedPref.removeUser();
      await Future<void>.delayed(Duration.zero);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('token'), anyOf(isNull, isEmpty));
      expect(prefs.getString('StaffName'), anyOf(isNull, isEmpty));
    });
  });
}
