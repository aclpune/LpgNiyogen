// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardSVDetails.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from DashboardSVDetails ─────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

Map<String, dynamic> calcSVTotals(List<Map<String, dynamic>> items) {
  final totalCylQty =
      items.fold<num>(0, (s, e) => s + ((e['cylQty'] ?? 0) as num));
  final totalAmount = items.fold<double>(
      0.0, (s, e) => s + ((e['totalAmount'] ?? 0.0) as num).toDouble());
  return {'totalCylQty': totalCylQty, 'totalAmount': totalAmount};
}

/// Mirrors: 'Cyl. Qty: ${svmodel.isNotEmpty ? totalCylQty : 0}'
String cylQtyDisplay(bool isNotEmpty, num qty) =>
    'Cyl. Qty: ${isNotEmpty ? qty : 0}';

/// Mirrors: 'Amount: ${svmodel.isNotEmpty ? formattedAmount : '0.00'}'
String amountDisplay(bool isNotEmpty, String formatted) =>
    'Amount: ${isNotEmpty ? formatted : '0.00'}';

/// Mirrors: item dropdown selection mode
String itemSelectionMode(int? itemId) =>
    itemId == -1 ? 'FETCH_ALL' : 'FETCH_ITEM';

void main() {
  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[DashboardSVDetails] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('does not start with "." for sub-zero', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('1.0 not starts with "0"', () =>
        expect(formatCurrency(1.0).startsWith('0'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-500.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(4800.0), formatCurrency(4800.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
    test('0.99 starts with "0."', () =>
        expect(formatCurrency(0.99).startsWith('0.'), isTrue));
  });

  // ── calcSVTotals ─────────────────────────────────────────────────────────────
  group('[DashboardSVDetails] calcSVTotals', () {
    test('sums cylQty and totalAmount for two items', () {
      final r = calcSVTotals([
        {'cylQty': 5, 'totalAmount': 3000.0},
        {'cylQty': 3, 'totalAmount': 1800.0},
      ]);
      expect(r['totalCylQty'], 8);
      expect(r['totalAmount'], closeTo(4800.0, 0.001));
    });
    test('empty list → zeros', () {
      final r = calcSVTotals([]);
      expect(r['totalCylQty'], 0);
      expect(r['totalAmount'], 0.0);
    });
    test('null fields treated as zero', () {
      final r = calcSVTotals([{'cylQty': null, 'totalAmount': null}]);
      expect(r['totalCylQty'], 0);
      expect(r['totalAmount'], 0.0);
    });
    test('single item', () {
      final r = calcSVTotals([{'cylQty': 7, 'totalAmount': 5000.0}]);
      expect(r['totalCylQty'], 7);
      expect(r['totalAmount'], closeTo(5000.0, 0.001));
    });
    test('fractional amounts summed correctly', () {
      final r = calcSVTotals([
        {'cylQty': 1, 'totalAmount': 1234.56},
        {'cylQty': 2, 'totalAmount': 4321.44},
      ]);
      expect(r['totalAmount'], closeTo(5556.0, 0.001));
    });
    test('large number of items summed', () {
      final items = List.generate(10, (i) =>
          {'cylQty': 1, 'totalAmount': 100.0});
      final r = calcSVTotals(items);
      expect(r['totalCylQty'], 10);
      expect(r['totalAmount'], closeTo(1000.0, 0.001));
    });
    test('only cylQty populated, totalAmount 0', () {
      final r = calcSVTotals([
        {'cylQty': 3, 'totalAmount': 0.0},
        {'cylQty': 2, 'totalAmount': 0.0},
      ]);
      expect(r['totalCylQty'], 5);
      expect(r['totalAmount'], 0.0);
    });
  });

  // ── cylQtyDisplay ────────────────────────────────────────────────────────────
  group('[DashboardSVDetails] cylQtyDisplay', () {
    test('non-empty shows actual qty', () =>
        expect(cylQtyDisplay(true, 8), 'Cyl. Qty: 8'));
    test('empty shows 0', () =>
        expect(cylQtyDisplay(false, 8), 'Cyl. Qty: 0'));
    test('non-empty qty 0 shows 0', () =>
        expect(cylQtyDisplay(true, 0), 'Cyl. Qty: 0'));
    test('non-empty large qty shows qty', () =>
        expect(cylQtyDisplay(true, 100), 'Cyl. Qty: 100'));
    test('empty overrides qty value', () =>
        expect(cylQtyDisplay(false, 999), 'Cyl. Qty: 0'));
  });

  // ── amountDisplay ─────────────────────────────────────────────────────────────
  group('[DashboardSVDetails] amountDisplay', () {
    test('non-empty shows formatted amount', () =>
        expect(amountDisplay(true, '4,800.00'), 'Amount: 4,800.00'));
    test('empty shows "0.00"', () =>
        expect(amountDisplay(false, '4,800.00'), 'Amount: 0.00'));
    test('non-empty with "0.00" shows "0.00"', () =>
        expect(amountDisplay(true, '0.00'), 'Amount: 0.00'));
    test('empty regardless of formatted string', () =>
        expect(amountDisplay(false, '99,999.00'), 'Amount: 0.00'));
  });

  // ── itemSelectionMode ─────────────────────────────────────────────────────────
  group('[DashboardSVDetails] itemSelectionMode', () {
    test('-1 → FETCH_ALL', () =>
        expect(itemSelectionMode(-1), 'FETCH_ALL'));
    test('0 → FETCH_ITEM', () =>
        expect(itemSelectionMode(0), 'FETCH_ITEM'));
    test('1 → FETCH_ITEM', () =>
        expect(itemSelectionMode(1), 'FETCH_ITEM'));
    test('null → FETCH_ITEM', () =>
        expect(itemSelectionMode(null), 'FETCH_ITEM'));
    test('100 → FETCH_ITEM', () =>
        expect(itemSelectionMode(100), 'FETCH_ITEM'));
    test('-2 → FETCH_ITEM (only -1 is ALL)', () =>
        expect(itemSelectionMode(-2), 'FETCH_ITEM'));
  });
}

