import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/TVSaleScreen/GetTVSaleListModel.dart';

void main() {
  group('GetTvSaleListModel', () {
    final sampleJson = {
      'TVId': 2,
      'DistributorId': 8118,
      'TVDate': '2025-06-21T00:00:00',
      'StaffId': 44,
      'StaffName': '19kg Devendra',
      'ConsumerNo': '100002',
      'ClyReceivedQty': 2,
      'IsRegulator': 'Yes',
      'DepositAmt': 1500.00,
      'RefillGasAmt': 1000.00,
      'PaidAmt': 1500.00,
      'Remark': 'Test TV Details',
      'AddedBy': 4,
      'Action': null,
      'ClyHoldQty': 2,
      'PaymentMode': 'Cash',
      'TransactionCode': '',
      'TransactionTime': '',
      'TransactionRemark': '',
      'DenomTVList': null,
      'ConsumerName': 'Pravin',
      'ItemId': 3,
      'ItemName': '19 KG',
      'BankId': 0,
      'BankMappingId': 0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetTvSaleListModel(
        tVId: 2,
        distributorId: 8118,
        tVDate: '2025-06-21T00:00:00',
        staffId: 44,
        staffName: '19kg Devendra',
        consumerNo: '100002',
        clyReceivedQty: 2,
        isRegulator: 'Yes',
        depositAmt: 1500.00,
        refillGasAmt: 1000.00,
        paidAmt: 1500.00,
        remark: 'Test TV Details',
        addedBy: 4,
        clyHoldQty: 2,
        paymentMode: 'Cash',
        transactionCode: '',
        transactionTime: '',
        transactionRemark: '',
        consumerName: 'Pravin',
        itemId: 3,
        itemName: '19 KG',
        bankId: 0,
        bankMappingId: 0,
      );

      expect(model.tVId, 2);
      expect(model.distributorId, 8118);
      expect(model.tVDate, '2025-06-21T00:00:00');
      expect(model.staffId, 44);
      expect(model.staffName, '19kg Devendra');
      expect(model.consumerNo, '100002');
      expect(model.clyReceivedQty, 2);
      expect(model.isRegulator, 'Yes');
      expect(model.depositAmt, 1500.00);
      expect(model.refillGasAmt, 1000.00);
      expect(model.paidAmt, 1500.00);
      expect(model.remark, 'Test TV Details');
      expect(model.addedBy, 4);
      expect(model.clyHoldQty, 2);
      expect(model.paymentMode, 'Cash');
      expect(model.consumerName, 'Pravin');
      expect(model.itemId, 3);
      expect(model.itemName, '19 KG');
      expect(model.bankId, 0);
      expect(model.bankMappingId, 0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetTvSaleListModel.fromJson(sampleJson);

      expect(model.tVId, 2);
      expect(model.distributorId, 8118);
      expect(model.tVDate, '2025-06-21T00:00:00');
      expect(model.staffId, 44);
      expect(model.staffName, '19kg Devendra');
      expect(model.consumerNo, '100002');
      expect(model.clyReceivedQty, 2);
      expect(model.isRegulator, 'Yes');
      expect(model.depositAmt, 1500.00);
      expect(model.refillGasAmt, 1000.00);
      expect(model.paidAmt, 1500.00);
      expect(model.remark, 'Test TV Details');
      expect(model.addedBy, 4);
      expect(model.action, isNull);
      expect(model.clyHoldQty, 2);
      expect(model.paymentMode, 'Cash');
      expect(model.transactionCode, '');
      expect(model.transactionTime, '');
      expect(model.transactionRemark, '');
      expect(model.denomTVList, isNull);
      expect(model.consumerName, 'Pravin');
      expect(model.itemId, 3);
      expect(model.itemName, '19 KG');
      expect(model.bankId, 0);
      expect(model.bankMappingId, 0);
    });

    test('toJson returns correct map', () {
      final model = GetTvSaleListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['TVId'], 2);
      expect(json['DistributorId'], 8118);
      expect(json['TVDate'], '2025-06-21T00:00:00');
      expect(json['StaffId'], 44);
      expect(json['StaffName'], '19kg Devendra');
      expect(json['ConsumerNo'], '100002');
      expect(json['ClyReceivedQty'], 2);
      expect(json['IsRegulator'], 'Yes');
      expect(json['DepositAmt'], 1500.00);
      expect(json['RefillGasAmt'], 1000.00);
      expect(json['PaidAmt'], 1500.00);
      expect(json['Remark'], 'Test TV Details');
      expect(json['AddedBy'], 4);
      expect(json['Action'], isNull);
      expect(json['ClyHoldQty'], 2);
      expect(json['PaymentMode'], 'Cash');
      expect(json['ConsumerName'], 'Pravin');
      expect(json['ItemId'], 3);
      expect(json['ItemName'], '19 KG');
      expect(json['BankId'], 0);
      expect(json['BankMappingId'], 0);
    });

    test('copyWith updates specified fields', () {
      final model = GetTvSaleListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'Updated Staff', paidAmt: 2000.0);

      expect(updated.staffName, 'Updated Staff');
      expect(updated.paidAmt, 2000.0);
      // original unchanged
      expect(model.staffName, '19kg Devendra');
      expect(model.paidAmt, 1500.00);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetTvSaleListModel.fromJson(sampleJson);
      final updated = model.copyWith(remark: 'New Remark');

      expect(updated.tVId, model.tVId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.consumerNo, model.consumerNo);
      expect(updated.isRegulator, model.isRegulator);
      expect(updated.remark, 'New Remark');
    });

    test('copyWith with multiple fields', () {
      final model = GetTvSaleListModel.fromJson(sampleJson);
      final updated = model.copyWith(
        depositAmt: 3000.0,
        paymentMode: 'Online',
        transactionCode: 'TXN123',
      );

      expect(updated.depositAmt, 3000.0);
      expect(updated.paymentMode, 'Online');
      expect(updated.transactionCode, 'TXN123');
      expect(updated.clyReceivedQty, model.clyReceivedQty);
    });

    test('default constructor with null values', () {
      final model = GetTvSaleListModel();

      expect(model.tVId, isNull);
      expect(model.staffId, isNull);
      expect(model.depositAmt, isNull);
      expect(model.paidAmt, isNull);
      expect(model.isRegulator, isNull);
    });

    test('fromJson with null optional fields', () {
      final json = {
        'TVId': 10,
        'DistributorId': 100,
        'TVDate': null,
        'StaffId': null,
        'StaffName': null,
        'ConsumerNo': null,
        'ClyReceivedQty': null,
        'IsRegulator': null,
        'DepositAmt': null,
        'RefillGasAmt': null,
        'PaidAmt': null,
        'Remark': null,
        'AddedBy': null,
        'Action': null,
        'ClyHoldQty': null,
        'PaymentMode': null,
        'TransactionCode': null,
        'TransactionTime': null,
        'TransactionRemark': null,
        'DenomTVList': null,
        'ConsumerName': null,
        'ItemId': null,
        'ItemName': null,
        'BankId': null,
        'BankMappingId': null,
      };
      final model = GetTvSaleListModel.fromJson(json);

      expect(model.tVId, 10);
      expect(model.distributorId, 100);
      expect(model.tVDate, isNull);
      expect(model.staffId, isNull);
      expect(model.paidAmt, isNull);
      expect(model.denomTVList, isNull);
    });

    test('toJson includes all keys', () {
      final model = GetTvSaleListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json.containsKey('TVId'), isTrue);
      expect(json.containsKey('DistributorId'), isTrue);
      expect(json.containsKey('TVDate'), isTrue);
      expect(json.containsKey('StaffId'), isTrue);
      expect(json.containsKey('StaffName'), isTrue);
      expect(json.containsKey('ConsumerNo'), isTrue);
      expect(json.containsKey('ClyReceivedQty'), isTrue);
      expect(json.containsKey('IsRegulator'), isTrue);
      expect(json.containsKey('DepositAmt'), isTrue);
      expect(json.containsKey('RefillGasAmt'), isTrue);
      expect(json.containsKey('PaidAmt'), isTrue);
      expect(json.containsKey('Remark'), isTrue);
      expect(json.containsKey('AddedBy'), isTrue);
      expect(json.containsKey('Action'), isTrue);
      expect(json.containsKey('ClyHoldQty'), isTrue);
      expect(json.containsKey('PaymentMode'), isTrue);
      expect(json.containsKey('TransactionCode'), isTrue);
      expect(json.containsKey('TransactionTime'), isTrue);
      expect(json.containsKey('TransactionRemark'), isTrue);
      expect(json.containsKey('DenomTVList'), isTrue);
      expect(json.containsKey('ConsumerName'), isTrue);
      expect(json.containsKey('ItemId'), isTrue);
      expect(json.containsKey('ItemName'), isTrue);
      expect(json.containsKey('BankId'), isTrue);
      expect(json.containsKey('BankMappingId'), isTrue);
    });

    test('fromJson then toJson is consistent (round-trip)', () {
      final model = GetTvSaleListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetTvSaleListModel.fromJson(json);

      expect(model2.tVId, model.tVId);
      expect(model2.distributorId, model.distributorId);
      expect(model2.staffName, model.staffName);
      expect(model2.consumerNo, model.consumerNo);
      expect(model2.paidAmt, model.paidAmt);
      expect(model2.isRegulator, model.isRegulator);
      expect(model2.itemName, model.itemName);
    });
  });
}

