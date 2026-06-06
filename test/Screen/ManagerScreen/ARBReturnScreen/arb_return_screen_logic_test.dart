// Unit tests for pure business-logic helpers in ArbReturnScreen:
//   • _updateSum()   → amount = rate × qty
//   • updateTotalAmount() → sums all item amounts
//   • getArbItemCurrentStock() → stock lookup
//   • item validation predicates (hasValidItems, hasValidRate, hasValidQty)
//   • credit-note equality check
//   • credit / delete guard (cNAmt != 0)
//
// None of these tests call any API or mutate any widget state.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// ─── Inline helpers mirroring ArbReturnScreen logic (pure, no Flutter deps) ──

/// Mirrors _updateSum(index) — amount = rate × qty
double arbReturnUpdateSum({required String rateText, required String qtyText}) {
  final rate = double.tryParse(rateText.trim()) ?? 0.0;
  final qty  = double.tryParse(qtyText.trim())  ?? 0.0;
  return rate * qty;
}

/// Mirrors updateTotalAmount() — sum of all item amounts
double arbReturnUpdateTotalAmount(List<String> amountTexts) {
  double total = 0.0;
  for (final txt in amountTexts) {
    total += double.tryParse(txt.trim()) ?? 0.0;
  }
  return total;
}

/// Mirrors getArbItemCurrentStock() — returns stock for itemId, 0 if not found
int arbReturnGetItemCurrentStock(
    List<Map<String, dynamic>> stock, int? itemId) {
  if (itemId == null) return 0;
  try {
    for (final entry in stock) {
      int? parsedId;
      int? parsedStock;

      for (final kv in entry.entries) {
        final key = kv.key.toString().toLowerCase();
        if (key == 'itemid') {
          final rawId = kv.value;
          parsedId = rawId is num
              ? rawId.toInt()
              : int.tryParse(rawId?.toString() ?? '');
        } else if (key == 'currentstk' || key == 'currentstock') {
          final rawStock = kv.value;
          parsedStock = rawStock is num
              ? rawStock.toInt()
              : int.tryParse(rawStock?.toString() ?? '');
        }
      }

      if (parsedId == itemId) {
        return parsedStock ?? 0;
      }
    }
    return 0;
  } catch (_) {
    return 0;
  }
}

/// Mirrors hasValidItems check
bool arbReturnHasValidItems(List<Map<String, dynamic>> items) =>
    items.any((item) =>
        item['ItemId'] != 0 &&
        item['ItemName'].toString().isNotEmpty);

/// Mirrors hasValidRate check
bool arbReturnHasValidRate(List<Map<String, dynamic>> items) =>
    items.any((item) =>
        item['ItemId'] != 0 &&
        item['Rate'].toString().isNotEmpty &&
        num.tryParse(item['Rate'].toString()) != null &&
        num.parse(item['Rate'].toString()) > 0);

/// Mirrors hasValidQty check
bool arbReturnHasValidQty(List<Map<String, dynamic>> items) =>
    items.any((item) =>
        item['ItemId'] != 0 &&
        item['RetQty'].toString().isNotEmpty &&
        num.tryParse(item['RetQty'].toString()) != null &&
        num.parse(item['RetQty'].toString()) > 0);

/// Mirrors credit-note amount equality check
bool arbReturnCreditAmtEqualsTotal(double creditAmt, double totalAmt) =>
    creditAmt == totalAmt;

/// Mirrors cNAmt guard — returns true when edit/delete is blocked
bool arbReturnIsCreditBlocked(double cnAmt) => cnAmt != 0;

void main() {
  // ── _updateSum ─────────────────────────────────────────────────────────────
  group('arbReturnUpdateSum – amount = rate × qty', () {
    test('100 × 2 = 200', () {
      expect(arbReturnUpdateSum(rateText: '100', qtyText: '2'), 200.0);
    });

    test('855.50 × 1 = 855.50', () {
      expect(arbReturnUpdateSum(rateText: '855.50', qtyText: '1'), 855.50);
    });

    test('rate empty → 0', () {
      expect(arbReturnUpdateSum(rateText: '', qtyText: '5'), 0.0);
    });

    test('qty empty → 0', () {
      expect(arbReturnUpdateSum(rateText: '500', qtyText: ''), 0.0);
    });

    test('both empty → 0', () {
      expect(arbReturnUpdateSum(rateText: '', qtyText: ''), 0.0);
    });

    test('non-numeric rate → 0', () {
      expect(arbReturnUpdateSum(rateText: 'abc', qtyText: '3'), 0.0);
    });

    test('non-numeric qty → 0', () {
      expect(arbReturnUpdateSum(rateText: '200', qtyText: 'xyz'), 0.0);
    });

    test('zero qty → 0', () {
      expect(arbReturnUpdateSum(rateText: '500', qtyText: '0'), 0.0);
    });

    test('result has correct precision: 99.99 × 3 = 299.97', () {
      expect(
        arbReturnUpdateSum(rateText: '99.99', qtyText: '3'),
        closeTo(299.97, 0.001),
      );
    });
  });

  // ── updateTotalAmount ──────────────────────────────────────────────────────
  group('arbReturnUpdateTotalAmount – sums all item amounts', () {
    test('single item', () {
      expect(arbReturnUpdateTotalAmount(['500.00']), 500.0);
    });

    test('multiple items', () {
      expect(
        arbReturnUpdateTotalAmount(['200.00', '300.00', '150.00']),
        650.0,
      );
    });

    test('empty list → 0', () {
      expect(arbReturnUpdateTotalAmount([]), 0.0);
    });

    test('ignores empty strings', () {
      expect(arbReturnUpdateTotalAmount(['', '100.00', '']), 100.0);
    });

    test('ignores non-numeric entries', () {
      expect(arbReturnUpdateTotalAmount(['abc', '200.00']), 200.0);
    });

    test('mixed valid and invalid', () {
      expect(
        arbReturnUpdateTotalAmount(['100.00', 'bad', '50.00']),
        150.0,
      );
    });

    test('all zeros → 0', () {
      expect(arbReturnUpdateTotalAmount(['0.00', '0.00', '0.00']), 0.0);
    });
  });

  // ── getArbItemCurrentStock ─────────────────────────────────────────────────
  group('arbReturnGetItemCurrentStock – stock lookup', () {
    final stock = [
      {'itemId': 1, 'currentStk': 50},
      {'itemId': 2, 'currentStk': 30},
      {'itemId': 3, 'currentStk': 0},
    ];

    test('returns stock for matching itemId', () {
      expect(arbReturnGetItemCurrentStock(stock, 1), 50);
    });

    test('returns correct stock for different item', () {
      expect(arbReturnGetItemCurrentStock(stock, 2), 30);
    });

    test('returns 0 for itemId not in list', () {
      expect(arbReturnGetItemCurrentStock(stock, 99), 0);
    });

    test('returns 0 for null itemId', () {
      expect(arbReturnGetItemCurrentStock(stock, null), 0);
    });

    test('returns 0 for item with zero stock', () {
      expect(arbReturnGetItemCurrentStock(stock, 3), 0);
    });

    test('returns 0 for empty stock list', () {
      expect(arbReturnGetItemCurrentStock([], 1), 0);
    });
  });

  // ── hasValidItems ──────────────────────────────────────────────────────────
  group('arbReturnHasValidItems – item validation', () {
    test('valid item returns true', () {
      expect(
        arbReturnHasValidItems([
          {'ItemId': 5, 'ItemName': 'DGCC Book', 'Rate': '100', 'RetQty': '2'},
        ]),
        isTrue,
      );
    });

    test('ItemId = 0 returns false', () {
      expect(
        arbReturnHasValidItems([
          {'ItemId': 0, 'ItemName': 'Test', 'Rate': '100', 'RetQty': '1'},
        ]),
        isFalse,
      );
    });

    test('empty ItemName returns false', () {
      expect(
        arbReturnHasValidItems([
          {'ItemId': 5, 'ItemName': '', 'Rate': '100', 'RetQty': '2'},
        ]),
        isFalse,
      );
    });

    test('empty list returns false', () {
      expect(arbReturnHasValidItems([]), isFalse);
    });

    test('any one valid item in list returns true', () {
      expect(
        arbReturnHasValidItems([
          {'ItemId': 0, 'ItemName': '', 'Rate': '0', 'RetQty': '0'},
          {'ItemId': 5, 'ItemName': 'DGCC Book', 'Rate': '100', 'RetQty': '2'},
        ]),
        isTrue,
      );
    });
  });

  // ── hasValidRate ───────────────────────────────────────────────────────────
  group('arbReturnHasValidRate – rate validation', () {
    test('positive rate returns true', () {
      expect(
        arbReturnHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '100', 'RetQty': '1'},
        ]),
        isTrue,
      );
    });

    test('rate "0" returns false', () {
      expect(
        arbReturnHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '0', 'RetQty': '1'},
        ]),
        isFalse,
      );
    });

    test('empty rate returns false', () {
      expect(
        arbReturnHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '', 'RetQty': '1'},
        ]),
        isFalse,
      );
    });

    test('non-numeric rate returns false', () {
      expect(
        arbReturnHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': 'abc', 'RetQty': '1'},
        ]),
        isFalse,
      );
    });

    test('negative rate returns false', () {
      expect(
        arbReturnHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '-50', 'RetQty': '1'},
        ]),
        isFalse,
      );
    });
  });

  // ── hasValidQty ────────────────────────────────────────────────────────────
  group('arbReturnHasValidQty – qty validation', () {
    test('positive qty returns true', () {
      expect(
        arbReturnHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '100', 'RetQty': '3'},
        ]),
        isTrue,
      );
    });

    test('qty "0" returns false', () {
      expect(
        arbReturnHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '100', 'RetQty': '0'},
        ]),
        isFalse,
      );
    });

    test('empty qty returns false', () {
      expect(
        arbReturnHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '100', 'RetQty': ''},
        ]),
        isFalse,
      );
    });

    test('non-numeric qty returns false', () {
      expect(
        arbReturnHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '100', 'RetQty': 'abc'},
        ]),
        isFalse,
      );
    });
  });

  // ── Credit-note equality guard ─────────────────────────────────────────────
  group('arbReturnCreditAmtEqualsTotal', () {
    test('equal amounts returns true', () {
      expect(arbReturnCreditAmtEqualsTotal(500.0, 500.0), isTrue);
    });

    test('different amounts returns false', () {
      expect(arbReturnCreditAmtEqualsTotal(400.0, 500.0), isFalse);
    });

    test('zero both sides returns true', () {
      expect(arbReturnCreditAmtEqualsTotal(0.0, 0.0), isTrue);
    });
  });

  // ── Credit-note / delete guard ─────────────────────────────────────────────
  group('arbReturnIsCreditBlocked – cNAmt != 0 blocks edit/delete', () {
    test('cnAmt = 0 → not blocked', () {
      expect(arbReturnIsCreditBlocked(0.0), isFalse);
    });

    test('cnAmt > 0 → blocked', () {
      expect(arbReturnIsCreditBlocked(200.0), isTrue);
    });

    test('cnAmt negative → blocked', () {
      expect(arbReturnIsCreditBlocked(-100.0), isTrue);
    });
  });
}
