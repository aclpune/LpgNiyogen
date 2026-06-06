import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/SVProfitDetailDataGetModel.dart';

// ── Adjust import path to match your project structure ────────────────────
// ─────────────────────────────────────────────────────────────────────────

void main() {
  group('SvProfitDetailDataGetModel', () {
    final validJson = {
      'DistributorId': 8118,
      'ItemId': 15,
      'ItemName': 'Stove Inspection charges',
      'ItemQty': 51,
      'ProfitAmt': 12283.00,
    };

    // ── fromJson ────────────────────────────────────────────────────────────
    group('fromJson', () {
      test('parses all fields correctly from valid JSON', () {
        final model = SvProfitDetailDataGetModel.fromJson(validJson);

        expect(model.distributorId, 8118);
        expect(model.itemId, 15);
        expect(model.itemName, 'Stove Inspection charges');
        expect(model.itemQty, 51);
        expect(model.profitAmt, 12283.00);
      });

      test('all fields are null when JSON is empty', () {
        final model = SvProfitDetailDataGetModel.fromJson({});

        expect(model.distributorId, isNull);
        expect(model.itemId, isNull);
        expect(model.itemName, isNull);
        expect(model.itemQty, isNull);
        expect(model.profitAmt, isNull);
      });

      test('handles explicit null values in JSON without throwing', () {
        final model = SvProfitDetailDataGetModel.fromJson({
          'DistributorId': null,
          'ItemId': null,
          'ItemName': null,
          'ItemQty': null,
          'ProfitAmt': null,
        });

        expect(model.itemName, isNull);
        expect(model.profitAmt, isNull);
      });

      test('accepts integer profitAmt (num type)', () {
        final model = SvProfitDetailDataGetModel.fromJson({
          ...validJson,
          'ProfitAmt': 5000,
        });

        expect(model.profitAmt, 5000);
        expect(model.profitAmt, isA<num>());
      });

      test('accepts zero profitAmt and stores it as 0, not null', () {
        final model = SvProfitDetailDataGetModel.fromJson({
          ...validJson,
          'ProfitAmt': 0.0,
        });

        expect(model.profitAmt, 0.0);
        expect(model.profitAmt, isNotNull);
      });

      test('parses from a decoded JSON string end-to-end', () {
        final model = SvProfitDetailDataGetModel.fromJson(
            jsonDecode(jsonEncode(validJson)));

        expect(model.itemName, 'Stove Inspection charges');
        expect(model.itemQty, 51);
      });

      test('distributorId is stored as num type', () {
        final model = SvProfitDetailDataGetModel.fromJson(validJson);

        expect(model.distributorId, isA<num>());
      });
    });

    // ── Named constructor ───────────────────────────────────────────────────
    group('named constructor', () {
      test('assigns all provided values correctly', () {
        final model = SvProfitDetailDataGetModel(
          distributorId: 10,
          itemId: 20,
          itemName: 'Safety Check',
          itemQty: 30,
          profitAmt: 3000.0,
        );

        expect(model.distributorId, 10);
        expect(model.itemId, 20);
        expect(model.itemName, 'Safety Check');
        expect(model.itemQty, 30);
        expect(model.profitAmt, 3000.0);
      });

      test('all fields default to null when no arguments provided', () {
        final model = SvProfitDetailDataGetModel();

        expect(model.distributorId, isNull);
        expect(model.itemId, isNull);
        expect(model.itemName, isNull);
        expect(model.itemQty, isNull);
        expect(model.profitAmt, isNull);
      });
    });

    // ── toJson ──────────────────────────────────────────────────────────────
    group('toJson', () {
      test('serialises all fields with correct API key names', () {
        final map = SvProfitDetailDataGetModel.fromJson(validJson).toJson();

        expect(map['DistributorId'], 8118);
        expect(map['ItemId'], 15);
        expect(map['ItemName'], 'Stove Inspection charges');
        expect(map['ItemQty'], 51);
        expect(map['ProfitAmt'], 12283.00);
      });

      test('output contains exactly the expected 5 keys', () {
        final map = SvProfitDetailDataGetModel.fromJson(validJson).toJson();

        expect(
          map.keys.toSet(),
          containsAll([
            'DistributorId',
            'ItemId',
            'ItemName',
            'ItemQty',
            'ProfitAmt',
          ]),
        );
        expect(map.keys.length, 5);
      });

      test('fromJson → toJson round-trip preserves all values', () {
        final original = SvProfitDetailDataGetModel.fromJson(validJson);
        final restored =
            SvProfitDetailDataGetModel.fromJson(original.toJson());

        expect(restored.distributorId, original.distributorId);
        expect(restored.itemId, original.itemId);
        expect(restored.itemName, original.itemName);
        expect(restored.itemQty, original.itemQty);
        expect(restored.profitAmt, original.profitAmt);
      });

      test('toJson outputs null values when fields are unset', () {
        final map = SvProfitDetailDataGetModel().toJson();

        expect(map['ItemName'], isNull);
        expect(map['ProfitAmt'], isNull);
      });
    });

    // ── copyWith ────────────────────────────────────────────────────────────
    group('copyWith', () {
      test('overrides only the specified fields', () {
        final original = SvProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith(itemQty: 100, profitAmt: 9999.0);

        expect(copy.itemQty, 100);
        expect(copy.profitAmt, 9999.0);
        expect(copy.itemName, original.itemName);
        expect(copy.distributorId, original.distributorId);
      });

      test('returns a new instance, not the same reference', () {
        final original = SvProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith(itemName: 'Updated Service');

        expect(identical(original, copy), isFalse);
        expect(copy.itemName, 'Updated Service');
        expect(original.itemName, 'Stove Inspection charges');
      });

      test('preserves all fields when no arguments are passed', () {
        final original = SvProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith();

        expect(copy.distributorId, original.distributorId);
        expect(copy.itemId, original.itemId);
        expect(copy.itemQty, original.itemQty);
        expect(copy.profitAmt, original.profitAmt);
      });

      test('can update profitAmt independently without changing itemQty', () {
        final original = SvProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith(profitAmt: 0.0);

        expect(copy.profitAmt, 0.0);
        expect(copy.itemQty, original.itemQty);
      });
    });

    // ── List parsing & aggregation ───────────────────────────────────────
    group('list parsing & aggregation', () {
      final secondJson = {
        'DistributorId': 8118,
        'ItemId': 16,
        'ItemName': 'Pipe Inspection charges',
        'ItemQty': 30,
        'ProfitAmt': 6000.00,
      };

      test('parses a JSON array into a list of models', () {
        final list =
            (jsonDecode(jsonEncode([validJson, secondJson])) as List)
                .map((j) => SvProfitDetailDataGetModel.fromJson(j))
                .toList();

        expect(list.length, 2);
        expect(list[0].itemName, 'Stove Inspection charges');
        expect(list[1].itemName, 'Pipe Inspection charges');
      });

      test('computes total profitAmt across all service items', () {
        final records = [
          {'ProfitAmt': 12283.0},
          {'ProfitAmt': 6000.0},
          {'ProfitAmt': 3500.0},
        ];
        final list =
            records.map((j) => SvProfitDetailDataGetModel.fromJson(j)).toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.profitAmt ?? 0));

        expect(total, 21783.0);
      });

      test('computes total itemQty across all service items', () {
        final records = [
          {'ItemQty': 51},
          {'ItemQty': 30},
          {'ItemQty': 19},
        ];
        final list =
            records.map((j) => SvProfitDetailDataGetModel.fromJson(j)).toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.itemQty ?? 0));

        expect(total, 100);
      });

      test('filters items by itemId', () {
        final list =
            (jsonDecode(jsonEncode([validJson, secondJson])) as List)
                .map((j) => SvProfitDetailDataGetModel.fromJson(j))
                .where((m) => m.itemId == 15)
                .toList();

        expect(list.length, 1);
        expect(list.first.itemName, 'Stove Inspection charges');
      });

      test('empty JSON array returns empty list', () {
        final list = (jsonDecode('[]') as List)
            .map((j) => SvProfitDetailDataGetModel.fromJson(j))
            .toList();

        expect(list, isEmpty);
      });
    });
  });
}
