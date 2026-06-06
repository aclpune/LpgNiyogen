// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerCashInHandScreenDetailsUI.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerCashInHandScreenDetailsUI ───────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

bool isEvenRow(int serialNumber) => serialNumber % 2 == 0;
String serialDisplay(int n) => '$n';
String itemNameDisplay(String? name) => name ?? '';
String amountDisplay(double amount) => '‚ ${formatCurrency(amount)}';

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetailsUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative does not throw', () => expect(() => formatCurrency(-100.0), returnsNormally));
    test('same input same output', () => expect(formatCurrency(3400.0), formatCurrency(3400.0)));
    test('non-zero ≠ "0.00"', () => expect(formatCurrency(1.0), isNot('0.00')));
    test('0.01 starts with "0"', () => expect(formatCurrency(0.01).startsWith('0'), isTrue));
    test('0.99 starts with "0."', () => expect(formatCurrency(0.99).startsWith('0.'), isTrue));
  });

  // ── isEvenRow ─────────────────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetailsUI] isEvenRow', () {
    test('serial 2 → even', () => expect(isEvenRow(2), isTrue));
    test('serial 1 → odd', () => expect(isEvenRow(1), isFalse));
    test('serial 4 → even', () => expect(isEvenRow(4), isTrue));
    test('serial 3 → odd', () => expect(isEvenRow(3), isFalse));
    test('serial 0 → even', () => expect(isEvenRow(0), isTrue));
    test('serial 100 → even', () => expect(isEvenRow(100), isTrue));
    test('serial 99 → odd', () => expect(isEvenRow(99), isFalse));
  });

  // ── serialDisplay ─────────────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetailsUI] serialDisplay', () {
    test('1 → "1"', () => expect(serialDisplay(1), '1'));
    test('10 → "10"', () => expect(serialDisplay(10), '10'));
    test('0 → "0"', () => expect(serialDisplay(0), '0'));
    test('100 → "100"', () => expect(serialDisplay(100), '100'));
  });

  // ── itemNameDisplay ───────────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetailsUI] itemNameDisplay', () {
    test('"14.2 KG" returned', () => expect(itemNameDisplay('14.2 KG'), '14.2 KG'));
    test('"5 KG" returned', () => expect(itemNameDisplay('5 KG'), '5 KG'));
    test('null → ""', () => expect(itemNameDisplay(null), ''));
    test('empty string returned', () => expect(itemNameDisplay(''), ''));
  });

  // ── amountDisplay ─────────────────────────────────────────────────────────
  group('[ManagerCashInHandScreenDetailsUI] amountDisplay', () {
    test('0 → "‚ 0.00"', () => expect(amountDisplay(0), '‚ 0.00'));
    test('3400.0 contains "3"', () => expect(amountDisplay(3400.0).contains('3'), isTrue));
    test('starts with "‚ "', () => expect(amountDisplay(500.0).startsWith('‚ '), isTrue));
    test('sub-1 → starts with "‚ 0"', () => expect(amountDisplay(0.5).startsWith('‚ 0'), isTrue));
  });
}

