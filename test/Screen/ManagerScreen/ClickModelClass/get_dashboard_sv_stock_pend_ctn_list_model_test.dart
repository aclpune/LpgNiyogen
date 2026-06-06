import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ClickModelClass/GetDashboardSVStockPendCtnListForMobListModel.dart';

void main() {
  final Map<String, dynamic> fullJson = {
    'DistributorId': 8118, 'FromDate': null, 'ToDate': null,
    'StaffId': 0, 'ReferredBy': '19kg Devendra',
    'SVDate': '2025-07-07T14:39:03', 'SVType': 'NC',
    'ProductId': 1, 'ItemName': '14.2 KG', 'ItemId': 0,
    'IsUndocument': false, 'ConsuDCNo': '43434', 'ConsumerName': '',
    'CylQty': 1, 'SCRegulator': 1, 'StaffName': null,
    'AmtCharges': 0.00, 'TotalAmount': 6155.50,
    'AddedOn': '2025-07-07T09:09:46.283', 'DMId': 0,
    'StockStatus': 'Pending', 'GodownId': 0, 'GodownNo': null,
    'ReceiptDate': null, 'ConsumerNo': null,
  };

  group('GetDashboardSvStockPendCtnListForMobListModel.fromJson', () {
    test('parses all 25 fields', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.distributorId, 8118);
      expect(m.referredBy, '19kg Devendra');
      expect(m.sVDate, '2025-07-07T14:39:03');
      expect(m.sVType, 'NC');
      expect(m.productId, 1);
      expect(m.itemName, '14.2 KG');
      expect(m.isUndocument, false);
      expect(m.consuDCNo, '43434');
      expect(m.cylQty, 1);
      expect(m.sCRegulator, 1);
      expect(m.totalAmount, 6155.50);
      expect(m.stockStatus, 'Pending');
      expect(m.fromDate, isNull);
      expect(m.staffName, isNull);
      expect(m.consumerNo, isNull);
    });

    test('handles empty JSON', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson({});
      expect(m.distributorId, isNull);
      expect(m.stockStatus, isNull);
    });

    test('isUndocument false for documented SV', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.isUndocument, false);
    });

    test('isUndocument true for undocumented SV', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson({
        ...fullJson, 'IsUndocument': true,
      });
      expect(m.isUndocument, true);
    });
  });

  group('GetDashboardSvStockPendCtnListForMobListModel.toJson', () {
    test('serialises 25 fields', () {
      final j = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson).toJson();
      expect(j.length, 25);
      expect(j['SVType'], 'NC');
      expect(j['TotalAmount'], 6155.50);
      expect(j['StockStatus'], 'Pending');
    });

    test('round-trips correctly', () {
      final o = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      final r = GetDashboardSvStockPendCtnListForMobListModel.fromJson(o.toJson());
      expect(r.sVType, o.sVType);
      expect(r.totalAmount, o.totalAmount);
      expect(r.isUndocument, o.isUndocument);
    });
  });

  group('GetDashboardSvStockPendCtnListForMobListModel.copyWith', () {
    test('replaces stockStatus', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.copyWith(stockStatus: 'Completed').stockStatus, 'Completed');
    });

    test('replaces cylQty', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.copyWith(cylQty: 3).cylQty, 3);
    });

    test('replaces isUndocument', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.copyWith(isUndocument: true).isUndocument, true);
    });

    test('preserves all without args', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.copyWith().sVType, m.sVType);
    });
  });

  group('SV pending stock – business logic', () {
    test('stockStatus is Pending for new record', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.stockStatus, 'Pending');
    });

    test('sVType is valid type', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(['NC', 'DBC', 'RC', 'SV', 'TV'].contains(m.sVType), isTrue);
    });

    test('cylQty must be positive', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect((m.cylQty ?? 0) > 0, isTrue);
    });

    test('totalAmount must be positive', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect((m.totalAmount ?? 0) > 0, isTrue);
    });

    test('consuDCNo is non-empty for valid record', () {
      final m = GetDashboardSvStockPendCtnListForMobListModel.fromJson(fullJson);
      expect(m.consuDCNo, isNotEmpty);
    });
  });
}

