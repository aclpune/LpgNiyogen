/// pkId : 0
/// DMId : 22
/// DistributorId : 8118
/// SaleGKId : 171
/// VehicleId : 10
/// VehicleNo : "MH49KL7474"
/// ItemCount : 1
/// StaffName : "Rahul"
/// TotalSVQty : 0
/// TotalSVAmt : 0.0
/// TotalTVQty : 0
/// TotalTVAmt : 0
/// TotalFilledQty : 43
/// TotalActualSaleQty : 43
/// TotalFilledAmt : 0
/// TotalDefQty : 0
/// TotalAmt : 34636.50
/// PrepaidAmt : 0.00
/// PrepaidQty : 0
/// PostPaidAmt : 0.00
/// PostPaidQty : 0
/// RetiCrAmt : 0.00
/// RetiCrQty : 0
/// CashAmt : 0.00
/// CashQty : 0
/// Status : null
/// StatusStr : "Accepted"
/// DailySaleStatus : 2
/// TotRecievedcAmt : 0.00
/// DelDate : "2025-04-07T00:00:00"
/// Action : null
/// AddedBy : 0
/// DSCollMgrId : 0

class DailySaleSaummaryListModel {
  DailySaleSaummaryListModel({
      num? pkId, 
      num? dMId, 
      num? distributorId, 
      num? saleGKId, 
      num? vehicleId, 
      String? vehicleNo, 
      num? itemCount, 
      String? staffName, 
      num? totalSVQty, 
      num? totalSVAmt, 
      num? totalTVQty, 
      num? totalTVAmt, 
      num? totalFilledQty, 
      num? totalActualSaleQty, 
      num? totalFilledAmt, 
      num? totalDefQty, 
      num? totalAmt, 
      num? prepaidAmt, 
      num? prepaidQty, 
      num? postPaidAmt, 
      num? postPaidQty, 
      num? retiCrAmt, 
      num? retiCrQty, 
      num? cashAmt, 
      num? cashQty, 
      dynamic status, 
      String? statusStr, 
      num? dailySaleStatus, 
      num? totRecievedcAmt, 
      String? delDate, 
      dynamic action, 
      num? addedBy, 
      num? dSCollMgrId,}){
    _pkId = pkId;
    _dMId = dMId;
    _distributorId = distributorId;
    _saleGKId = saleGKId;
    _vehicleId = vehicleId;
    _vehicleNo = vehicleNo;
    _itemCount = itemCount;
    _staffName = staffName;
    _totalSVQty = totalSVQty;
    _totalSVAmt = totalSVAmt;
    _totalTVQty = totalTVQty;
    _totalTVAmt = totalTVAmt;
    _totalFilledQty = totalFilledQty;
    _totalActualSaleQty = totalActualSaleQty;
    _totalFilledAmt = totalFilledAmt;
    _totalDefQty = totalDefQty;
    _totalAmt = totalAmt;
    _prepaidAmt = prepaidAmt;
    _prepaidQty = prepaidQty;
    _postPaidAmt = postPaidAmt;
    _postPaidQty = postPaidQty;
    _retiCrAmt = retiCrAmt;
    _retiCrQty = retiCrQty;
    _cashAmt = cashAmt;
    _cashQty = cashQty;
    _status = status;
    _statusStr = statusStr;
    _dailySaleStatus = dailySaleStatus;
    _totRecievedcAmt = totRecievedcAmt;
    _delDate = delDate;
    _action = action;
    _addedBy = addedBy;
    _dSCollMgrId = dSCollMgrId;
}

  DailySaleSaummaryListModel.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _dMId = json['DMId'];
    _distributorId = json['DistributorId'];
    _saleGKId = json['SaleGKId'];
    _vehicleId = json['VehicleId'];
    _vehicleNo = json['VehicleNo'];
    _itemCount = json['ItemCount'];
    _staffName = json['StaffName'];
    _totalSVQty = json['TotalSVQty'];
    _totalSVAmt = json['TotalSVAmt'];
    _totalTVQty = json['TotalTVQty'];
    _totalTVAmt = json['TotalTVAmt'];
    _totalFilledQty = json['TotalFilledQty'];
    _totalActualSaleQty = json['TotalActualSaleQty'];
    _totalFilledAmt = json['TotalFilledAmt'];
    _totalDefQty = json['TotalDefQty'];
    _totalAmt = json['TotalAmt'];
    _prepaidAmt = json['PrepaidAmt'];
    _prepaidQty = json['PrepaidQty'];
    _postPaidAmt = json['PostPaidAmt'];
    _postPaidQty = json['PostPaidQty'];
    _retiCrAmt = json['RetiCrAmt'];
    _retiCrQty = json['RetiCrQty'];
    _cashAmt = json['CashAmt'];
    _cashQty = json['CashQty'];
    _status = json['Status'];
    _statusStr = json['StatusStr'];
    _dailySaleStatus = json['DailySaleStatus'];
    _totRecievedcAmt = json['TotRecievedcAmt'];
    _delDate = json['DelDate'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
    _dSCollMgrId = json['DSCollMgrId'];
  }
  num? _pkId;
  num? _dMId;
  num? _distributorId;
  num? _saleGKId;
  num? _vehicleId;
  String? _vehicleNo;
  num? _itemCount;
  String? _staffName;
  num? _totalSVQty;
  num? _totalSVAmt;
  num? _totalTVQty;
  num? _totalTVAmt;
  num? _totalFilledQty;
  num? _totalActualSaleQty;
  num? _totalFilledAmt;
  num? _totalDefQty;
  num? _totalAmt;
  num? _prepaidAmt;
  num? _prepaidQty;
  num? _postPaidAmt;
  num? _postPaidQty;
  num? _retiCrAmt;
  num? _retiCrQty;
  num? _cashAmt;
  num? _cashQty;
  dynamic _status;
  String? _statusStr;
  num? _dailySaleStatus;
  num? _totRecievedcAmt;
  String? _delDate;
  dynamic _action;
  num? _addedBy;
  num? _dSCollMgrId;
DailySaleSaummaryListModel copyWith({  num? pkId,
  num? dMId,
  num? distributorId,
  num? saleGKId,
  num? vehicleId,
  String? vehicleNo,
  num? itemCount,
  String? staffName,
  num? totalSVQty,
  num? totalSVAmt,
  num? totalTVQty,
  num? totalTVAmt,
  num? totalFilledQty,
  num? totalActualSaleQty,
  num? totalFilledAmt,
  num? totalDefQty,
  num? totalAmt,
  num? prepaidAmt,
  num? prepaidQty,
  num? postPaidAmt,
  num? postPaidQty,
  num? retiCrAmt,
  num? retiCrQty,
  num? cashAmt,
  num? cashQty,
  dynamic status,
  String? statusStr,
  num? dailySaleStatus,
  num? totRecievedcAmt,
  String? delDate,
  dynamic action,
  num? addedBy,
  num? dSCollMgrId,
}) => DailySaleSaummaryListModel(  pkId: pkId ?? _pkId,
  dMId: dMId ?? _dMId,
  distributorId: distributorId ?? _distributorId,
  saleGKId: saleGKId ?? _saleGKId,
  vehicleId: vehicleId ?? _vehicleId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  itemCount: itemCount ?? _itemCount,
  staffName: staffName ?? _staffName,
  totalSVQty: totalSVQty ?? _totalSVQty,
  totalSVAmt: totalSVAmt ?? _totalSVAmt,
  totalTVQty: totalTVQty ?? _totalTVQty,
  totalTVAmt: totalTVAmt ?? _totalTVAmt,
  totalFilledQty: totalFilledQty ?? _totalFilledQty,
  totalActualSaleQty: totalActualSaleQty ?? _totalActualSaleQty,
  totalFilledAmt: totalFilledAmt ?? _totalFilledAmt,
  totalDefQty: totalDefQty ?? _totalDefQty,
  totalAmt: totalAmt ?? _totalAmt,
  prepaidAmt: prepaidAmt ?? _prepaidAmt,
  prepaidQty: prepaidQty ?? _prepaidQty,
  postPaidAmt: postPaidAmt ?? _postPaidAmt,
  postPaidQty: postPaidQty ?? _postPaidQty,
  retiCrAmt: retiCrAmt ?? _retiCrAmt,
  retiCrQty: retiCrQty ?? _retiCrQty,
  cashAmt: cashAmt ?? _cashAmt,
  cashQty: cashQty ?? _cashQty,
  status: status ?? _status,
  statusStr: statusStr ?? _statusStr,
  dailySaleStatus: dailySaleStatus ?? _dailySaleStatus,
  totRecievedcAmt: totRecievedcAmt ?? _totRecievedcAmt,
  delDate: delDate ?? _delDate,
  action: action ?? _action,
  addedBy: addedBy ?? _addedBy,
  dSCollMgrId: dSCollMgrId ?? _dSCollMgrId,
);
  num? get pkId => _pkId;
  num? get dMId => _dMId;
  num? get distributorId => _distributorId;
  num? get saleGKId => _saleGKId;
  num? get vehicleId => _vehicleId;
  String? get vehicleNo => _vehicleNo;
  num? get itemCount => _itemCount;
  String? get staffName => _staffName;
  num? get totalSVQty => _totalSVQty;
  num? get totalSVAmt => _totalSVAmt;
  num? get totalTVQty => _totalTVQty;
  num? get totalTVAmt => _totalTVAmt;
  num? get totalFilledQty => _totalFilledQty;
  num? get totalActualSaleQty => _totalActualSaleQty;
  num? get totalFilledAmt => _totalFilledAmt;
  num? get totalDefQty => _totalDefQty;
  num? get totalAmt => _totalAmt;
  num? get prepaidAmt => _prepaidAmt;
  num? get prepaidQty => _prepaidQty;
  num? get postPaidAmt => _postPaidAmt;
  num? get postPaidQty => _postPaidQty;
  num? get retiCrAmt => _retiCrAmt;
  num? get retiCrQty => _retiCrQty;
  num? get cashAmt => _cashAmt;
  num? get cashQty => _cashQty;
  dynamic get status => _status;
  String? get statusStr => _statusStr;
  num? get dailySaleStatus => _dailySaleStatus;
  num? get totRecievedcAmt => _totRecievedcAmt;
  String? get delDate => _delDate;
  dynamic get action => _action;
  num? get addedBy => _addedBy;
  num? get dSCollMgrId => _dSCollMgrId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['DMId'] = _dMId;
    map['DistributorId'] = _distributorId;
    map['SaleGKId'] = _saleGKId;
    map['VehicleId'] = _vehicleId;
    map['VehicleNo'] = _vehicleNo;
    map['ItemCount'] = _itemCount;
    map['StaffName'] = _staffName;
    map['TotalSVQty'] = _totalSVQty;
    map['TotalSVAmt'] = _totalSVAmt;
    map['TotalTVQty'] = _totalTVQty;
    map['TotalTVAmt'] = _totalTVAmt;
    map['TotalFilledQty'] = _totalFilledQty;
    map['TotalActualSaleQty'] = _totalActualSaleQty;
    map['TotalFilledAmt'] = _totalFilledAmt;
    map['TotalDefQty'] = _totalDefQty;
    map['TotalAmt'] = _totalAmt;
    map['PrepaidAmt'] = _prepaidAmt;
    map['PrepaidQty'] = _prepaidQty;
    map['PostPaidAmt'] = _postPaidAmt;
    map['PostPaidQty'] = _postPaidQty;
    map['RetiCrAmt'] = _retiCrAmt;
    map['RetiCrQty'] = _retiCrQty;
    map['CashAmt'] = _cashAmt;
    map['CashQty'] = _cashQty;
    map['Status'] = _status;
    map['StatusStr'] = _statusStr;
    map['DailySaleStatus'] = _dailySaleStatus;
    map['TotRecievedcAmt'] = _totRecievedcAmt;
    map['DelDate'] = _delDate;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    map['DSCollMgrId'] = _dSCollMgrId;
    return map;
  }

}