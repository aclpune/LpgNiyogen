/// DistributorId : 8118
/// ItemId : 1
/// ItemName : "14.2 KG"
/// SaleQty : 160
/// GrossRevenue : 136880.00
/// GrossProfit : 12240.00

class RefillProfitDetailDataGetModel {
  RefillProfitDetailDataGetModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? saleQty, 
      num? grossRevenue, 
      num? grossProfit,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _saleQty = saleQty;
    _grossRevenue = grossRevenue;
    _grossProfit = grossProfit;
}

  RefillProfitDetailDataGetModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _saleQty = json['SaleQty'];
    _grossRevenue = json['GrossRevenue'];
    _grossProfit = json['GrossProfit'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _saleQty;
  num? _grossRevenue;
  num? _grossProfit;
RefillProfitDetailDataGetModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? saleQty,
  num? grossRevenue,
  num? grossProfit,
}) => RefillProfitDetailDataGetModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  saleQty: saleQty ?? _saleQty,
  grossRevenue: grossRevenue ?? _grossRevenue,
  grossProfit: grossProfit ?? _grossProfit,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get saleQty => _saleQty;
  num? get grossRevenue => _grossRevenue;
  num? get grossProfit => _grossProfit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['SaleQty'] = _saleQty;
    map['GrossRevenue'] = _grossRevenue;
    map['GrossProfit'] = _grossProfit;
    return map;
  }

}