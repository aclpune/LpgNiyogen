/// DistributorId : 8118
/// DelDate : "0001-01-01T00:00:00"
/// DMId : 25
/// StaffNo : "SN/0010"
/// StaffName : "Suchitra Zadane"
/// ItemId : 1
/// ItemName : "14.2 KG"
/// FilledSaleQty : 20
/// SVQty : 2
/// TVQty : 0
/// EmptyRetQty : 16
/// DeffQty : 0
/// LessEmptyQty : 2
/// ActualSaleQty : 18
/// DailySaleStatus : 6
/// DSCollMgrId : 0
/// CollRcptDate : "0001-01-01T00:00:00"
/// Rate : 855.50
/// TotalAmount : 15399.00
/// TotPrepaidQty : 2
/// TotPrepaidAmt : 1711.00
/// TotPostpaidQty : 0
/// TotPostpaidAmt : 0.00
/// TotRetiCrQty : 0
/// TotRetiCrAmt : 0.00
/// TotCashQty : 16
/// TotCashAmt : 13688.00
/// AddedBy : 0
/// DenoCashExptd : 13688.00
/// DenoCashRcvd : 13688.00
/// CashBalance : 0.00
/// FromDate : "0001-01-01T00:00:00"

class ManagerGetDsrdMwiseSummaryListModel {
  ManagerGetDsrdMwiseSummaryListModel({
      num? distributorId, 
      String? delDate, 
      num? dMId, 
      String? staffNo, 
      String? staffName, 
      num? itemId, 
      String? itemName, 
      num? filledSaleQty, 
      num? sVQty, 
      num? tVQty, 
      num? emptyRetQty, 
      num? deffQty, 
      num? lessEmptyQty, 
      num? actualSaleQty, 
      num? dailySaleStatus, 
      num? dSCollMgrId, 
      String? collRcptDate, 
      num? rate, 
      num? totalAmount, 
      num? totPrepaidQty, 
      num? totPrepaidAmt, 
      num? totPostpaidQty, 
      num? totPostpaidAmt, 
      num? totRetiCrQty, 
      num? totRetiCrAmt, 
      num? totCashQty, 
      num? totCashAmt, 
      num? addedBy, 
      num? denoCashExptd, 
      num? denoCashRcvd, 
      num? cashBalance, 
      String? fromDate,}){
    _distributorId = distributorId;
    _delDate = delDate;
    _dMId = dMId;
    _staffNo = staffNo;
    _staffName = staffName;
    _itemId = itemId;
    _itemName = itemName;
    _filledSaleQty = filledSaleQty;
    _sVQty = sVQty;
    _tVQty = tVQty;
    _emptyRetQty = emptyRetQty;
    _deffQty = deffQty;
    _lessEmptyQty = lessEmptyQty;
    _actualSaleQty = actualSaleQty;
    _dailySaleStatus = dailySaleStatus;
    _dSCollMgrId = dSCollMgrId;
    _collRcptDate = collRcptDate;
    _rate = rate;
    _totalAmount = totalAmount;
    _totPrepaidQty = totPrepaidQty;
    _totPrepaidAmt = totPrepaidAmt;
    _totPostpaidQty = totPostpaidQty;
    _totPostpaidAmt = totPostpaidAmt;
    _totRetiCrQty = totRetiCrQty;
    _totRetiCrAmt = totRetiCrAmt;
    _totCashQty = totCashQty;
    _totCashAmt = totCashAmt;
    _addedBy = addedBy;
    _denoCashExptd = denoCashExptd;
    _denoCashRcvd = denoCashRcvd;
    _cashBalance = cashBalance;
    _fromDate = fromDate;
}

  ManagerGetDsrdMwiseSummaryListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _delDate = json['DelDate'];
    _dMId = json['DMId'];
    _staffNo = json['StaffNo'];
    _staffName = json['StaffName'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledSaleQty = json['FilledSaleQty'];
    _sVQty = json['SVQty'];
    _tVQty = json['TVQty'];
    _emptyRetQty = json['EmptyRetQty'];
    _deffQty = json['DeffQty'];
    _lessEmptyQty = json['LessEmptyQty'];
    _actualSaleQty = json['ActualSaleQty'];
    _dailySaleStatus = json['DailySaleStatus'];
    _dSCollMgrId = json['DSCollMgrId'];
    _collRcptDate = json['CollRcptDate'];
    _rate = json['Rate'];
    _totalAmount = json['TotalAmount'];
    _totPrepaidQty = json['TotPrepaidQty'];
    _totPrepaidAmt = json['TotPrepaidAmt'];
    _totPostpaidQty = json['TotPostpaidQty'];
    _totPostpaidAmt = json['TotPostpaidAmt'];
    _totRetiCrQty = json['TotRetiCrQty'];
    _totRetiCrAmt = json['TotRetiCrAmt'];
    _totCashQty = json['TotCashQty'];
    _totCashAmt = json['TotCashAmt'];
    _addedBy = json['AddedBy'];
    _denoCashExptd = json['DenoCashExptd'];
    _denoCashRcvd = json['DenoCashRcvd'];
    _cashBalance = json['CashBalance'];
    _fromDate = json['FromDate'];
  }
  num? _distributorId;
  String? _delDate;
  num? _dMId;
  String? _staffNo;
  String? _staffName;
  num? _itemId;
  String? _itemName;
  num? _filledSaleQty;
  num? _sVQty;
  num? _tVQty;
  num? _emptyRetQty;
  num? _deffQty;
  num? _lessEmptyQty;
  num? _actualSaleQty;
  num? _dailySaleStatus;
  num? _dSCollMgrId;
  String? _collRcptDate;
  num? _rate;
  num? _totalAmount;
  num? _totPrepaidQty;
  num? _totPrepaidAmt;
  num? _totPostpaidQty;
  num? _totPostpaidAmt;
  num? _totRetiCrQty;
  num? _totRetiCrAmt;
  num? _totCashQty;
  num? _totCashAmt;
  num? _addedBy;
  num? _denoCashExptd;
  num? _denoCashRcvd;
  num? _cashBalance;
  String? _fromDate;
ManagerGetDsrdMwiseSummaryListModel copyWith({  num? distributorId,
  String? delDate,
  num? dMId,
  String? staffNo,
  String? staffName,
  num? itemId,
  String? itemName,
  num? filledSaleQty,
  num? sVQty,
  num? tVQty,
  num? emptyRetQty,
  num? deffQty,
  num? lessEmptyQty,
  num? actualSaleQty,
  num? dailySaleStatus,
  num? dSCollMgrId,
  String? collRcptDate,
  num? rate,
  num? totalAmount,
  num? totPrepaidQty,
  num? totPrepaidAmt,
  num? totPostpaidQty,
  num? totPostpaidAmt,
  num? totRetiCrQty,
  num? totRetiCrAmt,
  num? totCashQty,
  num? totCashAmt,
  num? addedBy,
  num? denoCashExptd,
  num? denoCashRcvd,
  num? cashBalance,
  String? fromDate,
}) => ManagerGetDsrdMwiseSummaryListModel(  distributorId: distributorId ?? _distributorId,
  delDate: delDate ?? _delDate,
  dMId: dMId ?? _dMId,
  staffNo: staffNo ?? _staffNo,
  staffName: staffName ?? _staffName,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledSaleQty: filledSaleQty ?? _filledSaleQty,
  sVQty: sVQty ?? _sVQty,
  tVQty: tVQty ?? _tVQty,
  emptyRetQty: emptyRetQty ?? _emptyRetQty,
  deffQty: deffQty ?? _deffQty,
  lessEmptyQty: lessEmptyQty ?? _lessEmptyQty,
  actualSaleQty: actualSaleQty ?? _actualSaleQty,
  dailySaleStatus: dailySaleStatus ?? _dailySaleStatus,
  dSCollMgrId: dSCollMgrId ?? _dSCollMgrId,
  collRcptDate: collRcptDate ?? _collRcptDate,
  rate: rate ?? _rate,
  totalAmount: totalAmount ?? _totalAmount,
  totPrepaidQty: totPrepaidQty ?? _totPrepaidQty,
  totPrepaidAmt: totPrepaidAmt ?? _totPrepaidAmt,
  totPostpaidQty: totPostpaidQty ?? _totPostpaidQty,
  totPostpaidAmt: totPostpaidAmt ?? _totPostpaidAmt,
  totRetiCrQty: totRetiCrQty ?? _totRetiCrQty,
  totRetiCrAmt: totRetiCrAmt ?? _totRetiCrAmt,
  totCashQty: totCashQty ?? _totCashQty,
  totCashAmt: totCashAmt ?? _totCashAmt,
  addedBy: addedBy ?? _addedBy,
  denoCashExptd: denoCashExptd ?? _denoCashExptd,
  denoCashRcvd: denoCashRcvd ?? _denoCashRcvd,
  cashBalance: cashBalance ?? _cashBalance,
  fromDate: fromDate ?? _fromDate,
);
  num? get distributorId => _distributorId;
  String? get delDate => _delDate;
  num? get dMId => _dMId;
  String? get staffNo => _staffNo;
  String? get staffName => _staffName;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledSaleQty => _filledSaleQty;
  num? get sVQty => _sVQty;
  num? get tVQty => _tVQty;
  num? get emptyRetQty => _emptyRetQty;
  num? get deffQty => _deffQty;
  num? get lessEmptyQty => _lessEmptyQty;
  num? get actualSaleQty => _actualSaleQty;
  num? get dailySaleStatus => _dailySaleStatus;
  num? get dSCollMgrId => _dSCollMgrId;
  String? get collRcptDate => _collRcptDate;
  num? get rate => _rate;
  num? get totalAmount => _totalAmount;
  num? get totPrepaidQty => _totPrepaidQty;
  num? get totPrepaidAmt => _totPrepaidAmt;
  num? get totPostpaidQty => _totPostpaidQty;
  num? get totPostpaidAmt => _totPostpaidAmt;
  num? get totRetiCrQty => _totRetiCrQty;
  num? get totRetiCrAmt => _totRetiCrAmt;
  num? get totCashQty => _totCashQty;
  num? get totCashAmt => _totCashAmt;
  num? get addedBy => _addedBy;
  num? get denoCashExptd => _denoCashExptd;
  num? get denoCashRcvd => _denoCashRcvd;
  num? get cashBalance => _cashBalance;
  String? get fromDate => _fromDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['DelDate'] = _delDate;
    map['DMId'] = _dMId;
    map['StaffNo'] = _staffNo;
    map['StaffName'] = _staffName;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledSaleQty'] = _filledSaleQty;
    map['SVQty'] = _sVQty;
    map['TVQty'] = _tVQty;
    map['EmptyRetQty'] = _emptyRetQty;
    map['DeffQty'] = _deffQty;
    map['LessEmptyQty'] = _lessEmptyQty;
    map['ActualSaleQty'] = _actualSaleQty;
    map['DailySaleStatus'] = _dailySaleStatus;
    map['DSCollMgrId'] = _dSCollMgrId;
    map['CollRcptDate'] = _collRcptDate;
    map['Rate'] = _rate;
    map['TotalAmount'] = _totalAmount;
    map['TotPrepaidQty'] = _totPrepaidQty;
    map['TotPrepaidAmt'] = _totPrepaidAmt;
    map['TotPostpaidQty'] = _totPostpaidQty;
    map['TotPostpaidAmt'] = _totPostpaidAmt;
    map['TotRetiCrQty'] = _totRetiCrQty;
    map['TotRetiCrAmt'] = _totRetiCrAmt;
    map['TotCashQty'] = _totCashQty;
    map['TotCashAmt'] = _totCashAmt;
    map['AddedBy'] = _addedBy;
    map['DenoCashExptd'] = _denoCashExptd;
    map['DenoCashRcvd'] = _denoCashRcvd;
    map['CashBalance'] = _cashBalance;
    map['FromDate'] = _fromDate;
    return map;
  }

}