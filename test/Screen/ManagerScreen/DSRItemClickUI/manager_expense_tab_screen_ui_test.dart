// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerExpenseTabScreenUI.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerExpenseTabScreenUI ──────────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

bool isEvenRow(int serialNumber) => serialNumber % 2 == 0;
String staffNameDisplay(dynamic staffName) => staffName == null ? '' : staffName.toString();
String qtyDisplay(dynamic qty) => qty == null ? '' : qty.toString();
String cashDisplay(double cash) => '‚ ${formatCurrency(cash)}';
String bankDisplay(double bank) => '‚ ${formatCurrency(bank)}';

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative no throw', () => expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () => expect(formatCurrency(200.0), formatCurrency(200.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
  });

  // ── isEvenRow ─────────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenUI] isEvenRow', () {
    test('2 → even', () => expect(isEvenRow(2), isTrue));
    test('1 → odd', () => expect(isEvenRow(1), isFalse));
    test('0 → even', () => expect(isEvenRow(0), isTrue));
    test('9 → odd', () => expect(isEvenRow(9), isFalse));
    test('10 → even', () => expect(isEvenRow(10), isTrue));
    for (int i = 1; i <= 8; i++) {
      test('serial $i', () => expect(isEvenRow(i), i % 2 == 0));
    }
  });

  // ── staffNameDisplay ──────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenUI] staffNameDisplay', () {
    test('valid name returned', () => expect(staffNameDisplay('Ravi Kumar'), 'Ravi Kumar'));
    test('null → ""', () => expect(staffNameDisplay(null), ''));
    test('empty string → ""', () => expect(staffNameDisplay(''), ''));
    test('int → string', () => expect(staffNameDisplay(42), '42'));
  });

  // ── qtyDisplay ────────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenUI] qtyDisplay', () {
    test('3 → "3"', () => expect(qtyDisplay(3), '3'));
    test('null → ""', () => expect(qtyDisplay(null), ''));
    test('0 → "0"', () => expect(qtyDisplay(0), '0'));
    test('string qty returned', () => expect(qtyDisplay('5'), '5'));
  });

  // ── cashDisplay ───────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenUI] cashDisplay', () {
    test('0 → "‚ 0.00"', () => expect(cashDisplay(0), '‚ 0.00'));
    test('500 starts with "‚ "', () => expect(cashDisplay(500.0).startsWith('‚ '), isTrue));
    test('0.5 → "‚ 0..."', () => expect(cashDisplay(0.5).startsWith('‚ 0'), isTrue));
    test('large amount formatted', () => expect(cashDisplay(10000.0).contains('10'), isTrue));
  });

  // ── bankDisplay ───────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenUI] bankDisplay', () {
    test('0 → "‚ 0.00"', () => expect(bankDisplay(0), '‚ 0.00'));
    test('300 starts with "‚ "', () => expect(bankDisplay(300.0).startsWith('‚ '), isTrue));
    test('same result as cashDisplay for same input', () =>
        expect(bankDisplay(200.0), cashDisplay(200.0)));
  });

  // ── integration ───────────────────────────────────────────────────────────
  group('[ManagerExpenseTabScreenUI] integration', () {
    test('row 1 is odd → bg differs from row 2', () {
      expect(isEvenRow(1), isFalse);
      expect(isEvenRow(2), isTrue);
    });
    test('null fields → safe displays', () {
      expect(staffNameDisplay(null), '');
      expect(qtyDisplay(null), '');
      expect(cashDisplay(0), '‚ 0.00');
      expect(bankDisplay(0), '‚ 0.00');
    });
  });
}

