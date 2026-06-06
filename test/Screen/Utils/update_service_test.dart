import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/UpdateService.dart';

void main() {
  group('UpdateService', () {
    test('class can be referenced', () {
      expect(UpdateService, isNotNull);
    });

    test('fetchLatestAppVersion is a callable static member', () {
      expect(UpdateService.fetchLatestAppVersion, isA<Function>());
    });

    test('checkForUpdate is a callable static member', () {
      expect(UpdateService.checkForUpdate, isA<Function>());
    });

    test('sendPostRequest is a callable static member', () {
      expect(UpdateService.sendPostRequest, isA<Function>());
    });
  });
}

