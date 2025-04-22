/// DistributorId : 8118
/// IncomeId : 0
/// TransCate : null
/// Quantity : 0.0
/// UnsettQty : 0
/// SettQty : 0
/// Mode : null
/// Amount : 18000.00
/// ItemName : "19 KG"
/// ItemId : 2
/// Date : "0001-01-01T00:00:00"
/// StaffId : 24
/// StaffName : "Bhagwat"
/// Flag : 0
/// Qty : 10

class GetUnsettledAmountListModel {
  GetUnsettledAmountListModel({
      num? distributorId, 
      num? incomeId, 
      dynamic transCate, 
      num? quantity, 
      num? unsettQty, 
      num? settQty, 
      dynamic mode, 
      num? amount, 
      String? itemName, 
      num? itemId, 
      String? date, 
      num? staffId, 
      String? staffName, 
      num? flag, 
      num? qty,}){
    _distributorId = distributorId;
    _incomeId = incomeId;
    _transCate = transCate;
    _quantity = quantity;
    _unsettQty = unsettQty;
    _settQty = settQty;
    _mode = mode;
    _amount = amount;
    _itemName = itemName;
    _itemId = itemId;
    _date = date;
    _staffId = staffId;
    _staffName = staffName;
    _flag = flag;
    _qty = qty;
}

  GetUnsettledAmountListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _incomeId = json['IncomeId'];
    _transCate = json['TransCate'];
    _quantity = json['Quantity'];
    _unsettQty = json['UnsettQty'];
    _settQty = json['SettQty'];
    _mode = json['Mode'];
    _amount = json['Amount'];
    _itemName = json['ItemName'];
    _itemId = json['ItemId'];
    _date = json['Date'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _flag = json['Flag'];
    _qty = json['Qty'];
  }
  num? _distributorId;
  num? _incomeId;
  dynamic _transCate;
  num? _quantity;
  num? _unsettQty;
  num? _settQty;
  dynamic _mode;
  num? _amount;
  String? _itemName;
  num? _itemId;
  String? _date;
  num? _staffId;
  String? _staffName;
  num? _flag;
  num? _qty;
GetUnsettledAmountListModel copyWith({  num? distributorId,
  num? incomeId,
  dynamic transCate,
  num? quantity,
  num? unsettQty,
  num? settQty,
  dynamic mode,
  num? amount,
  String? itemName,
  num? itemId,
  String? date,
  num? staffId,
  String? staffName,
  num? flag,
  num? qty,
}) => GetUnsettledAmountListModel(  distributorId: distributorId ?? _distributorId,
  incomeId: incomeId ?? _incomeId,
  transCate: transCate ?? _transCate,
  quantity: quantity ?? _quantity,
  unsettQty: unsettQty ?? _unsettQty,
  settQty: settQty ?? _settQty,
  mode: mode ?? _mode,
  amount: amount ?? _amount,
  itemName: itemName ?? _itemName,
  itemId: itemId ?? _itemId,
  date: date ?? _date,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  flag: flag ?? _flag,
  qty: qty ?? _qty,
);
  num? get distributorId => _distributorId;
  num? get incomeId => _incomeId;
  dynamic get transCate => _transCate;
  num? get quantity => _quantity;
  num? get unsettQty => _unsettQty;
  num? get settQty => _settQty;
  dynamic get mode => _mode;
  num? get amount => _amount;
  String? get itemName => _itemName;
  num? get itemId => _itemId;
  String? get date => _date;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get flag => _flag;
  num? get qty => _qty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['IncomeId'] = _incomeId;
    map['TransCate'] = _transCate;
    map['Quantity'] = _quantity;
    map['UnsettQty'] = _unsettQty;
    map['SettQty'] = _settQty;
    map['Mode'] = _mode;
    map['Amount'] = _amount;
    map['ItemName'] = _itemName;
    map['ItemId'] = _itemId;
    map['Date'] = _date;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['Flag'] = _flag;
    map['Qty'] = _qty;
    return map;
  }

}