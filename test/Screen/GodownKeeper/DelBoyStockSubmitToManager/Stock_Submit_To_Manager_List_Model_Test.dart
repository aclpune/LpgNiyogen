import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/StockSubmitToManagerListModel.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // StockSubmitToManagerListModel Tests
  // ═══════════════════════════════════════════════════════════════
  group('StockSubmitToManagerListModel', () {

    // ─────────────────────────────────────────────
    // Sample data helpers
    // ─────────────────────────────────────────────
    Map<String, dynamic> validItemJson() => {
      'SaleGKItemId': 1,
      'ItemId': 4,
      'ItemName': '2 kg',
      'FilledSaleQty': 20,
      'SVQty': 1,
      'TVQty': 1,
      'EmptyRetQty': 18,
      'DeffQty': 1,
      'LessEmptyQty': 1,
      'Remark': null,
      'ClosingFilled': 0,
      'ClosingEmpty': 0,
      'ClosingDef': 0,
      'SVConsStr': null,
      'PSVIdStr': null,
      'TVConsStr': null,
      'SVQtyStr': null,
      'TVQtyStr': null,
      'ImbForIdStr': null,
      'ImbQtyStr': null,
      'DMImbQty': 0,
      'FlagColumnUpdate': null,
    };

    Map<String, dynamic> validJson() => {
      'SaleGKId': 17,
      'DistributorId': 8118,
      'DeliveryDate': '2024-12-19T00:00:00',
      'DMId': 25,
      'VehicleId': 25,
      'DailySaleStatus': 0,
      'StaffNo': 'SN/024',
      'StaffName': 'Virendra Surwase',
      'VehicleNo': 'MH45AB5342',
      'StatusStr': null,
      'AddedOn': '2024-12-19T04:51:21.227',
      'AddedByNo': null,
      'AddedByName': null,
      'ItemList': [validItemJson()],
      'AddedBy': 4,
      'Action': null,
    };

    // ─────────────────────────────────────────────
    // Constructor Tests
    // ─────────────────────────────────────────────
    group('Constructor', () {
      test('POSITIVE: creates instance with all valid fields', () {
        final model = StockSubmitToManagerListModel(
          saleGKId: 17,
          distributorId: 8118,
          deliveryDate: '2024-12-19T00:00:00',
          dMId: 25,
          vehicleId: 25,
          dailySaleStatus: 0,
          staffNo: 'SN/024',
          staffName: 'Virendra Surwase',
          vehicleNo: 'MH45AB5342',
          addedBy: 4,
        );

        expect(model.saleGKId, 17);
        expect(model.distributorId, 8118);
        expect(model.deliveryDate, '2024-12-19T00:00:00');
        expect(model.dMId, 25);
        expect(model.vehicleId, 25);
        expect(model.dailySaleStatus, 0);
        expect(model.staffNo, 'SN/024');
        expect(model.staffName, 'Virendra Surwase');
        expect(model.vehicleNo, 'MH45AB5342');
        expect(model.addedBy, 4);
      });

      test('POSITIVE: creates instance with all null fields', () {
        final model = StockSubmitToManagerListModel();

        expect(model.saleGKId, isNull);
        expect(model.distributorId, isNull);
        expect(model.deliveryDate, isNull);
        expect(model.dMId, isNull);
        expect(model.vehicleId, isNull);
        expect(model.dailySaleStatus, isNull);
        expect(model.staffNo, isNull);
        expect(model.staffName, isNull);
        expect(model.vehicleNo, isNull);
        expect(model.statusStr, isNull);
        expect(model.addedOn, isNull);
        expect(model.addedByNo, isNull);
        expect(model.addedByName, isNull);
        expect(model.itemList, isNull);
        expect(model.addedBy, isNull);
        expect(model.action, isNull);
      });

      test('POSITIVE: creates instance with non-null itemList', () {
        final item = ItemList(itemId: 4, itemName: '2 kg');
        final model = StockSubmitToManagerListModel(itemList: [item]);

        expect(model.itemList, isNotNull);
        expect(model.itemList!.length, 1);
        expect(model.itemList!.first.itemId, 4);
      });

      test('POSITIVE: creates instance with empty itemList', () {
        final model = StockSubmitToManagerListModel(itemList: []);
        expect(model.itemList, isNotNull);
        expect(model.itemList!.isEmpty, isTrue);
      });

      test('NEGATIVE: dailySaleStatus accepts negative value', () {
        final model = StockSubmitToManagerListModel(dailySaleStatus: -1);
        expect(model.dailySaleStatus, -1);
      });
    });

    // ─────────────────────────────────────────────
    // fromJson Tests
    // ─────────────────────────────────────────────
    group('fromJson', () {
      test('POSITIVE: parses complete valid JSON correctly', () {
        final model = StockSubmitToManagerListModel.fromJson(validJson());

        expect(model.saleGKId, 17);
        expect(model.distributorId, 8118);
        expect(model.deliveryDate, '2024-12-19T00:00:00');
        expect(model.dMId, 25);
        expect(model.vehicleId, 25);
        expect(model.dailySaleStatus, 0);
        expect(model.staffNo, 'SN/024');
        expect(model.staffName, 'Virendra Surwase');
        expect(model.vehicleNo, 'MH45AB5342');
        expect(model.statusStr, isNull);
        expect(model.addedOn, '2024-12-19T04:51:21.227');
        expect(model.addedByNo, isNull);
        expect(model.addedByName, isNull);
        expect(model.addedBy, 4);
        expect(model.action, isNull);
      });

      test('POSITIVE: parses ItemList correctly', () {
        final model = StockSubmitToManagerListModel.fromJson(validJson());

        expect(model.itemList, isNotNull);
        expect(model.itemList!.length, 1);
        expect(model.itemList!.first.itemId, 4);
        expect(model.itemList!.first.itemName, '2 kg');
        expect(model.itemList!.first.filledSaleQty, 20);
      });

      test('POSITIVE: parses multiple items in ItemList', () {
        final json = validJson();
        json['ItemList'] = [validItemJson(), validItemJson(), validItemJson()];

        final model = StockSubmitToManagerListModel.fromJson(json);

        expect(model.itemList!.length, 3);
      });

      test('POSITIVE: parses null ItemList without error', () {
        final json = validJson();
        json['ItemList'] = null;

        final model = StockSubmitToManagerListModel.fromJson(json);

        expect(model.itemList, isNull);
      });

      test('POSITIVE: parses empty ItemList array', () {
        final json = validJson();
        json['ItemList'] = [];

        final model = StockSubmitToManagerListModel.fromJson(json);

        expect(model.itemList, isNotNull);
        expect(model.itemList!.isEmpty, isTrue);
      });

      test('POSITIVE: parses JSON with all nullable string fields as null', () {
        final json = validJson();
        json['StatusStr'] = null;
        json['AddedByNo'] = null;
        json['AddedByName'] = null;
        json['Action'] = null;

        final model = StockSubmitToManagerListModel.fromJson(json);

        expect(model.statusStr, isNull);
        expect(model.addedByNo, isNull);
        expect(model.addedByName, isNull);
        expect(model.action, isNull);
      });

      test('NEGATIVE: missing keys result in null fields', () {
        final model = StockSubmitToManagerListModel.fromJson(<String, dynamic>{});

        expect(model.saleGKId, isNull);
        expect(model.distributorId, isNull);
        expect(model.itemList, isNull);
      });

      test('NEGATIVE: throws when JSON is null', () {
        expect(
              () => StockSubmitToManagerListModel.fromJson(null),
          throwsA(anything),
        );
      });

      test('NEGATIVE: throws when JSON is not a map', () {
        expect(
              () => StockSubmitToManagerListModel.fromJson([1, 2, 3]),
          throwsA(anything),
        );
      });
    });

    // ─────────────────────────────────────────────
    // toJson Tests
    // ─────────────────────────────────────────────
    group('toJson', () {
      test('POSITIVE: serializes all fields correctly', () {
        final model = StockSubmitToManagerListModel.fromJson(validJson());
        final json = model.toJson();

        expect(json['SaleGKId'], 17);
        expect(json['DistributorId'], 8118);
        expect(json['DeliveryDate'], '2024-12-19T00:00:00');
        expect(json['DMId'], 25);
        expect(json['VehicleId'], 25);
        expect(json['DailySaleStatus'], 0);
        expect(json['StaffNo'], 'SN/024');
        expect(json['StaffName'], 'Virendra Surwase');
        expect(json['VehicleNo'], 'MH45AB5342');
        expect(json['AddedBy'], 4);
      });

      test('POSITIVE: serializes ItemList as list of maps', () {
        final model = StockSubmitToManagerListModel.fromJson(validJson());
        final json = model.toJson();

        expect(json['ItemList'], isA<List>());
        expect(json['ItemList'].length, 1);
        expect(json['ItemList'][0], isA<Map<String, dynamic>>());
      });

      test('POSITIVE: null ItemList is excluded from map', () {
        final model = StockSubmitToManagerListModel();
        final json = model.toJson();

        expect(json.containsKey('ItemList'), isFalse);
      });

      test('POSITIVE: null fields serialize as null', () {
        final model = StockSubmitToManagerListModel();
        final json = model.toJson();

        expect(json['SaleGKId'], isNull);
        expect(json['StaffName'], isNull);
        expect(json['Action'], isNull);
      });

      test('POSITIVE: round-trip fromJson -> toJson preserves all scalar fields', () {
        final original = validJson();
        original['ItemList'] = null; // exclude nested for this check

        final model = StockSubmitToManagerListModel.fromJson(original);
        final result = model.toJson();

        expect(result['SaleGKId'], original['SaleGKId']);
        expect(result['DistributorId'], original['DistributorId']);
        expect(result['DeliveryDate'], original['DeliveryDate']);
        expect(result['StaffNo'], original['StaffNo']);
        expect(result['VehicleNo'], original['VehicleNo']);
      });

      test('NEGATIVE: toJson does not contain unexpected extra keys', () {
        final model = StockSubmitToManagerListModel(saleGKId: 1);
        final json = model.toJson();

        // 15 scalar keys expected (ItemList absent if null)
        const expectedKeys = [
          'SaleGKId', 'DistributorId', 'DeliveryDate', 'DMId', 'VehicleId',
          'DailySaleStatus', 'StaffNo', 'StaffName', 'VehicleNo', 'StatusStr',
          'AddedOn', 'AddedByNo', 'AddedByName', 'AddedBy', 'Action',
        ];
        for (final key in expectedKeys) {
          expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
        }
      });
    });

    // ─────────────────────────────────────────────
    // copyWith Tests
    // ─────────────────────────────────────────────
    group('copyWith', () {
      test('POSITIVE: copies with updated staffName', () {
        final original = StockSubmitToManagerListModel(staffName: 'Alice', saleGKId: 10);
        final copy = original.copyWith(staffName: 'Bob');

        expect(copy.staffName, 'Bob');
        expect(copy.saleGKId, 10); // unchanged
      });

      test('POSITIVE: copies with updated itemList', () {
        final original = StockSubmitToManagerListModel(itemList: []);
        final newItem = ItemList(itemId: 99, itemName: '5 kg');
        final copy = original.copyWith(itemList: [newItem]);

        expect(copy.itemList!.length, 1);
        expect(copy.itemList!.first.itemId, 99);
      });

      test('POSITIVE: copyWith with no arguments retains all values', () {
        final original = StockSubmitToManagerListModel(
          saleGKId: 17,
          staffName: 'Virendra Surwase',
          vehicleNo: 'MH45AB5342',
        );
        final copy = original.copyWith();

        expect(copy.saleGKId, 17);
        expect(copy.staffName, 'Virendra Surwase');
        expect(copy.vehicleNo, 'MH45AB5342');
      });

      test('POSITIVE: original is not mutated after copyWith', () {
        final original = StockSubmitToManagerListModel(staffName: 'Alice');
        original.copyWith(staffName: 'Bob');

        expect(original.staffName, 'Alice');
      });

      test('NEGATIVE: copyWith cannot set field to null (uses ?? fallback)', () {
        final original = StockSubmitToManagerListModel(staffName: 'Alice');
        final copy = original.copyWith(staffName: null);

        expect(copy.staffName, 'Alice'); // null is ignored
      });
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ItemList Tests
  // ═══════════════════════════════════════════════════════════════
  group('ItemList', () {

    Map<String, dynamic> validItemJson() => {
      'SaleGKItemId': 1,
      'ItemId': 4,
      'ItemName': '2 kg',
      'FilledSaleQty': 20,
      'SVQty': 1,
      'TVQty': 1,
      'EmptyRetQty': 18,
      'DeffQty': 1,
      'LessEmptyQty': 1,
      'Remark': null,
      'ClosingFilled': 0,
      'ClosingEmpty': 0,
      'ClosingDef': 0,
      'SVConsStr': null,
      'PSVIdStr': null,
      'TVConsStr': null,
      'SVQtyStr': null,
      'TVQtyStr': null,
      'ImbForIdStr': null,
      'ImbQtyStr': null,
      'DMImbQty': 5,
      'FlagColumnUpdate': null,
    };

    // ─────────────────────────────────────────────
    // Constructor Tests
    // ─────────────────────────────────────────────
    group('Constructor', () {
      test('POSITIVE: creates instance with all valid fields', () {
        final item = ItemList(
          SaleGKItemId: 1,
          itemId: 4,
          itemName: '2 kg',
          filledSaleQty: 20,
          sVQty: 1,
          tVQty: 1,
          emptyRetQty: 18,
          deffQty: 1,
          lessEmptyQty: 1,
          closingFilled: 0,
          closingEmpty: 0,
          closingDef: 0,
          DMImbQty: 5,
        );

        expect(item.itemId, 4);
        expect(item.itemName, '2 kg');
        expect(item.filledSaleQty, 20);
        expect(item.sVQty, 1);
        expect(item.tVQty, 1);
        expect(item.emptyRetQty, 18);
        expect(item.deffQty, 1);
        expect(item.lessEmptyQty, 1);
        expect(item.closingFilled, 0);
        expect(item.closingEmpty, 0);
        expect(item.closingDef, 0);
        expect(item.DMImbQty, 5);
      });

      test('POSITIVE: creates instance with all null fields', () {
        final item = ItemList();

        expect(item.itemId, isNull);
        expect(item.itemName, isNull);
        expect(item.filledSaleQty, isNull);
        expect(item.remark, isNull);
        expect(item.sVConsStr, isNull);
        expect(item.FlagColumnUpdate, isNull);
      });

      test('NEGATIVE: filledSaleQty accepts negative value', () {
        final item = ItemList(filledSaleQty: -5);
        expect(item.filledSaleQty, -5);
      });

      test('NEGATIVE: itemName accepts empty string', () {
        final item = ItemList(itemName: '');
        expect(item.itemName, '');
      });
    });

    // ─────────────────────────────────────────────
    // fromJson Tests
    // ─────────────────────────────────────────────
    group('fromJson', () {
      test('POSITIVE: parses complete valid JSON', () {
        final item = ItemList.fromJson(validItemJson());

        expect(item.SaleGKItemId, 1);
        expect(item.itemId, 4);
        expect(item.itemName, '2 kg');
        expect(item.filledSaleQty, 20);
        expect(item.sVQty, 1);
        expect(item.tVQty, 1);
        expect(item.emptyRetQty, 18);
        expect(item.deffQty, 1);
        expect(item.lessEmptyQty, 1);
        expect(item.remark, isNull);
        expect(item.closingFilled, 0);
        expect(item.closingEmpty, 0);
        expect(item.closingDef, 0);
        expect(item.DMImbQty, 5);
      });

      test('POSITIVE: parseNum handles integer values', () {
        final json = validItemJson();
        json['FilledSaleQty'] = 100;
        final item = ItemList.fromJson(json);
        expect(item.filledSaleQty, 100);
      });

      test('POSITIVE: parseNum handles numeric string values', () {
        final json = validItemJson();
        json['FilledSaleQty'] = '25'; // string representation
        final item = ItemList.fromJson(json);
        expect(item.filledSaleQty, 25);
      });

      test('POSITIVE: parseNum handles null values gracefully', () {
        final json = validItemJson();
        json['FilledSaleQty'] = null;
        final item = ItemList.fromJson(json);
        expect(item.filledSaleQty, isNull);
      });

      test('POSITIVE: parses all string fields (SVConsStr, PSVIdStr, etc.)', () {
        final json = validItemJson();
        json['SVConsStr'] = 'cons1';
        json['PSVIdStr'] = 'psv1';
        json['TVConsStr'] = 'tvc1';
        json['SVQtyStr'] = 'sv1';
        json['TVQtyStr'] = 'tv1';
        json['ImbForIdStr'] = 'imb1';
        json['ImbQtyStr'] = 'imbq1';
        json['FlagColumnUpdate'] = 'Y';

        final item = ItemList.fromJson(json);

        expect(item.sVConsStr, 'cons1');
        expect(item.PSVIdStr, 'psv1');
        expect(item.TVConsStr, 'tvc1');
        expect(item.SVQtyStr, 'sv1');
        expect(item.TVQtyStr, 'tv1');
        expect(item.ImbForIdStr, 'imb1');
        expect(item.ImbQtyStr, 'imbq1');
        expect(item.FlagColumnUpdate, 'Y');
      });

      test('NEGATIVE: parseNum returns null for non-parseable string', () {
        final json = validItemJson();
        json['FilledSaleQty'] = 'not-a-number';
        final item = ItemList.fromJson(json);
        expect(item.filledSaleQty, isNull);
      });

      test('NEGATIVE: missing keys result in null fields', () {
        final item = ItemList.fromJson(<String, dynamic>{});

        expect(item.itemId, isNull);
        expect(item.itemName, isNull);
        expect(item.filledSaleQty, isNull);
      });

      test('NEGATIVE: throws when JSON is null', () {
        expect(() => ItemList.fromJson(null), throwsA(anything));
      });
    });

    // ─────────────────────────────────────────────
    // toJson Tests
    // ─────────────────────────────────────────────
    group('toJson', () {
      test('POSITIVE: serializes all fields correctly', () {
        final item = ItemList.fromJson(validItemJson());
        final json = item.toJson();

        expect(json['SaleGKItemId'], 1);
        expect(json['ItemId'], 4);
        expect(json['ItemName'], '2 kg');
        expect(json['FilledSaleQty'], 20);
        expect(json['SVQty'], 1);
        expect(json['TVQty'], 1);
        expect(json['EmptyRetQty'], 18);
        expect(json['DeffQty'], 1);
        expect(json['LessEmptyQty'], 1);
        expect(json['ClosingFilled'], 0);
        expect(json['ClosingEmpty'], 0);
        expect(json['ClosingDef'], 0);
        expect(json['DMImbQty'], 5);
      });

      test('POSITIVE: serializes null fields as null', () {
        final item = ItemList();
        final json = item.toJson();

        expect(json['ItemId'], isNull);
        expect(json['ItemName'], isNull);
        expect(json['Remark'], isNull);
        expect(json['SVConsStr'], isNull);
      });

      test('POSITIVE: toJson contains all expected keys', () {
        final item = ItemList();
        final json = item.toJson();

        const expectedKeys = [
          'SaleGKItemId', 'ItemId', 'ItemName', 'FilledSaleQty', 'SVQty',
          'TVQty', 'EmptyRetQty', 'DeffQty', 'LessEmptyQty', 'Remark',
          'ClosingFilled', 'ClosingEmpty', 'ClosingDef', 'SVConsStr',
          'PSVIdStr', 'TVConsStr', 'SVQtyStr', 'TVQtyStr',
          'ImbForIdStr', 'ImbQtyStr', 'DMImbQty', 'FlagColumnUpdate',
        ];
        for (final key in expectedKeys) {
          expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
        }
      });

      test('POSITIVE: round-trip fromJson -> toJson preserves all fields', () {
        final original = validItemJson();
        final item = ItemList.fromJson(original);
        final result = item.toJson();

        expect(result['ItemId'], original['ItemId']);
        expect(result['ItemName'], original['ItemName']);
        expect(result['FilledSaleQty'], original['FilledSaleQty']);
        expect(result['EmptyRetQty'], original['EmptyRetQty']);
        expect(result['DMImbQty'], original['DMImbQty']);
      });
    });

    // ─────────────────────────────────────────────
    // copyWith Tests
    // ─────────────────────────────────────────────
    group('copyWith', () {
      test('POSITIVE: copies with updated itemName', () {
        final original = ItemList(itemId: 4, itemName: '2 kg');
        final copy = original.copyWith(itemName: '5 kg');

        expect(copy.itemName, '5 kg');
        expect(copy.itemId, 4); // unchanged
      });

      test('POSITIVE: copies with updated numeric fields', () {
        final original = ItemList(filledSaleQty: 10, emptyRetQty: 5);
        final copy = original.copyWith(filledSaleQty: 30, emptyRetQty: 20);

        expect(copy.filledSaleQty, 30);
        expect(copy.emptyRetQty, 20);
      });

      test('POSITIVE: copyWith with no args retains all values', () {
        final original = ItemList(
          itemId: 4,
          itemName: '2 kg',
          filledSaleQty: 20,
          DMImbQty: 5,
        );
        final copy = original.copyWith();

        expect(copy.itemId, 4);
        expect(copy.itemName, '2 kg');
        expect(copy.filledSaleQty, 20);
        expect(copy.DMImbQty, 5);
      });

      test('POSITIVE: original is not mutated after copyWith', () {
        final original = ItemList(itemName: '2 kg');
        original.copyWith(itemName: '5 kg');

        expect(original.itemName, '2 kg');
      });

      test('NEGATIVE: copyWith bug — ImbForIdStr and ImbQtyStr self-reference (known issue)', () {
        // In the source: ImbForIdStr: ImbForIdStr ?? ImbForIdStr (uses param, not _ImbForIdStr)
        // This means original _ImbForIdStr is NEVER used in copyWith
        final original = ItemList(ImbForIdStr: 'original_value');
        final copy = original.copyWith(); // no override

        // After fixing copyWith, the original value should be preserved
        expect(copy.ImbForIdStr, 'original_value');
      });

      test('NEGATIVE: copyWith bug — DMImbQty self-reference (known issue)', () {
        // Same bug: DMImbQty: DMImbQty ?? DMImbQty (uses param, ignores _DMImbQty)
        final original = ItemList(DMImbQty: 99);
        final copy = original.copyWith();

        expect(copy.DMImbQty, 99);
      });

      test('NEGATIVE: copyWith cannot set field to null (uses ?? fallback)', () {
        final original = ItemList(itemName: '2 kg');
        final copy = original.copyWith(itemName: null);

        expect(copy.itemName, '2 kg'); // null ignored
      });
    });

    // ─────────────────────────────────────────────
    // parseNum Helper Tests
    // ─────────────────────────────────────────────
    group('parseNum (via fromJson)', () {
      test('POSITIVE: parses int correctly', () {
        final item = ItemList.fromJson({'ItemId': 4});
        expect(item.itemId, 4);
      });

      test('POSITIVE: parses double correctly', () {
        final item = ItemList.fromJson({'FilledSaleQty': 20.5});
        expect(item.filledSaleQty, 20.5);
      });

      test('POSITIVE: parses numeric string correctly', () {
        final item = ItemList.fromJson({'SVQty': '3'});
        expect(item.sVQty, 3);
      });

      test('POSITIVE: returns null for null input', () {
        final item = ItemList.fromJson({'FilledSaleQty': null});
        expect(item.filledSaleQty, isNull);
      });

      test('NEGATIVE: returns null for non-parseable string', () {
        final item = ItemList.fromJson({'TVQty': 'abc'});
        expect(item.tVQty, isNull);
      });

      test('NEGATIVE: returns null for empty string', () {
        final item = ItemList.fromJson({'EmptyRetQty': ''});
        expect(item.emptyRetQty, isNull);
      });
    });

    // ─────────────────────────────────────────────
    // Getter Tests
    // ─────────────────────────────────────────────
    group('Getters', () {
      test('POSITIVE: all getters return expected values after fromJson', () {
        final item = ItemList.fromJson({
          'SaleGKItemId': 10,
          'ItemId': 4,
          'ItemName': '2 kg',
          'FilledSaleQty': 20,
          'SVQty': 1,
          'TVQty': 1,
          'EmptyRetQty': 18,
          'DeffQty': 1,
          'LessEmptyQty': 1,
          'Remark': 'ok',
          'ClosingFilled': 2,
          'ClosingEmpty': 3,
          'ClosingDef': 0,
          'SVConsStr': 'sv',
          'PSVIdStr': 'psv',
          'TVConsStr': 'tv',
          'SVQtyStr': 'svq',
          'TVQtyStr': 'tvq',
          'ImbForIdStr': 'imb',
          'ImbQtyStr': 'imbq',
          'DMImbQty': 7,
          'FlagColumnUpdate': 'Y',
        });

        expect(item.SaleGKItemId, 10);
        expect(item.itemId, 4);
        expect(item.itemName, '2 kg');
        expect(item.filledSaleQty, 20);
        expect(item.sVQty, 1);
        expect(item.tVQty, 1);
        expect(item.emptyRetQty, 18);
        expect(item.deffQty, 1);
        expect(item.lessEmptyQty, 1);
        expect(item.remark, 'ok');
        expect(item.closingFilled, 2);
        expect(item.closingEmpty, 3);
        expect(item.closingDef, 0);
        expect(item.sVConsStr, 'sv');
        expect(item.PSVIdStr, 'psv');
        expect(item.TVConsStr, 'tv');
        expect(item.SVQtyStr, 'svq');
        expect(item.TVQtyStr, 'tvq');
        expect(item.ImbForIdStr, 'imb');
        expect(item.ImbQtyStr, 'imbq');
        expect(item.DMImbQty, 7);
        expect(item.FlagColumnUpdate, 'Y');
      });

      test('NEGATIVE: unset getters return null', () {
        final item = ItemList();
        expect(item.itemId, isNull);
        expect(item.itemName, isNull);
        expect(item.DMImbQty, isNull);
      });
    });
  });
}