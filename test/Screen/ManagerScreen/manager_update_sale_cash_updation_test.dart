import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerUpdateSaleCashUpdation.dart';

// Safe helper mirrors based on logic present in ManagerUpdateSaleCashUpdation.
String formatCurrencyMirror(double amount) {
  if (amount == 0) return '0.00';
  final format = NumberFormat('#,##,###.00', 'en_IN');
  String formatted = format.format(amount);
  if (amount < 1 && formatted.startsWith('.')) {
    formatted = '0$formatted';
  }
  return formatted;
}

double calcDenomResult(int qty, double noteValue) => qty * noteValue;

double calcDenomTotal(Map<double, int> denomMap) {
  return denomMap.entries.fold(0.0, (sum, e) => sum + e.key * e.value);
}

bool calcIsLumsumAmountAdd({
  required double postpaidAmountApi,
  required int postpaidQtyApi,
  required double cashAmountApi,
  required int cashQtyApi,
}) {
  if ((postpaidAmountApi > 0 && postpaidQtyApi <= 0) ||
      (cashAmountApi > 0 && cashQtyApi <= 0)) {
    return false;
  }
  return true;
}

bool calcIsItemSubtypeND(String? itemSubtype) => itemSubtype == 'ND';

Map<String, int> calcConsumerCounts(List<Map<String, dynamic>> consumerList) {
  int valid = 0;
  int invalid = 0;
  for (final item in consumerList) {
    if (item['InCorrectStatus'] == 1) {
      valid++;
    } else {
      invalid++;
    }
  }
  return {'valid': valid, 'invalid': invalid};
}

bool calcCashDenominationMandatory(
    List<Map<String, dynamic>> flagList, String distributorId) {
  for (final item in flagList) {
    if (item['distributorId'].toString() == distributorId &&
        item['permissionFor'] == 'Cash Denomination' &&
        item['isActive'] == 1) {
      return true;
    }
  }
  return false;
}

Map<String, dynamic> buildRouteArgs({
  String delBoyName = 'Rahul',
  String itemName = '14.2 KG',
  int saleQty = 18,
  int svQty = 2,
  int tvQty = 0,
  double amountTotal = 15399.0,
  double itemRate = 855.5,
  int delBoyID = 42,
  int itemID = 1,
  int salesGkId = 100,
  int sakesGKItemID = 200,
  int vehicleID = 10,
  int dSCollMgrId = 0,
  String vehicleNumber = 'MH49KL7474',
  String receiptNoText = 'REC001',
  String actionModeApi = 'EDIT',
  int prepaidQtyApi = 0,
  double prepaidAmountApi = 0.0,
  int postpaidQtyApi = 0,
  double postpaidAmountApi = 0.0,
  int creditQtyApi = 0,
  double creditAmountApi = 0.0,
  int cashQtyApi = 0,
  double cashAmountApi = 0.0,
  double cashTotalExpectedAmount = 0.0,
  double cashTotalReceiveAmount = 0.0,
  double cashBalanceAmount = 0.0,
  String itemSubtype = 'DOM',
}) {
  return {
    'delBoyName': delBoyName,
    'itemName': itemName,
    'saleQty': saleQty,
    'svQty': svQty,
    'tvQty': tvQty,
    'amountTotal': amountTotal,
    'expAmount': '',
    'dmBal': '',
    'itemRate': itemRate,
    'delBoyID': delBoyID,
    'itemID': itemID,
    'salesGkId': salesGkId,
    'sakesGKItemID': sakesGKItemID,
    'vehicleID': vehicleID,
    'dSCollMgrId': dSCollMgrId,
    'vehicleNumber': vehicleNumber,
    'receiptNoText': receiptNoText,
    'actionModeApi': actionModeApi,
    'prepaidQtyApi': prepaidQtyApi,
    'prepaidAmountApi': prepaidAmountApi,
    'postpaidQtyApi': postpaidQtyApi,
    'postpaidAmountApi': postpaidAmountApi,
    'creditQtyApi': creditQtyApi,
    'creditAmountApi': creditAmountApi,
    'cashQtyApi': cashQtyApi,
    'cashAmountApi': cashAmountApi,
    'cashTotalExpectedAmount': cashTotalExpectedAmount,
    'cashTotalReceiveAmount': cashTotalReceiveAmount,
    'cashBalanceAmount': cashBalanceAmount,
    'itemSubtype': itemSubtype,
  };
}

void main() {
  group('ManagerUpdateSaleCashUpdation contract', () {
    test('screenName constant is correct', () {
      expect(ManagerUpdateSaleCashUpdation.screenName,
          '/managerUpdateSaleCashUpdation');
    });

    test('widget is StatefulWidget', () {
      expect(const ManagerUpdateSaleCashUpdation(), isA<StatefulWidget>());
    });

    test('route arguments fixture contains expected keys', () {
      final args = buildRouteArgs();
      expect(args['delBoyName'], 'Rahul');
      expect(args['itemName'], '14.2 KG');
      expect(args.containsKey('actionModeApi'), isTrue);
      expect(args.containsKey('cashTotalExpectedAmount'), isTrue);
      expect(args.containsKey('itemSubtype'), isTrue);
    });

    test('route arguments fixture supports NEW mode', () {
      final args = buildRouteArgs(actionModeApi: '');
      expect(args['actionModeApi'], '');
    });
  });

  group('ManagerUpdateSaleCashUpdation formatCurrency mirror', () {
    test('zero returns 0.00', () {
      expect(formatCurrencyMirror(0), '0.00');
    });

    test('positive whole amount formats correctly', () {
      final r = formatCurrencyMirror(15399.0);
      expect(r.contains('15399') || r.contains('15,399'), isTrue);
    });

    test('sub-one amount gets leading zero', () {
      final r = formatCurrencyMirror(0.5);
      expect(r.startsWith('0'), isTrue);
    });

    test('large amount does not throw', () {
      expect(() => formatCurrencyMirror(1234567.89), returnsNormally);
    });

    test('negative amount does not throw', () {
      expect(() => formatCurrencyMirror(-1000.0), returnsNormally);
    });

    test('exact boundary 1.0 includes digit 1', () {
      expect(formatCurrencyMirror(1.0).contains('1'), isTrue);
    });
  });

  group('ManagerUpdateSaleCashUpdation denomination math', () {
    test('500 x 2 = 1000.0', () {
      expect(calcDenomResult(2, 500.0), 1000.0);
    });

    test('100 x 5 = 500.0', () {
      expect(calcDenomResult(5, 100.0), 500.0);
    });

    test('zero qty returns zero', () {
      expect(calcDenomResult(0, 500.0), 0.0);
    });

    test('total sum combines all denominations', () {
      final total = calcDenomTotal({500.0: 2, 200.0: 1, 50.0: 3});
      expect(total, 1350.0);
    });

    test('empty denomination map totals zero', () {
      expect(calcDenomTotal({}), 0.0);
    });
  });

  group('ManagerUpdateSaleCashUpdation lumsum amount logic', () {
    test('returns false when postpaid amount > 0 but qty <= 0', () {
      expect(
        calcIsLumsumAmountAdd(
          postpaidAmountApi: 100.0,
          postpaidQtyApi: 0,
          cashAmountApi: 0.0,
          cashQtyApi: 0,
        ),
        isFalse,
      );
    });

    test('returns false when cash amount > 0 but qty <= 0', () {
      expect(
        calcIsLumsumAmountAdd(
          postpaidAmountApi: 0.0,
          postpaidQtyApi: 0,
          cashAmountApi: 100.0,
          cashQtyApi: 0,
        ),
        isFalse,
      );
    });

    test('returns true when amounts and quantities are aligned', () {
      expect(
        calcIsLumsumAmountAdd(
          postpaidAmountApi: 200.0,
          postpaidQtyApi: 2,
          cashAmountApi: 300.0,
          cashQtyApi: 3,
        ),
        isTrue,
      );
    });

    test('returns true when all amounts are zero', () {
      expect(
        calcIsLumsumAmountAdd(
          postpaidAmountApi: 0.0,
          postpaidQtyApi: 0,
          cashAmountApi: 0.0,
          cashQtyApi: 0,
        ),
        isTrue,
      );
    });
  });

  group('ManagerUpdateSaleCashUpdation item subtype logic', () {
    test('ND subtype is detected', () {
      expect(calcIsItemSubtypeND('ND'), isTrue);
    });

    test('DOM subtype is not ND', () {
      expect(calcIsItemSubtypeND('DOM'), isFalse);
    });

    test('null subtype is not ND', () {
      expect(calcIsItemSubtypeND(null), isFalse);
    });
  });

  group('ManagerUpdateSaleCashUpdation consumer counts', () {
    test('counts valid and invalid consumers correctly', () {
      final result = calcConsumerCounts([
        {'InCorrectStatus': 1},
        {'InCorrectStatus': 0},
        {'InCorrectStatus': 1},
        {'InCorrectStatus': 2},
      ]);

      expect(result['valid'], 2);
      expect(result['invalid'], 2);
    });

    test('empty consumer list returns zero counts', () {
      final result = calcConsumerCounts([]);
      expect(result['valid'], 0);
      expect(result['invalid'], 0);
    });
  });

  group('ManagerUpdateSaleCashUpdation cash denomination mandatory flag', () {
    test('returns true when matching active permission exists', () {
      final result = calcCashDenominationMandatory([
        {
          'distributorId': 8118,
          'permissionFor': 'Cash Denomination',
          'isActive': 1,
        }
      ], '8118');
      expect(result, isTrue);
    });

    test('returns false when permission exists but inactive', () {
      final result = calcCashDenominationMandatory([
        {
          'distributorId': 8118,
          'permissionFor': 'Cash Denomination',
          'isActive': 0,
        }
      ], '8118');
      expect(result, isFalse);
    });

    test('returns false when distributor does not match', () {
      final result = calcCashDenominationMandatory([
        {
          'distributorId': 9999,
          'permissionFor': 'Cash Denomination',
          'isActive': 1,
        }
      ], '8118');
      expect(result, isFalse);
    });

    test('returns false when permission name does not match', () {
      final result = calcCashDenominationMandatory([
        {
          'distributorId': 8118,
          'permissionFor': 'Other Permission',
          'isActive': 1,
        }
      ], '8118');
      expect(result, isFalse);
    });

    test('returns false for empty flag list', () {
      expect(calcCashDenominationMandatory([], '8118'), isFalse);
    });
  });
}

