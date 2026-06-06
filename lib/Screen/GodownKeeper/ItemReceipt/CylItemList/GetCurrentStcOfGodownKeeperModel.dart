/// DistributorId : 8118
/// GodownId : 1
/// ItemId : 4
/// ItemName : "2 Kg"
/// CurrentStkFilled : 220
/// CurrentStkEmpty : 0
/// CurrentStkDefective : 0

class GetCurrentStcOfGodownKeeperModel {
  GetCurrentStcOfGodownKeeperModel({
      num? distributorId, 
      num? godownId, 
      num? itemId, 
      String? itemName, 
      num? currentStkFilled, 
      num? currentStkEmpty, 
      num? currentStkDefective,}){
    _distributorId = distributorId;
    _godownId = godownId;
    _itemId = itemId;
    _itemName = itemName;
    _currentStkFilled = currentStkFilled;
    _currentStkEmpty = currentStkEmpty;
    _currentStkDefective = currentStkDefective;
}

  GetCurrentStcOfGodownKeeperModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _godownId = json['GodownId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _currentStkFilled = json['CurrentStkFilled'];
    _currentStkEmpty = json['CurrentStkEmpty'];
    _currentStkDefective = json['CurrentStkDefective'];
  }
  num? _distributorId;
  num? _godownId;
  num? _itemId;
  String? _itemName;
  num? _currentStkFilled;
  num? _currentStkEmpty;
  num? _currentStkDefective;
GetCurrentStcOfGodownKeeperModel copyWith({  num? distributorId,
  num? godownId,
  num? itemId,
  String? itemName,
  num? currentStkFilled,
  num? currentStkEmpty,
  num? currentStkDefective,
}) => GetCurrentStcOfGodownKeeperModel(  distributorId: distributorId ?? _distributorId,
  godownId: godownId ?? _godownId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  currentStkFilled: currentStkFilled ?? _currentStkFilled,
  currentStkEmpty: currentStkEmpty ?? _currentStkEmpty,
  currentStkDefective: currentStkDefective ?? _currentStkDefective,
);
  num? get distributorId => _distributorId;
  num? get godownId => _godownId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get currentStkFilled => _currentStkFilled;
  num? get currentStkEmpty => _currentStkEmpty;
  num? get currentStkDefective => _currentStkDefective;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['GodownId'] = _godownId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['CurrentStkFilled'] = _currentStkFilled;
    map['CurrentStkEmpty'] = _currentStkEmpty;
    map['CurrentStkDefective'] = _currentStkDefective;
    return map;
  }

}