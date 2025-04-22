/// DistributorId : 8118
/// ItemId : 1
/// ItemName : "14.2 kg"
/// FilledDiff : 7348
/// EmptyDiff : 5826
/// DefectiveDiff : 374
/// TodayImbQty : 0
/// AsOfDateImbQty : 19
/// DMCount : 7
/// TotalAmount : 150982.00
/// TotalIncome : 124805.00
/// TotalExp : 5000.00
/// StaffOnAccToday : 632.00
/// StaffOnAccAsOf : 13543.10
/// cDCMSPunPend : 2318
/// NiyoJanPunPend : 6
/// PaymtDoneBtDelPend : 1098
/// DelDoneBtPaymtPend : 9
/// NiyojanPun : 0
/// NiyojanDuplicate : 0

class GetManagerDashboarDetailModel {
  GetManagerDashboarDetailModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? filledDiff, 
      num? emptyDiff, 
      num? defectiveDiff, 
      num? todayImbQty, 
      num? asOfDateImbQty, 
      num? dMCount, 
      num? totalAmount, 
      num? totalIncome, 
      num? totalExp, 
      num? staffOnAccToday, 
      num? staffOnAccAsOf, 
      num? cDCMSPunPend, 
      num? niyoJanPunPend, 
      num? paymtDoneBtDelPend, 
      num? delDoneBtPaymtPend, 
      num? niyojanPun, 
      num? niyojanDuplicate,
      num? DelDonNiyoJanPunPend,
      num? NiyoJanPunDelPend,
      num? OldBkgPendNewBkgRecv,
      num? PostPaidVerifPend,
      num? SVPendingStk,
      num? TVPendingStk,
  }){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _filledDiff = filledDiff;
    _emptyDiff = emptyDiff;
    _defectiveDiff = defectiveDiff;
    _todayImbQty = todayImbQty;
    _asOfDateImbQty = asOfDateImbQty;
    _dMCount = dMCount;
    _totalAmount = totalAmount;
    _totalIncome = totalIncome;
    _totalExp = totalExp;
    _staffOnAccToday = staffOnAccToday;
    _staffOnAccAsOf = staffOnAccAsOf;
    _cDCMSPunPend = cDCMSPunPend;
    _niyoJanPunPend = niyoJanPunPend;
    _paymtDoneBtDelPend = paymtDoneBtDelPend;
    _delDoneBtPaymtPend = delDoneBtPaymtPend;
    _niyojanPun = niyojanPun;
    _niyojanDuplicate = niyojanDuplicate;
    _DelDonNiyoJanPunPend = DelDonNiyoJanPunPend;
    _NiyoJanPunDelPend = NiyoJanPunDelPend;
    _OldBkgPendNewBkgRecv = OldBkgPendNewBkgRecv;
    _PostPaidVerifPend = PostPaidVerifPend;
    _SVPendingStk = SVPendingStk;
    _TVPendingStk = TVPendingStk;
}

  GetManagerDashboarDetailModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledDiff = json['FilledDiff'];
    _emptyDiff = json['EmptyDiff'];
    _defectiveDiff = json['DefectiveDiff'];
    _todayImbQty = json['TodayImbQty'];
    _asOfDateImbQty = json['AsOfDateImbQty'];
    _dMCount = json['DMCount'];
    _totalAmount = json['TotalAmount'];
    _totalIncome = json['TotalIncome'];
    _totalExp = json['TotalExp'];
    _staffOnAccToday = json['StaffOnAccToday'];
    _staffOnAccAsOf = json['StaffOnAccAsOf'];
    _cDCMSPunPend = json['cDCMSPunPend'];
    _niyoJanPunPend = json['NiyoJanPunPend'];
    _paymtDoneBtDelPend = json['PaymtDoneBtDelPend'];
    _delDoneBtPaymtPend = json['DelDoneBtPaymtPend'];
    _niyojanPun = json['NiyojanPun'];
    _niyojanDuplicate = json['NiyojanDuplicate'];
    _DelDonNiyoJanPunPend = json['DelDonNiyoJanPunPend'];
    _NiyoJanPunDelPend = json['NiyoJanPunDelPend'];
    _OldBkgPendNewBkgRecv = json['OldBkgPendNewBkgRecv'];
    _PostPaidVerifPend = json['PostPaidVerifPend'];
    _SVPendingStk = json['SVPendingStk'];
    _TVPendingStk = json['TVPendingStk'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _filledDiff;
  num? _emptyDiff;
  num? _defectiveDiff;
  num? _todayImbQty;
  num? _asOfDateImbQty;
  num? _dMCount;
  num? _totalAmount;
  num? _totalIncome;
  num? _totalExp;
  num? _staffOnAccToday;
  num? _staffOnAccAsOf;
  num? _cDCMSPunPend;
  num? _niyoJanPunPend;
  num? _paymtDoneBtDelPend;
  num? _delDoneBtPaymtPend;
  num? _niyojanPun;
  num? _niyojanDuplicate;
  num? _DelDonNiyoJanPunPend;
  num? _NiyoJanPunDelPend;
  num? _OldBkgPendNewBkgRecv;
  num? _PostPaidVerifPend;
  num? _SVPendingStk;
  num? _TVPendingStk;
GetManagerDashboarDetailModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? filledDiff,
  num? emptyDiff,
  num? defectiveDiff,
  num? todayImbQty,
  num? asOfDateImbQty,
  num? dMCount,
  num? totalAmount,
  num? totalIncome,
  num? totalExp,
  num? staffOnAccToday,
  num? staffOnAccAsOf,
  num? cDCMSPunPend,
  num? niyoJanPunPend,
  num? paymtDoneBtDelPend,
  num? delDoneBtPaymtPend,
  num? niyojanPun,
  num? niyojanDuplicate,
  num? DelDonNiyoJanPunPend,
  num? NiyoJanPunDelPend,
  num? OldBkgPendNewBkgRecv,
  num? PostPaidVerifPend,
  num? SVPendingStk,
  num? TVPendingStk,
}) => GetManagerDashboarDetailModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledDiff: filledDiff ?? _filledDiff,
  emptyDiff: emptyDiff ?? _emptyDiff,
  defectiveDiff: defectiveDiff ?? _defectiveDiff,
  todayImbQty: todayImbQty ?? _todayImbQty,
  asOfDateImbQty: asOfDateImbQty ?? _asOfDateImbQty,
  dMCount: dMCount ?? _dMCount,
  totalAmount: totalAmount ?? _totalAmount,
  totalIncome: totalIncome ?? _totalIncome,
  totalExp: totalExp ?? _totalExp,
  staffOnAccToday: staffOnAccToday ?? _staffOnAccToday,
  staffOnAccAsOf: staffOnAccAsOf ?? _staffOnAccAsOf,
  cDCMSPunPend: cDCMSPunPend ?? _cDCMSPunPend,
  niyoJanPunPend: niyoJanPunPend ?? _niyoJanPunPend,
  paymtDoneBtDelPend: paymtDoneBtDelPend ?? _paymtDoneBtDelPend,
  delDoneBtPaymtPend: delDoneBtPaymtPend ?? _delDoneBtPaymtPend,
  niyojanPun: niyojanPun ?? _niyojanPun,
  niyojanDuplicate: niyojanDuplicate ?? _niyojanDuplicate,
  DelDonNiyoJanPunPend: DelDonNiyoJanPunPend ?? _DelDonNiyoJanPunPend,
  NiyoJanPunDelPend: NiyoJanPunDelPend ?? _NiyoJanPunDelPend,
  OldBkgPendNewBkgRecv: OldBkgPendNewBkgRecv ?? _OldBkgPendNewBkgRecv,
  PostPaidVerifPend: PostPaidVerifPend ?? _PostPaidVerifPend,
  SVPendingStk: SVPendingStk ?? _SVPendingStk,
  TVPendingStk: TVPendingStk ?? _TVPendingStk,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledDiff => _filledDiff;
  num? get emptyDiff => _emptyDiff;
  num? get defectiveDiff => _defectiveDiff;
  num? get todayImbQty => _todayImbQty;
  num? get asOfDateImbQty => _asOfDateImbQty;
  num? get dMCount => _dMCount;
  num? get totalAmount => _totalAmount;
  num? get totalIncome => _totalIncome;
  num? get totalExp => _totalExp;
  num? get staffOnAccToday => _staffOnAccToday;
  num? get staffOnAccAsOf => _staffOnAccAsOf;
  num? get cDCMSPunPend => _cDCMSPunPend;
  num? get niyoJanPunPend => _niyoJanPunPend;
  num? get paymtDoneBtDelPend => _paymtDoneBtDelPend;
  num? get delDoneBtPaymtPend => _delDoneBtPaymtPend;
  num? get niyojanPun => _niyojanPun;
  num? get niyojanDuplicate => _niyojanDuplicate;
  num? get DelDonNiyoJanPunPend => _DelDonNiyoJanPunPend;
  num? get NiyoJanPunDelPend => _NiyoJanPunDelPend;
  num? get OldBkgPendNewBkgRecv => _OldBkgPendNewBkgRecv;
  num? get PostPaidVerifPend => _PostPaidVerifPend;
  num? get SVPendingStk => _SVPendingStk;
  num? get TVPendingStk => _TVPendingStk;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledDiff'] = _filledDiff;
    map['EmptyDiff'] = _emptyDiff;
    map['DefectiveDiff'] = _defectiveDiff;
    map['TodayImbQty'] = _todayImbQty;
    map['AsOfDateImbQty'] = _asOfDateImbQty;
    map['DMCount'] = _dMCount;
    map['TotalAmount'] = _totalAmount;
    map['TotalIncome'] = _totalIncome;
    map['TotalExp'] = _totalExp;
    map['StaffOnAccToday'] = _staffOnAccToday;
    map['StaffOnAccAsOf'] = _staffOnAccAsOf;
    map['cDCMSPunPend'] = _cDCMSPunPend;
    map['NiyoJanPunPend'] = _niyoJanPunPend;
    map['PaymtDoneBtDelPend'] = _paymtDoneBtDelPend;
    map['DelDoneBtPaymtPend'] = _delDoneBtPaymtPend;
    map['NiyojanPun'] = _niyojanPun;
    map['NiyojanDuplicate'] = _niyojanDuplicate;
    map['DelDonNiyoJanPunPend'] = _DelDonNiyoJanPunPend;
    map['NiyoJanPunDelPend'] = _NiyoJanPunDelPend;
    map['OldBkgPendNewBkgRecv'] = _OldBkgPendNewBkgRecv;
    map['PostPaidVerifPend'] = _PostPaidVerifPend;
    map['SVPendingStk'] = _SVPendingStk;
    map['TVPendingStk'] = _TVPendingStk;
    return map;
  }

}