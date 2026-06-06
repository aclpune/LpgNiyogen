import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/DilySaleSummaryDeliveryBoyWiseListModel.dart';

void main() {
  group('DilySaleSummaryDeliveryBoyWiseListModel', () {
    final sampleJson = {
      'SaleGKId': 4957,
      'DistributorId': 8118,
      'StaffId': 42,
      'DSCollMgrId': 0,
      'StaffNo': 'SN/027',
      'StaffName': '5kg Swarup',
      'ItemId': 1,
      'ItemName': '14.2 KG',
      'SaleGKItemId': 5257,
      'GDFilledSale': 20,
      'ActualSaleQty': 18,
      'SVQty': 2,
      'TVQty': 0,
      'Amount': 15399.00,
      'CashQty': 0,
      'CashAmt': 0.00,
      'PrepaidQty': 0,
      'PrepaidAmt': 0.00,
      'PostQty': 0,
      'PostAmt': 0.00,
      'CreditQty': 0,
      'CreditAmt': 0.00,
      'EmptyRetQty': 16,
      'DeffQty': 0,
      'LessEmptyQty': 2,
      'DailySaleStatus': 2,
      'DenoCashExptd': 0.0,
      'DenoCashRcvd': 0.0,
      'CashBalance': 0.0,
      'UserName': '',
      'StatusStr': 'Accepted',
      'AddedBy': 0,
      'IsActive': 0,
      'AddedOn': '0001-01-01T00:00:00',
      'DelDate': '2025-09-10T00:00:00',
      'ItemSubType': 'DOM',
    };

    test('fromJson parses all fields correctly', () {
      final model = DilySaleSummaryDeliveryBoyWiseListModel.fromJson(sampleJson);
      expect(model.saleGKId, 4957);
      expect(model.distributorId, 8118);
      expect(model.staffName, '5kg Swarup');
      expect(model.itemName, '14.2 KG');
      expect(model.actualSaleQty, 18);
      expect(model.amount, 15399.00);
      expect(model.statusStr, 'Accepted');
      expect(model.dailySaleStatus, 2);
      expect(model.itemSubType, 'DOM');
    });

    test('toJson returns correct map', () {
      final model = DilySaleSummaryDeliveryBoyWiseListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['SaleGKId'], 4957);
      expect(json['StaffName'], '5kg Swarup');
      expect(json['Amount'], 15399.00);
      expect(json['StatusStr'], 'Accepted');
      expect(json['ItemSubType'], 'DOM');
    });

    test('copyWith updates specified fields', () {
      final model = DilySaleSummaryDeliveryBoyWiseListModel.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'New Staff', amount: 20000.0);
      expect(updated.staffName, 'New Staff');
      expect(updated.amount, 20000.0);
      expect(model.staffName, '5kg Swarup');
    });

    test('copyWith preserves non-updated fields', () {
      final model = DilySaleSummaryDeliveryBoyWiseListModel.fromJson(sampleJson);
      final updated = model.copyWith(dailySaleStatus: 3);
      expect(updated.saleGKId, model.saleGKId);
      expect(updated.itemName, model.itemName);
    });

    test('default constructor with null values', () {
      final model = DilySaleSummaryDeliveryBoyWiseListModel();
      expect(model.saleGKId, isNull);
      expect(model.staffName, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = DilySaleSummaryDeliveryBoyWiseListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = DilySaleSummaryDeliveryBoyWiseListModel.fromJson(json);
      expect(model2.saleGKId, model.saleGKId);
      expect(model2.staffName, model.staffName);
      expect(model2.amount, model.amount);
      expect(model2.dailySaleStatus, model.dailySaleStatus);
    });
  });
}

