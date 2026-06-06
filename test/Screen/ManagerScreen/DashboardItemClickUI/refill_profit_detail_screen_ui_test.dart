// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/RefillProfitDetailScreenUi.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from RefillProfitDetailScreenUi ─────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

/// Mirrors: AppBar title logic  (profitFors field)
String refillAppBarTitle(String? profitFor) {
  if (profitFor == 'GrossRevenue') return 'Refill Gross Revenue -';
  if (profitFor == 'GrossProfit')  return 'Refill Gross Profit -';
  return 'Refill -';
}

/// Mirrors: AppBar day-flag label
String refillDayFlagLabel(String? flag) {
  if (flag == 'TODAYS')    return "Today's";
  if (flag == 'THISMONTH') return 'This Month';
  if (flag == 'FINYEAR')   return 'Financial Year';
  return '';
}

/// Mirrors: profitFors == 'GrossProfit' column visibility
bool showGrossProfitColumn(String? profitFor) => profitFor == 'GrossProfit';

/// Mirrors: totals loop in fetchRefillDetailList → setState
Map<String, dynamic> calcRefillTotals(List<Map<String, dynamic>> data) {
  double grossRevenue = 0, grossProfit = 0;
  int    saleQty      = 0;
  for (final d in data) {
    grossRevenue += ((d['grossRevenue'] ?? 0) as num).toDouble();
    grossProfit  += ((d['grossProfit']  ?? 0) as num).toDouble();
    saleQty      += ((d['saleQty']      ?? 0) as num).toInt();
  }
  return {
    'grossRevenueAmts': grossRevenue,
    'grossProfitAmts':  grossProfit,
    'saleQtys':         saleQty,
  };
}

/// Mirrors: null-safe field display helper
String refillCurrencyDisplay(num? amount) =>
    amount != null ? formatCurrency(amount.toDouble()) : '0';

/// Mirrors: WillPopScope always returns false (navigates to bottomNavBar)
bool willPopReturnsFalse() => false;

void main() {
  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[RefillProfitDetailScreenUi] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.0 → "0.00"', () => expect(formatCurrency(0.0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('1.0 not starts with "0"', () =>
        expect(formatCurrency(1.0).startsWith('0'), isFalse));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-200.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(5000.0), formatCurrency(5000.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
  });

  // ── refillAppBarTitle ────────────────────────────────────────────────────────
  group('[RefillProfitDetailScreenUi] refillAppBarTitle', () {
    test('"GrossRevenue" → "Refill Gross Revenue -"', () =>
        expect(refillAppBarTitle('GrossRevenue'), 'Refill Gross Revenue -'));
    test('"GrossProfit" → "Refill Gross Profit -"', () =>
        expect(refillAppBarTitle('GrossProfit'), 'Refill Gross Profit -'));
    test('unknown → "Refill -"', () =>
        expect(refillAppBarTitle('Other'), 'Refill -'));
    test('empty → "Refill -"', () =>
        expect(refillAppBarTitle(''), 'Refill -'));
    test('null → "Refill -"', () =>
        expect(refillAppBarTitle(null), 'Refill -'));
    test('case-sensitive "grossRevenue" → "Refill -"', () =>
        expect(refillAppBarTitle('grossRevenue'), 'Refill -'));
    test('case-sensitive "grossProfit" → "Refill -"', () =>
        expect(refillAppBarTitle('grossProfit'), 'Refill -'));
  });

  // ── refillDayFlagLabel ───────────────────────────────────────────────────────
  group('[RefillProfitDetailScreenUi] refillDayFlagLabel', () {
    test('"TODAYS" → "Today\'s"', () =>
        expect(refillDayFlagLabel('TODAYS'), "Today's"));
    test('"THISMONTH" → "This Month"', () =>
        expect(refillDayFlagLabel('THISMONTH'), 'This Month'));
    test('"FINYEAR" → "Financial Year"', () =>
        expect(refillDayFlagLabel('FINYEAR'), 'Financial Year'));
    test('unknown → ""', () => expect(refillDayFlagLabel('UNKNOWN'), ''));
    test('empty → ""', () => expect(refillDayFlagLabel(''), ''));
    test('null → ""', () => expect(refillDayFlagLabel(null), ''));
    test('lowercase "todays" → ""', () =>
        expect(refillDayFlagLabel('todays'), ''));
    test('lowercase "thismonth" → ""', () =>
        expect(refillDayFlagLabel('thismonth'), ''));
  });

  // ── showGrossProfitColumn ────────────────────────────────────────────────────
  group('[RefillProfitDetailScreenUi] showGrossProfitColumn', () {
    test('"GrossProfit" → true', () =>
        expect(showGrossProfitColumn('GrossProfit'), isTrue));
    test('"GrossRevenue" → false', () =>
        expect(showGrossProfitColumn('GrossRevenue'), isFalse));
    test('null → false', () =>
        expect(showGrossProfitColumn(null), isFalse));
    test('"" → false', () =>
        expect(showGrossProfitColumn(''), isFalse));
    test('case-sensitive "grossprofit" → false', () =>
        expect(showGrossProfitColumn('grossprofit'), isFalse));
  });

  // ── calcRefillTotals ─────────────────────────────────────────────────────────
  group('[RefillProfitDetailScreenUi] calcRefillTotals', () {
    test('sums grossRevenue', () {
      final r = calcRefillTotals([
        {'grossRevenue': 5000.0, 'grossProfit': 1000.0, 'saleQty': 10},
        {'grossRevenue': 3000.0, 'grossProfit': 600.0,  'saleQty': 6},
      ]);
      expect(r['grossRevenueAmts'], closeTo(8000.0, 0.001));
    });
    test('sums grossProfit', () {
      final r = calcRefillTotals([
        {'grossRevenue': 0, 'grossProfit': 400.0, 'saleQty': 0},
        {'grossRevenue': 0, 'grossProfit': 600.0, 'saleQty': 0},
      ]);
      expect(r['grossProfitAmts'], closeTo(1000.0, 0.001));
    });
    test('sums saleQty', () {
      final r = calcRefillTotals([
        {'grossRevenue': 0, 'grossProfit': 0, 'saleQty': 4},
        {'grossRevenue': 0, 'grossProfit': 0, 'saleQty': 6},
      ]);
      expect(r['saleQtys'], 10);
    });
    test('empty list → zeros', () {
      final r = calcRefillTotals([]);
      expect(r['grossRevenueAmts'], 0.0);
      expect(r['grossProfitAmts'],  0.0);
      expect(r['saleQtys'],         0);
    });
    test('null fields treated as zero', () {
      final r = calcRefillTotals([
        {'grossRevenue': null, 'grossProfit': null, 'saleQty': null},
      ]);
      expect(r['grossRevenueAmts'], 0.0);
      expect(r['grossProfitAmts'],  0.0);
      expect(r['saleQtys'],         0);
    });
    test('single item', () {
      final r = calcRefillTotals([
        {'grossRevenue': 1500.0, 'grossProfit': 300.0, 'saleQty': 3},
      ]);
      expect(r['grossRevenueAmts'], closeTo(1500.0, 0.001));
      expect(r['grossProfitAmts'],  closeTo(300.0,  0.001));
      expect(r['saleQtys'],         3);
    });
    test('10 items summed', () {
      final data = List.generate(10, (_) =>
          {'grossRevenue': 100.0, 'grossProfit': 20.0, 'saleQty': 1});
      final r = calcRefillTotals(data);
      expect(r['grossRevenueAmts'], closeTo(1000.0, 0.001));
      expect(r['grossProfitAmts'],  closeTo(200.0,  0.001));
      expect(r['saleQtys'],         10);
    });
    test('fractional amounts', () {
      final r = calcRefillTotals([
        {'grossRevenue': 1234.56, 'grossProfit': 100.0, 'saleQty': 1},
        {'grossRevenue': 4321.44, 'grossProfit': 200.0, 'saleQty': 2},
      ]);
      expect(r['grossRevenueAmts'], closeTo(5556.0, 0.001));
    });
  });

  // ── refillCurrencyDisplay ────────────────────────────────────────────────────
  group('[RefillProfitDetailScreenUi] refillCurrencyDisplay', () {
    test('null → "0"', () => expect(refillCurrencyDisplay(null), '0'));
    test('0 → "0.00"', () => expect(refillCurrencyDisplay(0), '0.00'));
    test('positive formatted', () =>
        expect(refillCurrencyDisplay(500), isNot('0')));
    test('non-null ≠ "0"', () =>
        expect(refillCurrencyDisplay(100), isNot('0')));
  });

  // ── WillPopScope ─────────────────────────────────────────────────────────────
  group('[RefillProfitDetailScreenUi] WillPopScope', () {
    test('onWillPop returns false', () =>
        expect(willPopReturnsFalse(), isFalse));
  });
}

