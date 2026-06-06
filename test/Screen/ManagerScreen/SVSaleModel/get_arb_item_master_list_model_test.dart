import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetARBItemMasterListModel.dart';

void main() {
  group('GetArbItemMasterListModel', () {
    final sampleJson = {
      'ItemId': 150,
      'DistributorId': 8118,
      'CategoryId': 5,
      'CategoryName': 'Other',
      'ItemCode': '19',
      'ItemName': 'NAME CHANGE',
      'Rate': 500.0,
      'Action': null,
      'AddedBy': 0,
      'ActiveStatus': 1,
      'LastUpdatedOn': '2025-04-01T18:23:30.503',
    };

    test('constructor sets all fields correctly', () {
      final model = GetArbItemMasterListModel(
        itemId: 150,
        distributorId: 8118,
        categoryId: 5,
        categoryName: 'Other',
        itemCode: '19',
        itemName: 'NAME CHANGE',
        rate: 500.0,
        addedBy: 0,
        activeStatus: 1,
        lastUpdatedOn: '2025-04-01T18:23:30.503',
      );

      expect(model.itemId, 150);
      expect(model.distributorId, 8118);
      expect(model.categoryId, 5);
      expect(model.categoryName, 'Other');
      expect(model.itemCode, '19');
      expect(model.itemName, 'NAME CHANGE');
      expect(model.rate, 500.0);
      expect(model.addedBy, 0);
      expect(model.activeStatus, 1);
      expect(model.lastUpdatedOn, '2025-04-01T18:23:30.503');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetArbItemMasterListModel.fromJson(sampleJson);

      expect(model.itemId, 150);
      expect(model.distributorId, 8118);
      expect(model.categoryId, 5);
      expect(model.categoryName, 'Other');
      expect(model.itemCode, '19');
      expect(model.itemName, 'NAME CHANGE');
      expect(model.rate, 500.0);
      expect(model.action, isNull);
      expect(model.addedBy, 0);
      expect(model.activeStatus, 1);
      expect(model.lastUpdatedOn, '2025-04-01T18:23:30.503');
    });

    test('toJson returns correct map', () {
      final model = GetArbItemMasterListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['ItemId'], 150);
      expect(json['DistributorId'], 8118);
      expect(json['CategoryId'], 5);
      expect(json['CategoryName'], 'Other');
      expect(json['ItemCode'], '19');
      expect(json['ItemName'], 'NAME CHANGE');
      expect(json['Rate'], 500.0);
      expect(json['Action'], isNull);
      expect(json['AddedBy'], 0);
      expect(json['ActiveStatus'], 1);
      expect(json['LastUpdatedOn'], '2025-04-01T18:23:30.503');
    });

    test('copyWith returns new instance with updated fields', () {
      final model = GetArbItemMasterListModel.fromJson(sampleJson);
      final updated = model.copyWith(itemName: 'Updated Item', rate: 750.0);

      expect(updated.itemName, 'Updated Item');
      expect(updated.rate, 750.0);
      expect(model.itemName, 'NAME CHANGE');
      expect(model.rate, 500.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetArbItemMasterListModel.fromJson(sampleJson);
      final updated = model.copyWith(rate: 600.0);

      expect(updated.itemId, model.itemId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.categoryName, model.categoryName);
    });

    test('constructor with null values', () {
      final model = GetArbItemMasterListModel();
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.rate, isNull);
    });
  });
}

