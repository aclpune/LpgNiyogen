import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDsrReportSavedDataFetchModelList.dart';

void main() {
  group('ManagerDsrReportSavedDataFetchModelList', () {
    final sampleJson = {
      'Date': '2025-01-01T00:00:00',
      'DistributorId': 8118,
      'TotalDtls': [
        {'DSRId': 0, 'cashTotal': 1000.0, 'bankTotal': 500.0, 'creditTotal': 200.0,
         'unsettledTotal': 300.0, 'settledTotal': 100.0},
      ],
      'IncDtls': [
        {'DistributorId': 8118, 'IncomeId': 1, 'TransCate': 'DailySale',
         'Quantity': 10.0, 'UnsettQty': 0, 'SettQty': 0, 'Mode': '',
         'Amount': 8555.0, 'ItemName': '14.2 KG', 'ItemId': 1, 'Date': '0001-01-01T00:00:00'},
      ],
      'expDtls': [
        {'DistributorId': 8118, 'IncomeId': 0, 'TransCate': 'Expense',
         'Quantity': 1, 'ExpHeadId': 1, 'PHId': 1, 'Mode': '',
         'ExpenseAmount': 500.0, 'ExpenseItemName': 'Misc', 'categoryName': null,
         'PHName': 'Office', 'Date': '0001-01-01T00:00:00'},
      ],
      'handoverDtls': [
        {'DSRId': 0, 'StaffId': 4, 'StaffName': 'Test Staff', 'CollAmt': 1000.0,
         'PaidAmt': 0.0, 'TotalAmt': 1000.0, 'CashStatus': 0},
      ],
      'CashDenomDtls': [
        {'DSRId': 0, 'NoteId': 1, 'NoteType': 500.0, 'Qty': 2, 'Amount': 1000.0},
      ],
      'cashflowDtls': [
        {'DistributorId': 8118, 'StaffId': 0, 'BankId': 0,
         'HeaderNameStr': 'Cash In Hand', 'TotalAmt': 5000.0,
         'StaffName': 'Test', 'MappingId': 0},
      ],
      'SvTvDtls': [
        {'DistributorId': 8118, 'TransCate': 'SV', 'Quantity': 1, 'Mode': '',
         'Amount': 2450.0, 'ItemName': '14.2 KG', 'ItemId': 1,
         'Date': '0001-01-01T00:00:00', 'SVType': 'NC', 'TransDate': null, 'TotalSaleQty': 0},
      ],
      'dmsaleDtls': [
        {'DistributorId': 8118, 'DelDate': '0001-01-01T00:00:00', 'DMId': 45,
         'StaffNo': null, 'StaffName': 'Delivery Staff', 'ItemId': 1, 'ItemName': '14.2 KG',
         'FilledSaleQty': 10, 'SVQty': 0, 'TVQty': 0, 'EmptyRetQty': 0, 'DeffQty': 0,
         'LessEmptyQty': 0, 'ActualSaleQty': 10, 'DailySaleStatus': 0, 'DSCollMgrId': 0,
         'CollRcptDate': '0001-01-01T00:00:00', 'Rate': 0.0, 'TotalAmount': 8555.0,
         'TotPrepaidQty': 0, 'TotPrepaidAmt': 0.0, 'TotPostpaidQty': 0, 'TotPostpaidAmt': 0.0,
         'TotRetiCrQty': 0, 'TotRetiCrAmt': 0.0, 'TotCashQty': 0, 'TotCashAmt': 8555.0,
         'AddedBy': 0, 'DenoCashExptd': 0.0, 'DenoCashRcvd': 8555.0, 'CashBalance': 0.0,
         'FromDate': '0001-01-01T00:00:00'},
      ],
    };

    test('fromJson parses top-level fields correctly', () {
      final model = ManagerDsrReportSavedDataFetchModelList.fromJson(sampleJson);
      expect(model.date, '2025-01-01T00:00:00');
      expect(model.distributorId, 8118);
    });

    test('fromJson parses nested lists correctly', () {
      final model = ManagerDsrReportSavedDataFetchModelList.fromJson(sampleJson);
      expect(model.totalDtls, isNotNull);
      expect(model.totalDtls!.length, 1);
      expect(model.incDtls, isNotNull);
      expect(model.incDtls!.length, 1);
      expect(model.expDtls, isNotNull);
      expect(model.handoverDtls, isNotNull);
      expect(model.cashDenomDtls, isNotNull);
      expect(model.cashflowDtls, isNotNull);
      expect(model.svTvDtls, isNotNull);
      expect(model.dmsaleDtls, isNotNull);
    });

    test('cashDenomDtls noteType is correct', () {
      final model = ManagerDsrReportSavedDataFetchModelList.fromJson(sampleJson);
      expect(model.cashDenomDtls!.first.noteType, 500.0);
    });

    test('toJson returns a map', () {
      final model = ManagerDsrReportSavedDataFetchModelList.fromJson(sampleJson);
      final json = model.toJson();
      expect(json, isA<Map<String, dynamic>>());
      expect(json['Date'], '2025-01-01T00:00:00');
      expect(json['DistributorId'], 8118);
    });

    test('fromJson with null sub-lists returns null', () {
      final json = {
        'Date': '2025-01-01T00:00:00',
        'DistributorId': 8118,
        'TotalDtls': null,
        'IncDtls': null,
        'expDtls': null,
        'handoverDtls': null,
        'CashDenomDtls': null,
        'cashflowDtls': null,
        'SvTvDtls': null,
        'dmsaleDtls': null,
      };
      final model = ManagerDsrReportSavedDataFetchModelList.fromJson(json);
      expect(model.totalDtls, isNull);
      expect(model.incDtls, isNull);
    });

    test('default constructor with null values', () {
      final model = ManagerDsrReportSavedDataFetchModelList();
      expect(model.date, isNull);
      expect(model.distributorId, isNull);
      expect(model.cashDenomDtls, isNull);
    });
  });
}

