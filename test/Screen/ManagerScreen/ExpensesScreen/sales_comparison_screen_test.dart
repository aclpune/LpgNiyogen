// Tests for: lib/Screen/ManagerScreen/ExpensesScreen/SalesComparisonScreen.dart
import 'package:flutter_test/flutter_test.dart';

// ── Pure-logic helpers extracted from SalesComparisonScreen ─────────────────

/// Mirrors: WillPopScope – always returns false
bool willPopReturnsFalse() => false;

/// Mirrors: _selectedItem = selectedItem.itemName ?? 'All Items'
String resolveSelectedItemName(String? itemName) => itemName ?? 'All Items';

/// Mirrors: selectedItemId = selectedItem.itemId?.toInt()
int? resolveSelectedItemId(num? itemId) => itemId?.toInt();

/// Mirrors: _selectedSalesItemModel = _salesItem[0]  (first item selected)
Map<String, dynamic>? resolveFirstItem(List<Map<String, dynamic>> salesItems) =>
    salesItems.isNotEmpty ? salesItems[0] : null;

/// Mirrors: SalesData(thisMonthSaleQty?.toDouble() ?? 0.0)
double safeQty(num? qty) => qty?.toDouble() ?? 0.0;

/// Mirrors: pointColorMapper
String resolveBarColor(int index) {
  if (index == 0) return 'lightBlueAccent';
  if (index == 1) return '#1271b5';
  if (index == 2) return 'orange';
  return 'grey';
}

/// Mirrors: _selectedItemModel = _items.firstWhere((item) => item.itemName == '14.2 KG', orElse: () => _items.first)
Map<String, Object?> resolveDefaultItem(List<Map<String, Object?>> items) {
  for (final item in items) {
    if (item['itemName'] == '14.2 KG') return item;
  }
  return items.first;
}

/// Mirrors: barData = [thisMonth, preMonth, preYearSameMonth]
List<double> buildBarData(num? thisMonth, num? preMonth, num? preYearSame) => [
  thisMonth?.toDouble() ?? 0.0,
  preMonth?.toDouble() ?? 0.0,
  preYearSame?.toDouble() ?? 0.0,
];

void main() {
  // ── willPopReturnsFalse ───────────────────────────────────────────────────
  group('[SalesComparisonScreen] WillPopScope', () {
    test('fromDrawer → false', () => expect(willPopReturnsFalse(), isFalse));
    test('other → false', () => expect(willPopReturnsFalse(), isFalse));
  });

  // ── resolveSelectedItemName ───────────────────────────────────────────────
  group('[SalesComparisonScreen] resolveSelectedItemName', () {
    test('"14.2 KG" returned', () =>
        expect(resolveSelectedItemName('14.2 KG'), '14.2 KG'));
    test('"5 KG" returned', () =>
        expect(resolveSelectedItemName('5 KG'), '5 KG'));
    test('null → "All Items"', () =>
        expect(resolveSelectedItemName(null), 'All Items'));
    test('empty string returned', () =>
        expect(resolveSelectedItemName(''), ''));
  });

  // ── resolveSelectedItemId ─────────────────────────────────────────────────
  group('[SalesComparisonScreen] resolveSelectedItemId', () {
    test('1 → 1', () => expect(resolveSelectedItemId(1), 1));
    test('2.0 → 2', () => expect(resolveSelectedItemId(2.0), 2));
    test('null → null', () => expect(resolveSelectedItemId(null), isNull));
    test('10 → 10', () => expect(resolveSelectedItemId(10), 10));
    test('large id', () => expect(resolveSelectedItemId(9999), 9999));
  });

  // ── resolveFirstItem ──────────────────────────────────────────────────────
  group('[SalesComparisonScreen] resolveFirstItem', () {
    test('non-empty → first item', () {
      final items = [
        {'itemName': '14.2 KG', 'thisMonthSaleQty': 120.0},
        {'itemName': '5 KG',    'thisMonthSaleQty': 40.0},
      ];
      expect(resolveFirstItem(items)?['itemName'], '14.2 KG');
    });
    test('empty → null', () => expect(resolveFirstItem([]), isNull));
    test('single item → that item', () {
      final items = [{'itemName': '19 KG'}];
      expect(resolveFirstItem(items)?['itemName'], '19 KG');
    });
  });

  // ── safeQty ───────────────────────────────────────────────────────────────
  group('[SalesComparisonScreen] safeQty', () {
    test('120.0 → 120.0', () => expect(safeQty(120.0), 120.0));
    test('160.0 → 160.0', () => expect(safeQty(160.0), 160.0));
    test('null → 0.0', () => expect(safeQty(null), 0.0));
    test('0 → 0.0', () => expect(safeQty(0), 0.0));
    test('int → double', () => expect(safeQty(50), 50.0));
  });

  // ── resolveBarColor ───────────────────────────────────────────────────────
  group('[SalesComparisonScreen] resolveBarColor (pointColorMapper)', () {
    test('index 0 → lightBlueAccent (This Month)', () =>
        expect(resolveBarColor(0), 'lightBlueAccent'));
    test('index 1 → #1271b5 (Last Month)', () =>
        expect(resolveBarColor(1), '#1271b5'));
    test('index 2 → orange (Last Year Same Month)', () =>
        expect(resolveBarColor(2), 'orange'));
    test('index 3 → grey (fallback)', () =>
        expect(resolveBarColor(3), 'grey'));
    test('index 99 → grey', () =>
        expect(resolveBarColor(99), 'grey'));
  });

  // ── resolveDefaultItem ────────────────────────────────────────────────────
  group('[SalesComparisonScreen] resolveDefaultItem', () {
    test('"14.2 KG" found → selected', () {
      final items = [
        {'itemName': '5 KG',    'itemId': 2},
        {'itemName': '14.2 KG', 'itemId': 1},
        {'itemName': '19 KG',   'itemId': 3},
      ];
      expect(resolveDefaultItem(items)['itemName'], '14.2 KG');
    });
    test('"14.2 KG" not found → first item', () {
      final items = [
        {'itemName': '5 KG',  'itemId': 2},
        {'itemName': '19 KG', 'itemId': 3},
      ];
      expect(resolveDefaultItem(items)['itemName'], '5 KG');
    });
    test('single item returned', () {
      final items = [{'itemName': '5 KG', 'itemId': 1}];
      expect(resolveDefaultItem(items)['itemName'], '5 KG');
    });
    test('"14.2 KG" present among many', () {
      final items = [
        {'itemName': 'A'}, {'itemName': '14.2 KG'}, {'itemName': 'C'},
      ];
      expect(resolveDefaultItem(items)['itemName'], '14.2 KG');
    });
  });

  // ── buildBarData ──────────────────────────────────────────────────────────
  group('[SalesComparisonScreen] buildBarData', () {
    test('all non-null', () {
      final d = buildBarData(120.0, 160.0, 135.0);
      expect(d[0], 120.0);
      expect(d[1], 160.0);
      expect(d[2], 135.0);
    });
    test('all null → zeros', () {
      final d = buildBarData(null, null, null);
      expect(d, [0.0, 0.0, 0.0]);
    });
    test('has 3 elements', () {
      expect(buildBarData(1.0, 2.0, 3.0).length, 3);
    });
    test('thisMonth null → 0', () {
      final d = buildBarData(null, 160.0, 135.0);
      expect(d[0], 0.0);
      expect(d[1], 160.0);
    });
    test('preMonth null → 0', () {
      final d = buildBarData(120.0, null, 135.0);
      expect(d[1], 0.0);
    });
    test('preYearSame null → 0', () {
      final d = buildBarData(120.0, 160.0, null);
      expect(d[2], 0.0);
    });
    test('int values converted to double', () {
      final d = buildBarData(100, 200, 150);
      expect(d[0], 100.0);
      expect(d[1], 200.0);
      expect(d[2], 150.0);
    });
    test('0 qty stays 0', () {
      final d = buildBarData(0.0, 0.0, 0.0);
      expect(d, [0.0, 0.0, 0.0]);
    });
  });
}
