import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetStaffDetailsListModel.dart';

void main() {
  group('GetStaffDetailsListModel (SVSaleModel)', () {
    final sampleJson = {
      'StaffId': 305,
      'StaffNo': 'SN/038',
      'DistributorId': 8118,
      'StaffName': 'Pk',
      'VehicleNo': null,
      'StaffAddress': null,
      'ContactPhone1': '7215932156',
      'StaffType': 0,
      'Salary': 1000.0,
      'DelRate': 0.0,
      'StaffStatus': 1,
      'Designation': 3,
      'DesignationName': 'Godown Keeper',
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
        staffId: 305,
        staffNo: 'SN/038',
        distributorId: 8118,
        staffName: 'Pk',
        contactPhone1: '7215932156',
        staffType: 0,
        salary: 1000.0,
        delRate: 0.0,
        staffStatus: 1,
        designation: 3,
        designationName: 'Godown Keeper',
        addedBy: 0,
        refNo: '0',
        roleName: '',
        staffTypeText: 'Salaried',
      );

      expect(model.staffId, 305);
      expect(model.staffNo, 'SN/038');
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Pk');
      expect(model.contactPhone1, '7215932156');
      expect(model.staffType, 0);
      expect(model.salary, 1000.0);
      expect(model.delRate, 0.0);
      expect(model.staffStatus, 1);
      expect(model.designation, 3);
      expect(model.designationName, 'Godown Keeper');
      expect(model.addedBy, 0);
      expect(model.refNo, '0');
      expect(model.roleName, '');
      expect(model.staffTypeText, 'Salaried');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);

      expect(model.staffId, 305);
      expect(model.staffNo, 'SN/038');
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Pk');
      expect(model.vehicleNo, isNull);
      expect(model.staffAddress, isNull);
      expect(model.contactPhone1, '7215932156');
      expect(model.staffType, 0);
      expect(model.salary, 1000.0);
      expect(model.delRate, 0.0);
      expect(model.staffStatus, 1);
      expect(model.designation, 3);
      expect(model.designationName, 'Godown Keeper');
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

      expect(json['StaffId'], 305);
      expect(json['StaffNo'], 'SN/038');
      expect(json['DistributorId'], 8118);
      expect(json['StaffName'], 'Pk');
      expect(json['VehicleNo'], isNull);
      expect(json['ContactPhone1'], '7215932156');
      expect(json['Salary'], 1000.0);
      expect(json['DesignationName'], 'Godown Keeper');
    });

    test('copyWith updates specified fields', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'John', salary: 2000.0);

      expect(updated.staffName, 'John');
      expect(updated.salary, 2000.0);
      expect(model.staffName, 'Pk');
      expect(model.salary, 1000.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(roleName: 'Admin');

      expect(updated.staffId, model.staffId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.designation, model.designation);
    });

    test('constructor with null values', () {
      final model = GetStaffDetailsListModel();
      expect(model.staffId, isNull);
      expect(model.staffName, isNull);
      expect(model.salary, isNull);
    });
  });
}

