import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetStaffLedgerReportModelList.dart';

void main() {
  group('GetStaffLedgerReportModelList', () {
    final sampleJson = {
      'LedgerId': 73,
      'DistributorId': 8118,
      'FromDate': null,
      'ToDate': null,
      'StaffId': 48,
      'TransDate': '2025-04-22T00:00:00',
      'Description': 'On Account',
      'StaffName': 'Anopa',
      'DebitAmt': 22098.50,
      'CreditAmt': 5198.50,
      'Balance': 16900.00,
      'Flag': null,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetStaffLedgerReportModelList.fromJson(sampleJson);
      expect(model.ledgerId, 73);
      expect(model.distributorId, 8118);
      expect(model.fromDate, isNull);
      expect(model.staffId, 48);
      expect(model.transDate, '2025-04-22T00:00:00');
      expect(model.description, 'On Account');
      expect(model.staffName, 'Anopa');
      expect(model.debitAmt, 22098.50);
      expect(model.creditAmt, 5198.50);
      expect(model.balance, 16900.00);
      expect(model.flag, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetStaffLedgerReportModelList.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['LedgerId'], 73);
      expect(json['StaffName'], 'Anopa');
      expect(json['DebitAmt'], 22098.50);
      expect(json['Balance'], 16900.00);
      expect(json['Flag'], isNull);
    });

    test('toJson includes all keys', () {
      final model = GetStaffLedgerReportModelList.fromJson(sampleJson);
      final json = model.toJson();
      for (final key in ['LedgerId','DistributorId','FromDate','ToDate','StaffId',
        'TransDate','Description','StaffName','DebitAmt','CreditAmt','Balance','Flag']) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('copyWith updates specified fields', () {
      final model = GetStaffLedgerReportModelList.fromJson(sampleJson);
      final updated = model.copyWith(staffName: 'Updated', debitAmt: 30000.0);
      expect(updated.staffName, 'Updated');
      expect(updated.debitAmt, 30000.0);
      expect(model.staffName, 'Anopa');
    });

    test('default constructor with null values', () {
      final model = GetStaffLedgerReportModelList();
      expect(model.ledgerId, isNull);
      expect(model.debitAmt, isNull);
    });

    test('balance = debitAmt - creditAmt', () {
      final model = GetStaffLedgerReportModelList.fromJson(sampleJson);
      expect(model.balance, model.debitAmt! - model.creditAmt!);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetStaffLedgerReportModelList.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetStaffLedgerReportModelList.fromJson(json);
      expect(model2.ledgerId, model.ledgerId);
      expect(model2.staffName, model.staffName);
      expect(model2.balance, model.balance);
    });
  });
}

