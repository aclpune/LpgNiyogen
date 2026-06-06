/// DistributorId : 8118
/// Transdate : "0001-01-01T00:00:00"
/// ItemId : 1
/// ItemName : "14.2 Kg"
/// RSPPrice : 0.0
/// StaffId : 29
/// StaffName : "Shivaji Jambhale"
/// TotalSaleQty : 0
/// DelSVQty : 0
/// UnsettQty : 0
/// UnsettSaleAmt : 0.00

class UnsettledSaleListModel {
  UnsettledSaleListModel({
      num? distributorId, 
      String? transdate, 
      num? itemId, 
      String? itemName, 
      num? rSPPrice, 
      num? staffId, 
      String? staffName, 
      num? totalSaleQty, 
      num? delSVQty, 
      num? unsettQty, 
      num? unsettSaleAmt,}){
    _distributorId = distributorId;
    _transdate = transdate;
    _itemId = itemId;
    _itemName = itemName;
    _rSPPrice = rSPPrice;
    _staffId = staffId;
    _staffName = staffName;
    _totalSaleQty = totalSaleQty;
    _delSVQty = delSVQty;
    _unsettQty = unsettQty;
    _unsettSaleAmt = unsettSaleAmt;
}

  UnsettledSaleListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _transdate = json['Transdate'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _rSPPrice = json['RSPPrice'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _totalSaleQty = json['TotalSaleQty'];
    _delSVQty = json['DelSVQty'];
    _unsettQty = json['UnsettQty'];
    _unsettSaleAmt = json['UnsettSaleAmt'];
  }
  num? _distributorId;
  String? _transdate;
  num? _itemId;
  String? _itemName;
  num? _rSPPrice;
  num? _staffId;
  String? _staffName;
  num? _totalSaleQty;
  num? _delSVQty;
  num? _unsettQty;
  num? _unsettSaleAmt;
UnsettledSaleListModel copyWith({  num? distributorId,
  String? transdate,
  num? itemId,
  String? itemName,
  num? rSPPrice,
  num? staffId,
  String? staffName,
  num? totalSaleQty,
  num? delSVQty,
  num? unsettQty,
  num? unsettSaleAmt,
}) => UnsettledSaleListModel(  distributorId: distributorId ?? _distributorId,
  transdate: transdate ?? _transdate,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  rSPPrice: rSPPrice ?? _rSPPrice,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  totalSaleQty: totalSaleQty ?? _totalSaleQty,
  delSVQty: delSVQty ?? _delSVQty,
  unsettQty: unsettQty ?? _unsettQty,
  unsettSaleAmt: unsettSaleAmt ?? _unsettSaleAmt,
);
  num? get distributorId => _distributorId;
  String? get transdate => _transdate;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rSPPrice => _rSPPrice;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get totalSaleQty => _totalSaleQty;
  num? get delSVQty => _delSVQty;
  num? get unsettQty => _unsettQty;
  num? get unsettSaleAmt => _unsettSaleAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['Transdate'] = _transdate;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['RSPPrice'] = _rSPPrice;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['TotalSaleQty'] = _totalSaleQty;
    map['DelSVQty'] = _delSVQty;
    map['UnsettQty'] = _unsettQty;
    map['UnsettSaleAmt'] = _unsettSaleAmt;
    return map;
  }

}