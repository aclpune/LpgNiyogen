// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardTVDetails.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from DashboardTVDetails ─────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

Map<String, dynamic> calcTVTotals(List<Map<String, dynamic>> items) {
  final totalCylQty = items.fold<num>(
      0, (s, e) => s + ((e['clyReceivedQty'] ?? 0) as num));
  final totalAmount = items.fold<double>(
      0.0, (s, e) => s + ((e['paidAmt'] ?? 0.0) as num).toDouble());
  final regCount = items.where((e) => e['isRegulator'] == 'Yes').length;
  return {
    'totalCylQty':      totalCylQty,
    'totalAmount':      totalAmount,
    'regReceivedCount': regCount,
  };
}

String qtyDisplay(bool isNotEmpty, num qty) =>
    'Qty: ${isNotEmpty ? qty : 0}';

String regDisplay(bool isNotEmpty, int count) =>
    'Reg Rec: ${isNotEmpty ? count : 0}';

String amountDisplay(bool isNotEmpty, String formatted) =>
    'Amount: ${isNotEmpty ? formatted : '0.00'}';

String itemSelectionMode(int? itemId) =>
    itemId == -1 ? 'FETCH_ALL' : 'FETCH_ITEM';

void main() {
  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[DashboardTVDetails] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('does not start with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('1.0 not "0.xx"', () =>
        expect(formatCurrency(1.0).startsWith('0'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-200.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(4500.0), formatCurrency(4500.0)));
  });

  // ── calcTVTotals ─────────────────────────────────────────────────────────────
  group('[DashboardTVDetails] calcTVTotals', () {
    test('sums qty, amount and regulator count', () {
      final r = calcTVTotals([
        {'clyReceivedQty': 4, 'paidAmt': 2000.0, 'isRegulator': 'Yes'},
        {'clyReceivedQty': 2, 'paidAmt': 1000.0, 'isRegulator': 'No'},
        {'clyReceivedQty': 3, 'paidAmt': 1500.0, 'isRegulator': 'Yes'},
      ]);
      expect(r['totalCylQty'],      9);
      expect(r['totalAmount'],      closeTo(4500.0, 0.001));
      expect(r['regReceivedCount'], 2);
    });
    test('empty list → zeros', () {
      final r = calcTVTotals([]);
      expect(r['totalCylQty'],      0);
      expect(r['totalAmount'],      0.0);
      expect(r['regReceivedCount'], 0);
    });
    test('null fields treated as zero', () {
      final r = calcTVTotals([
        {'clyReceivedQty': null, 'paidAmt': null, 'isRegulator': null},
      ]);
      expect(r['totalCylQty'],      0);
      expect(r['totalAmount'],      0.0);
      expect(r['regReceivedCount'], 0);
    });
    test('all regulators Yes → full count', () {
      final data = List.generate(5, (_) =>
          {'clyReceivedQty': 1, 'paidAmt': 100.0, 'isRegulator': 'Yes'});
      expect(calcTVTotals(data)['regReceivedCount'], 5);
    });
    test('no regulator Yes → 0', () {
      final data = [{'clyReceivedQty': 2, 'paidAmt': 500.0, 'isRegulator': 'No'}];
      expect(calcTVTotals(data)['regReceivedCount'], 0);
    });
    test('single item', () {
      final r = calcTVTotals([
        {'clyReceivedQty': 6, 'paidAmt': 3000.0, 'isRegulator': 'Yes'},
      ]);
      expect(r['totalCylQty'],      6);
      expect(r['totalAmount'],      closeTo(3000.0, 0.001));
      expect(r['regReceivedCount'], 1);
    });
    test('fractional amounts summed', () {
      final r = calcTVTotals([
        {'clyReceivedQty': 1, 'paidAmt': 1234.56, 'isRegulator': 'No'},
        {'clyReceivedQty': 2, 'paidAmt': 4321.44, 'isRegulator': 'No'},
      ]);
      expect(r['totalAmount'], closeTo(5556.0, 0.001));
    });
    test('10 items summed', () {
      final data = List.generate(10, (_) =>
          {'clyReceivedQty': 1, 'paidAmt': 100.0, 'isRegulator': 'Yes'});
      final r = calcTVTotals(data);
      expect(r['totalCylQty'],      10);
      expect(r['totalAmount'],      closeTo(1000.0, 0.001));
      expect(r['regReceivedCount'], 10);
    });
    test('case-sensitive isRegulator ("yes" not matched)', () {
      final data = [
        {'clyReceivedQty': 1, 'paidAmt': 100.0, 'isRegulator': 'yes'},
        {'clyReceivedQty': 1, 'paidAmt': 100.0, 'isRegulator': 'YES'},
      ];
      expect(calcTVTotals(data)['regReceivedCount'], 0);
    });
  });

  // ── qtyDisplay ───────────────────────────────────────────────────────────────
  group('[DashboardTVDetails] qtyDisplay', () {
    test('non-empty shows qty', () =>
        expect(qtyDisplay(true, 9), 'Qty: 9'));
    test('empty shows 0', () =>
        expect(qtyDisplay(false, 9), 'Qty: 0'));
    test('non-empty qty 0', () =>
        expect(qtyDisplay(true, 0), 'Qty: 0'));
    test('empty overrides qty', () =>
        expect(qtyDisplay(false, 100), 'Qty: 0'));
    test('large qty non-empty', () =>
        expect(qtyDisplay(true, 999), 'Qty: 999'));
  });

  // ── regDisplay ───────────────────────────────────────────────────────────────
  group('[DashboardTVDetails] regDisplay', () {
    test('non-empty shows count', () =>
        expect(regDisplay(true, 3), 'Reg Rec: 3'));
    test('empty shows 0', () =>
        expect(regDisplay(false, 3), 'Reg Rec: 0'));
    test('count 0 non-empty', () =>
        expect(regDisplay(true, 0), 'Reg Rec: 0'));
    test('empty overrides count', () =>
        expect(regDisplay(false, 10), 'Reg Rec: 0'));
  });

  // ── amountDisplay ─────────────────────────────────────────────────────────────
  group('[DashboardTVDetails] amountDisplay', () {
    test('non-empty shows formatted', () =>
        expect(amountDisplay(true, '4,500.00'), 'Amount: 4,500.00'));
    test('empty shows "0.00"', () =>
        expect(amountDisplay(false, '4,500.00'), 'Amount: 0.00'));
    test('non-empty "0.00" stays "0.00"', () =>
        expect(amountDisplay(true, '0.00'), 'Amount: 0.00'));
    test('empty always "0.00"', () =>
        expect(amountDisplay(false, '1,00,000.00'), 'Amount: 0.00'));
  });

  // ── itemSelectionMode ─────────────────────────────────────────────────────────
  group('[DashboardTVDetails] itemSelectionMode', () {
    test('-1 → FETCH_ALL', () =>
        expect(itemSelectionMode(-1), 'FETCH_ALL'));
    test('1 → FETCH_ITEM', () =>
        expect(itemSelectionMode(1), 'FETCH_ITEM'));
    test('null → FETCH_ITEM', () =>
        expect(itemSelectionMode(null), 'FETCH_ITEM'));
    test('0 → FETCH_ITEM', () =>
        expect(itemSelectionMode(0), 'FETCH_ITEM'));
    test('-2 → FETCH_ITEM', () =>
        expect(itemSelectionMode(-2), 'FETCH_ITEM'));
  });
}

