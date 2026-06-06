/// StaffId : 48
/// DistributorId : 0
/// BalanceAmt : 0
/// DebitAmt : 1000
/// CreditAmt : 0
/// TransDate : null

class GetBalanceByStaffIdModel {
  GetBalanceByStaffIdModel({
      num? staffId, 
      num? distributorId, 
      num? balanceAmt, 
      num? debitAmt, 
      num? creditAmt, 
      dynamic transDate,}){
    _staffId = staffId;
    _distributorId = distributorId;
    _balanceAmt = balanceAmt;
    _debitAmt = debitAmt;
    _creditAmt = creditAmt;
    _transDate = transDate;
}

  GetBalanceByStaffIdModel.fromJson(dynamic json) {
    _staffId = json['StaffId'];
    _distributorId = json['DistributorId'];
    _balanceAmt = json['BalanceAmt'];
    _debitAmt = json['DebitAmt'];
    _creditAmt = json['CreditAmt'];
    _transDate = json['TransDate'];
  }
  num? _staffId;
  num? _distributorId;
  num? _balanceAmt;
  num? _debitAmt;
  num? _creditAmt;
  dynamic _transDate;
GetBalanceByStaffIdModel copyWith({  num? staffId,
  num? distributorId,
  num? balanceAmt,
  num? debitAmt,
  num? creditAmt,
  dynamic transDate,
}) => GetBalanceByStaffIdModel(  staffId: staffId ?? _staffId,
  distributorId: distributorId ?? _distributorId,
  balanceAmt: balanceAmt ?? _balanceAmt,
  debitAmt: debitAmt ?? _debitAmt,
  creditAmt: creditAmt ?? _creditAmt,
  transDate: transDate ?? _transDate,
);
  num? get staffId => _staffId;
  num? get distributorId => _distributorId;
  num? get balanceAmt => _balanceAmt;
  num? get debitAmt => _debitAmt;
  num? get creditAmt => _creditAmt;
  dynamic get transDate => _transDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StaffId'] = _staffId;
    map['DistributorId'] = _distributorId;
    map['BalanceAmt'] = _balanceAmt;
    map['DebitAmt'] = _debitAmt;
    map['CreditAmt'] = _creditAmt;
    map['TransDate'] = _transDate;
    return map;
  }

}