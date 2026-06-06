/// StkTransId : 3
/// DistributorId : 8118
/// StkTransDate : "2025-02-07T00:00:00"
/// FromGodownId : 1
/// ToGodownId : 24
/// ItemId : 4
/// ItemName : "2 Kg"
/// FilledStk : 20
/// EmptyStk : 0
/// DefectiveStk : 0
/// IsStkTrans : 0
/// Remark : "test"
/// AddedOn : "2025-02-07T09:04:32.03"
/// AddedBy : 61

class GetStockTransferListModel {
  GetStockTransferListModel({
      num? stkTransId, 
      num? distributorId, 
      String? stkTransDate, 
      num? fromGodownId, 
      num? toGodownId, 
      num? itemId, 
      String? itemName, 
      num? filledStk, 
      num? emptyStk, 
      num? defectiveStk, 
      num? isStkTrans, 
      String? remark, 
      String? addedOn, 
      num? addedBy,}){
    _stkTransId = stkTransId;
    _distributorId = distributorId;
    _stkTransDate = stkTransDate;
    _fromGodownId = fromGodownId;
    _toGodownId = toGodownId;
    _itemId = itemId;
    _itemName = itemName;
    _filledStk = filledStk;
    _emptyStk = emptyStk;
    _defectiveStk = defectiveStk;
    _isStkTrans = isStkTrans;
    _remark = remark;
    _addedOn = addedOn;
    _addedBy = addedBy;
}

  GetStockTransferListModel.fromJson(dynamic json) {
    _stkTransId = json['StkTransId'];
    _distributorId = json['DistributorId'];
    _stkTransDate = json['StkTransDate'];
    _fromGodownId = json['FromGodownId'];
    _toGodownId = json['ToGodownId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledStk = json['FilledStk'];
    _emptyStk = json['EmptyStk'];
    _defectiveStk = json['DefectiveStk'];
    _isStkTrans = json['IsStkTrans'];
    _remark = json['Remark'];
    _addedOn = json['AddedOn'];
    _addedBy = json['AddedBy'];
  }
  num? _stkTransId;
  num? _distributorId;
  String? _stkTransDate;
  num? _fromGodownId;
  num? _toGodownId;
  num? _itemId;
  String? _itemName;
  num? _filledStk;
  num? _emptyStk;
  num? _defectiveStk;
  num? _isStkTrans;
  String? _remark;
  String? _addedOn;
  num? _addedBy;
GetStockTransferListModel copyWith({  num? stkTransId,
  num? distributorId,
  String? stkTransDate,
  num? fromGodownId,
  num? toGodownId,
  num? itemId,
  String? itemName,
  num? filledStk,
  num? emptyStk,
  num? defectiveStk,
  num? isStkTrans,
  String? remark,
  String? addedOn,
  num? addedBy,
}) => GetStockTransferListModel(  stkTransId: stkTransId ?? _stkTransId,
  distributorId: distributorId ?? _distributorId,
  stkTransDate: stkTransDate ?? _stkTransDate,
  fromGodownId: fromGodownId ?? _fromGodownId,
  toGodownId: toGodownId ?? _toGodownId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledStk: filledStk ?? _filledStk,
  emptyStk: emptyStk ?? _emptyStk,
  defectiveStk: defectiveStk ?? _defectiveStk,
  isStkTrans: isStkTrans ?? _isStkTrans,
  remark: remark ?? _remark,
  addedOn: addedOn ?? _addedOn,
  addedBy: addedBy ?? _addedBy,
);
  num? get stkTransId => _stkTransId;
  num? get distributorId => _distributorId;
  String? get stkTransDate => _stkTransDate;
  num? get fromGodownId => _fromGodownId;
  num? get toGodownId => _toGodownId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledStk => _filledStk;
  num? get emptyStk => _emptyStk;
  num? get defectiveStk => _defectiveStk;
  num? get isStkTrans => _isStkTrans;
  String? get remark => _remark;
  String? get addedOn => _addedOn;
  num? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StkTransId'] = _stkTransId;
    map['DistributorId'] = _distributorId;
    map['StkTransDate'] = _stkTransDate;
    map['FromGodownId'] = _fromGodownId;
    map['ToGodownId'] = _toGodownId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledStk'] = _filledStk;
    map['EmptyStk'] = _emptyStk;
    map['DefectiveStk'] = _defectiveStk;
    map['IsStkTrans'] = _isStkTrans;
    map['Remark'] = _remark;
    map['AddedOn'] = _addedOn;
    map['AddedBy'] = _addedBy;
    return map;
  }

}