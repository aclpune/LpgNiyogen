import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/GetDefectiveStockListModel.dart';

void main() {
  group('GetDefectiveStockListModel', () {

    // ─── Sample valid JSON ───────────────────────────────────────────────
    final validJson = {
      'DefId': 8,
      'DistributorId': 8118,
      'DefDate': '2025-03-20T12:45:00',
      'ItemId': 1,
      'DefQty': 2,
      'Remark': 'Test Defective',
      'Action': null,
      'ItemName': '14.2 kg',
      'AddedBy': 0,
      'GodownId': 1,
    };

    // ════════════════════════════════════════════════════════════════════
    // POSITIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Positive Tests', () {

      test('fromJson parses all fields correctly', () {
        final model = GetDefectiveStockListModel.fromJson(validJson);

        expect(model.defId, equals(8));
        expect(model.distributorId, equals(8118));
        expect(model.defDate, equals('2025-03-20T12:45:00'));
        expect(model.itemId, equals(1));
        expect(model.defQty, equals(2));
        expect(model.remark, equals('Test Defective'));
        expect(model.action, isNull);
        expect(model.itemName, equals('14.2 kg'));
        expect(model.addedBy, equals(0));
        expect(model.godownId, equals(1));
      });

      test('constructor creates model with all provided fields', () {
        final model = GetDefectiveStockListModel(
          defId: 8,
          distributorId: 8118,
          defDate: '2025-03-20T12:45:00',
          itemId: 1,
          defQty: 2,
          remark: 'Test Defective',
          action: null,
          itemName: '14.2 kg',
          addedBy: 0,
          godownId: 1,
        );

        expect(model.defId, equals(8));
        expect(model.itemName, equals('14.2 kg'));
        expect(model.defQty, equals(2));
      });

      test('toJson produces correct map with all 10 keys', () {
        final model = GetDefectiveStockListModel.fromJson(validJson);
        final json = model.toJson();

        expect(json.keys.length, equals(10));
        expect(json['DefId'], equals(8));
        expect(json['DistributorId'], equals(8118));
        expect(json['DefDate'], equals('2025-03-20T12:45:00'));
        expect(json['ItemId'], equals(1));
        expect(json['DefQty'], equals(2));
        expect(json['Remark'], equals('Test Defective'));
        expect(json['Action'], isNull);
        expect(json['ItemName'], equals('14.2 kg'));
        expect(json['AddedBy'], equals(0));
        expect(json['GodownId'], equals(1));
      });

      test('copyWith updates only specified fields', () {
        final original = GetDefectiveStockListModel.fromJson(validJson);
        final updated = original.copyWith(
          defQty: 10,
          remark: 'Updated Remark',
          godownId: 5,
        );

        expect(updated.defQty, equals(10));
        expect(updated.remark, equals('Updated Remark'));
        expect(updated.godownId, equals(5));
        // unchanged
        expect(updated.defId, equals(8));
        expect(updated.distributorId, equals(8118));
        expect(updated.itemName, equals('14.2 kg'));
      });

      test('copyWith with no arguments returns equivalent object', () {
        final original = GetDefectiveStockListModel.fromJson(validJson);
        final copy = original.copyWith();

        expect(copy.defId, equals(original.defId));
        expect(copy.defQty, equals(original.defQty));
        expect(copy.itemName, equals(original.itemName));
      });

      test('fromJson then toJson round-trip preserves values', () {
        final model = GetDefectiveStockListModel.fromJson(validJson);
        final json = model.toJson();

        expect(json['DefId'], equals(validJson['DefId']));
        expect(json['DefQty'], equals(validJson['DefQty']));
        expect(json['Remark'], equals(validJson['Remark']));
        expect(json['Action'], equals(validJson['Action']));
      });

      test('default constructor creates model with all null fields', () {
        final model = GetDefectiveStockListModel();
        expect(model.defId, isNull);
        expect(model.distributorId, isNull);
        expect(model.defDate, isNull);
        expect(model.itemId, isNull);
        expect(model.defQty, isNull);
        expect(model.remark, isNull);
        expect(model.action, isNull);
        expect(model.itemName, isNull);
        expect(model.addedBy, isNull);
        expect(model.godownId, isNull);
      });

      test('fromJson handles action as non-null string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['Action'] = 'REPAIR';

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.action, equals('REPAIR'));
      });

      test('fromJson handles large defQty', () {
        final json = Map<String, dynamic>.from(validJson);
        json['DefQty'] = 5000;

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.defQty, equals(5000));
      });

      test('fromJson handles different godownId values', () {
        final json = Map<String, dynamic>.from(validJson);
        json['GodownId'] = 99;

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.godownId, equals(99));
      });

      test('copyWith can set action from null to non-null', () {
        final original = GetDefectiveStockListModel.fromJson(validJson);
        final updated = original.copyWith(action: 'SCRAP');

        expect(updated.action, equals('SCRAP'));
        expect(original.action, isNull);
      });
    });

    // ════════════════════════════════════════════════════════════════════
    // NEGATIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Negative Tests', () {

      test('fromJson with all null values does not throw', () {
        final nullJson = {
          'DefId': null, 'DistributorId': null, 'DefDate': null,
          'ItemId': null, 'DefQty': null, 'Remark': null,
          'Action': null, 'ItemName': null, 'AddedBy': null, 'GodownId': null,
        };

        expect(
                () => GetDefectiveStockListModel.fromJson(nullJson), returnsNormally);
        final model = GetDefectiveStockListModel.fromJson(nullJson);
        expect(model.defId, isNull);
        expect(model.defQty, isNull);
      });

      test('fromJson with empty map results in all null fields', () {
        final model = GetDefectiveStockListModel.fromJson({});
        expect(model.defId, isNull);
        expect(model.itemName, isNull);
        expect(model.godownId, isNull);
      });

      test('toJson includes null values when fields are null', () {
        final model = GetDefectiveStockListModel();
        final json = model.toJson();

        expect(json['DefId'], isNull);
        expect(json['DefQty'], isNull);
        expect(json['Action'], isNull);
      });

      test('copyWith does not mutate original instance', () {
        final original = GetDefectiveStockListModel.fromJson(validJson);
        original.copyWith(defQty: 999, remark: 'Mutated');

        expect(original.defQty, equals(2));
        expect(original.remark, equals('Test Defective'));
      });

      test('fromJson with negative defQty stores value as-is', () {
        final json = Map<String, dynamic>.from(validJson);
        json['DefQty'] = -3;

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.defQty, equals(-3));
      });

      test('fromJson with zero defQty', () {
        final json = Map<String, dynamic>.from(validJson);
        json['DefQty'] = 0;

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.defQty, equals(0));
      });

      test('fromJson with empty remark string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['Remark'] = '';

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.remark, equals(''));
      });

      test('fromJson with invalid defDate string does not throw', () {
        final json = Map<String, dynamic>.from(validJson);
        json['DefDate'] = 'bad-date-value';

        expect(
                () => GetDefectiveStockListModel.fromJson(json), returnsNormally);
        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.defDate, equals('bad-date-value'));
      });

      test('fromJson with string DefId stores as-is', () {
        final json = Map<String, dynamic>.from(validJson);
        json['DefId'] = '8'; // string instead of number

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.defId, equals('8'));
      });

      test('fromJson with decimal defQty stores as num', () {
        final json = Map<String, dynamic>.from(validJson);
        json['DefQty'] = 1.5;

        final model = GetDefectiveStockListModel.fromJson(json);
        expect(model.defQty, equals(1.5));
      });
    });
  });
}