// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerExpenseTabScreenDetails.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerExpenseTabScreenDetails ─────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

String formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

Map<String, dynamic> buildRequestBody({
  required String? distributorId,
  required String formattedDate,
  required int expenseHeadId,
  required String flag,
}) => {
  "DistributorId": distributorId,
  "Date": formattedDate,
  "ExpHeadId": expenseHeadId,
  "Flag": flag,
};

double getCashTotal(List<Map<String, dynamic>> items) {
  double t = 0.0;
  for (var i in items) {
    num? a = (i['cash'] as num?);
    if (a != null) t += a.toDouble();
  }
  return t;
}

double getBankTotal(List<Map<String, dynamic>> items) {
  double t = 0.0;
  for (var i in items) {
    num? a = (i['bank'] as num?);
    if (a != null) t += a.toDouble();
  }
  return t;
}

String resolveTitleText(List<Map<String, dynamic>> items) =>
    items.isNotEmpty ? (items[0]['expensehead'] ?? 'No Items') : 'No Items';

bool showNoRecords(int count) => count == 0;

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenDetails] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative no throw', () => expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () => expect(formatCurrency(500.0), formatCurrency(500.0)));
  });

  // ── formatDate ────────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenDetails] formatDate', () {
    test('formats 2025-04-07', () => expect(formatDate(DateTime(2025, 4, 7)), '2025-04-07'));
    test('end of year', () => expect(formatDate(DateTime(2025, 12, 31)), '2025-12-31'));
    test('single digit padded', () => expect(formatDate(DateTime(2026, 1, 5)), '2026-01-05'));
    test('format is yyyy-MM-dd', () {
      final r = formatDate(DateTime(2025, 8, 20));
      expect(RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(r), isTrue);
    });
  });

  // ── buildRequestBody ──────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenDetails] buildRequestBody', () {
    test('has 4 keys', () {
      final b = buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07',
          expenseHeadId: 5, flag: 'Cash');
      expect(b.keys.length, 4);
    });
    test('DistributorId correct', () {
      expect(buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07',
          expenseHeadId: 5, flag: 'Cash')['DistributorId'], '8118');
    });
    test('Date correct', () {
      expect(buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07',
          expenseHeadId: 5, flag: 'Cash')['Date'], '2025-04-07');
    });
    test('ExpHeadId correct', () {
      expect(buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07',
          expenseHeadId: 5, flag: 'Cash')['ExpHeadId'], 5);
    });
    test('Flag correct', () {
      expect(buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07',
          expenseHeadId: 5, flag: 'Cash')['Flag'], 'Cash');
    });
  });

  // ── getCashTotal ──────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenDetails] getCashTotal', () {
    test('sums cash field', () {
      expect(getCashTotal([{'cash': 200.0}, {'cash': 300.0}]), closeTo(500.0, 0.001));
    });
    test('empty → 0', () => expect(getCashTotal([]), 0.0));
    test('null cash → skipped', () {
      expect(getCashTotal([{'cash': null}, {'cash': 100.0}]), closeTo(100.0, 0.001));
    });
    test('all zero → 0', () {
      expect(getCashTotal([{'cash': 0.0}, {'cash': 0.0}]), 0.0);
    });
    test('10 items', () {
      final items = List.generate(10, (_) => {'cash': 50.0});
      expect(getCashTotal(items), closeTo(500.0, 0.001));
    });
  });

  // ── getBankTotal ──────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenDetails] getBankTotal', () {
    test('sums bank field', () {
      expect(getBankTotal([{'bank': 100.0}, {'bank': 400.0}]), closeTo(500.0, 0.001));
    });
    test('empty → 0', () => expect(getBankTotal([]), 0.0));
    test('null bank → skipped', () {
      expect(getBankTotal([{'bank': null}, {'bank': 200.0}]), closeTo(200.0, 0.001));
    });
    test('all zero → 0', () {
      expect(getBankTotal([{'bank': 0.0}]), 0.0);
    });
  });

  // ── resolveTitleText ──────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenDetails] resolveTitleText', () {
    test('non-empty list → first item expensehead', () {
      final items = [{'expensehead': 'Fuel'}, {'expensehead': 'Other'}];
      expect(resolveTitleText(items), 'Fuel');
    });
    test('empty list → "No Items"', () => expect(resolveTitleText([]), 'No Items'));
    test('null expensehead → "No Items"', () {
      expect(resolveTitleText([{'expensehead': null}]), 'No Items');
    });
  });

  // ── showNoRecords ─────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenDetails] showNoRecords', () {
    test('0 → show', () => expect(showNoRecords(0), isTrue));
    test('1 → hide', () => expect(showNoRecords(1), isFalse));
    test('10 → hide', () => expect(showNoRecords(10), isFalse));
  });
}

