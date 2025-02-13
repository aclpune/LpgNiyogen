/// DistributorId : 8118
/// DMId : 25
/// ItemId : 1
/// ItemName : "14.2 kg"
/// ImbQty : 10
/// RecQty : 3
/// BalImbQty : 7

class ImabalanceEmptyListModel {
  ImabalanceEmptyListModel({
      num? distributorId, 
      num? dMId, 
      num? itemId, 
      String? itemName, 
      num? imbQty, 
      num? recQty, 
      num? balImbQty,}){
    _distributorId = distributorId;
    _dMId = dMId;
    _itemId = itemId;
    _itemName = itemName;
    _imbQty = imbQty;
    _recQty = recQty;
    _balImbQty = balImbQty;
}

  ImabalanceEmptyListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _dMId = json['DMId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _imbQty = json['ImbQty'];
    _recQty = json['RecQty'];
    _balImbQty = json['BalImbQty'];
  }
  num? _distributorId;
  num? _dMId;
  num? _itemId;
  String? _itemName;
  num? _imbQty;
  num? _recQty;
  num? _balImbQty;
ImabalanceEmptyListModel copyWith({  num? distributorId,
  num? dMId,
  num? itemId,
  String? itemName,
  num? imbQty,
  num? recQty,
  num? balImbQty,
}) => ImabalanceEmptyListModel(  distributorId: distributorId ?? _distributorId,
  dMId: dMId ?? _dMId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  imbQty: imbQty ?? _imbQty,
  recQty: recQty ?? _recQty,
  balImbQty: balImbQty ?? _balImbQty,
);
  num? get distributorId => _distributorId;
  num? get dMId => _dMId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get imbQty => _imbQty;
  num? get recQty => _recQty;
  num? get balImbQty => _balImbQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['DMId'] = _dMId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ImbQty'] = _imbQty;
    map['RecQty'] = _recQty;
    map['BalImbQty'] = _balImbQty;
    return map;
  }

}