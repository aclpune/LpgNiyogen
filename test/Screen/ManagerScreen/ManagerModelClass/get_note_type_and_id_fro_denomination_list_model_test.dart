import 'package:flutter_test/flutter_test.dart';
import 'package:lpgsalesandinventory/Screen/ManagerScreen/ManagerModelClass/GetNoteTypeAndIDFroDenominationListModel.dart';

void main() {
  group('GetNoteTypeAndIdFroDenominationListModel', () {
    final sampleJson = {
      'Id': 1,
      'NoteType': 500,
      'isActive': 1,
    };

    test('fromJson parses all fields correctly', () {
      final model = GetNoteTypeAndIdFroDenominationListModel.fromJson(sampleJson);
      expect(model.id, 1);
      expect(model.noteType, 500);
      expect(model.isActive, 1);
    });

    test('toJson returns correct map', () {
      final model = GetNoteTypeAndIdFroDenominationListModel.fromJson(sampleJson);
      final json = model.toJson();
      expect(json['Id'], 1);
      expect(json['NoteType'], 500);
      expect(json['isActive'], 1);
    });

    test('copyWith updates specified fields', () {
      final model = GetNoteTypeAndIdFroDenominationListModel.fromJson(sampleJson);
      final updated = model.copyWith(noteType: 200, isActive: 0);
      expect(updated.noteType, 200);
      expect(updated.isActive, 0);
      expect(model.noteType, 500);
    });

    test('default constructor with null values', () {
      final model = GetNoteTypeAndIdFroDenominationListModel();
      expect(model.id, isNull);
      expect(model.noteType, isNull);
      expect(model.isActive, isNull);
    });

    test('fromJson then toJson round-trip is consistent', () {
      final model = GetNoteTypeAndIdFroDenominationListModel.fromJson(sampleJson);
      final json = model.toJson();
      final model2 = GetNoteTypeAndIdFroDenominationListModel.fromJson(json);
      expect(model2.id, model.id);
      expect(model2.noteType, model.noteType);
      expect(model2.isActive, model.isActive);
    });

    test('isActive flag correctly reflects status', () {
      final activeModel = GetNoteTypeAndIdFroDenominationListModel.fromJson(sampleJson);
      expect(activeModel.isActive, 1);

      final inactiveModel = GetNoteTypeAndIdFroDenominationListModel.fromJson({...sampleJson, 'isActive': 0});
      expect(inactiveModel.isActive, 0);
    });
  });
}

