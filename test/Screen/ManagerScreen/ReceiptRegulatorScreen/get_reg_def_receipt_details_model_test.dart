import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ReceiptRegulatorScreen/GetRegDefReceiptDetailsModel.dart';

void main() {
  group('GetRegDefReceiptDetailsModel', () {
    final sampleJson = {
      'RegDefRcptId': 11,
      'DistributorId': 8118,
      'RegDefRcptDate': '2025-09-23T10:39:12',
      'StaffId': 34,
      'StaffName': 'Dattatray Nanaware',
      'ConsumerNo': '423455',
      'ConsumerName': 'Fgdh',
      'ItemId': 6,
      'ItemName': 'SC REGULATOR',
      'RegDefRcptQty': 1,
      'ReplacementCharge': 1,
      'PaidAmt': 250.0,
      'PaymentMode': 'Cash',
      'TransactionCode': '',
      'TransactionTime': '',
      'TransactionRemark': '',
      'BankId': 0,
      'BankMappingId': 0,
      'Remark': '',
      'AddedBy': 0,
      'Action': null,
      'DenomRegDefList': null,
    };

    test('constructor sets all fields correctly', () {
      final model = GetRegDefReceiptDetailsModel(
        regDefRcptId: 11,
        distributorId: 8118,
        regDefRcptDate: '2025-09-23T10:39:12',
        staffId: 34,
        staffName: 'Dattatray Nanaware',
        consumerNo: '423455',
        consumerName: 'Fgdh',
        itemId: 6,
        itemName: 'SC REGULATOR',
        regDefRcptQty: 1,
        replacementCharge: 1,
        paidAmt: 250.0,
        paymentMode: 'Cash',
        transactionCode: '',
        transactionTime: '',
        transactionRemark: '',
        bankId: 0,
        bankMappingId: 0,
        remark: '',
        addedBy: 0,
      );

      expect(model.regDefRcptId, 11);
      expect(model.distributorId, 8118);
      expect(model.regDefRcptDate, '2025-09-23T10:39:12');
      expect(model.staffId, 34);
      expect(model.staffName, 'Dattatray Nanaware');
      expect(model.consumerNo, '423455');
      expect(model.consumerName, 'Fgdh');
      expect(model.itemId, 6);
      expect(model.itemName, 'SC REGULATOR');
      expect(model.regDefRcptQty, 1);
      expect(model.replacementCharge, 1);
      expect(model.paidAmt, 250.0);
      expect(model.paymentMode, 'Cash');
    });

    test('fromJson parses all fields correctly', () {
      final model = GetRegDefReceiptDetailsModel.fromJson(sampleJson);

      expect(model.regDefRcptId, 11);
      expect(model.distributorId, 8118);
      expect(model.regDefRcptDate, '2025-09-23T10:39:12');
      expect(model.staffId, 34);
      expect(model.staffName, 'Dattatray Nanaware');
      expect(model.consumerNo, '423455');
      expect(model.consumerName, 'Fgdh');
      expect(model.itemId, 6);
      expect(model.itemName, 'SC REGULATOR');
      expect(model.regDefRcptQty, 1);
      expect(model.replacementCharge, 1);
      expect(model.paidAmt, 250.0);
      expect(model.paymentMode, 'Cash');
      expect(model.transactionCode, '');
      expect(model.bankId, 0);
      expect(model.bankMappingId, 0);
      expect(model.remark, '');
      expect(model.addedBy, 0);
      expect(model.action, isNull);
      expect(model.denomRegDefList, isNull);
    });

    test('toJson returns correct map', () {
      final model = GetRegDefReceiptDetailsModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['RegDefRcptId'], 11);
      expect(json['DistributorId'], 8118);
      expect(json['StaffId'], 34);
      expect(json['StaffName'], 'Dattatray Nanaware');
      expect(json['ConsumerName'], 'Fgdh');
      expect(json['ItemName'], 'SC REGULATOR');
      expect(json['PaidAmt'], 250.0);
      expect(json['PaymentMode'], 'Cash');
      expect(json['Action'], isNull);
      expect(json['DenomRegDefList'], isNull);
    });

    test('copyWith updates specified fields', () {
      final model = GetRegDefReceiptDetailsModel.fromJson(sampleJson);
      final updated = model.copyWith(paymentMode: 'Online', paidAmt: 300.0);

      expect(updated.paymentMode, 'Online');
      expect(updated.paidAmt, 300.0);
      expect(model.paymentMode, 'Cash');
      expect(model.paidAmt, 250.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetRegDefReceiptDetailsModel.fromJson(sampleJson);
      final updated = model.copyWith(remark: 'Updated remark');

      expect(updated.regDefRcptId, model.regDefRcptId);
      expect(updated.staffId, model.staffId);
      expect(updated.consumerName, model.consumerName);
    });

    test('constructor with null values', () {
      final model = GetRegDefReceiptDetailsModel();
      expect(model.regDefRcptId, isNull);
      expect(model.staffName, isNull);
      expect(model.paidAmt, isNull);
    });
  });
}

