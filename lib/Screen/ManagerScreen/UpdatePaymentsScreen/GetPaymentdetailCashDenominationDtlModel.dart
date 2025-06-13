/// PaymentId : 708
/// DistributorId : 8118
/// NoteId : 1
/// NoteType : 500.00
/// Qty : 20
/// Amount : 10000.00
/// RetNoteQty : 0
/// RetNoteAmt : 0.00
/// totalAmount : 20000
/// totalAmountminus : 0

class GetPaymentdetailCashDenominationDtlModel {
  GetPaymentdetailCashDenominationDtlModel({
      num? paymentId, 
      num? distributorId, 
      num? noteId, 
      num? noteType, 
      num? qty, 
      num? amount, 
      num? retNoteQty, 
      num? retNoteAmt, 
      num? totalAmount, 
      num? totalAmountminus,}){
    _paymentId = paymentId;
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

  GetPaymentdetailCashDenominationDtlModel.fromJson(dynamic json) {
    _paymentId = json['PaymentId'];
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
  num? _paymentId;
  num? _distributorId;
  num? _noteId;
  num? _noteType;
  num? _qty;
  num? _amount;
  num? _retNoteQty;
  num? _retNoteAmt;
  num? _totalAmount;
  num? _totalAmountminus;
GetPaymentdetailCashDenominationDtlModel copyWith({  num? paymentId,
  num? distributorId,
  num? noteId,
  num? noteType,
  num? qty,
  num? amount,
  num? retNoteQty,
  num? retNoteAmt,
  num? totalAmount,
  num? totalAmountminus,
}) => GetPaymentdetailCashDenominationDtlModel(  paymentId: paymentId ?? _paymentId,
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
  num? get paymentId => _paymentId;
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
    map['PaymentId'] = _paymentId;
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