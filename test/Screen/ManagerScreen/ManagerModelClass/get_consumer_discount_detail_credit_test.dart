import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetConsumerDiscountDetailCredit.dart';

void main() {
  group('GetConsumerDiscountDetailCredit', () {
    final sampleJson = {
      'PkId': 87,
      'CustomerId': 57,
      'CustomerName': 'Eternia',
      'DistributorId': 8118,
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'RSP_Price': 855.50,
      'Discount': 10.00,
      'EffectiveDate': '2025-09-15T05:51:32.237',
    };

    test('fromJson parses all fields correctly', () {
      final model = GetConsumerDiscountDetailCredit.fromJson(sampleJson);
      expect(model.pkId, 87);
      expect(model.customerId, 57);
      expect(model.customerName, 'Eternia');
      expect(model.distributorId, 8118);
      expect(model.itemId, 1);
      expect(model.itemName, '14.2 KG');
      expect(model.rSPPrice, 855.50);
      expect(model.discount, 10.00);
      expect(model.effectiveDate, '2025-09-15T05:51:32.237');
    });

    test('toJson returns correct map', () {
      final model = GetConsumerDiscountDetailCredit.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['PkId'], 87);
      expect(json['CustomerName'], 'Eternia');
      expect(json['RSP_Price'], 855.50);
      expect(json['Discount'], 10.00);
    });

    test('copyWith updates specified fields', () {
      final model = GetConsumerDiscountDetailCredit.fromJson(sampleJson);
      final updated = model.copyWith(discount: 5.0, customerName: 'New Co');
      expect(updated.discount, 5.0);
      expect(updated.customerName, 'New Co');
      expect(model.discount, 10.00);
    });

    test('default constructor with null values', () {
      final model = GetConsumerDiscountDetailCredit();
      expect(model.pkId, isNull);
      expect(model.discount, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetConsumerDiscountDetailCredit.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetConsumerDiscountDetailCredit.fromJson(json);
      expect(model2.pkId, model.pkId);
      expect(model2.customerName, model.customerName);
      expect(model2.discount, model.discount);
    });
  });
}

