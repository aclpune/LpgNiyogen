/// GodownId : 24
/// DistributorId : 8118
/// DistributorCode : 0
/// DistributorName : null
/// GodownNo : "GN124"
/// GodownCapacity : 5000
/// GodownAddress : "Pune"
/// GodownKeeperId : 0
/// GodownKeeperName : null
/// isActive : 1
/// AddedBy : 0
/// Action : null
/// LatsUpdatedOn : "2025-02-01T05:19:12.597"

class GetGodownListModel {
  GetGodownListModel({
      num? godownId, 
      num? distributorId, 
      num? distributorCode, 
      dynamic distributorName, 
      String? godownNo, 
      num? godownCapacity, 
      String? godownAddress, 
      num? godownKeeperId, 
      dynamic godownKeeperName, 
      num? isActive, 
      num? addedBy, 
      dynamic action, 
      String? latsUpdatedOn,}){
    _godownId = godownId;
    _distributorId = distributorId;
    _distributorCode = distributorCode;
    _distributorName = distributorName;
    _godownNo = godownNo;
    _godownCapacity = godownCapacity;
    _godownAddress = godownAddress;
    _godownKeeperId = godownKeeperId;
    _godownKeeperName = godownKeeperName;
    _isActive = isActive;
    _addedBy = addedBy;
    _action = action;
    _latsUpdatedOn = latsUpdatedOn;
}

  GetGodownListModel.fromJson(dynamic json) {
    _godownId = json['GodownId'];
    _distributorId = json['DistributorId'];
    _distributorCode = json['DistributorCode'];
    _distributorName = json['DistributorName'];
    _godownNo = json['GodownNo'];
    _godownCapacity = json['GodownCapacity'];
    _godownAddress = json['GodownAddress'];
    _godownKeeperId = json['GodownKeeperId'];
    _godownKeeperName = json['GodownKeeperName'];
    _isActive = json['isActive'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
    _latsUpdatedOn = json['LatsUpdatedOn'];
  }
  num? _godownId;
  num? _distributorId;
  num? _distributorCode;
  dynamic _distributorName;
  String? _godownNo;
  num? _godownCapacity;
  String? _godownAddress;
  num? _godownKeeperId;
  dynamic _godownKeeperName;
  num? _isActive;
  num? _addedBy;
  dynamic _action;
  String? _latsUpdatedOn;
GetGodownListModel copyWith({  num? godownId,
  num? distributorId,
  num? distributorCode,
  dynamic distributorName,
  String? godownNo,
  num? godownCapacity,
  String? godownAddress,
  num? godownKeeperId,
  dynamic godownKeeperName,
  num? isActive,
  num? addedBy,
  dynamic action,
  String? latsUpdatedOn,
}) => GetGodownListModel(  godownId: godownId ?? _godownId,
  distributorId: distributorId ?? _distributorId,
  distributorCode: distributorCode ?? _distributorCode,
  distributorName: distributorName ?? _distributorName,
  godownNo: godownNo ?? _godownNo,
  godownCapacity: godownCapacity ?? _godownCapacity,
  godownAddress: godownAddress ?? _godownAddress,
  godownKeeperId: godownKeeperId ?? _godownKeeperId,
  godownKeeperName: godownKeeperName ?? _godownKeeperName,
  isActive: isActive ?? _isActive,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
  latsUpdatedOn: latsUpdatedOn ?? _latsUpdatedOn,
);
  num? get godownId => _godownId;
  num? get distributorId => _distributorId;
  num? get distributorCode => _distributorCode;
  dynamic get distributorName => _distributorName;
  String? get godownNo => _godownNo;
  num? get godownCapacity => _godownCapacity;
  String? get godownAddress => _godownAddress;
  num? get godownKeeperId => _godownKeeperId;
  dynamic get godownKeeperName => _godownKeeperName;
  num? get isActive => _isActive;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  String? get latsUpdatedOn => _latsUpdatedOn;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['GodownId'] = _godownId;
    map['DistributorId'] = _distributorId;
    map['DistributorCode'] = _distributorCode;
    map['DistributorName'] = _distributorName;
    map['GodownNo'] = _godownNo;
    map['GodownCapacity'] = _godownCapacity;
    map['GodownAddress'] = _godownAddress;
    map['GodownKeeperId'] = _godownKeeperId;
    map['GodownKeeperName'] = _godownKeeperName;
    map['isActive'] = _isActive;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    map['LatsUpdatedOn'] = _latsUpdatedOn;
    return map;
  }

}