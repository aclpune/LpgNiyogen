/// SalaryEntryId : 36
/// DistributorId : 8118
/// PaidDate : "2025-06-13T00:00:00"
/// StaffId : 214
/// StaffName : "Snehal"
/// PaidAgainst : "Salary"
/// PaidSalaryAmt : 100.00
/// PaymentMode : "Online"
/// BankId : 14
/// BankMappingId : 19
/// AccountNo : "7777005279799"
/// BankName : "ICICI"
/// TransactionCode : "wdftff"
/// TransactionTime : "1"
/// TransactionRemark : ""
/// Remark : ""
/// AddedBy : 0
/// Action : null
/// DenomDtList : null

class GetSalaryIncentiveEntryListModel {
  GetSalaryIncentiveEntryListModel({
      num? salaryEntryId, 
      num? distributorId, 
      String? paidDate, 
      num? staffId, 
      String? staffName, 
      String? paidAgainst, 
      num? paidSalaryAmt, 
      String? paymentMode, 
      num? bankId, 
      num? bankMappingId, 
      String? accountNo, 
      String? bankName, 
      String? transactionCode, 
      String? transactionTime, 
      String? transactionRemark, 
      String? remark, 
      num? addedBy, 
      dynamic action, 
      dynamic denomDtList,}){
    _salaryEntryId = salaryEntryId;
    _distributorId = distributorId;
    _paidDate = paidDate;
    _staffId = staffId;
    _staffName = staffName;
    _paidAgainst = paidAgainst;
    _paidSalaryAmt = paidSalaryAmt;
    _paymentMode = paymentMode;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
    _accountNo = accountNo;
    _bankName = bankName;
    _transactionCode = transactionCode;
    _transactionTime = transactionTime;
    _transactionRemark = transactionRemark;
    _remark = remark;
    _addedBy = addedBy;
    _action = action;
    _denomDtList = denomDtList;
}

  GetSalaryIncentiveEntryListModel.fromJson(dynamic json) {
    _salaryEntryId = json['SalaryEntryId'];
    _distributorId = json['DistributorId'];
    _paidDate = json['PaidDate'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _paidAgainst = json['PaidAgainst'];
    _paidSalaryAmt = json['PaidSalaryAmt'];
    _paymentMode = json['PaymentMode'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
    _accountNo = json['AccountNo'];
    _bankName = json['BankName'];
    _transactionCode = json['TransactionCode'];
    _transactionTime = json['TransactionTime'];
    _transactionRemark = json['TransactionRemark'];
    _remark = json['Remark'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
    _denomDtList = json['DenomDtList'];
  }
  num? _salaryEntryId;
  num? _distributorId;
  String? _paidDate;
  num? _staffId;
  String? _staffName;
  String? _paidAgainst;
  num? _paidSalaryAmt;
  String? _paymentMode;
  num? _bankId;
  num? _bankMappingId;
  String? _accountNo;
  String? _bankName;
  String? _transactionCode;
  String? _transactionTime;
  String? _transactionRemark;
  String? _remark;
  num? _addedBy;
  dynamic _action;
  dynamic _denomDtList;
GetSalaryIncentiveEntryListModel copyWith({  num? salaryEntryId,
  num? distributorId,
  String? paidDate,
  num? staffId,
  String? staffName,
  String? paidAgainst,
  num? paidSalaryAmt,
  String? paymentMode,
  num? bankId,
  num? bankMappingId,
  String? accountNo,
  String? bankName,
  String? transactionCode,
  String? transactionTime,
  String? transactionRemark,
  String? remark,
  num? addedBy,
  dynamic action,
  dynamic denomDtList,
}) => GetSalaryIncentiveEntryListModel(  salaryEntryId: salaryEntryId ?? _salaryEntryId,
  distributorId: distributorId ?? _distributorId,
  paidDate: paidDate ?? _paidDate,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  paidAgainst: paidAgainst ?? _paidAgainst,
  paidSalaryAmt: paidSalaryAmt ?? _paidSalaryAmt,
  paymentMode: paymentMode ?? _paymentMode,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
  accountNo: accountNo ?? _accountNo,
  bankName: bankName ?? _bankName,
  transactionCode: transactionCode ?? _transactionCode,
  transactionTime: transactionTime ?? _transactionTime,
  transactionRemark: transactionRemark ?? _transactionRemark,
  remark: remark ?? _remark,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
  denomDtList: denomDtList ?? _denomDtList,
);
  num? get salaryEntryId => _salaryEntryId;
  num? get distributorId => _distributorId;
  String? get paidDate => _paidDate;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  String? get paidAgainst => _paidAgainst;
  num? get paidSalaryAmt => _paidSalaryAmt;
  String? get paymentMode => _paymentMode;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;
  String? get accountNo => _accountNo;
  String? get bankName => _bankName;
  String? get transactionCode => _transactionCode;
  String? get transactionTime => _transactionTime;
  String? get transactionRemark => _transactionRemark;
  String? get remark => _remark;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  dynamic get denomDtList => _denomDtList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SalaryEntryId'] = _salaryEntryId;
    map['DistributorId'] = _distributorId;
    map['PaidDate'] = _paidDate;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['PaidAgainst'] = _paidAgainst;
    map['PaidSalaryAmt'] = _paidSalaryAmt;
    map['PaymentMode'] = _paymentMode;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    map['AccountNo'] = _accountNo;
    map['BankName'] = _bankName;
    map['TransactionCode'] = _transactionCode;
    map['TransactionTime'] = _transactionTime;
    map['TransactionRemark'] = _transactionRemark;
    map['Remark'] = _remark;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    map['DenomDtList'] = _denomDtList;
    return map;
  }

}