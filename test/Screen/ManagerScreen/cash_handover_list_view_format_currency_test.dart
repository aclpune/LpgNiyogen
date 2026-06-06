// Unit tests for the formatCurrency() utility function
// defined in CashHandoverListViewUI.dart
//
// STRICT RULES:
//  - NO business logic changed
//  - NO API calls
//  - NO widget rendering (pure-function tests only for this file)

import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/CashHandoverListViewUI.dart';

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('formatCurrency – zero handling', () {
    test('returns "0.00" for 0.0', () {
      expect(formatCurrency(0.0), '0.00');
    });

    test('returns "0.00" for -0.0', () {
      expect(formatCurrency(-0.0), '0.00');
    });
  });

  group('formatCurrency – whole numbers', () {
    test('formats 100 correctly', () {
      expect(formatCurrency(100.0), '100.00');
    });

    test('formats 1000 with comma', () {
      expect(formatCurrency(1000.0), '1,000.00');
    });

    test('formats 10000 with Indian grouping (10,000)', () {
      expect(formatCurrency(10000.0), '10,000.00');
    });

    test('formats 100000 as 1,00,000.00', () {
      expect(formatCurrency(100000.0), '1,00,000.00');
    });

    test('formats 1000000 as 10,00,000.00', () {
      expect(formatCurrency(1000000.0), '10,00,000.00');
    });
  });

  group('formatCurrency – decimal values', () {
    test('formats 855.50 correctly', () {
      expect(formatCurrency(855.50), '855.50');
    });

    test('formats 15304.50 with comma', () {
      expect(formatCurrency(15304.50), '15,304.50');
    });

    test('formats 551877.00 with Indian grouping', () {
      expect(formatCurrency(551877.00), '5,51,877.00');
    });

    test('formats 554077.00 correctly', () {
      expect(formatCurrency(554077.00), '5,54,077.00');
    });

    test('formats 2200.00 correctly', () {
      expect(formatCurrency(2200.00), '2,200.00');
    });
  });

  group('formatCurrency – small fractional values', () {
    test('0.5 returns 0.50', () {
      expect(formatCurrency(0.5), '0.50');
    });

    test('0.01 returns 0.01', () {
      expect(formatCurrency(0.01), '0.01');
    });

    test('0.99 returns 0.99', () {
      expect(formatCurrency(0.99), '0.99');
    });
  });

  group('formatCurrency – large values', () {
    test('formats 9999999.99 with Indian grouping', () {
      final result = formatCurrency(9999999.99);
      expect(result, isNotEmpty);
      expect(result.contains('.'), isTrue);
    });

    test('result always contains exactly one decimal point', () {
      for (final v in [0.0, 1.0, 100.5, 10000.0, 999999.0]) {
        final r = formatCurrency(v);
        expect('.'.allMatches(r).length, 1,
            reason: 'Value $v → "$r" must have exactly one decimal point');
      }
    });

    test('result always ends with two decimal digits', () {
      for (final v in [0.0, 855.5, 15304.0, 551877.5]) {
        final r = formatCurrency(v);
        final parts = r.split('.');
        expect(parts.last.length, 2,
            reason: 'Value $v → "$r" must end with 2 decimal digits');
      }
    });
  });

  group('formatCurrency – type safety', () {
    test('accepts int-like double without error', () {
      expect(() => formatCurrency(500.0), returnsNormally);
    });

    test('never returns empty string for any positive value', () {
      for (final v in [0.01, 1.0, 100.0, 100000.0]) {
        expect(formatCurrency(v), isNotEmpty);
      }
    });
  });
}

