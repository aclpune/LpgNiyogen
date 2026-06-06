import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/ImbalanceItemWiseCountListModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118,
    'DelDate': '0001-01-01T00:00:00',
    'DMId': 19,
    'StaffName': 'CHRISTINA ALOTKAR',
    'ItemId': 3,
    'ItemName': '19 KG',
    'ImbalanceQty': 20,
    'ImbRecQty': 0,
    'StaffId': 0,
  };

  group('ImbalanceItemWiseCountListModel.fromJson', () {
    test('parses all 9 fields', () {
      final m = ImbalanceItemWiseCountListModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.delDate, '0001-01-01T00:00:00');
      expect(m.dMId, 19);
      expect(m.staffName, 'CHRISTINA ALOTKAR');
      expect(m.itemId, 3);
      expect(m.itemName, '19 KG');
      expect(m.imbalanceQty, 20);
      expect(m.imbRecQty, 0);
      expect(m.staffId, 0);
    });

    test('handles empty JSON', () {
      final m = ImbalanceItemWiseCountListModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.imbalanceQty, isNull);
    });

    test('handles zero imbalance', () {
      final m = ImbalanceItemWiseCountListModel.fromJson({
        ...fullJson, 'ImbalanceQty': 0, 'ImbRecQty': 0,
      });
      expect(m.imbalanceQty, 0);
      expect(m.imbRecQty, 0);
    });
  });

  group('ImbalanceItemWiseCountListModel.toJson', () {
    test('serialises 9 fields', () {
      final j = ImbalanceItemWiseCountListModel.fromJson(fullJson).toJson();
      expect(j.length, 9);
      expect(j['ImbalanceQty'], 20);
      expect(j['ItemName'], '19 KG');
    });

    test('round-trips correctly', () {
      final o = ImbalanceItemWiseCountListModel.fromJson(fullJson);
      final r = ImbalanceItemWiseCountListModel.fromJson(o.toJson());
      expect(r.imbalanceQty, o.imbalanceQty);
      expect(r.staffName, o.staffName);
    });
  });

  group('ImbalanceItemWiseCountListModel.copyWith', () {
    test('replaces imbalanceQty and imbRecQty', () {
      final m = ImbalanceItemWiseCountListModel.fromJson(fullJson);
      final copy = m.copyWith(imbalanceQty: 10, imbRecQty: 5);
      expect(copy.imbalanceQty, 10);
      expect(copy.imbRecQty, 5);
      expect(copy.staffName, m.staffName);
    });

    test('preserves all without args', () {
      final m = ImbalanceItemWiseCountListModel.fromJson(fullJson);
      expect(m.copyWith().dMId, m.dMId);
    });
  });

  group('Imbalance – business logic', () {
    test('imbalanceQty must be non-negative', () {
      final m = ImbalanceItemWiseCountListModel.fromJson(fullJson);
      expect((m.imbalanceQty ?? 0) >= 0, isTrue);
    });

    test('imbRecQty must not exceed imbalanceQty', () {
      final m = ImbalanceItemWiseCountListModel.fromJson(fullJson);
      expect((m.imbRecQty ?? 0) <= (m.imbalanceQty ?? 0), isTrue);
    });

    test('pending imbalance = imbalanceQty - imbRecQty', () {
      final m = ImbalanceItemWiseCountListModel.fromJson(fullJson);
      final pending = (m.imbalanceQty ?? 0) - (m.imbRecQty ?? 0);
      expect(pending, 20);
    });

    test('fully recovered: imbRecQty equals imbalanceQty', () {
      final m = ImbalanceItemWiseCountListModel.fromJson({
        ...fullJson, 'ImbalanceQty': 5, 'ImbRecQty': 5,
      });
      expect(m.imbRecQty, m.imbalanceQty);
    });
  });
}

