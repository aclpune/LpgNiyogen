import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/DenomModel.dart';

void main() {
  group('DenomModel', () {
    final sampleJson = {
      'Id': 1,
      'NoteType': 500.0,
      'Quantity': 16,
      'TotalAmt': 8000.0,
      'RetNoteQty': 0,
      'RetNoteAmt': 0.0,
    };

    test('constructor sets all fields correctly', () {
      final model = DenomModel(
        id: 1,
        noteType: 500.0,
        quantity: 16,
        totalAmt: 8000.0,
        retNoteQty: 0,
        retNoteAmt: 0.0,
      );
      expect(model.id, 1);
      expect(model.noteType, 500.0);
      expect(model.quantity, 16);
      expect(model.totalAmt, 8000.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
    });

    test('fromJson parses all fields correctly', () {
      final model = DenomModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.noteType, 500.0);
      expect(model.quantity, 16);
      expect(model.totalAmt, 8000.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
    });

    test('toJson returns correct map', () {
      final model = DenomModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['Id'], 1);
      expect(json['NoteType'], 500.0);
      expect(json['Quantity'], 16);
      expect(json['TotalAmt'], 8000.0);
      expect(json['RetNoteQty'], 0);
      expect(json['RetNoteAmt'], 0.0);
    });

    test('toJson includes all keys', () {
      final model = DenomModel.fromJson(sampleJson);
      final json = model.toJson();
      for (final key in ['Id','NoteType','Quantity','TotalAmt','RetNoteQty','RetNoteAmt']) {
        expect(json.containsKey(key), isTrue, reason: 'Missing key: $key');
      }
    });

    test('default constructor with null values', () {
      final model = DenomModel();
      expect(model.id, isNull);
      expect(model.noteType, isNull);
      expect(model.quantity, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = DenomModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = DenomModel.fromJson(json);
      expect(model2.id, model.id);
      expect(model2.noteType, model.noteType);
      expect(model2.quantity, model.quantity);
      expect(model2.totalAmt, model.totalAmt);
    });

    test('totalAmt equals noteType * quantity', () {
      final model = DenomModel.fromJson(sampleJson);
      expect(model.totalAmt, model.noteType! * model.quantity!);
    });
  });
}

