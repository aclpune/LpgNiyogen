/// SalaryEntryId : 0
/// PSVId : 0
/// ARBSalesId : 0
/// ARBPurId : 0
/// DistributorId : 0
/// NoteId : 1
/// NoteType : 500.00
/// Qty : 0
/// Amount : 0.00
/// RetNoteQty : 0
/// RetNoteAmt : 0.00
/// totalAmount : 0.0
/// totalAmountminus : 0.0

class GetDenominationListForAddEdit {
  GetDenominationListForAddEdit({
      num? salaryEntryId, 
      num? pSVId, 
      num? aRBSalesId, 
      num? aRBPurId, 
      num? distributorId, 
      num? noteId, 
      num? noteType, 
      num? qty, 
      num? amount, 
      num? retNoteQty, 
      num? retNoteAmt, 
      num? totalAmount, 
      num? totalAmountminus,}){
    _salaryEntryId = salaryEntryId;
    _pSVId = pSVId;
    _aRBSalesId = aRBSalesId;
    _aRBPurId = aRBPurId;
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

  GetDenominationListForAddEdit.fromJson(dynamic json) {
    _salaryEntryId = json['SalaryEntryId'];
    _pSVId = json['PSVId'];
    _aRBSalesId = json['ARBSalesId'];
    _aRBPurId = json['ARBPurId'];
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
  num? _salaryEntryId;
  num? _pSVId;
  num? _aRBSalesId;
  num? _aRBPurId;
  num? _distributorId;
  num? _noteId;
  num? _noteType;
  num? _qty;
  num? _amount;
  num? _retNoteQty;
  num? _retNoteAmt;
  num? _totalAmount;
  num? _totalAmountminus;
GetDenominationListForAddEdit copyWith({  num? salaryEntryId,
  num? pSVId,
  num? aRBSalesId,
  num? aRBPurId,
  num? distributorId,
  num? noteId,
  num? noteType,
  num? qty,
  num? amount,
  num? retNoteQty,
  num? retNoteAmt,
  num? totalAmount,
  num? totalAmountminus,
}) => GetDenominationListForAddEdit(  salaryEntryId: salaryEntryId ?? _salaryEntryId,
  pSVId: pSVId ?? _pSVId,
  aRBSalesId: aRBSalesId ?? _aRBSalesId,
  aRBPurId: aRBPurId ?? _aRBPurId,
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
  num? get salaryEntryId => _salaryEntryId;
  num? get pSVId => _pSVId;
  num? get aRBSalesId => _aRBSalesId;
  num? get aRBPurId => _aRBPurId;
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
    map['SalaryEntryId'] = _salaryEntryId;
    map['PSVId'] = _pSVId;
    map['ARBSalesId'] = _aRBSalesId;
    map['ARBPurId'] = _aRBPurId;
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