import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetVehicleDetailsByStaffIdModel.dart';

void main() {
  group('GetVehicleDetailsByStaffIdModel', () {
    final sampleJson = {
      'VehicleId': 16,
      'DistributorId': 8118,
      'StaffId': 48,
      'VehicleNo': 'MH14JP5442',
      'AddedBy': 0,
      'IsActive': 1,
    };

    test('constructor sets all fields correctly', () {
      final model = GetVehicleDetailsByStaffIdModel(
        vehicleId: 16,
        distributorId: 8118,
        staffId: 48,
        vehicleNo: 'MH14JP5442',
        addedBy: 0,
        isActive: 1,
      );

      expect(model.vehicleId, 16);
      expect(model.distributorId, 8118);
      expect(model.staffId, 48);
      expect(model.vehicleNo, 'MH14JP5442');
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);

      expect(model.vehicleId, 16);
      expect(model.distributorId, 8118);
      expect(model.staffId, 48);
      expect(model.vehicleNo, 'MH14JP5442');
      expect(model.addedBy, 0);
      expect(model.isActive, 1);
    });

    test('toJson returns correct map', () {
      final model = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['VehicleId'], 16);
      expect(json['DistributorId'], 8118);
      expect(json['StaffId'], 48);
      expect(json['VehicleNo'], 'MH14JP5442');
      expect(json['AddedBy'], 0);
      expect(json['IsActive'], 1);
    });

    test('toJson includes all keys', () {
      final model = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json.containsKey('VehicleId'), isTrue);
      expect(json.containsKey('DistributorId'), isTrue);
      expect(json.containsKey('StaffId'), isTrue);
      expect(json.containsKey('VehicleNo'), isTrue);
      expect(json.containsKey('AddedBy'), isTrue);
      expect(json.containsKey('IsActive'), isTrue);
    });

    test('copyWith updates specified fields', () {
      final model = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);
      final updated = model.copyWith(vehicleNo: 'MH15AB1234', isActive: 0);

      expect(updated.vehicleNo, 'MH15AB1234');
      expect(updated.isActive, 0);
      expect(model.vehicleNo, 'MH14JP5442');
      expect(model.isActive, 1);
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);
      final updated = model.copyWith(addedBy: 5);

      expect(updated.vehicleId, model.vehicleId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.staffId, model.staffId);
      expect(updated.vehicleNo, model.vehicleNo);
      expect(updated.addedBy, 5);
    });

    test('default constructor with null values', () {
      final model = GetVehicleDetailsByStaffIdModel();

      expect(model.vehicleId, isNull);
      expect(model.staffId, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.isActive, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetVehicleDetailsByStaffIdModel.fromJson(json);

      expect(model2.vehicleId, model.vehicleId);
      expect(model2.staffId, model.staffId);
      expect(model2.vehicleNo, model.vehicleNo);
      expect(model2.isActive, model.isActive);
    });

    test('isActive flag reflects active status', () {
      final activeModel = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);
      expect(activeModel.isActive, 1);

      final inactiveModel = GetVehicleDetailsByStaffIdModel.fromJson({
        ...sampleJson,
        'IsActive': 0,
      });
      expect(inactiveModel.isActive, 0);
    });

    test('vehicleNo format is preserved as-is', () {
      final model = GetVehicleDetailsByStaffIdModel.fromJson(sampleJson);
      expect(model.vehicleNo, 'MH14JP5442');
      expect(model.vehicleNo!.length, 10);
    });
  });
}

