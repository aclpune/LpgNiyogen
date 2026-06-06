// Tests for: lib/Screen/ManagerScreen/ExpensesScreen/HeadWiseExpenseLstModel.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ExpensesScreen/HeadWiseExpenseLstModel.dart';

void main() {
  final sampleJson = {
    'DistributorId': 8118,
    'ParentExpHeadId': 1,
    'ParentExpHeadName': 'Office Expense',
    'TotExpAmt': 95201.0,
  };

  // ── fromJson ──────────────────────────────────────────────────────────────
  group('[HeadWiseExpenseLstModel] fromJson', () {
    test('parses distributorId', () =>
        expect(HeadWiseExpenseLstModel.fromJson(sampleJson).distributorId, 8118));
    test('parses parentExpHeadId', () =>
        expect(HeadWiseExpenseLstModel.fromJson(sampleJson).parentExpHeadId, 1));
    test('parses parentExpHeadName', () =>
        expect(HeadWiseExpenseLstModel.fromJson(sampleJson).parentExpHeadName,
            'Office Expense'));
    test('parses totExpAmt', () =>
        expect(HeadWiseExpenseLstModel.fromJson(sampleJson).totExpAmt, 95201.0));
    test('null parentExpHeadName → null', () {
      final j = <String, dynamic>{'ParentExpHeadName': null};
      expect(HeadWiseExpenseLstModel.fromJson(j).parentExpHeadName, isNull);
    });
    test('null totExpAmt → null', () {
      final j = <String, dynamic>{'TotExpAmt': null};
      expect(HeadWiseExpenseLstModel.fromJson(j).totExpAmt, isNull);
    });
    test('0 totExpAmt parsed', () {
      final j = {'TotExpAmt': 0.0};
      expect(HeadWiseExpenseLstModel.fromJson(j).totExpAmt, 0.0);
    });
  });

  // ── default constructor ────────────────────────────────────────────────────
  group('[HeadWiseExpenseLstModel] default constructor', () {
    test('all fields null', () {
      final m = HeadWiseExpenseLstModel();
      expect(m.distributorId,      isNull);
      expect(m.parentExpHeadId,    isNull);
      expect(m.parentExpHeadName,  isNull);
      expect(m.totExpAmt,          isNull);
    });
  });

  // ── toJson ────────────────────────────────────────────────────────────────
  group('[HeadWiseExpenseLstModel] toJson', () {
    test('round-trips all fields', () {
      final m = HeadWiseExpenseLstModel.fromJson(sampleJson);
      final map = m.toJson();
      expect(map['DistributorId'],     8118);
      expect(map['ParentExpHeadId'],   1);
      expect(map['ParentExpHeadName'], 'Office Expense');
      expect(map['TotExpAmt'],         95201.0);
    });
    test('has 4 keys', () {
      expect(HeadWiseExpenseLstModel().toJson().keys.length, 4);
    });
    test('contains expected keys', () {
      final keys = HeadWiseExpenseLstModel().toJson().keys.toSet();
      expect(keys, containsAll([
        'DistributorId', 'ParentExpHeadId', 'ParentExpHeadName', 'TotExpAmt',
      ]));
    });
    test('null values in toJson', () {
      expect(HeadWiseExpenseLstModel().toJson()['TotExpAmt'], isNull);
    });
    test('non-null amount preserved', () {
      final m = HeadWiseExpenseLstModel(totExpAmt: 500.0);
      expect(m.toJson()['TotExpAmt'], 500.0);
    });
  });

  // ── copyWith ──────────────────────────────────────────────────────────────
  group('[HeadWiseExpenseLstModel] copyWith', () {
    test('overrides totExpAmt only', () {
      final m = HeadWiseExpenseLstModel(
          parentExpHeadName: 'Office Expense', totExpAmt: 95201.0);
      final copy = m.copyWith(totExpAmt: 99999.0);
      expect(copy.parentExpHeadName, 'Office Expense');
      expect(copy.totExpAmt,         99999.0);
    });
    test('no override → all original', () {
      final m = HeadWiseExpenseLstModel(
          parentExpHeadName: 'Fuel', totExpAmt: 5000.0);
      final copy = m.copyWith();
      expect(copy.parentExpHeadName, 'Fuel');
      expect(copy.totExpAmt,         5000.0);
    });
    test('override parentExpHeadName', () {
      final m = HeadWiseExpenseLstModel(parentExpHeadName: 'Office');
      final copy = m.copyWith(parentExpHeadName: 'Travel');
      expect(copy.parentExpHeadName, 'Travel');
    });
    test('override distributorId', () {
      final m = HeadWiseExpenseLstModel(distributorId: 8118);
      final copy = m.copyWith(distributorId: 9999);
      expect(copy.distributorId, 9999);
    });
  });

  // ── getters ───────────────────────────────────────────────────────────────
  group('[HeadWiseExpenseLstModel] getters', () {
    final m = HeadWiseExpenseLstModel.fromJson(sampleJson);
    test('distributorId getter', () => expect(m.distributorId, 8118));
    test('parentExpHeadId getter', () => expect(m.parentExpHeadId, 1));
    test('parentExpHeadName getter', () =>
        expect(m.parentExpHeadName, 'Office Expense'));
    test('totExpAmt getter', () => expect(m.totExpAmt, 95201.0));
  });

  // ── business logic: toDouble fallback ────────────────────────────────────
  group('[HeadWiseExpenseLstModel] totExpAmt safe conversion', () {
    test('non-null → toDouble()', () {
      final m = HeadWiseExpenseLstModel(totExpAmt: 95201.0);
      expect(m.totExpAmt?.toDouble(), 95201.0);
    });
    test('null → fallback 0.0', () {
      final m = HeadWiseExpenseLstModel();
      expect(m.totExpAmt?.toDouble() ?? 0.0, 0.0);
    });
    test('0 → toDouble() = 0.0', () {
      final m = HeadWiseExpenseLstModel(totExpAmt: 0);
      expect(m.totExpAmt?.toDouble(), 0.0);
    });
    test('integer value converted', () {
      final m = HeadWiseExpenseLstModel(totExpAmt: 1000);
      expect(m.totExpAmt?.toDouble(), 1000.0);
    });
  });

  // ── parentExpHeadName fallback ────────────────────────────────────────────
  group('[HeadWiseExpenseLstModel] parentExpHeadName fallback', () {
    test('non-null returned', () {
      final m = HeadWiseExpenseLstModel(parentExpHeadName: 'Fuel');
      expect(m.parentExpHeadName ?? '', 'Fuel');
    });
    test('null → ""', () {
      final m = HeadWiseExpenseLstModel();
      expect(m.parentExpHeadName ?? '', '');
    });
  });
}

