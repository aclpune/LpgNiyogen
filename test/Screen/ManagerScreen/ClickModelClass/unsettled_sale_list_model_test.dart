import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/UnsettledSaleListModel.dart';

// ── Adjust import path to match your project structure ────────────────────
// ─────────────────────────────────────────────────────────────────────────

void main() {
  group('UnsettledSaleListModel', () {
    // All-zero baseline record (as returned by API for uninitialised entries)
    final zeroJson = {
      'DistributorId': 8118,
      'Transdate': '0001-01-01T00:00:00',
      'ItemId': 1,
      'ItemName': '14.2 Kg',
      'RSPPrice': 0.0,
      'StaffId': 29,
      'StaffName': 'Shivaji Jambhale',
      'TotalSaleQty': 0,
      'DelSVQty': 0,
      'UnsettQty': 0,
      'UnsettSaleAmt': 0.00,
    };

    // Realistic record with actual unsettled quantities
    final activeJson = {
      'DistributorId': 8118,
      'Transdate': '2024-06-15T10:30:00',
      'ItemId': 2,
      'ItemName': '19 Kg',
      'RSPPrice': 1800.50,
      'StaffId': 31,
      'StaffName': 'Rajan Patil',
      'TotalSaleQty': 100,
      'DelSVQty': 90,
      'UnsettQty': 10,
      'UnsettSaleAmt': 18005.00,
    };

    // ── fromJson ────────────────────────────────────────────────────────────
    group('fromJson', () {
      test('parses all 11 fields correctly from the zero baseline JSON', () {
        final model = UnsettledSaleListModel.fromJson(zeroJson);

        expect(model.distributorId, 8118);
        expect(model.transdate, '0001-01-01T00:00:00');
        expect(model.itemId, 1);
        expect(model.itemName, '14.2 Kg');
        expect(model.rSPPrice, 0.0);
        expect(model.staffId, 29);
        expect(model.staffName, 'Shivaji Jambhale');
        expect(model.totalSaleQty, 0);
        expect(model.delSVQty, 0);
        expect(model.unsettQty, 0);
        expect(model.unsettSaleAmt, 0.00);
      });

      test('parses all fields from an active realistic JSON record', () {
        final model = UnsettledSaleListModel.fromJson(activeJson);

        expect(model.itemName, '19 Kg');
        expect(model.rSPPrice, 1800.50);
        expect(model.totalSaleQty, 100);
        expect(model.delSVQty, 90);
        expect(model.unsettQty, 10);
        expect(model.unsettSaleAmt, 18005.00);
        expect(model.transdate, '2024-06-15T10:30:00');
      });

      test('all fields are null when JSON is empty', () {
        final model = UnsettledSaleListModel.fromJson({});

        expect(model.distributorId, isNull);
        expect(model.transdate, isNull);
        expect(model.itemId, isNull);
        expect(model.itemName, isNull);
        expect(model.rSPPrice, isNull);
        expect(model.staffId, isNull);
        expect(model.staffName, isNull);
        expect(model.totalSaleQty, isNull);
        expect(model.delSVQty, isNull);
        expect(model.unsettQty, isNull);
        expect(model.unsettSaleAmt, isNull);
      });

      test('handles explicit null values in JSON without throwing', () {
        final model = UnsettledSaleListModel.fromJson({
          'DistributorId': null,
          'Transdate': null,
          'ItemId': null,
          'ItemName': null,
          'RSPPrice': null,
          'StaffId': null,
          'StaffName': null,
          'TotalSaleQty': null,
          'DelSVQty': null,
          'UnsettQty': null,
          'UnsettSaleAmt': null,
        });

        expect(model.staffName, isNull);
        expect(model.unsettSaleAmt, isNull);
      });

      test('zero numeric values are stored as 0, not treated as null', () {
        final model = UnsettledSaleListModel.fromJson(zeroJson);

        expect(model.rSPPrice, isNotNull);
        expect(model.unsettSaleAmt, isNotNull);
        expect(model.totalSaleQty, isNotNull);
        expect(model.rSPPrice, 0.0);
        expect(model.unsettQty, 0);
      });

      test('transdate string is stored verbatim', () {
        final model = UnsettledSaleListModel.fromJson(activeJson);

        expect(model.transdate, '2024-06-15T10:30:00');
      });

      test('rSPPrice is stored as num type', () {
        final model = UnsettledSaleListModel.fromJson(activeJson);

        expect(model.rSPPrice, isA<num>());
      });

      test('parses from a decoded JSON string end-to-end', () {
        final model = UnsettledSaleListModel.fromJson(
            jsonDecode(jsonEncode(activeJson)));

        expect(model.staffName, 'Rajan Patil');
        expect(model.unsettQty, 10);
        expect(model.unsettSaleAmt, 18005.00);
      });
    });

    // ── Named constructor ───────────────────────────────────────────────────
    group('named constructor', () {
      test('assigns all provided values correctly', () {
        final model = UnsettledSaleListModel(
          distributorId: 1,
          transdate: '2024-01-01T00:00:00',
          itemId: 3,
          itemName: 'Test Cylinder',
          rSPPrice: 850.0,
          staffId: 5,
          staffName: 'Test Staff',
          totalSaleQty: 20,
          delSVQty: 18,
          unsettQty: 2,
          unsettSaleAmt: 1700.0,
        );

        expect(model.itemName, 'Test Cylinder');
        expect(model.unsettQty, 2);
        expect(model.unsettSaleAmt, 1700.0);
        expect(model.transdate, '2024-01-01T00:00:00');
        expect(model.delSVQty, 18);
      });

      test('all fields default to null when no arguments provided', () {
        final model = UnsettledSaleListModel();

        expect(model.distributorId, isNull);
        expect(model.transdate, isNull);
        expect(model.itemName, isNull);
        expect(model.unsettSaleAmt, isNull);
        expect(model.staffName, isNull);
      });
    });

    // ── toJson ──────────────────────────────────────────────────────────────
    group('toJson', () {
      test('serialises all fields with correct API key names', () {
        final map = UnsettledSaleListModel.fromJson(activeJson).toJson();

        expect(map['DistributorId'], 8118);
        expect(map['Transdate'], '2024-06-15T10:30:00');
        expect(map['ItemId'], 2);
        expect(map['ItemName'], '19 Kg');
        expect(map['RSPPrice'], 1800.50);
        expect(map['StaffId'], 31);
        expect(map['StaffName'], 'Rajan Patil');
        expect(map['TotalSaleQty'], 100);
        expect(map['DelSVQty'], 90);
        expect(map['UnsettQty'], 10);
        expect(map['UnsettSaleAmt'], 18005.00);
      });

      test('output contains exactly 11 keys', () {
        final map = UnsettledSaleListModel.fromJson(activeJson).toJson();

        expect(
          map.keys.toSet(),
          containsAll([
            'DistributorId',
            'Transdate',
            'ItemId',
            'ItemName',
            'RSPPrice',
            'StaffId',
            'StaffName',
            'TotalSaleQty',
            'DelSVQty',
            'UnsettQty',
            'UnsettSaleAmt',
          ]),
        );
        expect(map.keys.length, 11);
      });

      test('fromJson → toJson round-trip preserves all values', () {
        final original = UnsettledSaleListModel.fromJson(activeJson);
        final restored =
            UnsettledSaleListModel.fromJson(original.toJson());

        expect(restored.distributorId, original.distributorId);
        expect(restored.transdate, original.transdate);
        expect(restored.itemId, original.itemId);
        expect(restored.itemName, original.itemName);
        expect(restored.rSPPrice, original.rSPPrice);
        expect(restored.staffId, original.staffId);
        expect(restored.staffName, original.staffName);
        expect(restored.totalSaleQty, original.totalSaleQty);
        expect(restored.delSVQty, original.delSVQty);
        expect(restored.unsettQty, original.unsettQty);
        expect(restored.unsettSaleAmt, original.unsettSaleAmt);
      });

      test('toJson preserves zero values for all numeric fields', () {
        final map = UnsettledSaleListModel.fromJson(zeroJson).toJson();

        expect(map['RSPPrice'], 0.0);
        expect(map['TotalSaleQty'], 0);
        expect(map['DelSVQty'], 0);
        expect(map['UnsettQty'], 0);
        expect(map['UnsettSaleAmt'], 0.00);
      });

      test('toJson outputs null values when fields are unset', () {
        final map = UnsettledSaleListModel().toJson();

        expect(map['StaffName'], isNull);
        expect(map['UnsettSaleAmt'], isNull);
        expect(map['Transdate'], isNull);
      });
    });

    // ── copyWith ────────────────────────────────────────────────────────────
    group('copyWith', () {
      test('overrides only the specified fields', () {
        final original = UnsettledSaleListModel.fromJson(activeJson);
        final copy = original.copyWith(unsettQty: 0, unsettSaleAmt: 0.0);

        expect(copy.unsettQty, 0);
        expect(copy.unsettSaleAmt, 0.0);
        expect(copy.staffName, original.staffName);
        expect(copy.totalSaleQty, original.totalSaleQty);
        expect(copy.transdate, original.transdate);
      });

      test('returns a new instance, not the same reference', () {
        final original = UnsettledSaleListModel.fromJson(activeJson);
        final copy = original.copyWith(itemName: 'Changed');

        expect(identical(original, copy), isFalse);
        expect(copy.itemName, 'Changed');
        expect(original.itemName, '19 Kg');
      });

      test('preserves all values when no arguments are passed', () {
        final original = UnsettledSaleListModel.fromJson(activeJson);
        final copy = original.copyWith();

        expect(copy.unsettSaleAmt, original.unsettSaleAmt);
        expect(copy.staffName, original.staffName);
        expect(copy.transdate, original.transdate);
        expect(copy.rSPPrice, original.rSPPrice);
      });

      test('can update transdate independently', () {
        final original = UnsettledSaleListModel.fromJson(activeJson);
        final copy = original.copyWith(transdate: '2025-12-31T00:00:00');

        expect(copy.transdate, '2025-12-31T00:00:00');
        expect(copy.itemName, original.itemName);
        expect(copy.unsettQty, original.unsettQty);
      });

      test('can clear unsettQty by setting to 0', () {
        final original = UnsettledSaleListModel.fromJson(activeJson);
        final copy = original.copyWith(unsettQty: 0);

        expect(copy.unsettQty, 0);
        expect(original.unsettQty, 10);
      });
    });

    // ── List parsing & aggregation ───────────────────────────────────────
    group('list parsing & aggregation', () {
      test('parses a JSON array into a list of models', () {
        final list =
            (jsonDecode(jsonEncode([zeroJson, activeJson])) as List)
                .map((j) => UnsettledSaleListModel.fromJson(j))
                .toList();

        expect(list.length, 2);
        expect(list[0].staffName, 'Shivaji Jambhale');
        expect(list[1].staffName, 'Rajan Patil');
      });

      test('computes total unsettled quantity across all records', () {
        final records = [
          {'UnsettQty': 5},
          {'UnsettQty': 10},
          {'UnsettQty': 3},
        ];
        final list = records
            .map((j) => UnsettledSaleListModel.fromJson(j))
            .toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.unsettQty ?? 0));

        expect(total, 18);
      });

      test('computes total unsettled sale amount across all records', () {
        final records = [
          {'UnsettSaleAmt': 18005.0},
          {'UnsettSaleAmt': 5000.0},
          {'UnsettSaleAmt': 2500.0},
        ];
        final list = records
            .map((j) => UnsettledSaleListModel.fromJson(j))
            .toList();
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.unsettSaleAmt ?? 0));

        expect(total, 25505.0);
      });

      test('filters records where unsettQty > 0', () {
        final list =
            (jsonDecode(jsonEncode([zeroJson, activeJson])) as List)
                .map((j) => UnsettledSaleListModel.fromJson(j))
                .where((m) => (m.unsettQty ?? 0) > 0)
                .toList();

        expect(list.length, 1);
        expect(list.first.unsettQty, 10);
        expect(list.first.staffName, 'Rajan Patil');
      });

      test('filters records by staffId', () {
        final list =
            (jsonDecode(jsonEncode([zeroJson, activeJson])) as List)
                .map((j) => UnsettledSaleListModel.fromJson(j))
                .where((m) => m.staffId == 31)
                .toList();

        expect(list.length, 1);
        expect(list.first.staffName, 'Rajan Patil');
      });

      test('filters records by itemId', () {
        final list =
            (jsonDecode(jsonEncode([zeroJson, activeJson])) as List)
                .map((j) => UnsettledSaleListModel.fromJson(j))
                .where((m) => m.itemId == 1)
                .toList();

        expect(list.length, 1);
        expect(list.first.itemName, '14.2 Kg');
      });

      test('computes unsettled qty after filtering settled records', () {
        final records = [
          {'UnsettQty': 0, 'StaffId': 29},
          {'UnsettQty': 5, 'StaffId': 30},
          {'UnsettQty': 10, 'StaffId': 31},
        ];
        final list = records
            .map((j) => UnsettledSaleListModel.fromJson(j))
            .where((m) => (m.unsettQty ?? 0) > 0)
            .toList();

        expect(list.length, 2);
        final total =
            list.fold<num>(0, (sum, m) => sum + (m.unsettQty ?? 0));
        expect(total, 15);
      });

      test('empty JSON array returns empty list', () {
        final list = (jsonDecode('[]') as List)
            .map((j) => UnsettledSaleListModel.fromJson(j))
            .toList();

        expect(list, isEmpty);
      });
    });
  });
}
