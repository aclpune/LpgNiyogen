/// ExpHeadId : 10170
/// DistributorId : 8118
/// ExpHeadName : "Transportation/courier"
/// ParentHeadId : 3
/// ParentHeadName : "Operational Expenses"
/// AddedBy : 0
/// IsActive : 1
/// Action : null

class GetExpenseHeaderListModel {
  GetExpenseHeaderListModel({
      num? expHeadId, 
      num? distributorId, 
      String? expHeadName, 
      num? parentHeadId, 
      String? parentHeadName, 
      num? addedBy, 
      num? isActive, 
      dynamic action,}){
    _expHeadId = expHeadId;
    _distributorId = distributorId;
    _expHeadName = expHeadName;
    _parentHeadId = parentHeadId;
    _parentHeadName = parentHeadName;
    _addedBy = addedBy;
    _isActive = isActive;
    _action = action;
}

  GetExpenseHeaderListModel.fromJson(dynamic json) {
    _expHeadId = json['ExpHeadId'];
    _distributorId = json['DistributorId'];
    _expHeadName = json['ExpHeadName'];
    _parentHeadId = json['ParentHeadId'];
    _parentHeadName = json['ParentHeadName'];
    _addedBy = json['AddedBy'];
    _isActive = json['IsActive'];
    _action = json['Action'];
  }
  num? _expHeadId;
  num? _distributorId;
  String? _expHeadName;
  num? _parentHeadId;
  String? _parentHeadName;
  num? _addedBy;
  num? _isActive;
  dynamic _action;
GetExpenseHeaderListModel copyWith({  num? expHeadId,
  num? distributorId,
  String? expHeadName,
  num? parentHeadId,
  String? parentHeadName,
  num? addedBy,
  num? isActive,
  dynamic action,
}) => GetExpenseHeaderListModel(  expHeadId: expHeadId ?? _expHeadId,
  distributorId: distributorId ?? _distributorId,
  expHeadName: expHeadName ?? _expHeadName,
  parentHeadId: parentHeadId ?? _parentHeadId,
  parentHeadName: parentHeadName ?? _parentHeadName,
  addedBy: addedBy ?? _addedBy,
  isActive: isActive ?? _isActive,
  action: action ?? _action,
);
  num? get expHeadId => _expHeadId;
  num? get distributorId => _distributorId;
  String? get expHeadName => _expHeadName;
  num? get parentHeadId => _parentHeadId;
  String? get parentHeadName => _parentHeadName;
  num? get addedBy => _addedBy;
  num? get isActive => _isActive;
  dynamic get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ExpHeadId'] = _expHeadId;
    map['DistributorId'] = _distributorId;
    map['ExpHeadName'] = _expHeadName;
    map['ParentHeadId'] = _parentHeadId;
    map['ParentHeadName'] = _parentHeadName;
    map['AddedBy'] = _addedBy;
    map['IsActive'] = _isActive;
    map['Action'] = _action;
    return map;
  }

}