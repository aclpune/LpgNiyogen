/// ItemId : 150
/// DistributorId : 8118
/// CategoryId : 5
/// CategoryName : "Other"
/// ItemCode : "19"
/// ItemName : "NAME CHANGE"
/// Rate : 500.0
/// Action : null
/// AddedBy : 0
/// ActiveStatus : 1
/// LastUpdatedOn : "2025-04-01T18:23:30.503"

class GetArbItemMasterListModel {
  GetArbItemMasterListModel({
      num? itemId, 
      num? distributorId, 
      num? categoryId, 
      String? categoryName, 
      String? itemCode, 
      String? itemName, 
      num? rate, 
      dynamic action, 
      num? addedBy, 
      num? activeStatus, 
      String? lastUpdatedOn,}){
    _itemId = itemId;
    _distributorId = distributorId;
    _categoryId = categoryId;
    _categoryName = categoryName;
    _itemCode = itemCode;
    _itemName = itemName;
    _rate = rate;
    _action = action;
    _addedBy = addedBy;
    _activeStatus = activeStatus;
    _lastUpdatedOn = lastUpdatedOn;
}

  GetArbItemMasterListModel.fromJson(dynamic json) {
    _itemId = json['ItemId'];
    _distributorId = json['DistributorId'];
    _categoryId = json['CategoryId'];
    _categoryName = json['CategoryName'];
    _itemCode = json['ItemCode'];
    _itemName = json['ItemName'];
    _rate = json['Rate'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
    _activeStatus = json['ActiveStatus'];
    _lastUpdatedOn = json['LastUpdatedOn'];
  }
  num? _itemId;
  num? _distributorId;
  num? _categoryId;
  String? _categoryName;
  String? _itemCode;
  String? _itemName;
  num? _rate;
  dynamic _action;
  num? _addedBy;
  num? _activeStatus;
  String? _lastUpdatedOn;
GetArbItemMasterListModel copyWith({  num? itemId,
  num? distributorId,
  num? categoryId,
  String? categoryName,
  String? itemCode,
  String? itemName,
  num? rate,
  dynamic action,
  num? addedBy,
  num? activeStatus,
  String? lastUpdatedOn,
}) => GetArbItemMasterListModel(  itemId: itemId ?? _itemId,
  distributorId: distributorId ?? _distributorId,
  categoryId: categoryId ?? _categoryId,
  categoryName: categoryName ?? _categoryName,
  itemCode: itemCode ?? _itemCode,
  itemName: itemName ?? _itemName,
  rate: rate ?? _rate,
  action: action ?? _action,
  addedBy: addedBy ?? _addedBy,
  activeStatus: activeStatus ?? _activeStatus,
  lastUpdatedOn: lastUpdatedOn ?? _lastUpdatedOn,
);
  num? get itemId => _itemId;
  num? get distributorId => _distributorId;
  num? get categoryId => _categoryId;
  String? get categoryName => _categoryName;
  String? get itemCode => _itemCode;
  String? get itemName => _itemName;
  num? get rate => _rate;
  dynamic get action => _action;
  num? get addedBy => _addedBy;
  num? get activeStatus => _activeStatus;
  String? get lastUpdatedOn => _lastUpdatedOn;



  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemId'] = _itemId;
    map['DistributorId'] = _distributorId;
    map['CategoryId'] = _categoryId;
    map['CategoryName'] = _categoryName;
    map['ItemCode'] = _itemCode;
    map['ItemName'] = _itemName;
    map['Rate'] = _rate;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    map['ActiveStatus'] = _activeStatus;
    map['LastUpdatedOn'] = _lastUpdatedOn;
    return map;
  }

}