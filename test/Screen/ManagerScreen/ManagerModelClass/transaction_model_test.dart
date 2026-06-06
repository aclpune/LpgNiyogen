import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/TransactionModel.dart';

void main() {
  group('TransactionModel', () {
    final sampleJson = {
      'TransId': 10,
      'DistributorId': 8118,
      'StaffId': 5,
      'ItemId': 1,
      'TransactionCode': 'TX12345',
      'TransTime': '10:30:00',
      'Remark': 'Test transaction',
      'Action': null,
      'AddedBy': 0,
    };

    test('constructor sets all fields correctly', () {
      final model = TransactionModel(
        transId: 10,
        distributorId: 8118,
        staffId: 5,
        itemId: 1,
        transactionCode: 'TX12345',
        transTime: '10:30:00',
        remark: 'Test transaction',
      );
      expect(model.transId, 10);
      expect(model.distributorId, 8118);
      expect(model.transactionCode, 'TX12345');
      expect(model.remark, 'Test transaction');
    });

    test('fromJson parses all fields correctly', () {
      final model = TransactionModel.fromJson(sampleJson);
      expect(model.transId, 10);
      expect(model.distributorId, 8118);
      expect(model.staffId, 5);
      expect(model.itemId, 1);
      expect(model.transactionCode, 'TX12345');
      expect(model.transTime, '10:30:00');
      expect(model.remark, 'Test transaction');
      expect(model.action, isNull);
      expect(model.addedBy, 0);
    });

    test('toJson returns correct map', () {
      final model = TransactionModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['TransId'], 10);
      expect(json['TransactionCode'], 'TX12345');
      expect(json['Remark'], 'Test transaction');
      expect(json['Action'], isNull);
    });

    test('toJson includes all keys', () {
      final model = TransactionModel.fromJson(sampleJson);
      final json = model.toJson();
      for (final key in ['TransId','DistributorId','StaffId','ItemId',
        'TransactionCode','TransTime','Remark','Action','AddedBy']) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('default constructor with null values', () {
      final model = TransactionModel();
      expect(model.transId, isNull);
      expect(model.transactionCode, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = TransactionModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = TransactionModel.fromJson(json);
      expect(model2.transId, model.transId);
      expect(model2.transactionCode, model.transactionCode);
      expect(model2.remark, model.remark);
    });
  });
}

