/// pkId : 12
/// DistributorId : 8118
/// PageName : ""
/// PermissionFor : "Vehicle Mapping"
/// DescriptionText : null
/// IsActive : 0
/// ActiveDate : "2025-05-22T16:56:10.153"
/// Action : null
/// AddedOn : "2025-05-22T16:56:10.153"
/// LastUpdatedOn : "2025-05-22T17:27:54.133"
/// ItemId : 0
/// ItemName : ""
/// Discount : 0.00

class CahsDenominationMandatoryFlagModel {
  CahsDenominationMandatoryFlagModel({
      num? pkId,
      num? distributorId,
      String? pageName,
      String? permissionFor,
      dynamic descriptionText,
      num? isActive,
      String? activeDate,
      dynamic action,
      String? addedOn,
      String? lastUpdatedOn,
      num? itemId,
      String? itemName,
      num? discount,}){
    _pkId = pkId;
    _distributorId = distributorId;
    _pageName = pageName;
    _permissionFor = permissionFor;
    _descriptionText = descriptionText;
    _isActive = isActive;
    _activeDate = activeDate;
    _action = action;
    _addedOn = addedOn;
    _lastUpdatedOn = lastUpdatedOn;
    _itemId = itemId;
    _itemName = itemName;
    _discount = discount;
}

  CahsDenominationMandatoryFlagModel.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _distributorId = json['DistributorId'];
    _pageName = json['PageName'];
    _permissionFor = json['PermissionFor'];
    _descriptionText = json['DescriptionText'];
    _isActive = json['IsActive'];
    _activeDate = json['ActiveDate'];
    _action = json['Action'];
    _addedOn = json['AddedOn'];
    _lastUpdatedOn = json['LastUpdatedOn'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _discount = json['Discount'];
  }
  num? _pkId;
  num? _distributorId;
  String? _pageName;
  String? _permissionFor;
  dynamic _descriptionText;
  num? _isActive;
  String? _activeDate;
  dynamic _action;
  String? _addedOn;
  String? _lastUpdatedOn;
  num? _itemId;
  String? _itemName;
  num? _discount;
CahsDenominationMandatoryFlagModel copyWith({  num? pkId,
  num? distributorId,
  String? pageName,
  String? permissionFor,
  dynamic descriptionText,
  num? isActive,
  String? activeDate,
  dynamic action,
  String? addedOn,
  String? lastUpdatedOn,
  num? itemId,
  String? itemName,
  num? discount,
}) => CahsDenominationMandatoryFlagModel(  pkId: pkId ?? _pkId,
  distributorId: distributorId ?? _distributorId,
  pageName: pageName ?? _pageName,
  permissionFor: permissionFor ?? _permissionFor,
  descriptionText: descriptionText ?? _descriptionText,
  isActive: isActive ?? _isActive,
  activeDate: activeDate ?? _activeDate,
  action: action ?? _action,
  addedOn: addedOn ?? _addedOn,
  lastUpdatedOn: lastUpdatedOn ?? _lastUpdatedOn,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  discount: discount ?? _discount,
);
  num? get pkId => _pkId;
  num? get distributorId => _distributorId;
  String? get pageName => _pageName;
  String? get permissionFor => _permissionFor;
  dynamic get descriptionText => _descriptionText;
  num? get isActive => _isActive;
  String? get activeDate => _activeDate;
  dynamic get action => _action;
  String? get addedOn => _addedOn;
  String? get lastUpdatedOn => _lastUpdatedOn;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get discount => _discount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['DistributorId'] = _distributorId;
    map['PageName'] = _pageName;
    map['PermissionFor'] = _permissionFor;
    map['DescriptionText'] = _descriptionText;
    map['IsActive'] = _isActive;
    map['ActiveDate'] = _activeDate;
    map['Action'] = _action;
    map['AddedOn'] = _addedOn;
    map['LastUpdatedOn'] = _lastUpdatedOn;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['Discount'] = _discount;
    return map;
  }

}