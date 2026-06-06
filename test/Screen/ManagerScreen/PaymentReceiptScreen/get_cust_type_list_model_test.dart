import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/PaymentReceiptScreen/GetCustTypeListModel.dart';

void main() {
  group('GetCustTypeListModel', () {
    final sampleJson = {
      'CustTypeId': 5,
      'CustomerType': 'Other',
      'IsActive': 1,
    };

    test('constructor sets all fields correctly', () {
      final model = GetCustTypeListModel(
        custTypeId: 5,
        customerType: 'Other',
        isActive: 1,
      );

      expect(model.custTypeId, 5);
      expect(model.customerType, 'Other');
      expect(model.isActive, 1);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetCustTypeListModel.fromJson(sampleJson);

      expect(model.custTypeId, 5);
      expect(model.customerType, 'Other');
      expect(model.isActive, 1);
    });

    test('toJson returns correct map', () {
      final model = GetCustTypeListModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['CustTypeId'], 5);
      expect(json['CustomerType'], 'Other');
      expect(json['IsActive'], 1);
    });

    test('copyWith updates specified fields', () {
      final model = GetCustTypeListModel.fromJson(sampleJson);
      final updated = model.copyWith(customerType: 'Exempted', isActive: 0);

      expect(updated.customerType, 'Exempted');
      expect(updated.isActive, 0);
      expect(model.customerType, 'Other');
      expect(model.isActive, 1);
    });

    test('copyWith preserves custTypeId when not overridden', () {
      final model = GetCustTypeListModel.fromJson(sampleJson);
      final updated = model.copyWith(isActive: 0);

      expect(updated.custTypeId, model.custTypeId);
      expect(updated.customerType, model.customerType);
    });

    test('constructor with null values', () {
      final model = GetCustTypeListModel();
      expect(model.custTypeId, isNull);
      expect(model.customerType, isNull);
      expect(model.isActive, isNull);
    });

    test('toJson round-trips correctly', () {
      final original = GetCustTypeListModel(custTypeId: 3, customerType: 'Commercial', isActive: 1);
      final json = original.toJson();
      final restored = GetCustTypeListModel.fromJson(json);

      expect(restored.custTypeId, 3);
      expect(restored.customerType, 'Commercial');
      expect(restored.isActive, 1);
    });
  });
}

