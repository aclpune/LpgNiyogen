// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerIncomeUnsettledScreenDetails.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerIncomeUnsettledScreenDetails ────────────────

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
  required int itemId,
  required int flag,
}) => {"DistributorId": distributorId, "Date": formattedDate, "ItemId": itemId, "Flag": flag};

double getTotalAmount(List<Map<String, dynamic>> items) {
  double total = 0.0;
  for (var item in items) {
    num? amount = (item['amount'] as num?);
    if (amount != null) total += amount.toDouble();
  }
  return total;
}

String resolveTitleText(List<Map<String, dynamic>> items) =>
    items.isNotEmpty ? (items[0]['itemName'] ?? 'No Items') : 'No Items';

String resolveAccentColorName(int? flag) => flag == 1 ? 'amber' : 'green';
String resolveFooterGradient(int? flag) => flag == 1 ? 'gradWarn' : 'gradGreen';
String resolveAppBarIcon(int? flag) =>
    flag == 1 ? 'pending_actions_rounded' : 'check_circle_rounded';

bool showNoRecords(int count) => count == 0;

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('same input same output', () => expect(formatCurrency(5000.0), formatCurrency(5000.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
  });

  // ── formatDate ────────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] formatDate', () {
    test('formats 2025-04-07', () => expect(formatDate(DateTime(2025, 4, 7)), '2025-04-07'));
    test('end of year', () => expect(formatDate(DateTime(2025, 12, 31)), '2025-12-31'));
    test('single digit padded', () => expect(formatDate(DateTime(2026, 1, 5)), '2026-01-05'));
  });

  // ── buildRequestBody ──────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] buildRequestBody', () {
    test('has 4 keys', () {
      final b = buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07', itemId: 1, flag: 1);
      expect(b.keys.length, 4);
    });
    test('Flag is set', () {
      expect(buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07', itemId: 1, flag: 2)['Flag'], 2);
    });
    test('ItemId is set', () {
      expect(buildRequestBody(
          distributorId: '8118', formattedDate: '2025-04-07', itemId: 5, flag: 1)['ItemId'], 5);
    });
  });

  // ── getTotalAmount ────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] getTotalAmount', () {
    test('sums amount field', () {
      expect(getTotalAmount([{'amount': 500.0}, {'amount': 300.0}]), closeTo(800.0, 0.001));
    });
    test('empty → 0', () => expect(getTotalAmount([]), 0.0));
    test('null amount → skipped', () {
      expect(getTotalAmount([{'amount': null}, {'amount': 200.0}]), closeTo(200.0, 0.001));
    });
    test('all zero → 0', () {
      expect(getTotalAmount([{'amount': 0.0}, {'amount': 0.0}]), 0.0);
    });
    test('10 items', () {
      final items = List.generate(10, (_) => {'amount': 100.0});
      expect(getTotalAmount(items), closeTo(1000.0, 0.001));
    });
    test('fractional amounts', () {
      expect(getTotalAmount([{'amount': 1234.56}, {'amount': 4321.44}]),
          closeTo(5556.0, 0.001));
    });
  });

  // ── resolveTitleText ──────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] resolveTitleText', () {
    test('non-empty → first itemName', () {
      final items = [{'itemName': '14.2 KG'}, {'itemName': '5 KG'}];
      expect(resolveTitleText(items), '14.2 KG');
    });
    test('empty list → "No Items"', () => expect(resolveTitleText([]), 'No Items'));
    test('null itemName → "No Items"', () {
      expect(resolveTitleText([{'itemName': null}]), 'No Items');
    });
  });

  // ── resolveAccentColorName ────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] resolveAccentColorName', () {
    test('flag 1 → amber', () => expect(resolveAccentColorName(1), 'amber'));
    test('flag 2 → green', () => expect(resolveAccentColorName(2), 'green'));
    test('flag 0 → green', () => expect(resolveAccentColorName(0), 'green'));
    test('null → green', () => expect(resolveAccentColorName(null), 'green'));
  });

  // ── resolveFooterGradient ─────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] resolveFooterGradient', () {
    test('flag 1 → gradWarn', () => expect(resolveFooterGradient(1), 'gradWarn'));
    test('flag 2 → gradGreen', () => expect(resolveFooterGradient(2), 'gradGreen'));
    test('null → gradGreen', () => expect(resolveFooterGradient(null), 'gradGreen'));
  });

  // ── resolveAppBarIcon ─────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] resolveAppBarIcon', () {
    test('flag 1 → pending_actions_rounded', () =>
        expect(resolveAppBarIcon(1), 'pending_actions_rounded'));
    test('flag 2 → check_circle_rounded', () =>
        expect(resolveAppBarIcon(2), 'check_circle_rounded'));
    test('null → check_circle_rounded', () =>
        expect(resolveAppBarIcon(null), 'check_circle_rounded'));
  });

  // ── showNoRecords ─────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetails] showNoRecords', () {
    test('0 → show', () => expect(showNoRecords(0), isTrue));
    test('1 → hide', () => expect(showNoRecords(1), isFalse));
    test('10 → hide', () => expect(showNoRecords(10), isFalse));
  });
}

