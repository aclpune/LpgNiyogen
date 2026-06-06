import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/IOSVersionUpdateService.dart';

void main() {
  group('IosVersionUpdateCheck', () {
    final service = IosVersionUpdateCheck();

    test('appStoreUrl is configured', () {
      expect(service.appStoreUrl, isNotEmpty);
      expect(service.appStoreUrl.startsWith('https://'), isTrue);
    });

    test('instance can be created', () {
      expect(service, isA<IosVersionUpdateCheck>());
    });

    test('checkForUpdate is callable', () {
      expect(service.checkForUpdate, isA<Function>());
    });

    test('sendPostRequest is callable static member', () {
      expect(IosVersionUpdateCheck.sendPostRequest, isA<Function>());
    });
  });
}

