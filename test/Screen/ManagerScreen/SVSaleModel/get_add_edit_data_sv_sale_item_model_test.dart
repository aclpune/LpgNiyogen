import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetAddEditDataSVSaleItemModel.dart';

void main() {
  group('GetAddEditDataSvSaleItemModel', () {
    final sampleJson = {
      'PSVId': 1123,
      'DistributorId': 8118,
      'SVDate': '2026-02-06T00:00:00',
      'ReferredById': 27,
      'ReferredByName': 'Bharti Naiknaware',
      'OtherName': 'Bharti Naiknaware',
      'ProductId': 1,
      'ProductName': '14.2 KG',
      'IsUndocument': true,
      'SVType': 'NC',
      'CylQty': 1,
      'SCRegulator': 1,
      'DepositCyl': 2200.0,
      'CylRefillRSP': 855.50,
      'RegulatorDeposit': 250.0,
      'StampDuty': 100.0,
      'FTLRegulator': 0,
      'BasicAmt': 3405.50,
      'ConsuDCNo': '',
      'ConsumerName': 'ram',
      'ConsuContactNo': '9985758586',
      'TotalAmount': 3464.50,
      'ReceiptAmt': 3464.50,
      'QRReceiptAmt': 0.0,
      'PaymentMode': 'Cash',
      'TransactionCode': '',
      'TransactionTime': '',
      'TransactionRemark': '',
      'AddedBy': 0,
      'Action': null,
      'ItemId': 14,
      'ItemName': 'DGCC Book',
      'Rate': 59.0,
      'ItemQty': 1,
      'DiscountAmt': 0.0,
      'ARBAmount': 59.0,
      'ItemDataList': null,
      'DenomDtList': null,
      'ItemDetails': null,
      'AmtCharges': 0.0,
      'CategoryName': 'Other',
      'BankId': 0,
      'BankMappingId': 0,
      'AccountNo': null,
      'BankName': null,
      'IsExemptReti': 0,
      'SVDiscountAmt': 0.0,
      'ConsuAddress': 'pune',
      'InvoiceType': 'Manual',
      'InvoiceNo': '56785',
    };

    test('constructor sets all fields correctly', () {
      final model = GetAddEditDataSvSaleItemModel(
        pSVId: 1123,
        distributorId: 8118,
        sVDate: '2026-02-06T00:00:00',
        referredById: 27,
        referredByName: 'Bharti Naiknaware',
        otherName: 'Bharti Naiknaware',
        productId: 1,
        productName: '14.2 KG',
        isUndocument: true,
        sVType: 'NC',
        cylQty: 1,
        sCRegulator: 1,
        depositCyl: 2200.0,
        cylRefillRSP: 855.50,
        regulatorDeposit: 250.0,
        stampDuty: 100.0,
        fTLRegulator: 0,
        basicAmt: 3405.50,
        consuDCNo: '',
        consumerName: 'ram',
        consuContactNo: '9985758586',
        totalAmount: 3464.50,
        receiptAmt: 3464.50,
        qRReceiptAmt: 0.0,
        paymentMode: 'Cash',
        transactionCode: '',
        transactionTime: '',
        transactionRemark: '',
        addedBy: 0,
        itemId: 14,
        itemName: 'DGCC Book',
        rate: 59.0,
        itemQty: 1,
        discountAmt: 0.0,
        aRBAmount: 59.0,
        amtCharges: 0.0,
        categoryName: 'Other',
        bankId: 0,
        bankMappingId: 0,
        isExemptReti: 0,
        sVDiscountAmt: 0.0,
        consuAddress: 'pune',
        invoiceType: 'Manual',
        invoiceNo: '56785',
      );

      expect(model.pSVId, 1123);
      expect(model.distributorId, 8118);
      expect(model.sVDate, '2026-02-06T00:00:00');
      expect(model.referredById, 27);
      expect(model.referredByName, 'Bharti Naiknaware');
      expect(model.otherName, 'Bharti Naiknaware');
      expect(model.productId, 1);
      expect(model.productName, '14.2 KG');
      expect(model.isUndocument, true);
      expect(model.sVType, 'NC');
      expect(model.cylQty, 1);
      expect(model.sCRegulator, 1);
      expect(model.depositCyl, 2200.0);
      expect(model.cylRefillRSP, 855.50);
      expect(model.regulatorDeposit, 250.0);
      expect(model.stampDuty, 100.0);
      expect(model.fTLRegulator, 0);
      expect(model.basicAmt, 3405.50);
      expect(model.consuDCNo, '');
      expect(model.consumerName, 'ram');
      expect(model.consuContactNo, '9985758586');
      expect(model.totalAmount, 3464.50);
      expect(model.receiptAmt, 3464.50);
      expect(model.qRReceiptAmt, 0.0);
      expect(model.paymentMode, 'Cash');
      expect(model.itemId, 14);
      expect(model.itemName, 'DGCC Book');
      expect(model.rate, 59.0);
      expect(model.itemQty, 1);
      expect(model.discountAmt, 0.0);
      expect(model.aRBAmount, 59.0);
      expect(model.amtCharges, 0.0);
      expect(model.categoryName, 'Other');
      expect(model.bankId, 0);
      expect(model.bankMappingId, 0);
      expect(model.isExemptReti, 0);
      expect(model.sVDiscountAmt, 0.0);
      expect(model.consuAddress, 'pune');
      expect(model.invoiceType, 'Manual');
      expect(model.invoiceNo, '56785');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetAddEditDataSvSaleItemModel.fromJson(sampleJson);

      expect(model.pSVId, 1123);
      expect(model.distributorId, 8118);
      expect(model.sVDate, '2026-02-06T00:00:00');
      expect(model.referredById, 27);
      expect(model.referredByName, 'Bharti Naiknaware');
      expect(model.productId, 1);
      expect(model.productName, '14.2 KG');
      expect(model.isUndocument, true);
      expect(model.sVType, 'NC');
      expect(model.cylQty, 1);
      expect(model.sCRegulator, 1);
      expect(model.depositCyl, 2200.0);
      expect(model.paymentMode, 'Cash');
      expect(model.itemId, 14);
      expect(model.itemName, 'DGCC Book');
      expect(model.rate, 59.0);
      expect(model.consuAddress, 'pune');
      expect(model.invoiceType, 'Manual');
      expect(model.invoiceNo, '56785');
      expect(model.action, isNull);
      expect(model.itemDetails, isNull);
    });

    test('fromJson parses ItemDetails list when provided', () {
      final jsonWithItems = Map<String, dynamic>.from(sampleJson);
      jsonWithItems['ItemDetails'] = [
        {
          'PSVId': 0,
          'DistributorId': 0,
          'SVDate': null,
          'ReferredById': 0,
          'ReferredByName': null,
          'OtherName': null,
          'ProductId': 0,
          'ProductName': null,
          'IsUndocument': false,
          'SVType': null,
          'CylQty': 0,
          'SCRegulator': 0,
          'DepositCyl': 0.0,
          'CylRefillRSP': 0.0,
          'RegulatorDeposit': 0.0,
          'StampDuty': 0.0,
          'FTLRegulator': 0,
          'BasicAmt': 0.0,
          'ConsuDCNo': null,
          'ConsumerName': null,
          'ConsuContactNo': null,
          'TotalAmount': 0.0,
          'ReceiptAmt': 0.0,
          'QRReceiptAmt': 0.0,
          'PaymentMode': null,
          'TransactionCode': null,
          'TransactionTime': null,
          'TransactionRemark': null,
          'AddedBy': 0,
          'Action': null,
          'ItemId': 14,
          'ItemName': 'DGCC Book',
          'Rate': 59.0,
          'ItemQty': 1,
          'DiscountAmt': 0.0,
          'ARBAmount': 59.0,
          'ItemDataList': null,
          'DenomDtList': null,
          'ItemDetails': null,
          'AmtCharges': 0.0,
          'CategoryName': 'Other',
          'BankId': 0,
          'BankMappingId': 0,
          'AccountNo': null,
          'BankName': null,
          'IsExemptReti': 0,
          'SVDiscountAmt': 0.0,
          'ConsuAddress': null,
          'InvoiceType': null,
          'InvoiceNo': null,
        }
      ];
      final model = GetAddEditDataSvSaleItemModel.fromJson(jsonWithItems);
      expect(model.itemDetails, isNotNull);
      expect(model.itemDetails!.length, 1);
      expect(model.itemDetails![0].itemName, 'DGCC Book');
      expect(model.itemDetails![0].rate, 59.0);
    });

    test('toJson returns correct map', () {
      final model = GetAddEditDataSvSaleItemModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['PSVId'], 1123);
      expect(json['DistributorId'], 8118);
      expect(json['SVDate'], '2026-02-06T00:00:00');
      expect(json['ConsumerName'], 'ram');
      expect(json['PaymentMode'], 'Cash');
      expect(json['ItemId'], 14);
      expect(json['ItemName'], 'DGCC Book');
      expect(json['ConsuAddress'], 'pune');
      expect(json['InvoiceType'], 'Manual');
      expect(json['InvoiceNo'], '56785');
    });

    test('copyWith returns new instance with updated fields', () {
      final model = GetAddEditDataSvSaleItemModel.fromJson(sampleJson);
      final updated = model.copyWith(consumerName: 'John', paymentMode: 'Online');

      expect(updated.consumerName, 'John');
      expect(updated.paymentMode, 'Online');
      // original unchanged
      expect(model.consumerName, 'ram');
      expect(model.paymentMode, 'Cash');
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetAddEditDataSvSaleItemModel.fromJson(sampleJson);
      final updated = model.copyWith(invoiceNo: '99999');

      expect(updated.invoiceNo, '99999');
      expect(updated.pSVId, model.pSVId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.productName, model.productName);
    });

    test('constructor with null values returns null fields', () {
      final model = GetAddEditDataSvSaleItemModel();
      expect(model.pSVId, isNull);
      expect(model.distributorId, isNull);
      expect(model.consumerName, isNull);
      expect(model.itemDetails, isNull);
    });
  });

  group('ItemDetails', () {
    final itemJson = {
      'PSVId': 0,
      'DistributorId': 0,
      'SVDate': null,
      'ReferredById': 0,
      'ReferredByName': null,
      'OtherName': null,
      'ProductId': 0,
      'ProductName': null,
      'IsUndocument': false,
      'SVType': null,
      'CylQty': 0,
      'SCRegulator': 0,
      'DepositCyl': 0.0,
      'CylRefillRSP': 0.0,
      'RegulatorDeposit': 0.0,
      'StampDuty': 0.0,
      'FTLRegulator': 0,
      'BasicAmt': 0.0,
      'ConsuDCNo': null,
      'ConsumerName': null,
      'ConsuContactNo': null,
      'TotalAmount': 0.0,
      'ReceiptAmt': 0.0,
      'QRReceiptAmt': 0.0,
      'PaymentMode': null,
      'TransactionCode': null,
      'TransactionTime': null,
      'TransactionRemark': null,
      'AddedBy': 0,
      'Action': null,
      'ItemId': 14,
      'ItemName': 'DGCC Book',
      'Rate': 59.0,
      'ItemQty': 1,
      'DiscountAmt': 0.0,
      'ARBAmount': 59.0,
      'ItemDataList': null,
      'DenomDtList': null,
      'ItemDetails': null,
      'AmtCharges': 0.0,
      'CategoryName': 'Other',
      'BankId': 0,
      'BankMappingId': 0,
      'AccountNo': null,
      'BankName': null,
      'IsExemptReti': 0,
      'SVDiscountAmt': 0.0,
      'ConsuAddress': null,
      'InvoiceType': null,
      'InvoiceNo': null,
    };

    test('fromJson parses fields correctly', () {
      final item = ItemDetails.fromJson(itemJson);
      expect(item.pSVId, 0);
      expect(item.itemId, 14);
      expect(item.itemName, 'DGCC Book');
      expect(item.rate, 59.0);
      expect(item.itemQty, 1);
      expect(item.discountAmt, 0.0);
      expect(item.aRBAmount, 59.0);
      expect(item.categoryName, 'Other');
      expect(item.isUndocument, false);
      expect(item.action, isNull);
    });

    test('toJson round-trips correctly', () {
      final item = ItemDetails.fromJson(itemJson);
      final json = item.toJson();
      expect(json['ItemId'], 14);
      expect(json['ItemName'], 'DGCC Book');
      expect(json['Rate'], 59.0);
      expect(json['CategoryName'], 'Other');
    });

    test('copyWith updates specified fields', () {
      final item = ItemDetails.fromJson(itemJson);
      final updated = item.copyWith(itemName: 'New Book', rate: 100.0);
      expect(updated.itemName, 'New Book');
      expect(updated.rate, 100.0);
      expect(item.itemName, 'DGCC Book');
    });

    test('constructor with null values', () {
      final item = ItemDetails();
      expect(item.itemId, isNull);
      expect(item.itemName, isNull);
    });
  });
}

