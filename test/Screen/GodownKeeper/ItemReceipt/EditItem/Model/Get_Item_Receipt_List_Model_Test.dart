// get_item_receipt_list_model_test.dart
// ─────────────────────────────────────────────────────────────────────────────
// All positive & negative unit tests for:
//   • GetItemReceiptListModel
//   • ItemDetails
//
// Run with:
//   flutter test test/get_item_receipt_list_model_test.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_test/flutter_test.dart';

// ─── Models (inline — replace with your real imports) ────────────────────────

class ItemDetails {
  ItemDetails({
    dynamic pkId,
    dynamic itemId,
    dynamic itemName,
    dynamic filledQty,
    dynamic eMRQty,
    dynamic invoiceQty,
    dynamic isReturnSent,
    dynamic emptyReturnQty,
    dynamic defectiveReturnQty,
  }) {
    _pkId = pkId;
    _itemId = itemId;
    _itemName = itemName;
    _filledQty = filledQty;
    _eMRQty = eMRQty;
    _invoiceQty = invoiceQty;
    _isReturnSent = isReturnSent;
    _emptyReturnQty = emptyReturnQty;
    _defectiveReturnQty = defectiveReturnQty;
  }

  ItemDetails.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledQty = json['FilledQty'];
    _eMRQty = json['EMRQty'];
    _invoiceQty = json['InvoiceQty'];
    _isReturnSent = json['IsReturnSent'];
    _emptyReturnQty = json['EmptyReturnQty'];
    _defectiveReturnQty = json['DefectiveReturnQty'];
  }

  dynamic _pkId;
  dynamic _itemId;
  dynamic _itemName;
  dynamic _filledQty;
  dynamic _eMRQty;
  dynamic _invoiceQty;
  dynamic _isReturnSent;
  dynamic _emptyReturnQty;
  dynamic _defectiveReturnQty;

  ItemDetails copyWith({
    dynamic pkId,
    dynamic itemId,
    dynamic itemName,
    dynamic filledQty,
    dynamic eMRQty,
    dynamic invoiceQty,
    dynamic isReturnSent,
    dynamic emptyReturnQty,
    dynamic defectiveReturnQty,
  }) =>
      ItemDetails(
        pkId: pkId ?? _pkId,
        itemId: itemId ?? _itemId,
        itemName: itemName ?? _itemName,
        filledQty: filledQty ?? _filledQty,
        eMRQty: eMRQty ?? _eMRQty,
        invoiceQty: invoiceQty ?? _invoiceQty,
        isReturnSent: isReturnSent ?? _isReturnSent,
        emptyReturnQty: emptyReturnQty ?? _emptyReturnQty,
        defectiveReturnQty: defectiveReturnQty ?? _defectiveReturnQty,
      );

  dynamic get pkId => _pkId;
  dynamic get itemId => _itemId;
  dynamic get itemName => _itemName;
  dynamic get filledQty => _filledQty;
  dynamic get eMRQty => _eMRQty;
  dynamic get invoiceQty => _invoiceQty;
  dynamic get isReturnSent => _isReturnSent;
  dynamic get emptyReturnQty => _emptyReturnQty;
  dynamic get defectiveReturnQty => _defectiveReturnQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledQty'] = _filledQty;
    map['EMRQty'] = _eMRQty;
    map['InvoiceQty'] = _invoiceQty;
    map['IsReturnSent'] = _isReturnSent;
    map['EmptyReturnQty'] = _emptyReturnQty;
    map['DefectiveReturnQty'] = _defectiveReturnQty;
    return map;
  }
}

class GetItemReceiptListModel {
  GetItemReceiptListModel({
    num? pkId,
    num? receiptId,
    num? distributorId,
    num? godownId,
    num? godownKeeperId,
    String? receiptDate,
    String? returnOn,
    String? vehicleNo,
    num? itemId,
    dynamic itemName,
    num? filledQty,
    num? eMRQty,
    num? invoiceQty,
    List<ItemDetails>? itemDetails,
    num? addedBy,
    dynamic action,
  }) {
    _pkId = pkId;
    _receiptId = receiptId;
    _distributorId = distributorId;
    _godownId = godownId;
    _godownKeeperId = godownKeeperId;
    _receiptDate = receiptDate;
    _returnOn = returnOn;
    _vehicleNo = vehicleNo;
    _itemId = itemId;
    _itemName = itemName;
    _filledQty = filledQty;
    _eMRQty = eMRQty;
    _invoiceQty = invoiceQty;
    _itemDetails = itemDetails;
    _addedBy = addedBy;
    _action = action;
  }

  GetItemReceiptListModel.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _receiptId = json['ReceiptId'];
    _distributorId = json['DistributorId'];
    _godownId = json['GodownId'];
    _godownKeeperId = json['GodownKeeperId'];
    _receiptDate = json['ReceiptDate'];
    _returnOn = json['ReturnOn'];
    _vehicleNo = json['VehicleNo'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledQty = json['FilledQty'];
    _eMRQty = json['EMRQty'];
    _invoiceQty = json['InvoiceQty'];
    if (json['ItemDetails'] != null) {
      _itemDetails = [];
      json['ItemDetails'].forEach((v) {
        _itemDetails?.add(ItemDetails.fromJson(v));
      });
    }
    _addedBy = json['AddedBy'];
    _action = json['Action'];
  }

  num? _pkId;
  num? _receiptId;
  num? _distributorId;
  num? _godownId;
  num? _godownKeeperId;
  String? _receiptDate;
  String? _returnOn;
  String? _vehicleNo;
  num? _itemId;
  dynamic _itemName;
  num? _filledQty;
  num? _eMRQty;
  num? _invoiceQty;
  List<ItemDetails>? _itemDetails;
  num? _addedBy;
  dynamic _action;

  GetItemReceiptListModel copyWith({
    num? pkId,
    num? receiptId,
    num? distributorId,
    num? godownId,
    num? godownKeeperId,
    String? receiptDate,
    String? returnOn,
    String? vehicleNo,
    num? itemId,
    dynamic itemName,
    num? filledQty,
    num? eMRQty,
    num? invoiceQty,
    List<ItemDetails>? itemDetails,
    num? addedBy,
    dynamic action,
  }) =>
      GetItemReceiptListModel(
        pkId: pkId ?? _pkId,
        receiptId: receiptId ?? _receiptId,
        distributorId: distributorId ?? _distributorId,
        godownId: godownId ?? _godownId,
        godownKeeperId: godownKeeperId ?? _godownKeeperId,
        receiptDate: receiptDate ?? _receiptDate,
        returnOn: returnOn ?? _returnOn,
        vehicleNo: vehicleNo ?? _vehicleNo,
        itemId: itemId ?? _itemId,
        itemName: itemName ?? _itemName,
        filledQty: filledQty ?? _filledQty,
        eMRQty: eMRQty ?? _eMRQty,
        invoiceQty: invoiceQty ?? _invoiceQty,
        itemDetails: itemDetails ?? _itemDetails,
        addedBy: addedBy ?? _addedBy,
        action: action ?? _action,
      );

  num? get pkId => _pkId;
  num? get receiptId => _receiptId;
  num? get distributorId => _distributorId;
  num? get godownId => _godownId;
  num? get godownKeeperId => _godownKeeperId;
  String? get receiptDate => _receiptDate;
  String? get returnOn => _returnOn;
  String? get vehicleNo => _vehicleNo;
  num? get itemId => _itemId;
  dynamic get itemName => _itemName;
  num? get filledQty => _filledQty;
  num? get eMRQty => _eMRQty;
  num? get invoiceQty => _invoiceQty;
  List<ItemDetails>? get itemDetails => _itemDetails;
  num? get addedBy => _addedBy;
  dynamic get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['ReceiptId'] = _receiptId;
    map['DistributorId'] = _distributorId;
    map['GodownId'] = _godownId;
    map['GodownKeeperId'] = _godownKeeperId;
    map['ReceiptDate'] = _receiptDate;
    map['ReturnOn'] = _returnOn;
    map['VehicleNo'] = _vehicleNo;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledQty'] = _filledQty;
    map['EMRQty'] = _eMRQty;
    map['InvoiceQty'] = _invoiceQty;
    if (_itemDetails != null) {
      map['ItemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    return map;
  }
}

// ─── Fixtures ─────────────────────────────────────────────────────────────────

Map<String, dynamic> _itemDetailJson1() => {
  'pkId': 0,
  'ItemId': 1,
  'ItemName': '14.2 kg..',
  'FilledQty': 250,
  'EMRQty': 100,
  'InvoiceQty': 350,
  'IsReturnSent': 0,
  'EmptyReturnQty': 0,
  'DefectiveReturnQty': 0,
};

Map<String, dynamic> _itemDetailJson2() => {
  'pkId': 0,
  'ItemId': 2,
  'ItemName': '5kg',
  'FilledQty': 100,
  'EMRQty': 100,
  'InvoiceQty': 200,
  'IsReturnSent': 0,
  'EmptyReturnQty': 0,
  'DefectiveReturnQty': 0,
};

Map<String, dynamic> _validReceiptJson() => {
  'pkId': 0,
  'ReceiptId': 1,
  'DistributorId': 0,
  'GodownId': 1,
  'GodownKeeperId': 1,
  'ReceiptDate': '2024-11-26T00:00:00',
  'ReturnOn': '0001-01-01T00:00:00',
  'VehicleNo': 'MH13DW58',
  'ItemId': 0,
  'ItemName': null,
  'FilledQty': 0,
  'EMRQty': 0,
  'InvoiceQty': 0,
  'ItemDetails': [_itemDetailJson1(), _itemDetailJson2()],
  'AddedBy': 4,
  'Action': null,
};

// =============================================================================
// ██████╗  █████╗ ██████╗ ████████╗     ██╗
// ██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝    ███║
// ██████╔╝███████║██████╔╝   ██║        ╚██║
// ██╔═══╝ ██╔══██║██╔══██╗   ██║         ██║
// ██║     ██║  ██║██║  ██║   ██║         ██║
// ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝         ╚═╝
//  ItemDetails  Tests
// =============================================================================

void main() {
  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  PART A — ItemDetails                                                   ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('═══ ItemDetails — Named Constructor ═══', () {
    test('POSITIVE: all fields stored correctly', () {
      final detail = ItemDetails(
        pkId: 0,
        itemId: 1,
        itemName: '14.2 kg..',
        filledQty: 250,
        eMRQty: 100,
        invoiceQty: 350,
        isReturnSent: 0,
        emptyReturnQty: 0,
        defectiveReturnQty: 0,
      );
      expect(detail.pkId, 0);
      expect(detail.itemId, 1);
      expect(detail.itemName, '14.2 kg..');
      expect(detail.filledQty, 250);
      expect(detail.eMRQty, 100);
      expect(detail.invoiceQty, 350);
      expect(detail.isReturnSent, 0);
      expect(detail.emptyReturnQty, 0);
      expect(detail.defectiveReturnQty, 0);
    });

    test('POSITIVE: accepts large quantity values', () {
      final detail = ItemDetails(filledQty: 99999, eMRQty: 99999, invoiceQty: 199998);
      expect(detail.filledQty, 99999);
      expect(detail.eMRQty, 99999);
      expect(detail.invoiceQty, 199998);
    });

    test('POSITIVE: accepts double qty values (num)', () {
      final detail = ItemDetails(filledQty: 10.5, eMRQty: 2.5, invoiceQty: 13.0);
      expect(detail.filledQty, 10.5);
      expect(detail.eMRQty, 2.5);
      expect(detail.invoiceQty, 13.0);
    });

    test('POSITIVE: isReturnSent = 1 (return sent)', () {
      final detail = ItemDetails(isReturnSent: 1);
      expect(detail.isReturnSent, 1);
    });

    test('POSITIVE: isReturnSent = 0 (not yet sent)', () {
      final detail = ItemDetails(isReturnSent: 0);
      expect(detail.isReturnSent, 0);
    });

    test('POSITIVE: itemName with special chars stored correctly', () {
      final detail = ItemDetails(itemName: '14.2 kg.. (LPG)');
      expect(detail.itemName, '14.2 kg.. (LPG)');
    });

    test('POSITIVE: emptyReturnQty and defectiveReturnQty can be non-zero', () {
      final detail = ItemDetails(emptyReturnQty: 15, defectiveReturnQty: 5);
      expect(detail.emptyReturnQty, 15);
      expect(detail.defectiveReturnQty, 5);
    });

    test('NEGATIVE: no-arg constructor — all fields null', () {
      final detail = ItemDetails();
      expect(detail.pkId, isNull);
      expect(detail.itemId, isNull);
      expect(detail.itemName, isNull);
      expect(detail.filledQty, isNull);
      expect(detail.eMRQty, isNull);
      expect(detail.invoiceQty, isNull);
      expect(detail.isReturnSent, isNull);
      expect(detail.emptyReturnQty, isNull);
      expect(detail.defectiveReturnQty, isNull);
    });

    test('NEGATIVE: pkId = 0 stored as-is (not treated as null)', () {
      final detail = ItemDetails(pkId: 0);
      expect(detail.pkId, 0);
      expect(detail.pkId, isNotNull);
    });

    test('NEGATIVE: negative filledQty stored without error', () {
      final detail = ItemDetails(filledQty: -10);
      expect(detail.filledQty, -10);
    });

    test('NEGATIVE: empty itemName stored as empty string', () {
      final detail = ItemDetails(itemName: '');
      expect(detail.itemName, '');
    });

    test('NEGATIVE: null itemName does not throw', () {
      expect(() => ItemDetails(itemName: null), returnsNormally);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ ItemDetails — fromJson ═══', () {
    test('POSITIVE: parses all fields from complete JSON', () {
      final detail = ItemDetails.fromJson(_itemDetailJson1());
      expect(detail.pkId, 0);
      expect(detail.itemId, 1);
      expect(detail.itemName, '14.2 kg..');
      expect(detail.filledQty, 250);
      expect(detail.eMRQty, 100);
      expect(detail.invoiceQty, 350);
      expect(detail.isReturnSent, 0);
      expect(detail.emptyReturnQty, 0);
      expect(detail.defectiveReturnQty, 0);
    });

    test('POSITIVE: parses second item detail JSON correctly', () {
      final detail = ItemDetails.fromJson(_itemDetailJson2());
      expect(detail.itemId, 2);
      expect(detail.itemName, '5kg');
      expect(detail.filledQty, 100);
      expect(detail.eMRQty, 100);
      expect(detail.invoiceQty, 200);
    });

    test('POSITIVE: filledQty parsed as integer', () {
      final detail = ItemDetails.fromJson({'FilledQty': 500});
      expect(detail.filledQty, 500);
    });

    test('POSITIVE: invoiceQty = filled + emr (350 = 250 + 100)', () {
      final detail = ItemDetails.fromJson(_itemDetailJson1());
      final sum = (detail.filledQty ?? 0) + (detail.eMRQty ?? 0);
      expect(sum, detail.invoiceQty);
    });

    test('POSITIVE: emptyReturnQty and defectiveReturnQty = 0 parsed correctly', () {
      final detail = ItemDetails.fromJson(_itemDetailJson1());
      expect(detail.emptyReturnQty, 0);
      expect(detail.defectiveReturnQty, 0);
    });

    test('POSITIVE: extra unknown keys in JSON are ignored', () {
      final json = _itemDetailJson1()..['ExtraKey'] = 'ignored';
      expect(() => ItemDetails.fromJson(json), returnsNormally);
    });

    test('POSITIVE: large emptyReturnQty parsed correctly', () {
      final detail = ItemDetails.fromJson({'EmptyReturnQty': 9999});
      expect(detail.emptyReturnQty, 9999);
    });

    test('NEGATIVE: missing all keys — all fields null', () {
      final detail = ItemDetails.fromJson(<String, dynamic>{});
      expect(detail.pkId, isNull);
      expect(detail.itemId, isNull);
      expect(detail.itemName, isNull);
      expect(detail.filledQty, isNull);
      expect(detail.eMRQty, isNull);
      expect(detail.invoiceQty, isNull);
      expect(detail.isReturnSent, isNull);
      expect(detail.emptyReturnQty, isNull);
      expect(detail.defectiveReturnQty, isNull);
    });

    test('NEGATIVE: null values in JSON stored as null', () {
      final json = {
        'pkId': null,
        'ItemId': null,
        'ItemName': null,
        'FilledQty': null,
        'EMRQty': null,
        'InvoiceQty': null,
        'IsReturnSent': null,
        'EmptyReturnQty': null,
        'DefectiveReturnQty': null,
      };
      final detail = ItemDetails.fromJson(json);
      expect(detail.filledQty, isNull);
      expect(detail.itemName, isNull);
    });

    test('NEGATIVE: wrong-case key not parsed (case-sensitive)', () {
      final detail = ItemDetails.fromJson({'filledQty': 500}); // lowercase
      expect(detail.filledQty, isNull);
    });

    test('NEGATIVE: wrong key "filled_qty" (snake_case) not parsed', () {
      final detail = ItemDetails.fromJson({'filled_qty': 100});
      expect(detail.filledQty, isNull);
    });

    test('NEGATIVE: negative quantities parsed as-is', () {
      final detail = ItemDetails.fromJson({
        'FilledQty': -50,
        'EMRQty': -20,
        'InvoiceQty': -70,
      });
      expect(detail.filledQty, -50);
      expect(detail.eMRQty, -20);
      expect(detail.invoiceQty, -70);
    });

    test('NEGATIVE: ItemName as integer does not throw', () {
      expect(() => ItemDetails.fromJson({'ItemName': 123}), returnsNormally);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ ItemDetails — toJson ═══', () {
    test('POSITIVE: produces map with all 9 expected keys', () {
      final detail = ItemDetails.fromJson(_itemDetailJson1());
      final json = detail.toJson();
      expect(json.keys, containsAll([
        'pkId', 'ItemId', 'ItemName', 'FilledQty', 'EMRQty',
        'InvoiceQty', 'IsReturnSent', 'EmptyReturnQty', 'DefectiveReturnQty',
      ]));
    });

    test('POSITIVE: serialised values match original JSON', () {
      final detail = ItemDetails.fromJson(_itemDetailJson1());
      final json = detail.toJson();
      expect(json['pkId'], 0);
      expect(json['ItemId'], 1);
      expect(json['ItemName'], '14.2 kg..');
      expect(json['FilledQty'], 250);
      expect(json['EMRQty'], 100);
      expect(json['InvoiceQty'], 350);
      expect(json['IsReturnSent'], 0);
      expect(json['EmptyReturnQty'], 0);
      expect(json['DefectiveReturnQty'], 0);
    });

    test('POSITIVE: toJson round-trip preserves all data', () {
      final original = ItemDetails.fromJson(_itemDetailJson1());
      final restored = ItemDetails.fromJson(original.toJson());
      expect(restored.itemId, original.itemId);
      expect(restored.itemName, original.itemName);
      expect(restored.filledQty, original.filledQty);
      expect(restored.eMRQty, original.eMRQty);
      expect(restored.invoiceQty, original.invoiceQty);
      expect(restored.isReturnSent, original.isReturnSent);
      expect(restored.emptyReturnQty, original.emptyReturnQty);
      expect(restored.defectiveReturnQty, original.defectiveReturnQty);
    });

    test('POSITIVE: toJson has exactly 9 keys', () {
      final detail = ItemDetails.fromJson(_itemDetailJson1());
      expect(detail.toJson().length, 9);
    });

    test('POSITIVE: null fields included as null in map', () {
      final detail = ItemDetails();
      final json = detail.toJson();
      expect(json.containsKey('ItemName'), isTrue);
      expect(json['ItemName'], isNull);
      expect(json['FilledQty'], isNull);
    });

    test('POSITIVE: zero quantities serialise as 0 (not null)', () {
      final detail = ItemDetails(
          filledQty: 0, eMRQty: 0, invoiceQty: 0,
          isReturnSent: 0, emptyReturnQty: 0, defectiveReturnQty: 0);
      final json = detail.toJson();
      expect(json['FilledQty'], 0);
      expect(json['EMRQty'], 0);
      expect(json['InvoiceQty'], 0);
    });

    test('NEGATIVE: toJson on default instance — all values null', () {
      final detail = ItemDetails();
      final json = detail.toJson();
      expect(json.values.every((v) => v == null), isTrue);
    });

    test('NEGATIVE: modifying toJson output does not affect model', () {
      final detail = ItemDetails(filledQty: 100);
      final json = detail.toJson();
      json['FilledQty'] = 9999;
      expect(detail.filledQty, 100);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ ItemDetails — copyWith ═══', () {
    late ItemDetails base;
    setUp(() => base = ItemDetails.fromJson(_itemDetailJson1()));

    test('POSITIVE: no args — all fields identical', () {
      final copy = base.copyWith();
      expect(copy.pkId, base.pkId);
      expect(copy.itemId, base.itemId);
      expect(copy.itemName, base.itemName);
      expect(copy.filledQty, base.filledQty);
      expect(copy.eMRQty, base.eMRQty);
      expect(copy.invoiceQty, base.invoiceQty);
      expect(copy.isReturnSent, base.isReturnSent);
      expect(copy.emptyReturnQty, base.emptyReturnQty);
      expect(copy.defectiveReturnQty, base.defectiveReturnQty);
    });

    test('POSITIVE: updates pkId only', () {
      final copy = base.copyWith(pkId: 99);
      expect(copy.pkId, 99);
      expect(copy.itemId, base.itemId);
    });

    test('POSITIVE: updates itemId only', () {
      final copy = base.copyWith(itemId: 10);
      expect(copy.itemId, 10);
      expect(copy.itemName, base.itemName);
    });

    test('POSITIVE: updates itemName only', () {
      final copy = base.copyWith(itemName: 'NewItem');
      expect(copy.itemName, 'NewItem');
      expect(copy.filledQty, base.filledQty);
    });

    test('POSITIVE: updates filledQty only', () {
      final copy = base.copyWith(filledQty: 500);
      expect(copy.filledQty, 500);
      expect(copy.eMRQty, base.eMRQty);
    });

    test('POSITIVE: updates eMRQty only', () {
      final copy = base.copyWith(eMRQty: 200);
      expect(copy.eMRQty, 200);
    });

    test('POSITIVE: updates invoiceQty only', () {
      final copy = base.copyWith(invoiceQty: 700);
      expect(copy.invoiceQty, 700);
    });

    test('POSITIVE: updates isReturnSent to 1', () {
      final copy = base.copyWith(isReturnSent: 1);
      expect(copy.isReturnSent, 1);
    });

    test('POSITIVE: updates emptyReturnQty', () {
      final copy = base.copyWith(emptyReturnQty: 30);
      expect(copy.emptyReturnQty, 30);
    });

    test('POSITIVE: updates defectiveReturnQty', () {
      final copy = base.copyWith(defectiveReturnQty: 7);
      expect(copy.defectiveReturnQty, 7);
    });

    test('POSITIVE: updates all fields at once', () {
      final copy = base.copyWith(
        pkId: 1, itemId: 5, itemName: 'Updated', filledQty: 300,
        eMRQty: 50, invoiceQty: 350, isReturnSent: 1,
        emptyReturnQty: 10, defectiveReturnQty: 2,
      );
      expect(copy.pkId, 1);
      expect(copy.itemId, 5);
      expect(copy.itemName, 'Updated');
      expect(copy.filledQty, 300);
      expect(copy.eMRQty, 50);
      expect(copy.invoiceQty, 350);
      expect(copy.isReturnSent, 1);
      expect(copy.emptyReturnQty, 10);
      expect(copy.defectiveReturnQty, 2);
    });

    test('POSITIVE: returns distinct instance', () {
      expect(identical(base.copyWith(), base), isFalse);
    });

    test('POSITIVE: chain copyWith gives independent copies', () {
      final copy1 = base.copyWith(filledQty: 111);
      final copy2 = copy1.copyWith(filledQty: 222);
      expect(copy1.filledQty, 111);
      expect(copy2.filledQty, 222);
    });

    test('NEGATIVE: does not mutate original', () {
      base.copyWith(filledQty: 9999);
      expect(base.filledQty, 250);
    });

    test('NEGATIVE: passing null arg falls back to original (via ??)', () {
      final copy = base.copyWith(itemName: null);
      expect(copy.itemName, base.itemName);
    });

    test('POSITIVE: can set filledQty to 0 via copyWith', () {
      final copy = base.copyWith(filledQty: 0);
      expect(copy.filledQty, 0);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ ItemDetails — Getters ═══', () {
    test('POSITIVE: all getters return correct num/String types', () {
      final detail = ItemDetails.fromJson(_itemDetailJson1());
      expect(detail.pkId, isA<num>());
      expect(detail.itemId, isA<num>());
      expect(detail.itemName, isA<String>());
      expect(detail.filledQty, isA<num>());
      expect(detail.eMRQty, isA<num>());
      expect(detail.invoiceQty, isA<num>());
      expect(detail.isReturnSent, isA<num>());
      expect(detail.emptyReturnQty, isA<num>());
      expect(detail.defectiveReturnQty, isA<num>());
    });

    test('NEGATIVE: all getters null on default instance', () {
      final detail = ItemDetails();
      expect(detail.pkId, isNull);
      expect(detail.itemId, isNull);
      expect(detail.itemName, isNull);
      expect(detail.filledQty, isNull);
      expect(detail.eMRQty, isNull);
      expect(detail.invoiceQty, isNull);
      expect(detail.isReturnSent, isNull);
      expect(detail.emptyReturnQty, isNull);
      expect(detail.defectiveReturnQty, isNull);
    });
  });

  // ╔══════════════════════════════════════════════════════════════════════════╗
  // ║  PART B — GetItemReceiptListModel                                       ║
  // ╚══════════════════════════════════════════════════════════════════════════╝

  group('═══ GetItemReceiptListModel — Named Constructor ═══', () {
    test('POSITIVE: all scalar fields stored correctly', () {
      final model = GetItemReceiptListModel(
        pkId: 0,
        receiptId: 1,
        distributorId: 0,
        godownId: 1,
        godownKeeperId: 1,
        receiptDate: '2024-11-26T00:00:00',
        returnOn: '0001-01-01T00:00:00',
        vehicleNo: 'MH13DW58',
        itemId: 0,
        itemName: null,
        filledQty: 0,
        eMRQty: 0,
        invoiceQty: 0,
        addedBy: 4,
        action: null,
      );
      expect(model.pkId, 0);
      expect(model.receiptId, 1);
      expect(model.distributorId, 0);
      expect(model.godownId, 1);
      expect(model.godownKeeperId, 1);
      expect(model.receiptDate, '2024-11-26T00:00:00');
      expect(model.returnOn, '0001-01-01T00:00:00');
      expect(model.vehicleNo, 'MH13DW58');
      expect(model.itemId, 0);
      expect(model.itemName, isNull);
      expect(model.filledQty, 0);
      expect(model.eMRQty, 0);
      expect(model.invoiceQty, 0);
      expect(model.addedBy, 4);
      expect(model.action, isNull);
    });

    test('POSITIVE: itemDetails list stored correctly', () {
      final details = [
        ItemDetails(itemId: 1, itemName: '14.2 kg..', filledQty: 250),
        ItemDetails(itemId: 2, itemName: '5kg', filledQty: 100),
      ];
      final model = GetItemReceiptListModel(itemDetails: details);
      expect(model.itemDetails?.length, 2);
      expect(model.itemDetails?[0].itemName, '14.2 kg..');
      expect(model.itemDetails?[1].itemName, '5kg');
    });

    test('POSITIVE: vehicleNo alphanumeric stored correctly', () {
      final model = GetItemReceiptListModel(vehicleNo: 'MH13DW58');
      expect(model.vehicleNo, 'MH13DW58');
    });

    test('POSITIVE: action accepts string value', () {
      final model = GetItemReceiptListModel(action: 'ADD');
      expect(model.action, 'ADD');
    });

    test('POSITIVE: itemName accepts string value', () {
      final model = GetItemReceiptListModel(itemName: '5kg');
      expect(model.itemName, '5kg');
    });

    test('NEGATIVE: no-arg constructor — all fields null', () {
      final model = GetItemReceiptListModel();
      expect(model.pkId, isNull);
      expect(model.receiptId, isNull);
      expect(model.distributorId, isNull);
      expect(model.godownId, isNull);
      expect(model.godownKeeperId, isNull);
      expect(model.receiptDate, isNull);
      expect(model.returnOn, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.itemId, isNull);
      expect(model.itemName, isNull);
      expect(model.filledQty, isNull);
      expect(model.eMRQty, isNull);
      expect(model.invoiceQty, isNull);
      expect(model.itemDetails, isNull);
      expect(model.addedBy, isNull);
      expect(model.action, isNull);
    });

    test('NEGATIVE: empty itemDetails list stored as empty list', () {
      final model = GetItemReceiptListModel(itemDetails: []);
      expect(model.itemDetails, isEmpty);
    });

    test('NEGATIVE: negative receiptId stored without error', () {
      final model = GetItemReceiptListModel(receiptId: -1);
      expect(model.receiptId, -1);
    });

    test('NEGATIVE: pkId = 0 is stored as-is', () {
      final model = GetItemReceiptListModel(pkId: 0);
      expect(model.pkId, 0);
      expect(model.pkId, isNotNull);
    });

    test('NEGATIVE: empty vehicleNo string stored as-is', () {
      final model = GetItemReceiptListModel(vehicleNo: '');
      expect(model.vehicleNo, '');
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ GetItemReceiptListModel — fromJson ═══', () {
    test('POSITIVE: parses all scalar fields from complete JSON', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.pkId, 0);
      expect(model.receiptId, 1);
      expect(model.distributorId, 0);
      expect(model.godownId, 1);
      expect(model.godownKeeperId, 1);
      expect(model.receiptDate, '2024-11-26T00:00:00');
      expect(model.returnOn, '0001-01-01T00:00:00');
      expect(model.vehicleNo, 'MH13DW58');
      expect(model.itemId, 0);
      expect(model.itemName, isNull);
      expect(model.filledQty, 0);
      expect(model.eMRQty, 0);
      expect(model.invoiceQty, 0);
      expect(model.addedBy, 4);
      expect(model.action, isNull);
    });

    test('POSITIVE: itemDetails parsed as list of ItemDetails', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.itemDetails, isNotNull);
      expect(model.itemDetails!.length, 2);
    });

    test('POSITIVE: first itemDetail parsed correctly', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final d = model.itemDetails![0];
      expect(d.itemId, 1);
      expect(d.itemName, '14.2 kg..');
      expect(d.filledQty, 250);
      expect(d.eMRQty, 100);
      expect(d.invoiceQty, 350);
    });

    test('POSITIVE: second itemDetail parsed correctly', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final d = model.itemDetails![1];
      expect(d.itemId, 2);
      expect(d.itemName, '5kg');
      expect(d.filledQty, 100);
      expect(d.eMRQty, 100);
      expect(d.invoiceQty, 200);
    });

    test('POSITIVE: null ItemDetails in JSON leaves _itemDetails null', () {
      final json = _validReceiptJson()..['ItemDetails'] = null;
      final model = GetItemReceiptListModel.fromJson(json);
      expect(model.itemDetails, isNull);
    });

    test('POSITIVE: empty ItemDetails array parsed as empty list', () {
      final json = _validReceiptJson()..['ItemDetails'] = [];
      final model = GetItemReceiptListModel.fromJson(json);
      expect(model.itemDetails, isEmpty);
    });

    test('POSITIVE: vehicleNo parsed as alphanumeric string', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.vehicleNo, 'MH13DW58');
    });

    test('POSITIVE: receiptDate ISO string parsed as-is', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.receiptDate, '2024-11-26T00:00:00');
    });

    test('POSITIVE: returnOn default ISO string parsed correctly', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.returnOn, '0001-01-01T00:00:00');
    });

    test('POSITIVE: extra unknown keys in JSON are ignored', () {
      final json = _validReceiptJson()..['Unknown'] = 'ignored';
      expect(() => GetItemReceiptListModel.fromJson(json), returnsNormally);
    });

    test('POSITIVE: single itemDetail in list parsed correctly', () {
      final json = _validReceiptJson()
        ..['ItemDetails'] = [_itemDetailJson1()];
      final model = GetItemReceiptListModel.fromJson(json);
      expect(model.itemDetails!.length, 1);
      expect(model.itemDetails![0].itemName, '14.2 kg..');
    });

    test('NEGATIVE: missing all keys — all fields null', () {
      final model = GetItemReceiptListModel.fromJson(<String, dynamic>{});
      expect(model.pkId, isNull);
      expect(model.receiptId, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.itemDetails, isNull);
    });

    test('NEGATIVE: null values throughout JSON stored as null', () {
      final json = {
        'pkId': null,
        'ReceiptId': null,
        'DistributorId': null,
        'GodownId': null,
        'GodownKeeperId': null,
        'ReceiptDate': null,
        'ReturnOn': null,
        'VehicleNo': null,
        'ItemId': null,
        'ItemName': null,
        'FilledQty': null,
        'EMRQty': null,
        'InvoiceQty': null,
        'ItemDetails': null,
        'AddedBy': null,
        'Action': null,
      };
      final model = GetItemReceiptListModel.fromJson(json);
      expect(model.receiptId, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.itemDetails, isNull);
    });

    test('NEGATIVE: wrong-case "receiptId" (camelCase) not parsed', () {
      final model =
      GetItemReceiptListModel.fromJson({'receiptId': 100}); // wrong case
      expect(model.receiptId, isNull);
    });

    test('NEGATIVE: wrong key "vehicle_no" (snake_case) not parsed', () {
      final model =
      GetItemReceiptListModel.fromJson({'vehicle_no': 'MH12AB1234'});
      expect(model.vehicleNo, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ GetItemReceiptListModel — toJson ═══', () {
    test('POSITIVE: produces map with all expected scalar keys', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final json = model.toJson();
      expect(json.keys, containsAll([
        'pkId', 'ReceiptId', 'DistributorId', 'GodownId', 'GodownKeeperId',
        'ReceiptDate', 'ReturnOn', 'VehicleNo', 'ItemId', 'ItemName',
        'FilledQty', 'EMRQty', 'InvoiceQty', 'ItemDetails', 'AddedBy', 'Action',
      ]));
    });

    test('POSITIVE: serialised scalar values match original', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final json = model.toJson();
      expect(json['pkId'], 0);
      expect(json['ReceiptId'], 1);
      expect(json['DistributorId'], 0);
      expect(json['GodownId'], 1);
      expect(json['GodownKeeperId'], 1);
      expect(json['ReceiptDate'], '2024-11-26T00:00:00');
      expect(json['ReturnOn'], '0001-01-01T00:00:00');
      expect(json['VehicleNo'], 'MH13DW58');
      expect(json['AddedBy'], 4);
    });

    test('POSITIVE: ItemDetails serialised as list of maps', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final json = model.toJson();
      final details = json['ItemDetails'] as List;
      expect(details.length, 2);
      expect(details[0]['ItemId'], 1);
      expect(details[1]['ItemId'], 2);
    });

    test('POSITIVE: toJson round-trip preserves all data including itemDetails',
            () {
          final original = GetItemReceiptListModel.fromJson(_validReceiptJson());
          final restored =
          GetItemReceiptListModel.fromJson(original.toJson());
          expect(restored.receiptId, original.receiptId);
          expect(restored.vehicleNo, original.vehicleNo);
          expect(restored.itemDetails!.length, original.itemDetails!.length);
          expect(
              restored.itemDetails![0].filledQty, original.itemDetails![0].filledQty);
        });

    test('POSITIVE: ItemDetails key absent when _itemDetails is null', () {
      final model = GetItemReceiptListModel(pkId: 1, receiptId: 1);
      final json = model.toJson();
      expect(json.containsKey('ItemDetails'), isFalse);
    });

    test('POSITIVE: null ItemName serialised as null', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.toJson()['ItemName'], isNull);
    });

    test('POSITIVE: null Action serialised as null', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.toJson()['Action'], isNull);
    });

    test('POSITIVE: itemDetails with 0 entries serialises as empty list', () {
      final model = GetItemReceiptListModel(itemDetails: []);
      final json = model.toJson();
      expect(json['ItemDetails'], isEmpty);
    });

    test('NEGATIVE: modifying toJson map does not affect model', () {
      final model = GetItemReceiptListModel(vehicleNo: 'MH12AB1234');
      final json = model.toJson();
      json['VehicleNo'] = 'MODIFIED';
      expect(model.vehicleNo, 'MH12AB1234');
    });

    test('NEGATIVE: toJson on default instance — scalars null, no ItemDetails key',
            () {
          final model = GetItemReceiptListModel();
          final json = model.toJson();
          expect(json['pkId'], isNull);
          expect(json['VehicleNo'], isNull);
          expect(json.containsKey('ItemDetails'), isFalse);
        });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ GetItemReceiptListModel — copyWith ═══', () {
    late GetItemReceiptListModel base;
    setUp(() => base = GetItemReceiptListModel.fromJson(_validReceiptJson()));

    test('POSITIVE: no args — all fields identical', () {
      final copy = base.copyWith();
      expect(copy.pkId, base.pkId);
      expect(copy.receiptId, base.receiptId);
      expect(copy.distributorId, base.distributorId);
      expect(copy.godownId, base.godownId);
      expect(copy.godownKeeperId, base.godownKeeperId);
      expect(copy.receiptDate, base.receiptDate);
      expect(copy.returnOn, base.returnOn);
      expect(copy.vehicleNo, base.vehicleNo);
      expect(copy.itemId, base.itemId);
      expect(copy.itemName, base.itemName);
      expect(copy.filledQty, base.filledQty);
      expect(copy.eMRQty, base.eMRQty);
      expect(copy.invoiceQty, base.invoiceQty);
      expect(copy.addedBy, base.addedBy);
      expect(copy.action, base.action);
    });

    test('POSITIVE: updates receiptId only', () {
      final copy = base.copyWith(receiptId: 99);
      expect(copy.receiptId, 99);
      expect(copy.vehicleNo, base.vehicleNo);
    });

    test('POSITIVE: updates vehicleNo only', () {
      final copy = base.copyWith(vehicleNo: 'MH99ZZ9999');
      expect(copy.vehicleNo, 'MH99ZZ9999');
      expect(copy.receiptId, base.receiptId);
    });

    test('POSITIVE: updates receiptDate only', () {
      final copy = base.copyWith(receiptDate: '2025-01-01T00:00:00');
      expect(copy.receiptDate, '2025-01-01T00:00:00');
    });

    test('POSITIVE: updates returnOn only', () {
      final copy = base.copyWith(returnOn: '2025-06-01T00:00:00');
      expect(copy.returnOn, '2025-06-01T00:00:00');
    });

    test('POSITIVE: updates distributorId only', () {
      final copy = base.copyWith(distributorId: 9999);
      expect(copy.distributorId, 9999);
    });

    test('POSITIVE: updates godownId only', () {
      final copy = base.copyWith(godownId: 5);
      expect(copy.godownId, 5);
    });

    test('POSITIVE: updates godownKeeperId only', () {
      final copy = base.copyWith(godownKeeperId: 7);
      expect(copy.godownKeeperId, 7);
    });

    test('POSITIVE: updates filledQty only', () {
      final copy = base.copyWith(filledQty: 500);
      expect(copy.filledQty, 500);
    });

    test('POSITIVE: updates eMRQty only', () {
      final copy = base.copyWith(eMRQty: 150);
      expect(copy.eMRQty, 150);
    });

    test('POSITIVE: updates invoiceQty only', () {
      final copy = base.copyWith(invoiceQty: 650);
      expect(copy.invoiceQty, 650);
    });

    test('POSITIVE: updates addedBy only', () {
      final copy = base.copyWith(addedBy: 99);
      expect(copy.addedBy, 99);
    });

    test('POSITIVE: updates action to a string value', () {
      final copy = base.copyWith(action: 'EDIT');
      expect(copy.action, 'EDIT');
    });

    test('POSITIVE: replaces itemDetails list', () {
      final newDetails = [
        ItemDetails(itemId: 10, itemName: 'NewItem', filledQty: 50),
      ];
      final copy = base.copyWith(itemDetails: newDetails);
      expect(copy.itemDetails!.length, 1);
      expect(copy.itemDetails![0].itemId, 10);
    });

    test('POSITIVE: clears itemDetails via copyWith empty list', () {
      final copy = base.copyWith(itemDetails: []);
      expect(copy.itemDetails, isEmpty);
    });

    test('POSITIVE: returns distinct instance', () {
      expect(identical(base.copyWith(), base), isFalse);
    });

    test('POSITIVE: chained copyWith gives independent copies', () {
      final copy1 = base.copyWith(receiptId: 10);
      final copy2 = copy1.copyWith(receiptId: 20);
      expect(copy1.receiptId, 10);
      expect(copy2.receiptId, 20);
    });

    test('NEGATIVE: does not mutate original', () {
      base.copyWith(vehicleNo: 'MUTATED');
      expect(base.vehicleNo, 'MH13DW58');
    });

    test('NEGATIVE: null arg falls back to original value via ??', () {
      final copy = base.copyWith(vehicleNo: null);
      expect(copy.vehicleNo, base.vehicleNo);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ GetItemReceiptListModel — Getters ═══', () {
    test('POSITIVE: all getters return correct types from fromJson', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.pkId, isA<num>());
      expect(model.receiptId, isA<num>());
      expect(model.distributorId, isA<num>());
      expect(model.godownId, isA<num>());
      expect(model.godownKeeperId, isA<num>());
      expect(model.receiptDate, isA<String>());
      expect(model.returnOn, isA<String>());
      expect(model.vehicleNo, isA<String>());
      expect(model.itemId, isA<num>());
      expect(model.filledQty, isA<num>());
      expect(model.eMRQty, isA<num>());
      expect(model.invoiceQty, isA<num>());
      expect(model.itemDetails, isA<List<ItemDetails>>());
      expect(model.addedBy, isA<num>());
    });

    test('POSITIVE: itemDetails getter returns 2 items', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.itemDetails!.length, 2);
    });

    test('NEGATIVE: all getters null on default instance', () {
      final model = GetItemReceiptListModel();
      expect(model.pkId, isNull);
      expect(model.receiptId, isNull);
      expect(model.vehicleNo, isNull);
      expect(model.itemDetails, isNull);
    });

    test('POSITIVE: itemName getter is dynamic — can be null', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.itemName, isNull);
    });

    test('POSITIVE: action getter is dynamic — can be null', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      expect(model.action, isNull);
    });
  });

  // ───────────────────────────────────────────────────────────────────────────
  group('═══ Business Logic & Edge Cases ═══', () {
    test('POSITIVE: total invoiceQty = sum of all itemDetail invoiceQtys', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final total = model.itemDetails!
          .fold<num>(0, (sum, d) => sum + (d.invoiceQty ?? 0));
      expect(total, 550); // 350 + 200
    });

    test('POSITIVE: total filledQty across all itemDetails', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final total = model.itemDetails!
          .fold<num>(0, (sum, d) => sum + (d.filledQty ?? 0));
      expect(total, 350); // 250 + 100
    });

    test('POSITIVE: total eMRQty across all itemDetails', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final total = model.itemDetails!
          .fold<num>(0, (sum, d) => sum + (d.eMRQty ?? 0));
      expect(total, 200); // 100 + 100
    });

    test('POSITIVE: filter itemDetails by isReturnSent = 0', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final pending =
      model.itemDetails!.where((d) => d.isReturnSent == 0).toList();
      expect(pending.length, 2);
    });

    test('POSITIVE: filter itemDetails by isReturnSent = 1', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final returned =
      model.itemDetails!.where((d) => d.isReturnSent == 1).toList();
      expect(returned, isEmpty);
    });

    test('POSITIVE: find itemDetail by itemId = 2', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final found =
      model.itemDetails!.firstWhere((d) => d.itemId == 2);
      expect(found.itemName, '5kg');
    });

    test('POSITIVE: vehicleNo matches expected pattern format', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final regex = RegExp(r'^[A-Z0-9]+$');
      expect(regex.hasMatch(model.vehicleNo!), isTrue);
    });

    test('POSITIVE: receiptDate can be parsed as DateTime', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final dt = DateTime.tryParse(model.receiptDate!);
      expect(dt, isNotNull);
      expect(dt!.year, 2024);
      expect(dt.month, 11);
      expect(dt.day, 26);
    });

    test('POSITIVE: returnOn default date can be parsed as DateTime', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final dt = DateTime.tryParse(model.returnOn!);
      expect(dt, isNotNull);
      expect(dt!.year, 1); // year 0001
    });

    test('NEGATIVE: null itemDetails — fold returns 0 safely with null check', () {
      final model = GetItemReceiptListModel();
      final total =
          model.itemDetails?.fold<num>(0, (s, d) => s + (d.invoiceQty ?? 0)) ??
              0;
      expect(total, 0);
    });

    test('NEGATIVE: empty itemDetails — sum is 0', () {
      final model = GetItemReceiptListModel(itemDetails: []);
      final total = model.itemDetails!
          .fold<num>(0, (s, d) => s + (d.invoiceQty ?? 0));
      expect(total, 0);
    });

    test('POSITIVE: list of receipts parsed from JSON array', () {
      final jsonList = [_validReceiptJson(), _validReceiptJson()];
      final models =
      jsonList.map((j) => GetItemReceiptListModel.fromJson(j)).toList();
      expect(models.length, 2);
      expect(models[0].receiptId, 1);
      expect(models[1].receiptId, 1);
    });

    test('POSITIVE: stress — 50 itemDetails in one receipt parsed correctly', () {
      final jsonList = List.generate(
          50,
              (i) => {
            'pkId': 0,
            'ItemId': i + 1,
            'ItemName': 'Item$i',
            'FilledQty': i * 10,
            'EMRQty': i * 2,
            'InvoiceQty': i * 12,
            'IsReturnSent': 0,
            'EmptyReturnQty': 0,
            'DefectiveReturnQty': 0,
          });
      final json = _validReceiptJson()..['ItemDetails'] = jsonList;
      final model = GetItemReceiptListModel.fromJson(json);
      expect(model.itemDetails!.length, 50);
      expect(model.itemDetails![49].itemName, 'Item49');
    });

    test('POSITIVE: itemDetails each hold correct invoiceQty = filled + emr', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      for (final d in model.itemDetails!) {
        final expected = (d.filledQty ?? 0) + (d.eMRQty ?? 0);
        expect(d.invoiceQty, expected);
      }
    });

    test('NEGATIVE: receipt with isReturnSent all 0 — no returned items', () {
      final model = GetItemReceiptListModel.fromJson(_validReceiptJson());
      final allNotReturned =
      model.itemDetails!.every((d) => d.isReturnSent == 0);
      expect(allNotReturned, isTrue);
    });
  });
}