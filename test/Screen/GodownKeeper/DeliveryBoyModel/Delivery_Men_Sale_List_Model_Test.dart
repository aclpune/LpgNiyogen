import 'package:flutter_test/flutter_test.dart';


import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/DeliveryMenSaleListModel.dart';

void main() {
  group('DeliveryMenSaleListModel', () {
    test('Constructor assigns all fields correctly', () {
      final model = DeliveryMenSaleListModel(
        dMId: 1,
        staffNo: 'SN/001',
        distributorId: 100,
        staffName: 'John Doe',
        vehicleId: 10,
        vehicleNo: 'MH12AB1234',
        staffStatus: 1,
        filledSaleQty: 50,
      );
      expect(model.dMId, 1);
      expect(model.staffNo, 'SN/001');
      expect(model.distributorId, 100);
      expect(model.staffName, 'John Doe');
      expect(model.vehicleId, 10);
      expect(model.vehicleNo, 'MH12AB1234');
      expect(model.staffStatus, 1);
      expect(model.filledSaleQty, 50);
    });

    test('Constructor handles nulls', () {
      final model = DeliveryMenSaleListModel();
      expect(model.dMId, isNull);
      expect(model.staffNo, isNull);
      expect(model.distributorId, isNull);
      expect(model.staffName, isNull);
      expect(model.vehicleId, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.staffStatus, isNull);
      expect(model.filledSaleQty, isNull);
    });

    test('fromJson assigns all fields correctly', () {
      final json = {
        'DMId': 2,
        'StaffNo': 'SN/002',
        'DistributorId': 200,
        'StaffName': 'Jane Doe',
        'VehicleId': 20,
        'VehicleNo': 'MH12CD5678',
        'StaffStatus': 2,
        'FilledSaleQty': 100,
      };
      final model = DeliveryMenSaleListModel.fromJson(json);
      expect(model.dMId, 2);
      expect(model.staffNo, 'SN/002');
      expect(model.distributorId, 200);
      expect(model.staffName, 'Jane Doe');
      expect(model.vehicleId, 20);
      expect(model.vehicleNo, 'MH12CD5678');
      expect(model.staffStatus, 2);
      expect(model.filledSaleQty, 100);
    });

    test('fromJson handles missing fields', () {
      final json = {'DMId': 3};
      final model = DeliveryMenSaleListModel.fromJson(json);
      expect(model.dMId, 3);
      expect(model.staffNo, isNull);
      expect(model.distributorId, isNull);
      expect(model.staffName, isNull);
      expect(model.vehicleId, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.staffStatus, isNull);
      expect(model.filledSaleQty, isNull);
    });

    test('fromJson handles null input', () {
      final model = DeliveryMenSaleListModel.fromJson({});
      expect(model.dMId, isNull);
      expect(model.staffNo, isNull);
      expect(model.distributorId, isNull);
      expect(model.staffName, isNull);
      expect(model.vehicleId, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.staffStatus, isNull);
      expect(model.filledSaleQty, isNull);
    });

    test('toJson outputs correct map', () {
      final model = DeliveryMenSaleListModel(
        dMId: 4,
        staffNo: 'SN/004',
        distributorId: 400,
        staffName: 'Test User',
        vehicleId: 40,
        vehicleNo: 'MH12EF9012',
        staffStatus: 4,
        filledSaleQty: 200,
      );
      final json = model.toJson();
      expect(json['DMId'], 4);
      expect(json['StaffNo'], 'SN/004');
      expect(json['DistributorId'], 400);
      expect(json['StaffName'], 'Test User');
      expect(json['VehicleId'], 40);
      expect(json['VehicleNo'], 'MH12EF9012');
      expect(json['StaffStatus'], 4);
      expect(json['FilledSaleQty'], 200);
    });

    test('toJson handles nulls', () {
      final model = DeliveryMenSaleListModel();
      final json = model.toJson();
      expect(json['DMId'], isNull);
      expect(json['StaffNo'], isNull);
      expect(json['DistributorId'], isNull);
      expect(json['StaffName'], isNull);
      expect(json['VehicleId'], isNull);
      expect(json['VehicleNo'], isNull);
      expect(json['StaffStatus'], isNull);
      expect(json['FilledSaleQty'], isNull);
    });

    test('copyWith copies all fields', () {
      final model = DeliveryMenSaleListModel(
        dMId: 5,
        staffNo: 'SN/005',
        distributorId: 500,
        staffName: 'Copy User',
        vehicleId: 50,
        vehicleNo: 'MH12GH3456',
        staffStatus: 5,
        filledSaleQty: 300,
      );
      final copy = model.copyWith();
      expect(copy.dMId, 5);
      expect(copy.staffNo, 'SN/005');
      expect(copy.distributorId, 500);
      expect(copy.staffName, 'Copy User');
      expect(copy.vehicleId, 50);
      expect(copy.vehicleNo, 'MH12GH3456');
      expect(copy.staffStatus, 5);
      expect(copy.filledSaleQty, 300);
    });

    test('copyWith overrides fields', () {
      final model = DeliveryMenSaleListModel(
        dMId: 6,
        staffNo: 'SN/006',
        distributorId: 600,
        staffName: 'Override User',
        vehicleId: 60,
        vehicleNo: 'MH12IJ7890',
        staffStatus: 6,
        filledSaleQty: 400,
      );
      final copy = model.copyWith(
        dMId: 7,
        staffNo: 'SN/007',
        distributorId: 700,
        staffName: 'New Name',
        vehicleId: 70,
        vehicleNo: 'MH12KL1234',
        staffStatus: 7,
        filledSaleQty: 500,
      );
      expect(copy.dMId, 7);
      expect(copy.staffNo, 'SN/007');
      expect(copy.distributorId, 700);
      expect(copy.staffName, 'New Name');
      expect(copy.vehicleId, 70);
      expect(copy.vehicleNo, 'MH12KL1234');
      expect(copy.staffStatus, 7);
      expect(copy.filledSaleQty, 500);
    });

    // test('Handles unexpected types in fromJson', () {
    //   final json = {
    //     'DMId': 'not a number',
    //     'StaffNo': 123,
    //     'DistributorId': 'wrong',
    //     'StaffName': 456,
    //     'VehicleId': 'car',
    //     'VehicleNo': 789,
    //     'StaffStatus': 'active',
    //     'FilledSaleQty': 'lots',
    //   };
    //   final model = DeliveryMenSaleListModel.fromJson(json);
    //   // Should not throw, but values will be as assigned
    //   expect(model.dMId, 'not a number');
    //   expect(model.staffNo, 123);
    //   expect(model.distributorId, 'wrong');
    //   expect(model.staffName, 456);
    //   expect(model.vehicleId, 'car');
    //   expect(model.vehicleNo, 789);
    //   expect(model.staffStatus, 'active');
    //   expect(model.filledSaleQty, 'lots');
    // });

    test('fromJson with wrong types throws TypeError', () {
      final json = {
        'DMId': 'not a number', // String into num? → throws
      };
      expect(
            () => DeliveryMenSaleListModel.fromJson(json),
        throwsA(isA<TypeError>()),
      );
    });
  });
}

