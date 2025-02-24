/// DistributorId : 0
/// IncomeId : 0
/// TransCate : "ARBSale"
/// Quantity : 1.0
/// UnsettQty : 0
/// SettQty : 0
/// Mode : null
/// Amount : 100.00
/// ItemName : "Prestige  Lighter"
/// ItemId : 38
/// Date : "0001-01-01T00:00:00"

class ManagerDsrReportIncomeSalesModel {
  ManagerDsrReportIncomeSalesModel({
      num? distributorId, 
      num? incomeId, 
      String? transCate, 
      num? quantity, 
      num? unsettQty, 
      num? settQty, 
      dynamic mode, 
      num? amount, 
      String? itemName, 
      num? itemId, 
      String? date,}){
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
}

  ManagerDsrReportIncomeSalesModel.fromJson(dynamic json) {
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
  }
  num? _distributorId;
  num? _incomeId;
  String? _transCate;
  num? _quantity;
  num? _unsettQty;
  num? _settQty;
  dynamic _mode;
  num? _amount;
  String? _itemName;
  num? _itemId;
  String? _date;
ManagerDsrReportIncomeSalesModel copyWith({  num? distributorId,
  num? incomeId,
  String? transCate,
  num? quantity,
  num? unsettQty,
  num? settQty,
  dynamic mode,
  num? amount,
  String? itemName,
  num? itemId,
  String? date,
}) => ManagerDsrReportIncomeSalesModel(  distributorId: distributorId ?? _distributorId,
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
);
  num? get distributorId => _distributorId;
  num? get incomeId => _incomeId;
  String? get transCate => _transCate;
  num? get quantity => _quantity;
  num? get unsettQty => _unsettQty;
  num? get settQty => _settQty;
  dynamic get mode => _mode;
  num? get amount => _amount;
  String? get itemName => _itemName;
  num? get itemId => _itemId;
  String? get date => _date;

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
    return map;
  }

}