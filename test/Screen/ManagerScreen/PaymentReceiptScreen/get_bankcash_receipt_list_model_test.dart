import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/PaymentReceiptScreen/GetBankcashReceiptListModel.dart';

void main() {
  group('GetBankcashReceiptListModel', () {
    final sampleJson = {
      'CustomerId': 60,
      'StaffId': 0,
      'ReceiptId': 153,
      'ReceiptNo': 'RC/000042',
      'ReceiptFrom': 2,
      'DistributorId': 8118,
      'StaffName': 'Aspiria',
      'Amount': 1000.0,
      'Balance': 0.0,
      'VendorName': null,
      'ReceiptMode': 'Bank',
      'ReceiptDate': '04-06-2025',
      'RemarkForVendor': '',
      'TransationCode': 'vfkkdnhh',
      'TransTime': '',
      'TransRemark': '',
      'BankId': 13,
      'MappingId': 20,
      'AccountNo': '9822279799',
    };

    test('constructor sets all fields correctly', () {
      final model = GetBankcashReceiptListModel(
        customerId: 60,
        staffId: 0,
        receiptId: 153,
        receiptNo: 'RC/000042',
        receiptFrom: 2,
        distributorId: 8118,
        staffName: 'Aspiria',
        amount: 1000.0,
        balance: 0.0,
        receiptMode: 'Bank',
        receiptDate: '04-06-2025',
        remarkForVendor: '',
        transationCode: 'vfkkdnhh',
        transTime: '',
        transRemark: '',
        bankId: 13,
        mappingId: 20,
        accountNo: '9822279799',
      );

      expect(model.customerId, 60);
      expect(model.staffId, 0);
      expect(model.receiptId, 153);
      expect(model.receiptNo, 'RC/000042');
      expect(model.receiptFrom, 2);
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Aspiria');
      expect(model.amount, 1000.0);
      expect(model.balance, 0.0);
      expect(model.receiptMode, 'Bank');
      expect(model.receiptDate, '04-06-2025');
      expect(model.transationCode, 'vfkkdnhh');
      expect(model.bankId, 13);
      expect(model.mappingId, 20);
      expect(model.accountNo, '9822279799');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetBankcashReceiptListModel.fromJson(sampleJson);

      expect(model.customerId, 60);
      expect(model.receiptId, 153);
      expect(model.receiptNo, 'RC/000042');
      expect(model.receiptFrom, 2);
      expect(model.distributorId, 8118);
      expect(model.staffName, 'Aspiria');
      expect(model.amount, 1000.0);
      expect(model.balance, 0.0);
      expect(model.vendorName, isNull);
      expect(model.receiptMode, 'Bank');
      expect(model.receiptDate, '04-06-2025');
      expect(model.transationCode, 'vfkkdnhh');
      expect(model.bankId, 13);
      expect(model.mappingId, 20);
      expect(model.accountNo, '9822279799');
    });

    test('toJson returns correct map', () {
      final model = GetBankcashReceiptListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['CustomerId'], 60);
      expect(json['ReceiptId'], 153);
      expect(json['ReceiptNo'], 'RC/000042');
      expect(json['DistributorId'], 8118);
      expect(json['Amount'], 1000.0);
      expect(json['ReceiptMode'], 'Bank');
      expect(json['VendorName'], isNull);
      expect(json['BankId'], 13);
      expect(json['AccountNo'], '9822279799');
    });

    test('copyWith updates specified fields', () {
      final model = GetBankcashReceiptListModel.fromJson(sampleJson);
      final updated = model.copyWith(amount: 2000.0, receiptMode: 'Cash');

      expect(updated.amount, 2000.0);
      expect(updated.receiptMode, 'Cash');
      expect(model.amount, 1000.0);
      expect(model.receiptMode, 'Bank');
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetBankcashReceiptListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'New Staff');

      expect(updated.customerId, model.customerId);
      expect(updated.receiptId, model.receiptId);
      expect(updated.bankId, model.bankId);
    });

    test('constructor with null values', () {
      final model = GetBankcashReceiptListModel();
      expect(model.customerId, isNull);
      expect(model.receiptNo, isNull);
      expect(model.amount, isNull);
    });
  });
}

