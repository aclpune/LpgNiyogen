// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardTVDetailUI.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from DashboardTVDetailUI ────────────────────

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

/// Mirrors: DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.tVDate ?? ''))
String tvDateDisplay(String? tvDate) {
  if (tvDate == null || tvDate.isEmpty) return '';
  try {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(tvDate));
  } catch (_) {
    return '';
  }
}

/// Mirrors: all rendered fields
Map<String, String> tvDetailFields({
  String?  tvDate,
  String?  itemName,
  String?  consumerNo,
  num?     clyHoldQty,
  String?  isRegulator,
  num?     paidAmt,
  String?  stockStatus,
  String?  consumerName,
}) =>
    {
      'itemName':    itemName ?? '',
      'tvDate':      tvDateDisplay(tvDate),
      'consNo':      nullToDash(consumerNo),
      'cylQty':      nullToDash(clyHoldQty?.toString()),
      'regRec':      nullToDash(isRegulator),
      'paidAmount':  nullToDash(formatCurrency((paidAmt ?? 0.0).toDouble())),
      'stockStatus': nullToDash(stockStatus),
      'consName':    consumerName ?? '',
    };

void main() {
  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[DashboardTVDetailUI] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
    test('"nUlL" → "-"', () => expect(nullToDash('nUlL'), '-'));
    test('"" → ""', () => expect(nullToDash(''), ''));
    test('valid value returned', () => expect(nullToDash('660990'), '660990'));
    test('date returned', () => expect(nullToDash('10-09-2025'), '10-09-2025'));
    test('"Yes" returned', () => expect(nullToDash('Yes'), 'Yes'));
    test('"No" returned', () => expect(nullToDash('No'), 'No'));
  });

  // ── tvDateDisplay ────────────────────────────────────────────────────────────
  group('[DashboardTVDetailUI] tvDateDisplay', () {
    test('ISO datetime → dd-MM-yyyy', () =>
        expect(tvDateDisplay('2025-09-10T00:00:00'), '10-09-2025'));
    test('ISO date-only → dd-MM-yyyy', () =>
        expect(tvDateDisplay('2025-01-01'), '01-01-2025'));
    test('end of year', () =>
        expect(tvDateDisplay('2025-12-31'), '31-12-2025'));
    test('single-digit month/day padded', () =>
        expect(tvDateDisplay('2025-05-07'), '07-05-2025'));
    test('null → ""', () => expect(tvDateDisplay(null), ''));
    test('empty string → ""', () => expect(tvDateDisplay(''), ''));
    test('invalid string → ""', () => expect(tvDateDisplay('bad-date'), ''));
    test('year 2026', () =>
        expect(tvDateDisplay('2026-03-15'), '15-03-2026'));
    test('leap year 2024-02-29', () =>
        expect(tvDateDisplay('2024-02-29'), '29-02-2024'));
  });

  // ── tvDetailFields – all null ────────────────────────────────────────────────
  group('[DashboardTVDetailUI] tvDetailFields – all null/default', () {
    test('8 keys present', () => expect(tvDetailFields().keys.length, 8));
    test('itemName null → ""', () => expect(tvDetailFields()['itemName'], ''));
    test('tvDate null → ""', () => expect(tvDetailFields()['tvDate'], ''));
    test('consNo null → "-"', () => expect(tvDetailFields()['consNo'], '-'));
    test('cylQty null → "-"', () => expect(tvDetailFields()['cylQty'], '-'));
    test('regRec null → "-"', () => expect(tvDetailFields()['regRec'], '-'));
    test('paidAmount 0 → "0.00"', () =>
        expect(tvDetailFields()['paidAmount'], '0.00'));
    test('stockStatus null → "-"', () =>
        expect(tvDetailFields()['stockStatus'], '-'));
    test('consName null → ""', () => expect(tvDetailFields()['consName'], ''));
  });

  // ── tvDetailFields – field by field ─────────────────────────────────────────
  group('[DashboardTVDetailUI] tvDetailFields – individual fields', () {
    test('itemName "14.2 KG" returned', () {
      expect(tvDetailFields(itemName: '14.2 KG')['itemName'], '14.2 KG');
    });
    test('tvDate formatted to dd-MM-yyyy', () {
      expect(tvDetailFields(tvDate: '2025-09-10T00:00:00')['tvDate'], '10-09-2025');
    });
    test('consumerNo "660990" returned', () {
      expect(tvDetailFields(consumerNo: '660990')['consNo'], '660990');
    });
    test('clyHoldQty 4 → "4"', () {
      expect(tvDetailFields(clyHoldQty: 4)['cylQty'], '4');
    });
    test('isRegulator "Yes" returned', () {
      expect(tvDetailFields(isRegulator: 'Yes')['regRec'], 'Yes');
    });
    test('isRegulator "No" returned', () {
      expect(tvDetailFields(isRegulator: 'No')['regRec'], 'No');
    });
    test('paidAmt 2000 formatted', () {
      final f = tvDetailFields(paidAmt: 2000.0)['paidAmount']!;
      expect(f.contains('2'), isTrue);
      expect(f, isNot('0.00'));
    });
    test('paidAmt 0 → "0.00"', () {
      expect(tvDetailFields(paidAmt: 0)['paidAmount'], '0.00');
    });
    test('stockStatus "Available" returned', () {
      expect(tvDetailFields(stockStatus: 'Available')['stockStatus'], 'Available');
    });
    test('consumerName "Rahul" returned', () {
      expect(tvDetailFields(consumerName: 'Rahul')['consName'], 'Rahul');
    });
  });

  // ── tvDetailFields – "null" string inputs ────────────────────────────────────
  group('[DashboardTVDetailUI] tvDetailFields – "null" string inputs', () {
    test('consumerNo "null" → "-"', () {
      expect(tvDetailFields(consumerNo: 'null')['consNo'], '-');
    });
    test('isRegulator "NULL" → "-"', () {
      expect(tvDetailFields(isRegulator: 'NULL')['regRec'], '-');
    });
    test('stockStatus "Null" → "-"', () {
      expect(tvDetailFields(stockStatus: 'Null')['stockStatus'], '-');
    });
  });

  // ── tvDetailFields – mixed ────────────────────────────────────────────────────
  group('[DashboardTVDetailUI] tvDetailFields – mixed valid/null', () {
    test('partial valid fields returned correctly', () {
      final f = tvDetailFields(
        itemName: '5 KG',
        consumerNo: null,
        isRegulator: 'Yes',
        paidAmt: 1000.0,
        stockStatus: 'null',
      );
      expect(f['itemName'],    '5 KG');
      expect(f['consNo'],      '-');
      expect(f['regRec'],      'Yes');
      expect(f['stockStatus'], '-');
      expect(f['paidAmount'],  isNot('0.00'));
    });
    test('all provided fields no "-"', () {
      final f = tvDetailFields(
        tvDate: '2025-09-10T00:00:00',
        itemName: '14.2 KG',
        consumerNo: '660990',
        clyHoldQty: 2,
        isRegulator: 'Yes',
        paidAmt: 1500.0,
        stockStatus: 'Active',
        consumerName: 'Priya',
      );
      expect(f['itemName'],    '14.2 KG');
      expect(f['tvDate'],      '10-09-2025');
      expect(f['consNo'],      '660990');
      expect(f['cylQty'],      '2');
      expect(f['regRec'],      'Yes');
      expect(f['stockStatus'], 'Active');
      expect(f['consName'],    'Priya');
    });
  });
}

