// cyl_item_list_model_test.dart
// ─────────────────────────────────────────────────────────────────────────────
// All positive & negative unit tests for CylItemListModel
//
// Run with:
//   flutter test test/cyl_item_list_model_test.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_test/flutter_test.dart';

// ─── Model (inline so the file is self-contained; replace with your import) ───
class CylItemListModel {
  CylItemListModel({
    dynamic itemId,
    dynamic distributorId,
    dynamic itemName,
    dynamic itemDescription,
    dynamic action,
    dynamic addedBy,
    dynamic isActive,
    dynamic lastUpdatedOn,
  }) {
    _itemId = itemId;
    _distributorId = distributorId;
    _itemName = itemName;
    _itemDescription = itemDescription;
    _action = action;
    _addedBy = addedBy;
    _isActive = isActive;
    _lastUpdatedOn = lastUpdatedOn;
  }

  CylItemListModel.fromJson(dynamic json) {
    _itemId = json['ItemId'];
    _distributorId = json['DistributorId'];
    _itemName = json['ItemName'];
    _itemDescription = json['ItemDescription'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
    _isActive = json['IsActive'];
    _lastUpdatedOn = json['LastUpdatedOn'];
  }

  dynamic _itemId;
  dynamic _distributorId;
  dynamic _itemName;
  dynamic _itemDescription;
  dynamic _action;
  dynamic _addedBy;
  dynamic _isActive;
  dynamic _lastUpdatedOn;

  CylItemListModel copyWith({
    dynamic itemId,
    dynamic distributorId,
    dynamic itemName,
    dynamic itemDescription,
    dynamic action,
    dynamic addedBy,
    dynamic isActive,
    dynamic lastUpdatedOn,
  }) =>
      CylItemListModel(
        itemId: itemId ?? _itemId,
        distributorId: distributorId ?? _distributorId,
        itemName: itemName ?? _itemName,
        itemDescription: itemDescription ?? _itemDescription,
        action: action ?? _action,
        addedBy: addedBy ?? _addedBy,
        isActive: isActive ?? _isActive,
        lastUpdatedOn: lastUpdatedOn ?? _lastUpdatedOn,
      );

  dynamic get itemId => _itemId;
  dynamic get distributorId => _distributorId;
  dynamic get itemName => _itemName;
  dynamic get itemDescription => _itemDescription;
  dynamic get action => _action;
  dynamic get addedBy => _addedBy;
  dynamic get isActive => _isActive;
  dynamic get lastUpdatedOn => _lastUpdatedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemId'] = _itemId;
    map['DistributorId'] = _distributorId;
    map['ItemName'] = _itemName;
    map['ItemDescription'] = _itemDescription;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    map['IsActive'] = _isActive;
    map['LastUpdatedOn'] = _lastUpdatedOn;
    return map;
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Map<String, dynamic> _validJson() => {
  'ItemId': 2,
  'DistributorId': 8118,
  'ItemName': '5kg',
  'ItemDescription': '5kg filled cylinder',
  'Action': null,
  'AddedBy': null,
  'IsActive': 1,
  'LastUpdatedOn': '2024-11-19T05:31:01.337',
};

// =============================================================================
// TESTS
// =============================================================================

void main() {
  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 1 — Named constructor
  // ───────────────────────────────────────────────────────────────────────────
  group('Named constructor —', () {
    test('POSITIVE: all fields set correctly', () {
      final model = CylItemListModel(
        itemId: 2,
        distributorId: 8118,
        itemName: '5kg',
        itemDescription: '5kg filled cylinder',
        action: null,
        addedBy: null,
        isActive: 1,
        lastUpdatedOn: '2024-11-19T05:31:01.337',
      );

      expect(model.itemId, 2);
      expect(model.distributorId, 8118);
      expect(model.itemName, '5kg');
      expect(model.itemDescription, '5kg filled cylinder');
      expect(model.action, isNull);
      expect(model.addedBy, isNull);
      expect(model.isActive, 1);
      expect(model.lastUpdatedOn, '2024-11-19T05:31:01.337');
    });

    test('POSITIVE: itemId accepts integer value', () {
      final model = CylItemListModel(itemId: 100);
      expect(model.itemId, 100);
    });

    test('POSITIVE: itemId accepts double value (num)', () {
      final model = CylItemListModel(itemId: 2.5);
      expect(model.itemId, 2.5);
    });

    test('POSITIVE: isActive = 1 (active state)', () {
      final model = CylItemListModel(isActive: 1);
      expect(model.isActive, 1);
    });

    test('POSITIVE: isActive = 0 (inactive state)', () {
      final model = CylItemListModel(isActive: 0);
      expect(model.isActive, 0);
    });

    test('POSITIVE: action accepts string value', () {
      final model = CylItemListModel(action: 'EDIT');
      expect(model.action, 'EDIT');
    });

    test('POSITIVE: addedBy accepts integer staff id', () {
      final model = CylItemListModel(addedBy: 42);
      expect(model.addedBy, 42);
    });

    test('POSITIVE: itemName accepts special characters', () {
      final model = CylItemListModel(itemName: '5 kg (LPG) — Special');
      expect(model.itemName, '5 kg (LPG) — Special');
    });

    test('POSITIVE: itemDescription accepts long string', () {
      final desc = 'A' * 500;
      final model = CylItemListModel(itemDescription: desc);
      expect(model.itemDescription, desc);
    });

    test('NEGATIVE: default constructor with no args — all fields null', () {
      final model = CylItemListModel();
      expect(model.itemId, isNull);
      expect(model.distributorId, isNull);
      expect(model.itemName, isNull);
      expect(model.itemDescription, isNull);
      expect(model.action, isNull);
      expect(model.addedBy, isNull);
      expect(model.isActive, isNull);
      expect(model.lastUpdatedOn, isNull);
    });

    test('NEGATIVE: itemName null does not throw', () {
      expect(() => CylItemListModel(itemName: null), returnsNormally);
    });

    test('NEGATIVE: itemId 0 is stored as-is (not treated as null)', () {
      final model = CylItemListModel(itemId: 0);
      expect(model.itemId, 0);
      expect(model.itemId, isNotNull);
    });

    test('NEGATIVE: negative itemId is stored without error', () {
      final model = CylItemListModel(itemId: -1);
      expect(model.itemId, -1);
    });

    test('NEGATIVE: empty itemName string is stored as-is', () {
      final model = CylItemListModel(itemName: '');
      expect(model.itemName, '');
    });

    test('NEGATIVE: empty itemDescription is stored as-is', () {
      final model = CylItemListModel(itemDescription: '');
      expect(model.itemDescription, '');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 2 — fromJson constructor
  // ───────────────────────────────────────────────────────────────────────────
  group('fromJson —', () {
    test('POSITIVE: parses all fields from a complete JSON map', () {
      final model = CylItemListModel.fromJson(_validJson());
      expect(model.itemId, 2);
      expect(model.distributorId, 8118);
      expect(model.itemName, '5kg');
      expect(model.itemDescription, '5kg filled cylinder');
      expect(model.action, isNull);
      expect(model.addedBy, isNull);
      expect(model.isActive, 1);
      expect(model.lastUpdatedOn, '2024-11-19T05:31:01.337');
    });

    test('POSITIVE: parses itemId as integer', () {
      final model = CylItemListModel.fromJson({'ItemId': 99});
      expect(model.itemId, 99);
    });

    test('POSITIVE: parses itemId as double', () {
      final model = CylItemListModel.fromJson({'ItemId': 3.14});
      expect(model.itemId, 3.14);
    });

    test('POSITIVE: parses action as String when provided', () {
      final model = CylItemListModel.fromJson({'Action': 'ADD'});
      expect(model.action, 'ADD');
    });

    test('POSITIVE: parses addedBy as integer when provided', () {
      final model = CylItemListModel.fromJson({'AddedBy': 7});
      expect(model.addedBy, 7);
    });

    test('POSITIVE: parses isActive = 0', () {
      final model = CylItemListModel.fromJson({'IsActive': 0});
      expect(model.isActive, 0);
    });

    test('POSITIVE: parses lastUpdatedOn as ISO datetime string', () {
      final model = CylItemListModel.fromJson(
          {'LastUpdatedOn': '2024-11-19T05:31:01.337'});
      expect(model.lastUpdatedOn, '2024-11-19T05:31:01.337');
    });

    test('POSITIVE: extra unknown keys in JSON are ignored', () {
      final json = _validJson()..['UnknownKey'] = 'should be ignored';
      expect(() => CylItemListModel.fromJson(json), returnsNormally);
    });

    test('NEGATIVE: missing all keys — all fields null', () {
      final model = CylItemListModel.fromJson({});
      expect(model.itemId, isNull);
      expect(model.distributorId, isNull);
      expect(model.itemName, isNull);
      expect(model.itemDescription, isNull);
      expect(model.action, isNull);
      expect(model.addedBy, isNull);
      expect(model.isActive, isNull);
      expect(model.lastUpdatedOn, isNull);
    });

    test('NEGATIVE: null values in JSON map to null fields', () {
      final json = {
        'ItemId': null,
        'DistributorId': null,
        'ItemName': null,
        'ItemDescription': null,
        'Action': null,
        'AddedBy': null,
        'IsActive': null,
        'LastUpdatedOn': null,
      };
      final model = CylItemListModel.fromJson(json);
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.isActive, isNull);
    });

    test('NEGATIVE: wrong-case key (lowercase) is not parsed', () {
      final model = CylItemListModel.fromJson({'itemId': 5});
      expect(model.itemId, isNull); // key mismatch — case-sensitive
    });

    test('NEGATIVE: ItemName as integer is stored as dynamic (no crash)', () {
      // JSON is dynamic; no type enforcement at parse time
      expect(() => CylItemListModel.fromJson({'ItemName': 123}), returnsNormally);
    });

    test('NEGATIVE: empty string for ItemName is parsed as empty', () {
      final model = CylItemListModel.fromJson({'ItemName': ''});
      expect(model.itemName, '');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 3 — toJson
  // ───────────────────────────────────────────────────────────────────────────
  group('toJson —', () {
    test('POSITIVE: produces map with all expected keys', () {
      final model = CylItemListModel.fromJson(_validJson());
      final json = model.toJson();
      expect(json.keys, containsAll([
        'ItemId', 'DistributorId', 'ItemName', 'ItemDescription',
        'Action', 'AddedBy', 'IsActive', 'LastUpdatedOn',
      ]));
    });

    test('POSITIVE: serialised values match original', () {
      final model = CylItemListModel.fromJson(_validJson());
      final json = model.toJson();
      expect(json['ItemId'], 2);
      expect(json['DistributorId'], 8118);
      expect(json['ItemName'], '5kg');
      expect(json['ItemDescription'], '5kg filled cylinder');
      expect(json['IsActive'], 1);
      expect(json['LastUpdatedOn'], '2024-11-19T05:31:01.337');
    });

    test('POSITIVE: toJson round-trip preserves data', () {
      final original = CylItemListModel.fromJson(_validJson());
      final restored = CylItemListModel.fromJson(original.toJson());
      expect(restored.itemId, original.itemId);
      expect(restored.itemName, original.itemName);
      expect(restored.distributorId, original.distributorId);
      expect(restored.itemDescription, original.itemDescription);
      expect(restored.isActive, original.isActive);
      expect(restored.lastUpdatedOn, original.lastUpdatedOn);
    });

    test('POSITIVE: null fields are included as null in map', () {
      final model = CylItemListModel();
      final json = model.toJson();
      expect(json.containsKey('ItemId'), isTrue);
      expect(json['ItemId'], isNull);
      expect(json['ItemName'], isNull);
    });

    test('POSITIVE: action null is preserved in toJson', () {
      final model = CylItemListModel.fromJson(_validJson());
      expect(model.toJson()['Action'], isNull);
    });

    test('POSITIVE: addedBy null is preserved in toJson', () {
      final model = CylItemListModel.fromJson(_validJson());
      expect(model.toJson()['AddedBy'], isNull);
    });

    test('POSITIVE: toJson map has exactly 8 keys', () {
      final model = CylItemListModel.fromJson(_validJson());
      expect(model.toJson().length, 8);
    });

    test('NEGATIVE: toJson on default instance returns map with null values', () {
      final model = CylItemListModel();
      final json = model.toJson();
      expect(json.values.every((v) => v == null), isTrue);
    });

    test('NEGATIVE: modifying toJson map does not affect model', () {
      final model = CylItemListModel(itemName: 'Original');
      final json = model.toJson();
      json['ItemName'] = 'Modified';
      expect(model.itemName, 'Original'); // model unchanged
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 4 — copyWith
  // ───────────────────────────────────────────────────────────────────────────
  group('copyWith —', () {
    late CylItemListModel base;
    setUp(() => base = CylItemListModel.fromJson(_validJson()));

    test('POSITIVE: no args — all fields remain identical to original', () {
      final copy = base.copyWith();
      expect(copy.itemId, base.itemId);
      expect(copy.distributorId, base.distributorId);
      expect(copy.itemName, base.itemName);
      expect(copy.itemDescription, base.itemDescription);
      expect(copy.action, base.action);
      expect(copy.addedBy, base.addedBy);
      expect(copy.isActive, base.isActive);
      expect(copy.lastUpdatedOn, base.lastUpdatedOn);
    });

    test('POSITIVE: updates itemId only', () {
      final copy = base.copyWith(itemId: 999);
      expect(copy.itemId, 999);
      expect(copy.itemName, base.itemName); // unchanged
    });

    test('POSITIVE: updates distributorId only', () {
      final copy = base.copyWith(distributorId: 1000);
      expect(copy.distributorId, 1000);
      expect(copy.itemId, base.itemId);
    });

    test('POSITIVE: updates itemName only', () {
      final copy = base.copyWith(itemName: '10kg');
      expect(copy.itemName, '10kg');
      expect(copy.distributorId, base.distributorId);
    });

    test('POSITIVE: updates itemDescription only', () {
      final copy = base.copyWith(itemDescription: 'Updated description');
      expect(copy.itemDescription, 'Updated description');
    });

    test('POSITIVE: updates action to a non-null string', () {
      final copy = base.copyWith(action: 'EDIT');
      expect(copy.action, 'EDIT');
    });

    test('POSITIVE: updates addedBy to integer', () {
      final copy = base.copyWith(addedBy: 77);
      expect(copy.addedBy, 77);
    });

    test('POSITIVE: updates isActive to 0 (deactivate)', () {
      final copy = base.copyWith(isActive: 0);
      expect(copy.isActive, 0);
    });

    test('POSITIVE: updates lastUpdatedOn to new timestamp', () {
      final copy = base.copyWith(lastUpdatedOn: '2025-01-01T00:00:00.000');
      expect(copy.lastUpdatedOn, '2025-01-01T00:00:00.000');
    });

    test('POSITIVE: updates multiple fields at once', () {
      final copy = base.copyWith(itemId: 10, itemName: 'NewItem', isActive: 0);
      expect(copy.itemId, 10);
      expect(copy.itemName, 'NewItem');
      expect(copy.isActive, 0);
      expect(copy.distributorId, base.distributorId); // unchanged
    });

    test('POSITIVE: copyWith returns a new distinct instance', () {
      final copy = base.copyWith();
      expect(identical(copy, base), isFalse);
    });

    test('NEGATIVE: copyWith does NOT mutate the original', () {
      base.copyWith(itemName: 'Changed');
      expect(base.itemName, '5kg'); // original untouched
    });

    test('NEGATIVE: passing null explicitly — falls back to original value', () {
      // copyWith uses ?? so null arg keeps original value
      final copy = base.copyWith(itemName: null);
      expect(copy.itemName, base.itemName); // not overridden
    });

    test('NEGATIVE: chaining copyWith twice gives independent copies', () {
      final copy1 = base.copyWith(itemId: 11);
      final copy2 = copy1.copyWith(itemId: 22);
      expect(copy1.itemId, 11);
      expect(copy2.itemId, 22);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 5 — Getters
  // ───────────────────────────────────────────────────────────────────────────
  group('Getters —', () {
    test('POSITIVE: all getters return expected values from named constructor',
            () {
          final model = CylItemListModel(
            itemId: 2,
            distributorId: 8118,
            itemName: '5kg',
            itemDescription: '5kg filled cylinder',
            action: null,
            addedBy: null,
            isActive: 1,
            lastUpdatedOn: '2024-11-19T05:31:01.337',
          );
          expect(model.itemId, 2);
          expect(model.distributorId, 8118);
          expect(model.itemName, '5kg');
          expect(model.itemDescription, '5kg filled cylinder');
          expect(model.action, isNull);
          expect(model.addedBy, isNull);
          expect(model.isActive, 1);
          expect(model.lastUpdatedOn, '2024-11-19T05:31:01.337');
        });

    test('POSITIVE: itemId getter returns num type', () {
      final model = CylItemListModel(itemId: 5);
      expect(model.itemId, isA<num>());
    });

    test('POSITIVE: isActive getter returns num type', () {
      final model = CylItemListModel(isActive: 1);
      expect(model.isActive, isA<num>());
    });

    test('POSITIVE: itemName getter returns String type', () {
      final model = CylItemListModel(itemName: 'Test');
      expect(model.itemName, isA<String>());
    });

    test('NEGATIVE: action getter is dynamic — can hold any type', () {
      final model = CylItemListModel(action: {'key': 'value'});
      expect(model.action, isA<Map>());
    });

    test('NEGATIVE: addedBy getter is dynamic — can hold any type', () {
      final model = CylItemListModel(addedBy: [1, 2, 3]);
      expect(model.addedBy, isA<List>());
    });

    test('NEGATIVE: all getters null when no args passed to constructor', () {
      final model = CylItemListModel();
      expect(model.itemId, isNull);
      expect(model.distributorId, isNull);
      expect(model.itemName, isNull);
      expect(model.itemDescription, isNull);
      expect(model.action, isNull);
      expect(model.addedBy, isNull);
      expect(model.isActive, isNull);
      expect(model.lastUpdatedOn, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 6 — Edge Cases & Boundary Conditions
  // ───────────────────────────────────────────────────────────────────────────
  group('Edge cases —', () {
    test('POSITIVE: itemId = 0 is valid and stored correctly', () {
      final model = CylItemListModel(itemId: 0);
      expect(model.itemId, 0);
    });

    test('POSITIVE: very large distributorId (big int)', () {
      final model = CylItemListModel(distributorId: 999999999);
      expect(model.distributorId, 999999999);
    });

    test('POSITIVE: itemName with only whitespace is stored as-is', () {
      final model = CylItemListModel(itemName: '   ');
      expect(model.itemName, '   ');
    });

    test('POSITIVE: unicode itemName is stored correctly', () {
      final model = CylItemListModel(itemName: '5किलो गैस');
      expect(model.itemName, '5किलो गैस');
    });

    test('POSITIVE: lastUpdatedOn with timezone offset is stored as-is', () {
      final model =
      CylItemListModel(lastUpdatedOn: '2024-11-19T05:31:01.337+05:30');
      expect(model.lastUpdatedOn, '2024-11-19T05:31:01.337+05:30');
    });

    test('NEGATIVE: isActive negative value stored without error', () {
      final model = CylItemListModel(isActive: -1);
      expect(model.isActive, -1);
    });

    test('NEGATIVE: fromJson with integer ItemName does not throw', () {
      expect(
              () => CylItemListModel.fromJson({'ItemName': 123}), returnsNormally);
    });

    test('NEGATIVE: fromJson with boolean IsActive does not throw', () {
      expect(
              () => CylItemListModel.fromJson({'IsActive': true}), returnsNormally);
    });

    test('POSITIVE: list of models from JSON array parsed correctly', () {
      final jsonList = [
        _validJson(),
        {
          'ItemId': 3,
          'DistributorId': 8118,
          'ItemName': '10kg',
          'ItemDescription': '10kg filled cylinder',
          'Action': null,
          'AddedBy': null,
          'IsActive': 1,
          'LastUpdatedOn': '2024-12-01T00:00:00.000',
        }
      ];
      final models =
      jsonList.map((j) => CylItemListModel.fromJson(j)).toList();
      expect(models.length, 2);
      expect(models[0].itemName, '5kg');
      expect(models[1].itemName, '10kg');
    });

    test('POSITIVE: two models with same data have identical getter values', () {
      final m1 = CylItemListModel.fromJson(_validJson());
      final m2 = CylItemListModel.fromJson(_validJson());
      expect(m1.itemId, m2.itemId);
      expect(m1.itemName, m2.itemName);
      expect(m1.isActive, m2.isActive);
    });

    test('NEGATIVE: fromJson with empty JSON list would yield null fields', () {
      // Simulates a server returning an unexpected empty-map element
      final model = CylItemListModel.fromJson(<String, dynamic>{});
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
    });
  });
}