import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/SVSaleModel/GetDenominationListForAddEdit.dart';

void main() {
  group('GetDenominationListForAddEdit', () {
    final sampleJson = {
      'SalaryEntryId': 0,
      'PSVId': 0,
      'ARBSalesId': 0,
      'ARBPurId': 0,
      'DistributorId': 0,
      'NoteId': 1,
      'NoteType': 500.0,
      'Qty': 2,
      'Amount': 1000.0,
      'RetNoteQty': 0,
      'RetNoteAmt': 0.0,
      'totalAmount': 1000.0,
      'totalAmountminus': 0.0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetDenominationListForAddEdit(
        salaryEntryId: 0,
        pSVId: 0,
        aRBSalesId: 0,
        aRBPurId: 0,
        distributorId: 0,
        noteId: 1,
        noteType: 500.0,
        qty: 2,
        amount: 1000.0,
        retNoteQty: 0,
        retNoteAmt: 0.0,
        totalAmount: 1000.0,
        totalAmountminus: 0.0,
      );

      expect(model.salaryEntryId, 0);
      expect(model.pSVId, 0);
      expect(model.aRBSalesId, 0);
      expect(model.aRBPurId, 0);
      expect(model.distributorId, 0);
      expect(model.noteId, 1);
      expect(model.noteType, 500.0);
      expect(model.qty, 2);
      expect(model.amount, 1000.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
      expect(model.totalAmount, 1000.0);
      expect(model.totalAmountminus, 0.0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetDenominationListForAddEdit.fromJson(sampleJson);

      expect(model.salaryEntryId, 0);
      expect(model.pSVId, 0);
      expect(model.aRBSalesId, 0);
      expect(model.aRBPurId, 0);
      expect(model.distributorId, 0);
      expect(model.noteId, 1);
      expect(model.noteType, 500.0);
      expect(model.qty, 2);
      expect(model.amount, 1000.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
      expect(model.totalAmount, 1000.0);
      expect(model.totalAmountminus, 0.0);
    });

    test('toJson returns correct map', () {
      final model = GetDenominationListForAddEdit.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['SalaryEntryId'], 0);
      expect(json['NoteId'], 1);
      expect(json['NoteType'], 500.0);
      expect(json['Qty'], 2);
      expect(json['Amount'], 1000.0);
      expect(json['RetNoteQty'], 0);
      expect(json['RetNoteAmt'], 0.0);
      expect(json['totalAmount'], 1000.0);
      expect(json['totalAmountminus'], 0.0);
    });

    test('copyWith updates specified fields', () {
      final model = GetDenominationListForAddEdit.fromJson(sampleJson);
      final updated = model.copyWith(qty: 5, amount: 2500.0);

      expect(updated.qty, 5);
      expect(updated.amount, 2500.0);
      expect(model.qty, 2);
      expect(model.amount, 1000.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetDenominationListForAddEdit.fromJson(sampleJson);
      final updated = model.copyWith(noteType: 100.0);

      expect(updated.noteId, model.noteId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.totalAmount, model.totalAmount);
    });

    test('constructor with null values', () {
      final model = GetDenominationListForAddEdit();
      expect(model.noteId, isNull);
      expect(model.noteType, isNull);
      expect(model.qty, isNull);
      expect(model.amount, isNull);
    });
  });
}

