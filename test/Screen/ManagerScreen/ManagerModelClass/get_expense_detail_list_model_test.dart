import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetExpenseDetailListModel.dart';

void main() {
  group('GetExpenseDetailListModel', () {
    final sampleJson = {
      'ExpId': 46,
      'ExpHeadId': 2,
      'ExpHeadName': 'Acc Settle',
      'DistributorId': 8118,
      'VehicleId': 0,
      'ExpDate': '0001-01-01T00:00:00',
      'StaffId': 21,
      'DSCollMgrId': 148,
      'ExpAmount': 100.00,
      'Remark': '',
      'AddedOn': '0001-01-01T00:00:00',
      'ExpenseFrom': null,
      'ExpStatus': 'Settled',
      'Action': null,
      'AddedBy': 0,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetExpenseDetailListModel.fromJson(sampleJson);
      expect(model.expId, 46);
      expect(model.expHeadId, 2);
      expect(model.expHeadName, 'Acc Settle');
      expect(model.distributorId, 8118);
      expect(model.staffId, 21);
      expect(model.expAmount, 100.00);
      expect(model.expStatus, 'Settled');
      expect(model.expenseFrom, isNull);
      expect(model.action, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetExpenseDetailListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['ExpId'], 46);
      expect(json['ExpHeadName'], 'Acc Settle');
      expect(json['ExpAmount'], 100.00);
      expect(json['ExpStatus'], 'Settled');
    });

    test('copyWith updates specified fields', () {
      final model = GetExpenseDetailListModel.fromJson(sampleJson);
      final updated = model.copyWith(expAmount: 500.0, expStatus: 'Pending');
      expect(updated.expAmount, 500.0);
      expect(updated.expStatus, 'Pending');
      expect(model.expAmount, 100.00);
    });

    test('default constructor with null values', () {
      final model = GetExpenseDetailListModel();
      expect(model.expId, isNull);
      expect(model.expAmount, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetExpenseDetailListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetExpenseDetailListModel.fromJson(json);
      expect(model2.expId, model.expId);
      expect(model2.expAmount, model.expAmount);
      expect(model2.expStatus, model.expStatus);
    });
  });
}

