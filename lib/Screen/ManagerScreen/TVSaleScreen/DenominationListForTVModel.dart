/// TVId : 2
/// DistributorId : 8118
/// NoteId : 1
/// NoteType : 500.00
/// Qty : 2
/// Amount : 1000.00
/// RetNoteQty : 0
/// RetNoteAmt : 0.00
/// totalAmount : 1500
/// totalAmountminus : 0

class DenominationListForTvModel {
  DenominationListForTvModel({
      num? tVId, 
      num? distributorId, 
      num? noteId, 
      num? noteType, 
      num? qty, 
      num? amount, 
      num? retNoteQty, 
      num? retNoteAmt, 
      num? totalAmount, 
      num? totalAmountminus,}){
    _tVId = tVId;
    _distributorId = distributorId;
    _noteId = noteId;
    _noteType = noteType;
    _qty = qty;
    _amount = amount;
    _retNoteQty = retNoteQty;
    _retNoteAmt = retNoteAmt;
    _totalAmount = totalAmount;
    _totalAmountminus = totalAmountminus;
}

  DenominationListForTvModel.fromJson(dynamic json) {
    _tVId = json['TVId'];
    _distributorId = json['DistributorId'];
    _noteId = json['NoteId'];
    _noteType = json['NoteType'];
    _qty = json['Qty'];
    _amount = json['Amount'];
    _retNoteQty = json['RetNoteQty'];
    _retNoteAmt = json['RetNoteAmt'];
    _totalAmount = json['totalAmount'];
    _totalAmountminus = json['totalAmountminus'];
  }
  num? _tVId;
  num? _distributorId;
  num? _noteId;
  num? _noteType;
  num? _qty;
  num? _amount;
  num? _retNoteQty;
  num? _retNoteAmt;
  num? _totalAmount;
  num? _totalAmountminus;
DenominationListForTvModel copyWith({  num? tVId,
  num? distributorId,
  num? noteId,
  num? noteType,
  num? qty,
  num? amount,
  num? retNoteQty,
  num? retNoteAmt,
  num? totalAmount,
  num? totalAmountminus,
}) => DenominationListForTvModel(  tVId: tVId ?? _tVId,
  distributorId: distributorId ?? _distributorId,
  noteId: noteId ?? _noteId,
  noteType: noteType ?? _noteType,
  qty: qty ?? _qty,
  amount: amount ?? _amount,
  retNoteQty: retNoteQty ?? _retNoteQty,
  retNoteAmt: retNoteAmt ?? _retNoteAmt,
  totalAmount: totalAmount ?? _totalAmount,
  totalAmountminus: totalAmountminus ?? _totalAmountminus,
);
  num? get tVId => _tVId;
  num? get distributorId => _distributorId;
  num? get noteId => _noteId;
  num? get noteType => _noteType;
  num? get qty => _qty;
  num? get amount => _amount;
  num? get retNoteQty => _retNoteQty;
  num? get retNoteAmt => _retNoteAmt;
  num? get totalAmount => _totalAmount;
  num? get totalAmountminus => _totalAmountminus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TVId'] = _tVId;
    map['DistributorId'] = _distributorId;
    map['NoteId'] = _noteId;
    map['NoteType'] = _noteType;
    map['Qty'] = _qty;
    map['Amount'] = _amount;
    map['RetNoteQty'] = _retNoteQty;
    map['RetNoteAmt'] = _retNoteAmt;
    map['totalAmount'] = _totalAmount;
    map['totalAmountminus'] = _totalAmountminus;
    return map;
  }

}