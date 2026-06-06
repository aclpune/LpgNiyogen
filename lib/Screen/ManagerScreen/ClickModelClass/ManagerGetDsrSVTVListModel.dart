/// DistributorId : 0
/// TransCate : "SV"
/// Quantity : 1
/// Mode : null
/// Amount : 5705.50
/// ItemName : "14.2 KG"
/// ItemId : 1
/// Date : "0001-01-01T00:00:00"
/// SVType : "DBC"
/// TransDate : "2025-08-29T00:00:00"
/// TotalSaleQty : 1

class ManagerGetDsrSvtvListModel {
  ManagerGetDsrSvtvListModel({
      num? distributorId, 
      String? transCate, 
      num? quantity, 
      dynamic mode, 
      num? amount, 
      String? itemName, 
      num? itemId, 
      String? date, 
      String? sVType, 
      String? transDate, 
      num? totalSaleQty,}){
    _distributorId = distributorId;
    _transCate = transCate;
    _quantity = quantity;
    _mode = mode;
    _amount = amount;
    _itemName = itemName;
    _itemId = itemId;
    _date = date;
    _sVType = sVType;
    _transDate = transDate;
    _totalSaleQty = totalSaleQty;
}

  ManagerGetDsrSvtvListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _transCate = json['TransCate'];
    _quantity = json['Quantity'];
    _mode = json['Mode'];
    _amount = json['Amount'];
    _itemName = json['ItemName'];
    _itemId = json['ItemId'];
    _date = json['Date'];
    _sVType = json['SVType'];
    _transDate = json['TransDate'];
    _totalSaleQty = json['TotalSaleQty'];
  }
  num? _distributorId;
  String? _transCate;
  num? _quantity;
  dynamic _mode;
  num? _amount;
  String? _itemName;
  num? _itemId;
  String? _date;
  String? _sVType;
  String? _transDate;
  num? _totalSaleQty;
ManagerGetDsrSvtvListModel copyWith({  num? distributorId,
  String? transCate,
  num? quantity,
  dynamic mode,
  num? amount,
  String? itemName,
  num? itemId,
  String? date,
  String? sVType,
  String? transDate,
  num? totalSaleQty,
}) => ManagerGetDsrSvtvListModel(  distributorId: distributorId ?? _distributorId,
  transCate: transCate ?? _transCate,
  quantity: quantity ?? _quantity,
  mode: mode ?? _mode,
  amount: amount ?? _amount,
  itemName: itemName ?? _itemName,
  itemId: itemId ?? _itemId,
  date: date ?? _date,
  sVType: sVType ?? _sVType,
  transDate: transDate ?? _transDate,
  totalSaleQty: totalSaleQty ?? _totalSaleQty,
);
  num? get distributorId => _distributorId;
  String? get transCate => _transCate;
  num? get quantity => _quantity;
  dynamic get mode => _mode;
  num? get amount => _amount;
  String? get itemName => _itemName;
  num? get itemId => _itemId;
  String? get date => _date;
  String? get sVType => _sVType;
  String? get transDate => _transDate;
  num? get totalSaleQty => _totalSaleQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['TransCate'] = _transCate;
    map['Quantity'] = _quantity;
    map['Mode'] = _mode;
    map['Amount'] = _amount;
    map['ItemName'] = _itemName;
    map['ItemId'] = _itemId;
    map['Date'] = _date;
    map['SVType'] = _sVType;
    map['TransDate'] = _transDate;
    map['TotalSaleQty'] = _totalSaleQty;
    return map;
  }

}