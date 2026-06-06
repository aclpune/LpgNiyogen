// Unit tests for pure business-logic helpers in AddPaymentPopupScreen:
//   • transMode required guard
//   • expense required guard
//   • paid-amount required guard
//   • Online mode: bank required + transaction-code required
//   • Cash denomination total vs entered amount (must match)
//   • ADD mode: paid amount cannot exceed balance
//   • EDIT mode: paid amount cannot exceed (editTotal + balance)
//   • Balance = 0 → edit/delete blocked
//   • denomination row amount: noteQty × noteValue
//   • remaining-amount after payment: balance - paid
//
// NO API calls | NO widget state | NO business logic changed

import 'package:flutter_test/flutter_test.dart';

// ─── Inline helpers mirroring AddPaymentPopupScreen logic ─────────────────────

/// Mirrors guard: selectedTransMode null or empty → show error
bool addPayTransModeRequired(String? mode) =>
    mode == null || mode.trim().isEmpty;

/// Mirrors guard: selectedExpense == null → show error
bool addPayExpenseRequired(dynamic expense) => expense == null;

/// Mirrors guard: _balanceController.text.isEmpty → show error
bool addPayPaidAmountRequired(String amountText) =>
    amountText.trim().isEmpty;

/// Mirrors guard: Online mode + bank not selected → show error
bool addPayOnlineBankRequired(String? mode, bool bankSelected) =>
    mode == 'Online' && !bankSelected;

/// Mirrors guard: Online mode + transaction code empty → show error
bool addPayOnlineTransCodeRequired(String? mode, String transCode) =>
    mode == 'Online' && transCode.trim().isEmpty;

/// Mirrors ADD mode guard: totalAmt > balanceAmtNum → show error
bool addPayExceedsBalanceAdd(double totalAmt, double balanceAmt) =>
    totalAmt > balanceAmt;

/// Mirrors EDIT mode guard: totalAmt > (editTotalAmt + balanceAmt) → show error
bool addPayExceedsBalanceEdit(
    double totalAmt, double editTotalAmt, double balanceAmt) =>
    totalAmt > (editTotalAmt + balanceAmt);

/// Mirrors Cash mode: cash-denomination total != entered amount → show error
bool addPayCashDenoMismatch(double enteredAmt, double denoTotal) =>
    enteredAmt != denoTotal;

/// Mirrors balance = 0 → edit/delete icon is blocked
bool addPayBalanceIsZero(String? balanceAmt) =>
    balanceAmt == '0' || balanceAmt == '0.0' ||
    (double.tryParse(balanceAmt ?? '') == 0.0);

/// Mirrors denomination row amount = noteValue × qty
double addPayDenoRowAmount(double noteValue, int qty) => noteValue * qty;

/// Mirrors remaining balance after ADD payment: balance - paid
double addPayRemainingBalance(double balanceAmt, double paidAmt) =>
    balanceAmt - paidAmt;

void main() {
  // ── transMode required ─────────────────────────────────────────────────────
  group('addPayTransModeRequired', () {
    test('null mode → required', () {
      expect(addPayTransModeRequired(null), isTrue);
    });

    test('empty mode → required', () {
      expect(addPayTransModeRequired(''), isTrue);
    });

    test('whitespace mode → required', () {
      expect(addPayTransModeRequired('   '), isTrue);
    });

    test('"Cash" → not required', () {
      expect(addPayTransModeRequired('Cash'), isFalse);
    });

    test('"Online" → not required', () {
      expect(addPayTransModeRequired('Online'), isFalse);
    });
  });

  // ── expense required ───────────────────────────────────────────────────────
  group('addPayExpenseRequired', () {
    test('null expense → required', () {
      expect(addPayExpenseRequired(null), isTrue);
    });

    test('non-null expense → not required', () {
      expect(addPayExpenseRequired('Fuel'), isFalse);
    });
  });

  // ── paid amount required ───────────────────────────────────────────────────
  group('addPayPaidAmountRequired', () {
    test('empty text → required', () {
      expect(addPayPaidAmountRequired(''), isTrue);
    });

    test('whitespace → required', () {
      expect(addPayPaidAmountRequired('   '), isTrue);
    });

    test('valid amount text → not required', () {
      expect(addPayPaidAmountRequired('500.00'), isFalse);
    });
  });

  // ── Online mode: bank required ─────────────────────────────────────────────
  group('addPayOnlineBankRequired', () {
    test('Online + no bank → required', () {
      expect(addPayOnlineBankRequired('Online', false), isTrue);
    });

    test('Online + bank selected → not required', () {
      expect(addPayOnlineBankRequired('Online', true), isFalse);
    });

    test('Cash + no bank → not required', () {
      expect(addPayOnlineBankRequired('Cash', false), isFalse);
    });

    test('null mode + no bank → not required', () {
      expect(addPayOnlineBankRequired(null, false), isFalse);
    });
  });

  // ── Online mode: transaction code required ─────────────────────────────────
  group('addPayOnlineTransCodeRequired', () {
    test('Online + empty transCode → required', () {
      expect(addPayOnlineTransCodeRequired('Online', ''), isTrue);
    });

    test('Online + filled transCode → not required', () {
      expect(addPayOnlineTransCodeRequired('Online', 'TXN123456'), isFalse);
    });

    test('Cash + empty transCode → not required', () {
      expect(addPayOnlineTransCodeRequired('Cash', ''), isFalse);
    });

    test('null mode + empty transCode → not required', () {
      expect(addPayOnlineTransCodeRequired(null, ''), isFalse);
    });
  });

  // ── ADD mode: paid amount exceeds balance ──────────────────────────────────
  group('addPayExceedsBalanceAdd', () {
    test('paid < balance → allowed', () {
      expect(addPayExceedsBalanceAdd(500.0, 1000.0), isFalse);
    });

    test('paid == balance → allowed', () {
      expect(addPayExceedsBalanceAdd(1000.0, 1000.0), isFalse);
    });

    test('paid > balance → blocked', () {
      expect(addPayExceedsBalanceAdd(1200.0, 1000.0), isTrue);
    });

    test('paid = 0 → allowed', () {
      expect(addPayExceedsBalanceAdd(0.0, 500.0), isFalse);
    });
  });

  // ── EDIT mode: paid amount exceeds (editTotal + balance) ──────────────────
  group('addPayExceedsBalanceEdit', () {
    test('paid < (editTotal + balance) → allowed', () {
      expect(addPayExceedsBalanceEdit(500.0, 300.0, 400.0), isFalse);
    });

    test('paid == (editTotal + balance) → allowed', () {
      expect(addPayExceedsBalanceEdit(700.0, 300.0, 400.0), isFalse);
    });

    test('paid > (editTotal + balance) → blocked', () {
      expect(addPayExceedsBalanceEdit(800.0, 300.0, 400.0), isTrue);
    });

    test('editTotal 0 → same as ADD mode', () {
      expect(addPayExceedsBalanceEdit(1001.0, 0.0, 1000.0), isTrue);
    });
  });

  // ── Cash denomination mismatch ─────────────────────────────────────────────
  group('addPayCashDenoMismatch', () {
    test('enteredAmt matches denoTotal → no mismatch', () {
      expect(addPayCashDenoMismatch(1000.0, 1000.0), isFalse);
    });

    test('enteredAmt != denoTotal → mismatch', () {
      expect(addPayCashDenoMismatch(1000.0, 900.0), isTrue);
    });

    test('both zero → no mismatch', () {
      expect(addPayCashDenoMismatch(0.0, 0.0), isFalse);
    });

    test('entered > denoTotal → mismatch', () {
      expect(addPayCashDenoMismatch(1500.0, 1000.0), isTrue);
    });
  });

  // ── balance = 0 blocks edit/delete ─────────────────────────────────────────
  group('addPayBalanceIsZero', () {
    test('"0" → blocked', () {
      expect(addPayBalanceIsZero('0'), isTrue);
    });

    test('"0.0" → blocked', () {
      expect(addPayBalanceIsZero('0.0'), isTrue);
    });

    test('"0.00" → blocked', () {
      expect(addPayBalanceIsZero('0.00'), isTrue);
    });

    test('"500.0" → not blocked', () {
      expect(addPayBalanceIsZero('500.0'), isFalse);
    });

    test('"100" → not blocked', () {
      expect(addPayBalanceIsZero('100'), isFalse);
    });

    test('null → not blocked', () {
      expect(addPayBalanceIsZero(null), isFalse);
    });
  });

  // ── denomination row amount ────────────────────────────────────────────────
  group('addPayDenoRowAmount – noteValue × qty', () {
    test('500 × 2 = 1000', () {
      expect(addPayDenoRowAmount(500.0, 2), 1000.0);
    });

    test('100 × 5 = 500', () {
      expect(addPayDenoRowAmount(100.0, 5), 500.0);
    });

    test('50 × 0 = 0', () {
      expect(addPayDenoRowAmount(50.0, 0), 0.0);
    });

    test('10 × 10 = 100', () {
      expect(addPayDenoRowAmount(10.0, 10), 100.0);
    });
  });

  // ── remaining balance after payment ───────────────────────────────────────
  group('addPayRemainingBalance – balance - paid', () {
    test('1650 - 0 = 1650 (unpaid)', () {
      expect(addPayRemainingBalance(1650.0, 0.0), 1650.0);
    });

    test('1650 - 800 = 850', () {
      expect(addPayRemainingBalance(1650.0, 800.0), 850.0);
    });

    test('1650 - 1650 = 0 (fully paid)', () {
      expect(addPayRemainingBalance(1650.0, 1650.0), 0.0);
    });

    test('over-paid → negative remaining', () {
      expect(addPayRemainingBalance(1000.0, 1200.0), -200.0);
    });
  });
}

