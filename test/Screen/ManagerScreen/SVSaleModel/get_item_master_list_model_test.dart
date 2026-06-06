import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetItemMasterListModel.dart';

void main() {
  group('GetItemMasterListModel', () {
    final sampleJson = {
      'ItemId': 5,
      'DistributorId': 8118,
      'ItemName': '2 KG FTL',
      'ItemTypeFilter': 'Cylinder',
      'ItemType': 'C',
      'ItemDescription': '2 KG ND CYL',
      'Action': null,
      'AddedBy': 0,
      'IsActive': 1,
      'LastUpdatedOn': '2025-04-16T14:17:23.607',
      'ItemSubType': 'ND',
    };

    test('constructor sets all fields correctly', () {
      final model = GetItemMasterListModel(
        itemId: 5,
        distributorId: 8118,
        itemName: '2 KG FTL',
        itemTypeFilter: 'Cylinder',
        itemType: 'C',
        itemDescription: '2 KG ND CYL',
        addedBy: 0,
        isActive: 1,
        lastUpdatedOn: '2025-04-16T14:17:23.607',
        itemSubType: 'ND',
      );

      expect(model.itemId, 5);
      expect(model.distributorId, 8118);
      expect(model.itemName, '2 KG FTL');
      expect(model.itemTypeFilter, 'Cylinder');
      expect(model.itemType, 'C');
      expect(model.itemDescription, '2 KG ND CYL');
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
      expect(model.lastUpdatedOn, '2025-04-16T14:17:23.607');
      expect(model.itemSubType, 'ND');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetItemMasterListModel.fromJson(sampleJson);

      expect(model.itemId, 5);
      expect(model.distributorId, 8118);
      expect(model.itemName, '2 KG FTL');
      expect(model.itemTypeFilter, 'Cylinder');
      expect(model.itemType, 'C');
      expect(model.itemDescription, '2 KG ND CYL');
      expect(model.action, isNull);
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
      expect(model.lastUpdatedOn, '2025-04-16T14:17:23.607');
      expect(model.itemSubType, 'ND');
    });

    test('toJson returns correct map', () {
      final model = GetItemMasterListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['ItemId'], 5);
      expect(json['DistributorId'], 8118);
      expect(json['ItemName'], '2 KG FTL');
      expect(json['ItemTypeFilter'], 'Cylinder');
      expect(json['ItemType'], 'C');
      expect(json['ItemDescription'], '2 KG ND CYL');
      expect(json['Action'], isNull);
      expect(json['AddedBy'], 0);
      expect(json['IsActive'], 1);
      expect(json['LastUpdatedOn'], '2025-04-16T14:17:23.607');
      expect(json['ItemSubType'], 'ND');
    });

    test('copyWith updates specified fields', () {
      final model = GetItemMasterListModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: 'Updated Item', isActive: 0);

      expect(updated.itemName, 'Updated Item');
      expect(updated.isActive, 0);
      expect(model.itemName, '2 KG FTL');
      expect(model.isActive, 1);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetItemMasterListModel.fromJson(sampleJson);
      final updated = model.copyWith(itemSubType: 'SC');

      expect(updated.itemId, model.itemId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.itemType, model.itemType);
    });

    test('constructor with null values', () {
      final model = GetItemMasterListModel();
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.itemType, isNull);
    });
  });
}

