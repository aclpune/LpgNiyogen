// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardPostPaidVerifPendDetailsUI.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from DashboardPostPaidVerifPendDetailsUI ─────

String nullToDash(String? value) {
  if (value == null || value.toLowerCase() == 'null') return '-';
  return value;
}

String formatCurrency(double amount) {
  if (amount == 0) return '0.00';
  final fmt = NumberFormat('#,##,###.00', 'en_IN');
  String r = fmt.format(amount);
  if (amount < 1 && r.startsWith('.')) r = '0$r';
  return r;
}

/// Mirrors: "${selectedDate.toLocal()}".split(' ')[0]
String formatSelectedDate(DateTime dt) => '${dt.toLocal()}'.split(' ')[0];

/// Mirrors: initial selectedDate = DateTime.now()
String initialDateDisplay() => '${DateTime.now().toLocal()}'.split(' ')[0];

/// Mirrors: getTransactionForList constant (same as parent screen)
const List<String> getTransactionForList =
    ['All', 'Daily Sales', 'SV Sales', 'ARB Sales', 'Receipt'];

/// Mirrors: applyPickedDate via showDatePicker callback
DateTime applyPickedDate(DateTime current, DateTime? picked) =>
    picked ?? current;

/// Mirrors: amount display = nullToDash(formatCurrency(...))
String amountDisplay(num? amount) =>
    nullToDash(formatCurrency((amount ?? 0.0).toDouble()));

void main() {
  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetailsUI] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
    test('"" → ""', () => expect(nullToDash(''), ''));
    test('transCode valid returned', () =>
        expect(nullToDash('TC-00123'), 'TC-00123'));
    test('transTime valid returned', () =>
        expect(nullToDash('14:30'), '14:30'));
    test('staffName valid returned', () =>
        expect(nullToDash('Rahul Kumar'), 'Rahul Kumar'));
    test('transFor valid returned', () =>
        expect(nullToDash('Daily Sales'), 'Daily Sales'));
    test('transDate valid returned', () =>
        expect(nullToDash('2025-04-07'), '2025-04-07'));
  });

  // ── formatCurrency ──────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetailsUI] formatCurrency', () {
    test('0 → "0.00"', () => expect(formatCurrency(0), '0.00'));
    test('0.5 starts with "0"', () =>
        expect(formatCurrency(0.5).startsWith('0'), isTrue));
    test('0.5 not starts with "."', () =>
        expect(formatCurrency(0.5).startsWith('.'), isFalse));
    test('50.0 → "50.00"', () => expect(formatCurrency(50.0), '50.00'));
    test('large amount no throw', () =>
        expect(() => formatCurrency(99999999.0), returnsNormally));
    test('same input same output', () =>
        expect(formatCurrency(1500.0), formatCurrency(1500.0)));
  });

  // ── formatSelectedDate ───────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetailsUI] formatSelectedDate', () {
    test('formats 2025-04-07', () {
      expect(formatSelectedDate(DateTime(2025, 4, 7)), '2025-04-07');
    });
    test('formats 2025-12-31', () {
      expect(formatSelectedDate(DateTime(2025, 12, 31)), '2025-12-31');
    });
    test('formats 2026-01-05 (single digit day/month padded)', () {
      expect(formatSelectedDate(DateTime(2026, 1, 5)), '2026-01-05');
    });
    test('includes only date part (no time)', () {
      final dt = DateTime(2025, 6, 15, 23, 59, 59);
      expect(formatSelectedDate(dt), '2025-06-15');
    });
    test('result is 10 characters', () {
      expect(formatSelectedDate(DateTime(2025, 4, 7)).length, 10);
    });
    test('format is yyyy-MM-dd', () {
      final result = formatSelectedDate(DateTime(2025, 8, 20));
      expect(RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(result), isTrue);
    });
  });

  // ── initialDateDisplay ───────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetailsUI] initialDateDisplay', () {
    test('returns today in yyyy-MM-dd format', () {
      final today = '${DateTime.now().toLocal()}'.split(' ')[0];
      expect(initialDateDisplay(), today);
    });
    test('length is 10', () {
      expect(initialDateDisplay().length, 10);
    });
  });

  // ── getTransactionForList ────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetailsUI] getTransactionForList', () {
    test('has 5 items', () => expect(getTransactionForList.length, 5));
    test('first is "All"', () => expect(getTransactionForList[0], 'All'));
    test('second is "Daily Sales"', () =>
        expect(getTransactionForList[1], 'Daily Sales'));
    test('third is "SV Sales"', () =>
        expect(getTransactionForList[2], 'SV Sales'));
    test('fourth is "ARB Sales"', () =>
        expect(getTransactionForList[3], 'ARB Sales'));
    test('fifth is "Receipt"', () =>
        expect(getTransactionForList[4], 'Receipt'));
  });

  // ── applyPickedDate ───────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetailsUI] applyPickedDate', () {
    test('null picked retains current', () {
      final current = DateTime(2025, 5, 10);
      expect(applyPickedDate(current, null), current);
    });
    test('non-null picked updates date', () {
      final current = DateTime(2025, 5, 10);
      final picked  = DateTime(2025, 9, 25);
      expect(applyPickedDate(current, picked), picked);
    });
    test('same date as current → same returned', () {
      final dt = DateTime(2025, 1, 1);
      expect(applyPickedDate(dt, dt), dt);
    });
    test('future date picked → future date returned', () {
      final future = DateTime(2030, 6, 15);
      expect(applyPickedDate(DateTime.now(), future), future);
    });
  });

  // ── amountDisplay ─────────────────────────────────────────────────────────────
  group('[DashboardPostPaidVerifPendDetailsUI] amountDisplay', () {
    test('null → "0.00"', () => expect(amountDisplay(null), '0.00'));
    test('0 → "0.00"', () => expect(amountDisplay(0), '0.00'));
    test('0.0 → "0.00"', () => expect(amountDisplay(0.0), '0.00'));
    test('positive amount is formatted', () {
      final r = amountDisplay(500.0);
      expect(r, isNot('0.00'));
      expect(r.contains('5'), isTrue);
    });
    test('large amount formatted', () {
      final r = amountDisplay(15000.0);
      expect(r.contains('15'), isTrue);
    });
    test('sub-1 amount starts with "0"', () {
      expect(amountDisplay(0.5).startsWith('0'), isTrue);
    });
  });
}

