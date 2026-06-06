import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/VehicleNumberGetModel.dart';

void main() {
  group('VehicleNumberGetModel', () {
    // ─────────────────────────────────────────────
    // Constructor Tests
    // ─────────────────────────────────────────────
    group('Constructor', () {
      test('POSITIVE: creates instance with all valid fields', () {
        final model = VehicleNumberGetModel(
          vehicleId: 35,
          distributorId: 8118,
          staffId: 24,
          vehicleNo: 'MH12GH0001',
          addedBy: 0,
          isActive: 1,
        );

        expect(model.vehicleId, 35);
        expect(model.distributorId, 8118);
        expect(model.staffId, 24);
        expect(model.vehicleNo, 'MH12GH0001');
        expect(model.addedBy, 0);
        expect(model.isActive, 1);
      });

      test('POSITIVE: creates instance with all null fields (default constructor)', () {
        final model = VehicleNumberGetModel();

        expect(model.vehicleId, isNull);
        expect(model.distributorId, isNull);
        expect(model.staffId, isNull);
        expect(model.vehicleNo, isNull);
        expect(model.addedBy, isNull);
        expect(model.isActive, isNull);
      });

      test('POSITIVE: creates instance with partial fields', () {
        final model = VehicleNumberGetModel(vehicleId: 10, vehicleNo: 'MH01AB1234');

        expect(model.vehicleId, 10);
        expect(model.vehicleNo, 'MH01AB1234');
        expect(model.distributorId, isNull);
        expect(model.staffId, isNull);
        expect(model.addedBy, isNull);
        expect(model.isActive, isNull);
      });

      test('POSITIVE: accepts double values for num fields', () {
        final model = VehicleNumberGetModel(vehicleId: 1.5, isActive: 0.0);

        expect(model.vehicleId, 1.5);
        expect(model.isActive, 0.0);
      });

      test('POSITIVE: accepts isActive = 0 (inactive)', () {
        final model = VehicleNumberGetModel(isActive: 0);
        expect(model.isActive, 0);
      });

      test('NEGATIVE: vehicleNo accepts empty string', () {
        final model = VehicleNumberGetModel(vehicleNo: '');
        expect(model.vehicleNo, '');
      });

      test('NEGATIVE: vehicleId accepts negative value', () {
        final model = VehicleNumberGetModel(vehicleId: -1);
        expect(model.vehicleId, -1);
      });
    });

    // ─────────────────────────────────────────────
    // fromJson Tests
    // ─────────────────────────────────────────────
    group('fromJson', () {
      test('POSITIVE: parses complete valid JSON', () {
        final json = {
          'VehicleId': 35,
          'DistributorId': 8118,
          'StaffId': 24,
          'VehicleNo': 'MH12GH0001',
          'AddedBy': 0,
          'IsActive': 1,
        };

        final model = VehicleNumberGetModel.fromJson(json);

        expect(model.vehicleId, 35);
        expect(model.distributorId, 8118);
        expect(model.staffId, 24);
        expect(model.vehicleNo, 'MH12GH0001');
        expect(model.addedBy, 0);
        expect(model.isActive, 1);
      });

      test('POSITIVE: parses JSON with all null values', () {
        final json = {
          'VehicleId': null,
          'DistributorId': null,
          'StaffId': null,
          'VehicleNo': null,
          'AddedBy': null,
          'IsActive': null,
        };

        final model = VehicleNumberGetModel.fromJson(json);

        expect(model.vehicleId, isNull);
        expect(model.distributorId, isNull);
        expect(model.staffId, isNull);
        expect(model.vehicleNo, isNull);
        expect(model.addedBy, isNull);
        expect(model.isActive, isNull);
      });

      test('POSITIVE: parses JSON with large numeric vehicleId', () {
        final json = {
          'VehicleId': 999999,
          'DistributorId': 8118,
          'StaffId': 24,
          'VehicleNo': 'MH12GH0001',
          'AddedBy': 0,
          'IsActive': 1,
        };

        final model = VehicleNumberGetModel.fromJson(json);
        expect(model.vehicleId, 999999);
      });

      test('POSITIVE: parses JSON with vehicleNo having special characters', () {
        final json = {
          'VehicleId': 1,
          'DistributorId': 1,
          'StaffId': 1,
          'VehicleNo': 'MH-12 GH 0001',
          'AddedBy': 0,
          'IsActive': 1,
        };

        final model = VehicleNumberGetModel.fromJson(json);
        expect(model.vehicleNo, 'MH-12 GH 0001');
      });

      test('NEGATIVE: missing keys in JSON results in null fields', () {
        final json = <String, dynamic>{};

        final model = VehicleNumberGetModel.fromJson(json);

        expect(model.vehicleId, isNull);
        expect(model.distributorId, isNull);
        expect(model.staffId, isNull);
        expect(model.vehicleNo, isNull);
        expect(model.addedBy, isNull);
        expect(model.isActive, isNull);
      });

      test('NEGATIVE: throws when JSON is not a map (e.g. null)', () {
        expect(() => VehicleNumberGetModel.fromJson(null), throwsA(anything));
      });

      test('NEGATIVE: wrong type for VehicleId (string instead of num)', () {
        final json = {
          'VehicleId': 'abc',
          'DistributorId': 8118,
          'StaffId': 24,
          'VehicleNo': 'MH12GH0001',
          'AddedBy': 0,
          'IsActive': 1,
        };

        // fromJson directly assigns without parsing — vehicleId will be 'abc' (dynamic)
        final model = VehicleNumberGetModel.fromJson(json);
        expect(model.vehicleId, 'abc'); // no type coercion in this model
      });
    });

    // ─────────────────────────────────────────────
    // toJson Tests
    // ─────────────────────────────────────────────
    group('toJson', () {
      test('POSITIVE: serializes all fields correctly', () {
        final model = VehicleNumberGetModel(
          vehicleId: 35,
          distributorId: 8118,
          staffId: 24,
          vehicleNo: 'MH12GH0001',
          addedBy: 0,
          isActive: 1,
        );

        final json = model.toJson();

        expect(json['VehicleId'], 35);
        expect(json['DistributorId'], 8118);
        expect(json['StaffId'], 24);
        expect(json['VehicleNo'], 'MH12GH0001');
        expect(json['AddedBy'], 0);
        expect(json['IsActive'], 1);
      });

      test('POSITIVE: serializes null fields as null', () {
        final model = VehicleNumberGetModel();
        final json = model.toJson();

        expect(json['VehicleId'], isNull);
        expect(json['DistributorId'], isNull);
        expect(json['StaffId'], isNull);
        expect(json['VehicleNo'], isNull);
        expect(json['AddedBy'], isNull);
        expect(json['IsActive'], isNull);
      });

      test('POSITIVE: toJson contains all expected keys', () {
        final model = VehicleNumberGetModel();
        final json = model.toJson();

        expect(json.containsKey('VehicleId'), isTrue);
        expect(json.containsKey('DistributorId'), isTrue);
        expect(json.containsKey('StaffId'), isTrue);
        expect(json.containsKey('VehicleNo'), isTrue);
        expect(json.containsKey('AddedBy'), isTrue);
        expect(json.containsKey('IsActive'), isTrue);
      });

      test('POSITIVE: fromJson -> toJson round-trip preserves data', () {
        final originalJson = {
          'VehicleId': 35,
          'DistributorId': 8118,
          'StaffId': 24,
          'VehicleNo': 'MH12GH0001',
          'AddedBy': 0,
          'IsActive': 1,
        };

        final model = VehicleNumberGetModel.fromJson(originalJson);
        final resultJson = model.toJson();

        expect(resultJson, equals(originalJson));
      });

      test('NEGATIVE: toJson does not contain unexpected extra keys', () {
        final model = VehicleNumberGetModel(vehicleId: 1);
        final json = model.toJson();

        expect(json.length, 6);
      });
    });

    // ─────────────────────────────────────────────
    // copyWith Tests
    // ─────────────────────────────────────────────
    group('copyWith', () {
      test('POSITIVE: copies model with updated vehicleNo', () {
        final original = VehicleNumberGetModel(
          vehicleId: 35,
          distributorId: 8118,
          staffId: 24,
          vehicleNo: 'MH12GH0001',
          addedBy: 0,
          isActive: 1,
        );

        final copy = original.copyWith(vehicleNo: 'DL01AB9999');

        expect(copy.vehicleNo, 'DL01AB9999');
        expect(copy.vehicleId, 35);      // unchanged
        expect(copy.distributorId, 8118); // unchanged
      });

      test('POSITIVE: copies model with all fields updated', () {
        final original = VehicleNumberGetModel(
          vehicleId: 1,
          distributorId: 1,
          staffId: 1,
          vehicleNo: 'OLD001',
          addedBy: 1,
          isActive: 0,
        );

        final copy = original.copyWith(
          vehicleId: 99,
          distributorId: 999,
          staffId: 9,
          vehicleNo: 'NEW999',
          addedBy: 5,
          isActive: 1,
        );

        expect(copy.vehicleId, 99);
        expect(copy.distributorId, 999);
        expect(copy.staffId, 9);
        expect(copy.vehicleNo, 'NEW999');
        expect(copy.addedBy, 5);
        expect(copy.isActive, 1);
      });

      test('POSITIVE: copyWith with no arguments keeps original values', () {
        final original = VehicleNumberGetModel(
          vehicleId: 35,
          distributorId: 8118,
          staffId: 24,
          vehicleNo: 'MH12GH0001',
          addedBy: 0,
          isActive: 1,
        );

        final copy = original.copyWith();

        expect(copy.vehicleId, original.vehicleId);
        expect(copy.distributorId, original.distributorId);
        expect(copy.staffId, original.staffId);
        expect(copy.vehicleNo, original.vehicleNo);
        expect(copy.addedBy, original.addedBy);
        expect(copy.isActive, original.isActive);
      });

      test('POSITIVE: original is not mutated after copyWith', () {
        final original = VehicleNumberGetModel(vehicleNo: 'MH12GH0001');
        original.copyWith(vehicleNo: 'CHANGED');

        expect(original.vehicleNo, 'MH12GH0001');
      });

      test('NEGATIVE: copyWith cannot set a field back to null (no null override support)', () {
        final original = VehicleNumberGetModel(vehicleNo: 'MH12GH0001');
        // copyWith uses ?? so passing null keeps the original value
        final copy = original.copyWith(vehicleNo: null);

        expect(copy.vehicleNo, 'MH12GH0001'); // null is ignored, original retained
      });
    });

    // ─────────────────────────────────────────────
    // Getter Tests
    // ─────────────────────────────────────────────
    group('Getters', () {
      test('POSITIVE: all getters return expected values', () {
        final model = VehicleNumberGetModel(
          vehicleId: 5,
          distributorId: 100,
          staffId: 10,
          vehicleNo: 'KA05MN4321',
          addedBy: 2,
          isActive: 1,
        );

        expect(model.vehicleId, 5);
        expect(model.distributorId, 100);
        expect(model.staffId, 10);
        expect(model.vehicleNo, 'KA05MN4321');
        expect(model.addedBy, 2);
        expect(model.isActive, 1);
      });

      test('POSITIVE: isActive getter returns 0 correctly', () {
        final model = VehicleNumberGetModel(isActive: 0);
        expect(model.isActive, 0);
        expect(model.isActive == 0, isTrue);
      });

      test('NEGATIVE: unset getter returns null, not default', () {
        final model = VehicleNumberGetModel();
        expect(model.vehicleId, isNull);
        expect(model.vehicleNo, isNull);
      });
    });
  });
}