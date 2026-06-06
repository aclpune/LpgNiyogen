/// DistributorId : 8118
/// ItemId : 3
/// ItemName : "5 kg"
/// ImbalanceStk : 2

class PhysicalStockImbalanceDataModel {
  PhysicalStockImbalanceDataModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? imbalanceStk,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _imbalanceStk = imbalanceStk;
}

  PhysicalStockImbalanceDataModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _imbalanceStk = json['ImbalanceStk'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _imbalanceStk;
PhysicalStockImbalanceDataModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? imbalanceStk,
}) => PhysicalStockImbalanceDataModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  imbalanceStk: imbalanceStk ?? _imbalanceStk,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get imbalanceStk => _imbalanceStk;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ImbalanceStk'] = _imbalanceStk;
    return map;
  }

}