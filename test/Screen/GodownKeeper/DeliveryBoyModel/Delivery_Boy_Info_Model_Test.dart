import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/DeliveryBoyInfoModel.dart';

void main() {
  group('DeliveryBoyInfoModel', () {

    // ─── Sample valid JSON ───────────────────────────────────────────────
    final validJson = {
      'StaffId': 31,
      'StaffNo': 'SN/030',
      'DistributorId': 8118,
      'StaffInitials': 'SJ',
      'StaffName': 'Suresh Jadhav',
      'VehicleNo': null,
      'StaffAddress': 'Baner',
      'ContactPhone1': '919665709402',
      'JoiningDate': '2024-12-17T00:00:00',
      'Salary': 500000,
      'StaffStatus': 1,
      'Designation': 2,
      'DesignationName': 'Delivery Men',
      'AddedBy': 0,
      'RefNo': '31',
      'Action': null,
      'RoleName': 'Manager',
      'StaffEmail': 'anilshinde@aadyamconsultant.com',
    };

    // ════════════════════════════════════════════════════════════════════
    // POSITIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Positive Tests', () {

      test('fromJson parses all fields correctly', () {
        final model = DeliveryBoyInfoModel.fromJson(validJson);

        expect(model.staffId, equals(31));
        expect(model.staffNo, equals('SN/030'));
        expect(model.distributorId, equals(8118));
        expect(model.staffInitials, equals('SJ'));
        expect(model.staffName, equals('Suresh Jadhav'));
        expect(model.vehicleNo, isNull);
        expect(model.staffAddress, equals('Baner'));
        expect(model.contactPhone1, equals('919665709402'));
        expect(model.joiningDate, equals('2024-12-17T00:00:00'));
        expect(model.salary, equals(500000));
        expect(model.staffStatus, equals(1));
        expect(model.designation, equals(2));
        expect(model.designationName, equals('Delivery Men'));
        expect(model.addedBy, equals(0));
        expect(model.refNo, equals('31'));
        expect(model.action, isNull);
        expect(model.roleName, equals('Manager'));
        expect(model.staffEmail, equals('anilshinde@aadyamconsultant.com'));
      });

      test('constructor creates model with all provided fields', () {
        final model = DeliveryBoyInfoModel(
          staffId: 31,
          staffNo: 'SN/030',
          distributorId: 8118,
          staffInitials: 'SJ',
          staffName: 'Suresh Jadhav',
          vehicleNo: null,
          staffAddress: 'Baner',
          contactPhone1: '919665709402',
          joiningDate: '2024-12-17T00:00:00',
          salary: 500000,
          staffStatus: 1,
          designation: 2,
          designationName: 'Delivery Men',
          addedBy: 0,
          refNo: '31',
          action: null,
          roleName: 'Manager',
          staffEmail: 'anilshinde@aadyamconsultant.com',
        );

        expect(model.staffId, equals(31));
        expect(model.staffName, equals('Suresh Jadhav'));
        expect(model.roleName, equals('Manager'));
      });

      test('toJson produces correct map with all 18 keys', () {
        final model = DeliveryBoyInfoModel.fromJson(validJson);
        final json = model.toJson();

        expect(json.keys.length, equals(18));
        expect(json['StaffId'], equals(31));
        expect(json['StaffNo'], equals('SN/030'));
        expect(json['DistributorId'], equals(8118));
        expect(json['StaffInitials'], equals('SJ'));
        expect(json['StaffName'], equals('Suresh Jadhav'));
        expect(json['VehicleNo'], isNull);
        expect(json['StaffAddress'], equals('Baner'));
        expect(json['ContactPhone1'], equals('919665709402'));
        expect(json['JoiningDate'], equals('2024-12-17T00:00:00'));
        expect(json['Salary'], equals(500000));
        expect(json['StaffStatus'], equals(1));
        expect(json['Designation'], equals(2));
        expect(json['DesignationName'], equals('Delivery Men'));
        expect(json['AddedBy'], equals(0));
        expect(json['RefNo'], equals('31'));
        expect(json['Action'], isNull);
        expect(json['RoleName'], equals('Manager'));
        expect(json['StaffEmail'], equals('anilshinde@aadyamconsultant.com'));
      });

      test('copyWith updates only specified fields', () {
        final original = DeliveryBoyInfoModel.fromJson(validJson);
        final updated = original.copyWith(
          staffName: 'New Name',
          salary: 600000,
          roleName: 'Admin',
        );

        expect(updated.staffName, equals('New Name'));
        expect(updated.salary, equals(600000));
        expect(updated.roleName, equals('Admin'));
        // unchanged
        expect(updated.staffId, equals(31));
        expect(updated.staffNo, equals('SN/030'));
        expect(updated.staffEmail, equals('anilshinde@aadyamconsultant.com'));
      });

      test('copyWith with no arguments returns equivalent object', () {
        final original = DeliveryBoyInfoModel.fromJson(validJson);
        final copy = original.copyWith();

        expect(copy.staffId, equals(original.staffId));
        expect(copy.staffName, equals(original.staffName));
        expect(copy.salary, equals(original.salary));
      });

      test('fromJson then toJson round-trip preserves values', () {
        final model = DeliveryBoyInfoModel.fromJson(validJson);
        final json = model.toJson();

        expect(json['StaffId'], equals(validJson['StaffId']));
        expect(json['StaffName'], equals(validJson['StaffName']));
        expect(json['StaffEmail'], equals(validJson['StaffEmail']));
        expect(json['VehicleNo'], equals(validJson['VehicleNo']));
      });

      test('default constructor creates model with all null fields', () {
        final model = DeliveryBoyInfoModel();
        expect(model.staffId, isNull);
        expect(model.staffNo, isNull);
        expect(model.distributorId, isNull);
        expect(model.staffInitials, isNull);
        expect(model.staffName, isNull);
        expect(model.vehicleNo, isNull);
        expect(model.staffAddress, isNull);
        expect(model.contactPhone1, isNull);
        expect(model.joiningDate, isNull);
        expect(model.salary, isNull);
        expect(model.staffStatus, isNull);
        expect(model.designation, isNull);
        expect(model.designationName, isNull);
        expect(model.addedBy, isNull);
        expect(model.refNo, isNull);
        expect(model.action, isNull);
        expect(model.roleName, isNull);
        expect(model.staffEmail, isNull);
      });

      test('fromJson handles active and inactive staffStatus', () {
        final activeJson = Map<String, dynamic>.from(validJson)
          ..['StaffStatus'] = 1;
        final inactiveJson = Map<String, dynamic>.from(validJson)
          ..['StaffStatus'] = 0;

        expect(DeliveryBoyInfoModel.fromJson(activeJson).staffStatus, equals(1));
        expect(DeliveryBoyInfoModel.fromJson(inactiveJson).staffStatus, equals(0));
      });

      test('fromJson handles vehicleNo as non-null string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['VehicleNo'] = 'MH12AB1234';

        final model = DeliveryBoyInfoModel.fromJson(json);
        expect(model.vehicleNo, equals('MH12AB1234'));
      });

      test('fromJson handles salary as decimal value', () {
        final json = Map<String, dynamic>.from(validJson);
        json['Salary'] = 45000.75;

        final model = DeliveryBoyInfoModel.fromJson(json);
        expect(model.salary, equals(45000.75));
      });
    });

    // ════════════════════════════════════════════════════════════════════
    // NEGATIVE TEST CASES
    // ════════════════════════════════════════════════════════════════════

    group('Negative Tests', () {

      test('fromJson with all null values does not throw', () {
        final nullJson = {
          'StaffId': null, 'StaffNo': null, 'DistributorId': null,
          'StaffInitials': null, 'StaffName': null, 'VehicleNo': null,
          'StaffAddress': null, 'ContactPhone1': null, 'JoiningDate': null,
          'Salary': null, 'StaffStatus': null, 'Designation': null,
          'DesignationName': null, 'AddedBy': null, 'RefNo': null,
          'Action': null, 'RoleName': null, 'StaffEmail': null,
        };

        expect(() => DeliveryBoyInfoModel.fromJson(nullJson), returnsNormally);
        final model = DeliveryBoyInfoModel.fromJson(nullJson);
        expect(model.staffId, isNull);
        expect(model.staffName, isNull);
      });

      test('fromJson with empty map results in all null fields', () {
        final model = DeliveryBoyInfoModel.fromJson({});
        expect(model.staffId, isNull);
        expect(model.staffName, isNull);
        expect(model.salary, isNull);
      });

      test('toJson includes null values when fields are null', () {
        final model = DeliveryBoyInfoModel();
        final json = model.toJson();

        expect(json['StaffId'], isNull);
        expect(json['StaffName'], isNull);
        expect(json['VehicleNo'], isNull);
        expect(json['Action'], isNull);
      });

      test('copyWith does not mutate original instance', () {
        final original = DeliveryBoyInfoModel.fromJson(validJson);
        original.copyWith(staffName: 'Different Name');

        expect(original.staffName, equals('Suresh Jadhav'));
      });

      test('fromJson with empty staffName string', () {
        final json = Map<String, dynamic>.from(validJson);
        json['StaffName'] = '';

        final model = DeliveryBoyInfoModel.fromJson(json);
        expect(model.staffName, equals(''));
      });

      test('fromJson with invalid email format stores as-is', () {
        final json = Map<String, dynamic>.from(validJson);
        json['StaffEmail'] = 'not-an-email';

        final model = DeliveryBoyInfoModel.fromJson(json);
        expect(model.staffEmail, equals('not-an-email'));
      });

      test('fromJson with negative salary stores value as-is', () {
        final json = Map<String, dynamic>.from(validJson);
        json['Salary'] = -1000;

        final model = DeliveryBoyInfoModel.fromJson(json);
        expect(model.salary, equals(-1000));
      });

      test('fromJson with invalid date string does not throw', () {
        final json = Map<String, dynamic>.from(validJson);
        json['JoiningDate'] = 'invalid-date';

        expect(() => DeliveryBoyInfoModel.fromJson(json), returnsNormally);
      });

      // test('fromJson with numeric staffNo stores value as-is', () {
      //   final json = Map<String, dynamic>.from(validJson);
      //   json['StaffNo'] = 30; // number instead of string
      //
      //   final model = DeliveryBoyInfoModel.fromJson(json);
      //   expect(model.staffNo, equals(30));
      // });
      test('fromJson with numeric staffNo throws TypeError', () {
        final json = Map<String, dynamic>.from(validJson);
        json['StaffNo'] = 30;

        expect(
              () => DeliveryBoyInfoModel.fromJson(json),
          throwsA(isA<TypeError>()),
        );
      });
    });
  });
}