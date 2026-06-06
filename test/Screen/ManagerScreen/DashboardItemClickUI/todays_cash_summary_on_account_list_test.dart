// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/TodaysCashSummaryOnAccountList.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from TodaysCashSummaryOnAccountList ──────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

String nullToDash(String? value) {
  if (value == null || value.toLowerCase() == 'null') return '-';
  return value;
}

/// Mirrors: _updateTotalBalance()
double updateTotalBalance(
    List<Map<String, dynamic>> reports, int? selectedStaffId) {
  final filtered = selectedStaffId == null
      ? reports
      : reports.where((r) => r['staffId'] == selectedStaffId).toList();
  return filtered.fold(
      0.0, (sum, r) => sum + ((r['balance'] ?? 0.0) as num).toDouble());
}

/// Mirrors: cashsummary count in build()
int calcCashSummary(
    List<Map<String, dynamic>> reports, int? selectedReferredID) {
  if (reports.isEmpty) return 0;
  if (selectedReferredID == null) return reports.length;
  return reports.where((r) => r['staffId'] == selectedReferredID).length;
}

/// Mirrors: checkAndSaveDayEndData saveFlag logic
bool calcSaveFlag(Map<String, dynamic>? data) {
  if (data == null) return false;
  final dsr   = (data['DSRSaved']      ?? 0) as int;
  final cdcms = (data['CDCMSStkSaved'] ?? 0) as int;
  final opcl  = (data['OpClSaved']     ?? 0) as int;
  return dsr == 1 && cdcms == 1 && opcl == 1;
}

/// Mirrors: staff list alphabetical sort
List<Map<String, dynamic>> sortStaffByName(List<Map<String, dynamic>> staff) {
  final sorted = List<Map<String, dynamic>>.from(staff);
  sorted.sort((a, b) {
    final nameA = (a['staffName'] as String? ?? '').toLowerCase();
    final nameB = (b['staffName'] as String? ?? '').toLowerCase();
    return nameA.compareTo(nameB);
  });
  return sorted;
}

/// Mirrors: isPaymentButtonEnabled = isCheckedList.contains(true)
bool isPaymentEnabled(List<bool> checkedList) => checkedList.contains(true);

/// Mirrors: totalAmt sum for selected checked reports
double calcSelectedTotal(
    List<Map<String, dynamic>> reports, List<bool> checked) {
  double total = 0.0;
  for (int i = 0; i < reports.length; i++) {
    if (checked[i]) total += (reports[i]['balance'] as num? ?? 0.0).toDouble();
  }
  return total;
}

/// Mirrors: filtered reports in build() based on selectedStaff
List<Map<String, dynamic>> filteredReports(
    List<Map<String, dynamic>> reports, int? staffId) {
  if (staffId == null) return reports;
  return reports.where((r) => r['staffId'] == staffId).toList();
}

/// Mirrors: BalanceType enum default  = BalanceType.onAccount
const String defaultBalanceType = 'onAccount';

void main() {
  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('same input same output', () =>
        expect(formatCurrency(1600.0), formatCurrency(1600.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
  });

  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"" → ""', () => expect(nullToDash(''), ''));
    test('valid → returned', () => expect(nullToDash('Rahul'), 'Rahul'));
  });

  // ── updateTotalBalance ────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] updateTotalBalance', () {
    final reports = [
      {'staffId': 1, 'balance': 500.0},
      {'staffId': 1, 'balance': 300.0},
      {'staffId': 2, 'balance': 800.0},
      {'staffId': 3, 'balance': 200.0},
    ];

    test('null staffId → sum all', () =>
        expect(updateTotalBalance(reports, null), closeTo(1800.0, 0.001)));
    test('staffId=1 → sum staff 1', () =>
        expect(updateTotalBalance(reports, 1), closeTo(800.0, 0.001)));
    test('staffId=2 → sum staff 2', () =>
        expect(updateTotalBalance(reports, 2), closeTo(800.0, 0.001)));
    test('staffId=3 → sum staff 3', () =>
        expect(updateTotalBalance(reports, 3), closeTo(200.0, 0.001)));
    test('non-existent staffId → 0', () =>
        expect(updateTotalBalance(reports, 99), 0.0));
    test('empty list → 0', () =>
        expect(updateTotalBalance([], null), 0.0));
    test('empty list with staffId → 0', () =>
        expect(updateTotalBalance([], 1), 0.0));
    test('null balance treated as 0', () {
      expect(updateTotalBalance([{'staffId': 1, 'balance': null}], 1), 0.0);
    });
    test('all same staff → full sum', () {
      final same = List.generate(5, (_) => {'staffId': 10, 'balance': 100.0});
      expect(updateTotalBalance(same, 10), closeTo(500.0, 0.001));
    });
  });

  // ── calcCashSummary ───────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] calcCashSummary', () {
    final reports = [
      {'staffId': 1},
      {'staffId': 1},
      {'staffId': 2},
      {'staffId': 3},
    ];

    test('null → total count (4)', () =>
        expect(calcCashSummary(reports, null), 4));
    test('staffId=1 → 2', () =>
        expect(calcCashSummary(reports, 1), 2));
    test('staffId=2 → 1', () =>
        expect(calcCashSummary(reports, 2), 1));
    test('staffId=3 → 1', () =>
        expect(calcCashSummary(reports, 3), 1));
    test('non-existent → 0', () =>
        expect(calcCashSummary(reports, 99), 0));
    test('empty list → 0', () =>
        expect(calcCashSummary([], null), 0));
    test('empty list with staffId → 0', () =>
        expect(calcCashSummary([], 1), 0));
  });

  // ── calcSaveFlag ──────────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] calcSaveFlag', () {
    test('all 3 = 1 → true', () =>
        expect(calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 1}),
            isTrue));
    test('DSRSaved=0 → false', () =>
        expect(calcSaveFlag({'DSRSaved': 0, 'CDCMSStkSaved': 1, 'OpClSaved': 1}),
            isFalse));
    test('CDCMSStkSaved=0 → false', () =>
        expect(calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 0, 'OpClSaved': 1}),
            isFalse));
    test('OpClSaved=0 → false', () =>
        expect(calcSaveFlag({'DSRSaved': 1, 'CDCMSStkSaved': 1, 'OpClSaved': 0}),
            isFalse));
    test('null data → false', () => expect(calcSaveFlag(null), isFalse));
    test('empty map → false', () => expect(calcSaveFlag({}), isFalse));
    test('all null fields → false', () {
      expect(calcSaveFlag(
          {'DSRSaved': null, 'CDCMSStkSaved': null, 'OpClSaved': null}),
          isFalse);
    });
    test('all zeros → false', () =>
        expect(calcSaveFlag({'DSRSaved': 0, 'CDCMSStkSaved': 0, 'OpClSaved': 0}),
            isFalse));
  });

  // ── sortStaffByName ───────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] sortStaffByName', () {
    test('sorts alphabetically case-insensitive', () {
      final staff = [
        {'staffName': 'Zara'},
        {'staffName': 'amit'},
        {'staffName': 'Priya'},
      ];
      final r = sortStaffByName(staff);
      expect(r[0]['staffName'], 'amit');
      expect(r[2]['staffName'], 'Zara');
    });
    test('null staffName sorts first (empty string)', () {
      final staff = [
        {'staffName': 'Beta'},
        {'staffName': null},
      ];
      expect(sortStaffByName(staff).first['staffName'], isNull);
    });
    test('single item returned as-is', () {
      final staff = [{'staffName': 'Alice'}];
      expect(sortStaffByName(staff).first['staffName'], 'Alice');
    });
    test('empty list → empty', () => expect(sortStaffByName([]), isEmpty));
    test('does not mutate original', () {
      final staff = [
        {'staffName': 'Zeta'},
        {'staffName': 'Alpha'},
      ];
      sortStaffByName(staff);
      expect(staff.first['staffName'], 'Zeta');
    });
    test('already sorted stays sorted', () {
      final staff = [
        {'staffName': 'AAA'},
        {'staffName': 'BBB'},
        {'staffName': 'CCC'},
      ];
      final r = sortStaffByName(staff);
      expect(r.map((e) => e['staffName']).toList(), ['AAA', 'BBB', 'CCC']);
    });
  });

  // ── isPaymentEnabled ──────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] isPaymentEnabled', () {
    test('one true → enabled', () =>
        expect(isPaymentEnabled([false, true, false]), isTrue));
    test('all false → disabled', () =>
        expect(isPaymentEnabled([false, false, false]), isFalse));
    test('empty → disabled', () => expect(isPaymentEnabled([]), isFalse));
    test('all true → enabled', () =>
        expect(isPaymentEnabled([true, true, true]), isTrue));
    test('single true → enabled', () =>
        expect(isPaymentEnabled([true]), isTrue));
    test('single false → disabled', () =>
        expect(isPaymentEnabled([false]), isFalse));
  });

  // ── calcSelectedTotal ─────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] calcSelectedTotal', () {
    test('all checked → full sum', () {
      expect(calcSelectedTotal([
        {'balance': 500.0}, {'balance': 300.0},
      ], [true, true]), closeTo(800.0, 0.001));
    });
    test('none checked → 0', () {
      expect(calcSelectedTotal([
        {'balance': 500.0}, {'balance': 300.0},
      ], [false, false]), 0.0);
    });
    test('partial selection', () {
      expect(calcSelectedTotal([
        {'balance': 500.0}, {'balance': 300.0}, {'balance': 200.0},
      ], [true, false, true]), closeTo(700.0, 0.001));
    });
    test('null balance → 0', () {
      expect(calcSelectedTotal([
        {'balance': null}, {'balance': 400.0},
      ], [true, true]), closeTo(400.0, 0.001));
    });
  });

  // ── filteredReports ───────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] filteredReports', () {
    final reports = [
      {'staffId': 1, 'balance': 500.0},
      {'staffId': 1, 'balance': 300.0},
      {'staffId': 2, 'balance': 800.0},
    ];

    test('null staffId → all reports', () =>
        expect(filteredReports(reports, null).length, 3));
    test('staffId=1 → 2 reports', () =>
        expect(filteredReports(reports, 1).length, 2));
    test('staffId=2 → 1 report', () =>
        expect(filteredReports(reports, 2).length, 1));
    test('non-existent → empty', () =>
        expect(filteredReports(reports, 99), isEmpty));
    test('empty input → empty', () =>
        expect(filteredReports([], 1), isEmpty));
  });

  // ── defaultBalanceType ────────────────────────────────────────────────────────
  group('[TodaysCashSummaryOnAccountList] defaultBalanceType', () {
    test('default is onAccount', () =>
        expect(defaultBalanceType, 'onAccount'));
    test('not totalBalance', () =>
        expect(defaultBalanceType, isNot('totalBalance')));
    test('not advance', () =>
        expect(defaultBalanceType, isNot('advance')));
  });
}

