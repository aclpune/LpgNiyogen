import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetDashboardSettlementCtnListModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'ConsumerNo': '660990',
    'ConsumerName': 'Mr. Priyabrata Mondal',
    'OrderDate': '05-04-2025',
    'DeliveryDate': 'null',
    'PaymentDate': '05-04-2025',
    'SettlementDate': '09-04-2025',
  };

  group('GetDashboardSettlementCtnListModel.fromJson', () {
    test('parses all 7 fields', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.consumerNo, '660990');
      expect(m.consumerName, 'Mr. Priyabrata Mondal');
      expect(m.orderDate, '05-04-2025');
      expect(m.deliveryDate, 'null');
      expect(m.paymentDate, '05-04-2025');
      expect(m.settlementDate, '09-04-2025');
    });

    test('handles empty JSON', () {
      final m = GetDashboardSettlementCtnListModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.consumerNo, isNull);
    });

    test('deliveryDate can be string "null" (undelivered)', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.deliveryDate, 'null');
    });
  });

  group('GetDashboardSettlementCtnListModel.toJson', () {
    test('serialises 7 fields', () {
      final j = GetDashboardSettlementCtnListModel.fromJson(fullJson).toJson();
      expect(j.length, 7);
      expect(j['ConsumerNo'], '660990');
      expect(j['SettlementDate'], '09-04-2025');
    });

    test('round-trips correctly', () {
      final o = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      final r = GetDashboardSettlementCtnListModel.fromJson(o.toJson());
      expect(r.consumerNo, o.consumerNo);
      expect(r.settlementDate, o.settlementDate);
    });
  });

  group('GetDashboardSettlementCtnListModel.copyWith', () {
    test('replaces settlementDate', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.copyWith(settlementDate: '10-04-2025').settlementDate, '10-04-2025');
    });

    test('replaces consumerName', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.copyWith(consumerName: 'New Name').consumerName, 'New Name');
    });

    test('preserves all without args', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.copyWith().orderDate, m.orderDate);
    });
  });

  group('Settlement – business logic', () {
    test('consumerNo is non-empty', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.consumerNo, isNotEmpty);
    });

    test('settlement has both orderDate and paymentDate', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.orderDate, isNotNull);
      expect(m.paymentDate, isNotNull);
    });

    test('paymentDate should equal orderDate for same-day payment', () {
      final m = GetDashboardSettlementCtnListModel.fromJson(fullJson);
      expect(m.paymentDate, m.orderDate);
    });

    test('list of settled consumers accumulates correctly', () {
      final list = [
        GetDashboardSettlementCtnListModel.fromJson(fullJson),
        GetDashboardSettlementCtnListModel.fromJson({...fullJson, 'ConsumerNo': '660991'}),
      ];
      final nos = list.map((e) => e.consumerNo).toSet();
      expect(nos.length, 2);
    });
  });
}

