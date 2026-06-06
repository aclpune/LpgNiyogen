import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetConsumerCurrentDiscountDetailForCredtModel.dart';

void main() {
  group('GetConsumerCurrentDiscountDetailForCredtModel', () {
    final sampleJson = {
      'CustomerId': 60,
      'DistributorId': 8118,
      'ItemId': 3,
      'ItemName': '19 KG',
      'Discount': 20.00,
      'EffectiveDate': '2025-05-19T14:21:57',
    };

    test('constructor sets all fields correctly', () {
      final model = GetConsumerCurrentDiscountDetailForCredtModel(
        customerId: 60,
        distributorId: 8118,
        itemId: 3,
        itemName: '19 KG',
        discount: 20.00,
        effectiveDate: '2025-05-19T14:21:57',
      );
      expect(model.customerId, 60);
      expect(model.distributorId, 8118);
      expect(model.itemName, '19 KG');
      expect(model.discount, 20.00);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetConsumerCurrentDiscountDetailForCredtModel.fromJson(sampleJson);
      expect(model.customerId, 60);
      expect(model.distributorId, 8118);
      expect(model.itemId, 3);
      expect(model.itemName, '19 KG');
      expect(model.discount, 20.00);
      expect(model.effectiveDate, '2025-05-19T14:21:57');
    });

    test('toJson returns correct map', () {
      final model = GetConsumerCurrentDiscountDetailForCredtModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['CustomerId'], 60);
      expect(json['ItemName'], '19 KG');
      expect(json['Discount'], 20.00);
    });

    test('copyWith updates specified fields', () {
      final model = GetConsumerCurrentDiscountDetailForCredtModel.fromJson(sampleJson);
      final updated = model.copyWith(discount: 15.0, itemName: '14.2 KG');
      expect(updated.discount, 15.0);
      expect(updated.itemName, '14.2 KG');
      expect(model.discount, 20.00);
    });

    test('default constructor with null values', () {
      final model = GetConsumerCurrentDiscountDetailForCredtModel();
      expect(model.customerId, isNull);
      expect(model.discount, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetConsumerCurrentDiscountDetailForCredtModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetConsumerCurrentDiscountDetailForCredtModel.fromJson(json);
      expect(model2.customerId, model.customerId);
      expect(model2.discount, model.discount);
      expect(model2.itemName, model.itemName);
    });
  });
}

