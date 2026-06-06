import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/RefillProfitDetailDataGetModel.dart';

// ── Adjust import path to match your project structure ────────────────────
// ─────────────────────────────────────────────────────────────────────────

void main() {
  group('RefillProfitDetailDataGetModel', () {
    final validJson = {
      'DistributorId': 8118,
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'SaleQty': 160,
      'GrossRevenue': 136880.00,
      'GrossProfit': 12240.00,
    };

    // ── fromJson ────────────────────────────────────────────────────────────
    group('fromJson', () {
      test('parses all fields correctly from valid JSON', () {
        final model = RefillProfitDetailDataGetModel.fromJson(validJson);

        expect(model.distributorId, 8118);
        expect(model.itemId, 1);
        expect(model.itemName, '14.2 KG');
        expect(model.saleQty, 160);
        expect(model.grossRevenue, 136880.00);
        expect(model.grossProfit, 12240.00);
      });

      test('all fields are null when JSON is empty', () {
        final model = RefillProfitDetailDataGetModel.fromJson({});

        expect(model.distributorId, isNull);
        expect(model.itemId, isNull);
        expect(model.itemName, isNull);
        expect(model.saleQty, isNull);
        expect(model.grossRevenue, isNull);
        expect(model.grossProfit, isNull);
      });

      test('handles explicit null values inside JSON without throwing', () {
        final model = RefillProfitDetailDataGetModel.fromJson({
          'DistributorId': null,
          'ItemId': null,
          'ItemName': null,
          'SaleQty': null,
          'GrossRevenue': null,
          'GrossProfit': null,
        });

        expect(model.distributorId, isNull);
        expect(model.grossProfit, isNull);
      });

      test('accepts integer grossRevenue and grossProfit (num type)', () {
        final model = RefillProfitDetailDataGetModel.fromJson({
          ...validJson,
          'GrossRevenue': 100000,
          'GrossProfit': 5000,
        });

        expect(model.grossRevenue, 100000);
        expect(model.grossProfit, 5000);
      });

      test('parses a decoded JSON string end-to-end', () {
        final model = RefillProfitDetailDataGetModel.fromJson(
            jsonDecode(jsonEncode(validJson)));

        expect(model.itemName, '14.2 KG');
        expect(model.saleQty, 160);
      });

      test('distributorId is stored as num, not int specifically', () {
        final model = RefillProfitDetailDataGetModel.fromJson(validJson);

        expect(model.distributorId, isA<num>());
      });
    });

    // ── Named constructor ───────────────────────────────────────────────────
    group('named constructor', () {
      test('assigns all provided values correctly', () {
        final model = RefillProfitDetailDataGetModel(
          distributorId: 1,
          itemId: 2,
          itemName: 'Test Item',
          saleQty: 50,
          grossRevenue: 5000,
          grossProfit: 500,
        );

        expect(model.distributorId, 1);
        expect(model.itemId, 2);
        expect(model.itemName, 'Test Item');
        expect(model.saleQty, 50);
        expect(model.grossRevenue, 5000);
        expect(model.grossProfit, 500);
      });

      test('all fields default to null when no arguments provided', () {
        final model = RefillProfitDetailDataGetModel();

        expect(model.distributorId, isNull);
        expect(model.itemId, isNull);
        expect(model.itemName, isNull);
        expect(model.saleQty, isNull);
        expect(model.grossRevenue, isNull);
        expect(model.grossProfit, isNull);
      });
    });

    // ── toJson ──────────────────────────────────────────────────────────────
    group('toJson', () {
      test('serialises all fields with correct API key names', () {
        final map = RefillProfitDetailDataGetModel.fromJson(validJson).toJson();

        expect(map['DistributorId'], 8118);
        expect(map['ItemId'], 1);
        expect(map['ItemName'], '14.2 KG');
        expect(map['SaleQty'], 160);
        expect(map['GrossRevenue'], 136880.00);
        expect(map['GrossProfit'], 12240.00);
      });

      test('output contains exactly the expected 6 keys', () {
        final map = RefillProfitDetailDataGetModel.fromJson(validJson).toJson();

        expect(
          map.keys.toSet(),
          containsAll([
            'DistributorId',
            'ItemId',
            'ItemName',
            'SaleQty',
            'GrossRevenue',
            'GrossProfit',
          ]),
        );
        expect(map.keys.length, 6);
      });

      test('fromJson → toJson round-trip preserves all values', () {
        final original = RefillProfitDetailDataGetModel.fromJson(validJson);
        final restored =
            RefillProfitDetailDataGetModel.fromJson(original.toJson());

        expect(restored.distributorId, original.distributorId);
        expect(restored.itemId, original.itemId);
        expect(restored.itemName, original.itemName);
        expect(restored.saleQty, original.saleQty);
        expect(restored.grossRevenue, original.grossRevenue);
        expect(restored.grossProfit, original.grossProfit);
      });

      test('toJson outputs null values when fields are unset', () {
        final map = RefillProfitDetailDataGetModel().toJson();

        expect(map['DistributorId'], isNull);
        expect(map['GrossProfit'], isNull);
      });
    });

    // ── copyWith ────────────────────────────────────────────────────────────
    group('copyWith', () {
      test('overrides only the specified fields', () {
        final original = RefillProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith(saleQty: 999, grossProfit: 0);

        expect(copy.saleQty, 999);
        expect(copy.grossProfit, 0);
        expect(copy.distributorId, original.distributorId);
        expect(copy.itemName, original.itemName);
        expect(copy.grossRevenue, original.grossRevenue);
      });

      test('returns a new instance, not the same reference', () {
        final original = RefillProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith(itemName: 'New Item');

        expect(identical(original, copy), isFalse);
        expect(copy.itemName, 'New Item');
        expect(original.itemName, '14.2 KG');
      });

      test('preserves all fields when no arguments are passed', () {
        final original = RefillProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith();

        expect(copy.distributorId, original.distributorId);
        expect(copy.saleQty, original.saleQty);
        expect(copy.grossRevenue, original.grossRevenue);
        expect(copy.grossProfit, original.grossProfit);
      });

      test('can update grossRevenue independently', () {
        final original = RefillProfitDetailDataGetModel.fromJson(validJson);
        final copy = original.copyWith(grossRevenue: 200000.0);

        expect(copy.grossRevenue, 200000.0);
        expect(copy.grossProfit, original.grossProfit);
      });
    });

    // ── List parsing ────────────────────────────────────────────────────────
    group('list parsing', () {
      test('parses a JSON array into a list of models', () {
        final secondJson = {
          'DistributorId': 8118,
          'ItemId': 2,
          'ItemName': '19 KG',
          'SaleQty': 80,
          'GrossRevenue': 50000.0,
          'GrossProfit': 4000.0,
        };
        final list =
            (jsonDecode(jsonEncode([validJson, secondJson])) as List)
                .map((j) => RefillProfitDetailDataGetModel.fromJson(j))
                .toList();

        expect(list.length, 2);
        expect(list[0].itemName, '14.2 KG');
        expect(list[1].itemName, '19 KG');
      });

      test('computes total grossProfit across all items', () {
        final records = [
          {'GrossProfit': 12240.0},
          {'GrossProfit': 8000.0},
          {'GrossProfit': 5000.0},
        ];
        final list = records
            .map((j) => RefillProfitDetailDataGetModel.fromJson(j))
            .toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.grossProfit ?? 0));

        expect(total, 25240.0);
      });

      test('computes total saleQty across all items', () {
        final records = [
          {'SaleQty': 160},
          {'SaleQty': 80},
          {'SaleQty': 40},
        ];
        final list = records
            .map((j) => RefillProfitDetailDataGetModel.fromJson(j))
            .toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.saleQty ?? 0));

        expect(total, 280);
      });

      test('empty JSON array returns empty list', () {
        final list = (jsonDecode('[]') as List)
            .map((j) => RefillProfitDetailDataGetModel.fromJson(j))
            .toList();

        expect(list, isEmpty);
      });
    });
  });
}
