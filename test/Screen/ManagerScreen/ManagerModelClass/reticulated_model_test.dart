import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ReticulatedModel.dart';

void main() {
  group('ReticulatedModel', () {
    final sampleJson = {
      'RetId': 5,
      'DistributorId': 8118,
      'StaffId': 10,
      'ItemId': 1,
      'PaymentMode': 'Credit',
      'Quantity': 2,
      'Amount': 1711.0,
      'CustomerId': 25,
      'CustomerName': 'Reticulated Co',
      'ReticulatedRemark': 'Test remark',
      'Action': null,
      'AddedBy': 0,
      'DiscountAmt': 5.0,
      'CustTypeId': 2,
      'CustomerType': 'ND',
    };

    test('constructor sets all fields correctly', () {
      final model = ReticulatedModel(
        retId: 5,
        distributorId: 8118,
        staffId: 10,
        paymentMode: 'Credit',
        quantity: 2,
        amount: 1711.0,
        customerName: 'Reticulated Co',
      );
      expect(model.retId, 5);
      expect(model.paymentMode, 'Credit');
      expect(model.amount, 1711.0);
      expect(model.customerName, 'Reticulated Co');
    });

    test('fromJson parses all fields correctly', () {
      final model = ReticulatedModel.fromJson(sampleJson);
      expect(model.retId, 5);
      expect(model.distributorId, 8118);
      expect(model.paymentMode, 'Credit');
      expect(model.quantity, 2);
      expect(model.amount, 1711.0);
      expect(model.customerName, 'Reticulated Co');
      expect(model.discountAmount, 5.0);
      expect(model.customerTypeName, 'ND');
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = ReticulatedModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['RetId'], 5);
      expect(json['PaymentMode'], 'Credit');
      expect(json['Amount'], 1711.0);
      expect(json['CustomerName'], 'Reticulated Co');
      expect(json['Action'], isNull);
    });

    test('toJson includes all keys', () {
      final model = ReticulatedModel.fromJson(sampleJson);
      final json = model.toJson();
      for (final key in ['RetId','DistributorId','StaffId','ItemId','PaymentMode',
        'Quantity','Amount','CustomerId','CustomerName','ReticulatedRemark',
        'Action','AddedBy','DiscountAmt','CustTypeId','CustomerType']) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('default constructor with null values', () {
      final model = ReticulatedModel();
      expect(model.retId, isNull);
      expect(model.amount, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ReticulatedModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ReticulatedModel.fromJson(json);
      expect(model2.retId, model.retId);
      expect(model2.amount, model.amount);
      expect(model2.customerName, model.customerName);
    });
  });
}

