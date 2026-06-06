/// DistributorId : 0
/// ItemId : 5
/// ItemName : "2 Burner Delux"
/// ItemQty : 36
/// GrossSaleAmt : 98760.00
/// PurchesAmt : 23000.00
/// GrossProfitAmt : 75760.00

class ArbProfitDetailDataGetModel {
  ArbProfitDetailDataGetModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? itemQty, 
      num? grossSaleAmt, 
      num? purchesAmt, 
      num? grossProfitAmt,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _itemQty = itemQty;
    _grossSaleAmt = grossSaleAmt;
    _purchesAmt = purchesAmt;
    _grossProfitAmt = grossProfitAmt;
}

  ArbProfitDetailDataGetModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _itemQty = json['ItemQty'];
    _grossSaleAmt = json['GrossSaleAmt'];
    _purchesAmt = json['PurchesAmt'];
    _grossProfitAmt = json['GrossProfitAmt'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _itemQty;
  num? _grossSaleAmt;
  num? _purchesAmt;
  num? _grossProfitAmt;
ArbProfitDetailDataGetModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? itemQty,
  num? grossSaleAmt,
  num? purchesAmt,
  num? grossProfitAmt,
}) => ArbProfitDetailDataGetModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  itemQty: itemQty ?? _itemQty,
  grossSaleAmt: grossSaleAmt ?? _grossSaleAmt,
  purchesAmt: purchesAmt ?? _purchesAmt,
  grossProfitAmt: grossProfitAmt ?? _grossProfitAmt,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get itemQty => _itemQty;
  num? get grossSaleAmt => _grossSaleAmt;
  num? get purchesAmt => _purchesAmt;
  num? get grossProfitAmt => _grossProfitAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ItemQty'] = _itemQty;
    map['GrossSaleAmt'] = _grossSaleAmt;
    map['PurchesAmt'] = _purchesAmt;
    map['GrossProfitAmt'] = _grossProfitAmt;
    return map;
  }

}