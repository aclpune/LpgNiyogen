import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/GodownKeeper/ItemReceipt/ItemReturnXMI/model/GetEXMIListModel.dart';

void main() {
  group('ItemDetails', () {
    test('fromJson and toJson roundtrip', () {
      final json = {
        'pkId': 1,
        'ItemId': 2,
        'ItemName': '19 kg',
        'FilledQty': 5,
        'EXMIQty': 110,
        'EmptyReturnQty': 20,
        'EmptyEMR': 10,
      };

      final item = ItemDetails.fromJson(json);

      expect(item.pkId, 1);
      expect(item.itemId, 2);
      expect(item.itemName, '19 kg');
      expect(item.filledQty, 5);
      expect(item.eXMIQty, 110);
      expect(item.emptyReturnQty, 20);
      expect(item.emptyEMR, 10);

      final encoded = item.toJson();
      expect(encoded, json);
    });

    test('copyWith overrides provided fields only', () {
      final original = ItemDetails(
        pkId: 1,
        itemId: 2,
        itemName: '19 kg',
        filledQty: 5,
        eXMIQty: 110,
        emptyReturnQty: 20,
        emptyEMR: 10,
      );

      final copy = original.copyWith(itemName: '21 kg', emptyEMR: 0);

      expect(copy.pkId, original.pkId);
      expect(copy.itemId, original.itemId);
      expect(copy.itemName, '21 kg');
      expect(copy.filledQty, original.filledQty);
      expect(copy.eXMIQty, original.eXMIQty);
      expect(copy.emptyReturnQty, original.emptyReturnQty);
      expect(copy.emptyEMR, 0);
    });
  });

  group('GetExmiListModel', () {
    test('fromJson parses nested ItemDetails and toJson roundtrip', () {
      final json = {
        'pkId': 0,
        'ReturnId': 1,
        'DistributorId': 0,
        'GodownId': 1,
        'GodownKeeperId': 61,
        'ReturnDate': '2025-03-12T00:00:00',
        'ReceiptOn': '0001-01-01T00:00:00',
        'IsReceipt': 0,
        'VehicleNo': 'Fhyk98',
        'ItemId': 0,
        'ItemName': null,
        'FilledQty': 0,
        'EMRQty': 0,
        'InvoiceQty': 0,
        'ItemDetails': [
          {
            'pkId': 0,
            'ItemId': 2,
            'ItemName': '19 kg',
            'FilledQty': 0,
            'EXMIQty': 110,
            'EmptyReturnQty': 20,
            'EmptyEMR': 10
          }
        ],
        'AddedBy': 61,
        'Action': null,
      };

      final model = GetExmiListModel.fromJson(json);

      expect(model.pkId, 0);
      expect(model.returnId, 1);
      expect(model.vehicleNo, 'Fhyk98');
      expect(model.itemDetails, isNotNull);
      expect(model.itemDetails!.length, 1);
      final item = model.itemDetails!.first;
      expect(item.itemName, '19 kg');
      expect(item.eXMIQty, 110);

      final encoded = model.toJson();
      // toJson should produce values equivalent to input JSON for the known fields
      expect(encoded['ReturnId'], json['ReturnId']);
      expect(encoded['VehicleNo'], json['VehicleNo']);
      expect(encoded['ItemDetails'], isA<List>());
      expect((encoded['ItemDetails'] as List).first['ItemName'], '19 kg');
    });

    test('copyWith overrides only specified fields', () {
      final original = GetExmiListModel(
        pkId: 1,
        returnId: 2,
        vehicleNo: 'ABC123',
        addedBy: 5,
      );

      final copy = original.copyWith(vehicleNo: 'XYZ999', addedBy: 10);

      expect(copy.pkId, original.pkId);
      expect(copy.returnId, original.returnId);
      expect(copy.vehicleNo, 'XYZ999');
      expect(copy.addedBy, 10);
    });
  });
}

