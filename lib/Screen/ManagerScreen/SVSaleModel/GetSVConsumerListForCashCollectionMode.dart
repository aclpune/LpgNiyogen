/// DistributorId : 0
/// pkId : 0
/// SVTVDate : "2025-03-15T15:50:13"
/// ConsumerNo : null
/// DCChallanNo : "3929"
/// ConsumerName : "SUNITA SONZARI"
/// CylQty : 1
/// StaffId : 0
/// SaleGKId : 0
/// SaleGKItemId : 0
/// ConsumerNoStr : null
/// FlagForSVTV : null
/// AddedBy : 0

class GetSvConsumerListForCashCollectionMode {
  GetSvConsumerListForCashCollectionMode({
      num? distributorId, 
      num? pkId, 
      String? sVTVDate, 
      dynamic consumerNo, 
      String? dCChallanNo, 
      String? consumerName, 
      num? cylQty, 
      num? staffId, 
      num? saleGKId, 
      num? saleGKItemId, 
      dynamic consumerNoStr, 
      dynamic flagForSVTV, 
      num? addedBy,}){
    _distributorId = distributorId;
    _pkId = pkId;
    _sVTVDate = sVTVDate;
    _consumerNo = consumerNo;
    _dCChallanNo = dCChallanNo;
    _consumerName = consumerName;
    _cylQty = cylQty;
    _staffId = staffId;
    _saleGKId = saleGKId;
    _saleGKItemId = saleGKItemId;
    _consumerNoStr = consumerNoStr;
    _flagForSVTV = flagForSVTV;
    _addedBy = addedBy;
}

  GetSvConsumerListForCashCollectionMode.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _pkId = json['pkId'];
    _sVTVDate = json['SVTVDate'];
    _consumerNo = json['ConsumerNo'];
    _dCChallanNo = json['DCChallanNo'];
    _consumerName = json['ConsumerName'];
    _cylQty = json['CylQty'];
    _staffId = json['StaffId'];
    _saleGKId = json['SaleGKId'];
    _saleGKItemId = json['SaleGKItemId'];
    _consumerNoStr = json['ConsumerNoStr'];
    _flagForSVTV = json['FlagForSVTV'];
    _addedBy = json['AddedBy'];
  }
  num? _distributorId;
  num? _pkId;
  String? _sVTVDate;
  dynamic _consumerNo;
  String? _dCChallanNo;
  String? _consumerName;
  num? _cylQty;
  num? _staffId;
  num? _saleGKId;
  num? _saleGKItemId;
  dynamic _consumerNoStr;
  dynamic _flagForSVTV;
  num? _addedBy;
GetSvConsumerListForCashCollectionMode copyWith({  num? distributorId,
  num? pkId,
  String? sVTVDate,
  dynamic consumerNo,
  String? dCChallanNo,
  String? consumerName,
  num? cylQty,
  num? staffId,
  num? saleGKId,
  num? saleGKItemId,
  dynamic consumerNoStr,
  dynamic flagForSVTV,
  num? addedBy,
}) => GetSvConsumerListForCashCollectionMode(  distributorId: distributorId ?? _distributorId,
  pkId: pkId ?? _pkId,
  sVTVDate: sVTVDate ?? _sVTVDate,
  consumerNo: consumerNo ?? _consumerNo,
  dCChallanNo: dCChallanNo ?? _dCChallanNo,
  consumerName: consumerName ?? _consumerName,
  cylQty: cylQty ?? _cylQty,
  staffId: staffId ?? _staffId,
  saleGKId: saleGKId ?? _saleGKId,
  saleGKItemId: saleGKItemId ?? _saleGKItemId,
  consumerNoStr: consumerNoStr ?? _consumerNoStr,
  flagForSVTV: flagForSVTV ?? _flagForSVTV,
  addedBy: addedBy ?? _addedBy,
);
  num? get distributorId => _distributorId;
  num? get pkId => _pkId;
  String? get sVTVDate => _sVTVDate;
  dynamic get consumerNo => _consumerNo;
  String? get dCChallanNo => _dCChallanNo;
  String? get consumerName => _consumerName;
  num? get cylQty => _cylQty;
  num? get staffId => _staffId;
  num? get saleGKId => _saleGKId;
  num? get saleGKItemId => _saleGKItemId;
  dynamic get consumerNoStr => _consumerNoStr;
  dynamic get flagForSVTV => _flagForSVTV;
  num? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['pkId'] = _pkId;
    map['SVTVDate'] = _sVTVDate;
    map['ConsumerNo'] = _consumerNo;
    map['DCChallanNo'] = _dCChallanNo;
    map['ConsumerName'] = _consumerName;
    map['CylQty'] = _cylQty;
    map['StaffId'] = _staffId;
    map['SaleGKId'] = _saleGKId;
    map['SaleGKItemId'] = _saleGKItemId;
    map['ConsumerNoStr'] = _consumerNoStr;
    map['FlagForSVTV'] = _flagForSVTV;
    map['AddedBy'] = _addedBy;
    return map;
  }

}