import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';

void main() {
  group('AppColors', () {
    test('primary colors are defined', () {
      expect(AppColors.blue, isA<Color>());
      expect(AppColors.teal, isA<Color>());
      expect(AppColors.orange, isA<Color>());
      expect(AppColors.red, isA<Color>());
      expect(AppColors.green, isA<Color>());
    });

    test('neutral colors are defined', () {
      expect(AppColors.bg, isA<Color>());
      expect(AppColors.bg2, isA<Color>());
      expect(AppColors.white, isA<Color>());
      expect(AppColors.text, isA<Color>());
      expect(AppColors.border, isA<Color>());
    });

    test('gradients are defined', () {
      expect(AppColors.gradPrimary, isA<LinearGradient>());
      expect(AppColors.gradHero, isA<LinearGradient>());
      expect(AppColors.gradAccent, isA<LinearGradient>());
      expect(AppColors.gradPageBg, isA<LinearGradient>());
    });

    test('border colors are not equal', () {
      expect(AppColors.border, isNot(AppColors.border2));
    });
  });
}

