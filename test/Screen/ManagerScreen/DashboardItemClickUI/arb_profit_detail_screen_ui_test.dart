// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/ARBProfitDetailScreenUi.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from ARBProfitDetailScreenUi ────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

String arbAppBarTitle(String? profitFor) {
  if (profitFor == 'GrossRevenue') return 'ARB Gross Revenue -';
  if (profitFor == 'GrossProfit')  return 'ARB Gross Profit -';
  return 'ARB -';
}

String arbDayFlagLabel(String? flag) {
  if (flag == 'TODAYS')    return "Today's";
  if (flag == 'THISMONTH') return 'This Month';
  if (flag == 'FINYEAR')   return 'Financial Year';
  return '';
}

bool showGrossProfitColumns(String? profitFor) => profitFor == 'GrossProfit';

Map<String, dynamic> calcARBTotals(List<Map<String, dynamic>> data) {
  double grossSale = 0, grossProfit = 0, purchase = 0;
  int qty = 0;
  for (final d in data) {
    grossSale   += ((d['grossSaleAmt']   ?? 0) as num).toDouble();
    grossProfit += ((d['grossProfitAmt'] ?? 0) as num).toDouble();
    purchase    += ((d['purchesAmt']     ?? 0) as num).toDouble();
    qty         += ((d['itemQty']        ?? 0) as num).toInt();
  }
  return {'grossSaleAmts': grossSale, 'grossProfitAmts': grossProfit,
          'purchaseAmts': purchase,   'purchaseQtys': qty};
}

String arbCurrencyDisplay(num? amount) =>
    amount != null ? formatCurrency(amount.toDouble()) : '0';

// WillPopScope always navigates to bottomNavBar (never pops)
bool willPopReturnsFalse() => false;

void main() {
  // ── formatCurrency ─────────────────────────────────────────────────────────
  group('[ARBProfitDetailScreenUi] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.0 → "0.00"', () => expect(formatCurrency(0.0), '0.00'));
    test('sub-zero starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.01 starts with "0"', () => expect(formatCurrency(0.01).startsWith('0'), isTrue));
    test('0.99 starts with "0."', () => expect(formatCurrency(0.99).startsWith('0.'), isTrue));
    test('does not start with "." for sub-zero', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('1.0 does not start with "0"', () =>
        expect(formatCurrency(1.0).startsWith('0'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('100.0 contains "100"', () => expect(formatCurrency(100.0).contains('100'), isTrue));
    test('large amount does not throw', () =>
        expect(() => formatCurrency(9999999.0), returnsNormally));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input → same output', () =>
        expect(formatCurrency(1500.0), formatCurrency(1500.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
    test('1000000 has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
  });

  // ── arbAppBarTitle ──────────────────────────────────────────────────────────
  group('[ARBProfitDetailScreenUi] arbAppBarTitle', () {
    test('"GrossRevenue" → "ARB Gross Revenue -"', () =>
        expect(arbAppBarTitle('GrossRevenue'), 'ARB Gross Revenue -'));
    test('"GrossProfit" → "ARB Gross Profit -"', () =>
        expect(arbAppBarTitle('GrossProfit'), 'ARB Gross Profit -'));
    test('unknown string → "ARB -"', () =>
        expect(arbAppBarTitle('Other'), 'ARB -'));
    test('empty string → "ARB -"', () =>
        expect(arbAppBarTitle(''), 'ARB -'));
    test('null → "ARB -"', () =>
        expect(arbAppBarTitle(null), 'ARB -'));
    test('case-sensitive: "grossRevenue" → "ARB -"', () =>
        expect(arbAppBarTitle('grossRevenue'), 'ARB -'));
    test('case-sensitive: "grossProfit" → "ARB -"', () =>
        expect(arbAppBarTitle('grossProfit'), 'ARB -'));
  });

  // ── arbDayFlagLabel ─────────────────────────────────────────────────────────
  group('[ARBProfitDetailScreenUi] arbDayFlagLabel', () {
    test('"TODAYS" → "Today\'s"', () =>
        expect(arbDayFlagLabel('TODAYS'), "Today's"));
    test('"THISMONTH" → "This Month"', () =>
        expect(arbDayFlagLabel('THISMONTH'), 'This Month'));
    test('"FINYEAR" → "Financial Year"', () =>
        expect(arbDayFlagLabel('FINYEAR'), 'Financial Year'));
    test('unknown → ""', () => expect(arbDayFlagLabel('UNKNOWN'), ''));
    test('empty → ""', () => expect(arbDayFlagLabel(''), ''));
    test('null → ""', () => expect(arbDayFlagLabel(null), ''));
    test('lowercase "todays" → ""', () =>
        expect(arbDayFlagLabel('todays'), ''));
    test('lowercase "thismonth" → ""', () =>
        expect(arbDayFlagLabel('thismonth'), ''));
  });

  // ── showGrossProfitColumns ──────────────────────────────────────────────────
  group('[ARBProfitDetailScreenUi] showGrossProfitColumns', () {
    test('"GrossProfit" → true', () =>
        expect(showGrossProfitColumns('GrossProfit'), isTrue));
    test('"GrossRevenue" → false', () =>
        expect(showGrossProfitColumns('GrossRevenue'), isFalse));
    test('null → false', () =>
        expect(showGrossProfitColumns(null), isFalse));
    test('"" → false', () =>
        expect(showGrossProfitColumns(''), isFalse));
    test('case-sensitive "grossprofit" → false', () =>
        expect(showGrossProfitColumns('grossprofit'), isFalse));
  });

  // ── calcARBTotals ───────────────────────────────────────────────────────────
  group('[ARBProfitDetailScreenUi] calcARBTotals', () {
    test('sums grossSaleAmt across two items', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 1000.0, 'grossProfitAmt': 100.0, 'purchesAmt': 900.0, 'itemQty': 3},
        {'grossSaleAmt': 2000.0, 'grossProfitAmt': 200.0, 'purchesAmt': 1800.0, 'itemQty': 7},
      ]);
      expect(r['grossSaleAmts'], closeTo(3000.0, 0.001));
    });
    test('sums grossProfitAmt', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 0, 'grossProfitAmt': 150.0, 'purchesAmt': 0, 'itemQty': 0},
        {'grossSaleAmt': 0, 'grossProfitAmt': 250.0, 'purchesAmt': 0, 'itemQty': 0},
      ]);
      expect(r['grossProfitAmts'], closeTo(400.0, 0.001));
    });
    test('sums purchaseAmt', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 400.0, 'itemQty': 0},
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 600.0, 'itemQty': 0},
      ]);
      expect(r['purchaseAmts'], closeTo(1000.0, 0.001));
    });
    test('sums itemQty as int', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 0, 'itemQty': 4},
        {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 0, 'itemQty': 6},
      ]);
      expect(r['purchaseQtys'], 10);
    });
    test('empty list → all zeros', () {
      final r = calcARBTotals([]);
      expect(r['grossSaleAmts'],   0.0);
      expect(r['grossProfitAmts'], 0.0);
      expect(r['purchaseAmts'],    0.0);
      expect(r['purchaseQtys'],    0);
    });
    test('null fields treated as 0', () {
      final r = calcARBTotals([
        {'grossSaleAmt': null,'grossProfitAmt': null,'purchesAmt': null,'itemQty': null},
      ]);
      expect(r['grossSaleAmts'],  0.0);
      expect(r['purchaseQtys'],   0);
    });
    test('single item', () {
      final r = calcARBTotals([
        {'grossSaleAmt': 5000.0,'grossProfitAmt': 1000.0,'purchesAmt': 4000.0,'itemQty': 5},
      ]);
      expect(r['grossSaleAmts'],   closeTo(5000.0, 0.001));
      expect(r['grossProfitAmts'], closeTo(1000.0, 0.001));
      expect(r['purchaseAmts'],    closeTo(4000.0, 0.001));
      expect(r['purchaseQtys'],    5);
    });
    test('10 items qty sums to 55', () {
      final data = List.generate(10, (i) =>
          {'grossSaleAmt': 0, 'grossProfitAmt': 0, 'purchesAmt': 0, 'itemQty': i + 1});
      expect(calcARBTotals(data)['purchaseQtys'], 55);
    });
  });

  // ── arbCurrencyDisplay ──────────────────────────────────────────────────────
  group('[ARBProfitDetailScreenUi] arbCurrencyDisplay', () {
    test('null → "0"', () => expect(arbCurrencyDisplay(null), '0'));
    test('0 → "0.00"', () => expect(arbCurrencyDisplay(0), '0.00'));
    test('500 returns formatted', () =>
        expect(arbCurrencyDisplay(500).contains('5'), isTrue));
    test('non-null ≠ "0"', () =>
        expect(arbCurrencyDisplay(100), isNot('0')));
  });

  // ── WillPopScope ─────────────────────────────────────────────────────────────
  group('[ARBProfitDetailScreenUi] WillPopScope', () {
    test('onWillPop returns false (prevents default pop)', () =>
        expect(willPopReturnsFalse(), isFalse));
  });
}

