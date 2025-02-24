/// Date : "0001-01-01T00:00:00"
/// StaffId : 0
/// PaymentId : 0
/// DistributorId : 0
/// NoteId : 1
/// NoteType : 500.00
/// Qty : 0
/// Amount : 0.00
/// RetNoteQty : 0
/// RetNoteAmt : 0.0
/// totalAmount : 0.0
/// totalAmountminus : 0.0

class ManagerDsrReportCashDeniminationModel {
  ManagerDsrReportCashDeniminationModel({
      String? date, 
      num? staffId, 
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
    _date = date;
    _staffId = staffId;
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

  ManagerDsrReportCashDeniminationModel.fromJson(dynamic json) {
    _date = json['Date'];
    _staffId = json['StaffId'];
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
  String? _date;
  num? _staffId;
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
ManagerDsrReportCashDeniminationModel copyWith({  String? date,
  num? staffId,
  num? paymentId,
  num? distributorId,
  num? noteId,
  num? noteType,
  num? qty,
  num? amount,
  num? retNoteQty,
  num? retNoteAmt,
  num? totalAmount,
  num? totalAmountminus,
}) => ManagerDsrReportCashDeniminationModel(  date: date ?? _date,
  staffId: staffId ?? _staffId,
  paymentId: paymentId ?? _paymentId,
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
  String? get date => _date;
  num? get staffId => _staffId;
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
    map['Date'] = _date;
    map['StaffId'] = _staffId;
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