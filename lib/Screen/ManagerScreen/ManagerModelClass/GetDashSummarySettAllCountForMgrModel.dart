/// DistributorId : 8118
/// cDCMSPunPend : 54
/// PaymtDoneBtDelPend : 38
/// DelDoneBtPaymtPend : 1973
/// NiyojanPun : 0
/// NiyojanDuplicate : 0
/// DelDonNiyoJanPunPend : 1192
/// NiyoJanPunDelPend : 5
/// OldBkgPendNewBkgRecv : 229
/// SettlementPendSince : "2025-04-29T01:00:00"
/// cDCMDPendSince : "2025-09-07T15:10:15"
/// PaymtDoneBtDelPendAmt : 32509.00
/// DelDoneBtPaymtPendAmt : 1687901.50
/// TotalPendingSettCnt : 1989
/// TotalPendingSettAmt : 1701589.50
/// TotalPendingSettSince : "2025-04-29T01:00:00"

class GetDashSummarySettAllCountForMgrModel {
  GetDashSummarySettAllCountForMgrModel({
      num? distributorId, 
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
      num? paymtDoneBtDelPendAmt, 
      num? delDoneBtPaymtPendAmt, 
      num? totalPendingSettCnt, 
      num? totalPendingSettAmt, 
      String? totalPendingSettSince,}){
    _distributorId = distributorId;
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
    _paymtDoneBtDelPendAmt = paymtDoneBtDelPendAmt;
    _delDoneBtPaymtPendAmt = delDoneBtPaymtPendAmt;
    _totalPendingSettCnt = totalPendingSettCnt;
    _totalPendingSettAmt = totalPendingSettAmt;
    _totalPendingSettSince = totalPendingSettSince;
}

  GetDashSummarySettAllCountForMgrModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
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
    _paymtDoneBtDelPendAmt = json['PaymtDoneBtDelPendAmt'];
    _delDoneBtPaymtPendAmt = json['DelDoneBtPaymtPendAmt'];
    _totalPendingSettCnt = json['TotalPendingSettCnt'];
    _totalPendingSettAmt = json['TotalPendingSettAmt'];
    _totalPendingSettSince = json['TotalPendingSettSince'];
  }
  num? _distributorId;
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
  num? _paymtDoneBtDelPendAmt;
  num? _delDoneBtPaymtPendAmt;
  num? _totalPendingSettCnt;
  num? _totalPendingSettAmt;
  String? _totalPendingSettSince;
GetDashSummarySettAllCountForMgrModel copyWith({  num? distributorId,
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
  num? paymtDoneBtDelPendAmt,
  num? delDoneBtPaymtPendAmt,
  num? totalPendingSettCnt,
  num? totalPendingSettAmt,
  String? totalPendingSettSince,
}) => GetDashSummarySettAllCountForMgrModel(  distributorId: distributorId ?? _distributorId,
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
  paymtDoneBtDelPendAmt: paymtDoneBtDelPendAmt ?? _paymtDoneBtDelPendAmt,
  delDoneBtPaymtPendAmt: delDoneBtPaymtPendAmt ?? _delDoneBtPaymtPendAmt,
  totalPendingSettCnt: totalPendingSettCnt ?? _totalPendingSettCnt,
  totalPendingSettAmt: totalPendingSettAmt ?? _totalPendingSettAmt,
  totalPendingSettSince: totalPendingSettSince ?? _totalPendingSettSince,
);
  num? get distributorId => _distributorId;
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
  num? get paymtDoneBtDelPendAmt => _paymtDoneBtDelPendAmt;
  num? get delDoneBtPaymtPendAmt => _delDoneBtPaymtPendAmt;
  num? get totalPendingSettCnt => _totalPendingSettCnt;
  num? get totalPendingSettAmt => _totalPendingSettAmt;
  String? get totalPendingSettSince => _totalPendingSettSince;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
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
    map['PaymtDoneBtDelPendAmt'] = _paymtDoneBtDelPendAmt;
    map['DelDoneBtPaymtPendAmt'] = _delDoneBtPaymtPendAmt;
    map['TotalPendingSettCnt'] = _totalPendingSettCnt;
    map['TotalPendingSettAmt'] = _totalPendingSettAmt;
    map['TotalPendingSettSince'] = _totalPendingSettSince;
    return map;
  }

}