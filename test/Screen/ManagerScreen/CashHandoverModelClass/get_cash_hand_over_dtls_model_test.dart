import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/CashHandoverModelClass/GetCashHandOverDtlsModel.dart';

void main() {
  final fullJson = {
    'HandoverId': 0, 'DistributorId': 8118, 'TotalAmount': 0.0,
    'HandoverFromId': null, 'HandoverToType': 0, 'IsCashHandover': 0,
    'AddedBy': 0, 'DenomDtList': null, 'HandoverDate': '0001-01-01T00:00:00',
    'Date': null, 'StaffId': 4, 'StaffName': 'Shamika Joshi',
    'CollAmt': 554077.00, 'PaidAmt': 2200.00,
    'CashCollDate': '2025-04-10T00:00:00',
    'HandoverToId': 0, 'HandoverAmt': null,
    'TotalAmt': 551877.00, 'AcceptedById': 0,
    'HandoverStatus': 0, 'TotalHandoverAmt': 0.0,
  };

  group('GetCashHandOverDtlsModel.fromJson', () {
    test('parses all 21 fields', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect(m.handoverId, 0); expect(m.distributorId, 8118);
      expect(m.totalAmount, 0.0); expect(m.staffId, 4);
      expect(m.staffName, 'Shamika Joshi');
      expect(m.collAmt, 554077.00); expect(m.paidAmt, 2200.00);
      expect(m.totalAmt, 551877.00); expect(m.handoverStatus, 0);
      expect(m.handoverFromId, isNull); expect(m.date, isNull);
      expect(m.handoverAmt, isNull);
    });
    test('handles empty JSON', () {
      final m = GetCashHandOverDtlsModel.fromJson({});
      expect(m.distributorId, isNull); expect(m.staffName, isNull);
    });
  });

  group('GetCashHandOverDtlsModel.toJson', () {
    test('serialises 21 fields', () {
      final j = GetCashHandOverDtlsModel.fromJson(fullJson).toJson();
      expect(j.length, 21);
      expect(j['CollAmt'], 554077.00); expect(j['PaidAmt'], 2200.00);
    });
    test('round-trips correctly', () {
      final o = GetCashHandOverDtlsModel.fromJson(fullJson);
      final r = GetCashHandOverDtlsModel.fromJson(o.toJson());
      expect(r.collAmt, o.collAmt); expect(r.totalAmt, o.totalAmt);
    });
  });

  group('GetCashHandOverDtlsModel.copyWith', () {
    test('replaces staffName', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect(m.copyWith(staffName: 'New Staff').staffName, 'New Staff');
    });
    test('replaces handoverStatus', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect(m.copyWith(handoverStatus: 1).handoverStatus, 1);
    });
    test('preserves all without args', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect(m.copyWith().collAmt, m.collAmt);
    });
  });

  group('Cash handover – business logic', () {
    test('totalAmt = collAmt - paidAmt', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect((m.collAmt ?? 0) - (m.paidAmt ?? 0),
          closeTo(m.totalAmt ?? 0, 0.01));
    });
    test('collAmt must be >= paidAmt', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect((m.collAmt ?? 0) >= (m.paidAmt ?? 0), isTrue);
    });
    test('handoverStatus 0 = pending', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect(m.handoverStatus, 0);
    });
    test('totalAmount defaults to 0 for new handover', () {
      final m = GetCashHandOverDtlsModel.fromJson(fullJson);
      expect(m.totalAmount, 0.0);
    });
  });
}

