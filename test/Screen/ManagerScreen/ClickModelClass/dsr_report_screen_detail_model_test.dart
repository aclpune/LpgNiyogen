import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/DSRReportScreenDetailModel.dart';

void main() {
  // ── Fixtures ────────────────────────────────────────────────────────────
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'Date': '2026-05-15T00:00:00',
    'ItemId': 1,
    'ItemName': '14.2 KG SV Sale',
    'SaleAmt': 855.50,
    'CashAmt': 855.50,
    'BankAmt': 0.0,
    'CreditAmt': 0.00,
    'Category': 'SV',
    'TransCate': 'DailySale',
    'QtyName': 5,
    'CoustemerName': 'John Doe',
    'Flag': 'Y',
    'MerchantQR': 0.00,
    'PrepaidAmt': 0.00,
  };

  // ── fromJson ─────────────────────────────────────────────────────────────
  group('DsrReportScreenDetailModel.fromJson', () {
    test('parses all fields from valid JSON', () {
      final m = DsrReportScreenDetailModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.date, '2026-05-15T00:00:00');
      expect(m.itemId, 1);
      expect(m.itemName, '14.2 KG SV Sale');
      expect(m.saleAmt, 855.50);
      expect(m.cashAmt, 855.50);
      expect(m.bankAmt, 0.0);
      expect(m.creditAmt, 0.00);
      expect(m.category, 'SV');
      expect(m.transCate, 'DailySale');
      expect(m.qtyName, 5);
      expect(m.coustemerName, 'John Doe');
      expect(m.flag, 'Y');
      expect(m.merchantQR, 0.00);
      expect(m.prepaidAmt, 0.00);
    });

    test('handles null nullable fields', () {
      final m = DsrReportScreenDetailModel.fromJson({
        'DistributorId': 8118,
        'Date': null,
        'ItemId': 1,
        'ItemName': null,
        'SaleAmt': 100.0,
        'CashAmt': 100.0,
        'BankAmt': 0.0,
        'CreditAmt': 0.0,
        'Category': null,
        'TransCate': 'DailySale',
        'QtyName': 0,
        'CoustemerName': null,
        'Flag': null,
        'MerchantQR': 0.0,
        'PrepaidAmt': 0.0,
      });
      expect(m.date, isNull);
      expect(m.itemName, isNull);
      expect(m.category, isNull);
      expect(m.flag, isNull);
      expect(m.coustemerName, isNull);
    });

    test('handles empty JSON – all fields null', () {
      final m = DsrReportScreenDetailModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.itemId, isNull);
      expect(m.saleAmt, isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('DsrReportScreenDetailModel.toJson', () {
    test('serialises all fields correctly', () {
      final m = DsrReportScreenDetailModel.fromJson(fullJson);
      final j = m.toJson();
      expect(j['DistributorId'], 8118);
      expect(j['ItemName'], '14.2 KG SV Sale');
      expect(j['SaleAmt'], 855.50);
      expect(j['TransCate'], 'DailySale');
    });

    test('round-trips through fromJson → toJson → fromJson', () {
      final original = DsrReportScreenDetailModel.fromJson(fullJson);
      final restored = DsrReportScreenDetailModel.fromJson(original.toJson());
      expect(restored.distributorId, original.distributorId);
      expect(restored.itemName, original.itemName);
      expect(restored.saleAmt, original.saleAmt);
      expect(restored.transCate, original.transCate);
    });

    test('toJson contains all 15 keys', () {
      final j = DsrReportScreenDetailModel.fromJson(fullJson).toJson();
      expect(j.length, 15);
    });
  });

  // ── copyWith ─────────────────────────────────────────────────────────────
  group('DsrReportScreenDetailModel.copyWith', () {
    test('replaces only itemName', () {
      final m = DsrReportScreenDetailModel.fromJson(fullJson);
      final copy = m.copyWith(itemName: 'NEW ITEM');
      expect(copy.itemName, 'NEW ITEM');
      expect(copy.distributorId, m.distributorId);
    });

    test('replaces saleAmt and cashAmt together', () {
      final m = DsrReportScreenDetailModel.fromJson(fullJson);
      final copy = m.copyWith(saleAmt: 999.0, cashAmt: 999.0);
      expect(copy.saleAmt, 999.0);
      expect(copy.cashAmt, 999.0);
      expect(copy.bankAmt, m.bankAmt);
    });

    test('copyWith without args preserves all fields', () {
      final m = DsrReportScreenDetailModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.itemId, m.itemId);
      expect(copy.transCate, m.transCate);
    });
  });

  // ── Constructor ───────────────────────────────────────────────────────────
  group('DsrReportScreenDetailModel constructor', () {
    test('sets fields via named parameters', () {
      final m = DsrReportScreenDetailModel(
        distributorId: 100,
        itemName: 'Test Item',
        saleAmt: 500.0,
        transCate: 'TVSale',
      );
      expect(m.distributorId, 100);
      expect(m.itemName, 'Test Item');
      expect(m.saleAmt, 500.0);
      expect(m.transCate, 'TVSale');
    });

    test('unset fields default to null', () {
      final m = DsrReportScreenDetailModel(distributorId: 1);
      expect(m.itemName, isNull);
      expect(m.saleAmt, isNull);
    });
  });
}

