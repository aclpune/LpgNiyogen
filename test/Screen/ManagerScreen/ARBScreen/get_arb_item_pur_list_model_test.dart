import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ARBScreen/GetARBItemPurListModel.dart';

void main() {
  final Map<String, dynamic> itemDetailsJson = {
    'pkId': 0, 'ItemId': 11, 'ItemName': 'Safety Campaign Hose',
    'Rate': 800.00, 'PurQty': 2, 'BasicAmount': 1600.00,
    'TaxAmount': 50.00, 'NetAmount': 1650.00,
  };
  final Map<String, dynamic> fullJson = {
    'ARBPurId': 28, 'ARBPurIdDtls': 0, 'PurQty': 2,
    'DistributorId': 8118, 'InvoiceNo': 'hhccgzs', 'VendorId': 17,
    'VendorName': 'Test Vendor', 'InvoiceDate': '2025-06-24T00:00:00',
    'TotalAmount': 1650.00, 'PaidAmount': 0.00, 'BalanceAmount': 1650.00,
    'NetAmount': 1650.00, 'Remark': '', 'ItemDetails': [itemDetailsJson],
    'TransactionCode': null, 'DayEnd': 0,
  };

  group('ARBItemPur ItemDetails.fromJson', () {
    test('parses all 8 fields', () {
      final d = ItemDetails.fromJson(itemDetailsJson);
      expect(d.pkId, 0); expect(d.itemId, 11);
      expect(d.itemName, 'Safety Campaign Hose'); expect(d.rate, 800.00);
      expect(d.purQty, 2); expect(d.basicAmount, 1600.00);
      expect(d.taxAmount, 50.00); expect(d.netAmount, 1650.00);
    });
    test('handles empty JSON', () {
      final d = ItemDetails.fromJson({});
      expect(d.itemId, isNull); expect(d.netAmount, isNull);
    });
  });

  group('ARBItemPur ItemDetails.toJson', () {
    test('serialises 8 fields', () {
      final j = ItemDetails.fromJson(itemDetailsJson).toJson();
      expect(j.length, 8); expect(j['NetAmount'], 1650.00);
    });
    test('round-trips correctly', () {
      final o = ItemDetails.fromJson(itemDetailsJson);
      final r = ItemDetails.fromJson(o.toJson());
      expect(r.itemName, o.itemName); expect(r.netAmount, o.netAmount);
    });
  });

  group('ARBItemPur ItemDetails.copyWith', () {
    test('replaces rate and purQty', () {
      final d = ItemDetails.fromJson(itemDetailsJson);
      final copy = d.copyWith(rate: 900.0, purQty: 5);
      expect(copy.rate, 900.0); expect(copy.purQty, 5);
      expect(copy.itemName, d.itemName);
    });
    test('preserves all without args', () {
      final d = ItemDetails.fromJson(itemDetailsJson);
      expect(d.copyWith().taxAmount, d.taxAmount);
    });
  });

  group('GetArbItemPurListModel.fromJson', () {
    test('parses scalar fields', () {
      final m = GetArbItemPurListModel.fromJson(fullJson);
      expect(m.aRBPurId, 28); expect(m.distributorId, 8118);
      expect(m.invoiceNo, 'hhccgzs'); expect(m.vendorName, 'Test Vendor');
      expect(m.totalAmount, 1650.00); expect(m.paidAmount, 0.00);
      expect(m.balanceAmount, 1650.00); expect(m.dayEnd, 0);
    });
    test('parses nested ItemDetails list', () {
      final m = GetArbItemPurListModel.fromJson(fullJson);
      expect(m.itemDetails!.length, 1);
      expect(m.itemDetails!.first.itemName, 'Safety Campaign Hose');
    });
    test('null ItemDetails => null', () {
      final j = Map<String, dynamic>.from(fullJson)..['ItemDetails'] = null;
      expect(GetArbItemPurListModel.fromJson(j).itemDetails, isNull);
    });
    test('empty ItemDetails => empty list', () {
      final j = Map<String, dynamic>.from(fullJson)..['ItemDetails'] = [];
      expect(GetArbItemPurListModel.fromJson(j).itemDetails, isEmpty);
    });
    test('empty JSON all null', () {
      final m = GetArbItemPurListModel.fromJson({});
      expect(m.aRBPurId, isNull);
    });
  });

  group('GetArbItemPurListModel.toJson', () {
    test('serialises key fields', () {
      final j = GetArbItemPurListModel.fromJson(fullJson).toJson();
      expect(j['ARBPurId'], 28); expect(j['TotalAmount'], 1650.00);
    });
    test('serialises nested ItemDetails', () {
      final j = GetArbItemPurListModel.fromJson(fullJson).toJson();
      expect((j['ItemDetails'] as List).first['NetAmount'], 1650.00);
    });
    test('round-trips correctly', () {
      final o = GetArbItemPurListModel.fromJson(fullJson);
      final r = GetArbItemPurListModel.fromJson(o.toJson());
      expect(r.aRBPurId, o.aRBPurId);
      expect(r.itemDetails!.first.itemName, o.itemDetails!.first.itemName);
    });
  });

  group('GetArbItemPurListModel.copyWith', () {
    test('replaces paidAmount and balanceAmount', () {
      final m = GetArbItemPurListModel.fromJson(fullJson);
      final copy = m.copyWith(paidAmount: 800.0, balanceAmount: 850.0);
      expect(copy.paidAmount, 800.0); expect(copy.balanceAmount, 850.0);
    });
    test('preserves all without args', () {
      final m = GetArbItemPurListModel.fromJson(fullJson);
      expect(m.copyWith().invoiceNo, m.invoiceNo);
    });
  });

  group('ARB Purchase – business logic', () {
    test('balanceAmount = totalAmount - paidAmount', () {
      final m = GetArbItemPurListModel.fromJson(fullJson);
      expect((m.totalAmount ?? 0) - (m.paidAmount ?? 0),
          closeTo(m.balanceAmount ?? 0, 0.01));
    });
    test('netAmount = basicAmount + taxAmount', () {
      final d = ItemDetails.fromJson(itemDetailsJson);
      expect((d.basicAmount ?? 0) + (d.taxAmount ?? 0), d.netAmount);
    });
    test('basicAmount = rate × purQty', () {
      final d = ItemDetails.fromJson(itemDetailsJson);
      expect((d.rate ?? 0) * (d.purQty ?? 0), d.basicAmount);
    });
    test('paidAmount must not exceed totalAmount', () {
      final m = GetArbItemPurListModel.fromJson(fullJson);
      expect((m.paidAmount ?? 0) <= (m.totalAmount ?? 0), isTrue);
    });
  });
}

