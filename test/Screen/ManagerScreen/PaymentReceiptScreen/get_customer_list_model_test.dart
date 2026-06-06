import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/PaymentReceiptScreen/GetCustomerListModel.dart';

void main() {
  group('GetCustomerListModel', () {
    final sampleJson = {
      'CustomerId': 193,
      'CustTypeId': 1,
      'DistributorId': 8118,
      'CustomerType': 'Exempted',
      'CustomerName': 'consumer1',
      'CustAddress': '',
      'ContactNo': '9874563212',
      'CustomerEmail': 'vrush@gmail.com',
      'CustomerGSTNo': '',
      'SVQty': 0,
      'IsActive': 1,
      'IsAlertMessage': 0,
      'AlertInterval': '',
      'AddedBy': 0,
      'AddedOn': '0001-01-01T00:00:00',
      'Action': null,
      'CreditAmt': 0.0,
      'DebitAmt': 0.0,
      'OnbordingFlag': 0,
      'PkId': 0,
      'Type': null,
      'TypeId': 0,
      'OpBalDate': '0001-01-01T00:00:00',
    };

    test('constructor sets all fields correctly', () {
      final model = GetCustomerListModel(
        customerId: 193,
        custTypeId: 1,
        distributorId: 8118,
        customerType: 'Exempted',
        customerName: 'consumer1',
        custAddress: '',
        contactNo: '9874563212',
        customerEmail: 'vrush@gmail.com',
        customerGSTNo: '',
        sVQty: 0,
        isActive: 1,
        isAlertMessage: 0,
        alertInterval: '',
        addedBy: 0,
        addedOn: '0001-01-01T00:00:00',
        creditAmt: 0.0,
        debitAmt: 0.0,
        onbordingFlag: 0,
        pkId: 0,
        typeId: 0,
        opBalDate: '0001-01-01T00:00:00',
      );

      expect(model.customerId, 193);
      expect(model.custTypeId, 1);
      expect(model.distributorId, 8118);
      expect(model.customerType, 'Exempted');
      expect(model.customerName, 'consumer1');
      expect(model.custAddress, '');
      expect(model.contactNo, '9874563212');
      expect(model.customerEmail, 'vrush@gmail.com');
      expect(model.isActive, 1);
      expect(model.creditAmt, 0.0);
      expect(model.debitAmt, 0.0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetCustomerListModel.fromJson(sampleJson);

      expect(model.customerId, 193);
      expect(model.custTypeId, 1);
      expect(model.distributorId, 8118);
      expect(model.customerType, 'Exempted');
      expect(model.customerName, 'consumer1');
      expect(model.custAddress, '');
      expect(model.contactNo, '9874563212');
      expect(model.customerEmail, 'vrush@gmail.com');
      expect(model.customerGSTNo, '');
      expect(model.sVQty, 0);
      expect(model.isActive, 1);
      expect(model.isAlertMessage, 0);
      expect(model.alertInterval, '');
      expect(model.addedBy, 0);
      expect(model.addedOn, '0001-01-01T00:00:00');
      expect(model.action, isNull);
      expect(model.creditAmt, 0.0);
      expect(model.debitAmt, 0.0);
      expect(model.onbordingFlag, 0);
      expect(model.pkId, 0);
      expect(model.type, isNull);
      expect(model.typeId, 0);
      expect(model.opBalDate, '0001-01-01T00:00:00');
    });

    test('toJson returns correct map', () {
      final model = GetCustomerListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['CustomerId'], 193);
      expect(json['CustomerName'], 'consumer1');
      expect(json['ContactNo'], '9874563212');
      expect(json['CustomerEmail'], 'vrush@gmail.com');
      expect(json['IsActive'], 1);
      expect(json['Action'], isNull);
      expect(json['CreditAmt'], 0.0);
      expect(json['Type'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetCustomerListModel.fromJson(sampleJson);
      final updated = model.copyWith(customerName: 'New Customer', isActive: 0);

      expect(updated.customerName, 'New Customer');
      expect(updated.isActive, 0);
      expect(model.customerName, 'consumer1');
      expect(model.isActive, 1);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetCustomerListModel.fromJson(sampleJson);
      final updated = model.copyWith(contactNo: '0000000000');

      expect(updated.customerId, model.customerId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.customerEmail, model.customerEmail);
    });

    test('constructor with null values', () {
      final model = GetCustomerListModel();
      expect(model.customerId, isNull);
      expect(model.customerName, isNull);
      expect(model.contactNo, isNull);
    });
  });
}

