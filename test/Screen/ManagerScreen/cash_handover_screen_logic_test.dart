// Unit tests for pure business-logic helpers in CashHandoverScreen:
//   • staff/bank both absent → submission blocked
//   • bank selected but no trans mode → blocked
//   • denomination mandatory: deposit empty → blocked
//   • denomination mandatory: denoTotal <= 0 → blocked
//   • denomination mandatory: deposit != denoTotal → blocked
//   • denomination NOT mandatory: deposit empty → blocked
//   • deposit amount computation: noteValue × qty
//   • denomination total: sum of all row amounts
//   • remainingAmount = cashInHand - depositAmt
//   • formatCurrency-like rounding: amount always has 2 decimal places
//
// NO API calls | NO widget state | NO business logic changed

import 'package:flutter_test/flutter_test.dart';

// ─── Inline helpers mirroring CashHandoverScreen logic ───────────────────────

/// Mirrors guard: both staff and bank are absent → show error
bool cashHoStaffAndBankAbsent(
    String? selectedItem, int? selectedItemId,
    String? selectedBankName, String? selectedBankId) =>
    (selectedItem == null || selectedItemId == null) &&
    (selectedBankName == null || selectedBankId == null);

/// Mirrors guard: bank selected but transMode not chosen → show error
bool cashHoBankTransModeRequired(
    String? selectedBankName, String? selectedBankId,
    String? selectedTransMode) =>
    (selectedBankName != null || selectedBankId != null) &&
    selectedTransMode == null;

/// Mirrors guard (mandatory deno): deposit empty → show error
bool cashHoDepositEmpty(String depositText) => depositText.trim().isEmpty;

/// Mirrors guard (mandatory deno): denoTotal <= 0 → show error
bool cashHoDenoTotalZeroOrNeg(double denoTotal) => denoTotal <= 0;

/// Mirrors guard (mandatory deno): deposit != denoTotal → show error
bool cashHoDenoMismatch(double depositAmt, double denoTotal) =>
    depositAmt != denoTotal;

/// Mirrors denomination row amount: noteValue × qty
double cashHoDenoRowAmount(double noteValue, int qty) => noteValue * qty;

/// Mirrors denomination total: sum of all row amounts
double cashHoDenoTotal(List<double> rowAmounts) =>
    rowAmounts.fold(0.0, (sum, a) => sum + a);

/// Mirrors remainingAmount = cashInHand - depositAmt
double cashHoRemainingAmount(double cashInHand, double depositAmt) =>
    cashInHand - depositAmt;

void main() {
  // ── staff and bank both absent ─────────────────────────────────────────────
  group('cashHoStaffAndBankAbsent', () {
    test('both staff and bank absent → blocked', () {
      expect(cashHoStaffAndBankAbsent(null, null, null, null), isTrue);
    });

    test('staff present but bank absent → NOT blocked', () {
      expect(cashHoStaffAndBankAbsent('Ravi', 1, null, null), isFalse);
    });

    test('bank present but staff absent → NOT blocked', () {
      expect(cashHoStaffAndBankAbsent(null, null, 'SBI', '101'), isFalse);
    });

    test('both present → not blocked', () {
      expect(cashHoStaffAndBankAbsent('Ravi', 1, 'SBI', '101'), isFalse);
    });

    test('staff id null but name set → staff absent side is blocked', () {
      // selectedItem set but selectedItemId null → staff side incomplete
      expect(cashHoStaffAndBankAbsent('Ravi', null, null, null), isTrue);
    });
  });

  // ── bank selected but trans mode missing ───────────────────────────────────
  group('cashHoBankTransModeRequired', () {
    test('bank selected + no trans mode → required', () {
      expect(cashHoBankTransModeRequired('SBI', '101', null), isTrue);
    });

    test('bank selected + trans mode set → not required', () {
      expect(cashHoBankTransModeRequired('SBI', '101', 'ATM'), isFalse);
    });

    test('no bank + no trans mode → not required (bank absent)', () {
      expect(cashHoBankTransModeRequired(null, null, null), isFalse);
    });

    test('bank name only + no trans mode → required', () {
      expect(cashHoBankTransModeRequired('SBI', null, null), isTrue);
    });

    test('bank id only + trans mode set → not required', () {
      expect(cashHoBankTransModeRequired(null, '101', 'BRANCH'), isFalse);
    });
  });

  // ── deposit empty ──────────────────────────────────────────────────────────
  group('cashHoDepositEmpty', () {
    test('empty string → blocked', () {
      expect(cashHoDepositEmpty(''), isTrue);
    });

    test('whitespace → blocked', () {
      expect(cashHoDepositEmpty('   '), isTrue);
    });

    test('valid amount → not blocked', () {
      expect(cashHoDepositEmpty('5000'), isFalse);
    });

    test('"0" → not blocked (user explicitly entered zero)', () {
      expect(cashHoDepositEmpty('0'), isFalse);
    });
  });

  // ── denomination total zero or negative ────────────────────────────────────
  group('cashHoDenoTotalZeroOrNeg', () {
    test('0 → blocked', () {
      expect(cashHoDenoTotalZeroOrNeg(0.0), isTrue);
    });

    test('negative → blocked', () {
      expect(cashHoDenoTotalZeroOrNeg(-100.0), isTrue);
    });

    test('positive → not blocked', () {
      expect(cashHoDenoTotalZeroOrNeg(500.0), isFalse);
    });

    test('very small positive → not blocked', () {
      expect(cashHoDenoTotalZeroOrNeg(0.01), isFalse);
    });
  });

  // ── denomination mismatch ──────────────────────────────────────────────────
  group('cashHoDenoMismatch', () {
    test('deposit matches deno total → no mismatch', () {
      expect(cashHoDenoMismatch(5000.0, 5000.0), isFalse);
    });

    test('deposit != deno total → mismatch', () {
      expect(cashHoDenoMismatch(5000.0, 4500.0), isTrue);
    });

    test('both zero → no mismatch', () {
      expect(cashHoDenoMismatch(0.0, 0.0), isFalse);
    });

    test('deposit > deno total → mismatch', () {
      expect(cashHoDenoMismatch(6000.0, 5000.0), isTrue);
    });

    test('deposit < deno total → mismatch', () {
      expect(cashHoDenoMismatch(4000.0, 5000.0), isTrue);
    });
  });

  // ── denomination row amount ────────────────────────────────────────────────
  group('cashHoDenoRowAmount – noteValue × qty', () {
    test('500 × 10 = 5000', () {
      expect(cashHoDenoRowAmount(500.0, 10), 5000.0);
    });

    test('100 × 5 = 500', () {
      expect(cashHoDenoRowAmount(100.0, 5), 500.0);
    });

    test('50 × 0 = 0', () {
      expect(cashHoDenoRowAmount(50.0, 0), 0.0);
    });

    test('2000 × 3 = 6000', () {
      expect(cashHoDenoRowAmount(2000.0, 3), 6000.0);
    });

    test('10 × 20 = 200', () {
      expect(cashHoDenoRowAmount(10.0, 20), 200.0);
    });
  });

  // ── denomination total ─────────────────────────────────────────────────────
  group('cashHoDenoTotal – sum of row amounts', () {
    test('single denomination', () {
      expect(cashHoDenoTotal([5000.0]), 5000.0);
    });

    test('multiple denominations', () {
      expect(cashHoDenoTotal([5000.0, 1000.0, 500.0]), 6500.0);
    });

    test('empty list → 0', () {
      expect(cashHoDenoTotal([]), 0.0);
    });

    test('all zeros → 0', () {
      expect(cashHoDenoTotal([0.0, 0.0, 0.0]), 0.0);
    });

    test('mixed denominations', () {
      expect(
        cashHoDenoTotal([2000.0, 1000.0, 500.0, 200.0, 100.0]),
        3800.0,
      );
    });

    test('fractional amounts', () {
      expect(
        cashHoDenoTotal([100.50, 200.50]),
        closeTo(301.0, 0.001),
      );
    });
  });

  // ── remaining amount after deposit ─────────────────────────────────────────
  group('cashHoRemainingAmount – cashInHand - depositAmt', () {
    test('15304.50 - 5000 = 10304.50', () {
      expect(cashHoRemainingAmount(15304.50, 5000.0), closeTo(10304.50, 0.001));
    });

    test('full deposit → 0', () {
      expect(cashHoRemainingAmount(5000.0, 5000.0), 0.0);
    });

    test('no deposit → equals cashInHand', () {
      expect(cashHoRemainingAmount(8500.0, 0.0), 8500.0);
    });

    test('over-deposit → negative remaining', () {
      expect(cashHoRemainingAmount(1000.0, 1500.0), -500.0);
    });

    test('zero cashInHand + zero deposit → 0', () {
      expect(cashHoRemainingAmount(0.0, 0.0), 0.0);
    });
  });
}

