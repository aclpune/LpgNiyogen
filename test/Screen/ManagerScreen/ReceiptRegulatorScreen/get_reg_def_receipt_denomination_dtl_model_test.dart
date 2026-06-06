import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ReceiptRegulatorScreen/GetRegDefReceiptDenominationDtlModel.dart';

void main() {
  group('GetRegDefReceiptDenominationDtlModel', () {
    final sampleJson = {
      'RegDefRcptId': 0,
      'DistributorId': 0,
      'NoteId': 1,
      'NoteType': 500.0,
      'Qty': 0,
      'Amount': 0.0,
      'RetNoteQty': 0,
      'RetNoteAmt': 0.0,
      'totalAmount': 0,
      'totalAmountminus': 0,
    };

    test('constructor sets all fields correctly', () {
      final model = GetRegDefReceiptDenominationDtlModel(
        regDefRcptId: 0,
        distributorId: 0,
        noteId: 1,
        noteType: 500.0,
        qty: 0,
        amount: 0.0,
        retNoteQty: 0,
        retNoteAmt: 0.0,
        totalAmount: 0,
        totalAmountminus: 0,
      );

      expect(model.regDefRcptId, 0);
      expect(model.distributorId, 0);
      expect(model.noteId, 1);
      expect(model.noteType, 500.0);
      expect(model.qty, 0);
      expect(model.amount, 0.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
      expect(model.totalAmount, 0);
      expect(model.totalAmountminus, 0);
    });

    test('fromJson parses all fields correctly', () {
      final model = GetRegDefReceiptDenominationDtlModel.fromJson(sampleJson);

      expect(model.regDefRcptId, 0);
      expect(model.distributorId, 0);
      expect(model.noteId, 1);
      expect(model.noteType, 500.0);
      expect(model.qty, 0);
      expect(model.amount, 0.0);
      expect(model.retNoteQty, 0);
      expect(model.retNoteAmt, 0.0);
      expect(model.totalAmount, 0);
      expect(model.totalAmountminus, 0);
    });

    test('toJson returns correct map', () {
      final model = GetRegDefReceiptDenominationDtlModel.fromJson(sampleJson);
      final json = model.toJson();

      expect(json['RegDefRcptId'], 0);
      expect(json['DistributorId'], 0);
      expect(json['NoteId'], 1);
      expect(json['NoteType'], 500.0);
      expect(json['Qty'], 0);
      expect(json['Amount'], 0.0);
      expect(json['RetNoteQty'], 0);
      expect(json['RetNoteAmt'], 0.0);
      expect(json['totalAmount'], 0);
      expect(json['totalAmountminus'], 0);
    });

    test('copyWith updates specified fields', () {
      final model = GetRegDefReceiptDenominationDtlModel.fromJson(sampleJson);
      final updated = model.copyWith(qty: 3, amount: 1500.0, totalAmount: 1500.0);

      expect(updated.qty, 3);
      expect(updated.amount, 1500.0);
      expect(updated.totalAmount, 1500.0);
      expect(model.qty, 0);
      expect(model.amount, 0.0);
    });

    test('copyWith preserves existing fields when not overridden', () {
      final model = GetRegDefReceiptDenominationDtlModel.fromJson(sampleJson);
      final updated = model.copyWith(noteType: 200.0);

      expect(updated.regDefRcptId, model.regDefRcptId);
      expect(updated.distributorId, model.distributorId);
      expect(updated.noteId, model.noteId);
    });

    test('constructor with null values', () {
      final model = GetRegDefReceiptDenominationDtlModel();
      expect(model.regDefRcptId, isNull);
      expect(model.noteType, isNull);
      expect(model.qty, isNull);
    });
  });
}

