/// DistributorId : 0
/// ItemId : 1
/// ItemName : "14.2 KG"
/// ThisMonthSaleQty : 0.0
/// PreMonthSaleQty : 160.0
/// PreYearSameMonthSaleQty : 0.0

class GetDashProductSaleComparisonMob {
  GetDashProductSaleComparisonMob({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? thisMonthSaleQty, 
      num? preMonthSaleQty, 
      num? preYearSameMonthSaleQty,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _thisMonthSaleQty = thisMonthSaleQty;
    _preMonthSaleQty = preMonthSaleQty;
    _preYearSameMonthSaleQty = preYearSameMonthSaleQty;
}

  GetDashProductSaleComparisonMob.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _thisMonthSaleQty = json['ThisMonthSaleQty'];
    _preMonthSaleQty = json['PreMonthSaleQty'];
    _preYearSameMonthSaleQty = json['PreYearSameMonthSaleQty'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _thisMonthSaleQty;
  num? _preMonthSaleQty;
  num? _preYearSameMonthSaleQty;
GetDashProductSaleComparisonMob copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? thisMonthSaleQty,
  num? preMonthSaleQty,
  num? preYearSameMonthSaleQty,
}) => GetDashProductSaleComparisonMob(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  thisMonthSaleQty: thisMonthSaleQty ?? _thisMonthSaleQty,
  preMonthSaleQty: preMonthSaleQty ?? _preMonthSaleQty,
  preYearSameMonthSaleQty: preYearSameMonthSaleQty ?? _preYearSameMonthSaleQty,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get thisMonthSaleQty => _thisMonthSaleQty;
  num? get preMonthSaleQty => _preMonthSaleQty;
  num? get preYearSameMonthSaleQty => _preYearSameMonthSaleQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ThisMonthSaleQty'] = _thisMonthSaleQty;
    map['PreMonthSaleQty'] = _preMonthSaleQty;
    map['PreYearSameMonthSaleQty'] = _preYearSameMonthSaleQty;
    return map;
  }

}