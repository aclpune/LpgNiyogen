import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ConsumerModel.dart';

void main() {
  group('ConsumerModel', () {
    final sampleJson = {
      'ConsId': 1,
      'DistributorId': 8118,
      'StaffId': 10,
      'ItemId': 1,
      'ConsumerNo': '100001',
      'Action': null,
      'AddedBy': 0,
      'ConsumerName': 'Test Consumer',
      'OrderDate': '2025-01-01',
      'CashDate': null,
      'PaymentStatus': 'Credited',
      'ConsumerRemark': 'Test remark',
      'NiyojanDel': 1,
      'cDCMSDel': 0,
      'InCorrectStatus': 0,
      'PayDate': '2025-01-01',
      'DeliveryDate': '2025-01-02',
      'SettDate': '2025-01-01',
    };

    test('constructor sets all fields correctly', () {
      final model = ConsumerModel(
        consId: 1,
        distributorId: 8118,
        staffId: 10,
        itemId: 1,
        consumerNo: '100001',
        consumerName: 'Test Consumer',
        paymentStatus: 'Credited',
        niyojanDel: 1,
      );
      expect(model.consId, 1);
      expect(model.distributorId, 8118);
      expect(model.consumerNo, '100001');
      expect(model.consumerName, 'Test Consumer');
      expect(model.paymentStatus, 'Credited');
    });

    test('fromJson parses all fields correctly', () {
      final model = ConsumerModel.fromJson(sampleJson);
      expect(model.consId, 1);
      expect(model.distributorId, 8118);
      expect(model.staffId, 10);
      expect(model.itemId, 1);
      expect(model.consumerNo, '100001');
      expect(model.action, isNull);
      expect(model.consumerName, 'Test Consumer');
      expect(model.paymentStatus, 'Credited');
      expect(model.niyojanDel, 1);
      expect(model.cDCMSDel, 0);
    });

    test('toJson returns correct map', () {
      final model = ConsumerModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['ConsId'], 1);
      expect(json['ConsumerNo'], '100001');
      expect(json['ConsumerName'], 'Test Consumer');
      expect(json['PaymentStatus'], 'Credited');
      expect(json['Action'], isNull);
    });

    test('toJson includes all keys', () {
      final model = ConsumerModel.fromJson(sampleJson);
      final json = model.toJson();
      for (final key in ['ConsId','DistributorId','StaffId','ItemId','ConsumerNo',
        'Action','AddedBy','ConsumerName','OrderDate','CashDate','PaymentStatus',
        'ConsumerRemark','NiyojanDel','cDCMSDel','InCorrectStatus','PayDate',
        'DeliveryDate','SettDate']) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('default constructor with null values', () {
      final model = ConsumerModel();
      expect(model.consId, isNull);
      expect(model.consumerName, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ConsumerModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ConsumerModel.fromJson(json);
      expect(model2.consId, model.consId);
      expect(model2.consumerNo, model.consumerNo);
      expect(model2.paymentStatus, model.paymentStatus);
    });
  });
}

