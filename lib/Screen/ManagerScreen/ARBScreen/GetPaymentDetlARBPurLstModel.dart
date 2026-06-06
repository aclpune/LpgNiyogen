/// PaymentId : 756
/// ARBPurId : 35
/// DistributorId : 8118
/// PaymentDate : "2025-06-25T00:00:00"
/// PaymentMode : "Cash"
/// TotalAmtPaid : 500.00
/// ExpHeadId : 6
/// ExpHeadName : "Office/Godown repairs"
/// TransationCode : ""
/// TransTime : ""
/// TransRemark : ""
/// DayEnd : 0
/// BankId : 0
/// BankMappingId : 0
/// BankName : null
/// AccountNo : null

class GetPaymentDetlArbPurLstModel {
  GetPaymentDetlArbPurLstModel({
      num? paymentId, 
      num? aRBPurId, 
      num? distributorId, 
      String? paymentDate, 
      String? paymentMode, 
      num? totalAmtPaid, 
      num? expHeadId, 
      String? expHeadName, 
      String? transationCode, 
      String? transTime, 
      String? transRemark, 
      num? dayEnd, 
      num? bankId, 
      num? bankMappingId, 
      dynamic bankName, 
      dynamic accountNo,}){
    _paymentId = paymentId;
    _aRBPurId = aRBPurId;
    _distributorId = distributorId;
    _paymentDate = paymentDate;
    _paymentMode = paymentMode;
    _totalAmtPaid = totalAmtPaid;
    _expHeadId = expHeadId;
    _expHeadName = expHeadName;
    _transationCode = transationCode;
    _transTime = transTime;
    _transRemark = transRemark;
    _dayEnd = dayEnd;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
    _bankName = bankName;
    _accountNo = accountNo;
}

  GetPaymentDetlArbPurLstModel.fromJson(dynamic json) {
    _paymentId = json['PaymentId'];
    _aRBPurId = json['ARBPurId'];
    _distributorId = json['DistributorId'];
    _paymentDate = json['PaymentDate'];
    _paymentMode = json['PaymentMode'];
    _totalAmtPaid = json['TotalAmtPaid'];
    _expHeadId = json['ExpHeadId'];
    _expHeadName = json['ExpHeadName'];
    _transationCode = json['TransationCode'];
    _transTime = json['TransTime'];
    _transRemark = json['TransRemark'];
    _dayEnd = json['DayEnd'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
    _bankName = json['BankName'];
    _accountNo = json['AccountNo'];
  }
  num? _paymentId;
  num? _aRBPurId;
  num? _distributorId;
  String? _paymentDate;
  String? _paymentMode;
  num? _totalAmtPaid;
  num? _expHeadId;
  String? _expHeadName;
  String? _transationCode;
  String? _transTime;
  String? _transRemark;
  num? _dayEnd;
  num? _bankId;
  num? _bankMappingId;
  dynamic _bankName;
  dynamic _accountNo;
GetPaymentDetlArbPurLstModel copyWith({  num? paymentId,
  num? aRBPurId,
  num? distributorId,
  String? paymentDate,
  String? paymentMode,
  num? totalAmtPaid,
  num? expHeadId,
  String? expHeadName,
  String? transationCode,
  String? transTime,
  String? transRemark,
  num? dayEnd,
  num? bankId,
  num? bankMappingId,
  dynamic bankName,
  dynamic accountNo,
}) => GetPaymentDetlArbPurLstModel(  paymentId: paymentId ?? _paymentId,
  aRBPurId: aRBPurId ?? _aRBPurId,
  distributorId: distributorId ?? _distributorId,
  paymentDate: paymentDate ?? _paymentDate,
  paymentMode: paymentMode ?? _paymentMode,
  totalAmtPaid: totalAmtPaid ?? _totalAmtPaid,
  expHeadId: expHeadId ?? _expHeadId,
  expHeadName: expHeadName ?? _expHeadName,
  transationCode: transationCode ?? _transationCode,
  transTime: transTime ?? _transTime,
  transRemark: transRemark ?? _transRemark,
  dayEnd: dayEnd ?? _dayEnd,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
  bankName: bankName ?? _bankName,
  accountNo: accountNo ?? _accountNo,
);
  num? get paymentId => _paymentId;
  num? get aRBPurId => _aRBPurId;
  num? get distributorId => _distributorId;
  String? get paymentDate => _paymentDate;
  String? get paymentMode => _paymentMode;
  num? get totalAmtPaid => _totalAmtPaid;
  num? get expHeadId => _expHeadId;
  String? get expHeadName => _expHeadName;
  String? get transationCode => _transationCode;
  String? get transTime => _transTime;
  String? get transRemark => _transRemark;
  num? get dayEnd => _dayEnd;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;
  dynamic get bankName => _bankName;
  dynamic get accountNo => _accountNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PaymentId'] = _paymentId;
    map['ARBPurId'] = _aRBPurId;
    map['DistributorId'] = _distributorId;
    map['PaymentDate'] = _paymentDate;
    map['PaymentMode'] = _paymentMode;
    map['TotalAmtPaid'] = _totalAmtPaid;
    map['ExpHeadId'] = _expHeadId;
    map['ExpHeadName'] = _expHeadName;
    map['TransationCode'] = _transationCode;
    map['TransTime'] = _transTime;
    map['TransRemark'] = _transRemark;
    map['DayEnd'] = _dayEnd;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    map['BankName'] = _bankName;
    map['AccountNo'] = _accountNo;
    return map;
  }

}