import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/BootomNavigatinBarManager.dart';

void main() {
  group('BottomNavBarExample', () {
    test('screenName constant is correct', () {
      expect(BottomNavBarExample.screenName, '/bottomNavBarExample');
    });

    test('is a StatefulWidget', () {
      expect( BottomNavBarExample(), isA<StatefulWidget>());
    });

    test('createState returns a State object', () {
      expect( BottomNavBarExample().createState(), isA<State>());
    });
  });
}

