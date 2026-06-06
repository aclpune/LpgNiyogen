import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetExpenseHeaderListModel.dart';

void main() {
  group('GetExpenseHeaderListModel', () {
    final sampleJson = {
      'ExpHeadId': 10170,
      'DistributorId': 8118,
      'ExpHeadName': 'Transportation/courier',
      'ParentHeadId': 3,
      'ParentHeadName': 'Operational Expenses',
      'AddedBy': 0,
      'IsActive': 1,
      'Action': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetExpenseHeaderListModel(
        expHeadId: 10170,
        distributorId: 8118,
        expHeadName: 'Transportation/courier',
        parentHeadId: 3,
        parentHeadName: 'Operational Expenses',
        addedBy: 0,
        isActive: 1,
        action: null,
      );

      expect(model.expHeadId, 10170);
      expect(model.distributorId, 8118);
      expect(model.expHeadName, 'Transportation/courier');
      expect(model.parentHeadId, 3);
      expect(model.parentHeadName, 'Operational Expenses');
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
      expect(model.action, isNull);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetExpenseHeaderListModel.fromJson(sampleJson);

      expect(model.expHeadId, 10170);
      expect(model.distributorId, 8118);
      expect(model.expHeadName, 'Transportation/courier');
      expect(model.parentHeadId, 3);
      expect(model.parentHeadName, 'Operational Expenses');
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetExpenseHeaderListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['ExpHeadId'], 10170);
      expect(json['DistributorId'], 8118);
      expect(json['ExpHeadName'], 'Transportation/courier');
      expect(json['ParentHeadId'], 3);
      expect(json['ParentHeadName'], 'Operational Expenses');
      expect(json['IsActive'], 1);
      expect(json['Action'], isNull);
    });

    test('toJson includes all keys', () {
      final model = GetExpenseHeaderListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json.containsKey('ExpHeadId'), isTrue);
      expect(json.containsKey('DistributorId'), isTrue);
      expect(json.containsKey('ExpHeadName'), isTrue);
      expect(json.containsKey('ParentHeadId'), isTrue);
      expect(json.containsKey('ParentHeadName'), isTrue);
      expect(json.containsKey('AddedBy'), isTrue);
      expect(json.containsKey('IsActive'), isTrue);
      expect(json.containsKey('Action'), isTrue);
    });

    test('copyWith updates specified fields', () {
      final model = GetExpenseHeaderListModel.fromJson(sampleJson);
      final updated = model.copyWith(expHeadName: 'Updated Expense', isActive: 0);

      expect(updated.expHeadName, 'Updated Expense');
      expect(updated.isActive, 0);
      expect(model.expHeadName, 'Transportation/courier');
      expect(model.isActive, 1);
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetExpenseHeaderListModel.fromJson(sampleJson);
      final updated = model.copyWith(addedBy: 5);

      expect(updated.expHeadId, model.expHeadId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.parentHeadName, model.parentHeadName);
      expect(updated.addedBy, 5);
    });

    test('default constructor with null values', () {
      final model = GetExpenseHeaderListModel();

      expect(model.expHeadId, isNull);
      expect(model.expHeadName, isNull);
      expect(model.isActive, isNull);
      expect(model.action, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetExpenseHeaderListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetExpenseHeaderListModel.fromJson(json);

      expect(model2.expHeadId, model.expHeadId);
      expect(model2.expHeadName, model.expHeadName);
      expect(model2.parentHeadName, model.parentHeadName);
      expect(model2.isActive, model.isActive);
    });

    test('isActive flag correctly reflects active status', () {
      final activeModel = GetExpenseHeaderListModel.fromJson(sampleJson);
      expect(activeModel.isActive, 1);

      final inactiveModel = GetExpenseHeaderListModel.fromJson({
        ...sampleJson,
        'IsActive': 0,
      });
      expect(inactiveModel.isActive, 0);
    });
  });
}

