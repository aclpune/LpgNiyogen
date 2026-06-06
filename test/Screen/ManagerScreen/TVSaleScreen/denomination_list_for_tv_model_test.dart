import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/TVSaleScreen/DenominationListForTVModel.dart';

void main() {
  group('DenominationListForTvModel', () {
    final sampleJson = {
      'TVId': 2,
      'DistributorId': 8118,
      'NoteId': 1,
      'NoteType': 500.0,
      'Qty': 2,
      'Amount': 1000.0,
      'RetNoteQty': 0,
      'RetNoteAmt': 0.0,
      'totalAmount': 1500,
      'totalAmountminus': 0,
    };

    test('constructor sets all fields correctly', () {
      final model = DenominationListForTvModel(
        tVId: 2,
        distributorId: 8118,
        noteId: 1,
        noteType: 500.0,
        qty: 2,
        amount: 1000.0,
        retNoteQty: 0,
        retNoteAmt: 0.0,
        totalAmount: 1500,
        totalAmountminus: 0,
      );

      expect(model.tVId, 2);
      expect(model.distributorId, 8118);
      expect(model.noteId, 1);
      expect(model.noteType, 500.0);
      expect(model.qty, 2);
      expect(model.amount, 1000.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
      expect(model.totalAmount, 1500);
      expect(model.totalAmountminus, 0);
    });

    test('fromJson parses all fields correctly', () {
      final model = DenominationListForTvModel.fromJson(sampleJson);

      expect(model.tVId, 2);
      expect(model.distributorId, 8118);
      expect(model.noteId, 1);
      expect(model.noteType, 500.0);
      expect(model.qty, 2);
      expect(model.amount, 1000.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
      expect(model.totalAmount, 1500);
      expect(model.totalAmountminus, 0);
    });

    test('toJson returns correct map', () {
      final model = DenominationListForTvModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['TVId'], 2);
      expect(json['DistributorId'], 8118);
      expect(json['NoteId'], 1);
      expect(json['NoteType'], 500.0);
      expect(json['Qty'], 2);
      expect(json['Amount'], 1000.0);
      expect(json['RetNoteQty'], 0);
      expect(json['RetNoteAmt'], 0.0);
      expect(json['totalAmount'], 1500);
      expect(json['totalAmountminus'], 0);
    });

    test('copyWith updates specified fields', () {
      final model = DenominationListForTvModel.fromJson(sampleJson);
      final updated = model.copyWith(qty: 5, amount: 2500.0, totalAmount: 2500);

      expect(updated.qty, 5);
      expect(updated.amount, 2500.0);
      expect(updated.totalAmount, 2500);
      expect(model.qty, 2);
      expect(model.amount, 1000.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = DenominationListForTvModel.fromJson(sampleJson);
      final updated = model.copyWith(noteType: 200.0);

      expect(updated.tVId, model.tVId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.totalAmountminus, model.totalAmountminus);
    });

    test('constructor with null values', () {
      final model = DenominationListForTvModel();
      expect(model.tVId, isNull);
      expect(model.noteType, isNull);
      expect(model.qty, isNull);
    });
  });
}

