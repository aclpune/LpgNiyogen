class DenomModel {
  int? id;
  int? noteType;
  int? quantity;
  int? totalAmt;
  int? retNoteQty;
  int? retNoteAmt;

  DenomModel({
    this.id,
    this.noteType,
    this.quantity,
    this.totalAmt,
    this.retNoteQty,
    this.retNoteAmt,
  });

  factory DenomModel.fromJson(Map<String, dynamic> json) {
    return DenomModel(
      id: json['Id'],
      noteType: json['NoteType'],
      quantity: json['Quantity'],
      totalAmt: json['TotalAmt'],
      retNoteQty: json['RetNoteQty'],
      retNoteAmt: json['RetNoteAmt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'NoteType': noteType,
      'Quantity': quantity,
      'TotalAmt': totalAmt,
      'RetNoteQty': retNoteQty,
      'RetNoteAmt': retNoteAmt,
    };
  }
}
