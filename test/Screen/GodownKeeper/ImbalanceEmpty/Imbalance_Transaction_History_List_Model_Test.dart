import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ImbalanceEmpty/ImbalanceTransactionHistoryListModel.dart';

void main() {
  group('ImbalanceTransactionHistoryListModel', () {
	final validJson = {
	  'ImbId': 77,
	  'DistributorId': 8118,
	  'GodownId': 20,
	  'ImbDate': '2026-04-16T00:00:00',
	  'ItemId': 1,
	  'EntryType': 'D',
	  'ConsDMId': 35,
	  'ImbRecQty': 1,
	  'AddedBy': 0,
	  'Action': null,
	  'StaffName': 'Punam singh Rathor',
	  'CustomerName': null,
	  'ItemName': null,
	};

	test('fromJson assigns all fields correctly', () {
	  final model = ImbalanceTransactionHistoryListModel.fromJson(validJson);

	  expect(model.imbId, equals(77));
	  expect(model.distributorId, equals(8118));
	  expect(model.godownId, equals(20));
	  expect(model.imbDate, equals('2026-04-16T00:00:00'));
	  expect(model.itemId, equals(1));
	  expect(model.entryType, equals('D'));
	  expect(model.consDMId, equals(35));
	  expect(model.imbRecQty, equals(1));
	  expect(model.addedBy, equals(0));
	  expect(model.action, isNull);
	  expect(model.staffName, equals('Punam singh Rathor'));
	  expect(model.customerName, isNull);
	  expect(model.itemName, isNull);
	});

	test('toJson outputs correct map', () {
	  final model = ImbalanceTransactionHistoryListModel.fromJson(validJson);
	  final json = model.toJson();

	  expect(json['ImbId'], equals(77));
	  expect(json['DistributorId'], equals(8118));
	  expect(json['GodownId'], equals(20));
	  expect(json['ImbDate'], equals('2026-04-16T00:00:00'));
	  expect(json['ItemId'], equals(1));
	  expect(json['EntryType'], equals('D'));
	  expect(json['ConsDMId'], equals(35));
	  expect(json['ImbRecQty'], equals(1));
	  expect(json['AddedBy'], equals(0));
	  expect(json['Action'], isNull);
	  expect(json['StaffName'], equals('Punam singh Rathor'));
	});

	test('copyWith overrides and preserves fields', () {
	  final model = ImbalanceTransactionHistoryListModel.fromJson(validJson);
	  final copy = model.copyWith(imbId: 88, imbRecQty: 5, staffName: 'New Staff');

	  expect(copy.imbId, equals(88));
	  expect(copy.imbRecQty, equals(5));
	  expect(copy.staffName, equals('New Staff'));

	  // preserved
	  expect(copy.distributorId, equals(model.distributorId));
	  expect(copy.godownId, equals(model.godownId));
	});

	test('fromJson with missing keys results in null fields', () {
	  final model = ImbalanceTransactionHistoryListModel.fromJson({});
	  expect(model.imbId, isNull);
	  expect(model.distributorId, isNull);
	  expect(model.godownId, isNull);
	  expect(model.imbDate, isNull);
	  expect(model.itemId, isNull);
	});

	test('fromJson with null values preserves nulls', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['ImbRecQty'] = null;
	  json['StaffName'] = null;

	  final model = ImbalanceTransactionHistoryListModel.fromJson(json);
	  expect(model.imbRecQty, isNull);
	  expect(model.staffName, isNull);
	});

	test('fromJson throws TypeError for wrong numeric types', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['ImbRecQty'] = 'not-a-number';
	  json['ConsDMId'] = 'also-not-number';

	  expect(() => ImbalanceTransactionHistoryListModel.fromJson(json), throwsA(isA<TypeError>()));
	});

	test('fromJson with numeric strings may succeed or throw depending on runtime', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['ImbRecQty'] = '10';

	  try {
		final model = ImbalanceTransactionHistoryListModel.fromJson(json);
		expect(model.imbRecQty == 10 || model.imbRecQty == '10', isTrue);
	  } catch (e) {
		expect(e, isA<TypeError>());
	  }
	});

	test('toJson includes all keys when constructed with default constructor', () {
	  final model = ImbalanceTransactionHistoryListModel();
	  final json = model.toJson();

	  expect(json.containsKey('ImbId'), isTrue);
	  expect(json.containsKey('DistributorId'), isTrue);
	  expect(json.containsKey('GodownId'), isTrue);
	  expect(json.containsKey('ImbDate'), isTrue);
	  expect(json.containsKey('ItemId'), isTrue);
	  expect(json.containsKey('EntryType'), isTrue);
	});
  });
}


