// ignore_for_file: avoid_print
// Tests for: lib/Screen/ManagerScreen/DashboardItemClickUI/DashboardDropDownUI.dart

import 'package:flutter_test/flutter_test.dart';

// ── Pure-logic helpers extracted from DashboardDropDownUI ────────────────────

String nullToDash(String? value) {
  if (value == null || value.toLowerCase() == 'null') return '-';
  return value;
}

bool showDivider(int serialNumber, int listLength) => serialNumber != listLength;

Map<String, String> displayFields({
  String? consumerNo,
  String? orderDate,
  String? consumerName,
  String? cashMemoDate,
  String? settlementDate,
  String? deliveryDate,
  String? remark,
}) =>
    {
      'consumerNo':     nullToDash(consumerNo),
      'orderDate':      nullToDash(orderDate),
      'consumerName':   nullToDash(consumerName),
      'cashMemoDate':   nullToDash(cashMemoDate),
      'settlementDate': nullToDash(settlementDate),
      'deliveryDate':   nullToDash(deliveryDate),
      'remark':         nullToDash(remark),
    };

void main() {
  // ── nullToDash ───────────────────────────────────────────────────────────────
  group('[DashboardDropDownUI] nullToDash', () {
    test('null → "-"', () => expect(nullToDash(null), '-'));
    test('"null" → "-"', () => expect(nullToDash('null'), '-'));
    test('"NULL" → "-"', () => expect(nullToDash('NULL'), '-'));
    test('"Null" → "-"', () => expect(nullToDash('Null'), '-'));
    test('"nUlL" → "-"', () => expect(nullToDash('nUlL'), '-'));
    test('"" → "" (empty is NOT dash)', () => expect(nullToDash(''), ''));
    test('valid value returned as-is', () => expect(nullToDash('660990'), '660990'));
    test('name returned as-is', () => expect(nullToDash('Mr. Priyabrata'), 'Mr. Priyabrata'));
    test('date string returned as-is', () => expect(nullToDash('05-04-2025'), '05-04-2025'));
    test('whitespace returned as-is', () => expect(nullToDash(' '), ' '));
  });

  // ── showDivider ──────────────────────────────────────────────────────────────
  group('[DashboardDropDownUI] showDivider', () {
    test('serial(1) < len(5) → true', () => expect(showDivider(1, 5), isTrue));
    test('serial(3) < len(5) → true', () => expect(showDivider(3, 5), isTrue));
    test('serial(4) < len(5) → true', () => expect(showDivider(4, 5), isTrue));
    test('serial == len → false', () => expect(showDivider(5, 5), isFalse));
    test('single item (1/1) → false', () => expect(showDivider(1, 1), isFalse));
    test('first of 10 → true', () => expect(showDivider(1, 10), isTrue));
    test('penultimate of 10 → true', () => expect(showDivider(9, 10), isTrue));
    test('last of 10 → false', () => expect(showDivider(10, 10), isFalse));
    test('serial > len (edge) → true', () => expect(showDivider(6, 5), isTrue));
  });

  // ── displayFields ─────────────────────────────────────────────────────────────
  group('[DashboardDropDownUI] displayFields – all null', () {
    test('all fields default to "-"', () {
      final f = displayFields();
      expect(f.values.every((v) => v == '-'), isTrue);
    });
    test('map has exactly 7 keys', () {
      expect(displayFields().keys.length, 7);
    });
    test('contains all expected keys', () {
      final keys = displayFields().keys.toSet();
      expect(keys, containsAll([
        'consumerNo', 'orderDate', 'consumerName',
        'cashMemoDate', 'settlementDate', 'deliveryDate', 'remark',
      ]));
    });
  });

  group('[DashboardDropDownUI] displayFields – consumerNo', () {
    test('valid consumerNo returned', () =>
        expect(displayFields(consumerNo: '660990')['consumerNo'], '660990'));
    test('null consumerNo → "-"', () =>
        expect(displayFields(consumerNo: null)['consumerNo'], '-'));
    test('"null" consumerNo → "-"', () =>
        expect(displayFields(consumerNo: 'null')['consumerNo'], '-'));
  });

  group('[DashboardDropDownUI] displayFields – orderDate', () {
    test('valid date returned', () =>
        expect(displayFields(orderDate: '05-04-2025')['orderDate'], '05-04-2025'));
    test('null orderDate → "-"', () =>
        expect(displayFields(orderDate: null)['orderDate'], '-'));
    test('"NULL" orderDate → "-"', () =>
        expect(displayFields(orderDate: 'NULL')['orderDate'], '-'));
  });

  group('[DashboardDropDownUI] displayFields – consumerName', () {
    test('valid name returned', () =>
        expect(displayFields(consumerName: 'Mr. Priyabrata Mondal')['consumerName'],
            'Mr. Priyabrata Mondal'));
    test('null → "-"', () =>
        expect(displayFields(consumerName: null)['consumerName'], '-'));
  });

  group('[DashboardDropDownUI] displayFields – cashMemoDate', () {
    test('valid date returned', () =>
        expect(displayFields(cashMemoDate: '05-04-2025')['cashMemoDate'], '05-04-2025'));
    test('null → "-"', () =>
        expect(displayFields(cashMemoDate: null)['cashMemoDate'], '-'));
  });

  group('[DashboardDropDownUI] displayFields – settlementDate', () {
    test('valid date returned', () =>
        expect(displayFields(settlementDate: '09-04-2025')['settlementDate'], '09-04-2025'));
    test('null → "-"', () =>
        expect(displayFields(settlementDate: null)['settlementDate'], '-'));
  });

  group('[DashboardDropDownUI] displayFields – deliveryDate', () {
    test('valid date returned', () =>
        expect(displayFields(deliveryDate: '10-04-2025')['deliveryDate'], '10-04-2025'));
    test('"null" string → "-"', () =>
        expect(displayFields(deliveryDate: 'null')['deliveryDate'], '-'));
  });

  group('[DashboardDropDownUI] displayFields – remark', () {
    test('valid remark returned', () =>
        expect(displayFields(remark: 'Some remark text')['remark'], 'Some remark text'));
    test('null → "-"', () =>
        expect(displayFields(remark: null)['remark'], '-'));
    test('empty remark → ""', () =>
        expect(displayFields(remark: '')['remark'], ''));
  });

  group('[DashboardDropDownUI] displayFields – mixed', () {
    test('mix of null and valid fields', () {
      final f = displayFields(
        consumerNo: '123', consumerName: null, orderDate: '2025-01-01',
        deliveryDate: 'null', settlementDate: '2025-01-05', remark: 'OK',
      );
      expect(f['consumerNo'],     '123');
      expect(f['consumerName'],   '-');
      expect(f['orderDate'],      '2025-01-01');
      expect(f['deliveryDate'],   '-');
      expect(f['settlementDate'], '2025-01-05');
      expect(f['remark'],         'OK');
    });
  });
}

