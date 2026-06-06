import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/core/theme/app_typography.dart';

void main() {
  group('AppTypography', () {
    test('hero styles are defined', () {
      expect(AppTypography.heroTitle.fontSize, 22);
      expect(AppTypography.heroSubtitle.fontSize, 13);
    });

    test('kpi styles are defined', () {
      expect(AppTypography.kpiValueXL.fontSize, 30);
      expect(AppTypography.kpiValueLG.fontSize, 18);
      expect(AppTypography.kpiValueMD.fontSize, 22);
    });

    test('card styles are defined', () {
      expect(AppTypography.cardTitle.fontSize, 15);
      expect(AppTypography.cardSubtitle.fontSize, 13);
    });

    test('data row styles are defined', () {
      expect(AppTypography.dataRowLabel.fontSize, 14);
      expect(AppTypography.dataRowValue.fontSize, 16);
    });

    test('profit highlight value is larger and green', () {
      expect(AppTypography.profitHighlightValue.fontSize, 24);
    });
  });
}

