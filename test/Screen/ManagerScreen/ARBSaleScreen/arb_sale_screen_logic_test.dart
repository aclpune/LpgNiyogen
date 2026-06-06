// Unit tests for pure business-logic helpers in ArbSaleScreen:
//   • _updateSum()      → totalSum = (qty × rate) - discount
//   • updateTotalAmount() → sums all item net amounts
//   • discount > newAmt guard
//   • payment-mode validation
//   • contact-number validation (10-digit, starts with 6-9)
//   • transaction-code required for Bank/QR
//
// NO API calls | NO widget state | NO business logic changed

import 'package:flutter_test/flutter_test.dart';

// ─── Inline helpers mirroring ArbSaleScreen logic ────────────────────────────

/// Mirrors _updateSum():
/// totalSum = qty × rate - discount  (or rate - discount when qty == 0)
/// Returns null when newAmt < discount (discount exceeds total error)
double? arbSaleUpdateSum({
  required double rate,
  required double qty,
  required double discount,
}) {
  final newAmt  = qty != 0 ? qty * rate : rate;
  final totalSum = qty != 0 ? qty * rate - discount : rate - discount;
  if (newAmt < discount) return null; // signals discount error
  return totalSum;
}

/// Mirrors updateTotalAmount(): sums item net amounts
double arbSaleUpdateTotalAmount(List<String> amtTexts) {
  double total = 0.0;
  for (final txt in amtTexts) {
    total += double.tryParse(txt.trim()) ?? 0.0;
  }
  return total;
}

/// Payment-mode validation
bool arbSaleIsValidPaymentMode(String? mode) =>
    mode != null && ['Cash', 'Merchant QR', 'Partial'].contains(mode);

/// Contact-number validation (mirrors screen's onChanged guard)
bool arbSaleIsValidContact(String value) {
  if (value.isEmpty) return false;
  if (value.length != 10) return false;
  return RegExp(r'^[6789]').hasMatch(value);
}

/// Transaction-code required for Bank/QR payment
bool arbSaleTransCodeRequired(String? paymentMode, String transCode) {
  if (paymentMode == 'Merchant QR' || paymentMode == 'Bank') {
    return transCode.trim().isEmpty;
  }
  return false;
}

/// Invoice-no required check
bool arbSaleInvoiceRequired(String? invoiceNo) =>
    invoiceNo == null || invoiceNo.trim().isEmpty;

void main() {
  // ── _updateSum ─────────────────────────────────────────────────────────────
  group('arbSaleUpdateSum – totalSum = qty × rate - discount', () {
    test('2 × 950 - 10 = 1890', () {
      expect(arbSaleUpdateSum(rate: 950, qty: 2, discount: 10), 1890.0);
    });

    test('1 × 940 - 0 = 940', () {
      expect(arbSaleUpdateSum(rate: 940, qty: 1, discount: 0), 940.0);
    });

    test('zero qty falls back to rate - discount', () {
      expect(arbSaleUpdateSum(rate: 500, qty: 0, discount: 50), 450.0);
    });

    test('no discount: qty × rate', () {
      expect(arbSaleUpdateSum(rate: 1000, qty: 3, discount: 0), 3000.0);
    });

    test('discount equals total → 0', () {
      expect(arbSaleUpdateSum(rate: 100, qty: 2, discount: 200), 0.0);
    });

    test('discount exceeds total → returns null (discount error)', () {
      expect(arbSaleUpdateSum(rate: 100, qty: 1, discount: 200), isNull);
    });

    test('fractional rate and qty', () {
      expect(
        arbSaleUpdateSum(rate: 99.99, qty: 2, discount: 0),
        closeTo(199.98, 0.001),
      );
    });

    test('large values', () {
      expect(
        arbSaleUpdateSum(rate: 10000, qty: 5, discount: 500),
        49500.0,
      );
    });
  });

  // ── updateTotalAmount ──────────────────────────────────────────────────────
  group('arbSaleUpdateTotalAmount – sums net amounts', () {
    test('single item', () {
      expect(arbSaleUpdateTotalAmount(['940.00']), 940.0);
    });

    test('multiple items', () {
      expect(arbSaleUpdateTotalAmount(['940.00', '1890.00']), 2830.0);
    });

    test('empty list → 0', () {
      expect(arbSaleUpdateTotalAmount([]), 0.0);
    });

    test('ignores empty strings', () {
      expect(arbSaleUpdateTotalAmount(['', '500.00', '']), 500.0);
    });

    test('ignores non-numeric strings', () {
      expect(arbSaleUpdateTotalAmount(['abc', '200.00']), 200.0);
    });

    test('all zeros → 0', () {
      expect(arbSaleUpdateTotalAmount(['0.00', '0.00']), 0.0);
    });

    test('three items sum correctly', () {
      expect(
        arbSaleUpdateTotalAmount(['100.00', '200.00', '300.00']),
        600.0,
      );
    });
  });

  // ── payment-mode validation ────────────────────────────────────────────────
  group('arbSaleIsValidPaymentMode', () {
    test('"Cash" is valid', () {
      expect(arbSaleIsValidPaymentMode('Cash'), isTrue);
    });

    test('"Merchant QR" is valid', () {
      expect(arbSaleIsValidPaymentMode('Merchant QR'), isTrue);
    });

    test('"Partial" is valid', () {
      expect(arbSaleIsValidPaymentMode('Partial'), isTrue);
    });

    test('null is invalid', () {
      expect(arbSaleIsValidPaymentMode(null), isFalse);
    });

    test('empty string is invalid', () {
      expect(arbSaleIsValidPaymentMode(''), isFalse);
    });

    test('"Bank" is not in ARB Sale modes', () {
      expect(arbSaleIsValidPaymentMode('Bank'), isFalse);
    });

    test('random string is invalid', () {
      expect(arbSaleIsValidPaymentMode('UPI'), isFalse);
    });
  });

  // ── contact-number validation ──────────────────────────────────────────────
  group('arbSaleIsValidContact', () {
    test('valid 10-digit starting with 9', () {
      expect(arbSaleIsValidContact('9377484898'), isTrue);
    });

    test('valid starting with 6', () {
      expect(arbSaleIsValidContact('6000000001'), isTrue);
    });

    test('valid starting with 7', () {
      expect(arbSaleIsValidContact('7000000001'), isTrue);
    });

    test('valid starting with 8', () {
      expect(arbSaleIsValidContact('8000000001'), isTrue);
    });

    test('empty string is invalid', () {
      expect(arbSaleIsValidContact(''), isFalse);
    });

    test('9-digit number is invalid', () {
      expect(arbSaleIsValidContact('937748489'), isFalse);
    });

    test('11-digit number is invalid', () {
      expect(arbSaleIsValidContact('93774848980'), isFalse);
    });

    test('starts with 5 is invalid', () {
      expect(arbSaleIsValidContact('5000000001'), isFalse);
    });

    test('starts with 1 is invalid', () {
      expect(arbSaleIsValidContact('1234567890'), isFalse);
    });

    test('starts with 0 is invalid', () {
      expect(arbSaleIsValidContact('0000000000'), isFalse);
    });

    test('contains letters still passes guard (starts with 9, length 10)', () {
      expect(arbSaleIsValidContact('9abc484898'), isTrue);
    });
  });

  // ── transaction-code required ──────────────────────────────────────────────
  group('arbSaleTransCodeRequired', () {
    test('Merchant QR with empty transCode requires it', () {
      expect(arbSaleTransCodeRequired('Merchant QR', ''), isTrue);
    });

    test('Merchant QR with filled transCode does NOT require', () {
      expect(arbSaleTransCodeRequired('Merchant QR', 'TRN849329'), isFalse);
    });

    test('Cash does NOT require transCode', () {
      expect(arbSaleTransCodeRequired('Cash', ''), isFalse);
    });

    test('Partial does NOT require transCode', () {
      expect(arbSaleTransCodeRequired('Partial', ''), isFalse);
    });

    test('Bank with empty transCode requires it', () {
      expect(arbSaleTransCodeRequired('Bank', ''), isTrue);
    });

    test('null mode does NOT require transCode', () {
      expect(arbSaleTransCodeRequired(null, ''), isFalse);
    });
  });

  // ── invoice-number validation ──────────────────────────────────────────────
  group('arbSaleInvoiceRequired', () {
    test('null invoiceNo requires it', () {
      expect(arbSaleInvoiceRequired(null), isTrue);
    });

    test('empty invoiceNo requires it', () {
      expect(arbSaleInvoiceRequired(''), isTrue);
    });

    test('whitespace-only invoiceNo requires it', () {
      expect(arbSaleInvoiceRequired('   '), isTrue);
    });

    test('valid invoiceNo does not require it', () {
      expect(arbSaleInvoiceRequired('5588494'), isFalse);
    });
  });

  // ── discount edge-cases ────────────────────────────────────────────────────
  group('discount validation edge-cases', () {
    test('discount exactly equal to amount → allowed (returns 0)', () {
      final result = arbSaleUpdateSum(rate: 200, qty: 1, discount: 200);
      expect(result, 0.0);
    });

    test('discount 1 more than amount → null (error)', () {
      final result = arbSaleUpdateSum(rate: 200, qty: 1, discount: 201);
      expect(result, isNull);
    });

    test('discount 0 → returns full amount', () {
      expect(arbSaleUpdateSum(rate: 300, qty: 2, discount: 0), 600.0);
    });
  });
}

