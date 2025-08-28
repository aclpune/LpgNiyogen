/// LedgerId : 73
/// DistributorId : 8118
/// FromDate : null
/// ToDate : null
/// StaffId : 48
/// TransDate : "2025-04-22T00:00:00"
/// Description : "On Account"
/// StaffName : "Anopa"
/// DebitAmt : 22098.50
/// CreditAmt : 5198.50
/// Balance : 16900.00
/// Flag : null

class GetStaffLedgerReportModelList {
  GetStaffLedgerReportModelList({
      num? ledgerId, 
      num? distributorId, 
      dynamic fromDate, 
      dynamic toDate, 
      num? staffId, 
      String? transDate, 
      String? description, 
      String? staffName, 
      num? debitAmt, 
      num? creditAmt, 
      num? balance, 
      dynamic flag,}){
    _ledgerId = ledgerId;
    _distributorId = distributorId;
    _fromDate = fromDate;
    _toDate = toDate;
    _staffId = staffId;
    _transDate = transDate;
    _description = description;
    _staffName = staffName;
    _debitAmt = debitAmt;
    _creditAmt = creditAmt;
    _balance = balance;
    _flag = flag;
}

  GetStaffLedgerReportModelList.fromJson(dynamic json) {
    _ledgerId = json['LedgerId'];
    _distributorId = json['DistributorId'];
    _fromDate = json['FromDate'];
    _toDate = json['ToDate'];
    _staffId = json['StaffId'];
    _transDate = json['TransDate'];
    _description = json['Description'];
    _staffName = json['StaffName'];
    _debitAmt = json['DebitAmt'];
    _creditAmt = json['CreditAmt'];
    _balance = json['Balance'];
    _flag = json['Flag'];
  }
  num? _ledgerId;
  num? _distributorId;
  dynamic _fromDate;
  dynamic _toDate;
  num? _staffId;
  String? _transDate;
  String? _description;
  String? _staffName;
  num? _debitAmt;
  num? _creditAmt;
  num? _balance;
  dynamic _flag;
GetStaffLedgerReportModelList copyWith({  num? ledgerId,
  num? distributorId,
  dynamic fromDate,
  dynamic toDate,
  num? staffId,
  String? transDate,
  String? description,
  String? staffName,
  num? debitAmt,
  num? creditAmt,
  num? balance,
  dynamic flag,
}) => GetStaffLedgerReportModelList(  ledgerId: ledgerId ?? _ledgerId,
  distributorId: distributorId ?? _distributorId,
  fromDate: fromDate ?? _fromDate,
  toDate: toDate ?? _toDate,
  staffId: staffId ?? _staffId,
  transDate: transDate ?? _transDate,
  description: description ?? _description,
  staffName: staffName ?? _staffName,
  debitAmt: debitAmt ?? _debitAmt,
  creditAmt: creditAmt ?? _creditAmt,
  balance: balance ?? _balance,
  flag: flag ?? _flag,
);
  num? get ledgerId => _ledgerId;
  num? get distributorId => _distributorId;
  dynamic get fromDate => _fromDate;
  dynamic get toDate => _toDate;
  num? get staffId => _staffId;
  String? get transDate => _transDate;
  String? get description => _description;
  String? get staffName => _staffName;
  num? get debitAmt => _debitAmt;
  num? get creditAmt => _creditAmt;
  num? get balance => _balance;
  dynamic get flag => _flag;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['LedgerId'] = _ledgerId;
    map['DistributorId'] = _distributorId;
    map['FromDate'] = _fromDate;
    map['ToDate'] = _toDate;
    map['StaffId'] = _staffId;
    map['TransDate'] = _transDate;
    map['Description'] = _description;
    map['StaffName'] = _staffName;
    map['DebitAmt'] = _debitAmt;
    map['CreditAmt'] = _creditAmt;
    map['Balance'] = _balance;
    map['Flag'] = _flag;
    return map;
  }

}