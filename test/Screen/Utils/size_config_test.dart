import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/Utils/size_config.dart';

void main() {
  group('SizeConfig', () {
    test('init in portrait sets portrait flags and multipliers', () {
      SizeConfig().init(const BoxConstraints(maxWidth: 400, maxHeight: 800), Orientation.portrait);
      expect(SizeConfig.isPortrait, isTrue);
      expect(SizeConfig.isMobilePortrait, isTrue);
      expect(SizeConfig.textMultiplier, isNotNull);
      expect(SizeConfig.widthMultiplier, isNotNull);
      expect(SizeConfig.heightMultiplier, isNotNull);
    });

    test('init in landscape sets landscape flags', () {
      SizeConfig().init(const BoxConstraints(maxWidth: 800, maxHeight: 400), Orientation.landscape);
      expect(SizeConfig.isPortrait, isFalse);
      expect(SizeConfig.isMobilePortrait, isFalse);
      expect(SizeConfig.textMultiplier, isNotNull);
    });
  });
}

