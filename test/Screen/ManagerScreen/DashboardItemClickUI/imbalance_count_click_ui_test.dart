// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/ImbalanceCountClickUI.dart

import 'package:flutter_test/flutter_test.dart';

// ── Pure-logic helpers extracted from ImbalanceCountClickUI ──────────────────

/// Mirrors filterSearchResults() in _ImbalanceCountClickUIState
List<Map<String, dynamic>> filterImbalanceList(
    List<Map<String, dynamic>> items, String query) {
  if (query.isEmpty) return List.from(items);
  final lq = query.toLowerCase();
  return items.where((item) {
    return (item['staffName']?.toString().toLowerCase().contains(lq) ?? false) ||
        (item['itemName']?.toString().toLowerCase().contains(lq) ?? false) ||
        (item['imbalanceQty']?.toString().contains(lq) ?? false);
  }).toList();
}

/// Mirrors initialisation: filteredImbalanceList = List.from(imbalanceList)
List<Map<String, dynamic>> resetFilter(List<Map<String, dynamic>> fullList) =>
    List.from(fullList);

/// Mirrors display fields for each row
Map<String, String> imbalanceRowFields({
  required dynamic staffName,
  required dynamic itemName,
  required dynamic imbalanceQty,
}) =>
    {
      'staffName':    staffName?.toString() ?? '',
      'itemName':     itemName?.toString()  ?? '',
      'imbalanceQty': imbalanceQty?.toString() ?? '',
    };

void main() {
  // ── filterImbalanceList: empty query ─────────────────────────────────────────
  group('[ImbalanceCountClickUI] filterImbalanceList – empty query', () {
    final items = [
      {'staffName': 'Ravi Sharma',  'itemName': '14.2 KG', 'imbalanceQty': 3},
      {'staffName': 'Amit Das',     'itemName': '5 KG',    'imbalanceQty': 1},
      {'staffName': 'Priya Singh',  'itemName': '14.2 KG', 'imbalanceQty': 5},
    ];

    test('empty query returns all items', () =>
        expect(filterImbalanceList(items, '').length, 3));

    test('returns a copy, not the same reference', () {
      final result = filterImbalanceList(items, '');
      expect(result == items, isFalse); // different list object
      expect(result.length, items.length);
    });

    test('does not mutate original list', () {
      final original = [
        {'staffName': 'A', 'itemName': 'X', 'imbalanceQty': 1},
      ];
      final result = filterImbalanceList(original, '');
      result.add({'staffName': 'Extra', 'itemName': 'Y', 'imbalanceQty': 0});
      expect(original.length, 1);
    });
  });

  // ── filterImbalanceList: staffName ───────────────────────────────────────────
  group('[ImbalanceCountClickUI] filterImbalanceList – staffName', () {
    final items = [
      {'staffName': 'Ravi Sharma',  'itemName': '14.2 KG', 'imbalanceQty': 3},
      {'staffName': 'Amit Das',     'itemName': '5 KG',    'imbalanceQty': 1},
      {'staffName': 'Priya Singh',  'itemName': '14.2 KG', 'imbalanceQty': 5},
    ];

    test('exact staffName match', () =>
        expect(filterImbalanceList(items, 'Ravi Sharma').length, 1));
    test('partial staffName match', () =>
        expect(filterImbalanceList(items, 'ravi').length, 1));
    test('case-insensitive staffName', () =>
        expect(filterImbalanceList(items, 'AMIT').length, 1));
    test('partial last name', () =>
        expect(filterImbalanceList(items, 'singh').length, 1));
    test('partial first name across multiple', () {
      final items2 = [
        {'staffName': 'Ram Kumar', 'itemName': 'A', 'imbalanceQty': 1},
        {'staffName': 'Ramesh',    'itemName': 'B', 'imbalanceQty': 2},
      ];
      expect(filterImbalanceList(items2, 'ram').length, 2);
    });
  });

  // ── filterImbalanceList: itemName ────────────────────────────────────────────
  group('[ImbalanceCountClickUI] filterImbalanceList – itemName', () {
    final items = [
      {'staffName': 'Ravi Sharma',  'itemName': '14.2 KG', 'imbalanceQty': 3},
      {'staffName': 'Amit Das',     'itemName': '5 KG',    'imbalanceQty': 1},
      {'staffName': 'Priya Singh',  'itemName': '14.2 KG', 'imbalanceQty': 5},
    ];

    test('exact itemName match', () =>
        expect(filterImbalanceList(items, '5 KG').length, 1));
    test('partial itemName matches multiple', () =>
        expect(filterImbalanceList(items, '14.2').length, 2));
    test('case-insensitive itemName', () =>
        expect(filterImbalanceList(items, '14.2 kg').length, 2));
    test('"KG" matches both items', () =>
        expect(filterImbalanceList(items, 'KG').length, 3));
  });

  // ── filterImbalanceList: imbalanceQty ────────────────────────────────────────
  group('[ImbalanceCountClickUI] filterImbalanceList – imbalanceQty', () {
    final items = [
      {'staffName': 'A', 'itemName': 'X', 'imbalanceQty': 3},
      {'staffName': 'B', 'itemName': 'Y', 'imbalanceQty': 1},
      {'staffName': 'C', 'itemName': 'Z', 'imbalanceQty': 5},
    ];

    test('matches qty "3"', () =>
        expect(filterImbalanceList(items, '3').length, 1));
    test('matches qty "1"', () =>
        expect(filterImbalanceList(items, '1').length, 1));
    test('matches qty "5"', () =>
        expect(filterImbalanceList(items, '5').length, 1));
    test('no match returns empty', () =>
        expect(filterImbalanceList(items, '99'), isEmpty));
  });

  // ── filterImbalanceList: no match ────────────────────────────────────────────
  group('[ImbalanceCountClickUI] filterImbalanceList – no match', () {
    final items = [
      {'staffName': 'Ravi', 'itemName': '14.2 KG', 'imbalanceQty': 3},
    ];

    test('completely unrelated query → empty', () =>
        expect(filterImbalanceList(items, 'ZZZNOMATCH'), isEmpty));
    test('empty list → empty', () =>
        expect(filterImbalanceList([], 'ravi'), isEmpty));
    test('empty list empty query → empty', () =>
        expect(filterImbalanceList([], ''), isEmpty));
  });

  // ── filterImbalanceList: null fields ─────────────────────────────────────────
  group('[ImbalanceCountClickUI] filterImbalanceList – null fields', () {
    final items = [
      {'staffName': null, 'itemName': null, 'imbalanceQty': null},
      {'staffName': 'Ravi', 'itemName': '5 KG', 'imbalanceQty': 2},
    ];

    test('null fields not matched by text query', () {
      expect(filterImbalanceList(items, 'null').length, 0);
    });
    test('valid item still matched', () {
      expect(filterImbalanceList(items, 'ravi').length, 1);
    });
    test('empty query returns both', () {
      expect(filterImbalanceList(items, '').length, 2);
    });
  });

  // ── resetFilter ──────────────────────────────────────────────────────────────
  group('[ImbalanceCountClickUI] resetFilter', () {
    test('returns full list copy', () {
      final full = [
        {'staffName': 'A', 'itemName': 'X', 'imbalanceQty': 1},
        {'staffName': 'B', 'itemName': 'Y', 'imbalanceQty': 2},
      ];
      expect(resetFilter(full).length, 2);
    });
    test('returns new list (not same reference)', () {
      final full = [{'staffName': 'A', 'itemName': 'X', 'imbalanceQty': 1}];
      final copy = resetFilter(full);
      copy.add({'staffName': 'New', 'itemName': 'Z', 'imbalanceQty': 0});
      expect(full.length, 1);
    });
    test('empty full list → empty copy', () {
      expect(resetFilter([]), isEmpty);
    });
  });

  // ── imbalanceRowFields ────────────────────────────────────────────────────────
  group('[ImbalanceCountClickUI] imbalanceRowFields', () {
    test('valid values returned as strings', () {
      final f = imbalanceRowFields(
          staffName: 'Ravi', itemName: '14.2 KG', imbalanceQty: 3);
      expect(f['staffName'],    'Ravi');
      expect(f['itemName'],     '14.2 KG');
      expect(f['imbalanceQty'], '3');
    });
    test('null staffName → ""', () {
      final f = imbalanceRowFields(
          staffName: null, itemName: '5 KG', imbalanceQty: 1);
      expect(f['staffName'], '');
    });
    test('null itemName → ""', () {
      final f = imbalanceRowFields(
          staffName: 'A', itemName: null, imbalanceQty: 2);
      expect(f['itemName'], '');
    });
    test('null imbalanceQty → ""', () {
      final f = imbalanceRowFields(
          staffName: 'A', itemName: 'X', imbalanceQty: null);
      expect(f['imbalanceQty'], '');
    });
    test('zero qty → "0"', () {
      final f = imbalanceRowFields(
          staffName: 'A', itemName: 'X', imbalanceQty: 0);
      expect(f['imbalanceQty'], '0');
    });
    test('3 keys present', () {
      expect(imbalanceRowFields(
          staffName: 'A', itemName: 'X', imbalanceQty: 1).keys.length, 3);
    });
  });
}

