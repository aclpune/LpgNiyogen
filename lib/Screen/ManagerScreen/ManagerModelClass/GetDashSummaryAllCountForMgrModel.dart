/// DistributorId : 8118
/// DMCount : 3
/// TotalAmount : 31450.00
/// TotalIncome : 0.00
/// TotalExp : 0.00
/// StaffOnAccToday : 0.00
/// StaffOnAccAsOf : 120261.00
/// PostPaidVerifPend : 377
/// SVPendingStk : 149
/// TVPendingStk : 12
/// PostPaidVerifPendAmt : 3386703.00
/// UndocumentedSV : 78
/// TotalCrdtOutstd : 44088453.00
/// TotalVendorDueAmt : 145249.00

class GetDashSummaryAllCountForMgrModel {
  GetDashSummaryAllCountForMgrModel({
      num? distributorId, 
      num? dMCount, 
      num? totalAmount, 
      num? totalIncome, 
      num? totalExp, 
      num? staffOnAccToday, 
      num? staffOnAccAsOf, 
      num? postPaidVerifPend, 
      num? sVPendingStk, 
      num? tVPendingStk, 
      num? postPaidVerifPendAmt, 
      num? undocumentedSV, 
      num? totalCrdtOutstd, 
      num? totalVendorDueAmt,}){
    _distributorId = distributorId;
    _dMCount = dMCount;
    _totalAmount = totalAmount;
    _totalIncome = totalIncome;
    _totalExp = totalExp;
    _staffOnAccToday = staffOnAccToday;
    _staffOnAccAsOf = staffOnAccAsOf;
    _postPaidVerifPend = postPaidVerifPend;
    _sVPendingStk = sVPendingStk;
    _tVPendingStk = tVPendingStk;
    _postPaidVerifPendAmt = postPaidVerifPendAmt;
    _undocumentedSV = undocumentedSV;
    _totalCrdtOutstd = totalCrdtOutstd;
    _totalVendorDueAmt = totalVendorDueAmt;
}

  GetDashSummaryAllCountForMgrModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _dMCount = json['DMCount'];
    _totalAmount = json['TotalAmount'];
    _totalIncome = json['TotalIncome'];
    _totalExp = json['TotalExp'];
    _staffOnAccToday = json['StaffOnAccToday'];
    _staffOnAccAsOf = json['StaffOnAccAsOf'];
    _postPaidVerifPend = json['PostPaidVerifPend'];
    _sVPendingStk = json['SVPendingStk'];
    _tVPendingStk = json['TVPendingStk'];
    _postPaidVerifPendAmt = json['PostPaidVerifPendAmt'];
    _undocumentedSV = json['UndocumentedSV'];
    _totalCrdtOutstd = json['TotalCrdtOutstd'];
    _totalVendorDueAmt = json['TotalVendorDueAmt'];
  }
  num? _distributorId;
  num? _dMCount;
  num? _totalAmount;
  num? _totalIncome;
  num? _totalExp;
  num? _staffOnAccToday;
  num? _staffOnAccAsOf;
  num? _postPaidVerifPend;
  num? _sVPendingStk;
  num? _tVPendingStk;
  num? _postPaidVerifPendAmt;
  num? _undocumentedSV;
  num? _totalCrdtOutstd;
  num? _totalVendorDueAmt;
GetDashSummaryAllCountForMgrModel copyWith({  num? distributorId,
  num? dMCount,
  num? totalAmount,
  num? totalIncome,
  num? totalExp,
  num? staffOnAccToday,
  num? staffOnAccAsOf,
  num? postPaidVerifPend,
  num? sVPendingStk,
  num? tVPendingStk,
  num? postPaidVerifPendAmt,
  num? undocumentedSV,
  num? totalCrdtOutstd,
  num? totalVendorDueAmt,
}) => GetDashSummaryAllCountForMgrModel(  distributorId: distributorId ?? _distributorId,
  dMCount: dMCount ?? _dMCount,
  totalAmount: totalAmount ?? _totalAmount,
  totalIncome: totalIncome ?? _totalIncome,
  totalExp: totalExp ?? _totalExp,
  staffOnAccToday: staffOnAccToday ?? _staffOnAccToday,
  staffOnAccAsOf: staffOnAccAsOf ?? _staffOnAccAsOf,
  postPaidVerifPend: postPaidVerifPend ?? _postPaidVerifPend,
  sVPendingStk: sVPendingStk ?? _sVPendingStk,
  tVPendingStk: tVPendingStk ?? _tVPendingStk,
  postPaidVerifPendAmt: postPaidVerifPendAmt ?? _postPaidVerifPendAmt,
  undocumentedSV: undocumentedSV ?? _undocumentedSV,
  totalCrdtOutstd: totalCrdtOutstd ?? _totalCrdtOutstd,
  totalVendorDueAmt: totalVendorDueAmt ?? _totalVendorDueAmt,
);
  num? get distributorId => _distributorId;
  num? get dMCount => _dMCount;
  num? get totalAmount => _totalAmount;
  num? get totalIncome => _totalIncome;
  num? get totalExp => _totalExp;
  num? get staffOnAccToday => _staffOnAccToday;
  num? get staffOnAccAsOf => _staffOnAccAsOf;
  num? get postPaidVerifPend => _postPaidVerifPend;
  num? get sVPendingStk => _sVPendingStk;
  num? get tVPendingStk => _tVPendingStk;
  num? get postPaidVerifPendAmt => _postPaidVerifPendAmt;
  num? get undocumentedSV => _undocumentedSV;
  num? get totalCrdtOutstd => _totalCrdtOutstd;
  num? get totalVendorDueAmt => _totalVendorDueAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['DMCount'] = _dMCount;
    map['TotalAmount'] = _totalAmount;
    map['TotalIncome'] = _totalIncome;
    map['TotalExp'] = _totalExp;
    map['StaffOnAccToday'] = _staffOnAccToday;
    map['StaffOnAccAsOf'] = _staffOnAccAsOf;
    map['PostPaidVerifPend'] = _postPaidVerifPend;
    map['SVPendingStk'] = _sVPendingStk;
    map['TVPendingStk'] = _tVPendingStk;
    map['PostPaidVerifPendAmt'] = _postPaidVerifPendAmt;
    map['UndocumentedSV'] = _undocumentedSV;
    map['TotalCrdtOutstd'] = _totalCrdtOutstd;
    map['TotalVendorDueAmt'] = _totalVendorDueAmt;
    return map;
  }

}