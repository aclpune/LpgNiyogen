import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ARBScreen/GetPaymentDetlARBPurLstModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'PaymentId': 756, 'ARBPurId': 35, 'DistributorId': 8118,
    'PaymentDate': '2025-06-25T00:00:00', 'PaymentMode': 'Cash',
    'TotalAmtPaid': 500.00, 'ExpHeadId': 6,
    'ExpHeadName': 'Office/Godown repairs',
    'TransationCode': '', 'TransTime': '', 'TransRemark': '',
    'DayEnd': 0, 'BankId': 0, 'BankMappingId': 0,
    'BankName': null, 'AccountNo': null,
  };

  group('GetPaymentDetlArbPurLstModel.fromJson', () {
    test('parses all 16 fields', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      expect(m.paymentId, 756); expect(m.aRBPurId, 35);
      expect(m.distributorId, 8118);
      expect(m.paymentDate, '2025-06-25T00:00:00');
      expect(m.paymentMode, 'Cash'); expect(m.totalAmtPaid, 500.00);
      expect(m.expHeadId, 6);
      expect(m.expHeadName, 'Office/Godown repairs');
      expect(m.transationCode, ''); expect(m.transTime, '');
      expect(m.transRemark, ''); expect(m.dayEnd, 0);
      expect(m.bankId, 0); expect(m.bankMappingId, 0);
      expect(m.bankName, isNull); expect(m.accountNo, isNull);
    });
    test('handles empty JSON', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson({});
      expect(m.paymentId, isNull); expect(m.totalAmtPaid, isNull);
    });
    test('handles null bankName and accountNo', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      expect(m.bankName, isNull); expect(m.accountNo, isNull);
    });
  });

  group('GetPaymentDetlArbPurLstModel.toJson', () {
    test('serialises 16 fields', () {
      final j = GetPaymentDetlArbPurLstModel.fromJson(fullJson).toJson();
      expect(j.length, 16);
      expect(j['TotalAmtPaid'], 500.00);
      expect(j['PaymentMode'], 'Cash');
    });
    test('round-trips correctly', () {
      final o = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      final r = GetPaymentDetlArbPurLstModel.fromJson(o.toJson());
      expect(r.paymentId, o.paymentId);
      expect(r.totalAmtPaid, o.totalAmtPaid);
    });
  });

  group('GetPaymentDetlArbPurLstModel.copyWith', () {
    test('replaces paymentMode', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      final copy = m.copyWith(paymentMode: 'Bank');
      expect(copy.paymentMode, 'Bank');
      expect(copy.totalAmtPaid, m.totalAmtPaid);
    });
    test('replaces totalAmtPaid', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      final copy = m.copyWith(totalAmtPaid: 1000.0);
      expect(copy.totalAmtPaid, 1000.0);
    });
    test('preserves all without args', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      expect(m.copyWith().paymentId, m.paymentId);
    });
  });

  group('ARB payment – business logic', () {
    test('cash payment: bankId must be 0', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      if (m.paymentMode == 'Cash') expect(m.bankId, 0);
    });
    test('totalAmtPaid must be positive', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      expect((m.totalAmtPaid ?? 0) > 0, isTrue);
    });
    test('dayEnd = 0 means payment record is editable', () {
      final m = GetPaymentDetlArbPurLstModel.fromJson(fullJson);
      expect(m.dayEnd, 0);
    });
    test('bank payment has valid bankMappingId > 0', () {
      final bankJson = Map<String, dynamic>.from(fullJson)
        ..['PaymentMode'] = 'Bank'
        ..['BankId'] = 14
        ..['BankMappingId'] = 19;
      final m = GetPaymentDetlArbPurLstModel.fromJson(bankJson);
      expect((m.bankMappingId ?? 0) > 0, isTrue);
    });
  });
}

