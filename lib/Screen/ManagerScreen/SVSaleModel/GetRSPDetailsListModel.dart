/// RSPId : 121
/// DistributorId : 8118
/// ItemId : 4
/// ItemName : "5 KG FTL"
/// RSP_Price : 536.00
/// DepositAmt : 1100.00
/// EffectiveDate : "0001-01-01T00:00:00"
/// EffectiveDate1 : "16-04-2025"
/// AddedBy : 0
/// Action : null

class GetRspDetailsListModel {
  GetRspDetailsListModel({
      num? rSPId, 
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? rSPPrice, 
      num? depositAmt, 
      String? effectiveDate, 
      String? effectiveDate1, 
      num? addedBy, 
      dynamic action,}){
    _rSPId = rSPId;
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _rSPPrice = rSPPrice;
    _depositAmt = depositAmt;
    _effectiveDate = effectiveDate;
    _effectiveDate1 = effectiveDate1;
    _addedBy = addedBy;
    _action = action;
}

  GetRspDetailsListModel.fromJson(dynamic json) {
    _rSPId = json['RSPId'];
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _rSPPrice = json['RSP_Price'];
    _depositAmt = json['DepositAmt'];
    _effectiveDate = json['EffectiveDate'];
    _effectiveDate1 = json['EffectiveDate1'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
  }
  num? _rSPId;
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _rSPPrice;
  num? _depositAmt;
  String? _effectiveDate;
  String? _effectiveDate1;
  num? _addedBy;
  dynamic _action;
GetRspDetailsListModel copyWith({  num? rSPId,
  num? distributorId,
  num? itemId,
  String? itemName,
  num? rSPPrice,
  num? depositAmt,
  String? effectiveDate,
  String? effectiveDate1,
  num? addedBy,
  dynamic action,
}) => GetRspDetailsListModel(  rSPId: rSPId ?? _rSPId,
  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  rSPPrice: rSPPrice ?? _rSPPrice,
  depositAmt: depositAmt ?? _depositAmt,
  effectiveDate: effectiveDate ?? _effectiveDate,
  effectiveDate1: effectiveDate1 ?? _effectiveDate1,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
);
  num? get rSPId => _rSPId;
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rSPPrice => _rSPPrice;
  num? get depositAmt => _depositAmt;
  String? get effectiveDate => _effectiveDate;
  String? get effectiveDate1 => _effectiveDate1;
  num? get addedBy => _addedBy;
  dynamic get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RSPId'] = _rSPId;
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['RSP_Price'] = _rSPPrice;
    map['DepositAmt'] = _depositAmt;
    map['EffectiveDate'] = _effectiveDate;
    map['EffectiveDate1'] = _effectiveDate1;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    return map;
  }

}