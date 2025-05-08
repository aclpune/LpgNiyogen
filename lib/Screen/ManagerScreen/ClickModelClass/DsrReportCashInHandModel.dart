/// DistributorId : 8118
/// Date : null
/// StaffId : 0
/// ItemName : "14.2 KG- Daily Sale"
/// totalAmount : 15304.50
/// ItemId : 0
/// TransCate : null

class DsrReportCashInHandModel {
  DsrReportCashInHandModel({
      num? distributorId, 
      dynamic date, 
      num? staffId, 
      String? itemName, 
      num? totalAmount, 
      num? itemId, 
      dynamic transCate,}){
    _distributorId = distributorId;
    _date = date;
    _staffId = staffId;
    _itemName = itemName;
    _totalAmount = totalAmount;
    _itemId = itemId;
    _transCate = transCate;
}

  DsrReportCashInHandModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _date = json['Date'];
    _staffId = json['StaffId'];
    _itemName = json['ItemName'];
    _totalAmount = json['totalAmount'];
    _itemId = json['ItemId'];
    _transCate = json['TransCate'];
  }
  num? _distributorId;
  dynamic _date;
  num? _staffId;
  String? _itemName;
  num? _totalAmount;
  num? _itemId;
  dynamic _transCate;
DsrReportCashInHandModel copyWith({  num? distributorId,
  dynamic date,
  num? staffId,
  String? itemName,
  num? totalAmount,
  num? itemId,
  dynamic transCate,
}) => DsrReportCashInHandModel(  distributorId: distributorId ?? _distributorId,
  date: date ?? _date,
  staffId: staffId ?? _staffId,
  itemName: itemName ?? _itemName,
  totalAmount: totalAmount ?? _totalAmount,
  itemId: itemId ?? _itemId,
  transCate: transCate ?? _transCate,
);
  num? get distributorId => _distributorId;
  dynamic get date => _date;
  num? get staffId => _staffId;
  String? get itemName => _itemName;
  num? get totalAmount => _totalAmount;
  num? get itemId => _itemId;
  dynamic get transCate => _transCate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['Date'] = _date;
    map['StaffId'] = _staffId;
    map['ItemName'] = _itemName;
    map['totalAmount'] = _totalAmount;
    map['ItemId'] = _itemId;
    map['TransCate'] = _transCate;
    return map;
  }

}