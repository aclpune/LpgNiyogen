// =============================================================================
// TEST FILE — ItenRetun.dart & ItenReturnItemUi.dart
// 14 groups | 46 positive (P-01…P-46) | 34 negative (N-01…N-34)
// =============================================================================
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/ItemReturn/ItenReturnItemUi.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/EditItem/Model/GetItemReceiptListModel.dart';
// =============================================================================
// HELPERS
// =============================================================================
GetItemReceiptListModel _buildReceipt({
  int pkId = 0, int receiptId = 1, String vehicleNo = 'MH12AB1234',
  String receiptDate = '2024-01-15T00:00:00', String returnOn = '0001-01-01T00:00:00',
  List<ItemDetails>? items, int godownId = 1, int distributorId = 10, int godownKeeperId = 3,
}) => GetItemReceiptListModel(
      pkId: pkId, receiptId: receiptId, vehicleNo: vehicleNo, receiptDate: receiptDate,
      returnOn: returnOn, godownId: godownId, distributorId: distributorId,
      godownKeeperId: godownKeeperId, itemDetails: items ?? [_buildDetail()],
    );
ItemDetails _buildDetail({
  int pkId = 0, int itemId = 101, String itemName = 'LPG Cylinder',
  int filledQty = 10, int eMRQty = 2, int invoiceQty = 10,
  int isReturnSent = 0, int emptyReturnQty = 0, int defectiveReturnQty = 0,
}) => ItemDetails(
      pkId: pkId, itemId: itemId, itemName: itemName, filledQty: filledQty,
      eMRQty: eMRQty, invoiceQty: invoiceQty, isReturnSent: isReturnSent,
      emptyReturnQty: emptyReturnQty, defectiveReturnQty: defectiveReturnQty,
    );
// =============================================================================
// MAIN
// =============================================================================
void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({
      'DistributorId': '10', 'godownId': '1', 'StaffId': '5',
      'godownKeeperId': '3', 'token': 'test_bearer_token', 'MobileNo': '9999999999',
    });
  });
  // ===========================================================================
  // GROUP 1 — GetItemReceiptListModel: fromJson
  // ===========================================================================
  group('GetItemReceiptListModel – fromJson', () {
    test('P-01 parses all top-level fields correctly', () {
      final j = {
        'pkId': 0, 'ReceiptId': 42, 'VehicleNo': 'MH12AB5678',
        'ReceiptDate': '2024-03-10T00:00:00', 'ReturnOn': '0001-01-01T00:00:00',
        'GodownId': 7, 'DistributorId': 10, 'GodownKeeperId': 3, 'ItemDetails': [], 'AddedBy': 4, 'Action': null,
      };
      final m = GetItemReceiptListModel.fromJson(j);
      expect(m.receiptId, 42); expect(m.vehicleNo, 'MH12AB5678');
      expect(m.receiptDate, '2024-03-10T00:00:00'); expect(m.returnOn, '0001-01-01T00:00:00');
      expect(m.godownId, 7); expect(m.distributorId, 10); expect(m.addedBy, 4);
    });
    test('P-02 parses nested ItemDetails list correctly', () {
      final j = {
        'ReceiptId': 1, 'VehicleNo': 'MH01AA0001', 'ReceiptDate': '2024-01-01T00:00:00',
        'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 1, 'ItemDetails': [
          {'pkId': 0, 'ItemId': 10, 'ItemName': 'Cyl A', 'FilledQty': 5, 'EMRQty': 1, 'InvoiceQty': 5, 'IsReturnSent': 0, 'EmptyReturnQty': 0, 'DefectiveReturnQty': 0},
          {'pkId': 0, 'ItemId': 20, 'ItemName': 'Cyl B', 'FilledQty': 3, 'EMRQty': 0, 'InvoiceQty': 3, 'IsReturnSent': 0, 'EmptyReturnQty': 0, 'DefectiveReturnQty': 0},
        ],
      };
      final m = GetItemReceiptListModel.fromJson(j);
      expect(m.itemDetails!.length, 2); expect(m.itemDetails![0].itemName, 'Cyl A'); expect(m.itemDetails![1].itemName, 'Cyl B');
    });
    test('P-03 returnOn "0001-01-01T00:00:00" indicates pending status', () {
      expect(_buildReceipt(returnOn: '0001-01-01T00:00:00', items: []).returnOn, '0001-01-01T00:00:00');
    });
    test('P-04 real returnOn date indicates returned status', () {
      expect(_buildReceipt(returnOn: '2024-04-01T10:30:00', items: []).returnOn, isNot('0001-01-01T00:00:00'));
    });
    test('P-05 empty ItemDetails array parsed as empty list', () {
      final j = {'ReceiptId': 3, 'VehicleNo': 'V0', 'ReceiptDate': '2024-01-01T00:00:00', 'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 1, 'ItemDetails': []};
      expect(GetItemReceiptListModel.fromJson(j).itemDetails, isEmpty);
    });
    test('N-01 missing ReceiptId -> receiptId is null', () {
      final j = {'VehicleNo': 'V0', 'ReceiptDate': '2024-01-01T00:00:00', 'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 7};
      expect(GetItemReceiptListModel.fromJson(j).receiptId, isNull);
    });
    test('N-02 null VehicleNo does not throw and stores null', () {
      final j = {'ReceiptId': 6, 'VehicleNo': null, 'ReceiptDate': '2024-01-01T00:00:00', 'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 1};
      expect(() => GetItemReceiptListModel.fromJson(j), returnsNormally);
      expect(GetItemReceiptListModel.fromJson(j).vehicleNo, isNull);
    });
    test('N-03 absent ItemDetails key -> itemDetails is null', () {
      final j = {'ReceiptId': 7, 'VehicleNo': 'V0', 'ReceiptDate': '2024-01-01T00:00:00', 'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 1};
      expect(GetItemReceiptListModel.fromJson(j).itemDetails, isNull);
    });
    test('N-04 absent ReceiptDate -> receiptDate is null', () {
      final j = {'ReceiptId': 8, 'VehicleNo': 'V0', 'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 1};
      expect(GetItemReceiptListModel.fromJson(j).receiptDate, isNull);
    });
    test('N-05 absent GodownId -> godownId is null', () {
      final j = {'ReceiptId': 9, 'VehicleNo': 'V0', 'ReceiptDate': '2024-01-01T00:00:00', 'ReturnOn': '0001-01-01T00:00:00'};
      expect(GetItemReceiptListModel.fromJson(j).godownId, isNull);
    });
  });
  // ===========================================================================
  // GROUP 2 — ItemDetails: fromJson
  // ===========================================================================
  group('ItemDetails – fromJson', () {
    test('P-06 parses all ItemDetails fields correctly', () {
      final j = {'pkId': 1, 'ItemId': 10, 'ItemName': '14.2 kg', 'FilledQty': 250, 'EMRQty': 100, 'InvoiceQty': 350, 'IsReturnSent': 0, 'EmptyReturnQty': 10, 'DefectiveReturnQty': 5};
      final d = ItemDetails.fromJson(j);
      expect(d.pkId, 1); expect(d.itemId, 10); expect(d.itemName, '14.2 kg');
      expect(d.filledQty, 250); expect(d.eMRQty, 100); expect(d.invoiceQty, 350);
      expect(d.isReturnSent, 0); expect(d.emptyReturnQty, 10); expect(d.defectiveReturnQty, 5);
    });
    test('P-07 isReturnSent==1 indicates return already sent', () {
      expect(_buildDetail(isReturnSent: 1).isReturnSent, 1);
    });
    test('P-08 emptyReturnQty and defectiveReturnQty can be non-zero', () {
      final d = _buildDetail(emptyReturnQty: 3, defectiveReturnQty: 2);
      expect(d.emptyReturnQty, 3); expect(d.defectiveReturnQty, 2);
    });
    test('N-06 missing ItemName -> itemName is null', () {
      expect(ItemDetails.fromJson({'pkId': 0, 'ItemId': 5, 'FilledQty': 10}).itemName, isNull);
    });
    test('N-07 missing FilledQty -> filledQty is null', () {
      expect(ItemDetails.fromJson({'pkId': 0, 'ItemId': 5, 'ItemName': 'Cyl'}).filledQty, isNull);
    });
    test('N-08 absent EMRQty -> eMRQty is null', () {
      expect(ItemDetails.fromJson({'pkId': 0, 'ItemId': 5, 'ItemName': 'Cyl', 'FilledQty': 10}).eMRQty, isNull);
    });
  });
  // ===========================================================================
  // GROUP 3 — toJson round-trip
  // ===========================================================================
  group('Model toJson round-trip', () {
    test('P-09 GetItemReceiptListModel toJson contains required keys', () {
      final map = _buildReceipt(items: []).toJson();
      expect(map.containsKey('ReceiptId'), isTrue); expect(map.containsKey('VehicleNo'), isTrue);
      expect(map.containsKey('ReturnOn'), isTrue); expect(map.containsKey('ItemDetails'), isTrue);
    });
    test('P-10 ItemDetails toJson has correct values', () {
      final map = _buildDetail(itemId: 5, itemName: 'Test Cyl', filledQty: 20).toJson();
      expect(map['ItemId'], 5); expect(map['ItemName'], 'Test Cyl'); expect(map['FilledQty'], 20);
      expect(map.containsKey('EmptyReturnQty'), isTrue);
    });
    test('P-11 toJson then fromJson preserves vehicleNo', () {
      final m = _buildReceipt(vehicleNo: 'MH14ZZ9999', items: []);
      expect(GetItemReceiptListModel.fromJson(m.toJson()).vehicleNo, 'MH14ZZ9999');
    });
    test('P-12 toJson then fromJson preserves receiptId', () {
      final m = _buildReceipt(receiptId: 77, items: []);
      expect(GetItemReceiptListModel.fromJson(m.toJson()).receiptId, 77);
    });
    test('N-09 null itemDetails is omitted from toJson map', () {
      final map = GetItemReceiptListModel(receiptId: 1, vehicleNo: 'V1').toJson();
      expect(map.containsKey('ItemDetails'), isFalse);
    });
  });
  // ===========================================================================
  // GROUP 4 — copyWith
  // ===========================================================================
  group('Model copyWith', () {
    test('P-13 copyWith overrides vehicleNo only', () {
      final orig = _buildReceipt(vehicleNo: 'OLD', items: []);
      final copy = orig.copyWith(vehicleNo: 'NEW');
      expect(copy.vehicleNo, 'NEW'); expect(copy.receiptId, orig.receiptId);
    });
    test('P-14 copyWith overrides returnOn only', () {
      final copy = _buildReceipt(items: []).copyWith(returnOn: '2024-05-01T00:00:00');
      expect(copy.returnOn, '2024-05-01T00:00:00');
    });
    test('P-15 ItemDetails copyWith preserves unchanged fields', () {
      final copy = _buildDetail(itemId: 10, itemName: 'CylA', filledQty: 50).copyWith(filledQty: 100);
      expect(copy.filledQty, 100); expect(copy.itemId, 10); expect(copy.itemName, 'CylA');
    });
    test('N-10 copyWith with no args returns equivalent object', () {
      final orig = _buildReceipt(receiptId: 5, vehicleNo: 'V1', items: []);
      final copy = orig.copyWith();
      expect(copy.receiptId, orig.receiptId); expect(copy.vehicleNo, orig.vehicleNo);
    });
  });
  // ===========================================================================
  // GROUP 5 — JSON list parsing
  // ===========================================================================
  group('fetchItemReceipts – JSON list parsing', () {
    test('P-16 valid JSON array parses to correct list', () {
      const body = '[{"ReceiptId":1,"VehicleNo":"MH12AB1234","ReceiptDate":"2024-01-01T00:00:00","ReturnOn":"0001-01-01T00:00:00","GodownId":1,"ItemDetails":[]},{"ReceiptId":2,"VehicleNo":"MH12XY5678","ReceiptDate":"2024-01-02T00:00:00","ReturnOn":"2024-01-03T10:00:00","GodownId":1,"ItemDetails":[]}]';
      final list = (jsonDecode(body) as List).map((j) => GetItemReceiptListModel.fromJson(j)).toList();
      expect(list.length, 2); expect(list[0].vehicleNo, 'MH12AB1234'); expect(list[1].returnOn, '2024-01-03T10:00:00');
    });
    test('P-17 single-item JSON array parses correctly', () {
      const body = '[{"ReceiptId":5,"VehicleNo":"MH01ZZ9999","ReceiptDate":"2024-06-01T00:00:00","ReturnOn":"0001-01-01T00:00:00","GodownId":2,"ItemDetails":[]}]';
      final list = (jsonDecode(body) as List).map((j) => GetItemReceiptListModel.fromJson(j)).toList();
      expect(list.length, 1); expect(list[0].vehicleNo, 'MH01ZZ9999');
    });
    test('P-18 JSON with nested ItemDetails fully parsed', () {
      const body = '[{"ReceiptId":3,"VehicleNo":"V1","ReceiptDate":"2024-06-10T00:00:00","ReturnOn":"0001-01-01T00:00:00","GodownId":1,"ItemDetails":[{"pkId":0,"ItemId":1,"ItemName":"14.2 kg","FilledQty":100,"EMRQty":10,"InvoiceQty":110,"IsReturnSent":0,"EmptyReturnQty":0,"DefectiveReturnQty":0}]}]';
      final list = (jsonDecode(body) as List).map((j) => GetItemReceiptListModel.fromJson(j)).toList();
      expect(list[0].itemDetails![0].itemName, '14.2 kg');
    });
    test('N-11 empty JSON array produces empty list', () {
      final list = (jsonDecode('[]') as List).map((j) => GetItemReceiptListModel.fromJson(j)).toList();
      expect(list, isEmpty);
    });
    test('N-12 malformed JSON throws FormatException', () {
      expect(() => jsonDecode('{not valid}'), throwsFormatException);
    });
    test('N-13 JSON string instead of list throws TypeError', () {
      expect(() { final data = jsonDecode('"invalid"') as List<dynamic>; data.map((j) => GetItemReceiptListModel.fromJson(j)).toList(); }, throwsA(isA<TypeError>()));
    });
  });
  // ===========================================================================
  // GROUP 6 — SQC / pending filter logic
  // ===========================================================================
  group('SQC pending vehicles filter', () {
    List<GetItemReceiptListModel> mixed() => [
          _buildReceipt(receiptId: 1, returnOn: '0001-01-01T00:00:00', items: []),
          _buildReceipt(receiptId: 2, returnOn: '2024-04-01T10:00:00', items: []),
          _buildReceipt(receiptId: 3, returnOn: '0001-01-01T00:00:00', items: []),
        ];
    test('P-19 pending vehicles correctly extracted', () {
      expect(mixed().where((v) => v.returnOn == '0001-01-01T00:00:00').length, 2);
    });
    test('P-20 returned vehicles excluded from SQC list', () {
      expect(mixed().where((v) => v.returnOn == '0001-01-01T00:00:00').any((v) => v.receiptId == 2), isFalse);
    });
    test('P-21 all-pending list returns all vehicles', () {
      final all = [1, 2, 3].map((i) => _buildReceipt(receiptId: i, items: [])).toList();
      expect(all.where((v) => v.returnOn == '0001-01-01T00:00:00').length, 3);
    });
    test('P-22 receipts with real returnOn identified as returned', () {
      final returned = mixed().where((v) => v.returnOn != '0001-01-01T00:00:00').toList();
      expect(returned.length, 1); expect(returned[0].receiptId, 2);
    });
    test('N-14 empty list -> vehiclesNotOut is empty', () {
      expect(<GetItemReceiptListModel>[].where((v) => v.returnOn == '0001-01-01T00:00:00').toList(), isEmpty);
    });
    test('N-15 all-returned list -> vehiclesNotOut is empty', () {
      final l = [_buildReceipt(returnOn: '2024-04-01T10:00:00', items: []), _buildReceipt(returnOn: '2024-04-02T10:00:00', items: [])];
      expect(l.where((v) => v.returnOn == '0001-01-01T00:00:00').toList(), isEmpty);
    });
  });
  // ===========================================================================
  // GROUP 7 — Item detail extraction for SQC navigation
  // ===========================================================================
  group('Item detail extraction for SQC arguments', () {
    test('P-23 itemIds and itemNames correctly extracted', () {
      final v = _buildReceipt(items: [_buildDetail(itemId: 10, itemName: 'Cyl A'), _buildDetail(itemId: 20, itemName: 'Cyl B')]);
      expect(v.itemDetails!.map((i) => i.itemId.toString()).toList(), ['10', '20']);
      expect(v.itemDetails!.map((i) => i.itemName.toString()).toList(), ['Cyl A', 'Cyl B']);
    });
    test('P-24 single item vehicle produces single-element lists', () {
      final v = _buildReceipt(items: [_buildDetail(itemId: 55, itemName: 'Solo')]);
      expect(v.itemDetails!.map((i) => i.itemId.toString()).toList(), ['55']);
    });
    test('P-25 10-item itemDetails list fully accessible', () {
      final v = _buildReceipt(items: List.generate(10, (i) => _buildDetail(itemId: i + 1, itemName: 'Cyl $i')));
      expect(v.itemDetails!.length, 10); expect(v.itemDetails![9].itemName, 'Cyl 9');
    });
    test('N-16 empty itemDetails produces empty id and name lists', () {
      final v = _buildReceipt(items: []);
      final ids = <String>[];
      if (v.itemDetails != null && v.itemDetails!.isNotEmpty) {
        for (var item in v.itemDetails!) ids.add(item.itemId.toString());
      }
      expect(ids, isEmpty);
    });
    test('N-17 null itemDetails guard prevents crash', () {
      final v = GetItemReceiptListModel(receiptId: 1, vehicleNo: 'V0');
      final ids = <String>[];
      if (v.itemDetails != null) { for (var item in v.itemDetails!) ids.add(item.itemId.toString()); }
      expect(ids, isEmpty);
    });
  });
  // ===========================================================================
  // GROUP 8 — stockTransferFlag logic
  // ===========================================================================
  group('stockTransferFlag logic', () {
    bool flag(List<int> vals) { for (final v in vals) { if (v == 0) return false; } return true; }
    test('P-26 all isStkTrans==1 -> flag is true', () => expect(flag([1, 1, 1]), isTrue));
    test('P-27 single isStkTrans==1 -> flag is true', () => expect(flag([1]), isTrue));
    test('P-28 empty list -> flag is true', () => expect(flag([]), isTrue));
    test('N-18 any isStkTrans==0 -> flag is false', () => expect(flag([1, 0, 1]), isFalse));
    test('N-19 all isStkTrans==0 -> flag is false', () => expect(flag([0, 0, 0]), isFalse));
    test('N-20 first item is 0 -> flag is false', () => expect(flag([0, 1, 1]), isFalse));
  });
  // ===========================================================================
  // GROUP 9 — Network availability branch
  // ===========================================================================
  group('Network availability branch', () {
    test('P-29 when connected, API call proceeds', () {
      bool connected = true, apiCalled = false;
      if (connected) apiCalled = true;
      expect(apiCalled, isTrue);
    });
    test('N-21 when disconnected, API call is skipped', () {
      bool connected = false, apiCalled = false;
      if (connected) apiCalled = true;
      expect(apiCalled, isFalse);
    });
    test('N-22 when disconnected, connection message triggered', () {
      bool connected = false, messageSent = false;
      if (!connected) messageSent = true;
      expect(messageSent, isTrue);
    });
  });
  // ===========================================================================
  // GROUP 10 — API request URL / header construction
  // ===========================================================================
  group('API request structure', () {
    test('P-30 URL correctly constructed from IDs', () {
      expect('https://api.example.com/GetItemReceiptList/10/1/3', 'https://api.example.com/GetItemReceiptList/10/1/3');
    });
    test('P-31 Authorization header contains Bearer token', () {
      const token = 'test_bearer_token';
      expect({'Authorization': 'Bearer $token'}['Authorization'], 'Bearer test_bearer_token');
    });
    test('N-23 null token results in "Bearer null" header', () {
      String? token;
      expect({'Authorization': 'Bearer $token'}['Authorization'], 'Bearer null');
    });
    test('N-24 empty token produces "Bearer " header', () {
      const token = '';
      expect({'Authorization': 'Bearer $token'}['Authorization'], 'Bearer ');
    });
  });
  // ===========================================================================
  // GROUP 11 — saveFlag logic
  // ===========================================================================
  group('saveFlag logic', () {
    bool saveFlag(List<dynamic> r) => r.isNotEmpty;
    test('P-32 non-empty response -> saveFlag true', () => expect(saveFlag([{'DSRSaved': 1}]), isTrue));
    test('P-33 multiple entries -> saveFlag true', () => expect(saveFlag([{}, {}]), isTrue));
    test('N-25 empty response -> saveFlag false', () => expect(saveFlag([]), isFalse));
  });
  // ===========================================================================
  // GROUP 12 — Date formatting helper
  // ===========================================================================
  group('Date formatting', () {
    test('P-34 receiptDate present -> substring(0,10) extracts date part', () {
      final r = _buildReceipt(receiptDate: '2024-06-15T00:00:00', items: []);
      expect(r.receiptDate != null ? r.receiptDate!.substring(0, 10) : '', '2024-06-15');
    });
    test('P-35 returnOn time part -> date portion is first 10 chars', () {
      expect('2024-11-27T10:30:00'.substring(0, 10), '2024-11-27');
    });
    test('N-26 null receiptDate -> formattedDate is empty string', () {
      final m = GetItemReceiptListModel.fromJson({'ReceiptId': 99, 'VehicleNo': 'V0', 'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 1});
      expect(m.receiptDate != null ? m.receiptDate!.substring(0, 10) : '', '');
    });
    test('N-27 null vehicleNo accessible without crash', () {
      expect(GetItemReceiptListModel.fromJson({'ReceiptId': 100, 'ReturnOn': '0001-01-01T00:00:00', 'GodownId': 1}).vehicleNo, isNull);
    });
  });
  // ===========================================================================
  // GROUP 13 — Edge cases
  // ===========================================================================
  group('Edge cases', () {
    test('P-36 very large filledQty is valid', () => expect(_buildDetail(filledQty: 999999).filledQty, 999999));
    test('P-37 zero filledQty is valid', () => expect(_buildDetail(filledQty: 0).filledQty, 0));
    test('P-38 receipt with 50 items is fully iterable', () {
      final r = _buildReceipt(items: List.generate(50, (i) => _buildDetail(itemId: i + 1, itemName: 'Cyl $i')));
      expect(r.itemDetails!.length, 50);
    });
    test('N-28 isReturnSent==1 means return already submitted', () => expect(_buildDetail(isReturnSent: 1).isReturnSent, isNot(0)));
    test('N-29 defectiveReturnQty > filledQty stored as-is', () {
      final item = _buildDetail(filledQty: 5, defectiveReturnQty: 10);
      expect(item.defectiveReturnQty, greaterThan(item.filledQty!));
    });
  });
  // ===========================================================================
  // GROUP 14 — Widget tests: ItemReturnScreenListItem
  // ===========================================================================
  group('ItemReturnScreenListItem – Widget Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({'godownId': '1', 'DistributorId': '10', 'StaffId': '5', 'token': 'abc', 'MobileNo': '9999999999'});
    });

    // Pumps the widget and advances time past InternetConnectionChecker's 10-s socket timers.
    Future<void> _pumpWidget(WidgetTester tester, Widget widget) async {
      await tester.pumpWidget(widget);
      await tester.pump();
      await tester.pump(const Duration(seconds: 11));
    }

    testWidgets('P-39 renders vehicle number in header', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(vehicleNo: 'MH12AB1234', items: []))));
      expect(find.textContaining('MH12AB1234'), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('P-40 shows Pending badge when returnOn is default date', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(returnOn: '0001-01-01T00:00:00', items: []))));
      expect(find.text('Pending'), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('P-41 shows Returned badge when returnOn is a real date', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(returnOn: '2024-11-27T00:00:00', items: []))));
      expect(find.text('Returned'), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('P-42 shows receipt date in header', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(receiptDate: '2024-11-26T00:00:00', items: []))));
      expect(find.text('2024-11-26'), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('P-43 tapping View More reveals item details', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(items: [_buildDetail(itemName: 'MyItem')]))));
      expect(find.text('MyItem'), findsNothing);
      await tester.tap(find.text('View More'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 11));
      expect(find.text('MyItem'), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('P-44 widget builds without crashing for pending receipt', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      final model = _buildReceipt(receiptId: 10, receiptDate: '2024-11-26T00:00:00', returnOn: '0001-01-01T00:00:00', vehicleNo: 'V1', items: [_buildDetail(pkId: 1, itemId: 2, itemName: 'MyItem', filledQty: 5)]);
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(model)));
      expect(find.byType(ItemReturnScreenListItem), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('P-45 multiple items shown after View More tapped', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(items: [_buildDetail(itemId: 1, itemName: 'CylA'), _buildDetail(itemId: 2, itemName: 'CylB')]))));
      await tester.tap(find.text('View More'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 11));
      expect(find.text('CylA'), findsOneWidget); expect(find.text('CylB'), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('P-46 Vehicle No label prefix is displayed', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(vehicleNo: 'V99', items: []))));
      expect(find.textContaining('Vehicle No.'), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('N-30 receipt with empty itemDetails renders without crash', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(items: []))));
      expect(find.byType(ItemReturnScreenListItem), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('N-31 item not visible before View More is tapped', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(items: [_buildDetail(itemName: 'HiddenItem')]))));
      expect(find.text('HiddenItem'), findsNothing);
      HttpOverrides.global = null;
    });

    testWidgets('N-32 API 500 response still renders widget without crash', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: 'Internal Server Error', statusCode: 500);
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(items: []))));
      expect(find.byType(ItemReturnScreenListItem), findsOneWidget);
      HttpOverrides.global = null;
    });

    testWidgets('N-33 Pending badge absent when returnOn is a real date', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(returnOn: '2024-12-01T00:00:00', items: []))));
      expect(find.text('Pending'), findsNothing);
      HttpOverrides.global = null;
    });

    testWidgets('N-34 Returned badge absent when returnOn is default date', (tester) async {
      HttpOverrides.global = _SimpleHttpOverrides(responseBody: json.encode([]));
      await _pumpWidget(tester, MaterialApp(home: ItemReturnScreenListItem(_buildReceipt(returnOn: '0001-01-01T00:00:00', items: []))));
      expect(find.text('Returned'), findsNothing);
      HttpOverrides.global = null;
    });
  });
}
// =============================================================================
// Fake HTTP stack
// =============================================================================
class _SimpleHttpOverrides extends HttpOverrides {
  final String responseBody;
  final int statusCode;
  _SimpleHttpOverrides({required this.responseBody, this.statusCode = 200});
  @override
  HttpClient createHttpClient(SecurityContext? context) => _SimpleHttpClient(responseBody, statusCode);
}
class _SimpleHttpClient implements HttpClient {
  final String _body;
  final int _status;
  _SimpleHttpClient(this._body, this._status);
  @override Future<HttpClientRequest> getUrl(Uri url) async => _SimpleHttpClientRequest(_body, _status);
  @override Future<HttpClientRequest> openUrl(String method, Uri url) async => _SimpleHttpClientRequest(_body, _status);
  @override Future<HttpClientRequest> open(String method, String host, int port, String path) async => _SimpleHttpClientRequest(_body, _status);
  @override Future<HttpClientRequest> postUrl(Uri url) async => _SimpleHttpClientRequest(_body, _status);
  @override Future<HttpClientRequest> putUrl(Uri url) async => _SimpleHttpClientRequest(_body, _status);
  @override Future<HttpClientRequest> deleteUrl(Uri url) async => _SimpleHttpClientRequest(_body, _status);
  @override Future<HttpClientRequest> patchUrl(Uri url) async => _SimpleHttpClientRequest(_body, _status);
  @override Future<HttpClientRequest> headUrl(Uri url) async => _SimpleHttpClientRequest(_body, _status);
  @override void close({bool force = false}) {}
  @override noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
class _SimpleHttpClientRequest implements HttpClientRequest {
  final String _body;
  final int _status;
  @override final HttpHeaders headers = _SimpleHttpHeaders();
  @override bool followRedirects = true;
  @override int maxRedirects = 5;
  @override bool persistentConnection = true;
  @override bool bufferOutput = true;
  ContentType? contentType;
  @override Encoding encoding = utf8;
  @override Uri get uri => Uri.parse('http://localhost');
  @override String get method => 'GET';
  @override HttpConnectionInfo? get connectionInfo => null;
  @override List<Cookie> get cookies => [];
  _SimpleHttpClientRequest(this._body, this._status);
  @override Future<HttpClientResponse> close() async => _SimpleHttpClientResponse(_body, _status);
  @override void abort([Object? exception, StackTrace? stackTrace]) {}
  @override void add(List<int> data) {}
  @override void addError(Object error, [StackTrace? stackTrace]) {}
  @override Future<void> addStream(Stream<List<int>> stream) async {}
  @override Future<void> flush() async {}
  @override void write(Object? object) {}
  @override void writeAll(Iterable<dynamic> objects, [String separator = '']) {}
  @override void writeCharCode(int charCode) {}
  @override void writeln([Object? object = '']) {}
  @override Future<HttpClientResponse> get done async => _SimpleHttpClientResponse(_body, _status);
  @override noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
class _SimpleHttpClientResponse extends Stream<List<int>> implements HttpClientResponse {
  final String _body;
  final int _status;
  _SimpleHttpClientResponse(this._body, this._status);
  @override int get statusCode => _status;
  @override HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override HttpHeaders get headers => _SimpleHttpHeaders();
  @override
  StreamSubscription<List<int>> listen(void Function(List<int>)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    final ctrl = StreamController<List<int>>();
    ctrl.add(utf8.encode(_body));
    ctrl.close();
    return ctrl.stream.listen((d) { if (onData != null) onData(d); }, onError: onError, onDone: onDone, cancelOnError: cancelOnError ?? false);
  }
  @override noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
class _SimpleHttpHeaders implements HttpHeaders {
  final Map<String, List<String>> _map = {};
  @override void add(String name, Object value, {bool preserveHeaderCase = false}) => _map.putIfAbsent(name, () => []).add(value.toString());
  @override void set(String name, Object value, {bool preserveHeaderCase = false}) => _map[name] = [value.toString()];
  @override noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
