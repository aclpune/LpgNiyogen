import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/CashHandoverModelClass/GetBankMappingDetailsListModel.dart';

void main() {
  final fullJson = {
    'MappingId': 19, 'DistributorId': 8118, 'BankId': 14,
    'BankName': 'ICICI', 'AccountNo': '7777005279799',
    'IFSCCode': 'ICICI00005', 'IsActive': 1, 'AddedBy': 4,
    'AddedOn': '2025-03-24T12:21:09.75', 'Action': null,
  };

  group('GetBankMappingDetailsListModel.fromJson', () {
    test('parses all 10 fields', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect(m.mappingId, 19); expect(m.distributorId, 8118);
      expect(m.bankId, 14); expect(m.bankName, 'ICICI');
      expect(m.accountNo, '7777005279799');
      expect(m.iFSCCode, 'ICICI00005'); expect(m.isActive, 1);
      expect(m.addedBy, 4);
      expect(m.addedOn, '2025-03-24T12:21:09.75');
      expect(m.action, isNull);
    });
    test('handles empty JSON', () {
      final m = GetBankMappingDetailsListModel.fromJson({});
      expect(m.mappingId, isNull); expect(m.bankName, isNull);
    });
  });

  group('GetBankMappingDetailsListModel.toJson', () {
    test('serialises 10 fields', () {
      final j = GetBankMappingDetailsListModel.fromJson(fullJson).toJson();
      expect(j.length, 10);
      expect(j['BankName'], 'ICICI'); expect(j['IFSCCode'], 'ICICI00005');
    });
    test('round-trips correctly', () {
      final o = GetBankMappingDetailsListModel.fromJson(fullJson);
      final r = GetBankMappingDetailsListModel.fromJson(o.toJson());
      expect(r.accountNo, o.accountNo); expect(r.bankName, o.bankName);
    });
  });

  group('GetBankMappingDetailsListModel.copyWith', () {
    test('replaces bankName', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect(m.copyWith(bankName: 'SBI').bankName, 'SBI');
    });
    test('replaces isActive', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect(m.copyWith(isActive: 0).isActive, 0);
    });
    test('preserves all without args', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect(m.copyWith().iFSCCode, m.iFSCCode);
    });
  });

  group('Bank mapping – business logic', () {
    test('isActive 1 means bank mapping is active', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect(m.isActive, 1);
    });
    test('accountNo is non-empty', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect(m.accountNo, isNotEmpty);
    });
    test('iFSCCode is non-empty', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect(m.iFSCCode, isNotEmpty);
    });
    test('bankId is positive', () {
      final m = GetBankMappingDetailsListModel.fromJson(fullJson);
      expect((m.bankId ?? 0) > 0, isTrue);
    });
  });
}

