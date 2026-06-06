import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SalaryPaymentScreen/GetSalaryIncentiveEntryListModel.dart';

void main() {
  group('GetSalaryIncentiveEntryListModel', () {
    final sampleJson = {
      'SalaryEntryId': 36,
      'DistributorId': 8118,
      'PaidDate': '2025-06-13T00:00:00',
      'StaffId': 214,
      'StaffName': 'Snehal',
      'PaidAgainst': 'Salary',
      'PaidSalaryAmt': 100.0,
      'PaymentMode': 'Online',
      'BankId': 14,
      'BankMappingId': 19,
      'AccountNo': '7777005279799',
      'BankName': 'ICICI',
      'TransactionCode': 'wdftff',
      'TransactionTime': '1',
      'TransactionRemark': '',
      'Remark': '',
      'AddedBy': 0,
      'Action': null,
      'DenomDtList': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetSalaryIncentiveEntryListModel(
        salaryEntryId: 36,
        distributorId: 8118,
        paidDate: '2025-06-13T00:00:00',
        staffId: 214,
        staffName: 'Snehal',
        paidAgainst: 'Salary',
        paidSalaryAmt: 100.0,
        paymentMode: 'Online',
        bankId: 14,
        bankMappingId: 19,
        accountNo: '7777005279799',
        bankName: 'ICICI',
        transactionCode: 'wdftff',
        transactionTime: '1',
        transactionRemark: '',
        remark: '',
        addedBy: 0,
      );

      expect(model.salaryEntryId, 36);
      expect(model.distributorId, 8118);
      expect(model.paidDate, '2025-06-13T00:00:00');
      expect(model.staffId, 214);
      expect(model.staffName, 'Snehal');
      expect(model.paidAgainst, 'Salary');
      expect(model.paidSalaryAmt, 100.0);
      expect(model.paymentMode, 'Online');
      expect(model.bankId, 14);
      expect(model.bankMappingId, 19);
      expect(model.accountNo, '7777005279799');
      expect(model.bankName, 'ICICI');
      expect(model.transactionCode, 'wdftff');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetSalaryIncentiveEntryListModel.fromJson(sampleJson);

      expect(model.salaryEntryId, 36);
      expect(model.distributorId, 8118);
      expect(model.paidDate, '2025-06-13T00:00:00');
      expect(model.staffId, 214);
      expect(model.staffName, 'Snehal');
      expect(model.paidAgainst, 'Salary');
      expect(model.paidSalaryAmt, 100.0);
      expect(model.paymentMode, 'Online');
      expect(model.bankId, 14);
      expect(model.bankMappingId, 19);
      expect(model.accountNo, '7777005279799');
      expect(model.bankName, 'ICICI');
      expect(model.transactionCode, 'wdftff');
      expect(model.transactionTime, '1');
      expect(model.transactionRemark, '');
      expect(model.remark, '');
      expect(model.addedBy, 0);
      expect(model.action, isNull);
      expect(model.denomDtList, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetSalaryIncentiveEntryListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['SalaryEntryId'], 36);
      expect(json['DistributorId'], 8118);
      expect(json['StaffId'], 214);
      expect(json['StaffName'], 'Snehal');
      expect(json['PaidSalaryAmt'], 100.0);
      expect(json['PaymentMode'], 'Online');
      expect(json['BankName'], 'ICICI');
      expect(json['Action'], isNull);
      expect(json['DenomDtList'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetSalaryIncentiveEntryListModel.fromJson(sampleJson);
      final updated = model.copyWith(paidSalaryAmt: 500.0, paymentMode: 'Cash');

      expect(updated.paidSalaryAmt, 500.0);
      expect(updated.paymentMode, 'Cash');
      expect(model.paidSalaryAmt, 100.0);
      expect(model.paymentMode, 'Online');
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetSalaryIncentiveEntryListModel.fromJson(sampleJson);
      final updated = model.copyWith(remark: 'Updated');

      expect(updated.salaryEntryId, model.salaryEntryId);
      expect(updated.staffId, model.staffId);
      expect(updated.bankName, model.bankName);
    });

    test('constructor with null values', () {
      final model = GetSalaryIncentiveEntryListModel();
      expect(model.salaryEntryId, isNull);
      expect(model.staffName, isNull);
      expect(model.paidSalaryAmt, isNull);
    });
  });
}

