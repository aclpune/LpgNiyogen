import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetStaffDetailsListModel.dart';

void main() {
  group('GetStaffDetailsListModel (SalaryPaymentScreen)', () {
    final sampleJson = {
      'StaffId': 308,
      'StaffNo': 'SN/041',
      'DistributorId': 8118,
      'StaffName': 'Staff1',
      'VehicleNo': null,
      'StaffAddress': '',
      'ContactPhone1': '9756446665',
      'StaffType': 0,
      'Salary': 0.0,
      'DelRate': 0.0,
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
      'IsOnBording': 0,
      'DebitAmt': 0.0,
      'CreditAmt': 0.0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetStaffDetailsListModel(
        staffId: 308,
        staffNo: 'SN/041',
        distributorId: 8118,
        staffName: 'Staff1',
        staffAddress: '',
        contactPhone1: '9756446665',
        staffType: 0,
        salary: 0.0,
        delRate: 0.0,
        staffStatus: 1,
        designation: 2,
        designationName: 'Delivery Men',
        addedBy: 0,
        refNo: '0',
        roleName: '',
        staffTypeText: 'Salaried',
        isOnBording: 0,
        debitAmt: 0.0,
        creditAmt: 0.0,
      );

      expect(model.staffId, 308);
      expect(model.staffNo, 'SN/041');
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Staff1');
      expect(model.staffAddress, '');
      expect(model.contactPhone1, '9756446665');
      expect(model.staffType, 0);
      expect(model.salary, 0.0);
      expect(model.staffStatus, 1);
      expect(model.designation, 2);
      expect(model.designationName, 'Delivery Men');
      expect(model.isOnBording, 0);
      expect(model.debitAmt, 0.0);
      expect(model.creditAmt, 0.0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);

      expect(model.staffId, 308);
      expect(model.staffNo, 'SN/041');
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Staff1');
      expect(model.vehicleNo, isNull);
      expect(model.staffAddress, '');
      expect(model.contactPhone1, '9756446665');
      expect(model.staffType, 0);
      expect(model.salary, 0.0);
      expect(model.delRate, 0.0);
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
      expect(model.isOnBording, 0);
      expect(model.debitAmt, 0.0);
      expect(model.creditAmt, 0.0);
    });

    test('toJson returns correct map', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['StaffId'], 308);
      expect(json['StaffName'], 'Staff1');
      expect(json['DesignationName'], 'Delivery Men');
      expect(json['IsOnBording'], 0);
      expect(json['DebitAmt'], 0.0);
      expect(json['CreditAmt'], 0.0);
    });

    test('copyWith updates specified fields', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'Updated Staff', salary: 5000.0);

      expect(updated.staffName, 'Updated Staff');
      expect(updated.salary, 5000.0);
      expect(model.staffName, 'Staff1');
      expect(model.salary, 0.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetStaffDetailsListModel.fromJson(sampleJson);
      final updated = model.copyWith(debitAmt: 100.0);

      expect(updated.staffId, model.staffId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.creditAmt, model.creditAmt);
    });

    test('constructor with null values', () {
      final model = GetStaffDetailsListModel();
      expect(model.staffId, isNull);
      expect(model.salary, isNull);
      expect(model.isOnBording, isNull);
    });
  });
}

