// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerIncomeUnsettledScreenDetailUI.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerIncomeUnsettledScreenDetailUI ───────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

bool isEvenRow(int serialNumber) => serialNumber % 2 == 0;
String staffNameDisplay(String? name) => name ?? '';
String qtyDisplay(dynamic qty) => qty.toString();
String amountDisplay(double amount) => '‚ ${formatCurrency(amount)}';

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetailUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative no throw', () => expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () => expect(formatCurrency(800.0), formatCurrency(800.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
    test('0.99 starts with "0."', () => expect(formatCurrency(0.99).startsWith('0.'), isTrue));
  });

  // ── isEvenRow ─────────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetailUI] isEvenRow', () {
    test('2 → true', () => expect(isEvenRow(2), isTrue));
    test('1 → false', () => expect(isEvenRow(1), isFalse));
    test('0 → true', () => expect(isEvenRow(0), isTrue));
    test('100 → true', () => expect(isEvenRow(100), isTrue));
    test('99 → false', () => expect(isEvenRow(99), isFalse));
    for (int i = 1; i <= 6; i++) {
      test('serial $i → ${i % 2 == 0}', () => expect(isEvenRow(i), i % 2 == 0));
    }
  });

  // ── staffNameDisplay ──────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetailUI] staffNameDisplay', () {
    test('valid name returned', () => expect(staffNameDisplay('Ravi Kumar'), 'Ravi Kumar'));
    test('null → ""', () => expect(staffNameDisplay(null), ''));
    test('empty string → ""', () => expect(staffNameDisplay(''), ''));
    test('"5kg Swarup" returned', () => expect(staffNameDisplay('5kg Swarup'), '5kg Swarup'));
  });

  // ── qtyDisplay ────────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetailUI] qtyDisplay', () {
    test('3 → "3"', () => expect(qtyDisplay(3), '3'));
    test('0 → "0"', () => expect(qtyDisplay(0), '0'));
    test('null → "null"', () => expect(qtyDisplay(null), 'null'));
    test('large → string', () => expect(qtyDisplay(999), '999'));
  });

  // ── amountDisplay ─────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetailUI] amountDisplay', () {
    test('0 → "‚ 0.00"', () => expect(amountDisplay(0), '‚ 0.00'));
    test('500 starts with "‚ "', () => expect(amountDisplay(500.0).startsWith('‚ '), isTrue));
    test('0.5 → "‚ 0..."', () => expect(amountDisplay(0.5).startsWith('‚ 0'), isTrue));
    test('1000 contains "1"', () => expect(amountDisplay(1000.0).contains('1'), isTrue));
  });

  // ── integration ───────────────────────────────────────────────────────────
  group('[ManagerIncomeUnsettledScreenDetailUI] integration', () {
    test('row 1 is odd, row 2 is even', () {
      expect(isEvenRow(1), isFalse);
      expect(isEvenRow(2), isTrue);
    });
    test('null staffName safe', () => expect(staffNameDisplay(null), ''));
    test('amount 0 → "‚ 0.00"', () => expect(amountDisplay(0), '‚ 0.00'));
    test('full row display', () {
      expect(staffNameDisplay('Ravi'), 'Ravi');
      expect(qtyDisplay(5), '5');
      expect(amountDisplay(500.0).startsWith('‚ '), isTrue);
    });
  });
}

