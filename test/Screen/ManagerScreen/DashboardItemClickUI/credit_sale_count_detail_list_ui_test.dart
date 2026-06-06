// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/CreditSaleCountDetailListUI.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from CreditSaleCountDetailListUI ─────────────

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

double calcTotalOutstanding(List<Map<String, dynamic>> list) =>
    list.fold(0.0, (s, e) => s + ((e['totalOutstanding'] ?? 0.0) as num).toDouble());

double calcTotalOutstandingTopFive(List<Map<String, dynamic>> list) =>
    list.fold(0.0, (s, e) => s + ((e['totalOutstanding'] ?? 0.0) as num).toDouble());

String headerLabel(String? selectedItem, double allAmt, double topFiveAmt) {
  final fAll  = formatCurrency(allAmt);
  final fTop5 = formatCurrency(topFiveAmt);
  return selectedItem == 'Top 5 outstanding'
      ? 'Total Outstanding Amount: $fTop5'
      : 'Total Outstanding Amount: $fAll';
}

String currentListMode(String? selectedItem) =>
    selectedItem == 'Top 5 outstanding' ? 'topFive' : 'all';

String dropdownAction(int customerId) {
  if (customerId == -1) return 'FETCH_ALL';
  if (customerId == -2) return 'TOP_FIVE';
  if (customerId == -3) return 'OLDEST';
  return 'FETCH_CUSTOMER';
}

List<Map<String, dynamic>> showTop5ByOutstanding(List<Map<String, dynamic>> items) {
  final sorted = List<Map<String, dynamic>>.from(items);
  sorted.sort((a, b) =>
      ((b['totalOutstanding'] ?? 0) as num).compareTo((a['totalOutstanding'] ?? 0) as num));
  return sorted.take(5).toList();
}

List<Map<String, dynamic>> showOldestRecords(List<Map<String, dynamic>> items) {
  final sorted = List<Map<String, dynamic>>.from(items);
  sorted.sort((a, b) {
    DateTime da = a['collRcptDate'] != null
        ? DateTime.tryParse(a['collRcptDate'] as String) ?? DateTime(1970)
        : DateTime(1970);
    DateTime db = b['collRcptDate'] != null
        ? DateTime.tryParse(b['collRcptDate'] as String) ?? DateTime(1970)
        : DateTime(1970);
    return da.compareTo(db);
  });
  return sorted;
}

List<bool> addItemState(List<bool> existing) => [...existing, false];
bool showPayNow(String? selectedItem) => selectedItem != 'Top 5 outstanding';

void main() {
  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
    test('"" → ""', () => expect(nullToDash(''), ''));
    test('valid string returned unchanged', () =>
        expect(nullToDash('Priya Sharma'), 'Priya Sharma'));
    test('numeric string returned', () => expect(nullToDash('42'), '42'));
    test('dash string returned as-is', () => expect(nullToDash('-'), '-'));
  });

  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 does not start with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount has comma', () =>
        expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('same input same output', () =>
        expect(formatCurrency(2300.0), formatCurrency(2300.0)));
  });

  // ── calcTotalOutstanding ─────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] calcTotalOutstanding', () {
    test('sums three items', () {
      expect(calcTotalOutstanding([
        {'totalOutstanding': 500.0},
        {'totalOutstanding': 800.0},
        {'totalOutstanding': 200.0},
      ]), closeTo(1500.0, 0.001));
    });
    test('empty list → 0', () => expect(calcTotalOutstanding([]), 0.0));
    test('null field treated as 0', () {
      expect(calcTotalOutstanding([
        {'totalOutstanding': null},
        {'totalOutstanding': 300.0},
      ]), closeTo(300.0, 0.001));
    });
    test('all zeros → 0', () {
      expect(calcTotalOutstanding([
        {'totalOutstanding': 0.0},
        {'totalOutstanding': 0.0},
      ]), 0.0);
    });
    test('single item', () {
      expect(calcTotalOutstanding([{'totalOutstanding': 999.99}]),
          closeTo(999.99, 0.001));
    });
  });

  // ── calcTotalOutstandingTopFive ──────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] calcTotalOutstandingTopFive', () {
    test('sums top-five list', () {
      expect(calcTotalOutstandingTopFive([
        {'totalOutstanding': 1000.0},
        {'totalOutstanding': 2000.0},
      ]), closeTo(3000.0, 0.001));
    });
    test('empty → 0', () => expect(calcTotalOutstandingTopFive([]), 0.0));
  });

  // ── headerLabel ─────────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] headerLabel', () {
    test('Top 5 mode uses topFive amount', () {
      final label = headerLabel('Top 5 outstanding', 2300.0, 1000.0);
      expect(label.startsWith('Total Outstanding Amount:'), isTrue);
      expect(label.contains('1'), isTrue);
    });
    test('ALL mode uses full amount', () {
      final label = headerLabel('ALL', 2300.0, 1000.0);
      expect(label.startsWith('Total Outstanding Amount:'), isTrue);
      expect(label.contains('2'), isTrue);
    });
    test('null mode uses full amount', () {
      final label = headerLabel(null, 2300.0, 1000.0);
      expect(label.startsWith('Total Outstanding Amount:'), isTrue);
    });
    test('unknown mode uses full amount', () {
      final label = headerLabel('Other', 500.0, 100.0);
      expect(label.contains('5'), isTrue);
    });
  });

  // ── currentListMode ─────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] currentListMode', () {
    test('Top 5 outstanding → "topFive"', () =>
        expect(currentListMode('Top 5 outstanding'), 'topFive'));
    test('ALL → "all"', () => expect(currentListMode('ALL'), 'all'));
    test('null → "all"', () => expect(currentListMode(null), 'all'));
    test("Oldest by day's → \"all\"", () =>
        expect(currentListMode("Oldest by day's"), 'all'));
    test('any other string → "all"', () =>
        expect(currentListMode('random'), 'all'));
  });

  // ── dropdownAction ───────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] dropdownAction', () {
    test('-1 → FETCH_ALL', () => expect(dropdownAction(-1), 'FETCH_ALL'));
    test('-2 → TOP_FIVE', () => expect(dropdownAction(-2), 'TOP_FIVE'));
    test('-3 → OLDEST', () => expect(dropdownAction(-3), 'OLDEST'));
    test('1 → FETCH_CUSTOMER', () => expect(dropdownAction(1), 'FETCH_CUSTOMER'));
    test('100 → FETCH_CUSTOMER', () => expect(dropdownAction(100), 'FETCH_CUSTOMER'));
    test('0 → FETCH_CUSTOMER', () => expect(dropdownAction(0), 'FETCH_CUSTOMER'));
  });

  // ── showTop5ByOutstanding ────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] showTop5ByOutstanding', () {
    test('returns at most 5 items', () {
      final items = List.generate(8, (i) => {'totalOutstanding': (i + 1) * 100.0});
      expect(showTop5ByOutstanding(items).length, 5);
    });
    test('first item has highest outstanding', () {
      final items = List.generate(7, (i) =>
          {'totalOutstanding': (i + 1) * 100.0, 'id': i});
      expect(showTop5ByOutstanding(items).first['totalOutstanding'], 700.0);
    });
    test('descending order', () {
      final items = [
        {'totalOutstanding': 100.0},
        {'totalOutstanding': 300.0},
        {'totalOutstanding': 200.0},
      ];
      final r = showTop5ByOutstanding(items);
      expect(r[0]['totalOutstanding'], 300.0);
      expect(r[1]['totalOutstanding'], 200.0);
      expect(r[2]['totalOutstanding'], 100.0);
    });
    test('fewer than 5 → returns all', () {
      expect(showTop5ByOutstanding([
        {'totalOutstanding': 100.0},
        {'totalOutstanding': 50.0},
      ]).length, 2);
    });
    test('empty → empty', () => expect(showTop5ByOutstanding([]), isEmpty));
    test('null outstanding treated as 0 (sorts last)', () {
      final items = [
        {'totalOutstanding': null, 'id': 'a'},
        {'totalOutstanding': 500.0, 'id': 'b'},
      ];
      expect(showTop5ByOutstanding(items).first['id'], 'b');
    });
    test('does not mutate original list', () {
      final items = [
        {'totalOutstanding': 100.0, 'id': 1},
        {'totalOutstanding': 200.0, 'id': 2},
      ];
      showTop5ByOutstanding(items);
      expect(items.first['id'], 1);
    });
    test('exactly 5 items returned when list has 5', () {
      final items = List.generate(5, (i) => {'totalOutstanding': (i + 1) * 10.0});
      expect(showTop5ByOutstanding(items).length, 5);
    });
  });

  // ── showOldestRecords ────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] showOldestRecords', () {
    test('ascending date order', () {
      final items = [
        {'collRcptDate': '2025-06-01', 'id': 3},
        {'collRcptDate': '2025-01-01', 'id': 1},
        {'collRcptDate': '2025-03-15', 'id': 2},
      ];
      final r = showOldestRecords(items);
      expect(r[0]['id'], 1);
      expect(r[1]['id'], 2);
      expect(r[2]['id'], 3);
    });
    test('null date treated as epoch (sorts first)', () {
      final items = [
        {'collRcptDate': null, 'id': 0},
        {'collRcptDate': '2025-01-01', 'id': 1},
      ];
      expect(showOldestRecords(items).first['id'], 0);
    });
    test('single item returned as-is', () {
      expect(showOldestRecords([{'collRcptDate': '2025-01-01', 'id': 1}]).length, 1);
    });
    test('empty → empty', () => expect(showOldestRecords([]), isEmpty));
    test('does not mutate original', () {
      final items = [
        {'collRcptDate': '2025-06-01', 'id': 2},
        {'collRcptDate': '2025-01-01', 'id': 1},
      ];
      showOldestRecords(items);
      expect(items.first['id'], 2);
    });
    test('same date keeps both items', () {
      final items = [
        {'collRcptDate': '2025-01-01', 'id': 1},
        {'collRcptDate': '2025-01-01', 'id': 2},
      ];
      expect(showOldestRecords(items).length, 2);
    });
  });

  // ── addItemState ─────────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] addItemState', () {
    test('appends false to empty list', () {
      expect(addItemState([]), [false]);
    });
    test('appends false to existing list', () {
      final r = addItemState([true, false]);
      expect(r.last, isFalse);
      expect(r.length, 3);
    });
    test('does not mutate original', () {
      final orig = [true];
      addItemState(orig);
      expect(orig.length, 1);
    });
    test('multiple calls grow list', () {
      List<bool> list = [];
      for (int i = 0; i < 5; i++) {
        list = addItemState(list);
      }
      expect(list.length, 5);
      expect(list.every((e) => e == false), isTrue);
    });
  });

  // ── showPayNow ───────────────────────────────────────────────────────────────
  group('[CreditSaleCountDetailListUI] showPayNow', () {
    test('Top 5 outstanding → hide', () =>
        expect(showPayNow('Top 5 outstanding'), isFalse));
    test('ALL → show', () => expect(showPayNow('ALL'), isTrue));
    test('null → show', () => expect(showPayNow(null), isTrue));
    test("Oldest by day's → show", () =>
        expect(showPayNow("Oldest by day's"), isTrue));
    test('customer name → show', () => expect(showPayNow('Priya'), isTrue));
  });
}

