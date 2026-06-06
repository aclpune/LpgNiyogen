import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetVendorDetailListModel.dart';

void main() {
  final fullJson = {
    'ARBPurId': 14, 'DistributorId': 8118, 'InvoiceNo': '123',
    'InvoiceDate': '2025-07-03T15:40:49', 'VendorId': 78,
    'VendorName': 'Sagar parmar', 'ItemId': 0, 'ItemName': null,
    'PurchaseAmount': 60054.00, 'TotalPaid': 0.00, 'PendingAmount': 60054.00,
  };

  group('GetVendorDetailListModel.fromJson', () {
    test('parses all 11 fields', () {
      final m = GetVendorDetailListModel.fromJson(fullJson);
      expect(m.aRBPurId, 14); expect(m.distributorId, 8118);
      expect(m.invoiceNo, '123');
      expect(m.invoiceDate, '2025-07-03T15:40:49');
      expect(m.vendorId, 78); expect(m.vendorName, 'Sagar parmar');
      expect(m.itemId, 0); expect(m.itemName, isNull);
      expect(m.purchaseAmount, 60054.00);
      expect(m.totalPaid, 0.00); expect(m.pendingAmount, 60054.00);
    });
    test('handles empty JSON', () {
      final m = GetVendorDetailListModel.fromJson({});
      expect(m.aRBPurId, isNull); expect(m.purchaseAmount, isNull);
    });
  });

  group('GetVendorDetailListModel.toJson', () {
    test('serialises 11 fields', () {
      final j = GetVendorDetailListModel.fromJson(fullJson).toJson();
      expect(j.length, 11);
      expect(j['VendorName'], 'Sagar parmar');
      expect(j['PurchaseAmount'], 60054.00);
    });
    test('round-trips correctly', () {
      final o = GetVendorDetailListModel.fromJson(fullJson);
      final r = GetVendorDetailListModel.fromJson(o.toJson());
      expect(r.vendorName, o.vendorName);
      expect(r.pendingAmount, o.pendingAmount);
    });
  });

  group('GetVendorDetailListModel.copyWith', () {
    test('replaces totalPaid and pendingAmount', () {
      final m = GetVendorDetailListModel.fromJson(fullJson);
      final copy = m.copyWith(totalPaid: 20000.0, pendingAmount: 40054.0);
      expect(copy.totalPaid, 20000.0);
      expect(copy.pendingAmount, 40054.0);
    });
    test('preserves all without args', () {
      final m = GetVendorDetailListModel.fromJson(fullJson);
      expect(m.copyWith().invoiceNo, m.invoiceNo);
    });
  });

  group('Vendor detail – business logic', () {
    test('pendingAmount = purchaseAmount - totalPaid', () {
      final m = GetVendorDetailListModel.fromJson(fullJson);
      expect((m.purchaseAmount ?? 0) - (m.totalPaid ?? 0),
          closeTo(m.pendingAmount ?? 0, 0.01));
    });
    test('totalPaid must not exceed purchaseAmount', () {
      final m = GetVendorDetailListModel.fromJson(fullJson);
      expect((m.totalPaid ?? 0) <= (m.purchaseAmount ?? 0), isTrue);
    });
    test('pendingAmount is non-negative', () {
      final m = GetVendorDetailListModel.fromJson(fullJson);
      expect((m.pendingAmount ?? 0) >= 0, isTrue);
    });
    test('vendorId is positive', () {
      final m = GetVendorDetailListModel.fromJson(fullJson);
      expect((m.vendorId ?? 0) > 0, isTrue);
    });
  });
}

