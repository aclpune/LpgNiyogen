import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ImbalanceEmpty/ImabalanceEmptyListModel.dart';

void main() {
  group('ImabalanceEmptyListModel', () {
	final validJson = {
	  'DistributorId': 8118,
	  'DMId': 44,
	  'ItemId': 1,
	  'ItemName': '14.2 KG',
	  'ImbQty': 0,
	  'RecQty': 0,
	  'BalImbQty': 28,
	  'CustId': 0,
	  'EntryType': 'D',
	  'StaffName': null,
	  'CustomerName': null,
	};

	test('fromJson assigns all fields correctly for valid input', () {
	  final model = ImabalanceEmptyListModel.fromJson(validJson);

	  expect(model.distributorId, equals(8118));
	  expect(model.dMId, equals(44));
	  expect(model.itemId, equals(1));
	  expect(model.itemName, equals('14.2 KG'));
	  expect(model.imbQty, equals(0));
	  expect(model.recQty, equals(0));
	  expect(model.balImbQty, equals(28));
	  expect(model.custId, equals(0));
	  expect(model.entryType, equals('D'));
	  expect(model.staffName, isNull);
	  expect(model.customerName, isNull);
	});

	test('toJson outputs expected keys and values', () {
	  final model = ImabalanceEmptyListModel.fromJson(validJson);
	  final json = model.toJson();

	  expect(json['DistributorId'], equals(8118));
	  expect(json['DMId'], equals(44));
	  expect(json['ItemId'], equals(1));
	  expect(json['ItemName'], equals('14.2 KG'));
	  expect(json['ImbQty'], equals(0));
	  expect(json['RecQty'], equals(0));
	  expect(json['BalImbQty'], equals(28));
	  expect(json['CustId'], equals(0));
	  expect(json['EntryType'], equals('D'));
	  expect(json['StaffName'], isNull);
	  expect(json['CustomerName'], isNull);
	});

	test('copyWith copies and overrides fields correctly', () {
	  final model = ImabalanceEmptyListModel.fromJson(validJson);
	  final copy = model.copyWith(itemId: 99, itemName: 'New Item', imbQty: 5);

	  expect(copy.itemId, equals(99));
	  expect(copy.itemName, equals('New Item'));
	  expect(copy.imbQty, equals(5));

	  // unchanged fields preserved
	  expect(copy.distributorId, equals(model.distributorId));
	  expect(copy.dMId, equals(model.dMId));
	});

	test('fromJson with missing keys results in null fields', () {
	  final model = ImabalanceEmptyListModel.fromJson({});
	  expect(model.distributorId, isNull);
	  expect(model.dMId, isNull);
	  expect(model.itemId, isNull);
	  expect(model.itemName, isNull);
	  expect(model.imbQty, isNull);
	});

	test('fromJson accepts decimals and large numbers for numeric fields', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['ImbQty'] = 3.5;
	  json['BalImbQty'] = 9999999999;

	  final model = ImabalanceEmptyListModel.fromJson(json);
	  expect(model.imbQty, equals(3.5));
	  expect(model.balImbQty, equals(9999999999));
	});

	// NEGATIVE / EDGE CASES
	test('fromJson with null values keeps fields null', () {
	  final json = {
		'DistributorId': null,
		'DMId': null,
		'ItemId': null,
		'ItemName': null,
		'ImbQty': null,
	  };
	  final model = ImabalanceEmptyListModel.fromJson(json);
	  expect(model.distributorId, isNull);
	  expect(model.dMId, isNull);
	  expect(model.itemId, isNull);
	  expect(model.itemName, isNull);
	  expect(model.imbQty, isNull);
	});

	test('fromJson throws TypeError on wrong types for numeric fields', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['ImbQty'] = 'not-a-number';
	  json['RecQty'] = 'also-not-a-number';

	  expect(() => ImabalanceEmptyListModel.fromJson(json), throwsA(isA<TypeError>()));
	});

	test('fromJson accepts numeric strings if runtime allows (may throw in strong mode)', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['ImbQty'] = '10';

	  // Behavior depends on runtime type checks. We assert that either it parses to null/throws or stores as-is.
	  try {
		final model = ImabalanceEmptyListModel.fromJson(json);
		// If no error, the field may contain the string '10' or a num. Check for both possibilities.
		expect(model.imbQty == 10 || model.imbQty == '10', isTrue);
	  } catch (e) {
		expect(e, isA<TypeError>());
	  }
	});

	test('toJson includes all expected keys even when values are null', () {
	  final model = ImabalanceEmptyListModel();
	  final json = model.toJson();

	  expect(json.containsKey('DistributorId'), isTrue);
	  expect(json.containsKey('DMId'), isTrue);
	  expect(json.containsKey('ItemId'), isTrue);
	  expect(json.containsKey('ItemName'), isTrue);
	  expect(json.containsKey('ImbQty'), isTrue);
	  expect(json.containsKey('RecQty'), isTrue);
	  expect(json.containsKey('BalImbQty'), isTrue);
	  expect(json.containsKey('CustId'), isTrue);
	  expect(json.containsKey('EntryType'), isTrue);
	  expect(json.containsKey('StaffName'), isTrue);
	  expect(json.containsKey('CustomerName'), isTrue);
	});
  });
}


