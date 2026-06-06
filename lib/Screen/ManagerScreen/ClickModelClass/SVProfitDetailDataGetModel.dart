/// DistributorId : 8118
/// ItemId : 15
/// ItemName : "Stove Inspection charges"
/// ItemQty : 51
/// ProfitAmt : 12283.00

class SvProfitDetailDataGetModel {
  SvProfitDetailDataGetModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? itemQty, 
      num? profitAmt,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _itemQty = itemQty;
    _profitAmt = profitAmt;
}

  SvProfitDetailDataGetModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _itemQty = json['ItemQty'];
    _profitAmt = json['ProfitAmt'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _itemQty;
  num? _profitAmt;
SvProfitDetailDataGetModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? itemQty,
  num? profitAmt,
}) => SvProfitDetailDataGetModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  itemQty: itemQty ?? _itemQty,
  profitAmt: profitAmt ?? _profitAmt,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get itemQty => _itemQty;
  num? get profitAmt => _profitAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ItemQty'] = _itemQty;
    map['ProfitAmt'] = _profitAmt;
    return map;
  }

}