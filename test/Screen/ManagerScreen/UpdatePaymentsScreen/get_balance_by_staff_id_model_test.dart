import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/UpdatePaymentsScreen/GetBalanceByStaffIdModel.dart';

void main() {
  group('GetBalanceByStaffIdModel', () {
    final sampleJson = {
      'StaffId': 48,
      'DistributorId': 0,
      'BalanceAmt': 0,
      'DebitAmt': 1000,
      'CreditAmt': 0,
      'TransDate': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetBalanceByStaffIdModel(
        staffId: 48,
        distributorId: 0,
        balanceAmt: 0,
        debitAmt: 1000,
        creditAmt: 0,
        transDate: null,
      );

      expect(model.staffId, 48);
      expect(model.distributorId, 0);
      expect(model.balanceAmt, 0);
      expect(model.debitAmt, 1000);
      expect(model.creditAmt, 0);
      expect(model.transDate, isNull);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetBalanceByStaffIdModel.fromJson(sampleJson);

      expect(model.staffId, 48);
      expect(model.distributorId, 0);
      expect(model.balanceAmt, 0);
      expect(model.debitAmt, 1000);
      expect(model.creditAmt, 0);
      expect(model.transDate, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetBalanceByStaffIdModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['StaffId'], 48);
      expect(json['DistributorId'], 0);
      expect(json['BalanceAmt'], 0);
      expect(json['DebitAmt'], 1000);
      expect(json['CreditAmt'], 0);
      expect(json['TransDate'], isNull);
    });

    test('toJson includes all keys', () {
      final model = GetBalanceByStaffIdModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json.containsKey('StaffId'), isTrue);
      expect(json.containsKey('DistributorId'), isTrue);
      expect(json.containsKey('BalanceAmt'), isTrue);
      expect(json.containsKey('DebitAmt'), isTrue);
      expect(json.containsKey('CreditAmt'), isTrue);
      expect(json.containsKey('TransDate'), isTrue);
    });

    test('copyWith updates specified fields', () {
      final model = GetBalanceByStaffIdModel.fromJson(sampleJson);
      final updated = model.copyWith(debitAmt: 5000, balanceAmt: 5000);

      expect(updated.debitAmt, 5000);
      expect(updated.balanceAmt, 5000);
      expect(model.debitAmt, 1000);
    });

    test('copyWith preserves non-updated fields', () {
      final model = GetBalanceByStaffIdModel.fromJson(sampleJson);
      final updated = model.copyWith(creditAmt: 200);

      expect(updated.staffId, model.staffId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.debitAmt, model.debitAmt);
      expect(updated.creditAmt, 200);
    });

    test('default constructor with all null values', () {
      final model = GetBalanceByStaffIdModel();

      expect(model.staffId, isNull);
      expect(model.distributorId, isNull);
      expect(model.balanceAmt, isNull);
      expect(model.debitAmt, isNull);
      expect(model.creditAmt, isNull);
      expect(model.transDate, isNull);
    });

    test('fromJson then toJson is consistent (round-trip)', () {
      final model = GetBalanceByStaffIdModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetBalanceByStaffIdModel.fromJson(json);

      expect(model2.staffId, model.staffId);
      expect(model2.distributorId, model.distributorId);
      expect(model2.balanceAmt, model.balanceAmt);
      expect(model2.debitAmt, model.debitAmt);
      expect(model2.creditAmt, model.creditAmt);
    });

    test('fromJson with transDate as string', () {
      final json = {
        'StaffId': 10,
        'DistributorId': 100,
        'BalanceAmt': 500,
        'DebitAmt': 300,
        'CreditAmt': 200,
        'TransDate': '2025-01-01T00:00:00',
      };
      final model = GetBalanceByStaffIdModel.fromJson(json);
      expect(model.transDate, '2025-01-01T00:00:00');
    });
  });
}

