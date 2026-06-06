import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetStaffDetailsListModel.dart';

void main() {
  group('GetStaffDetailsListModel (UpdatePaymentsScreen)', () {
    final sampleJson = {
      'StaffId': 306,
      'StaffNo': 'SN/039',
      'DistributorId': 8118,
      'StaffName': 'Sarthak Saha',
      'VehicleNo': null,
      'StaffAddress': null,
      'ContactPhone1': '9846456323',
      'StaffType': 0,
      'Salary': 0.00,
      'DelRate': 0.00,
      'StaffStatus': 1,
      'Designation': 2,
      'DesignationName': 'Delivery Men',
      'AddedBy': 0,
      'RefNo': '0',
      'Action': null,
      'RoleName': '',
      'StaffEmail': null,
      'StaffTypeText': 'Salaried',
      'OTP': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetStaffDetailsListModel(
        staffId: 306,
        staffNo: 'SN/039',
        distributorId: 8118,
        staffName: 'Sarthak Saha',
        contactPhone1: '9846456323',
        staffType: 0,
        salary: 0.00,
        delRate: 0.00,
        staffStatus: 1,
        designation: 2,
        designationName: 'Delivery Men',
        addedBy: 0,
        refNo: '0',
        roleName: '',
        staffTypeText: 'Salaried',
      );

      expect(model.staffId, 306);
      expect(model.staffNo, 'SN/039');
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Sarthak Saha');
      expect(model.staffType, 0);
      expect(model.salary, 0.00);
      expect(model.staffStatus, 1);
      expect(model.designation, 2);
      expect(model.designationName, 'Delivery Men');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);

      expect(model.staffId, 306);
      expect(model.staffNo, 'SN/039');
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Sarthak Saha');
      expect(model.vehicleNo, isNull);
      expect(model.staffAddress, isNull);
      expect(model.contactPhone1, '9846456323');
      expect(model.staffType, 0);
      expect(model.salary, 0.00);
      expect(model.delRate, 0.00);
      expect(model.staffStatus, 1);
      expect(model.designation, 2);
      expect(model.designationName, 'Delivery Men');
      expect(model.addedBy, 0);
      expect(model.refNo, '0');
      expect(model.action, isNull);
      expect(model.roleName, '');
      expect(model.staffEmail, isNull);
      expect(model.staffTypeText, 'Salaried');
      expect(model.otp, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['StaffId'], 306);
      expect(json['StaffNo'], 'SN/039');
      expect(json['StaffName'], 'Sarthak Saha');
      expect(json['DesignationName'], 'Delivery Men');
      expect(json['StaffTypeText'], 'Salaried');
      expect(json['VehicleNo'], isNull);
    });

    test('toJson includes all keys', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final json = model.toJson();

      final expectedKeys = [
        'StaffId', 'StaffNo', 'DistributorId', 'StaffName', 'VehicleNo',
        'StaffAddress', 'ContactPhone1', 'StaffType', 'Salary', 'DelRate',
        'StaffStatus', 'Designation', 'DesignationName', 'AddedBy', 'RefNo',
        'Action', 'RoleName', 'StaffEmail', 'StaffTypeText', 'OTP',
      ];
      for (final key in expectedKeys) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('copyWith updates specified fields', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'Updated Name', salary: 5000.0);

      expect(updated.staffName, 'Updated Name');
      expect(updated.salary, 5000.0);
      expect(model.staffName, 'Sarthak Saha');
      expect(model.salary, 0.00);
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(designation: 3);

      expect(updated.staffId, model.staffId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.contactPhone1, model.contactPhone1);
      expect(updated.designation, 3);
    });

    test('default constructor with null values', () {
      final model = GetStaffDetailsListModel();

      expect(model.staffId, isNull);
      expect(model.staffName, isNull);
      expect(model.salary, isNull);
      expect(model.otp, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetStaffDetailsListModel.fromJson(json);

      expect(model2.staffId, model.staffId);
      expect(model2.staffName, model.staffName);
      expect(model2.designation, model.designation);
      expect(model2.staffTypeText, model.staffTypeText);
    });
  });
}

