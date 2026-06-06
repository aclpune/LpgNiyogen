import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetPaymentDetailListModel.dart';

void main() {
  group('GetPaymentDetailListModel', () {
    final sampleJson = {
      'PaymentId': 709,
      'DistributorId': 8118,
      'VoucherNo': 'EXP/000068',
      'PaymentTo': 1,
      'PaymentDate': '29-05-2025',
      'StaffId': 44,
      'VendorId': 0,
      'VehId': 17,
      'VehicleNo': 'MH12PQ8949',
      'StaffName': '19kg Devendra',
      'Amount': 100.00,
      'ExpHeadId': 11,
      'PaymentMode': 'Cash',
      'PayRemark': '',
      'TransTime': '',
      'TransationCode': '',
      'TransRemark': '',
      'ExpHeadName': 'ARB Item Purchase',
      'BankId': 0,
      'MappingId': 0,
      'AccountNo': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetPaymentDetailListModel(
        paymentId: 709,
        distributorId: 8118,
        voucherNo: 'EXP/000068',
        paymentTo: 1,
        paymentDate: '29-05-2025',
        staffId: 44,
        vendorId: 0,
        vehId: 17,
        vehicleNo: 'MH12PQ8949',
        staffName: '19kg Devendra',
        amount: 100.00,
        expHeadId: 11,
        paymentMode: 'Cash',
        payRemark: '',
        transTime: '',
        transationCode: '',
        transRemark: '',
        expHeadName: 'ARB Item Purchase',
        bankId: 0,
        mappingId: 0,
        accountNo: null,
      );

      expect(model.paymentId, 709);
      expect(model.distributorId, 8118);
      expect(model.voucherNo, 'EXP/000068');
      expect(model.staffName, '19kg Devendra');
      expect(model.amount, 100.00);
      expect(model.paymentMode, 'Cash');
      expect(model.expHeadName, 'ARB Item Purchase');
      expect(model.accountNo, isNull);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetPaymentDetailListModel.fromJson(sampleJson);

      expect(model.paymentId, 709);
      expect(model.distributorId, 8118);
      expect(model.voucherNo, 'EXP/000068');
      expect(model.paymentTo, 1);
      expect(model.paymentDate, '29-05-2025');
      expect(model.staffId, 44);
      expect(model.vendorId, 0);
      expect(model.vehId, 17);
      expect(model.vehicleNo, 'MH12PQ8949');
      expect(model.staffName, '19kg Devendra');
      expect(model.amount, 100.00);
      expect(model.expHeadId, 11);
      expect(model.paymentMode, 'Cash');
      expect(model.payRemark, '');
      expect(model.transTime, '');
      expect(model.transationCode, '');
      expect(model.transRemark, '');
      expect(model.expHeadName, 'ARB Item Purchase');
      expect(model.bankId, 0);
      expect(model.mappingId, 0);
      expect(model.accountNo, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetPaymentDetailListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['PaymentId'], 709);
      expect(json['VoucherNo'], 'EXP/000068');
      expect(json['StaffName'], '19kg Devendra');
      expect(json['Amount'], 100.00);
      expect(json['PaymentMode'], 'Cash');
      expect(json['AccountNo'], isNull);
    });

    test('toJson includes all keys', () {
      final model = GetPaymentDetailListModel.fromJson(sampleJson);
      final json = model.toJson();

      final expectedKeys = [
        'PaymentId', 'DistributorId', 'VoucherNo', 'PaymentTo', 'PaymentDate',
        'StaffId', 'VendorId', 'VehId', 'VehicleNo', 'StaffName', 'Amount',
        'ExpHeadId', 'PaymentMode', 'PayRemark', 'TransTime', 'TransationCode',
        'TransRemark', 'ExpHeadName', 'BankId', 'MappingId', 'AccountNo',
      ];
      for (final key in expectedKeys) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('copyWith updates specified fields', () {
      final model = GetPaymentDetailListModel.fromJson(sampleJson);
      final updated = model.copyWith(amount: 500.00, paymentMode: 'Online');

      expect(updated.amount, 500.00);
      expect(updated.paymentMode, 'Online');
      expect(model.amount, 100.00);
      expect(model.paymentMode, 'Cash');
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetPaymentDetailListModel.fromJson(sampleJson);
      final updated = model.copyWith(transationCode: 'TXN999');

      expect(updated.paymentId, model.paymentId);
      expect(updated.staffName, model.staffName);
      expect(updated.expHeadName, model.expHeadName);
      expect(updated.transationCode, 'TXN999');
    });

    test('default constructor with null values', () {
      final model = GetPaymentDetailListModel();

      expect(model.paymentId, isNull);
      expect(model.voucherNo, isNull);
      expect(model.amount, isNull);
      expect(model.paymentMode, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetPaymentDetailListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetPaymentDetailListModel.fromJson(json);

      expect(model2.paymentId, model.paymentId);
      expect(model2.voucherNo, model.voucherNo);
      expect(model2.staffName, model.staffName);
      expect(model2.amount, model.amount);
      expect(model2.expHeadName, model.expHeadName);
    });
  });
}

