import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/ARBProfitDetailDataGetModel.dart';

void main() {
  final fullJson = {
    'DistributorId': 0, 'ItemId': 5, 'ItemName': '2 Burner Delux',
    'ItemQty': 36, 'GrossSaleAmt': 98760.00,
    'PurchesAmt': 23000.00, 'GrossProfitAmt': 75760.00,
  };

  group('ArbProfitDetailDataGetModel.fromJson', () {
    test('parses all 7 fields', () {
      final m = ArbProfitDetailDataGetModel.fromJson(fullJson);
      expect(m.distributorId, 0); expect(m.itemId, 5);
      expect(m.itemName, '2 Burner Delux'); expect(m.itemQty, 36);
      expect(m.grossSaleAmt, 98760.00); expect(m.purchesAmt, 23000.00);
      expect(m.grossProfitAmt, 75760.00);
    });
    test('handles empty JSON', () {
      final m = ArbProfitDetailDataGetModel.fromJson({});
      expect(m.itemId, isNull); expect(m.grossProfitAmt, isNull);
    });
  });

  group('ArbProfitDetailDataGetModel.toJson', () {
    test('serialises 7 fields', () {
      final j = ArbProfitDetailDataGetModel.fromJson(fullJson).toJson();
      expect(j.length, 7); expect(j['GrossProfitAmt'], 75760.00);
    });
    test('round-trips correctly', () {
      final o = ArbProfitDetailDataGetModel.fromJson(fullJson);
      final r = ArbProfitDetailDataGetModel.fromJson(o.toJson());
      expect(r.grossSaleAmt, o.grossSaleAmt);
      expect(r.grossProfitAmt, o.grossProfitAmt);
    });
  });

  group('ArbProfitDetailDataGetModel.copyWith', () {
    test('replaces grossProfitAmt', () {
      final m = ArbProfitDetailDataGetModel.fromJson(fullJson);
      expect(m.copyWith(grossProfitAmt: 1000.0).grossProfitAmt, 1000.0);
    });
    test('preserves all without args', () {
      final m = ArbProfitDetailDataGetModel.fromJson(fullJson);
      expect(m.copyWith().itemName, m.itemName);
    });
  });

  group('ARB Profit – business logic', () {
    test('grossProfitAmt = grossSaleAmt - purchesAmt', () {
      final m = ArbProfitDetailDataGetModel.fromJson(fullJson);
      expect((m.grossSaleAmt ?? 0) - (m.purchesAmt ?? 0),
          closeTo(m.grossProfitAmt ?? 0, 0.01));
    });
    test('grossSaleAmt must be >= purchesAmt for positive profit', () {
      final m = ArbProfitDetailDataGetModel.fromJson(fullJson);
      expect((m.grossSaleAmt ?? 0) >= (m.purchesAmt ?? 0), isTrue);
    });
    test('profit margin as percentage', () {
      final m = ArbProfitDetailDataGetModel.fromJson(fullJson);
      final margin = ((m.grossProfitAmt ?? 0) / (m.grossSaleAmt ?? 1)) * 100;
      expect(margin, closeTo(76.72, 0.1));
    });
    test('itemQty is positive', () {
      final m = ArbProfitDetailDataGetModel.fromJson(fullJson);
      expect((m.itemQty ?? 0) > 0, isTrue);
    });
  });
}

