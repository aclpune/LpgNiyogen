import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/DsrReportCashInHandModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'Date': '2026-05-15T00:00:00',
    'StaffId': 19,
    'ItemName': '14.2 KG- Daily Sale',
    'totalAmount': 15304.50,
    'ItemId': 1,
    'TransCate': 'CashInHand',
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('DsrReportCashInHandModel.fromJson', () {
    test('parses all fields correctly', () {
      final m = DsrReportCashInHandModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.date, '2026-05-15T00:00:00');
      expect(m.staffId, 19);
      expect(m.itemName, '14.2 KG- Daily Sale');
      expect(m.totalAmount, 15304.50);
      expect(m.itemId, 1);
      expect(m.transCate, 'CashInHand');
    });

    test('handles null Date and TransCate', () {
      final m = DsrReportCashInHandModel.fromJson({
        'DistributorId': 8118,
        'Date': null,
        'StaffId': 0,
        'ItemName': '14.2 KG',
        'totalAmount': 0.0,
        'ItemId': 0,
        'TransCate': null,
      });
      expect(m.date, isNull);
      expect(m.transCate, isNull);
    });

    test('handles completely empty JSON', () {
      final m = DsrReportCashInHandModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.itemName, isNull);
      expect(m.totalAmount, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('DsrReportCashInHandModel.toJson', () {
    test('serialises all fields correctly', () {
      final j = DsrReportCashInHandModel.fromJson(fullJson).toJson();
      expect(j['DistributorId'], 8118);
      expect(j['ItemName'], '14.2 KG- Daily Sale');
      expect(j['totalAmount'], 15304.50);
      expect(j['StaffId'], 19);
      expect(j['TransCate'], 'CashInHand');
    });

    test('toJson contains 7 keys', () {
      final j = DsrReportCashInHandModel.fromJson(fullJson).toJson();
      expect(j.length, 7);
    });

    test('round-trips correctly', () {
      final original = DsrReportCashInHandModel.fromJson(fullJson);
      final restored = DsrReportCashInHandModel.fromJson(original.toJson());
      expect(restored.itemName, original.itemName);
      expect(restored.totalAmount, original.totalAmount);
      expect(restored.staffId, original.staffId);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('DsrReportCashInHandModel.copyWith', () {
    test('replaces totalAmount only', () {
      final m = DsrReportCashInHandModel.fromJson(fullJson);
      final copy = m.copyWith(totalAmount: 9999.0);
      expect(copy.totalAmount, 9999.0);
      expect(copy.distributorId, m.distributorId);
      expect(copy.itemName, m.itemName);
    });

    test('replaces staffId and itemName', () {
      final m = DsrReportCashInHandModel.fromJson(fullJson);
      final copy = m.copyWith(staffId: 99, itemName: 'New Item');
      expect(copy.staffId, 99);
      expect(copy.itemName, 'New Item');
      expect(copy.totalAmount, m.totalAmount);
    });

    test('copyWith without args preserves all', () {
      final m = DsrReportCashInHandModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.itemId, m.itemId);
      expect(copy.totalAmount, m.totalAmount);
    });
  });

  // ── Constructor ───────────────────────────────────────────────────────────
  group('DsrReportCashInHandModel constructor', () {
    test('sets fields via named parameters', () {
      final m = DsrReportCashInHandModel(
        distributorId: 1,
        itemName: 'Test',
        totalAmount: 500.0,
        staffId: 10,
      );
      expect(m.distributorId, 1);
      expect(m.itemName, 'Test');
      expect(m.totalAmount, 500.0);
      expect(m.staffId, 10);
    });
  });
}

