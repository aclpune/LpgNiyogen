/// DistributorId : 8118
/// DMId : 44
/// ItemId : 1
/// ItemName : "14.2 KG"
/// ImbQty : 0
/// RecQty : 0
/// BalImbQty : 28
/// CustId : 0
/// EntryType : "D"
/// StaffName : null
/// CustomerName : null

class ImabalanceEmptyListModel {
  ImabalanceEmptyListModel({
    num? distributorId,
    num? dMId,
    num? itemId,
    String? itemName,
    num? imbQty,
    num? recQty,
    num? balImbQty,
    num? custId,
    String? entryType,
    dynamic staffName,
    dynamic customerName,}){
    _distributorId = distributorId;
    _dMId = dMId;
    _itemId = itemId;
    _itemName = itemName;
    _imbQty = imbQty;
    _recQty = recQty;
    _balImbQty = balImbQty;
    _custId = custId;
    _entryType = entryType;
    _staffName = staffName;
    _customerName = customerName;
  }

  ImabalanceEmptyListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _dMId = json['DMId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _imbQty = json['ImbQty'];
    _recQty = json['RecQty'];
    _balImbQty = json['BalImbQty'];
    _custId = json['CustId'];
    _entryType = json['EntryType'];
    _staffName = json['StaffName'];
    _customerName = json['CustomerName'];
  }
  num? _distributorId;
  num? _dMId;
  num? _itemId;
  String? _itemName;
  num? _imbQty;
  num? _recQty;
  num? _balImbQty;
  num? _custId;
  String? _entryType;
  dynamic _staffName;
  dynamic _customerName;
  ImabalanceEmptyListModel copyWith({  num? distributorId,
    num? dMId,
    num? itemId,
    String? itemName,
    num? imbQty,
    num? recQty,
    num? balImbQty,
    num? custId,
    String? entryType,
    dynamic staffName,
    dynamic customerName,
  }) => ImabalanceEmptyListModel(  distributorId: distributorId ?? _distributorId,
    dMId: dMId ?? _dMId,
    itemId: itemId ?? _itemId,
    itemName: itemName ?? _itemName,
    imbQty: imbQty ?? _imbQty,
    recQty: recQty ?? _recQty,
    balImbQty: balImbQty ?? _balImbQty,
    custId: custId ?? _custId,
    entryType: entryType ?? _entryType,
    staffName: staffName ?? _staffName,
    customerName: customerName ?? _customerName,
  );
  num? get distributorId => _distributorId;
  num? get dMId => _dMId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get imbQty => _imbQty;
  num? get recQty => _recQty;
  num? get balImbQty => _balImbQty;
  num? get custId => _custId;
  String? get entryType => _entryType;
  dynamic get staffName => _staffName;
  dynamic get customerName => _customerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['DMId'] = _dMId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ImbQty'] = _imbQty;
    map['RecQty'] = _recQty;
    map['BalImbQty'] = _balImbQty;
    map['CustId'] = _custId;
    map['EntryType'] = _entryType;
    map['StaffName'] = _staffName;
    map['CustomerName'] = _customerName;
    return map;
  }

}