import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/constants.dart';

void main() {
  group('Constants', () {
    test('appName is Niyojan', () {
      expect(Constants.appName, 'Niyojan');
    });

    test('AppBarTitle is Niyojan', () {
      expect(Constants.AppBarTitle, 'Niyojan');
    });

    test('rupee symbol is set', () {
      expect(Constants.rupee, '\u{20B9}');
    });

    test('http success code is 200', () {
      expect(Constants.success, 200);
    });

    test('internalServer code is 500', () {
      expect(Constants.internalServer, 500);
    });

    test('token expiry auth code is 401', () {
      expect(Constants.tokenExpireAuth, 401);
    });

    test('default network availability is false', () {
      expect(Constants.isNetworkAvailable, isFalse);
    });

    test('connection title is defined', () {
      expect(Constants.connectionTitle, 'No Internet');
    });

    test('connection message is defined', () {
      expect(Constants.connectionMessage, isNotEmpty);
    });

    test('day end completed message is defined', () {
      expect(Constants.dayEndCompleted, isNotEmpty);
    });

    test('role id manager is 3', () {
      expect(Constants.roleIdManager, '3');
    });

    test('role id owner is 5', () {
      expect(Constants.roleIdOwner, '5');
    });

    test('font sizes are positive', () {
      expect(Constants.size20, greaterThan(0));
      expect(Constants.size18, greaterThan(0));
      expect(Constants.size16, greaterThan(0));
      expect(Constants.size14, greaterThan(0));
    });
  });
}

