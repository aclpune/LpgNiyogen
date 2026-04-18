/// ImbId : 77
/// DistributorId : 8118
/// GodownId : 20
/// ImbDate : "2026-04-16T00:00:00"
/// ItemId : 1
/// EntryType : "D"
/// ConsDMId : 35
/// ImbRecQty : 1
/// AddedBy : 0
/// Action : null
/// StaffName : "Punam singh Rathor"
/// CustomerName : null
/// ItemName : null

class ImbalanceTransactionHistoryListModel {
  ImbalanceTransactionHistoryListModel({
      num? imbId, 
      num? distributorId, 
      num? godownId, 
      String? imbDate, 
      num? itemId, 
      String? entryType, 
      num? consDMId, 
      num? imbRecQty, 
      num? addedBy, 
      dynamic action, 
      String? staffName, 
      dynamic customerName, 
      dynamic itemName,}){
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
    _itemName = itemName;
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
    _itemName = json['ItemName'];
  }
  num? _imbId;
  num? _distributorId;
  num? _godownId;
  String? _imbDate;
  num? _itemId;
  String? _entryType;
  num? _consDMId;
  num? _imbRecQty;
  num? _addedBy;
  dynamic _action;
  String? _staffName;
  dynamic _customerName;
  dynamic _itemName;
ImbalanceTransactionHistoryListModel copyWith({  num? imbId,
  num? distributorId,
  num? godownId,
  String? imbDate,
  num? itemId,
  String? entryType,
  num? consDMId,
  num? imbRecQty,
  num? addedBy,
  dynamic action,
  String? staffName,
  dynamic customerName,
  dynamic itemName,
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
  itemName: itemName ?? _itemName,
);
  num? get imbId => _imbId;
  num? get distributorId => _distributorId;
  num? get godownId => _godownId;
  String? get imbDate => _imbDate;
  num? get itemId => _itemId;
  String? get entryType => _entryType;
  num? get consDMId => _consDMId;
  num? get imbRecQty => _imbRecQty;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  String? get staffName => _staffName;
  dynamic get customerName => _customerName;
  dynamic get itemName => _itemName;

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
    map['ItemName'] = _itemName;
    return map;
  }

}