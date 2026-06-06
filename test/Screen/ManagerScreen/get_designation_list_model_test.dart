import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/GetDesignationListModel.dart';

void main() {
  group('GetDesignationListModel', () {
    final sampleJson = {
      'DesignationId': 17,
      'CategoryName': 'PermissionFor',
      'MasterName': 'Invoice Number',
    };

    test('constructor sets all fields correctly', () {
      final model = GetDesignationListModel(
        designationId: 17,
        categoryName: 'PermissionFor',
        masterName: 'Invoice Number',
      );

      expect(model.designationId, 17);
      expect(model.categoryName, 'PermissionFor');
      expect(model.masterName, 'Invoice Number');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetDesignationListModel.fromJson(sampleJson);

      expect(model.designationId, 17);
      expect(model.categoryName, 'PermissionFor');
      expect(model.masterName, 'Invoice Number');
    });

    test('toJson returns correct map', () {
      final model = GetDesignationListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['DesignationId'], 17);
      expect(json['CategoryName'], 'PermissionFor');
      expect(json['MasterName'], 'Invoice Number');
    });

    test('copyWith updates specified fields', () {
      final model = GetDesignationListModel.fromJson(sampleJson);
      final updated = model.copyWith(masterName: 'Manual Invoice');

      expect(updated.masterName, 'Manual Invoice');
      expect(updated.designationId, model.designationId);
      expect(model.masterName, 'Invoice Number');
    });

    test('copyWith preserves values when not overridden', () {
      final model = GetDesignationListModel.fromJson(sampleJson);
      final updated = model.copyWith();

      expect(updated.designationId, model.designationId);
      expect(updated.categoryName, model.categoryName);
      expect(updated.masterName, model.masterName);
    });

    test('default constructor leaves values null', () {
      final model = GetDesignationListModel();

      expect(model.designationId, isNull);
      expect(model.categoryName, isNull);
      expect(model.masterName, isNull);
    });

    test('fromJson toJson roundtrip remains consistent', () {
      final model = GetDesignationListModel.fromJson(sampleJson);
      final roundTrip = GetDesignationListModel.fromJson(model.toJson());

      expect(roundTrip.designationId, model.designationId);
      expect(roundTrip.categoryName, model.categoryName);
      expect(roundTrip.masterName, model.masterName);
    });
  });
}

