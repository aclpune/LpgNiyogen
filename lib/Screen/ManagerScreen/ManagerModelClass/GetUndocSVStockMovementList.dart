/// PSVId : 13
/// DistributorId : 8118
/// SVDate : "2025-02-14T17:44:25"
/// SVType : "NC"
/// ProductId : 1
/// ItemName : "14.2 KG"
/// ItemId : 0
/// IsUndocument : true
/// ConsuDCNo : "666"
/// ConsumerName : "Gurav"
/// CylQty : 1
/// SCRegulator : 1
/// TotalAmount : 4312.50
/// AmtCharges : 0.0
/// AddedOn : "2025-02-14T17:46:21.46"
/// DMId : 0
/// StockStatus : null
/// GodownId : 0
/// GodownNo : null
/// ReceiptDate : null
/// UndocSVDetails : null

class GetUndocSvStockMovementList {
  GetUndocSvStockMovementList({
      num? pSVId, 
      num? distributorId, 
      String? sVDate, 
      String? sVType, 
      num? productId, 
      String? itemName, 
      num? itemId, 
      bool? isUndocument, 
      String? consuDCNo, 
      String? consumerName, 
      num? cylQty, 
      num? sCRegulator, 
      num? totalAmount, 
      num? amtCharges, 
      String? addedOn, 
      num? dMId, 
      dynamic stockStatus, 
      num? godownId, 
      dynamic godownNo, 
      dynamic receiptDate, 
      dynamic undocSVDetails,}){
    _pSVId = pSVId;
    _distributorId = distributorId;
    _sVDate = sVDate;
    _sVType = sVType;
    _productId = productId;
    _itemName = itemName;
    _itemId = itemId;
    _isUndocument = isUndocument;
    _consuDCNo = consuDCNo;
    _consumerName = consumerName;
    _cylQty = cylQty;
    _sCRegulator = sCRegulator;
    _totalAmount = totalAmount;
    _amtCharges = amtCharges;
    _addedOn = addedOn;
    _dMId = dMId;
    _stockStatus = stockStatus;
    _godownId = godownId;
    _godownNo = godownNo;
    _receiptDate = receiptDate;
    _undocSVDetails = undocSVDetails;
}

  GetUndocSvStockMovementList.fromJson(dynamic json) {
    _pSVId = json['PSVId'];
    _distributorId = json['DistributorId'];
    _sVDate = json['SVDate'];
    _sVType = json['SVType'];
    _productId = json['ProductId'];
    _itemName = json['ItemName'];
    _itemId = json['ItemId'];
    _isUndocument = json['IsUndocument'];
    _consuDCNo = json['ConsuDCNo'];
    _consumerName = json['ConsumerName'];
    _cylQty = json['CylQty'];
    _sCRegulator = json['SCRegulator'];
    _totalAmount = json['TotalAmount'];
    _amtCharges = json['AmtCharges'];
    _addedOn = json['AddedOn'];
    _dMId = json['DMId'];
    _stockStatus = json['StockStatus'];
    _godownId = json['GodownId'];
    _godownNo = json['GodownNo'];
    _receiptDate = json['ReceiptDate'];
    _undocSVDetails = json['UndocSVDetails'];
  }
  num? _pSVId;
  num? _distributorId;
  String? _sVDate;
  String? _sVType;
  num? _productId;
  String? _itemName;
  num? _itemId;
  bool? _isUndocument;
  String? _consuDCNo;
  String? _consumerName;
  num? _cylQty;
  num? _sCRegulator;
  num? _totalAmount;
  num? _amtCharges;
  String? _addedOn;
  num? _dMId;
  dynamic _stockStatus;
  num? _godownId;
  dynamic _godownNo;
  dynamic _receiptDate;
  dynamic _undocSVDetails;
GetUndocSvStockMovementList copyWith({  num? pSVId,
  num? distributorId,
  String? sVDate,
  String? sVType,
  num? productId,
  String? itemName,
  num? itemId,
  bool? isUndocument,
  String? consuDCNo,
  String? consumerName,
  num? cylQty,
  num? sCRegulator,
  num? totalAmount,
  num? amtCharges,
  String? addedOn,
  num? dMId,
  dynamic stockStatus,
  num? godownId,
  dynamic godownNo,
  dynamic receiptDate,
  dynamic undocSVDetails,
}) => GetUndocSvStockMovementList(  pSVId: pSVId ?? _pSVId,
  distributorId: distributorId ?? _distributorId,
  sVDate: sVDate ?? _sVDate,
  sVType: sVType ?? _sVType,
  productId: productId ?? _productId,
  itemName: itemName ?? _itemName,
  itemId: itemId ?? _itemId,
  isUndocument: isUndocument ?? _isUndocument,
  consuDCNo: consuDCNo ?? _consuDCNo,
  consumerName: consumerName ?? _consumerName,
  cylQty: cylQty ?? _cylQty,
  sCRegulator: sCRegulator ?? _sCRegulator,
  totalAmount: totalAmount ?? _totalAmount,
  amtCharges: amtCharges ?? _amtCharges,
  addedOn: addedOn ?? _addedOn,
  dMId: dMId ?? _dMId,
  stockStatus: stockStatus ?? _stockStatus,
  godownId: godownId ?? _godownId,
  godownNo: godownNo ?? _godownNo,
  receiptDate: receiptDate ?? _receiptDate,
  undocSVDetails: undocSVDetails ?? _undocSVDetails,
);
  num? get pSVId => _pSVId;
  num? get distributorId => _distributorId;
  String? get sVDate => _sVDate;
  String? get sVType => _sVType;
  num? get productId => _productId;
  String? get itemName => _itemName;
  num? get itemId => _itemId;
  bool? get isUndocument => _isUndocument;
  String? get consuDCNo => _consuDCNo;
  String? get consumerName => _consumerName;
  num? get cylQty => _cylQty;
  num? get sCRegulator => _sCRegulator;
  num? get totalAmount => _totalAmount;
  num? get amtCharges => _amtCharges;
  String? get addedOn => _addedOn;
  num? get dMId => _dMId;
  dynamic get stockStatus => _stockStatus;
  num? get godownId => _godownId;
  dynamic get godownNo => _godownNo;
  dynamic get receiptDate => _receiptDate;
  dynamic get undocSVDetails => _undocSVDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PSVId'] = _pSVId;
    map['DistributorId'] = _distributorId;
    map['SVDate'] = _sVDate;
    map['SVType'] = _sVType;
    map['ProductId'] = _productId;
    map['ItemName'] = _itemName;
    map['ItemId'] = _itemId;
    map['IsUndocument'] = _isUndocument;
    map['ConsuDCNo'] = _consuDCNo;
    map['ConsumerName'] = _consumerName;
    map['CylQty'] = _cylQty;
    map['SCRegulator'] = _sCRegulator;
    map['TotalAmount'] = _totalAmount;
    map['AmtCharges'] = _amtCharges;
    map['AddedOn'] = _addedOn;
    map['DMId'] = _dMId;
    map['StockStatus'] = _stockStatus;
    map['GodownId'] = _godownId;
    map['GodownNo'] = _godownNo;
    map['ReceiptDate'] = _receiptDate;
    map['UndocSVDetails'] = _undocSVDetails;
    return map;
  }

}