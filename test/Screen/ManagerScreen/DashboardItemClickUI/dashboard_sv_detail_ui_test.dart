// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardSVDetailUI.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// ── Pure-logic helpers extracted from DashboardSVDetailUI ────────────────────

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

/// Mirrors: isUndocument → docStatus string
String svDocStatus(bool? isUndocument) {
  if (isUndocument == true)  return 'Pending';
  if (isUndocument == false) return 'Received';
  return '';
}

/// Mirrors: DateFormat('dd-MM-yyyy').format(DateTime.parse(sale.sVDate ?? ''))
String svDateDisplay(String? svDate) {
  if (svDate == null || svDate.isEmpty) return '';
  try {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(svDate));
  } catch (_) {
    return '';
  }
}

/// Mirrors: all rendered fields
Map<String, String> svDetailFields({
  String?  svDate,
  String?  itemName,
  String?  consuDCNo,
  num?     cylQty,
  bool?    isUndocument,
  String?  svType,
  num?     totalAmount,
  String?  stockStatus,
  String?  consumerNo,
  String?  consumerName,
  String?  referredBy,
}) =>
    {
      'svDate':      svDateDisplay(svDate),
      'itemName':    nullToDash(itemName),
      'consuDCNo':   nullToDash(consuDCNo),
      'cylQty':      nullToDash(cylQty?.toString()),
      'docStatus':   svDocStatus(isUndocument),
      'svType':      svType ?? '',
      'amount':      nullToDash(formatCurrency((totalAmount ?? 0.0).toDouble())),
      'stockStatus': nullToDash(stockStatus),
      'consumerNo':  consumerNo ?? '-',
      'consumerName':nullToDash(consumerName),
      'referredBy':  referredBy ?? '',
    };

void main() {
  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[DashboardSVDetailUI] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
    test('"" → ""', () => expect(nullToDash(''), ''));
    test('valid returned', () => expect(nullToDash('SV-001'), 'SV-001'));
    test('date returned', () => expect(nullToDash('07-04-2025'), '07-04-2025'));
  });

  // ── svDocStatus ──────────────────────────────────────────────────────────────
  group('[DashboardSVDetailUI] svDocStatus', () {
    test('true → "Pending"', () => expect(svDocStatus(true), 'Pending'));
    test('false → "Received"', () => expect(svDocStatus(false), 'Received'));
    test('null → ""', () => expect(svDocStatus(null), ''));
    test('Pending for undocumented', () =>
        expect(svDocStatus(true), contains('Pending')));
    test('Received for documented', () =>
        expect(svDocStatus(false), contains('Received')));
  });

  // ── svDateDisplay ────────────────────────────────────────────────────────────
  group('[DashboardSVDetailUI] svDateDisplay', () {
    test('ISO datetime → dd-MM-yyyy', () =>
        expect(svDateDisplay('2025-04-07T00:00:00'), '07-04-2025'));
    test('ISO date-only → dd-MM-yyyy', () =>
        expect(svDateDisplay('2025-12-31'), '31-12-2025'));
    test('null → ""', () => expect(svDateDisplay(null), ''));
    test('empty string → ""', () => expect(svDateDisplay(''), ''));
    test('invalid string → ""', () => expect(svDateDisplay('not-a-date'), ''));
    test('single digit month/day padded', () =>
        expect(svDateDisplay('2025-01-05'), '05-01-2025'));
    test('year 2026', () =>
        expect(svDateDisplay('2026-06-15'), '15-06-2026'));
    test('end of year', () =>
        expect(svDateDisplay('2025-12-31'), '31-12-2025'));
  });

  // ── svDetailFields – all null ────────────────────────────────────────────────
  group('[DashboardSVDetailUI] svDetailFields – all null/default', () {
    test('11 keys present', () => expect(svDetailFields().keys.length, 11));
    test('itemName null → "-"', () => expect(svDetailFields()['itemName'], '-'));
    test('consuDCNo null → "-"', () => expect(svDetailFields()['consuDCNo'], '-'));
    test('cylQty null → "-"', () => expect(svDetailFields()['cylQty'], '-'));
    test('docStatus null → ""', () => expect(svDetailFields()['docStatus'], ''));
    test('svType null → ""', () => expect(svDetailFields()['svType'], ''));
    test('amount 0 → "0.00"', () => expect(svDetailFields()['amount'], '0.00'));
    test('stockStatus null → "-"', () => expect(svDetailFields()['stockStatus'], '-'));
    test('consumerNo null → "-"', () => expect(svDetailFields()['consumerNo'], '-'));
    test('consumerName null → "-"', () => expect(svDetailFields()['consumerName'], '-'));
    test('referredBy null → ""', () => expect(svDetailFields()['referredBy'], ''));
  });

  // ── svDetailFields – specific fields ────────────────────────────────────────
  group('[DashboardSVDetailUI] svDetailFields – field by field', () {
    test('svDate formatted', () {
      expect(svDetailFields(svDate: '2025-04-07T00:00:00')['svDate'], '07-04-2025');
    });
    test('itemName valid returned', () {
      expect(svDetailFields(itemName: '14.2 KG')['itemName'], '14.2 KG');
    });
    test('consuDCNo valid returned', () {
      expect(svDetailFields(consuDCNo: 'DC-1234')['consuDCNo'], 'DC-1234');
    });
    test('cylQty 5 → "5"', () {
      expect(svDetailFields(cylQty: 5)['cylQty'], '5');
    });
    test('isUndocument=true → "Pending"', () {
      expect(svDetailFields(isUndocument: true)['docStatus'], 'Pending');
    });
    test('isUndocument=false → "Received"', () {
      expect(svDetailFields(isUndocument: false)['docStatus'], 'Received');
    });
    test('svType "SV" returned', () {
      expect(svDetailFields(svType: 'SV')['svType'], 'SV');
    });
    test('totalAmount 1500 → formatted', () {
      final f = svDetailFields(totalAmount: 1500.0)['amount']!;
      expect(f.contains('1'), isTrue);
      expect(f, isNot('0.00'));
    });
    test('stockStatus "Available" returned', () {
      expect(svDetailFields(stockStatus: 'Available')['stockStatus'], 'Available');
    });
    test('consumerNo "660990" returned', () {
      expect(svDetailFields(consumerNo: '660990')['consumerNo'], '660990');
    });
    test('consumerName "Rahul" returned', () {
      expect(svDetailFields(consumerName: 'Rahul')['consumerName'], 'Rahul');
    });
    test('referredBy "Amit" returned', () {
      expect(svDetailFields(referredBy: 'Amit')['referredBy'], 'Amit');
    });
  });

  // ── svDetailFields – null string fields ─────────────────────────────────────
  group('[DashboardSVDetailUI] svDetailFields – "null" string inputs', () {
    test('itemName "null" → "-"', () {
      expect(svDetailFields(itemName: 'null')['itemName'], '-');
    });
    test('stockStatus "NULL" → "-"', () {
      expect(svDetailFields(stockStatus: 'NULL')['stockStatus'], '-');
    });
    test('consumerName "Null" → "-"', () {
      expect(svDetailFields(consumerName: 'Null')['consumerName'], '-');
    });
  });
}

