/// ItemId : 5
/// DistributorId : 8118
/// ItemName : "2 KG FTL"
/// ItemTypeFilter : "Cylinder"
/// ItemType : "C"
/// ItemDescription : "2 KG ND CYL"
/// Action : null
/// AddedBy : 0
/// IsActive : 1
/// LastUpdatedOn : "2025-04-16T14:17:23.607"
/// ItemSubType : "ND"

class GetItemMasterListModel {
  GetItemMasterListModel({
      num? itemId, 
      num? distributorId, 
      String? itemName, 
      String? itemTypeFilter, 
      String? itemType, 
      String? itemDescription, 
      dynamic action, 
      num? addedBy, 
      num? isActive, 
      String? lastUpdatedOn, 
      String? itemSubType,}){
    _itemId = itemId;
    _distributorId = distributorId;
    _itemName = itemName;
    _itemTypeFilter = itemTypeFilter;
    _itemType = itemType;
    _itemDescription = itemDescription;
    _action = action;
    _addedBy = addedBy;
    _isActive = isActive;
    _lastUpdatedOn = lastUpdatedOn;
    _itemSubType = itemSubType;
}

  GetItemMasterListModel.fromJson(dynamic json) {
    _itemId = json['ItemId'];
    _distributorId = json['DistributorId'];
    _itemName = json['ItemName'];
    _itemTypeFilter = json['ItemTypeFilter'];
    _itemType = json['ItemType'];
    _itemDescription = json['ItemDescription'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
    _isActive = json['IsActive'];
    _lastUpdatedOn = json['LastUpdatedOn'];
    _itemSubType = json['ItemSubType'];
  }
  num? _itemId;
  num? _distributorId;
  String? _itemName;
  String? _itemTypeFilter;
  String? _itemType;
  String? _itemDescription;
  dynamic _action;
  num? _addedBy;
  num? _isActive;
  String? _lastUpdatedOn;
  String? _itemSubType;
GetItemMasterListModel copyWith({  num? itemId,
  num? distributorId,
  String? itemName,
  String? itemTypeFilter,
  String? itemType,
  String? itemDescription,
  dynamic action,
  num? addedBy,
  num? isActive,
  String? lastUpdatedOn,
  String? itemSubType,
}) => GetItemMasterListModel(  itemId: itemId ?? _itemId,
  distributorId: distributorId ?? _distributorId,
  itemName: itemName ?? _itemName,
  itemTypeFilter: itemTypeFilter ?? _itemTypeFilter,
  itemType: itemType ?? _itemType,
  itemDescription: itemDescription ?? _itemDescription,
  action: action ?? _action,
  addedBy: addedBy ?? _addedBy,
  isActive: isActive ?? _isActive,
  lastUpdatedOn: lastUpdatedOn ?? _lastUpdatedOn,
  itemSubType: itemSubType ?? _itemSubType,
);
  num? get itemId => _itemId;
  num? get distributorId => _distributorId;
  String? get itemName => _itemName;
  String? get itemTypeFilter => _itemTypeFilter;
  String? get itemType => _itemType;
  String? get itemDescription => _itemDescription;
  dynamic get action => _action;
  num? get addedBy => _addedBy;
  num? get isActive => _isActive;
  String? get lastUpdatedOn => _lastUpdatedOn;
  String? get itemSubType => _itemSubType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ItemId'] = _itemId;
    map['DistributorId'] = _distributorId;
    map['ItemName'] = _itemName;
    map['ItemTypeFilter'] = _itemTypeFilter;
    map['ItemType'] = _itemType;
    map['ItemDescription'] = _itemDescription;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    map['IsActive'] = _isActive;
    map['LastUpdatedOn'] = _lastUpdatedOn;
    map['ItemSubType'] = _itemSubType;
    return map;
  }

}