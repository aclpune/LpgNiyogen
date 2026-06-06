import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ARBSaleScreen/GetARBSalesListModel.dart';

void main() {
  // ── Fixtures ──────────────────────────────────────────────────────────────
  final Map<String, dynamic> itemDataListJson = {
    'ARBSalesId': 0,
    'ItemId': 9,
    'ItemName': '2 Burner Ujjawala',
    'Rate': 950.0,
    'ItemQty': 1,
    'DiscountAmt': 10.0,
    'ARBAmount': 940.0,
  };

  final Map<String, dynamic> fullJson = {
    'ARBSalesId': 281,
    'DistributorId': 8118,
    'SaleDate': '2026-02-04T10:47:39',
    'StaffId': 45,
    'StaffName': '19kg Gopal',
    'ConsumerNo': '123333',
    'ConsumerName': 'ram',
    'TotalAmount': 940.0,
    'PaymentMode': 'Bank',
    'TransactionCode': 'TRN849329',
    'TransactionTime': '3',
    'TransactionRemark': 'Okay',
    'AddedBy': 0,
    'Action': null,
    'ItemId': 9,
    'ItemName': '2 Burner Ujjawala',
    'Rate': 950.0,
    'ItemQty': 1,
    'DiscountAmt': 10.0,
    'ARBAmount': 940.0,
    'ItemDataList': [itemDataListJson],
    'DenomDtList': null,
    'BankId': 14,
    'BankMappingId': 19,
    'UpdatedFrom': null,
    'ReceiptAmt': 0.00,
    'QRReceiptAmt': 940.00,
    'ConsuContactNo': '9377484898',
    'ConsuAddress': 'A/p Pune, Pune, maharashtra',
    'InvoiceType': 'Manual',
    'InvoiceNo': '5588494',
  };

  // ── ItemDataList ──────────────────────────────────────────────────────────
  group('ItemDataList.fromJson', () {
    test('parses all fields correctly', () {
      final d = ItemDataList.fromJson(itemDataListJson);
      expect(d.aRBSalesId, 0);
      expect(d.itemId, 9);
      expect(d.itemName, '2 Burner Ujjawala');
      expect(d.rate, 950.0);
      expect(d.itemQty, 1);
      expect(d.discountAmt, 10.0);
      expect(d.aRBAmount, 940.0);
    });

    test('handles empty JSON', () {
      final d = ItemDataList.fromJson({});
      expect(d.itemId, isNull);
      expect(d.rate, isNull);
    });
  });

  group('ItemDataList.toJson', () {
    test('serialises 7 fields', () {
      final j = ItemDataList.fromJson(itemDataListJson).toJson();
      expect(j.length, 7);
      expect(j['ItemName'], '2 Burner Ujjawala');
      expect(j['ARBAmount'], 940.0);
    });

    test('round-trips correctly', () {
      final original = ItemDataList.fromJson(itemDataListJson);
      final restored = ItemDataList.fromJson(original.toJson());
      expect(restored.itemName, original.itemName);
      expect(restored.aRBAmount, original.aRBAmount);
    });
  });

  group('ItemDataList.copyWith', () {
    test('replaces discountAmt', () {
      final d = ItemDataList.fromJson(itemDataListJson);
      final copy = d.copyWith(discountAmt: 50.0);
      expect(copy.discountAmt, 50.0);
      expect(copy.rate, d.rate);
    });
  });

  // ── GetArbSalesListModel ──────────────────────────────────────────────────
  group('GetArbSalesListModel.fromJson', () {
    test('parses all scalar fields correctly', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      expect(m.aRBSalesId, 281);
      expect(m.distributorId, 8118);
      expect(m.saleDate, '2026-02-04T10:47:39');
      expect(m.staffId, 45);
      expect(m.staffName, '19kg Gopal');
      expect(m.consumerNo, '123333');
      expect(m.consumerName, 'ram');
      expect(m.totalAmount, 940.0);
      expect(m.paymentMode, 'Bank');
      expect(m.transactionCode, 'TRN849329');
      expect(m.transactionTime, '3');
      expect(m.transactionRemark, 'Okay');
      expect(m.addedBy, 0);
      expect(m.action, isNull);
      expect(m.itemId, 9);
      expect(m.itemName, '2 Burner Ujjawala');
      expect(m.rate, 950.0);
      expect(m.itemQty, 1);
      expect(m.discountAmt, 10.0);
      expect(m.aRBAmount, 940.0);
      expect(m.bankId, 14);
      expect(m.bankMappingId, 19);
      expect(m.receiptAmt, 0.00);
      expect(m.qRReceiptAmt, 940.00);
      expect(m.consuContactNo, '9377484898');
      expect(m.consuAddress, 'A/p Pune, Pune, maharashtra');
      expect(m.invoiceType, 'Manual');
      expect(m.invoiceNo, '5588494');
    });

    test('parses nested ItemDataList', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      expect(m.itemDataList, isNotNull);
      expect(m.itemDataList!.length, 1);
      expect(m.itemDataList!.first.itemName, '2 Burner Ujjawala');
    });

    test('null ItemDataList produces null list', () {
      final json = Map<String, dynamic>.from(fullJson);
      json['ItemDataList'] = null;
      final m = GetArbSalesListModel.fromJson(json);
      expect(m.itemDataList, isNull);
    });

    test('empty ItemDataList produces empty list', () {
      final json = Map<String, dynamic>.from(fullJson);
      json['ItemDataList'] = [];
      final m = GetArbSalesListModel.fromJson(json);
      expect(m.itemDataList, isEmpty);
    });

    test('handles empty JSON', () {
      final m = GetArbSalesListModel.fromJson({});
      expect(m.aRBSalesId, isNull);
      expect(m.itemDataList, isNull);
    });
  });

  group('GetArbSalesListModel.toJson', () {
    test('serialises key scalar fields', () {
      final j = GetArbSalesListModel.fromJson(fullJson).toJson();
      expect(j['ARBSalesId'], 281);
      expect(j['TotalAmount'], 940.0);
      expect(j['PaymentMode'], 'Bank');
      expect(j['InvoiceNo'], '5588494');
    });

    test('serialises nested ItemDataList', () {
      final j = GetArbSalesListModel.fromJson(fullJson).toJson();
      expect(j.containsKey('ItemDataList'), isTrue);
      final list = j['ItemDataList'] as List;
      expect(list.length, 1);
      expect(list.first['ItemName'], '2 Burner Ujjawala');
    });

    test('round-trips correctly', () {
      final original = GetArbSalesListModel.fromJson(fullJson);
      final restored = GetArbSalesListModel.fromJson(original.toJson());
      expect(restored.aRBSalesId, original.aRBSalesId);
      expect(restored.totalAmount, original.totalAmount);
      expect(restored.consuContactNo, original.consuContactNo);
    });
  });

  group('GetArbSalesListModel.copyWith', () {
    test('replaces paymentMode', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      final copy = m.copyWith(paymentMode: 'Cash');
      expect(copy.paymentMode, 'Cash');
      expect(copy.totalAmount, m.totalAmount);
    });

    test('replaces transactionCode', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      final copy = m.copyWith(transactionCode: 'NEW_TRN');
      expect(copy.transactionCode, 'NEW_TRN');
      expect(copy.aRBSalesId, m.aRBSalesId);
    });

    test('copyWith without args preserves all', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      final copy = m.copyWith();
      expect(copy.staffName, m.staffName);
      expect(copy.invoiceType, m.invoiceType);
    });
  });

  // ── Business logic ────────────────────────────────────────────────────────
  group('ARB Sale – business logic', () {
    test('ARBAmount = Rate - DiscountAmt', () {
      final d = ItemDataList.fromJson(itemDataListJson);
      final expected = (d.rate ?? 0) - (d.discountAmt ?? 0);
      expect(expected, d.aRBAmount);
    });

    test('TotalAmount matches ARBAmount for single-item sale', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      expect(m.totalAmount, m.aRBAmount);
    });

    test('QRReceiptAmt equals TotalAmount for QR payment', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      expect(m.qRReceiptAmt, m.totalAmount);
    });

    test('consumerNo is a non-empty string', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      expect(m.consumerNo, isNotEmpty);
    });

    test('contactNo has exactly 10 digits', () {
      final m = GetArbSalesListModel.fromJson(fullJson);
      expect(m.consuContactNo?.length, 10);
    });

    test('payment mode Cash results in receiptAmt > 0 (data-driven)', () {
      final cashJson = Map<String, dynamic>.from(fullJson);
      cashJson['PaymentMode'] = 'Cash';
      cashJson['ReceiptAmt'] = 940.0;
      cashJson['QRReceiptAmt'] = 0.0;
      final m = GetArbSalesListModel.fromJson(cashJson);
      expect(m.paymentMode, 'Cash');
      expect((m.receiptAmt ?? 0) > 0, isTrue);
    });
  });
}

