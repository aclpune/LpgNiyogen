// get_current_stc_of_godown_keeper_model_test.dart
// ─────────────────────────────────────────────────────────────────────────────
// All positive & negative unit tests for GetCurrentStcOfGodownKeeperModel
//
// Run with:
//   flutter test test/get_current_stc_of_godown_keeper_model_test.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_test/flutter_test.dart';

// ─── Model (inline so the file is self-contained; replace with your import) ───
class GetCurrentStcOfGodownKeeperModel {
  GetCurrentStcOfGodownKeeperModel({
    dynamic distributorId,
    dynamic godownId,
    dynamic itemId,
    dynamic itemName,
    dynamic currentStkFilled,
    dynamic currentStkEmpty,
    dynamic currentStkDefective,
  }) {
    _distributorId = distributorId;
    _godownId = godownId;
    _itemId = itemId;
    _itemName = itemName;
    _currentStkFilled = currentStkFilled;
    _currentStkEmpty = currentStkEmpty;
    _currentStkDefective = currentStkDefective;
  }

  GetCurrentStcOfGodownKeeperModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _godownId = json['GodownId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _currentStkFilled = json['CurrentStkFilled'];
    _currentStkEmpty = json['CurrentStkEmpty'];
    _currentStkDefective = json['CurrentStkDefective'];
  }

  dynamic _distributorId;
  dynamic _godownId;
  dynamic _itemId;
  dynamic _itemName;
  dynamic _currentStkFilled;
  dynamic _currentStkEmpty;
  dynamic _currentStkDefective;

  GetCurrentStcOfGodownKeeperModel copyWith({
    dynamic distributorId,
    dynamic godownId,
    dynamic itemId,
    dynamic itemName,
    dynamic currentStkFilled,
    dynamic currentStkEmpty,
    dynamic currentStkDefective,
  }) =>
      GetCurrentStcOfGodownKeeperModel(
        distributorId: distributorId ?? _distributorId,
        godownId: godownId ?? _godownId,
        itemId: itemId ?? _itemId,
        itemName: itemName ?? _itemName,
        currentStkFilled: currentStkFilled ?? _currentStkFilled,
        currentStkEmpty: currentStkEmpty ?? _currentStkEmpty,
        currentStkDefective: currentStkDefective ?? _currentStkDefective,
      );

  dynamic get distributorId => _distributorId;
  dynamic get godownId => _godownId;
  dynamic get itemId => _itemId;
  dynamic get itemName => _itemName;
  dynamic get currentStkFilled => _currentStkFilled;
  dynamic get currentStkEmpty => _currentStkEmpty;
  dynamic get currentStkDefective => _currentStkDefective;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['GodownId'] = _godownId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['CurrentStkFilled'] = _currentStkFilled;
    map['CurrentStkEmpty'] = _currentStkEmpty;
    map['CurrentStkDefective'] = _currentStkDefective;
    return map;
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Map<String, dynamic> _validJson() => {
  'DistributorId': 8118,
  'GodownId': 1,
  'ItemId': 4,
  'ItemName': '2 Kg',
  'CurrentStkFilled': 220,
  'CurrentStkEmpty': 0,
  'CurrentStkDefective': 0,
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
      final model = GetCurrentStcOfGodownKeeperModel(
        distributorId: 8118,
        godownId: 1,
        itemId: 4,
        itemName: '2 Kg',
        currentStkFilled: 220,
        currentStkEmpty: 0,
        currentStkDefective: 0,
      );

      expect(model.distributorId, 8118);
      expect(model.godownId, 1);
      expect(model.itemId, 4);
      expect(model.itemName, '2 Kg');
      expect(model.currentStkFilled, 220);
      expect(model.currentStkEmpty, 0);
      expect(model.currentStkDefective, 0);
    });

    test('POSITIVE: currentStkFilled accepts large stock number', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(currentStkFilled: 999999);
      expect(model.currentStkFilled, 999999);
    });

    test('POSITIVE: currentStkEmpty = 0 is valid', () {
      final model = GetCurrentStcOfGodownKeeperModel(currentStkEmpty: 0);
      expect(model.currentStkEmpty, 0);
    });

    test('POSITIVE: currentStkDefective = 0 is valid', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(currentStkDefective: 0);
      expect(model.currentStkDefective, 0);
    });

    test('POSITIVE: godownId accepts any positive integer', () {
      final model = GetCurrentStcOfGodownKeeperModel(godownId: 99);
      expect(model.godownId, 99);
    });

    test('POSITIVE: itemName accepts alphanumeric string with space', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(itemName: '19 Kg Industrial');
      expect(model.itemName, '19 Kg Industrial');
    });

    test('POSITIVE: all stock fields accept double values (num)', () {
      final model = GetCurrentStcOfGodownKeeperModel(
        currentStkFilled: 10.5,
        currentStkEmpty: 2.5,
        currentStkDefective: 0.5,
      );
      expect(model.currentStkFilled, 10.5);
      expect(model.currentStkEmpty, 2.5);
      expect(model.currentStkDefective, 0.5);
    });

    test('POSITIVE: distributorId accepts large number', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(distributorId: 999999999);
      expect(model.distributorId, 999999999);
    });

    test('NEGATIVE: no-arg constructor — all fields null', () {
      final model = GetCurrentStcOfGodownKeeperModel();
      expect(model.distributorId, isNull);
      expect(model.godownId, isNull);
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.currentStkFilled, isNull);
      expect(model.currentStkEmpty, isNull);
      expect(model.currentStkDefective, isNull);
    });

    test('NEGATIVE: null itemName does not throw', () {
      expect(
              () => GetCurrentStcOfGodownKeeperModel(itemName: null),
          returnsNormally);
    });

    test('NEGATIVE: negative stock counts stored without error', () {
      final model = GetCurrentStcOfGodownKeeperModel(
        currentStkFilled: -10,
        currentStkEmpty: -5,
        currentStkDefective: -1,
      );
      expect(model.currentStkFilled, -10);
      expect(model.currentStkEmpty, -5);
      expect(model.currentStkDefective, -1);
    });

    test('NEGATIVE: zero distributorId is stored as-is (not treated as null)',
            () {
          final model = GetCurrentStcOfGodownKeeperModel(distributorId: 0);
          expect(model.distributorId, 0);
          expect(model.distributorId, isNotNull);
        });

    test('NEGATIVE: empty itemName is stored as-is', () {
      final model = GetCurrentStcOfGodownKeeperModel(itemName: '');
      expect(model.itemName, '');
    });

    test('NEGATIVE: itemId = 0 is stored correctly', () {
      final model = GetCurrentStcOfGodownKeeperModel(itemId: 0);
      expect(model.itemId, 0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 2 — fromJson constructor
  // ───────────────────────────────────────────────────────────────────────────
  group('fromJson —', () {
    test('POSITIVE: parses all fields from a complete JSON map', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      expect(model.distributorId, 8118);
      expect(model.godownId, 1);
      expect(model.itemId, 4);
      expect(model.itemName, '2 Kg');
      expect(model.currentStkFilled, 220);
      expect(model.currentStkEmpty, 0);
      expect(model.currentStkDefective, 0);
    });

    test('POSITIVE: parses distributorId as integer', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'DistributorId': 1234});
      expect(model.distributorId, 1234);
    });

    test('POSITIVE: parses currentStkFilled as double', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'CurrentStkFilled': 12.5});
      expect(model.currentStkFilled, 12.5);
    });

    test('POSITIVE: parses currentStkEmpty = 0', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'CurrentStkEmpty': 0});
      expect(model.currentStkEmpty, 0);
    });

    test('POSITIVE: parses currentStkDefective = 0', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'CurrentStkDefective': 0});
      expect(model.currentStkDefective, 0);
    });

    test('POSITIVE: parses large currentStkFilled value', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'CurrentStkFilled': 999999});
      expect(model.currentStkFilled, 999999);
    });

    test('POSITIVE: extra unknown keys in JSON are ignored', () {
      final json = _validJson()..['ExtraField'] = 'ignored';
      expect(
              () => GetCurrentStcOfGodownKeeperModel.fromJson(json),
          returnsNormally);
    });

    test('POSITIVE: parses ItemName with special characters', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'ItemName': '5 Kg — LPG (Special)'});
      expect(model.itemName, '5 Kg — LPG (Special)');
    });

    test('NEGATIVE: missing all keys — all fields null', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(<String, dynamic>{});
      expect(model.distributorId, isNull);
      expect(model.godownId, isNull);
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.currentStkFilled, isNull);
      expect(model.currentStkEmpty, isNull);
      expect(model.currentStkDefective, isNull);
    });

    test('NEGATIVE: null values in JSON map to null fields', () {
      final json = {
        'DistributorId': null,
        'GodownId': null,
        'ItemId': null,
        'ItemName': null,
        'CurrentStkFilled': null,
        'CurrentStkEmpty': null,
        'CurrentStkDefective': null,
      };
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(json);
      expect(model.distributorId, isNull);
      expect(model.currentStkFilled, isNull);
    });

    test('NEGATIVE: wrong-case key is not parsed (case-sensitive)', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'distributor_id': 100}); // snake_case not recognised
      expect(model.distributorId, isNull);
    });

    test('NEGATIVE: wrong-case "currentStkFilled" not parsed', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          {'currentStkFilled': 50}); // camelCase not recognised
      expect(model.currentStkFilled, isNull);
    });

    test('NEGATIVE: negative stock values are parsed as-is', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson({
        'CurrentStkFilled': -100,
        'CurrentStkEmpty': -50,
        'CurrentStkDefective': -10,
      });
      expect(model.currentStkFilled, -100);
      expect(model.currentStkEmpty, -50);
      expect(model.currentStkDefective, -10);
    });

    test('NEGATIVE: ItemName as integer does not throw', () {
      expect(
              () => GetCurrentStcOfGodownKeeperModel.fromJson({'ItemName': 123}),
          returnsNormally);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 3 — toJson
  // ───────────────────────────────────────────────────────────────────────────
  group('toJson —', () {
    test('POSITIVE: produces map with all 7 expected keys', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      final json = model.toJson();
      expect(json.keys, containsAll([
        'DistributorId', 'GodownId', 'ItemId', 'ItemName',
        'CurrentStkFilled', 'CurrentStkEmpty', 'CurrentStkDefective',
      ]));
    });

    test('POSITIVE: serialised values match original', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      final json = model.toJson();
      expect(json['DistributorId'], 8118);
      expect(json['GodownId'], 1);
      expect(json['ItemId'], 4);
      expect(json['ItemName'], '2 Kg');
      expect(json['CurrentStkFilled'], 220);
      expect(json['CurrentStkEmpty'], 0);
      expect(json['CurrentStkDefective'], 0);
    });

    test('POSITIVE: toJson round-trip preserves all data', () {
      final original =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      final restored =
      GetCurrentStcOfGodownKeeperModel.fromJson(original.toJson());
      expect(restored.distributorId, original.distributorId);
      expect(restored.godownId, original.godownId);
      expect(restored.itemId, original.itemId);
      expect(restored.itemName, original.itemName);
      expect(restored.currentStkFilled, original.currentStkFilled);
      expect(restored.currentStkEmpty, original.currentStkEmpty);
      expect(restored.currentStkDefective, original.currentStkDefective);
    });

    test('POSITIVE: toJson has exactly 7 keys', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      expect(model.toJson().length, 7);
    });

    test('POSITIVE: null fields are included as null in map', () {
      final model = GetCurrentStcOfGodownKeeperModel();
      final json = model.toJson();
      expect(json.containsKey('DistributorId'), isTrue);
      expect(json['DistributorId'], isNull);
      expect(json['CurrentStkFilled'], isNull);
    });

    test('POSITIVE: zero stock values serialise as 0 (not null)', () {
      final model = GetCurrentStcOfGodownKeeperModel(
        currentStkFilled: 0,
        currentStkEmpty: 0,
        currentStkDefective: 0,
      );
      final json = model.toJson();
      expect(json['CurrentStkFilled'], 0);
      expect(json['CurrentStkEmpty'], 0);
      expect(json['CurrentStkDefective'], 0);
    });

    test('NEGATIVE: toJson on default instance returns all-null map', () {
      final model = GetCurrentStcOfGodownKeeperModel();
      final json = model.toJson();
      expect(json.values.every((v) => v == null), isTrue);
    });

    test('NEGATIVE: modifying toJson map does not affect the model', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(currentStkFilled: 100);
      final json = model.toJson();
      json['CurrentStkFilled'] = 9999;
      expect(model.currentStkFilled, 100); // model unchanged
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 4 — copyWith
  // ───────────────────────────────────────────────────────────────────────────
  group('copyWith —', () {
    late GetCurrentStcOfGodownKeeperModel base;
    setUp(() =>
    base = GetCurrentStcOfGodownKeeperModel.fromJson(_validJson()));

    test('POSITIVE: no args — all fields remain identical', () {
      final copy = base.copyWith();
      expect(copy.distributorId, base.distributorId);
      expect(copy.godownId, base.godownId);
      expect(copy.itemId, base.itemId);
      expect(copy.itemName, base.itemName);
      expect(copy.currentStkFilled, base.currentStkFilled);
      expect(copy.currentStkEmpty, base.currentStkEmpty);
      expect(copy.currentStkDefective, base.currentStkDefective);
    });

    test('POSITIVE: updates distributorId only', () {
      final copy = base.copyWith(distributorId: 1111);
      expect(copy.distributorId, 1111);
      expect(copy.godownId, base.godownId); // unchanged
    });

    test('POSITIVE: updates godownId only', () {
      final copy = base.copyWith(godownId: 5);
      expect(copy.godownId, 5);
      expect(copy.distributorId, base.distributorId);
    });

    test('POSITIVE: updates itemId only', () {
      final copy = base.copyWith(itemId: 99);
      expect(copy.itemId, 99);
    });

    test('POSITIVE: updates itemName only', () {
      final copy = base.copyWith(itemName: '14 Kg');
      expect(copy.itemName, '14 Kg');
    });

    test('POSITIVE: updates currentStkFilled to new quantity', () {
      final copy = base.copyWith(currentStkFilled: 500);
      expect(copy.currentStkFilled, 500);
      expect(copy.currentStkEmpty, base.currentStkEmpty);
    });

    test('POSITIVE: updates currentStkEmpty to new quantity', () {
      final copy = base.copyWith(currentStkEmpty: 30);
      expect(copy.currentStkEmpty, 30);
    });

    test('POSITIVE: updates currentStkDefective to new quantity', () {
      final copy = base.copyWith(currentStkDefective: 5);
      expect(copy.currentStkDefective, 5);
    });

    test('POSITIVE: updates all stock quantities at once', () {
      final copy = base.copyWith(
        currentStkFilled: 100,
        currentStkEmpty: 50,
        currentStkDefective: 10,
      );
      expect(copy.currentStkFilled, 100);
      expect(copy.currentStkEmpty, 50);
      expect(copy.currentStkDefective, 10);
      expect(copy.distributorId, base.distributorId); // unchanged
    });

    test('POSITIVE: copyWith returns a distinct instance', () {
      final copy = base.copyWith();
      expect(identical(copy, base), isFalse);
    });

    test('POSITIVE: chaining copyWith twice gives independent copies', () {
      final copy1 = base.copyWith(currentStkFilled: 111);
      final copy2 = copy1.copyWith(currentStkFilled: 222);
      expect(copy1.currentStkFilled, 111);
      expect(copy2.currentStkFilled, 222);
    });

    test('NEGATIVE: copyWith does NOT mutate the original', () {
      base.copyWith(currentStkFilled: 9999);
      expect(base.currentStkFilled, 220); // original unchanged
    });

    test('NEGATIVE: passing null arg — falls back to original via ?? operator',
            () {
          final copy = base.copyWith(itemName: null);
          expect(copy.itemName, base.itemName); // not overridden
        });

    test('POSITIVE: can set currentStkFilled to 0 via copyWith', () {
      final baseFilled = GetCurrentStcOfGodownKeeperModel(
          currentStkFilled: 100);
      // Note: passing 0 uses the ?? operator — 0 is falsy for ?? only if null;
      // 0 is NOT null so it should override correctly.
      final copy = baseFilled.copyWith(currentStkFilled: 0);
      expect(copy.currentStkFilled, 0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 5 — Getters
  // ───────────────────────────────────────────────────────────────────────────
  group('Getters —', () {
    test('POSITIVE: all getters return correct types', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      expect(model.distributorId, isA<num>());
      expect(model.godownId, isA<num>());
      expect(model.itemId, isA<num>());
      expect(model.itemName, isA<String>());
      expect(model.currentStkFilled, isA<num>());
      expect(model.currentStkEmpty, isA<num>());
      expect(model.currentStkDefective, isA<num>());
    });

    test('POSITIVE: currentStkFilled getter returns 220 from valid JSON', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      expect(model.currentStkFilled, 220);
    });

    test('POSITIVE: currentStkEmpty getter returns 0 from valid JSON', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      expect(model.currentStkEmpty, 0);
    });

    test('POSITIVE: currentStkDefective getter returns 0 from valid JSON',
            () {
          final model =
          GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
          expect(model.currentStkDefective, 0);
        });

    test('NEGATIVE: all getters null when no args passed', () {
      final model = GetCurrentStcOfGodownKeeperModel();
      expect(model.distributorId, isNull);
      expect(model.godownId, isNull);
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.currentStkFilled, isNull);
      expect(model.currentStkEmpty, isNull);
      expect(model.currentStkDefective, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 6 — Business Logic / Stock Calculation Helpers
  // ───────────────────────────────────────────────────────────────────────────
  group('Stock business logic —', () {
    test('POSITIVE: totalStock = filled + empty + defective', () {
      final model = GetCurrentStcOfGodownKeeperModel(
        currentStkFilled: 220,
        currentStkEmpty: 15,
        currentStkDefective: 5,
      );
      final total = (model.currentStkFilled ?? 0) +
          (model.currentStkEmpty ?? 0) +
          (model.currentStkDefective ?? 0);
      expect(total, 240);
    });

    test('POSITIVE: all-zero stock totals to zero', () {
      final model = GetCurrentStcOfGodownKeeperModel(
        currentStkFilled: 0,
        currentStkEmpty: 0,
        currentStkDefective: 0,
      );
      final total = (model.currentStkFilled ?? 0) +
          (model.currentStkEmpty ?? 0) +
          (model.currentStkDefective ?? 0);
      expect(total, 0);
    });

    test('POSITIVE: model correctly identifies when filled stock is zero', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(currentStkFilled: 0);
      expect(model.currentStkFilled == 0, isTrue);
    });

    test('POSITIVE: model correctly identifies when filled stock is positive',
            () {
          final model =
          GetCurrentStcOfGodownKeeperModel(currentStkFilled: 220);
          expect((model.currentStkFilled ?? 0) > 0, isTrue);
        });

    test('NEGATIVE: null stock treated as 0 in calculation', () {
      final model = GetCurrentStcOfGodownKeeperModel();
      final total = (model.currentStkFilled ?? 0) +
          (model.currentStkEmpty ?? 0) +
          (model.currentStkDefective ?? 0);
      expect(total, 0);
    });

    test('POSITIVE: list of models — find item by itemId', () {
      final models = [
        GetCurrentStcOfGodownKeeperModel(itemId: 1, itemName: '5 Kg'),
        GetCurrentStcOfGodownKeeperModel(itemId: 4, itemName: '2 Kg'),
        GetCurrentStcOfGodownKeeperModel(itemId: 7, itemName: '19 Kg'),
      ];
      final found = models.firstWhere((m) => m.itemId == 4);
      expect(found.itemName, '2 Kg');
    });

    test('NEGATIVE: model with negative defective stock does not crash', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(currentStkDefective: -3);
      expect(model.currentStkDefective, -3);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  // GROUP 7 — Edge Cases & Boundary Conditions
  // ───────────────────────────────────────────────────────────────────────────
  group('Edge cases —', () {
    test('POSITIVE: godownId = 1 (first godown) is valid', () {
      final model =
      GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
      expect(model.godownId, 1);
    });

    test('POSITIVE: unicode itemName is stored correctly', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(itemName: '2 किलो गैस');
      expect(model.itemName, '2 किलो गैस');
    });

    test('POSITIVE: very large stock number is stored correctly', () {
      final model = GetCurrentStcOfGodownKeeperModel(
          currentStkFilled: 9999999);
      expect(model.currentStkFilled, 9999999);
    });

    test('POSITIVE: two models with same data have identical getter values',
            () {
          final m1 =
          GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
          final m2 =
          GetCurrentStcOfGodownKeeperModel.fromJson(_validJson());
          expect(m1.distributorId, m2.distributorId);
          expect(m1.currentStkFilled, m2.currentStkFilled);
        });

    test('POSITIVE: list of models parsed from JSON array', () {
      final jsonList = [
        _validJson(),
        {
          'DistributorId': 8118,
          'GodownId': 2,
          'ItemId': 5,
          'ItemName': '5 Kg',
          'CurrentStkFilled': 100,
          'CurrentStkEmpty': 10,
          'CurrentStkDefective': 2,
        }
      ];
      final models = jsonList
          .map((j) => GetCurrentStcOfGodownKeeperModel.fromJson(j))
          .toList();
      expect(models.length, 2);
      expect(models[0].itemName, '2 Kg');
      expect(models[1].itemName, '5 Kg');
      expect(models[1].currentStkFilled, 100);
    });

    test('NEGATIVE: fromJson with boolean CurrentStkFilled does not throw',
            () {
          expect(
                  () => GetCurrentStcOfGodownKeeperModel.fromJson(
                  {'CurrentStkFilled': true}),
              returnsNormally);
        });

    test('NEGATIVE: fromJson with empty map yields all-null model', () {
      final model = GetCurrentStcOfGodownKeeperModel.fromJson(
          <String, dynamic>{});
      expect(model.currentStkFilled, isNull);
      expect(model.itemName, isNull);
    });

    test('NEGATIVE: itemName with only whitespace is stored as-is', () {
      final model =
      GetCurrentStcOfGodownKeeperModel(itemName: '   ');
      expect(model.itemName, '   ');
    });

    test('POSITIVE: stress — 100 models from JSON list parsed without error',
            () {
          final jsonList = List.generate(100, (i) => {
            'DistributorId': 8118,
            'GodownId': i + 1,
            'ItemId': i,
            'ItemName': 'Item$i',
            'CurrentStkFilled': i * 10,
            'CurrentStkEmpty': 0,
            'CurrentStkDefective': 0,
          });
          final models = jsonList
              .map((j) => GetCurrentStcOfGodownKeeperModel.fromJson(j))
              .toList();
          expect(models.length, 100);
          expect(models[0].itemName, 'Item0');
          expect(models[99].itemName, 'Item99');
          expect(models[99].currentStkFilled, 990);
        });
  });
}