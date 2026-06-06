import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/TodaysCashSummaryOnAccountListModel.dart';

// ── Adjust import path to match your project structure ────────────────────
// ─────────────────────────────────────────────────────────────────────────

void main() {
  group('TodaysCashSummaryOnAccountListModel', () {
    final validJson = {
      'DistributorId': 8118,
      'StaffId': 44,
      'StaffName': '19kg Devendra',
      'StaffOnAccToday': 0.00,
      'StaffOnAccAsOf': 117720.00,
    };

    final activeStaffJson = {
      'DistributorId': 8118,
      'StaffId': 55,
      'StaffName': 'Rajan Patil',
      'StaffOnAccToday': 3500.00,
      'StaffOnAccAsOf': 45000.00,
    };

    // ── fromJson ────────────────────────────────────────────────────────────
    group('fromJson', () {
      test('parses all fields correctly from valid JSON', () {
        final model =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);

        expect(model.distributorId, 8118);
        expect(model.staffId, 44);
        expect(model.staffName, '19kg Devendra');
        expect(model.staffOnAccToday, 0.00);
        expect(model.staffOnAccAsOf, 117720.00);
      });

      test('all fields are null when JSON is empty', () {
        final model = TodaysCashSummaryOnAccountListModel.fromJson({});

        expect(model.distributorId, isNull);
        expect(model.staffId, isNull);
        expect(model.staffName, isNull);
        expect(model.staffOnAccToday, isNull);
        expect(model.staffOnAccAsOf, isNull);
      });

      test('handles explicit null values in JSON without throwing', () {
        final model = TodaysCashSummaryOnAccountListModel.fromJson({
          'DistributorId': null,
          'StaffId': null,
          'StaffName': null,
          'StaffOnAccToday': null,
          'StaffOnAccAsOf': null,
        });

        expect(model.staffName, isNull);
        expect(model.staffOnAccToday, isNull);
        expect(model.staffOnAccAsOf, isNull);
      });

      test('staffOnAccToday of 0.00 is stored as 0, not null', () {
        final model =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);

        expect(model.staffOnAccToday, 0.00);
        expect(model.staffOnAccToday, isNotNull);
      });

      test('parses large staffOnAccAsOf value without precision loss', () {
        final model = TodaysCashSummaryOnAccountListModel.fromJson({
          ...validJson,
          'StaffOnAccAsOf': 9999999.99,
        });

        expect(model.staffOnAccAsOf, 9999999.99);
      });

      test('parses non-zero staffOnAccToday correctly', () {
        final model =
            TodaysCashSummaryOnAccountListModel.fromJson(activeStaffJson);

        expect(model.staffOnAccToday, 3500.00);
        expect(model.staffOnAccAsOf, 45000.00);
      });

      test('staffId is stored as num type', () {
        final model =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);

        expect(model.staffId, isA<num>());
      });

      test('parses from a decoded JSON string end-to-end', () {
        final model = TodaysCashSummaryOnAccountListModel.fromJson(
            jsonDecode(jsonEncode(validJson)));

        expect(model.staffName, '19kg Devendra');
        expect(model.staffOnAccAsOf, 117720.00);
      });
    });

    // ── Named constructor ───────────────────────────────────────────────────
    group('named constructor', () {
      test('assigns all provided values correctly', () {
        final model = TodaysCashSummaryOnAccountListModel(
          distributorId: 1,
          staffId: 10,
          staffName: 'Test Staff',
          staffOnAccToday: 500.0,
          staffOnAccAsOf: 10000.0,
        );

        expect(model.distributorId, 1);
        expect(model.staffId, 10);
        expect(model.staffName, 'Test Staff');
        expect(model.staffOnAccToday, 500.0);
        expect(model.staffOnAccAsOf, 10000.0);
      });

      test('all fields default to null when no arguments provided', () {
        final model = TodaysCashSummaryOnAccountListModel();

        expect(model.distributorId, isNull);
        expect(model.staffId, isNull);
        expect(model.staffName, isNull);
        expect(model.staffOnAccToday, isNull);
        expect(model.staffOnAccAsOf, isNull);
      });
    });

    // ── toJson ──────────────────────────────────────────────────────────────
    group('toJson', () {
      test('serialises all fields with correct API key names', () {
        final map = TodaysCashSummaryOnAccountListModel.fromJson(validJson)
            .toJson();

        expect(map['DistributorId'], 8118);
        expect(map['StaffId'], 44);
        expect(map['StaffName'], '19kg Devendra');
        expect(map['StaffOnAccToday'], 0.00);
        expect(map['StaffOnAccAsOf'], 117720.00);
      });

      test('output contains exactly the expected 5 keys', () {
        final map = TodaysCashSummaryOnAccountListModel.fromJson(validJson)
            .toJson();

        expect(
          map.keys.toSet(),
          containsAll([
            'DistributorId',
            'StaffId',
            'StaffName',
            'StaffOnAccToday',
            'StaffOnAccAsOf',
          ]),
        );
        expect(map.keys.length, 5);
      });

      test('fromJson → toJson round-trip preserves all values', () {
        final original =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);
        final restored = TodaysCashSummaryOnAccountListModel.fromJson(
            original.toJson());

        expect(restored.distributorId, original.distributorId);
        expect(restored.staffId, original.staffId);
        expect(restored.staffName, original.staffName);
        expect(restored.staffOnAccToday, original.staffOnAccToday);
        expect(restored.staffOnAccAsOf, original.staffOnAccAsOf);
      });

      test('toJson preserves zero value for staffOnAccToday', () {
        final map = TodaysCashSummaryOnAccountListModel.fromJson(validJson)
            .toJson();

        expect(map['StaffOnAccToday'], 0.00);
        expect(map['StaffOnAccToday'], isNotNull);
      });

      test('toJson outputs null when fields are unset', () {
        final map = TodaysCashSummaryOnAccountListModel().toJson();

        expect(map['StaffName'], isNull);
        expect(map['StaffOnAccAsOf'], isNull);
      });
    });

    // ── copyWith ────────────────────────────────────────────────────────────
    group('copyWith', () {
      test('overrides only the specified fields', () {
        final original =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);
        final copy =
            original.copyWith(staffName: 'New Name', staffOnAccToday: 250.0);

        expect(copy.staffName, 'New Name');
        expect(copy.staffOnAccToday, 250.0);
        expect(copy.staffId, original.staffId);
        expect(copy.staffOnAccAsOf, original.staffOnAccAsOf);
      });

      test('returns a new instance, not the same reference', () {
        final original =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);
        final copy = original.copyWith(staffId: 99);

        expect(identical(original, copy), isFalse);
        expect(copy.staffId, 99);
        expect(original.staffId, 44);
      });

      test('preserves all fields when no arguments are passed', () {
        final original =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);
        final copy = original.copyWith();

        expect(copy.staffOnAccAsOf, original.staffOnAccAsOf);
        expect(copy.staffOnAccToday, original.staffOnAccToday);
        expect(copy.staffName, original.staffName);
      });

      test('can update staffOnAccAsOf independently', () {
        final original =
            TodaysCashSummaryOnAccountListModel.fromJson(validJson);
        final copy = original.copyWith(staffOnAccAsOf: 200000.0);

        expect(copy.staffOnAccAsOf, 200000.0);
        expect(copy.staffName, original.staffName);
        expect(copy.staffOnAccToday, original.staffOnAccToday);
      });
    });

    // ── List parsing & aggregation ───────────────────────────────────────
    group('list parsing & aggregation', () {
      test('parses a JSON array into a list of models', () {
        final list =
            (jsonDecode(jsonEncode([validJson, activeStaffJson])) as List)
                .map((j) =>
                    TodaysCashSummaryOnAccountListModel.fromJson(j))
                .toList();

        expect(list.length, 2);
        expect(list[0].staffName, '19kg Devendra');
        expect(list[1].staffName, 'Rajan Patil');
      });

      test('computes total on-account balance (AsOf) across all staff', () {
        final records = [
          {'StaffOnAccAsOf': 117720.0},
          {'StaffOnAccAsOf': 45000.0},
          {'StaffOnAccAsOf': 20000.0},
        ];
        final list = records
            .map((j) => TodaysCashSummaryOnAccountListModel.fromJson(j))
            .toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.staffOnAccAsOf ?? 0));

        expect(total, 182720.0);
      });

      test("computes total today's on-account collection", () {
        final records = [
          {'StaffOnAccToday': 0.0},
          {'StaffOnAccToday': 3500.0},
          {'StaffOnAccToday': 1200.0},
        ];
        final list = records
            .map((j) => TodaysCashSummaryOnAccountListModel.fromJson(j))
            .toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.staffOnAccToday ?? 0));

        expect(total, 4700.0);
      });

      test('filters staff with non-zero staffOnAccToday', () {
        final list =
            (jsonDecode(jsonEncode([validJson, activeStaffJson])) as List)
                .map((j) =>
                    TodaysCashSummaryOnAccountListModel.fromJson(j))
                .where((m) => (m.staffOnAccToday ?? 0) > 0)
                .toList();

        expect(list.length, 1);
        expect(list.first.staffName, 'Rajan Patil');
      });

      test('empty JSON array returns empty list', () {
        final list = (jsonDecode('[]') as List)
            .map((j) =>
                TodaysCashSummaryOnAccountListModel.fromJson(j))
            .toList();

        expect(list, isEmpty);
      });
    });
  });
}
