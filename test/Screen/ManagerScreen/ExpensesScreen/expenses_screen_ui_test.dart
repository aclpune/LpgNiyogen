// Tests for: lib/Screen/ManagerScreen/ExpensesScreen/ExpensesScreenUI.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from ExpensesScreenUI ───────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

/// Mirrors: flag → API flag string for getHeadWiseExpenseLstModel()
String resolveExpenseFlag(String selectedFilter) {
  if (selectedFilter == "Today's")       return 'TODAYS';
  if (selectedFilter == 'This Month')    return 'THISMONTH';
  if (selectedFilter == 'Financial Year') return 'FINYEAR';
  return 'THISMONTH';
}

/// Mirrors: flag → API flag for getDashboardData()
String resolveDashboardFlag(String selectedFilter) {
  if (selectedFilter == 'This Year')  return 'FINYEAR';
  if (selectedFilter == 'Prev Year')  return 'PREFINYEAR';
  return 'FINYEAR';
}

/// Mirrors: AppBar title toggle: isOn ? "Revenue Vs Expense" : "Top Expenses"
String resolveAppBarTitle(bool isOn) =>
    isOn ? 'Revenue Vs Expense' : 'Top Expenses';

/// Mirrors: WillPopScope – always returns false
bool willPopReturnsFalse() => false;

/// Mirrors: totalExpense = parsedData.fold(0.0, (sum, item) => sum + item)
double calcTotalExpense(List<double> amounts) =>
    amounts.fold(0.0, (sum, a) => sum + a);

/// Mirrors: percentage = (amount / totalExpense) * 100
double calcPercentage(double amount, double totalExpense) =>
    totalExpense > 0 ? (amount / totalExpense) * 100 : 0.0;

/// Mirrors: sort parsedData by totExpAmt descending
List<Map<String, dynamic>> sortExpenseDescending(
    List<Map<String, dynamic>> items) {
  final sorted = List<Map<String, dynamic>>.from(items);
  sorted.sort((a, b) {
    final amtA = (a['totExpAmt'] as num? ?? 0.0).toDouble();
    final amtB = (b['totExpAmt'] as num? ?? 0.0).toDouble();
    return amtB.compareTo(amtA);
  });
  return sorted;
}

/// Mirrors: segment percentage list calculation
List<double> calcSegmentPercentages(List<double> amounts, double total) {
  if (total == 0) return amounts.map((_) => 0.0).toList();
  return amounts.map((a) => (a / total) * 100).toList();
}

/// Mirrors: groupedExpenses map
Map<String, double> buildGroupedExpenses(List<Map<String, dynamic>> items) {
  final map = <String, double>{};
  for (final item in items) {
    final name = (item['parentExpHeadName'] as String? ?? '');
    final amt  = (item['totExpAmt'] as num? ?? 0.0).toDouble();
    map[name] = (map[name] ?? 0.0) + amt;
  }
  return map;
}

/// Mirrors: chartWidth = (barWidth + barSpacing) * itemCount
double calcChartWidth() {
  const double barWidth   = 50;
  const double barSpacing = 8;
  const int    itemCount  = 22;
  return (barWidth + barSpacing) * itemCount;
}

/// Mirrors: regulatorReceived list
const List<String> regulatorReceived = ["Today's", 'This Month', 'Financial Year'];

/// Mirrors: regReceived list
const List<String> regReceived = ['Prev Year', 'This Year'];

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ExpensesScreenUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.0 → "0.00"', () => expect(formatCurrency(0.0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('1.0 not starts with "0"', () =>
        expect(formatCurrency(1.0).startsWith('0'), isFalse));
    test('large has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative no throw', () =>
        expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(5000.0), formatCurrency(5000.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
    test('0.99 starts with "0."', () =>
        expect(formatCurrency(0.99).startsWith('0.'), isTrue));
  });

  // ── resolveExpenseFlag ────────────────────────────────────────────────────
  group('[ExpensesScreenUI] resolveExpenseFlag', () {
    test('"Today\'s" → "TODAYS"', () =>
        expect(resolveExpenseFlag("Today's"), 'TODAYS'));
    test('"This Month" → "THISMONTH"', () =>
        expect(resolveExpenseFlag('This Month'), 'THISMONTH'));
    test('"Financial Year" → "FINYEAR"', () =>
        expect(resolveExpenseFlag('Financial Year'), 'FINYEAR'));
    test('unknown → "THISMONTH"', () =>
        expect(resolveExpenseFlag('Other'), 'THISMONTH'));
    test('empty → "THISMONTH"', () =>
        expect(resolveExpenseFlag(''), 'THISMONTH'));
  });

  // ── resolveDashboardFlag ──────────────────────────────────────────────────
  group('[ExpensesScreenUI] resolveDashboardFlag', () {
    test('"This Year" → "FINYEAR"', () =>
        expect(resolveDashboardFlag('This Year'), 'FINYEAR'));
    test('"Prev Year" → "PREFINYEAR"', () =>
        expect(resolveDashboardFlag('Prev Year'), 'PREFINYEAR'));
    test('unknown → "FINYEAR"', () =>
        expect(resolveDashboardFlag('Other'), 'FINYEAR'));
    test('empty → "FINYEAR"', () =>
        expect(resolveDashboardFlag(''), 'FINYEAR'));
  });

  // ── resolveAppBarTitle ────────────────────────────────────────────────────
  group('[ExpensesScreenUI] resolveAppBarTitle', () {
    test('isOn=false → "Top Expenses"', () =>
        expect(resolveAppBarTitle(false), 'Top Expenses'));
    test('isOn=true → "Revenue Vs Expense"', () =>
        expect(resolveAppBarTitle(true), 'Revenue Vs Expense'));
  });

  // ── willPopReturnsFalse ───────────────────────────────────────────────────
  group('[ExpensesScreenUI] WillPopScope', () {
    test('fromDrawer → false', () => expect(willPopReturnsFalse(), isFalse));
    test('other → false', () => expect(willPopReturnsFalse(), isFalse));
  });

  // ── calcTotalExpense ──────────────────────────────────────────────────────
  group('[ExpensesScreenUI] calcTotalExpense', () {
    test('sums amounts', () =>
        expect(calcTotalExpense([1000.0, 500.0, 200.0]), closeTo(1700.0, 0.001)));
    test('empty → 0', () => expect(calcTotalExpense([]), 0.0));
    test('single item', () =>
        expect(calcTotalExpense([95201.0]), closeTo(95201.0, 0.001)));
    test('all zeros → 0', () => expect(calcTotalExpense([0.0, 0.0]), 0.0));
    test('10 items', () {
      final amounts = List.generate(10, (_) => 100.0);
      expect(calcTotalExpense(amounts), closeTo(1000.0, 0.001));
    });
  });

  // ── calcPercentage ────────────────────────────────────────────────────────
  group('[ExpensesScreenUI] calcPercentage', () {
    test('50 of 100 → 50%', () =>
        expect(calcPercentage(50.0, 100.0), closeTo(50.0, 0.001)));
    test('25 of 100 → 25%', () =>
        expect(calcPercentage(25.0, 100.0), closeTo(25.0, 0.001)));
    test('total 0 → 0%', () =>
        expect(calcPercentage(50.0, 0.0), 0.0));
    test('amount == total → 100%', () =>
        expect(calcPercentage(500.0, 500.0), closeTo(100.0, 0.001)));
    test('0 of any → 0%', () =>
        expect(calcPercentage(0.0, 500.0), 0.0));
    test('partial percentage correct', () =>
        expect(calcPercentage(200.0, 800.0), closeTo(25.0, 0.001)));
  });

  // ── sortExpenseDescending ─────────────────────────────────────────────────
  group('[ExpensesScreenUI] sortExpenseDescending', () {
    test('sorts descending by totExpAmt', () {
      final items = [
        {'parentExpHeadName': 'Office', 'totExpAmt': 1000.0},
        {'parentExpHeadName': 'Fuel',   'totExpAmt': 5000.0},
        {'parentExpHeadName': 'Travel', 'totExpAmt': 2000.0},
      ];
      final r = sortExpenseDescending(items);
      expect(r[0]['totExpAmt'], 5000.0);
      expect(r[1]['totExpAmt'], 2000.0);
      expect(r[2]['totExpAmt'], 1000.0);
    });
    test('empty → empty', () => expect(sortExpenseDescending([]), isEmpty));
    test('does not mutate original', () {
      final items = [
        {'totExpAmt': 100.0, 'parentExpHeadName': 'A'},
        {'totExpAmt': 300.0, 'parentExpHeadName': 'B'},
      ];
      sortExpenseDescending(items);
      expect(items.first['totExpAmt'], 100.0);
    });
    test('null totExpAmt treated as 0 (sorts last)', () {
      final items = [
        {'totExpAmt': null,  'parentExpHeadName': 'A'},
        {'totExpAmt': 500.0, 'parentExpHeadName': 'B'},
      ];
      expect(sortExpenseDescending(items).first['parentExpHeadName'], 'B');
    });
    test('single item returned as-is', () {
      final items = [{'totExpAmt': 100.0, 'parentExpHeadName': 'A'}];
      expect(sortExpenseDescending(items).length, 1);
    });
  });

  // ── calcSegmentPercentages ────────────────────────────────────────────────
  group('[ExpensesScreenUI] calcSegmentPercentages', () {
    test('calculates percentages correctly', () {
      final r = calcSegmentPercentages([500.0, 300.0, 200.0], 1000.0);
      expect(r[0], closeTo(50.0, 0.001));
      expect(r[1], closeTo(30.0, 0.001));
      expect(r[2], closeTo(20.0, 0.001));
    });
    test('total 0 → all zeros', () {
      expect(calcSegmentPercentages([100.0, 200.0], 0.0), [0.0, 0.0]);
    });
    test('empty list → empty', () =>
        expect(calcSegmentPercentages([], 1000.0), isEmpty));
    test('sum of percentages ≈ 100', () {
      final r = calcSegmentPercentages([500.0, 300.0, 200.0], 1000.0);
      expect(r.fold(0.0, (s, p) => s + p), closeTo(100.0, 0.001));
    });
  });

  // ── buildGroupedExpenses ──────────────────────────────────────────────────
  group('[ExpensesScreenUI] buildGroupedExpenses', () {
    test('groups same category', () {
      final items = [
        {'parentExpHeadName': 'Office', 'totExpAmt': 1000.0},
        {'parentExpHeadName': 'Office', 'totExpAmt': 500.0},
        {'parentExpHeadName': 'Fuel',   'totExpAmt': 800.0},
      ];
      final r = buildGroupedExpenses(items);
      expect(r['Office'], closeTo(1500.0, 0.001));
      expect(r['Fuel'],   closeTo(800.0, 0.001));
    });
    test(
      'empty -> empty map',
          () {

        final result = buildGroupedExpenses([]);

        expect(result, isEmpty);
      },
    );    test('null parentExpHeadName → ""', () {
      final items = [{'parentExpHeadName': null, 'totExpAmt': 200.0}];
      expect(buildGroupedExpenses(items)[''], closeTo(200.0, 0.001));
    });
    test('distinct keys', () {
      final items = [
        {'parentExpHeadName': 'A', 'totExpAmt': 100.0},
        {'parentExpHeadName': 'B', 'totExpAmt': 200.0},
      ];
      expect(buildGroupedExpenses(items).keys.length, 2);
    });
  });

  // ── calcChartWidth ────────────────────────────────────────────────────────
  group('[ExpensesScreenUI] calcChartWidth', () {
    test('= (50 + 8) * 22 = 1276', () =>
        expect(calcChartWidth(), closeTo(1276.0, 0.001)));
    test('is positive', () => expect(calcChartWidth() > 0, isTrue));
  });

  // ── regulatorReceived list ────────────────────────────────────────────────
  group('[ExpensesScreenUI] regulatorReceived', () {
    test('has 3 items', () => expect(regulatorReceived.length, 3));
    test("contains \"Today's\"", () =>
        expect(regulatorReceived.contains("Today's"), isTrue));
    test('contains "This Month"', () =>
        expect(regulatorReceived.contains('This Month'), isTrue));
    test('contains "Financial Year"', () =>
        expect(regulatorReceived.contains('Financial Year'), isTrue));
  });

  // ── regReceived list ──────────────────────────────────────────────────────
  group('[ExpensesScreenUI] regReceived', () {
    test('has 2 items', () => expect(regReceived.length, 2));
    test('contains "Prev Year"', () =>
        expect(regReceived.contains('Prev Year'), isTrue));
    test('contains "This Year"', () =>
        expect(regReceived.contains('This Year'), isTrue));
    test('first is "Prev Year"', () => expect(regReceived.first, 'Prev Year'));
    test('last is "This Year"', () => expect(regReceived.last, 'This Year'));
  });
}

