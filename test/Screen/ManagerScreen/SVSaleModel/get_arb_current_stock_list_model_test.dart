import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetArbCurrentStockListModel.dart';

void main() {
  group('GetArbCurrentStockListModel', () {
    final sampleJson = {
      'CategoryId': 7,
      'ItemId': 16,
      'DistributorId': 0,
      'CategoryName': 'Non ARB Item',
      'ItemName': 'Installation charges',
      'CurrentStk': 99839,
    };

    test('constructor sets all fields correctly', () {
      final model = GetArbCurrentStockListModel(
        categoryId: 7,
        itemId: 16,
        distributorId: 0,
        categoryName: 'Non ARB Item',
        itemName: 'Installation charges',
        currentStk: 99839,
      );

      expect(model.categoryId, 7);
      expect(model.itemId, 16);
      expect(model.distributorId, 0);
      expect(model.categoryName, 'Non ARB Item');
      expect(model.itemName, 'Installation charges');
      expect(model.currentStk, 99839);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetArbCurrentStockListModel.fromJson(sampleJson);

      expect(model.categoryId, 7);
      expect(model.itemId, 16);
      expect(model.distributorId, 0);
      expect(model.categoryName, 'Non ARB Item');
      expect(model.itemName, 'Installation charges');
      expect(model.currentStk, 99839);
    });

    test('fromJson handles null CurrentStk by returning 0', () {
      final json = Map<String, dynamic>.from(sampleJson);
      json['CurrentStk'] = null;
      final model = GetArbCurrentStockListModel.fromJson(json);
      expect(model.currentStk, 0);
    });

    test('fromJson handles empty string CurrentStk by returning 0', () {
      final json = Map<String, dynamic>.from(sampleJson);
      json['CurrentStk'] = '';
      final model = GetArbCurrentStockListModel.fromJson(json);
      expect(model.currentStk, 0);
    });

    test('fromJson handles string numeric CurrentStk', () {
      final json = Map<String, dynamic>.from(sampleJson);
      json['CurrentStk'] = '150';
      final model = GetArbCurrentStockListModel.fromJson(json);
      expect(model.currentStk, 150);
    });

    test('toJson returns correct map', () {
      final model = GetArbCurrentStockListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['CategoryId'], 7);
      expect(json['ItemId'], 16);
      expect(json['DistributorId'], 0);
      expect(json['CategoryName'], 'Non ARB Item');
      expect(json['ItemName'], 'Installation charges');
      expect(json['CurrentStk'], 99839);
    });

    test('copyWith returns new instance with updated fields', () {
      final model = GetArbCurrentStockListModel.fromJson(sampleJson);
      final updated = model.copyWith(currentStk: 500, itemName: 'New Item');

      expect(updated.currentStk, 500);
      expect(updated.itemName, 'New Item');
      expect(model.currentStk, 99839);
      expect(model.itemName, 'Installation charges');
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetArbCurrentStockListModel.fromJson(sampleJson);
      final updated = model.copyWith(currentStk: 100);

      expect(updated.categoryId, model.categoryId);
      expect(updated.itemId, model.itemId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.categoryName, model.categoryName);
    });

    test('constructor with null values returns null fields', () {
      final model = GetArbCurrentStockListModel();
      expect(model.categoryId, isNull);
      expect(model.itemId, isNull);
      expect(model.categoryName, isNull);
      expect(model.itemName, isNull);
      expect(model.currentStk, isNull);
    });
  });
}

