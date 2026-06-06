import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ReceiptRegulatorScreen/GetItemMasterListRegulatorListModel.dart';

void main() {
  group('GetItemMasterListRegulatorListModel', () {
    final sampleJson = {
      'ItemId': 6,
      'DistributorId': 8118,
      'ItemName': 'SC REGULATOR',
      'ItemTypeFilter': 'Regulator',
      'ItemType': 'R',
      'ItemDescription': 'DOM REGULATOR',
      'Action': null,
      'AddedBy': 0,
      'IsActive': 1,
      'LastUpdatedOn': '2025-01-23T16:08:17.04',
      'ItemSubType': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetItemMasterListRegulatorListModel(
        itemId: 6,
        distributorId: 8118,
        itemName: 'SC REGULATOR',
        itemTypeFilter: 'Regulator',
        itemType: 'R',
        itemDescription: 'DOM REGULATOR',
        addedBy: 0,
        isActive: 1,
        lastUpdatedOn: '2025-01-23T16:08:17.04',
      );

      expect(model.itemId, 6);
      expect(model.distributorId, 8118);
      expect(model.itemName, 'SC REGULATOR');
      expect(model.itemTypeFilter, 'Regulator');
      expect(model.itemType, 'R');
      expect(model.itemDescription, 'DOM REGULATOR');
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
      expect(model.lastUpdatedOn, '2025-01-23T16:08:17.04');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetItemMasterListRegulatorListModel.fromJson(sampleJson);

      expect(model.itemId, 6);
      expect(model.distributorId, 8118);
      expect(model.itemName, 'SC REGULATOR');
      expect(model.itemTypeFilter, 'Regulator');
      expect(model.itemType, 'R');
      expect(model.itemDescription, 'DOM REGULATOR');
      expect(model.action, isNull);
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
      expect(model.lastUpdatedOn, '2025-01-23T16:08:17.04');
      expect(model.itemSubType, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetItemMasterListRegulatorListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['ItemId'], 6);
      expect(json['DistributorId'], 8118);
      expect(json['ItemName'], 'SC REGULATOR');
      expect(json['ItemTypeFilter'], 'Regulator');
      expect(json['ItemType'], 'R');
      expect(json['ItemDescription'], 'DOM REGULATOR');
      expect(json['Action'], isNull);
      expect(json['ItemSubType'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetItemMasterListRegulatorListModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: 'NEW REGULATOR', isActive: 0);

      expect(updated.itemName, 'NEW REGULATOR');
      expect(updated.isActive, 0);
      expect(model.itemName, 'SC REGULATOR');
      expect(model.isActive, 1);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetItemMasterListRegulatorListModel.fromJson(sampleJson);
      final updated = model.copyWith(itemType: 'D');

      expect(updated.itemId, model.itemId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.itemDescription, model.itemDescription);
    });

    test('constructor with null values', () {
      final model = GetItemMasterListRegulatorListModel();
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.itemType, isNull);
    });
  });
}

