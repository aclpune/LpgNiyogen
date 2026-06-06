import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetConsumerDetailsCredit.dart';

void main() {
  group('GetConsumerDetailsCredit', () {
    final sampleJson = {
      'CustomerId': 27,
      'CustTypeId': 2,
      'DistributorId': 8118,
      'CustomerType': 'ND',
      'CustomerName': 'Amit',
      'CustAddress': 'Pune',
      'ContactNo': '8765432123',
      'CustomerEmail': 'amit@gmail.com',
      'CustomerGSTNo': '123456789',
      'ItemStr': null,
      'DiscountStr': null,
      'SVQty': 2,
      'IsActive': 1,
      'IsAlertMessage': 1,
      'AlertInterval': 'Monthly',
      'AddedBy': 0,
      'AddedOn': '0001-01-01T00:00:00',
      'Action': null,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetConsumerDetailsCredit.fromJson(sampleJson);
      expect(model.customerId, 27);
      expect(model.custTypeId, 2);
      expect(model.distributorId, 8118);
      expect(model.customerType, 'ND');
      expect(model.customerName, 'Amit');
      expect(model.custAddress, 'Pune');
      expect(model.contactNo, '8765432123');
      expect(model.customerEmail, 'amit@gmail.com');
      expect(model.isActive, 1);
      expect(model.alertInterval, 'Monthly');
      expect(model.itemStr, isNull);
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetConsumerDetailsCredit.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['CustomerId'], 27);
      expect(json['CustomerName'], 'Amit');
      expect(json['CustomerType'], 'ND');
      expect(json['IsActive'], 1);
      expect(json['Action'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetConsumerDetailsCredit.fromJson(sampleJson);
      final updated = model.copyWith(customerName: 'Updated Name', isActive: 0);
      expect(updated.customerName, 'Updated Name');
      expect(updated.isActive, 0);
      expect(model.customerName, 'Amit');
    });

    test('default constructor with null values', () {
      final model = GetConsumerDetailsCredit();
      expect(model.customerId, isNull);
      expect(model.customerName, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetConsumerDetailsCredit.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetConsumerDetailsCredit.fromJson(json);
      expect(model2.customerId, model.customerId);
      expect(model2.customerName, model.customerName);
      expect(model2.isActive, model.isActive);
    });
  });
}

