// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerDSRReportScreenDetails.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerDSRReportScreenDetails ──────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

String buildAppBarTitle(String? screenMode) {
  if (screenMode == null) return 'Details';
  return '${capitalize(screenMode.toLowerCase())} Details';
}

String modeColorName(String? screenMode) {
  switch (screenMode) {
    case 'Cash':     return 'green';
    case 'MERCHANT': return 'teal';
    case 'Credit':   return 'amber';
    case 'PREPAID':  return 'orange';
    case 'Expenses': return 'red';
    default:         return 'blue';
  }
}

String modeIconName(String? screenMode) {
  switch (screenMode) {
    case 'Cash':     return 'payments_rounded';
    case 'MERCHANT': return 'qr_code_rounded';
    case 'Credit':   return 'credit_card_rounded';
    case 'PREPAID':  return 'online_prediction_rounded';
    case 'Expenses': return 'receipt_long_rounded';
    default:         return 'bar_chart_rounded';
  }
}

String headerAmountLabel(String? mode) =>
    mode == 'Expenses' ? 'Cash / Bank' : 'Amount';

String headerItemLabel(String? mode) =>
    mode == 'Expenses' ? 'Expense Head' : 'Item Name';

double getTotalCash(List<Map<String, dynamic>> items) =>
    items.fold(0.0, (s, i) => s + ((i['cashAmt'] ?? 0.0) as num).toDouble());

double getTotalBank(List<Map<String, dynamic>> items) =>
    items.fold(0.0, (s, i) => s + ((i['merchantQR'] ?? 0.0) as num).toDouble());

double getTotalCredit(List<Map<String, dynamic>> items) =>
    items.fold(0.0, (s, i) => s + ((i['creditAmt'] ?? 0.0) as num).toDouble());

double getTotalPrepaid(List<Map<String, dynamic>> items) =>
    items.fold(0.0, (s, i) => s + ((i['prepaidAmt'] ?? 0.0) as num).toDouble());

double getExpenseCash(List<Map<String, dynamic>> items) =>
    items.fold(0.0, (s, i) => s + ((i['cash'] ?? 0.0) as num).toDouble());

double getExpenseBank(List<Map<String, dynamic>> items) =>
    items.fold(0.0, (s, i) => s + ((i['bank'] ?? 0.0) as num).toDouble());

List<Map<String, dynamic>> filterByMode(
    List<Map<String, dynamic>> items, String mode) {
  switch (mode) {
    case 'Cash':     return items.where((i) => ((i['cashAmt']    ?? 0) as num) > 0).toList();
    case 'MERCHANT': return items.where((i) => ((i['merchantQR'] ?? 0) as num) > 0).toList();
    case 'Credit':   return items.where((i) => ((i['creditAmt']  ?? 0) as num) > 0).toList();
    case 'PREPAID':  return items.where((i) => ((i['prepaidAmt'] ?? 0) as num) > 0).toList();
    default:         return items;
  }
}

String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative no throw', () => expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () => expect(formatCurrency(500.0), formatCurrency(500.0)));
  });

  // ── capitalize ────────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] capitalize', () {
    test('"cash" → "Cash"', () => expect(capitalize('cash'), 'Cash'));
    test('"expenses" → "Expenses"', () => expect(capitalize('expenses'), 'Expenses'));
    test('"merchant" → "Merchant"', () => expect(capitalize('merchant'), 'Merchant'));
    test('empty → ""', () => expect(capitalize(''), ''));
    test('already capitalized unchanged', () => expect(capitalize('Cash'), 'Cash'));
    test('single char capitalized', () => expect(capitalize('c'), 'C'));
  });

  // ── buildAppBarTitle ──────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] buildAppBarTitle', () {
    test('"Cash" → "Cash Details"', () => expect(buildAppBarTitle('Cash'), 'Cash Details'));
    test('"MERCHANT" → "Merchant Details"', () => expect(buildAppBarTitle('MERCHANT'), 'Merchant Details'));
    test('"Credit" → "Credit Details"', () => expect(buildAppBarTitle('Credit'), 'Credit Details'));
    test('"PREPAID" → "Prepaid Details"', () => expect(buildAppBarTitle('PREPAID'), 'Prepaid Details'));
    test('"Expenses" → "Expenses Details"', () => expect(buildAppBarTitle('Expenses'), 'Expenses Details'));
    test('null → "Details"', () => expect(buildAppBarTitle(null), 'Details'));
  });

  // ── modeColorName ─────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] modeColorName', () {
    test('Cash → green', () => expect(modeColorName('Cash'), 'green'));
    test('MERCHANT → teal', () => expect(modeColorName('MERCHANT'), 'teal'));
    test('Credit → amber', () => expect(modeColorName('Credit'), 'amber'));
    test('PREPAID → orange', () => expect(modeColorName('PREPAID'), 'orange'));
    test('Expenses → red', () => expect(modeColorName('Expenses'), 'red'));
    test('unknown → blue', () => expect(modeColorName('Unknown'), 'blue'));
    test('null → blue', () => expect(modeColorName(null), 'blue'));
  });

  // ── modeIconName ──────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] modeIconName', () {
    test('Cash icon', () => expect(modeIconName('Cash'), 'payments_rounded'));
    test('MERCHANT icon', () => expect(modeIconName('MERCHANT'), 'qr_code_rounded'));
    test('Credit icon', () => expect(modeIconName('Credit'), 'credit_card_rounded'));
    test('PREPAID icon', () => expect(modeIconName('PREPAID'), 'online_prediction_rounded'));
    test('Expenses icon', () => expect(modeIconName('Expenses'), 'receipt_long_rounded'));
    test('unknown → bar_chart', () => expect(modeIconName('Other'), 'bar_chart_rounded'));
  });

  // ── headerLabels ──────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] headerLabels', () {
    test('Expenses amount label → "Cash / Bank"', () => expect(headerAmountLabel('Expenses'), 'Cash / Bank'));
    test('Cash amount label → "Amount"', () => expect(headerAmountLabel('Cash'), 'Amount'));
    test('null → "Amount"', () => expect(headerAmountLabel(null), 'Amount'));
    test('Expenses item label → "Expense Head"', () => expect(headerItemLabel('Expenses'), 'Expense Head'));
    test('Cash item label → "Item Name"', () => expect(headerItemLabel('Cash'), 'Item Name'));
  });

  // ── getTotalCash ──────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] getTotalCash', () {
    test('sums cashAmt', () {
      final items = [{'cashAmt': 1000.0}, {'cashAmt': 500.0}];
      expect(getTotalCash(items), closeTo(1500.0, 0.001));
    });
    test('null cashAmt treated as 0', () {
      expect(getTotalCash([{'cashAmt': null}]), 0.0);
    });
    test('empty → 0', () => expect(getTotalCash([]), 0.0));
  });

  // ── getTotalBank ──────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] getTotalBank', () {
    test('sums merchantQR', () {
      final items = [{'merchantQR': 800.0}, {'merchantQR': 200.0}];
      expect(getTotalBank(items), closeTo(1000.0, 0.001));
    });
    test('null merchantQR → 0', () => expect(getTotalBank([{'merchantQR': null}]), 0.0));
    test('empty → 0', () => expect(getTotalBank([]), 0.0));
  });

  // ── getTotalCredit ────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] getTotalCredit', () {
    test('sums creditAmt', () {
      final items = [{'creditAmt': 600.0}, {'creditAmt': 400.0}];
      expect(getTotalCredit(items), closeTo(1000.0, 0.001));
    });
    test('empty → 0', () => expect(getTotalCredit([]), 0.0));
  });

  // ── getTotalPrepaid ───────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] getTotalPrepaid', () {
    test('sums prepaidAmt', () {
      final items = [{'prepaidAmt': 300.0}, {'prepaidAmt': 700.0}];
      expect(getTotalPrepaid(items), closeTo(1000.0, 0.001));
    });
    test('empty → 0', () => expect(getTotalPrepaid([]), 0.0));
  });

  // ── getExpenseCash / getExpenseBank ───────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] getExpenseCash', () {
    test('sums cash field', () {
      expect(getExpenseCash([{'cash': 200.0}, {'cash': 300.0}]), closeTo(500.0, 0.001));
    });
    test('empty → 0', () => expect(getExpenseCash([]), 0.0));
  });

  group('[ManagerDSRReportScreenDetails] getExpenseBank', () {
    test('sums bank field', () {
      expect(getExpenseBank([{'bank': 100.0}, {'bank': 400.0}]), closeTo(500.0, 0.001));
    });
    test('empty → 0', () => expect(getExpenseBank([]), 0.0));
  });

  // ── filterByMode ──────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] filterByMode', () {
    final items = [
      {'cashAmt': 500.0, 'merchantQR': 0.0,   'creditAmt': 0.0,   'prepaidAmt': 0.0},
      {'cashAmt': 0.0,   'merchantQR': 300.0,  'creditAmt': 0.0,   'prepaidAmt': 0.0},
      {'cashAmt': 0.0,   'merchantQR': 0.0,    'creditAmt': 200.0, 'prepaidAmt': 0.0},
      {'cashAmt': 0.0,   'merchantQR': 0.0,    'creditAmt': 0.0,   'prepaidAmt': 100.0},
    ];
    test('Cash mode filters cashAmt > 0', () => expect(filterByMode(items, 'Cash').length, 1));
    test('MERCHANT mode', () => expect(filterByMode(items, 'MERCHANT').length, 1));
    test('Credit mode', () => expect(filterByMode(items, 'Credit').length, 1));
    test('PREPAID mode', () => expect(filterByMode(items, 'PREPAID').length, 1));
    test('Expenses mode returns all', () => expect(filterByMode(items, 'Expenses').length, 4));
    test('empty list → empty', () => expect(filterByMode([], 'Cash'), isEmpty));
    test('all zero cashAmt → empty for Cash', () {
      final z = [{'cashAmt': 0.0}];
      expect(filterByMode(z, 'Cash'), isEmpty);
    });
  });

  // ── formatDate ────────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenDetails] formatDate', () {
    test('formats correctly', () => expect(formatDate(DateTime(2025, 4, 7)), '2025-04-07'));
    test('end of year', () => expect(formatDate(DateTime(2025, 12, 31)), '2025-12-31'));
  });
}

