import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetDashboardNiyojanPunchCtnLstModel.dart';

void main() {
  final Map<String, dynamic> consumerDetailsJson = {
    'ConsumerNo': '668326',
    'ConsumerName': 'Mrs. Pallavi K Patil',
    'OrderDate': '11-04-2025',
    'CashMemoDate': '11-04-2025',
    'SettlementDate': 'null',
    'DeliveryDate': 'null',
    'TodayDate2': '2025-04-16T00:00:00',
    'Remark': 'Punching Pending In cDCMS',
  };

  final Map<String, dynamic> fullJson = {
    'PkId': 1,
    'DistributorId': 8118,
    'TodayDate': '2025-04-16T00:00:00',
    'StaffId': 21,
    'StaffName': 'Rathod',
    'NiyojanPunQty': 1,
    'SettlementQty': 0,
    'PendingSttlQty': 1,
    'ConsumerDetails': [consumerDetailsJson],
  };

  // ── ConsumerDetails ───────────────────────────────────────────────────────
  group('ConsumerDetails.fromJson', () {
    test('parses all 8 fields', () {
      final d = ConsumerDetails.fromJson(consumerDetailsJson);
      expect(d.consumerNo, '668326');
      expect(d.consumerName, 'Mrs. Pallavi K Patil');
      expect(d.orderDate, '11-04-2025');
      expect(d.cashMemoDate, '11-04-2025');
      expect(d.settlementDate, 'null');
      expect(d.deliveryDate, 'null');
      expect(d.todayDate2, '2025-04-16T00:00:00');
      expect(d.remark, 'Punching Pending In cDCMS');
    });

    test('handles empty JSON', () {
      final d = ConsumerDetails.fromJson({});
      expect(d.consumerNo, isNull);
      expect(d.remark, isNull);
    });
  });

  group('ConsumerDetails.toJson', () {
    test('serialises 8 fields', () {
      final j = ConsumerDetails.fromJson(consumerDetailsJson).toJson();
      expect(j.length, 8);
      expect(j['ConsumerNo'], '668326');
      expect(j['Remark'], 'Punching Pending In cDCMS');
    });

    test('round-trips correctly', () {
      final o = ConsumerDetails.fromJson(consumerDetailsJson);
      final r = ConsumerDetails.fromJson(o.toJson());
      expect(r.consumerNo, o.consumerNo);
      expect(r.consumerName, o.consumerName);
    });
  });

  group('ConsumerDetails.copyWith', () {
    test('replaces remark', () {
      final d = ConsumerDetails.fromJson(consumerDetailsJson);
      expect(d.copyWith(remark: 'Updated').remark, 'Updated');
    });

    test('preserves all without args', () {
      final d = ConsumerDetails.fromJson(consumerDetailsJson);
      expect(d.copyWith().consumerNo, d.consumerNo);
    });
  });

  // ── GetDashboardNiyojanPunchCtnLstModel ───────────────────────────────────
  group('GetDashboardNiyojanPunchCtnLstModel.fromJson', () {
    test('parses all scalar fields', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      expect(m.pkId, 1);
      expect(m.distributorId, 8118);
      expect(m.todayDate, '2025-04-16T00:00:00');
      expect(m.staffId, 21);
      expect(m.staffName, 'Rathod');
      expect(m.niyojanPunQty, 1);
      expect(m.settlementQty, 0);
      expect(m.pendingSttlQty, 1);
    });

    test('parses nested ConsumerDetails list', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      expect(m.consumerDetails, isNotNull);
      expect(m.consumerDetails!.length, 1);
      expect(m.consumerDetails!.first.consumerNo, '668326');
    });

    test('null ConsumerDetails produces null list', () {
      final j = Map<String, dynamic>.from(fullJson)..['ConsumerDetails'] = null;
      expect(GetDashboardNiyojanPunchCtnLstModel.fromJson(j).consumerDetails, isNull);
    });

    test('empty ConsumerDetails produces empty list', () {
      final j = Map<String, dynamic>.from(fullJson)..['ConsumerDetails'] = [];
      expect(GetDashboardNiyojanPunchCtnLstModel.fromJson(j).consumerDetails, isEmpty);
    });

    test('handles empty JSON', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson({});
      expect(m.pkId, isNull);
      expect(m.consumerDetails, isNull);
    });
  });

  group('GetDashboardNiyojanPunchCtnLstModel.toJson', () {
    test('serialises scalar + nested fields', () {
      final j = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson).toJson();
      expect(j['PkId'], 1);
      expect(j['StaffName'], 'Rathod');
      expect((j['ConsumerDetails'] as List).first['ConsumerNo'], '668326');
    });

    test('round-trips correctly', () {
      final o = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      final r = GetDashboardNiyojanPunchCtnLstModel.fromJson(o.toJson());
      expect(r.pkId, o.pkId);
      expect(r.consumerDetails!.first.consumerName,
          o.consumerDetails!.first.consumerName);
    });
  });

  group('GetDashboardNiyojanPunchCtnLstModel.copyWith', () {
    test('replaces pendingSttlQty', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      expect(m.copyWith(pendingSttlQty: 3).pendingSttlQty, 3);
    });

    test('preserves all without args', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      expect(m.copyWith().staffName, m.staffName);
    });
  });

  group('Niyojan punch – business logic', () {
    test('pendingSttlQty = niyojanPunQty - settlementQty', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      final expected = (m.niyojanPunQty ?? 0) - (m.settlementQty ?? 0);
      expect(expected, m.pendingSttlQty);
    });

    test('consumerDetails count equals niyojanPunQty', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      expect(m.consumerDetails!.length, m.niyojanPunQty);
    });

    test('settlementQty must not exceed niyojanPunQty', () {
      final m = GetDashboardNiyojanPunchCtnLstModel.fromJson(fullJson);
      expect((m.settlementQty ?? 0) <= (m.niyojanPunQty ?? 0), isTrue);
    });
  });
}

