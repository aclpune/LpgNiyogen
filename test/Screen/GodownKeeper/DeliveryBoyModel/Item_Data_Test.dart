import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/DeliveryBoyModel/ItemData.dart';

void main() {
  group('ItemData', () {
	final validJson = {
	  'date': '2025-05-15',
	  'deliveryBoyName': 'Delivery Boy',
	  'delBoyId': 'DB001',
	  'vehicleNo': 'MH12AB1234',
	  'itemName': '2 Kg',
	  'itemID': '4',
	  'filled': '20',
	  'sv': '1',
	  'tv': '1',
	  'empty': '18',
	  'defective': '0',
	  'lessEmpty': '1',
	  'remark': 'ok',
	  'svRemark': 'sv ok',
	  'svCount': '1',
	  'tvConsumerNo': '675',
	  'tvCount': '1',
	  'updateFlag': '0',
	  'itemAddedDate': '2025-05-15T10:00:00',
	  'SVUniqueID': 123, // numeric -> should be converted to string
	  'lessEmptyCustomer': 456,
	  'lessEmptyDMCount': 2,
	  'lessEmptyCustomerCount': 3,
	  'lessEmptyCustomerId': 789,
	};

	test('fromJson with valid complete map assigns fields correctly', () {
	  final item = ItemData.fromJson(validJson);

	  expect(item.date, '2025-05-15');
	  expect(item.deliveryBoyName, 'Delivery Boy');
	  expect(item.delBoyId, 'DB001');
	  expect(item.vehicleNo, 'MH12AB1234');
	  expect(item.itemName, '2 Kg');
	  expect(item.itemID, '4');
	  expect(item.filled, '20');
	  expect(item.sv, '1');
	  expect(item.tv, '1');
	  expect(item.empty, '18');
	  expect(item.defective, '0');
	  expect(item.lessEmpty, '1');
	  expect(item.remark, 'ok');
	  expect(item.svRemark, 'sv ok');
	  expect(item.svCount, '1');
	  expect(item.tvConsumerNo, '675');
	  expect(item.tvCount, '1');
	  expect(item.updateFlag, '0');
	  expect(item.itemAddedDate, '2025-05-15T10:00:00');

	  // Fields that are converted with toString() or defaulted to empty string
	  expect(item.sVUniqueId, '123');
	  expect(item.lessEmptyCustomer, '456');
	  expect(item.lessEmptyDMCount, '2');
	  expect(item.lessEmptyCustomerCount, '3');
	  expect(item.lessEmptyCustomerId, '789');
	});

	test('toMap returns a map with expected keys and values', () {
	  final item = ItemData.fromJson(validJson);
	  final map = item.toMap();

	  expect(map['date'], '2025-05-15');
	  expect(map['deliveryBoyName'], 'Delivery Boy');
	  expect(map['itemName'], '2 Kg');
	  expect(map['itemID'], '4');
	  expect(map['sVUniqueId'], '123'); // note: key name differs from input
	  expect(map['lessEmptyCustomer'], '456');
	  expect(map['lessEmptyDMCount'], '2');
	  expect(map['lessEmptyCustomerCount'], '3');
	  expect(map['lessEmptyCustomerId'], '789');
	});

	test('fromJson converts missing optional numeric fields to empty string', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json.remove('SVUniqueID');
	  json.remove('lessEmptyCustomer');
	  json.remove('lessEmptyDMCount');
	  json.remove('lessEmptyCustomerCount');
	  json.remove('lessEmptyCustomerId');

	  final item = ItemData.fromJson(json);
	  expect(item.sVUniqueId, '');
	  expect(item.lessEmptyCustomer, '');
	  expect(item.lessEmptyDMCount, '');
	  expect(item.lessEmptyCustomerCount, '');
	  expect(item.lessEmptyCustomerId, '');
	});

	test('fromJson throws when required string fields are missing', () {
	  final json = <String, dynamic>{}; // empty map
	  expect(() => ItemData.fromJson(json), throwsA(isA<TypeError>()));
	});

	test('fromJson throws when required fields are null', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['date'] = null;
	  expect(() => ItemData.fromJson(json), throwsA(isA<TypeError>()));
	});

	test('fromJson throws when types mismatch for required string fields', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['itemName'] = 100; // int instead of string
	  expect(() => ItemData.fromJson(json), throwsA(isA<TypeError>()));
	});

	test('fromJson accepts numeric strings and returns them unchanged', () {
	  final json = Map<String, dynamic>.from(validJson);
	  json['SVUniqueID'] = '999';
	  final item = ItemData.fromJson(json);
	  expect(item.sVUniqueId, '999');
	});

	test('toMap followed by ItemData.fromJson roundtrip for sVUniqueId keys', () {
	  final item = ItemData.fromJson(validJson);
	  final map = item.toMap();
	  // toMap uses lowercase 'sVUniqueId' key; simulate reading from DB by mapping back
	  final dbMap = Map<String, dynamic>.from(map);
	  // Convert back to the original input key name expected by factory
	  dbMap['SVUniqueID'] = dbMap['sVUniqueId'];
	  final item2 = ItemData.fromJson(dbMap);
	  expect(item2.sVUniqueId, item.sVUniqueId);
	});
  });
}


