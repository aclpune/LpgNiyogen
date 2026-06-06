import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/ManagerDSRReportExpenseDetailListModel.dart';

void main() {
  group('ManagerDsrReportExpenseDetailListModel', () {
    final sampleJson = {
      'DistributorId': 0,
      'IncomeId': 0,
      'TransCate': 'Other Expense',
      'Quantity': 0.0,
      'ExpHeadId': 6,
      'PHId': 5,
      'Mode': '',
      'ExpenseAmount': 1000.00,
      'ExpenseItemName': 'Miscellaneous',
      'categoryName': null,
      'PHName': 'Other Expense',
      'Date': '0001-01-01T00:00:00',
    };

    test('fromJson parses all fields correctly', () {
      final model = ManagerDsrReportExpenseDetailListModel.fromJson(sampleJson);
      expect(model.distributorId, 0);
      expect(model.transCate, 'Other Expense');
      expect(model.expHeadId, 6);
      expect(model.expenseAmount, 1000.00);
      expect(model.expenseItemName, 'Miscellaneous');
      expect(model.categoryName, isNull);
      expect(model.pHName, 'Other Expense');
    });

    test('toJson returns correct map', () {
      final model = ManagerDsrReportExpenseDetailListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['TransCate'], 'Other Expense');
      expect(json['ExpenseAmount'], 1000.00);
      expect(json['ExpenseItemName'], 'Miscellaneous');
      expect(json['categoryName'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = ManagerDsrReportExpenseDetailListModel.fromJson(sampleJson);
      final updated = model.copyWith(expenseAmount: 2000.0, transCate: 'Updated');
      expect(updated.expenseAmount, 2000.0);
      expect(updated.transCate, 'Updated');
      expect(model.expenseAmount, 1000.00);
    });

    test('default constructor with null values', () {
      final model = ManagerDsrReportExpenseDetailListModel();
      expect(model.expenseAmount, isNull);
      expect(model.transCate, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = ManagerDsrReportExpenseDetailListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = ManagerDsrReportExpenseDetailListModel.fromJson(json);
      expect(model2.expHeadId, model.expHeadId);
      expect(model2.expenseAmount, model.expenseAmount);
      expect(model2.expenseItemName, model.expenseItemName);
    });
  });
}

