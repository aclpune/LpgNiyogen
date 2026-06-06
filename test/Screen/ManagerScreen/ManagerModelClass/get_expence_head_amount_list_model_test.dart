import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetExpenceHeadAmountListModel.dart';

void main() {
  group('GetExpenceHeadAmountListModel', () {
    final sampleJson = {
      'ExpHeadId': 10,
      'DistributorId': 8118,
      'ExpHeadName': 'ARB Item Purchase Paymt',
      'ParentHeadId': 1,
      'ParentHeadName': 'Office Expense',
      'AddedBy': 0,
      'IsActive': 1,
      'Action': null,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetExpenceHeadAmountListModel.fromJson(sampleJson);
      expect(model.expHeadId, 10);
      expect(model.distributorId, 8118);
      expect(model.expHeadName, 'ARB Item Purchase Paymt');
      expect(model.parentHeadId, 1);
      expect(model.parentHeadName, 'Office Expense');
      expect(model.isActive, 1);
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetExpenceHeadAmountListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['ExpHeadId'], 10);
      expect(json['ExpHeadName'], 'ARB Item Purchase Paymt');
      expect(json['IsActive'], 1);
    });

    test('copyWith updates specified fields', () {
      final model = GetExpenceHeadAmountListModel.fromJson(sampleJson);
      final updated = model.copyWith(expHeadName: 'Updated', isActive: 0);
      expect(updated.expHeadName, 'Updated');
      expect(updated.isActive, 0);
      expect(model.isActive, 1);
    });

    test('default constructor with null values', () {
      final model = GetExpenceHeadAmountListModel();
      expect(model.expHeadId, isNull);
      expect(model.expHeadName, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetExpenceHeadAmountListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetExpenceHeadAmountListModel.fromJson(json);
      expect(model2.expHeadId, model.expHeadId);
      expect(model2.expHeadName, model.expHeadName);
    });
  });
}

