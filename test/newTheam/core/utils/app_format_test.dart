import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/newTheam/core/utils/app_format.dart';

void main() {
  group('AppFormat', () {
    test('currency formats INR', () {
      final value = AppFormat.currency(1186437);
      expect(value.contains('₹'), isTrue);
    });

    test('compact currency formats INR compactly', () {
      final value = AppFormat.currencyCompact(1186437);
      expect(value.contains('₹'), isTrue);
    });

    test('count formats with grouping', () {
      final value = AppFormat.count(1210);
      expect(value.contains('1,210') || value.contains('1210'), isTrue);
    });

    test('percent adds percent sign', () {
      expect(AppFormat.percent(82.5), '82.5%');
    });

    test('heroDate formats readable date', () {
      final value = AppFormat.heroDate(DateTime(2026, 4, 24));
      expect(value.contains('24'), isTrue);
      expect(value.contains('2026'), isTrue);
    });

    test('shortDate formats short date', () {
      expect(AppFormat.shortDate(DateTime(2026, 4, 24)), '24 Apr');
    });
  });
}

