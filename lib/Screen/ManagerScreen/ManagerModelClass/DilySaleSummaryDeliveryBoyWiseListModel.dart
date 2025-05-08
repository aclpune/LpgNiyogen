/// SaleGKId : 171
/// DistributorId : 8118
/// StaffId : 22
/// DSCollMgrId : 0
/// StaffNo : "SN/022"
/// StaffName : "Rahul"
/// ItemId : 1
/// ItemName : "14.2 KG"
/// SaleGKItemId : 151
/// GDFilledSale : 43
/// ActualSaleQty : 43
/// SVQty : 0
/// TVQty : 0
/// Amount : 34636
/// CashQty : 0
/// CashAmt : 0
/// PrepaidQty : 0
/// PrepaidAmt : 0
/// PostQty : 0
/// PostAmt : 0
/// CreditQty : 0
/// CreditAmt : 0
/// EmptyRetQty : 43
/// DeffQty : 0
/// LessEmptyQty : 0
/// DailySaleStatus : 2
/// DenoCashExptd : 0
/// DenoCashRcvd : 0
/// CashBalance : 0
/// UserName : ""
/// StatusStr : "Accepted"
/// AddedBy : 0
/// IsActive : 0
/// AddedOn : "0001-01-01T00:00:00"
/// DelDate : "2025-04-07T00:00:00"

class DilySaleSummaryDeliveryBoyWiseListModel {
  DilySaleSummaryDeliveryBoyWiseListModel({
      num? saleGKId, 
      num? distributorId, 
      num? staffId, 
      num? dSCollMgrId, 
      String? staffNo, 
      String? staffName, 
      num? itemId, 
      String? itemName, 
      num? saleGKItemId, 
      num? gDFilledSale, 
      num? actualSaleQty, 
      num? sVQty, 
      num? tVQty, 
      num? amount, 
      num? cashQty, 
      num? cashAmt, 
      num? prepaidQty,
      num? prepaidAmt,
      num? postQty, 
      num? postAmt, 
      num? creditQty, 
      num? creditAmt, 
      num? emptyRetQty, 
      num? deffQty, 
      num? lessEmptyQty, 
      num? dailySaleStatus, 
      num? denoCashExptd, 
      num? denoCashRcvd, 
      num? cashBalance, 
      String? userName, 
      String? statusStr, 
      num? addedBy, 
      num? isActive, 
      String? addedOn, 
      String? delDate,}){
    _saleGKId = saleGKId;
    _distributorId = distributorId;
    _staffId = staffId;
    _dSCollMgrId = dSCollMgrId;
    _staffNo = staffNo;
    _staffName = staffName;
    _itemId = itemId;
    _itemName = itemName;
    _saleGKItemId = saleGKItemId;
    _gDFilledSale = gDFilledSale;
    _actualSaleQty = actualSaleQty;
    _sVQty = sVQty;
    _tVQty = tVQty;
    _amount = amount;
    _cashQty = cashQty;
    _cashAmt = cashAmt;
    _prepaidQty = prepaidQty;
    _prepaidAmt = prepaidAmt;
    _postQty = postQty;
    _postAmt = postAmt;
    _creditQty = creditQty;
    _creditAmt = creditAmt;
    _emptyRetQty = emptyRetQty;
    _deffQty = deffQty;
    _lessEmptyQty = lessEmptyQty;
    _dailySaleStatus = dailySaleStatus;
    _denoCashExptd = denoCashExptd;
    _denoCashRcvd = denoCashRcvd;
    _cashBalance = cashBalance;
    _userName = userName;
    _statusStr = statusStr;
    _addedBy = addedBy;
    _isActive = isActive;
    _addedOn = addedOn;
    _delDate = delDate;
}

  DilySaleSummaryDeliveryBoyWiseListModel.fromJson(dynamic json) {
    _saleGKId = json['SaleGKId'];
    _distributorId = json['DistributorId'];
    _staffId = json['StaffId'];
    _dSCollMgrId = json['DSCollMgrId'];
    _staffNo = json['StaffNo'];
    _staffName = json['StaffName'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _saleGKItemId = json['SaleGKItemId'];
    _gDFilledSale = json['GDFilledSale'];
    _actualSaleQty = json['ActualSaleQty'];
    _sVQty = json['SVQty'];
    _tVQty = json['TVQty'];
    _amount = json['Amount'];
    _cashQty = json['CashQty'];
    _cashAmt = json['CashAmt'];
    _prepaidQty = json['PrepaidQty'];
    _prepaidAmt = json['PrepaidAmt'];
    _postQty = json['PostQty'];
    _postAmt = json['PostAmt'];
    _creditQty = json['CreditQty'];
    _creditAmt = json['CreditAmt'];
    _emptyRetQty = json['EmptyRetQty'];
    _deffQty = json['DeffQty'];
    _lessEmptyQty = json['LessEmptyQty'];
    _dailySaleStatus = json['DailySaleStatus'];
    _denoCashExptd = json['DenoCashExptd'];
    _denoCashRcvd = json['DenoCashRcvd'];
    _cashBalance = json['CashBalance'];
    _userName = json['UserName'];
    _statusStr = json['StatusStr'];
    _addedBy = json['AddedBy'];
    _isActive = json['IsActive'];
    _addedOn = json['AddedOn'];
    _delDate = json['DelDate'];
  }
  num? _saleGKId;
  num? _distributorId;
  num? _staffId;
  num? _dSCollMgrId;
  String? _staffNo;
  String? _staffName;
  num? _itemId;
  String? _itemName;
  num? _saleGKItemId;
  num? _gDFilledSale;
  num? _actualSaleQty;
  num? _sVQty;
  num? _tVQty;
  num? _amount;
  num? _cashQty;
  num? _cashAmt;
  num? _prepaidQty;
  num? _prepaidAmt;
  num? _postQty;
  num? _postAmt;
  num? _creditQty;
  num? _creditAmt;
  num? _emptyRetQty;
  num? _deffQty;
  num? _lessEmptyQty;
  num? _dailySaleStatus;
  num? _denoCashExptd;
  num? _denoCashRcvd;
  num? _cashBalance;
  String? _userName;
  String? _statusStr;
  num? _addedBy;
  num? _isActive;
  String? _addedOn;
  String? _delDate;
DilySaleSummaryDeliveryBoyWiseListModel copyWith({  num? saleGKId,
  num? distributorId,
  num? staffId,
  num? dSCollMgrId,
  String? staffNo,
  String? staffName,
  num? itemId,
  String? itemName,
  num? saleGKItemId,
  num? gDFilledSale,
  num? actualSaleQty,
  num? sVQty,
  num? tVQty,
  num? amount,
  num? cashQty,
  num? cashAmt,
  num? prepaidQty,
  num? prepaidAmt,
  num? postQty,
  num? postAmt,
  num? creditQty,
  num? creditAmt,
  num? emptyRetQty,
  num? deffQty,
  num? lessEmptyQty,
  num? dailySaleStatus,
  num? denoCashExptd,
  num? denoCashRcvd,
  num? cashBalance,
  String? userName,
  String? statusStr,
  num? addedBy,
  num? isActive,
  String? addedOn,
  String? delDate,
}) => DilySaleSummaryDeliveryBoyWiseListModel(  saleGKId: saleGKId ?? _saleGKId,
  distributorId: distributorId ?? _distributorId,
  staffId: staffId ?? _staffId,
  dSCollMgrId: dSCollMgrId ?? _dSCollMgrId,
  staffNo: staffNo ?? _staffNo,
  staffName: staffName ?? _staffName,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  saleGKItemId: saleGKItemId ?? _saleGKItemId,
  gDFilledSale: gDFilledSale ?? _gDFilledSale,
  actualSaleQty: actualSaleQty ?? _actualSaleQty,
  sVQty: sVQty ?? _sVQty,
  tVQty: tVQty ?? _tVQty,
  amount: amount ?? _amount,
  cashQty: cashQty ?? _cashQty,
  cashAmt: cashAmt ?? _cashAmt,
  prepaidQty: prepaidQty ?? _prepaidQty,
  prepaidAmt: prepaidAmt ?? _prepaidAmt,
  postQty: postQty ?? _postQty,
  postAmt: postAmt ?? _postAmt,
  creditQty: creditQty ?? _creditQty,
  creditAmt: creditAmt ?? _creditAmt,
  emptyRetQty: emptyRetQty ?? _emptyRetQty,
  deffQty: deffQty ?? _deffQty,
  lessEmptyQty: lessEmptyQty ?? _lessEmptyQty,
  dailySaleStatus: dailySaleStatus ?? _dailySaleStatus,
  denoCashExptd: denoCashExptd ?? _denoCashExptd,
  denoCashRcvd: denoCashRcvd ?? _denoCashRcvd,
  cashBalance: cashBalance ?? _cashBalance,
  userName: userName ?? _userName,
  statusStr: statusStr ?? _statusStr,
  addedBy: addedBy ?? _addedBy,
  isActive: isActive ?? _isActive,
  addedOn: addedOn ?? _addedOn,
  delDate: delDate ?? _delDate,
);
  num? get saleGKId => _saleGKId;
  num? get distributorId => _distributorId;
  num? get staffId => _staffId;
  num? get dSCollMgrId => _dSCollMgrId;
  String? get staffNo => _staffNo;
  String? get staffName => _staffName;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get saleGKItemId => _saleGKItemId;
  num? get gDFilledSale => _gDFilledSale;
  num? get actualSaleQty => _actualSaleQty;
  num? get sVQty => _sVQty;
  num? get tVQty => _tVQty;
  num? get amount => _amount;
  num? get cashQty => _cashQty;
  num? get cashAmt => _cashAmt;
  num? get prepaidQty => _prepaidQty;
  num? get prepaidAmt => _prepaidAmt;
  num? get postQty => _postQty;
  num? get postAmt => _postAmt;
  num? get creditQty => _creditQty;
  num? get creditAmt => _creditAmt;
  num? get emptyRetQty => _emptyRetQty;
  num? get deffQty => _deffQty;
  num? get lessEmptyQty => _lessEmptyQty;
  num? get dailySaleStatus => _dailySaleStatus;
  num? get denoCashExptd => _denoCashExptd;
  num? get denoCashRcvd => _denoCashRcvd;
  num? get cashBalance => _cashBalance;
  String? get userName => _userName;
  String? get statusStr => _statusStr;
  num? get addedBy => _addedBy;
  num? get isActive => _isActive;
  String? get addedOn => _addedOn;
  String? get delDate => _delDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SaleGKId'] = _saleGKId;
    map['DistributorId'] = _distributorId;
    map['StaffId'] = _staffId;
    map['DSCollMgrId'] = _dSCollMgrId;
    map['StaffNo'] = _staffNo;
    map['StaffName'] = _staffName;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['SaleGKItemId'] = _saleGKItemId;
    map['GDFilledSale'] = _gDFilledSale;
    map['ActualSaleQty'] = _actualSaleQty;
    map['SVQty'] = _sVQty;
    map['TVQty'] = _tVQty;
    map['Amount'] = _amount;
    map['CashQty'] = _cashQty;
    map['CashAmt'] = _cashAmt;
    map['PrepaidQty'] = _prepaidQty;
    map['PrepaidAmt'] = _prepaidAmt;
    map['PostQty'] = _postQty;
    map['PostAmt'] = _postAmt;
    map['CreditQty'] = _creditQty;
    map['CreditAmt'] = _creditAmt;
    map['EmptyRetQty'] = _emptyRetQty;
    map['DeffQty'] = _deffQty;
    map['LessEmptyQty'] = _lessEmptyQty;
    map['DailySaleStatus'] = _dailySaleStatus;
    map['DenoCashExptd'] = _denoCashExptd;
    map['DenoCashRcvd'] = _denoCashRcvd;
    map['CashBalance'] = _cashBalance;
    map['UserName'] = _userName;
    map['StatusStr'] = _statusStr;
    map['AddedBy'] = _addedBy;
    map['IsActive'] = _isActive;
    map['AddedOn'] = _addedOn;
    map['DelDate'] = _delDate;
    return map;
  }

}