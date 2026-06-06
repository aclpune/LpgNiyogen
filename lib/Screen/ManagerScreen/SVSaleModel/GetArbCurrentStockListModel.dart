/// CategoryId : 7
/// ItemId : 16
/// DistributorId : 0
/// CategoryName : "Non ARB Item"
/// ItemName : "Installation charges"
/// CurrentStk : 99839

class GetArbCurrentStockListModel {
  GetArbCurrentStockListModel({
      num? categoryId, 
      num? itemId, 
      num? distributorId, 
      String? categoryName, 
      String? itemName, 
      num? currentStk,}){
    _categoryId = categoryId;
    _itemId = itemId;
    _distributorId = distributorId;
    _categoryName = categoryName;
    _itemName = itemName;
    _currentStk = currentStk;
}

  // GetArbCurrentStockListModel.fromJson(dynamic json) {
  //   _categoryId = json['CategoryId'];
  //   _itemId = json['ItemId'];
  //   _distributorId = json['DistributorId'];
  //   _categoryName = json['CategoryName'];
  //   _itemName = json['ItemName'];
  //   _currentStk = json['CurrentStk'];
  // }
  GetArbCurrentStockListModel.fromJson(dynamic json) {
    _categoryId = json['CategoryId'];
    _itemId = json['ItemId'];
    _distributorId = json['DistributorId'];
    _categoryName = json['CategoryName'];
    _itemName = json['ItemName'];
    _currentStk = _parseNum(json['CurrentStk']);
  }

  num? _categoryId;
  num? _itemId;
  num? _distributorId;
  String? _categoryName;
  String? _itemName;
  num? _currentStk;
GetArbCurrentStockListModel copyWith({  num? categoryId,
  num? itemId,
  num? distributorId,
  String? categoryName,
  String? itemName,
  num? currentStk,
}) => GetArbCurrentStockListModel(  categoryId: categoryId ?? _categoryId,
  itemId: itemId ?? _itemId,
  distributorId: distributorId ?? _distributorId,
  categoryName: categoryName ?? _categoryName,
  itemName: itemName ?? _itemName,
  currentStk: currentStk ?? _currentStk,
);
  num? get categoryId => _categoryId;
  num? get itemId => _itemId;
  num? get distributorId => _distributorId;
  String? get categoryName => _categoryName;
  String? get itemName => _itemName;
  num? get currentStk => _currentStk;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CategoryId'] = _categoryId;
    map['ItemId'] = _itemId;
    map['DistributorId'] = _distributorId;
    map['CategoryName'] = _categoryName;
    map['ItemName'] = _itemName;
    map['CurrentStk'] = _currentStk;
    return map;
  }
  num? _parseNum(dynamic value) {
    if (value == null) return 0; // Or null, based on your need
    if (value is num) return value;
    if (value is String && value.trim().isEmpty) return 0;
    return num.tryParse(value.toString()) ?? 0;
  }

}