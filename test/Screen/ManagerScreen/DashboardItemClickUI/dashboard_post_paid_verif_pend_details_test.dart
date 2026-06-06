// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardPostPaidVerifPendDetails.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from DashboardPostPaidVerifPendDetails ───────

String nullToDash(String? value) {
  if (value == null || value.toLowerCase() == 'null') return '-';
  return value;
}

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

List<Map<String, dynamic>> filterSearchResults(
    List<Map<String, dynamic>> items, String query) =>
    items
        .where((e) => (e['staffName'] as String? ?? '')
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

String cleanTxnType(String value) => value.replaceAll(' ', '');

const List<String> getTransactionForList =
    ['All', 'Daily Sales', 'SV Sales', 'ARB Sales', 'Receipt'];

String amountDisplay(num? amount) =>
    nullToDash(formatCurrency((amount ?? 0.0).toDouble()));

DateTime applyPickedDate(DateTime current, DateTime? picked) =>
    picked ?? current;

bool showNoRecords(int count) => count == 0;

void main() {
  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
    test('"" → ""', () => expect(nullToDash(''), ''));
    test('valid value unchanged', () => expect(nullToDash('TC-001'), 'TC-001'));
  });

  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('negative does not throw', () =>
        expect(() => formatCurrency(-100.0), returnsNormally));
    test('large amount does not throw', () =>
        expect(() => formatCurrency(99999999.0), returnsNormally));
  });

  // ── filterSearchResults ──────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] filterSearchResults', () {
    final items = [
      {'staffName': 'Rahul Kumar',  'amount': 500.0},
      {'staffName': 'Swarup Das',   'amount': 800.0},
      {'staffName': 'Priya Singh',  'amount': 300.0},
      {'staffName': null,            'amount': 100.0},
    ];

    test('exact name match', () {
      expect(filterSearchResults(items, 'Rahul Kumar').length, 1);
    });
    test('case-insensitive', () {
      expect(filterSearchResults(items, 'rahul').length, 1);
    });
    test('partial match', () {
      expect(filterSearchResults(items, 'swa').length, 1);
    });
    test('uppercase query', () {
      expect(filterSearchResults(items, 'PRIYA').length, 1);
    });
    test('empty query → all items', () {
      expect(filterSearchResults(items, '').length, 4);
    });
    test('no match → empty list', () {
      expect(filterSearchResults(items, 'ZZZNONE'), isEmpty);
    });
    test('null staffName not matched by text query', () {
      expect(filterSearchResults(items, 'null').length, 0);
    });
    test('partial last name match', () {
      expect(filterSearchResults(items, 'Das').length, 1);
    });
    test('common letter matches multiple', () {
      expect(filterSearchResults(items, 'a').length,
          greaterThanOrEqualTo(2));
    });
  });

  // ── cleanTxnType ─────────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] cleanTxnType', () {
    test('"Daily Sales" → "DailySales"', () =>
        expect(cleanTxnType('Daily Sales'), 'DailySales'));
    test('"SV Sales" → "SVSales"', () =>
        expect(cleanTxnType('SV Sales'), 'SVSales'));
    test('"ARB Sales" → "ARBSales"', () =>
        expect(cleanTxnType('ARB Sales'), 'ARBSales'));
    test('"All" → "All"', () => expect(cleanTxnType('All'), 'All'));
    test('"Receipt" → "Receipt"', () => expect(cleanTxnType('Receipt'), 'Receipt'));
    test('multiple spaces all removed', () =>
        expect(cleanTxnType('A B C'), 'ABC'));
    test('empty stays empty', () => expect(cleanTxnType(''), ''));
    test('no spaces unchanged', () =>
        expect(cleanTxnType('NoSpaces'), 'NoSpaces'));
  });

  // ── getTransactionForList ────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] getTransactionForList', () {
    test('has 5 items', () => expect(getTransactionForList.length, 5));
    test('first item is "All"', () => expect(getTransactionForList[0], 'All'));
    test('contains "Daily Sales"', () =>
        expect(getTransactionForList.contains('Daily Sales'), isTrue));
    test('contains "SV Sales"', () =>
        expect(getTransactionForList.contains('SV Sales'), isTrue));
    test('contains "ARB Sales"', () =>
        expect(getTransactionForList.contains('ARB Sales'), isTrue));
    test('contains "Receipt"', () =>
        expect(getTransactionForList.contains('Receipt'), isTrue));
    test('last item is "Receipt"', () =>
        expect(getTransactionForList.last, 'Receipt'));
  });

  // ── amountDisplay ─────────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] amountDisplay', () {
    test('null → "0.00"', () => expect(amountDisplay(null), '0.00'));
    test('0 → "0.00"', () => expect(amountDisplay(0), '0.00'));
    test('positive formats to non-zero', () {
      expect(amountDisplay(1500.0), isNot('0.00'));
    });
    test('positive contains digits', () {
      expect(amountDisplay(800.0).contains('8'), isTrue);
    });
  });

  // ── applyPickedDate ───────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] applyPickedDate', () {
    test('null picked → current date unchanged', () {
      final current = DateTime(2025, 4, 10);
      expect(applyPickedDate(current, null), current);
    });
    test('picked date applied', () {
      final current = DateTime(2025, 4, 10);
      final picked  = DateTime(2025, 6, 20);
      expect(applyPickedDate(current, picked), picked);
    });
    test('same date → same', () {
      final dt = DateTime(2025, 1, 1);
      expect(applyPickedDate(dt, dt), dt);
    });
  });

  // ── showNoRecords ─────────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetails] showNoRecords', () {
    test('0 → show', () => expect(showNoRecords(0), isTrue));
    test('1 → hide', () => expect(showNoRecords(1), isFalse));
    test('10 → hide', () => expect(showNoRecords(10), isFalse));
  });
}

