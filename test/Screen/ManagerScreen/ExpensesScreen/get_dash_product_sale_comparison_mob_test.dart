// Tests for: lib/Screen/ManagerScreen/ExpensesScreen/GetDashProductSaleComparisonMob.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ExpensesScreen/GetDashProductSaleComparisonMob.dart';

void main() {
  final sampleJson = {
    'DistributorId': 8118,
    'ItemId': 1,
    'ItemName': '14.2 KG',
    'ThisMonthSaleQty': 120.0,
    'PreMonthSaleQty': 160.0,
    'PreYearSameMonthSaleQty': 135.0,
  };

  // ── fromJson ──────────────────────────────────────────────────────────────
  group('[GetDashProductSaleComparisonMob] fromJson', () {
    test('parses distributorId', () =>
        expect(GetDashProductSaleComparisonMob.fromJson(sampleJson).distributorId, 8118));
    test('parses itemId', () =>
        expect(GetDashProductSaleComparisonMob.fromJson(sampleJson).itemId, 1));
    test('parses itemName', () =>
        expect(GetDashProductSaleComparisonMob.fromJson(sampleJson).itemName, '14.2 KG'));
    test('parses thisMonthSaleQty', () =>
        expect(GetDashProductSaleComparisonMob.fromJson(sampleJson).thisMonthSaleQty, 120.0));
    test('parses preMonthSaleQty', () =>
        expect(GetDashProductSaleComparisonMob.fromJson(sampleJson).preMonthSaleQty, 160.0));
    test('parses preYearSameMonthSaleQty', () =>
        expect(GetDashProductSaleComparisonMob.fromJson(sampleJson).preYearSameMonthSaleQty, 135.0));
    test('null field stays null', () {
      final j = <String, dynamic>{'ItemName': null};
      expect(GetDashProductSaleComparisonMob.fromJson(j).itemName, isNull);
    });
    test('0.0 qty parsed correctly', () {
      final j = {'ThisMonthSaleQty': 0.0};
      expect(GetDashProductSaleComparisonMob.fromJson(j).thisMonthSaleQty, 0.0);
    });
  });

  // ── default constructor ────────────────────────────────────────────────────
  group('[GetDashProductSaleComparisonMob] default constructor', () {
    test('all fields null', () {
      final m = GetDashProductSaleComparisonMob();
      expect(m.distributorId,          isNull);
      expect(m.itemId,                  isNull);
      expect(m.itemName,                isNull);
      expect(m.thisMonthSaleQty,        isNull);
      expect(m.preMonthSaleQty,         isNull);
      expect(m.preYearSameMonthSaleQty, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('[GetDashProductSaleComparisonMob] toJson', () {
    test('round-trips all fields', () {
      final m = GetDashProductSaleComparisonMob.fromJson(sampleJson);
      final map = m.toJson();
      expect(map['DistributorId'],         8118);
      expect(map['ItemId'],                1);
      expect(map['ItemName'],              '14.2 KG');
      expect(map['ThisMonthSaleQty'],      120.0);
      expect(map['PreMonthSaleQty'],       160.0);
      expect(map['PreYearSameMonthSaleQty'], 135.0);
    });
    test('has 6 keys', () {
      final m = GetDashProductSaleComparisonMob();
      expect(m.toJson().keys.length, 6);
    });
    test('null values preserved', () {
      final m = GetDashProductSaleComparisonMob();
      expect(m.toJson()['ItemName'], isNull);
    });
  });

  // ── copyWith ──────────────────────────────────────────────────────────────
  group('[GetDashProductSaleComparisonMob] copyWith', () {
    test('overrides only specified field', () {
      final m = GetDashProductSaleComparisonMob(
          itemName: '14.2 KG', thisMonthSaleQty: 120.0);
      final copy = m.copyWith(thisMonthSaleQty: 999.0);
      expect(copy.itemName,         '14.2 KG');
      expect(copy.thisMonthSaleQty, 999.0);
    });
    test('no override → all original', () {
      final m = GetDashProductSaleComparisonMob(
          itemId: 1, itemName: '5 KG');
      final copy = m.copyWith();
      expect(copy.itemId,   1);
      expect(copy.itemName, '5 KG');
    });
    test('override itemName', () {
      final m = GetDashProductSaleComparisonMob(itemName: '14.2 KG');
      final copy = m.copyWith(itemName: '5 KG');
      expect(copy.itemName, '5 KG');
    });
  });

  // ── getters ───────────────────────────────────────────────────────────────
  group('[GetDashProductSaleComparisonMob] getters', () {
    final m = GetDashProductSaleComparisonMob.fromJson(sampleJson);
    test('distributorId getter', () => expect(m.distributorId, 8118));
    test('itemId getter', () => expect(m.itemId, 1));
    test('itemName getter', () => expect(m.itemName, '14.2 KG'));
    test('thisMonthSaleQty getter', () => expect(m.thisMonthSaleQty, 120.0));
    test('preMonthSaleQty getter', () => expect(m.preMonthSaleQty, 160.0));
    test('preYearSameMonthSaleQty getter', () =>
        expect(m.preYearSameMonthSaleQty, 135.0));
  });

  // ── chart data derivation ─────────────────────────────────────────────────
  group('[GetDashProductSaleComparisonMob] chart data derivation', () {
    test('thisMonthSaleQty.toDouble() safe', () {
      final m = GetDashProductSaleComparisonMob.fromJson(sampleJson);
      expect(m.thisMonthSaleQty?.toDouble(), 120.0);
    });
    test('null qty → fallback 0.0', () {
      final m = GetDashProductSaleComparisonMob();
      expect(m.thisMonthSaleQty?.toDouble() ?? 0.0, 0.0);
      expect(m.preMonthSaleQty?.toDouble() ?? 0.0, 0.0);
      expect(m.preYearSameMonthSaleQty?.toDouble() ?? 0.0, 0.0);
    });
    test('preMonthSaleQty fallback', () {
      final m = GetDashProductSaleComparisonMob(preMonthSaleQty: 160.0);
      expect(m.preMonthSaleQty?.toDouble() ?? 0.0, 160.0);
    });
  });
}

