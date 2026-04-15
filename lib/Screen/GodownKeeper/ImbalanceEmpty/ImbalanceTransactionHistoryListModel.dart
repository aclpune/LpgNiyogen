/// ImbId : 53
/// DistributorId : 8118
/// GodownId : 20
/// ImbDate : "2026-04-14T00:00:00"
/// ItemId : 1
/// EntryType : null
/// ConsDMId : 44
/// ImbRecQty : 5
/// AddedBy : 0
/// Action : null
/// StaffName : null
/// CustomerName : null

class ImbalanceTransactionHistoryListModel {
  ImbalanceTransactionHistoryListModel({
      num? imbId, 
      num? distributorId, 
      num? godownId, 
      String? imbDate, 
      num? itemId, 
      dynamic entryType, 
      num? consDMId, 
      num? imbRecQty, 
      num? addedBy, 
      dynamic action, 
      dynamic staffName, 
      dynamic customerName,}){
    _imbId = imbId;
    _distributorId = distributorId;
    _godownId = godownId;
    _imbDate = imbDate;
    _itemId = itemId;
    _entryType = entryType;
    _consDMId = consDMId;
    _imbRecQty = imbRecQty;
    _addedBy = addedBy;
    _action = action;
    _staffName = staffName;
    _customerName = customerName;
}

  ImbalanceTransactionHistoryListModel.fromJson(dynamic json) {
    _imbId = json['ImbId'];
    _distributorId = json['DistributorId'];
    _godownId = json['GodownId'];
    _imbDate = json['ImbDate'];
    _itemId = json['ItemId'];
    _entryType = json['EntryType'];
    _consDMId = json['ConsDMId'];
    _imbRecQty = json['ImbRecQty'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
    _staffName = json['StaffName'];
    _customerName = json['CustomerName'];
  }
  num? _imbId;
  num? _distributorId;
  num? _godownId;
  String? _imbDate;
  num? _itemId;
  dynamic _entryType;
  num? _consDMId;
  num? _imbRecQty;
  num? _addedBy;
  dynamic _action;
  dynamic _staffName;
  dynamic _customerName;
ImbalanceTransactionHistoryListModel copyWith({  num? imbId,
  num? distributorId,
  num? godownId,
  String? imbDate,
  num? itemId,
  dynamic entryType,
  num? consDMId,
  num? imbRecQty,
  num? addedBy,
  dynamic action,
  dynamic staffName,
  dynamic customerName,
}) => ImbalanceTransactionHistoryListModel(  imbId: imbId ?? _imbId,
  distributorId: distributorId ?? _distributorId,
  godownId: godownId ?? _godownId,
  imbDate: imbDate ?? _imbDate,
  itemId: itemId ?? _itemId,
  entryType: entryType ?? _entryType,
  consDMId: consDMId ?? _consDMId,
  imbRecQty: imbRecQty ?? _imbRecQty,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
  staffName: staffName ?? _staffName,
  customerName: customerName ?? _customerName,
);
  num? get imbId => _imbId;
  num? get distributorId => _distributorId;
  num? get godownId => _godownId;
  String? get imbDate => _imbDate;
  num? get itemId => _itemId;
  dynamic get entryType => _entryType;
  num? get consDMId => _consDMId;
  num? get imbRecQty => _imbRecQty;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  dynamic get staffName => _staffName;
  dynamic get customerName => _customerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ImbId'] = _imbId;
    map['DistributorId'] = _distributorId;
    map['GodownId'] = _godownId;
    map['ImbDate'] = _imbDate;
    map['ItemId'] = _itemId;
    map['EntryType'] = _entryType;
    map['ConsDMId'] = _consDMId;
    map['ImbRecQty'] = _imbRecQty;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    map['StaffName'] = _staffName;
    map['CustomerName'] = _customerName;
    return map;
  }

}