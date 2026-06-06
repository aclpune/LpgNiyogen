import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/HeadWiseExpenseLstModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'ParentExpHeadId': 1,
    'ParentExpHeadName': 'Office Expense',
    'TotExpAmt': 74014.00,
  };

  group('HeadWiseExpenseLstModel.fromJson', () {
    test('parses all 4 fields', () {
      final m = HeadWiseExpenseLstModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.parentExpHeadId, 1);
      expect(m.parentExpHeadName, 'Office Expense');
      expect(m.totExpAmt, 74014.00);
    });

    test('handles empty JSON', () {
      final m = HeadWiseExpenseLstModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.totExpAmt, isNull);
    });

    test('handles zero expense amount', () {
      final m = HeadWiseExpenseLstModel.fromJson({
        'DistributorId': 8118, 'ParentExpHeadId': 2,
        'ParentExpHeadName': 'Salary', 'TotExpAmt': 0.00,
      });
      expect(m.totExpAmt, 0.00);
    });
  });

  group('HeadWiseExpenseLstModel.toJson', () {
    test('serialises 4 fields', () {
      final j = HeadWiseExpenseLstModel.fromJson(fullJson).toJson();
      expect(j.length, 4);
      expect(j['ParentExpHeadName'], 'Office Expense');
      expect(j['TotExpAmt'], 74014.00);
    });

    test('round-trips correctly', () {
      final o = HeadWiseExpenseLstModel.fromJson(fullJson);
      final r = HeadWiseExpenseLstModel.fromJson(o.toJson());
      expect(r.parentExpHeadName, o.parentExpHeadName);
      expect(r.totExpAmt, o.totExpAmt);
    });
  });

  group('HeadWiseExpenseLstModel.copyWith', () {
    test('replaces totExpAmt', () {
      final m = HeadWiseExpenseLstModel.fromJson(fullJson);
      expect(m.copyWith(totExpAmt: 9999.0).totExpAmt, 9999.0);
    });

    test('replaces parentExpHeadName', () {
      final m = HeadWiseExpenseLstModel.fromJson(fullJson);
      expect(m.copyWith(parentExpHeadName: 'Rent').parentExpHeadName, 'Rent');
    });

    test('preserves all without args', () {
      final m = HeadWiseExpenseLstModel.fromJson(fullJson);
      expect(m.copyWith().distributorId, m.distributorId);
    });
  });

  group('HeadWiseExpense – business logic', () {
    test('totExpAmt must be non-negative', () {
      final m = HeadWiseExpenseLstModel.fromJson(fullJson);
      expect((m.totExpAmt ?? 0) >= 0, isTrue);
    });

    test('parentExpHeadId is positive', () {
      final m = HeadWiseExpenseLstModel.fromJson(fullJson);
      expect((m.parentExpHeadId ?? 0) > 0, isTrue);
    });

    test('multiple expense heads sum correctly', () {
      final heads = [
        HeadWiseExpenseLstModel.fromJson({...fullJson, 'TotExpAmt': 10000.0}),
        HeadWiseExpenseLstModel.fromJson({...fullJson, 'TotExpAmt': 5000.0}),
        HeadWiseExpenseLstModel.fromJson({...fullJson, 'TotExpAmt': 2000.0}),
      ];
      final total = heads.fold<double>(0, (s, h) => s + (h.totExpAmt?.toDouble() ?? 0));
      expect(total, 17000.0);
    });
  });
}

