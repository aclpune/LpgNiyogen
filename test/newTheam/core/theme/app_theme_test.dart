import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_colors.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_theme.dart';

void main() {
  group('AppTheme.light', () {
    test('returns ThemeData', () {
      expect(AppTheme.light, isA<ThemeData>());
    });

    test('uses Material 3', () {
      expect(AppTheme.light.useMaterial3, isTrue);
    });

    test('scaffold background uses brand background', () {
      expect(AppTheme.light.scaffoldBackgroundColor, AppColors.bg2);
    });

    test('elevated button theme exists', () {
      expect(AppTheme.light.elevatedButtonTheme, isA<ElevatedButtonThemeData>());
    });

    test('page transitions theme exists', () {
      expect(AppTheme.light.pageTransitionsTheme, isA<PageTransitionsTheme>());
    });
  });
}

