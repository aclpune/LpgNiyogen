/// DistributorId : 0
/// pkId : 0
/// SVTVDate : "2025-02-04T00:00:00"
/// ConsumerNo : "234234"
/// ConsumerName : null
/// CylQty : 2
/// StaffId : 0
/// SaleGKId : 0
/// SaleGKItemId : 0
/// ConsumerNoStr : null
/// FlagForSVTV : null
/// AddedBy : 0

class GetSvtvConsumerListModel {
  GetSvtvConsumerListModel({
      num? distributorId, 
      num? pkId, 
      String? sVTVDate, 
      String? consumerNo, 
      dynamic consumerName, 
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
    _consumerName = consumerName;
    _cylQty = cylQty;
    _staffId = staffId;
    _saleGKId = saleGKId;
    _saleGKItemId = saleGKItemId;
    _consumerNoStr = consumerNoStr;
    _flagForSVTV = flagForSVTV;
    _addedBy = addedBy;
}

  GetSvtvConsumerListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _pkId = json['pkId'];
    _sVTVDate = json['SVTVDate'];
    _consumerNo = json['ConsumerNo'];
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
  String? _consumerNo;
  dynamic _consumerName;
  num? _cylQty;
  num? _staffId;
  num? _saleGKId;
  num? _saleGKItemId;
  dynamic _consumerNoStr;
  dynamic _flagForSVTV;
  num? _addedBy;
GetSvtvConsumerListModel copyWith({  num? distributorId,
  num? pkId,
  String? sVTVDate,
  String? consumerNo,
  dynamic consumerName,
  num? cylQty,
  num? staffId,
  num? saleGKId,
  num? saleGKItemId,
  dynamic consumerNoStr,
  dynamic flagForSVTV,
  num? addedBy,
}) => GetSvtvConsumerListModel(  distributorId: distributorId ?? _distributorId,
  pkId: pkId ?? _pkId,
  sVTVDate: sVTVDate ?? _sVTVDate,
  consumerNo: consumerNo ?? _consumerNo,
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
  String? get consumerNo => _consumerNo;
  dynamic get consumerName => _consumerName;
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