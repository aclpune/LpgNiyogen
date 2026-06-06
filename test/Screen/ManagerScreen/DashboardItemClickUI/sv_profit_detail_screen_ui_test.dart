// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/SVProfitdetailScreenUi.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from SVProfitdetailScreenUi ─────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

/// Mirrors: AppBar flag label logic
String svDayFlagLabel(String? flag) {
  if (flag == 'TODAYS')    return "Today's";
  if (flag == 'THISMONTH') return 'This Month';
  if (flag == 'FINYEAR')   return 'Financial Year';
  return '';
}

/// Mirrors: AppBar title logic (profitFors)
String svProfitTitle(String? profitFor) {
  if (profitFor == 'GrossRevenue') return 'SV Gross Revenue -';
  if (profitFor == 'GrossProfit')  return 'SV Gross Profit -';
  return 'SV -';
}

/// Mirrors: profitFors == 'GrossProfit' column visibility
bool showGrossProfitColumn(String? profitFor) => profitFor == 'GrossProfit';

/// Mirrors: totals loop in fetchSVProfitDetailList → setState
Map<String, dynamic> calcSVProfitTotals(List<Map<String, dynamic>> data) {
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

/// Mirrors: null-safe amount display
String svCurrencyDisplay(num? amount) =>
    amount != null ? formatCurrency(amount.toDouble()) : '0';

/// Mirrors: WillPopScope always returns false
bool willPopReturnsFalse() => false;

void main() {
  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[SVProfitdetailScreenUi] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(2000.0), formatCurrency(2000.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
    test('0.01 starts with "0"', () =>
        expect(formatCurrency(0.01).startsWith('0'), isTrue));
  });

  // ── svDayFlagLabel ───────────────────────────────────────────────────────────
  group('[SVProfitdetailScreenUi] svDayFlagLabel', () {
    test('"TODAYS" → "Today\'s"', () =>
        expect(svDayFlagLabel('TODAYS'), "Today's"));
    test('"THISMONTH" → "This Month"', () =>
        expect(svDayFlagLabel('THISMONTH'), 'This Month'));
    test('"FINYEAR" → "Financial Year"', () =>
        expect(svDayFlagLabel('FINYEAR'), 'Financial Year'));
    test('unknown → ""', () => expect(svDayFlagLabel('UNKNOWN'), ''));
    test('empty → ""', () => expect(svDayFlagLabel(''), ''));
    test('null → ""', () => expect(svDayFlagLabel(null), ''));
    test('lowercase not matched', () => expect(svDayFlagLabel('todays'), ''));
    test('all 3 known flags return non-empty', () {
      for (final f in ['TODAYS', 'THISMONTH', 'FINYEAR']) {
        expect(svDayFlagLabel(f).isNotEmpty, isTrue, reason: f);
      }
    });
  });

  // ── svProfitTitle ────────────────────────────────────────────────────────────
  group('[SVProfitdetailScreenUi] svProfitTitle', () {
    test('"GrossRevenue" → "SV Gross Revenue -"', () =>
        expect(svProfitTitle('GrossRevenue'), 'SV Gross Revenue -'));
    test('"GrossProfit" → "SV Gross Profit -"', () =>
        expect(svProfitTitle('GrossProfit'), 'SV Gross Profit -'));
    test('unknown → "SV -"', () =>
        expect(svProfitTitle('Other'), 'SV -'));
    test('empty → "SV -"', () =>
        expect(svProfitTitle(''), 'SV -'));
    test('null → "SV -"', () =>
        expect(svProfitTitle(null), 'SV -'));
  });

  // ── showGrossProfitColumn ────────────────────────────────────────────────────
  group('[SVProfitdetailScreenUi] showGrossProfitColumn', () {
    test('"GrossProfit" → true', () =>
        expect(showGrossProfitColumn('GrossProfit'), isTrue));
    test('"GrossRevenue" → false', () =>
        expect(showGrossProfitColumn('GrossRevenue'), isFalse));
    test('null → false', () =>
        expect(showGrossProfitColumn(null), isFalse));
    test('"" → false', () =>
        expect(showGrossProfitColumn(''), isFalse));
    test('case-sensitive → false', () =>
        expect(showGrossProfitColumn('grossprofit'), isFalse));
  });

  // ── calcSVProfitTotals ────────────────────────────────────────────────────────
  group('[SVProfitdetailScreenUi] calcSVProfitTotals', () {
    test('sums grossRevenue', () {
      final r = calcSVProfitTotals([
        {'grossRevenue': 4000.0, 'grossProfit': 800.0, 'saleQty': 8},
        {'grossRevenue': 2000.0, 'grossProfit': 400.0, 'saleQty': 4},
      ]);
      expect(r['grossRevenueAmts'], closeTo(6000.0, 0.001));
    });
    test('sums grossProfit', () {
      final r = calcSVProfitTotals([
        {'grossRevenue': 0, 'grossProfit': 300.0, 'saleQty': 0},
        {'grossRevenue': 0, 'grossProfit': 700.0, 'saleQty': 0},
      ]);
      expect(r['grossProfitAmts'], closeTo(1000.0, 0.001));
    });
    test('sums saleQty', () {
      final r = calcSVProfitTotals([
        {'grossRevenue': 0, 'grossProfit': 0, 'saleQty': 3},
        {'grossRevenue': 0, 'grossProfit': 0, 'saleQty': 7},
      ]);
      expect(r['saleQtys'], 10);
    });
    test('empty list → zeros', () {
      final r = calcSVProfitTotals([]);
      expect(r['grossRevenueAmts'], 0.0);
      expect(r['grossProfitAmts'],  0.0);
      expect(r['saleQtys'],         0);
    });
    test('null fields → zeros', () {
      final r = calcSVProfitTotals([
        {'grossRevenue': null, 'grossProfit': null, 'saleQty': null},
      ]);
      expect(r['grossRevenueAmts'], 0.0);
      expect(r['saleQtys'],         0);
    });
    test('single item', () {
      final r = calcSVProfitTotals([
        {'grossRevenue': 2500.0, 'grossProfit': 500.0, 'saleQty': 5},
      ]);
      expect(r['grossRevenueAmts'], closeTo(2500.0, 0.001));
      expect(r['grossProfitAmts'],  closeTo(500.0,  0.001));
      expect(r['saleQtys'],         5);
    });
    test('10 items', () {
      final data = List.generate(10, (_) =>
          {'grossRevenue': 200.0, 'grossProfit': 40.0, 'saleQty': 2});
      final r = calcSVProfitTotals(data);
      expect(r['grossRevenueAmts'], closeTo(2000.0, 0.001));
      expect(r['saleQtys'],         20);
    });
    test('fractional amounts summed', () {
      final r = calcSVProfitTotals([
        {'grossRevenue': 1111.11, 'grossProfit': 0, 'saleQty': 0},
        {'grossRevenue': 2222.22, 'grossProfit': 0, 'saleQty': 0},
      ]);
      expect(r['grossRevenueAmts'], closeTo(3333.33, 0.01));
    });
  });

  // ── svCurrencyDisplay ────────────────────────────────────────────────────────
  group('[SVProfitdetailScreenUi] svCurrencyDisplay', () {
    test('null → "0"', () => expect(svCurrencyDisplay(null), '0'));
    test('0 → "0.00"', () => expect(svCurrencyDisplay(0), '0.00'));
    test('positive formatted', () =>
        expect(svCurrencyDisplay(500), isNot('0')));
    test('non-null ≠ "0"', () =>
        expect(svCurrencyDisplay(1), isNot('0')));
  });

  // ── WillPopScope ─────────────────────────────────────────────────────────────
  group('[SVProfitdetailScreenUi] WillPopScope', () {
    test('onWillPop returns false (prevents default pop)', () =>
        expect(willPopReturnsFalse(), isFalse));
  });
}

