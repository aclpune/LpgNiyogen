// Unit tests for pure business-logic helpers in ArbScreen (ARB Purchase):
//   • hasValidItems / hasValidRate / hasValidQty (purchase variant)
//   • vendor-name validation (required)
//   • vendor mobile-number validation (10-digit, starts 6-9)
//   • invoice-number required
//   • purchase amount computation: netAmt = basicAmt + taxAmt
//   • balance amount: balance = totalBill - paid
//
// NO API calls | NO widget state | NO business logic changed

import 'package:flutter_test/flutter_test.dart';

// ─── Inline helpers mirroring ArbScreen logic ─────────────────────────────────

bool arbPurHasValidItems(List<Map<String, dynamic>> items) =>
    items.any((item) =>
        item['ItemId'] != 0 && item['ItemName'].toString().isNotEmpty);

bool arbPurHasValidRate(List<Map<String, dynamic>> items) =>
    items.any((item) =>
        item['ItemId'] != 0 &&
        item['Rate'].toString().isNotEmpty &&
        num.tryParse(item['Rate'].toString()) != null &&
        num.parse(item['Rate'].toString()) > 0);

bool arbPurHasValidQty(List<Map<String, dynamic>> items) =>
    items.any((item) =>
        item['ItemId'] != 0 &&
        item['PurQty'].toString().isNotEmpty &&
        num.tryParse(item['PurQty'].toString()) != null &&
        num.parse(item['PurQty'].toString()) > 0);

bool arbPurInvoiceRequired(String? invoice) =>
    invoice == null || invoice.trim().isEmpty;

bool arbPurVendorRequired(dynamic vendor) => vendor == null;

bool arbPurItemsRequired(Map<int, dynamic> selectedItems) =>
    selectedItems.isEmpty;

bool arbPurIsValidVendorName(String name) => name.trim().isNotEmpty;

bool arbPurIsValidVendorMobile(String mobile) {
  if (mobile.isEmpty || mobile.length != 10) return false;
  return RegExp(r'^[6789]').hasMatch(mobile);
}

double arbPurNetAmount(double basicAmt, double taxAmt) => basicAmt + taxAmt;

double arbPurBasicAmount(double rate, double qty) => rate * qty;

double arbPurBalanceAmount(double totalBill, double paid) => totalBill - paid;

void main() {
  // ── hasValidItems ──────────────────────────────────────────────────────────
  group('arbPurHasValidItems', () {
    test('valid item → true', () {
      expect(
        arbPurHasValidItems([
          {'ItemId': 11, 'ItemName': 'Safety Hose', 'Rate': '800', 'PurQty': '2'},
        ]),
        isTrue,
      );
    });

    test('ItemId=0 → false', () {
      expect(
        arbPurHasValidItems([
          {'ItemId': 0, 'ItemName': 'Item', 'Rate': '800', 'PurQty': '2'},
        ]),
        isFalse,
      );
    });

    test('empty ItemName → false', () {
      expect(
        arbPurHasValidItems([
          {'ItemId': 5, 'ItemName': '', 'Rate': '800', 'PurQty': '2'},
        ]),
        isFalse,
      );
    });

    test('empty list → false', () {
      expect(arbPurHasValidItems([]), isFalse);
    });

    test('one invalid + one valid → true', () {
      expect(
        arbPurHasValidItems([
          {'ItemId': 0, 'ItemName': '', 'Rate': '0', 'PurQty': '0'},
          {'ItemId': 11, 'ItemName': 'Hose', 'Rate': '800', 'PurQty': '2'},
        ]),
        isTrue,
      );
    });
  });

  // ── hasValidRate ───────────────────────────────────────────────────────────
  group('arbPurHasValidRate', () {
    test('positive rate → true', () {
      expect(
        arbPurHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '800', 'PurQty': '2'},
        ]),
        isTrue,
      );
    });

    test('rate "0" → false', () {
      expect(
        arbPurHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '0', 'PurQty': '2'},
        ]),
        isFalse,
      );
    });

    test('empty rate → false', () {
      expect(
        arbPurHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '', 'PurQty': '2'},
        ]),
        isFalse,
      );
    });

    test('non-numeric rate → false', () {
      expect(
        arbPurHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': 'abc', 'PurQty': '2'},
        ]),
        isFalse,
      );
    });

    test('negative rate → false', () {
      expect(
        arbPurHasValidRate([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '-100', 'PurQty': '2'},
        ]),
        isFalse,
      );
    });
  });

  // ── hasValidQty ────────────────────────────────────────────────────────────
  group('arbPurHasValidQty', () {
    test('positive PurQty → true', () {
      expect(
        arbPurHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '800', 'PurQty': '5'},
        ]),
        isTrue,
      );
    });

    test('PurQty "0" → false', () {
      expect(
        arbPurHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '800', 'PurQty': '0'},
        ]),
        isFalse,
      );
    });

    test('empty PurQty → false', () {
      expect(
        arbPurHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '800', 'PurQty': ''},
        ]),
        isFalse,
      );
    });

    test('non-numeric PurQty → false', () {
      expect(
        arbPurHasValidQty([
          {'ItemId': 1, 'ItemName': 'A', 'Rate': '800', 'PurQty': 'x'},
        ]),
        isFalse,
      );
    });
  });

  // ── invoice / vendor / items required ─────────────────────────────────────
  group('arbPur required-field guards', () {
    test('null invoice → required', () {
      expect(arbPurInvoiceRequired(null), isTrue);
    });

    test('empty invoice → required', () {
      expect(arbPurInvoiceRequired(''), isTrue);
    });

    test('whitespace invoice → required', () {
      expect(arbPurInvoiceRequired('   '), isTrue);
    });

    test('valid invoice → not required', () {
      expect(arbPurInvoiceRequired('INV-001'), isFalse);
    });

    test('null vendor → required', () {
      expect(arbPurVendorRequired(null), isTrue);
    });

    test('non-null vendor → not required', () {
      expect(arbPurVendorRequired('Test Vendor'), isFalse);
    });

    test('empty selectedItems map → required', () {
      expect(arbPurItemsRequired({}), isTrue);
    });

    test('non-empty selectedItems map → not required', () {
      expect(arbPurItemsRequired({0: 'Safety Hose'}), isFalse);
    });
  });

  // ── vendor-name validation ─────────────────────────────────────────────────
  group('arbPurIsValidVendorName', () {
    test('non-empty name → valid', () {
      expect(arbPurIsValidVendorName('Sagar Parmar'), isTrue);
    });

    test('empty name → invalid', () {
      expect(arbPurIsValidVendorName(''), isFalse);
    });

    test('whitespace-only → invalid', () {
      expect(arbPurIsValidVendorName('   '), isFalse);
    });
  });

  // ── vendor mobile validation ───────────────────────────────────────────────
  group('arbPurIsValidVendorMobile', () {
    test('valid 10-digit starting with 9', () {
      expect(arbPurIsValidVendorMobile('9377484898'), isTrue);
    });

    test('valid starting with 6', () {
      expect(arbPurIsValidVendorMobile('6123456789'), isTrue);
    });

    test('9-digit → invalid', () {
      expect(arbPurIsValidVendorMobile('937748489'), isFalse);
    });

    test('11-digit → invalid', () {
      expect(arbPurIsValidVendorMobile('93774848980'), isFalse);
    });

    test('starts with 5 → invalid', () {
      expect(arbPurIsValidVendorMobile('5000000001'), isFalse);
    });

    test('starts with 0 → invalid', () {
      expect(arbPurIsValidVendorMobile('0000000000'), isFalse);
    });

    test('empty → invalid', () {
      expect(arbPurIsValidVendorMobile(''), isFalse);
    });
  });

  // ── purchase amount computations ───────────────────────────────────────────
  group('arbPurNetAmount – basicAmt + taxAmt', () {
    test('1600 + 50 = 1650', () {
      expect(arbPurNetAmount(1600.0, 50.0), 1650.0);
    });

    test('zero tax → equals basicAmt', () {
      expect(arbPurNetAmount(800.0, 0.0), 800.0);
    });

    test('fractional values', () {
      expect(arbPurNetAmount(799.50, 49.50), 849.0);
    });
  });

  group('arbPurBasicAmount – rate × qty', () {
    test('800 × 2 = 1600', () {
      expect(arbPurBasicAmount(800.0, 2.0), 1600.0);
    });

    test('zero qty → 0', () {
      expect(arbPurBasicAmount(800.0, 0.0), 0.0);
    });

    test('fractional rate and qty', () {
      expect(arbPurBasicAmount(99.99, 3.0), closeTo(299.97, 0.001));
    });
  });

  group('arbPurBalanceAmount – totalBill - paid', () {
    test('1650 - 0 = 1650 (unpaid)', () {
      expect(arbPurBalanceAmount(1650.0, 0.0), 1650.0);
    });

    test('1650 - 800 = 850', () {
      expect(arbPurBalanceAmount(1650.0, 800.0), 850.0);
    });

    test('fully paid → 0', () {
      expect(arbPurBalanceAmount(1650.0, 1650.0), 0.0);
    });

    test('over-paid → negative balance', () {
      expect(arbPurBalanceAmount(1000.0, 1200.0), -200.0);
    });
  });
}

