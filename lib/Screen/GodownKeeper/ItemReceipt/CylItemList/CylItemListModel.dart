  /// ItemId : 2
  /// DistributorId : 8118
  /// ItemName : "5kg"
  /// ItemDescription : "5kg filled cylinder"
  /// Action : null
  /// AddedBy : null
  /// IsActive : 1
  /// LastUpdatedOn : "2024-11-19T05:31:01.337"

  class CylItemListModel {
    CylItemListModel({
        num? itemId,
        num? distributorId,
        String? itemName,
        String? itemDescription,
        dynamic action,
        dynamic addedBy,
        num? isActive,
        String? lastUpdatedOn,}){
      _itemId = itemId;
      _distributorId = distributorId;
      _itemName = itemName;
      _itemDescription = itemDescription;
      _action = action;
      _addedBy = addedBy;
      _isActive = isActive;
      _lastUpdatedOn = lastUpdatedOn;
  }

    CylItemListModel.fromJson(dynamic json) {
      _itemId = json['ItemId'];
      _distributorId = json['DistributorId'];
      _itemName = json['ItemName'];
      _itemDescription = json['ItemDescription'];
      _action = json['Action'];
      _addedBy = json['AddedBy'];
      _isActive = json['IsActive'];
      _lastUpdatedOn = json['LastUpdatedOn'];
    }
    num? _itemId;
    num? _distributorId;
    String? _itemName;
    String? _itemDescription;
    dynamic _action;
    dynamic _addedBy;
    num? _isActive;
    String? _lastUpdatedOn;
  CylItemListModel copyWith({  num? itemId,
    num? distributorId,
    String? itemName,
    String? itemDescription,
    dynamic action,
    dynamic addedBy,
    num? isActive,
    String? lastUpdatedOn,
  }) => CylItemListModel(  itemId: itemId ?? _itemId,
    distributorId: distributorId ?? _distributorId,
    itemName: itemName ?? _itemName,
    itemDescription: itemDescription ?? _itemDescription,
    action: action ?? _action,
    addedBy: addedBy ?? _addedBy,
    isActive: isActive ?? _isActive,
    lastUpdatedOn: lastUpdatedOn ?? _lastUpdatedOn,
  );
    num? get itemId => _itemId;
    num? get distributorId => _distributorId;
    String? get itemName => _itemName;
    String? get itemDescription => _itemDescription;
    dynamic get action => _action;
    dynamic get addedBy => _addedBy;
    num? get isActive => _isActive;
    String? get lastUpdatedOn => _lastUpdatedOn;

    Map<String, dynamic> toJson() {
      final map = <String, dynamic>{};
      map['ItemId'] = _itemId;
      map['DistributorId'] = _distributorId;
      map['ItemName'] = _itemName;
      map['ItemDescription'] = _itemDescription;
      map['Action'] = _action;
      map['AddedBy'] = _addedBy;
      map['IsActive'] = _isActive;
      map['LastUpdatedOn'] = _lastUpdatedOn;
      return map;
    }

  }