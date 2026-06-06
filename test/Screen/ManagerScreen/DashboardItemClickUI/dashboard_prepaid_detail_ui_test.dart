// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardPrepaidDetailUI.dart

import 'package:flutter_test/flutter_test.dart';

// ── Pure-logic helpers extracted from DashboardPrepaidDetailUI ───────────────

String nullToDash(String? value) {
  if (value == null || value.toLowerCase() == 'null') return '-';
  return value;
}

/// Mirrors: all 5 display fields rendered via nullToDash
Map<String, String> prepaidDetailFields({
  String? consumerNo,
  String? consumerName,
  String? orderDate,
  String? deliveryDate,
  String? settlementDate,
}) =>
    {
      'consumerNo':     nullToDash(consumerNo),
      'consumerName':   nullToDash(consumerName),
      'orderDate':      nullToDash(orderDate),
      'deliveryDate':   nullToDash(deliveryDate),
      'settlementDate': nullToDash(settlementDate),
    };

void main() {
  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
    test('"nUlL" → "-"', () => expect(nullToDash('nUlL'), '-'));
    test('"" → "" (not "-")', () => expect(nullToDash(''), ''));
    test('valid value returned unchanged', () =>
        expect(nullToDash('660990'), '660990'));
    test('name returned unchanged', () =>
        expect(nullToDash('Mr. Priyabrata Mondal'), 'Mr. Priyabrata Mondal'));
    test('date returned unchanged', () =>
        expect(nullToDash('05-04-2025'), '05-04-2025'));
    test('whitespace string returned', () => expect(nullToDash('  '), '  '));
  });

  // ── prepaidDetailFields – all null ──────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] prepaidDetailFields – all null', () {
    test('all 5 fields default to "-"', () {
      final f = prepaidDetailFields();
      expect(f.values.every((v) => v == '-'), isTrue);
    });
    test('map has exactly 5 keys', () {
      expect(prepaidDetailFields().keys.length, 5);
    });
    test('contains all expected keys', () {
      expect(prepaidDetailFields().keys.toSet(), containsAll([
        'consumerNo', 'consumerName', 'orderDate', 'deliveryDate', 'settlementDate',
      ]));
    });
  });

  // ── consumerNo ───────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] consumerNo field', () {
    test('valid consumerNo returned', () =>
        expect(prepaidDetailFields(consumerNo: '660990')['consumerNo'], '660990'));
    test('null → "-"', () =>
        expect(prepaidDetailFields(consumerNo: null)['consumerNo'], '-'));
    test('"null" string → "-"', () =>
        expect(prepaidDetailFields(consumerNo: 'null')['consumerNo'], '-'));
    test('numeric string returned', () =>
        expect(prepaidDetailFields(consumerNo: '123456')['consumerNo'], '123456'));
  });

  // ── consumerName ─────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] consumerName field', () {
    test('valid name returned', () =>
        expect(prepaidDetailFields(consumerName: 'Rahul Das')['consumerName'],
            'Rahul Das'));
    test('null → "-"', () =>
        expect(prepaidDetailFields(consumerName: null)['consumerName'], '-'));
    test('"NULL" → "-"', () =>
        expect(prepaidDetailFields(consumerName: 'NULL')['consumerName'], '-'));
    test('empty string → ""', () =>
        expect(prepaidDetailFields(consumerName: '')['consumerName'], ''));
  });

  // ── orderDate ─────────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] orderDate field', () {
    test('valid date returned', () =>
        expect(prepaidDetailFields(orderDate: '05-04-2025')['orderDate'],
            '05-04-2025'));
    test('null → "-"', () =>
        expect(prepaidDetailFields(orderDate: null)['orderDate'], '-'));
    test('"null" → "-"', () =>
        expect(prepaidDetailFields(orderDate: 'null')['orderDate'], '-'));
  });

  // ── deliveryDate ─────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] deliveryDate field', () {
    test('valid date returned', () =>
        expect(prepaidDetailFields(deliveryDate: '10-04-2025')['deliveryDate'],
            '10-04-2025'));
    test('null → "-"', () =>
        expect(prepaidDetailFields(deliveryDate: null)['deliveryDate'], '-'));
    test('"null" → "-" (API sends literal "null")', () =>
        expect(prepaidDetailFields(deliveryDate: 'null')['deliveryDate'], '-'));
  });

  // ── settlementDate ────────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] settlementDate field', () {
    test('valid date returned', () =>
        expect(prepaidDetailFields(settlementDate: '09-04-2025')['settlementDate'],
            '09-04-2025'));
    test('null → "-"', () =>
        expect(prepaidDetailFields(settlementDate: null)['settlementDate'], '-'));
    test('"NULL" → "-"', () =>
        expect(prepaidDetailFields(settlementDate: 'NULL')['settlementDate'], '-'));
  });

  // ── mixed scenarios ───────────────────────────────────────────────────────────
  group('[DashboardPrepaidDetailUI] prepaidDetailFields – mixed', () {
    test('partial null and valid mix', () {
      final f = prepaidDetailFields(
        consumerNo: '660990',
        consumerName: null,
        orderDate: '05-04-2025',
        deliveryDate: 'null',
        settlementDate: '09-04-2025',
      );
      expect(f['consumerNo'],     '660990');
      expect(f['consumerName'],   '-');
      expect(f['orderDate'],      '05-04-2025');
      expect(f['deliveryDate'],   '-');
      expect(f['settlementDate'], '09-04-2025');
    });
    test('all provided fields returned correctly', () {
      final f = prepaidDetailFields(
        consumerNo: 'CN1', consumerName: 'Test', orderDate: '2025-01-01',
        deliveryDate: '2025-01-05', settlementDate: '2025-01-07',
      );
      expect(f.values.every((v) => v != '-'), isTrue);
    });
  });
}

