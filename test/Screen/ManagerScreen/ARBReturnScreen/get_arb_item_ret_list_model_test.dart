import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ARBReturnScreen/GetARBItemRetListModel.dart';

void main() {
  // ── Fixtures ──────────────────────────────────────────────────────────────
  final Map<String, dynamic> itemDetailJson = {
    'pkId': 0,
    'ItemId': 14,
    'ItemName': 'DGCC Book',
    'Rate': 100.00,
    'RetQty': 2,
    'Reason': 'defective',
    'Amount': 200.00,
  };

  final Map<String, dynamic> fullJson = {
    'ARBRetId': 11,
    'ARBRetIdDtls': 0,
    'RetQty': 2,
    'DistributorId': 8118,
    'VendorId': 17,
    'VendorName': 'Test Vendor',
    'ReturnDate': '2025-07-04T00:00:00',
    'RetQtySum': 2,
    'TotalAmount': 200.00,
    'Amount': 200.00,
    'Remark': 'defective goods',
    'CNNo': null,
    'CNAmt': 0.0,
    'CNRemark': null,
    'DayEnd': 0,
    'ItemDetails': [itemDetailJson],
  };

  // ── ItemDetails ───────────────────────────────────────────────────────────
  group('ItemDetails.fromJson', () {
    test('parses all fields correctly', () {
      final d = ItemDetails.fromJson(itemDetailJson);
      expect(d.pkId, 0);
      expect(d.itemId, 14);
      expect(d.itemName, 'DGCC Book');
      expect(d.rate, 100.00);
      expect(d.retQty, 2);
      expect(d.reason, 'defective');
      expect(d.amount, 200.00);
    });

    test('handles empty JSON', () {
      final d = ItemDetails.fromJson({});
      expect(d.itemId, isNull);
      expect(d.itemName, isNull);
    });
  });

  group('ItemDetails.toJson', () {
    test('serialises all 7 fields', () {
      final j = ItemDetails.fromJson(itemDetailJson).toJson();
      expect(j.length, 7);
      expect(j['ItemName'], 'DGCC Book');
      expect(j['Amount'], 200.00);
    });

    test('round-trips correctly', () {
      final original = ItemDetails.fromJson(itemDetailJson);
      final restored = ItemDetails.fromJson(original.toJson());
      expect(restored.itemName, original.itemName);
      expect(restored.amount, original.amount);
      expect(restored.reason, original.reason);
    });
  });

  group('ItemDetails.copyWith', () {
    test('replaces rate and retQty', () {
      final d = ItemDetails.fromJson(itemDetailJson);
      final copy = d.copyWith(rate: 200.0, retQty: 5);
      expect(copy.rate, 200.0);
      expect(copy.retQty, 5);
      expect(copy.itemName, d.itemName);
    });
  });

  // ── GetArbItemRetListModel ────────────────────────────────────────────────
  group('GetArbItemRetListModel.fromJson', () {
    test('parses all scalar fields correctly', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      expect(m.aRBRetId, 11);
      expect(m.aRBRetIdDtls, 0);
      expect(m.retQty, 2);
      expect(m.distributorId, 8118);
      expect(m.vendorId, 17);
      expect(m.vendorName, 'Test Vendor');
      expect(m.returnDate, '2025-07-04T00:00:00');
      expect(m.retQtySum, 2);
      expect(m.totalAmount, 200.00);
      expect(m.amount, 200.00);
      expect(m.remark, 'defective goods');
      expect(m.cNNo, isNull);
      expect(m.cNAmt, 0.0);
      expect(m.cNRemark, isNull);
      expect(m.dayEnd, 0);
    });

    test('parses nested ItemDetails list', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      expect(m.itemDetails, isNotNull);
      expect(m.itemDetails!.length, 1);
      expect(m.itemDetails!.first.itemName, 'DGCC Book');
      expect(m.itemDetails!.first.amount, 200.00);
    });

    test('null ItemDetails produces null list', () {
      final json = Map<String, dynamic>.from(fullJson);
      json['ItemDetails'] = null;
      final m = GetArbItemRetListModel.fromJson(json);
      expect(m.itemDetails, isNull);
    });

    test('empty ItemDetails array produces empty list', () {
      final json = Map<String, dynamic>.from(fullJson);
      json['ItemDetails'] = [];
      final m = GetArbItemRetListModel.fromJson(json);
      expect(m.itemDetails, isEmpty);
    });

    test('handles empty JSON', () {
      final m = GetArbItemRetListModel.fromJson({});
      expect(m.aRBRetId, isNull);
      expect(m.vendorName, isNull);
      expect(m.itemDetails, isNull);
    });
  });

  group('GetArbItemRetListModel.toJson', () {
    test('serialises scalar fields', () {
      final j = GetArbItemRetListModel.fromJson(fullJson).toJson();
      expect(j['ARBRetId'], 11);
      expect(j['VendorName'], 'Test Vendor');
      expect(j['TotalAmount'], 200.00);
    });

    test('serialises nested ItemDetails list', () {
      final j = GetArbItemRetListModel.fromJson(fullJson).toJson();
      expect(j.containsKey('ItemDetails'), isTrue);
      final list = j['ItemDetails'] as List;
      expect(list.length, 1);
      expect(list.first['ItemName'], 'DGCC Book');
    });

    test('round-trips correctly', () {
      final original = GetArbItemRetListModel.fromJson(fullJson);
      final restored = GetArbItemRetListModel.fromJson(original.toJson());
      expect(restored.aRBRetId, original.aRBRetId);
      expect(restored.totalAmount, original.totalAmount);
      expect(restored.itemDetails!.first.itemName,
          original.itemDetails!.first.itemName);
    });
  });

  group('GetArbItemRetListModel.copyWith', () {
    test('replaces remark', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      final copy = m.copyWith(remark: 'Updated remark');
      expect(copy.remark, 'Updated remark');
      expect(copy.aRBRetId, m.aRBRetId);
    });

    test('replaces totalAmount and amount', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      final copy = m.copyWith(totalAmount: 500.0, amount: 500.0);
      expect(copy.totalAmount, 500.0);
      expect(copy.amount, 500.0);
    });

    test('copyWith without args preserves all', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.vendorId, m.vendorId);
      expect(copy.itemDetails!.length, m.itemDetails!.length);
    });
  });

  // ── Business logic ────────────────────────────────────────────────────────
  group('ARB Return – business logic', () {
    test('totalAmount equals sum of item details amounts', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      final sumFromItems = m.itemDetails!
          .fold<double>(0, (s, d) => s + (d.amount?.toDouble() ?? 0));
      expect(sumFromItems, closeTo(m.totalAmount!.toDouble(), 0.01));
    });

    test('retQty equals retQtySum', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      expect(m.retQty, m.retQtySum);
    });

    test('item amount = rate × retQty', () {
      final d = ItemDetails.fromJson(itemDetailJson);
      final expected = (d.rate ?? 0) * (d.retQty ?? 0);
      expect(expected, d.amount);
    });

    test('dayEnd = 0 means day has not been closed', () {
      final m = GetArbItemRetListModel.fromJson(fullJson);
      expect(m.dayEnd, 0);
    });
  });
}

