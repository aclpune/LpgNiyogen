/// DistributorId : 0
/// IncomeId : 0
/// TransCate : "ARB-SV"
/// Quantity : 6.0
/// UnsettQty : 0
/// SettQty : 0
/// Mode : null
/// Amount : 5133.00
/// ItemName : "14.2 Kg - Refill"
/// ItemId : 1
/// Date : "0001-01-01T00:00:00"
/// Seq : 1

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
      String? date, 
      num? seq,}){
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
    _seq = seq;
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
    _seq = json['Seq'];
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
  num? _seq;
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
  num? seq,
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
  seq: seq ?? _seq,
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
  num? get seq => _seq;

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
    map['Seq'] = _seq;
    return map;
  }

}