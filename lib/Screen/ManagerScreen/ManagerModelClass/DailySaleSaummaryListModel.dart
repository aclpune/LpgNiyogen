/// pkId : 0
/// DMId : 2
/// DistributorId : 8118
/// SaleGKId : 2
/// VehicleId : 25
/// VehicleNo : "MH45AB5342"
/// ItemCount : 2
/// StaffName : "Amit Thosar"
/// TotalSVQty : 2
/// TotalSVAmt : 0
/// TotalTVQty : 1
/// TotalTVAmt : 0
/// TotalFilledQty : 60
/// TotalFilledAmt : 0
/// TotalAmt : 69300
/// PrepaidAmt : 0
/// PrepaidQty : 0
/// PostPaidAmt : 0
/// PostPaidQty : 0
/// RetiCrAmt : 0
/// RetiCrQty : 0
/// CashAmt : 0
/// CashQty : 0
/// Status : null
/// StatusStr : "Submited"
/// DailySaleStatus : 1
/// DelDate : "2025-01-17T00:00:00"
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
      num? totalFilledAmt, 
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
    _totalFilledAmt = totalFilledAmt;
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
    _totalFilledAmt = json['TotalFilledAmt'];
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
  num? _totalFilledAmt;
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
  num? totalFilledAmt,
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
  totalFilledAmt: totalFilledAmt ?? _totalFilledAmt,
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
  num? get totalFilledAmt => _totalFilledAmt;
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
    map['TotalFilledAmt'] = _totalFilledAmt;
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
    map['DelDate'] = _delDate;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    map['DSCollMgrId'] = _dSCollMgrId;
    return map;
  }

}