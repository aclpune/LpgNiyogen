// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerDSRExpenseUI.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerDSRExpenseUI ─────────────────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

bool isEvenRow(int serialNumber) => serialNumber % 2 == 0;
String expenseHeadDisplay(String? head) => head ?? 'No Head';
String cashDisplay(double cash) => '‚ ${formatCurrency(cash)}';
String bankDisplay(double bank) => '‚ ${formatCurrency(bank)}';

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerDSRExpenseUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative no throw', () => expect(() => formatCurrency(-50.0), returnsNormally));
    test('same input same output', () => expect(formatCurrency(200.0), formatCurrency(200.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
  });

  // ── isEvenRow ─────────────────────────────────────────────────────────────
  group('[ManagerDSRExpenseUI] isEvenRow', () {
    test('2 → even', () => expect(isEvenRow(2), isTrue));
    test('1 → odd', () => expect(isEvenRow(1), isFalse));
    test('100 → even', () => expect(isEvenRow(100), isTrue));
    test('99 → odd', () => expect(isEvenRow(99), isFalse));
    for (int i = 1; i <= 10; i++) {
      test('serial $i isEven == (i%2==0)', () => expect(isEvenRow(i), i % 2 == 0));
    }
  });

  // ── expenseHeadDisplay ────────────────────────────────────────────────────
  group('[ManagerDSRExpenseUI] expenseHeadDisplay', () {
    test('valid head returned', () => expect(expenseHeadDisplay('Fuel'), 'Fuel'));
    test('null → "No Head"', () => expect(expenseHeadDisplay(null), 'No Head'));
    test('empty string returned', () => expect(expenseHeadDisplay(''), ''));
    test('"Maintenance" returned', () => expect(expenseHeadDisplay('Maintenance'), 'Maintenance'));
  });

  // ── cashDisplay ───────────────────────────────────────────────────────────
  group('[ManagerDSRExpenseUI] cashDisplay', () {
    test('0 → "‚ 0.00"', () => expect(cashDisplay(0), '‚ 0.00'));
    test('500.0 starts with "‚ "', () => expect(cashDisplay(500.0).startsWith('‚ '), isTrue));
    test('0.5 → "‚ 0..."', () => expect(cashDisplay(0.5).startsWith('‚ 0'), isTrue));
    test('1000 contains "1"', () => expect(cashDisplay(1000.0).contains('1'), isTrue));
  });

  // ── bankDisplay ───────────────────────────────────────────────────────────
  group('[ManagerDSRExpenseUI] bankDisplay', () {
    test('0 → "‚ 0.00"', () => expect(bankDisplay(0), '‚ 0.00'));
    test('300.0 starts with "‚ "', () => expect(bankDisplay(300.0).startsWith('‚ '), isTrue));
    test('same as cashDisplay for same amount', () =>
        expect(bankDisplay(500.0), cashDisplay(500.0)));
  });
}

