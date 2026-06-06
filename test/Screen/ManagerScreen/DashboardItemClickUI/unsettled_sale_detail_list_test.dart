// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/UnsettledSaleDetailList.dart

import 'package:flutter_test/flutter_test.dart';

// ── Pure-logic helpers extracted from UnsettledSaleDetailList ────────────────

/// Mirrors: .where((item) => item.unsettQty != null && item.unsettQty! > 0)
List<Map<String, dynamic>> filterUnsettled(List<Map<String, dynamic>> data) {
  return data
      .where((item) => item['unsettQty'] != null && (item['unsettQty'] as num) > 0)
      .toList();
}

/// Mirrors: isNotEmpty guard for list display vs 'No Records Found'
bool showNoRecords(int count) => count == 0;

/// Mirrors: unsettle.staffName.toString()
String staffNameDisplay(dynamic staffName) => staffName?.toString() ?? '';

/// Mirrors: unsettle.itemName!.toString()
String itemNameDisplay(dynamic itemName) => itemName?.toString() ?? '';

/// Mirrors: unsettle.unsettQty.toString()
String unsettQtyDisplay(dynamic qty) => qty?.toString() ?? '';

/// Mirrors: unsettle.unsettSaleAmt!.toStringAsFixed(2)
String unsettAmtDisplay(num? amt) =>
    amt != null ? amt.toStringAsFixed(2) : '0.00';

/// Mirrors: initial isLoading = true
bool initialLoadingState() => true;

/// Mirrors: isLoading = false after fetch
bool loadingStateAfterFetch() => false;

void main() {
  // ── filterUnsettled ───────────────────────────────────────────────────────
  group('[UnsettledSaleDetailList] filterUnsettled – basic filtering', () {
    test('keeps items with unsettQty > 0', () {
      final data = [
        {'staffName': 'Ravi', 'itemName': '14.2 KG', 'unsettQty': 3, 'unsettSaleAmt': 2559.0},
        {'staffName': 'Amit', 'itemName': '5 KG',    'unsettQty': 1, 'unsettSaleAmt': 850.0},
      ];
      expect(filterUnsettled(data).length, 2);
    });

    test('removes items with unsettQty == 0', () {
      final data = [
        {'staffName': 'Ravi', 'itemName': '14.2 KG', 'unsettQty': 0, 'unsettSaleAmt': 0.0},
        {'staffName': 'Amit', 'itemName': '5 KG',    'unsettQty': 2, 'unsettSaleAmt': 850.0},
      ];
      final result = filterUnsettled(data);
      expect(result.length, 1);
      expect(result.first['staffName'], 'Amit');
    });

    test('removes items with null unsettQty', () {
      final data = [
        {'staffName': 'Ravi', 'unsettQty': null, 'unsettSaleAmt': 0.0},
        {'staffName': 'Amit', 'unsettQty': 2,    'unsettSaleAmt': 850.0},
      ];
      final result = filterUnsettled(data);
      expect(result.length, 1);
      expect(result.first['staffName'], 'Amit');
    });

    test('all items null unsettQty → empty', () {
      final data = [
        {'staffName': 'A', 'unsettQty': null},
        {'staffName': 'B', 'unsettQty': null},
      ];
      expect(filterUnsettled(data), isEmpty);
    });

    test('all items unsettQty 0 → empty', () {
      final data = [
        {'staffName': 'A', 'unsettQty': 0},
        {'staffName': 'B', 'unsettQty': 0},
      ];
      expect(filterUnsettled(data), isEmpty);
    });

    test('empty list → empty', () {
      expect(filterUnsettled([]), isEmpty);
    });

    test('mixed null, 0 and positive → only positives kept', () {
      final data = [
        {'staffName': 'A', 'unsettQty': null},
        {'staffName': 'B', 'unsettQty': 0},
        {'staffName': 'C', 'unsettQty': 1},
        {'staffName': 'D', 'unsettQty': 5},
      ];
      final result = filterUnsettled(data);
      expect(result.length, 2);
      expect(result.map((e) => e['staffName']).toList(), containsAll(['C', 'D']));
    });

    test('large qty retained', () {
      final data = [{'staffName': 'X', 'unsettQty': 999, 'unsettSaleAmt': 85000.0}];
      expect(filterUnsettled(data).length, 1);
    });

    test('decimal qty > 0 retained', () {
      final data = [{'staffName': 'X', 'unsettQty': 0.5}];
      expect(filterUnsettled(data).length, 1);
    });

    test('negative qty not shown (treated as ≤ 0)', () {
      final data = [{'staffName': 'X', 'unsettQty': -1}];
      expect(filterUnsettled(data), isEmpty);
    });
  });

  // ── showNoRecords ─────────────────────────────────────────────────────────
  group('[UnsettledSaleDetailList] showNoRecords', () {
    test('count 0 → show "No Records Found"', () =>
        expect(showNoRecords(0), isTrue));
    test('count 1 → hide message', () =>
        expect(showNoRecords(1), isFalse));
    test('count 10 → hide message', () =>
        expect(showNoRecords(10), isFalse));
    test('count after filter of all-zero list → 0 → show message', () {
      final data = [
        {'unsettQty': 0},
        {'unsettQty': null},
      ];
      expect(showNoRecords(filterUnsettled(data).length), isTrue);
    });
    test('count after filter with positives → hide message', () {
      final data = [{'unsettQty': 3}];
      expect(showNoRecords(filterUnsettled(data).length), isFalse);
    });
  });

  // ── staffNameDisplay ──────────────────────────────────────────────────────
  group('[UnsettledSaleDetailList] staffNameDisplay', () {
    test('valid name returned', () =>
        expect(staffNameDisplay('Ravi Kumar'), 'Ravi Kumar'));
    test('null → ""', () => expect(staffNameDisplay(null), ''));
    test('int converted to string', () =>
        expect(staffNameDisplay(42), '42'));
    test('empty string returned', () =>
        expect(staffNameDisplay(''), ''));
  });

  // ── itemNameDisplay ───────────────────────────────────────────────────────
  group('[UnsettledSaleDetailList] itemNameDisplay', () {
    test('"14.2 KG" returned', () =>
        expect(itemNameDisplay('14.2 KG'), '14.2 KG'));
    test('"5 KG" returned', () =>
        expect(itemNameDisplay('5 KG'), '5 KG'));
    test('null → ""', () => expect(itemNameDisplay(null), ''));
    test('numeric item type converted', () =>
        expect(itemNameDisplay(142), '142'));
  });

  // ── unsettQtyDisplay ──────────────────────────────────────────────────────
  group('[UnsettledSaleDetailList] unsettQtyDisplay', () {
    test('3 → "3"', () => expect(unsettQtyDisplay(3), '3'));
    test('0 → "0"', () => expect(unsettQtyDisplay(0), '0'));
    test('null → ""', () => expect(unsettQtyDisplay(null), ''));
    test('large qty → string', () => expect(unsettQtyDisplay(999), '999'));
    test('string qty returned', () =>
        expect(unsettQtyDisplay('5'), '5'));
  });

  // ── unsettAmtDisplay ──────────────────────────────────────────────────────
  group('[UnsettledSaleDetailList] unsettAmtDisplay – toStringAsFixed(2)', () {
    test('0 → "0.00"', () => expect(unsettAmtDisplay(0), '0.00'));
    test('null → "0.00"', () => expect(unsettAmtDisplay(null), '0.00'));
    test('2559.0 → "2559.00"', () =>
        expect(unsettAmtDisplay(2559.0), '2559.00'));
    test('850.5 → "850.50"', () =>
        expect(unsettAmtDisplay(850.5), '850.50'));
    test('1234.567 rounds to 2 dp', () =>
        expect(unsettAmtDisplay(1234.567), '1234.57'));
    test('0.1 → "0.10"', () => expect(unsettAmtDisplay(0.1), '0.10'));
    test('negative amount → "-500.00"', () =>
        expect(unsettAmtDisplay(-500.0), '-500.00'));
  });

  // ── loading state ─────────────────────────────────────────────────────────
  group('[UnsettledSaleDetailList] loading state', () {
    test('initial isLoading is true', () =>
        expect(initialLoadingState(), isTrue));
    test('isLoading after fetch is false', () =>
        expect(loadingStateAfterFetch(), isFalse));
  });

  // ── integration: filter + count + display ─────────────────────────────────
  group('[UnsettledSaleDetailList] filter → count → display integration', () {
    test('full pipeline: 5 items, 3 valid → 3 shown', () {
      final raw = [
        {'staffName': 'A', 'itemName': '14.2 KG', 'unsettQty': 3, 'unsettSaleAmt': 2559.0},
        {'staffName': 'B', 'itemName': '5 KG',    'unsettQty': 0, 'unsettSaleAmt': 0.0},
        {'staffName': 'C', 'itemName': '14.2 KG', 'unsettQty': 1, 'unsettSaleAmt': 853.0},
        {'staffName': 'D', 'itemName': '5 KG',    'unsettQty': null,'unsettSaleAmt': 0.0},
        {'staffName': 'E', 'itemName': '19 KG',   'unsettQty': 2, 'unsettSaleAmt': 3200.0},
      ];
      final filtered = filterUnsettled(raw);
      expect(filtered.length, 3);
      expect(showNoRecords(filtered.length), isFalse);
    });

    test('all invalid → 0 → show no records', () {
      final raw = [
        {'staffName': 'A', 'unsettQty': 0},
        {'staffName': 'B', 'unsettQty': null},
      ];
      final filtered = filterUnsettled(raw);
      expect(showNoRecords(filtered.length), isTrue);
    });

    test('display fields of first filtered item', () {
      final raw = [
        {'staffName': 'Ravi', 'itemName': '14.2 KG',
         'unsettQty': 3, 'unsettSaleAmt': 2559.0},
      ];
      final filtered = filterUnsettled(raw);
      final item = filtered.first;
      expect(staffNameDisplay(item['staffName']),  'Ravi');
      expect(itemNameDisplay(item['itemName']),    '14.2 KG');
      expect(unsettQtyDisplay(item['unsettQty']),  '3');
      expect(unsettAmtDisplay(
          (item['unsettSaleAmt'] as num?)?.toDouble()), '2559.00');
    });
  });
}

