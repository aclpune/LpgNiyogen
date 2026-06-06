import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/ManagerGetDsrSVTVListModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'TransCate': 'SV',
    'Quantity': 1,
    'Mode': null,
    'Amount': 5705.50,
    'ItemName': '14.2 KG',
    'ItemId': 1,
    'Date': '0001-01-01T00:00:00',
    'SVType': 'DBC',
    'TransDate': '2025-08-29T00:00:00',
    'TotalSaleQty': 1,
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('ManagerGetDsrSvtvListModel.fromJson', () {
    test('parses all 11 fields correctly', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.transCate, 'SV');
      expect(m.quantity, 1);
      expect(m.mode, isNull);
      expect(m.amount, 5705.50);
      expect(m.itemName, '14.2 KG');
      expect(m.itemId, 1);
      expect(m.date, '0001-01-01T00:00:00');
      expect(m.sVType, 'DBC');
      expect(m.transDate, '2025-08-29T00:00:00');
      expect(m.totalSaleQty, 1);
    });

    test('TV record: transCate is TV', () {
      final tvJson = Map<String, dynamic>.from(fullJson)
        ..['TransCate'] = 'TV'
        ..['SVType'] = 'TV';
      final m = ManagerGetDsrSvtvListModel.fromJson(tvJson);
      expect(m.transCate, 'TV');
    });

    test('handles empty JSON', () {
      final m = ManagerGetDsrSvtvListModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.amount, isNull);
      expect(m.transCate, isNull);
    });

    test('handles null mode field', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      expect(m.mode, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('ManagerGetDsrSvtvListModel.toJson', () {
    test('serialises 11 fields', () {
      final j = ManagerGetDsrSvtvListModel.fromJson(fullJson).toJson();
      expect(j.length, 11);
      expect(j['TransCate'], 'SV');
      expect(j['Amount'], 5705.50);
      expect(j['SVType'], 'DBC');
    });

    test('round-trips correctly', () {
      final o = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      final r = ManagerGetDsrSvtvListModel.fromJson(o.toJson());
      expect(r.amount, o.amount);
      expect(r.transCate, o.transCate);
      expect(r.transDate, o.transDate);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('ManagerGetDsrSvtvListModel.copyWith', () {
    test('replaces transCate', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      final copy = m.copyWith(transCate: 'TV');
      expect(copy.transCate, 'TV');
      expect(copy.amount, m.amount);
    });

    test('replaces amount and quantity', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      final copy = m.copyWith(amount: 9999.0, quantity: 5);
      expect(copy.amount, 9999.0);
      expect(copy.quantity, 5);
      expect(copy.itemName, m.itemName);
    });

    test('preserves all without args', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      expect(m.copyWith().sVType, m.sVType);
    });
  });

  // ── Business logic ────────────────────────────────────────────────────────
  group('DSR SV/TV – business logic', () {
    test('transCate must be SV or TV', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      expect(['SV', 'TV'].contains(m.transCate), isTrue);
    });

    test('quantity must be positive', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      expect((m.quantity ?? 0) > 0, isTrue);
    });

    test('amount must be positive', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      expect((m.amount ?? 0) > 0, isTrue);
    });

    test('totalSaleQty equals quantity for single item', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      expect(m.totalSaleQty, m.quantity);
    });

    test('svType DBC is valid SV type', () {
      final m = ManagerGetDsrSvtvListModel.fromJson(fullJson);
      final validSvTypes = ['DBC', 'NC', 'RC', 'TV'];
      expect(validSvTypes.contains(m.sVType), isTrue);
    });
  });
}

