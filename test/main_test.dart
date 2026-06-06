import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/main.dart';

void main() {
  group('main.dart contracts', () {
    test('navigatorKey is a GlobalKey<NavigatorState>', () {
      expect(navigatorKey, isA<GlobalKey<NavigatorState>>());
    });

    test('MyHttpOverrides is an HttpOverrides', () {
      expect(MyHttpOverrides(), isA<HttpOverrides>());
    });

    test('MyApp is a StatelessWidget', () {
      expect(const MyApp(), isA<StatelessWidget>());
    });

    test('MyApp can create widget instance', () {
      expect(const MyApp(), isNotNull);
    });
  });
}

