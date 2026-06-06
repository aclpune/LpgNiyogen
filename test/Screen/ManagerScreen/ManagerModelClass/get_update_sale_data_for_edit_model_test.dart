import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetUpdateSaleDataForEditModel.dart';

void main() {
  group('GetUpdateSaleDataForEditModel', () {
    final sampleJson = {
      'DSCollMgrId': 0,
      'SaleGKId': 10,
      'SaleGKItemId': 20,
      'DistributorId': 8118,
      'CashDenomDtls': [
        {'Id': 1, 'NoteType': 500.00, 'Quantity': 2, 'TotalAmt': 1000.00, 'RetNoteQty': 0, 'RetNoteAmt': 0.00},
      ],
      'consumerDtls': null,
      'PostpaidDtls': null,
      'ReticulatedDtls': null,
    };

    test('fromJson parses top-level fields correctly', () {
      final model = GetUpdateSaleDataForEditModel.fromJson(sampleJson);
      expect(model.dSCollMgrId, 0);
      expect(model.saleGKId, 10);
      expect(model.saleGKItemId, 20);
      expect(model.distributorId, 8118);
    });

    test('fromJson parses CashDenomDtls list correctly', () {
      final model = GetUpdateSaleDataForEditModel.fromJson(sampleJson);
      expect(model.cashDenomDtls, isNotNull);
      expect(model.cashDenomDtls!.length, 1);
      expect(model.cashDenomDtls!.first.noteType, 500.00);
      expect(model.cashDenomDtls!.first.quantity, 2);
    });

    test('fromJson with null sub-lists returns null', () {
      final model = GetUpdateSaleDataForEditModel.fromJson(sampleJson);
      expect(model.consumerDtls, isNull);
      expect(model.postpaidDtls, isNull);
      expect(model.reticulatedDtls, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetUpdateSaleDataForEditModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['DSCollMgrId'], 0);
      expect(json['SaleGKId'], 10);
      expect(json['DistributorId'], 8118);
    });

    test('copyWith updates specified fields', () {
      final model = GetUpdateSaleDataForEditModel.fromJson(sampleJson);
      final updated = model.copyWith(saleGKId: 99);
      expect(updated.saleGKId, 99);
      expect(model.saleGKId, 10);
    });

    test('default constructor with null values', () {
      final model = GetUpdateSaleDataForEditModel();
      expect(model.saleGKId, isNull);
      expect(model.cashDenomDtls, isNull);
    });

    test('fromJson with all sub-lists populated', () {
      final json = {
        'DSCollMgrId': 1,
        'SaleGKId': 5,
        'SaleGKItemId': 6,
        'DistributorId': 100,
        'CashDenomDtls': [
          {'Id': 1, 'NoteType': 100.0, 'Quantity': 3, 'TotalAmt': 300.0, 'RetNoteQty': 0, 'RetNoteAmt': 0.0},
        ],
        'consumerDtls': [
          {'ConsId': 1, 'DistributorId': 100, 'StaffId': 2, 'ItemId': 1, 'ConsumerNo': '12345',
           'Action': null, 'AddedBy': 0, 'ConsumerName': 'Test', 'OrderDate': null, 'CashDate': null,
           'PaymentStatus': 'Credited', 'ConsumerRemark': '', 'NiyojanDel': 1, 'cDCMSDel': 0,
           'InCorrectStatus': 0, 'PayDate': null, 'DeliveryDate': null, 'SettDate': null},
        ],
        'PostpaidDtls': [
          {'TransId': 1, 'DistributorId': 100, 'StaffId': 2, 'ItemId': 1,
           'TransactionCode': 'T1', 'TransTime': '', 'Remark': '', 'Action': null, 'AddedBy': 0},
        ],
        'ReticulatedDtls': [
          {'RetId': 1, 'DistributorId': 100, 'StaffId': 2, 'ItemId': 1,
           'PaymentMode': 'Cash', 'Quantity': 1, 'Amount': 855.5, 'DiscountAmt': 0.0,
           'CustomerId': 5, 'CustomerName': 'Co', 'ReticulatedRemark': '', 'Action': null, 'AddedBy': 0},
        ],
      };
      final model = GetUpdateSaleDataForEditModel.fromJson(json);
      expect(model.cashDenomDtls!.length, 1);
      expect(model.consumerDtls!.length, 1);
      expect(model.postpaidDtls!.length, 1);
      expect(model.reticulatedDtls!.length, 1);
    });
  });
}

