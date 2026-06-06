// Tests for: lib/Screen/ManagerScreen/DSRItemClickUI/ManagerDSRReportScreenItemUI.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Helpers mirrored from ManagerDSRReportScreenItemUI ───────────────────────

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

bool isEvenRow(int serialNumber) => serialNumber % 2 == 0;

String resolveAmountValue(String mode, {
  num? merchantQR, num? creditAmt, num? prepaidAmt, num? cashAmt}) {
  if (mode == 'MERCHANT') return formatCurrency((merchantQR ?? 0).toDouble());
  if (mode == 'Credit')   return formatCurrency((creditAmt  ?? 0).toDouble());
  if (mode == 'PREPAID')  return formatCurrency((prepaidAmt ?? 0).toDouble());
  return formatCurrency((cashAmt ?? 0).toDouble());
}

String resolveAmountColorName(String mode) {
  if (mode == 'MERCHANT') return 'teal';
  if (mode == 'Credit')   return 'amber';
  if (mode == 'PREPAID')  return 'orange';
  return 'green';
}

String resolveItemName(String? itemName, String? transCate) =>
    (itemName == null || itemName.isEmpty) ? (transCate ?? '') : (itemName);

void main() {
  // ── formatCurrency ────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenItemUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () => expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not "."', () => expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large has comma', () => expect(formatCurrency(1000000.0).contains(','), isTrue));
    test('negative no throw', () => expect(() => formatCurrency(-100.0), returnsNormally));
  });

  // ── isEvenRow ─────────────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenItemUI] isEvenRow', () {
    test('2 → true', () => expect(isEvenRow(2), isTrue));
    test('1 → false', () => expect(isEvenRow(1), isFalse));
    test('0 → true', () => expect(isEvenRow(0), isTrue));
    test('5 → false', () => expect(isEvenRow(5), isFalse));
    for (int i = 1; i <= 6; i++) {
      test('serial $i → ${i % 2 == 0}', () => expect(isEvenRow(i), i % 2 == 0));
    }
  });

  // ── resolveAmountValue ────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenItemUI] resolveAmountValue', () {
    test('MERCHANT → merchantQR formatted', () {
      final r = resolveAmountValue('MERCHANT', merchantQR: 500.0);
      expect(r.contains('5'), isTrue);
    });
    test('Credit → creditAmt formatted', () {
      final r = resolveAmountValue('Credit', creditAmt: 300.0);
      expect(r.contains('3'), isTrue);
    });
    test('PREPAID → prepaidAmt formatted', () {
      final r = resolveAmountValue('PREPAID', prepaidAmt: 200.0);
      expect(r.contains('2'), isTrue);
    });
    test('Cash → cashAmt formatted', () {
      final r = resolveAmountValue('Cash', cashAmt: 1000.0);
      expect(r.contains('1'), isTrue);
    });
    test('null amounts → "0.00"', () {
      expect(resolveAmountValue('Cash'), '0.00');
      expect(resolveAmountValue('MERCHANT'), '0.00');
      expect(resolveAmountValue('Credit'), '0.00');
      expect(resolveAmountValue('PREPAID'), '0.00');
    });
    test('0 amounts → "0.00"', () {
      expect(resolveAmountValue('Cash', cashAmt: 0), '0.00');
    });
  });

  // ── resolveAmountColorName ────────────────────────────────────────────────
  group('[ManagerDSRReportScreenItemUI] resolveAmountColorName', () {
    test('MERCHANT → teal', () => expect(resolveAmountColorName('MERCHANT'), 'teal'));
    test('Credit → amber', () => expect(resolveAmountColorName('Credit'), 'amber'));
    test('PREPAID → orange', () => expect(resolveAmountColorName('PREPAID'), 'orange'));
    test('Cash → green', () => expect(resolveAmountColorName('Cash'), 'green'));
    test('unknown → green', () => expect(resolveAmountColorName('Other'), 'green'));
  });

  // ── resolveItemName ───────────────────────────────────────────────────────
  group('[ManagerDSRReportScreenItemUI] resolveItemName', () {
    test('valid itemName returned', () =>
        expect(resolveItemName('14.2 KG', 'Category'), '14.2 KG'));
    test('empty itemName → transCate', () =>
        expect(resolveItemName('', 'Category'), 'Category'));
    test('null itemName → transCate', () =>
        expect(resolveItemName(null, 'Category'), 'Category'));
    test('null both → ""', () =>
        expect(resolveItemName(null, null), ''));
    test('empty itemName, null transCate → ""', () =>
        expect(resolveItemName('', null), ''));
  });
}

