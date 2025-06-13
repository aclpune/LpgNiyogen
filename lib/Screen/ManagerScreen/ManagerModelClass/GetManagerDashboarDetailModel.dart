/// DistributorId : 8118
/// ItemId : 1
/// ItemName : "14.2 KG"
/// FilledDiff : 0
/// EmptyDiff : 0
/// DefectiveDiff : 0
/// TodayImbQty : 0
/// AsOfDateImbQty : 135
/// DMCount : 12
/// TotalAmount : 263874.00
/// TotalIncome : 0.00
/// TotalExp : 3433.00
/// StaffOnAccToday : 0.00
/// StaffOnAccAsOf : 6838996.00
/// cDCMSPunPend : 103
/// PaymtDoneBtDelPend : 40
/// DelDoneBtPaymtPend : 106
/// NiyojanPun : 0
/// NiyojanDuplicate : 0
/// DelDonNiyoJanPunPend : 1715
/// NiyoJanPunDelPend : 0
/// OldBkgPendNewBkgRecv : 383
/// SettlementPendSince : "2025-04-29T01:00:00"
/// cDCMDPendSince : "2025-05-27T01:00:00"
/// PostPaidVerifPend : 260
/// SVPendingStk : 61
/// TVPendingStk : 1
/// PaymtDoneBtDelPendAmt : 34220.00
/// DelDoneBtPaymtPendAmt : 90683.00
/// PostPaidVerifPendAmt : 2982453.50
/// TotalPendingSettCnt : 169
/// TotalPendingSettAmt : 144579.50
/// TotalPendingSettSince : "2025-04-29T01:00:00"

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
      num? paymtDoneBtDelPend, 
      num? delDoneBtPaymtPend, 
      num? niyojanPun, 
      num? niyojanDuplicate, 
      num? delDonNiyoJanPunPend, 
      num? niyoJanPunDelPend, 
      num? oldBkgPendNewBkgRecv, 
      String? settlementPendSince, 
      String? cDCMDPendSince, 
      num? postPaidVerifPend, 
      num? sVPendingStk, 
      num? tVPendingStk, 
      num? paymtDoneBtDelPendAmt, 
      num? delDoneBtPaymtPendAmt, 
      num? postPaidVerifPendAmt, 
      num? totalPendingSettCnt, 
      num? totalPendingSettAmt, 
      String? totalPendingSettSince,}){
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
    _paymtDoneBtDelPend = paymtDoneBtDelPend;
    _delDoneBtPaymtPend = delDoneBtPaymtPend;
    _niyojanPun = niyojanPun;
    _niyojanDuplicate = niyojanDuplicate;
    _delDonNiyoJanPunPend = delDonNiyoJanPunPend;
    _niyoJanPunDelPend = niyoJanPunDelPend;
    _oldBkgPendNewBkgRecv = oldBkgPendNewBkgRecv;
    _settlementPendSince = settlementPendSince;
    _cDCMDPendSince = cDCMDPendSince;
    _postPaidVerifPend = postPaidVerifPend;
    _sVPendingStk = sVPendingStk;
    _tVPendingStk = tVPendingStk;
    _paymtDoneBtDelPendAmt = paymtDoneBtDelPendAmt;
    _delDoneBtPaymtPendAmt = delDoneBtPaymtPendAmt;
    _postPaidVerifPendAmt = postPaidVerifPendAmt;
    _totalPendingSettCnt = totalPendingSettCnt;
    _totalPendingSettAmt = totalPendingSettAmt;
    _totalPendingSettSince = totalPendingSettSince;
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
    _paymtDoneBtDelPend = json['PaymtDoneBtDelPend'];
    _delDoneBtPaymtPend = json['DelDoneBtPaymtPend'];
    _niyojanPun = json['NiyojanPun'];
    _niyojanDuplicate = json['NiyojanDuplicate'];
    _delDonNiyoJanPunPend = json['DelDonNiyoJanPunPend'];
    _niyoJanPunDelPend = json['NiyoJanPunDelPend'];
    _oldBkgPendNewBkgRecv = json['OldBkgPendNewBkgRecv'];
    _settlementPendSince = json['SettlementPendSince'];
    _cDCMDPendSince = json['cDCMDPendSince'];
    _postPaidVerifPend = json['PostPaidVerifPend'];
    _sVPendingStk = json['SVPendingStk'];
    _tVPendingStk = json['TVPendingStk'];
    _paymtDoneBtDelPendAmt = json['PaymtDoneBtDelPendAmt'];
    _delDoneBtPaymtPendAmt = json['DelDoneBtPaymtPendAmt'];
    _postPaidVerifPendAmt = json['PostPaidVerifPendAmt'];
    _totalPendingSettCnt = json['TotalPendingSettCnt'];
    _totalPendingSettAmt = json['TotalPendingSettAmt'];
    _totalPendingSettSince = json['TotalPendingSettSince'];
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
  num? _paymtDoneBtDelPend;
  num? _delDoneBtPaymtPend;
  num? _niyojanPun;
  num? _niyojanDuplicate;
  num? _delDonNiyoJanPunPend;
  num? _niyoJanPunDelPend;
  num? _oldBkgPendNewBkgRecv;
  String? _settlementPendSince;
  String? _cDCMDPendSince;
  num? _postPaidVerifPend;
  num? _sVPendingStk;
  num? _tVPendingStk;
  num? _paymtDoneBtDelPendAmt;
  num? _delDoneBtPaymtPendAmt;
  num? _postPaidVerifPendAmt;
  num? _totalPendingSettCnt;
  num? _totalPendingSettAmt;
  String? _totalPendingSettSince;
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
  num? paymtDoneBtDelPend,
  num? delDoneBtPaymtPend,
  num? niyojanPun,
  num? niyojanDuplicate,
  num? delDonNiyoJanPunPend,
  num? niyoJanPunDelPend,
  num? oldBkgPendNewBkgRecv,
  String? settlementPendSince,
  String? cDCMDPendSince,
  num? postPaidVerifPend,
  num? sVPendingStk,
  num? tVPendingStk,
  num? paymtDoneBtDelPendAmt,
  num? delDoneBtPaymtPendAmt,
  num? postPaidVerifPendAmt,
  num? totalPendingSettCnt,
  num? totalPendingSettAmt,
  String? totalPendingSettSince,
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
  paymtDoneBtDelPend: paymtDoneBtDelPend ?? _paymtDoneBtDelPend,
  delDoneBtPaymtPend: delDoneBtPaymtPend ?? _delDoneBtPaymtPend,
  niyojanPun: niyojanPun ?? _niyojanPun,
  niyojanDuplicate: niyojanDuplicate ?? _niyojanDuplicate,
  delDonNiyoJanPunPend: delDonNiyoJanPunPend ?? _delDonNiyoJanPunPend,
  niyoJanPunDelPend: niyoJanPunDelPend ?? _niyoJanPunDelPend,
  oldBkgPendNewBkgRecv: oldBkgPendNewBkgRecv ?? _oldBkgPendNewBkgRecv,
  settlementPendSince: settlementPendSince ?? _settlementPendSince,
  cDCMDPendSince: cDCMDPendSince ?? _cDCMDPendSince,
  postPaidVerifPend: postPaidVerifPend ?? _postPaidVerifPend,
  sVPendingStk: sVPendingStk ?? _sVPendingStk,
  tVPendingStk: tVPendingStk ?? _tVPendingStk,
  paymtDoneBtDelPendAmt: paymtDoneBtDelPendAmt ?? _paymtDoneBtDelPendAmt,
  delDoneBtPaymtPendAmt: delDoneBtPaymtPendAmt ?? _delDoneBtPaymtPendAmt,
  postPaidVerifPendAmt: postPaidVerifPendAmt ?? _postPaidVerifPendAmt,
  totalPendingSettCnt: totalPendingSettCnt ?? _totalPendingSettCnt,
  totalPendingSettAmt: totalPendingSettAmt ?? _totalPendingSettAmt,
  totalPendingSettSince: totalPendingSettSince ?? _totalPendingSettSince,
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
  num? get paymtDoneBtDelPend => _paymtDoneBtDelPend;
  num? get delDoneBtPaymtPend => _delDoneBtPaymtPend;
  num? get niyojanPun => _niyojanPun;
  num? get niyojanDuplicate => _niyojanDuplicate;
  num? get delDonNiyoJanPunPend => _delDonNiyoJanPunPend;
  num? get niyoJanPunDelPend => _niyoJanPunDelPend;
  num? get oldBkgPendNewBkgRecv => _oldBkgPendNewBkgRecv;
  String? get settlementPendSince => _settlementPendSince;
  String? get cDCMDPendSince => _cDCMDPendSince;
  num? get postPaidVerifPend => _postPaidVerifPend;
  num? get sVPendingStk => _sVPendingStk;
  num? get tVPendingStk => _tVPendingStk;
  num? get paymtDoneBtDelPendAmt => _paymtDoneBtDelPendAmt;
  num? get delDoneBtPaymtPendAmt => _delDoneBtPaymtPendAmt;
  num? get postPaidVerifPendAmt => _postPaidVerifPendAmt;
  num? get totalPendingSettCnt => _totalPendingSettCnt;
  num? get totalPendingSettAmt => _totalPendingSettAmt;
  String? get totalPendingSettSince => _totalPendingSettSince;

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
    map['PaymtDoneBtDelPend'] = _paymtDoneBtDelPend;
    map['DelDoneBtPaymtPend'] = _delDoneBtPaymtPend;
    map['NiyojanPun'] = _niyojanPun;
    map['NiyojanDuplicate'] = _niyojanDuplicate;
    map['DelDonNiyoJanPunPend'] = _delDonNiyoJanPunPend;
    map['NiyoJanPunDelPend'] = _niyoJanPunDelPend;
    map['OldBkgPendNewBkgRecv'] = _oldBkgPendNewBkgRecv;
    map['SettlementPendSince'] = _settlementPendSince;
    map['cDCMDPendSince'] = _cDCMDPendSince;
    map['PostPaidVerifPend'] = _postPaidVerifPend;
    map['SVPendingStk'] = _sVPendingStk;
    map['TVPendingStk'] = _tVPendingStk;
    map['PaymtDoneBtDelPendAmt'] = _paymtDoneBtDelPendAmt;
    map['DelDoneBtPaymtPendAmt'] = _delDoneBtPaymtPendAmt;
    map['PostPaidVerifPendAmt'] = _postPaidVerifPendAmt;
    map['TotalPendingSettCnt'] = _totalPendingSettCnt;
    map['TotalPendingSettAmt'] = _totalPendingSettAmt;
    map['TotalPendingSettSince'] = _totalPendingSettSince;
    return map;
  }

}