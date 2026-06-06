import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/CheckConsumerNumberIsValidPrepaid.dart';

void main() {
  group('CheckConsumerNumberIsValidPrepaid', () {
    final sampleJson = {
      'DistributorId': 8118,
      'OrderRefNo': 5250811800071846.0,
      'OrderNo': '597338',
      'OrderDate': '2025-05-03T10:10:58',
      'CashDate': null,
      'ConsumerNo': '614075',
      'ConsumerName': 'Bhatia Arun',
      'PaymentStatus': 'Credited',
      'ConsumerRemark': 'Punched In cDCMS',
      'PayDate': '2025-05-03T10:16:46',
      'DeliveryDate': '2025-05-05T11:01:12.29',
      'SettDate': '2025-05-03T12:00:00',
      'NiyojanDel': 0,
      'cDCMSDel': 1,
      'InCorrectStatus': 0,
      'UnAccVerified': 0,
      'BypassOn': 0,
      'Isvalid': 1,
      'AddedBy': 0,
    };

    test('constructor sets all fields correctly', () {
      final model = CheckConsumerNumberIsValidPrepaid(
        distributorId: 8118,
        orderNo: '597338',
        consumerNo: '614075',
        consumerName: 'Bhatia Arun',
        paymentStatus: 'Credited',
        niyojanDel: 0,
        cDCMSDel: 1,
        isvalid: 1,
      );
      expect(model.distributorId, 8118);
      expect(model.orderNo, '597338');
      expect(model.consumerNo, '614075');
      expect(model.consumerName, 'Bhatia Arun');
      expect(model.paymentStatus, 'Credited');
      expect(model.isvalid, 1);
    });

    test('fromJson parses all fields correctly', () {
      final model = CheckConsumerNumberIsValidPrepaid.fromJson(sampleJson);
      expect(model.distributorId, 8118);
      expect(model.orderNo, '597338');
      expect(model.consumerNo, '614075');
      expect(model.consumerName, 'Bhatia Arun');
      expect(model.paymentStatus, 'Credited');
      expect(model.cashDate, isNull);
      expect(model.niyojanDel, 0);
      expect(model.cDCMSDel, 1);
      expect(model.inCorrectStatus, 0);
      expect(model.isvalid, 1);
    });

    test('toJson returns correct map', () {
      final model = CheckConsumerNumberIsValidPrepaid.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DistributorId'], 8118);
      expect(json['ConsumerNo'], '614075');
      expect(json['PaymentStatus'], 'Credited');
      expect(json['Isvalid'], 1);
      expect(json['CashDate'], isNull);
    });

    test('toJson includes all keys', () {
      final model = CheckConsumerNumberIsValidPrepaid.fromJson(sampleJson);
      final json = model.toJson();
      for (final key in ['DistributorId','OrderRefNo','OrderNo','OrderDate','CashDate',
        'ConsumerNo','ConsumerName','PaymentStatus','ConsumerRemark','PayDate',
        'DeliveryDate','SettDate','NiyojanDel','cDCMSDel','InCorrectStatus',
        'UnAccVerified','BypassOn','Isvalid','AddedBy']) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('copyWith updates specified fields', () {
      final model = CheckConsumerNumberIsValidPrepaid.fromJson(sampleJson);
      final updated = model.copyWith(consumerName: 'New Name', isvalid: 0);
      expect(updated.consumerName, 'New Name');
      expect(updated.isvalid, 0);
      expect(model.consumerName, 'Bhatia Arun');
    });

    test('copyWith preserves non-updated fields', () {
      final model = CheckConsumerNumberIsValidPrepaid.fromJson(sampleJson);
      final updated = model.copyWith(bypassOn: 1);
      expect(updated.distributorId, model.distributorId);
      expect(updated.consumerNo, model.consumerNo);
      expect(updated.bypassOn, 1);
    });

    test('default constructor with null values', () {
      final model = CheckConsumerNumberIsValidPrepaid();
      expect(model.distributorId, isNull);
      expect(model.isvalid, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = CheckConsumerNumberIsValidPrepaid.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = CheckConsumerNumberIsValidPrepaid.fromJson(json);
      expect(model2.consumerNo, model.consumerNo);
      expect(model2.paymentStatus, model.paymentStatus);
      expect(model2.isvalid, model.isvalid);
    });
  });
}

