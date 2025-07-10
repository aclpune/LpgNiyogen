/// DistributorId : 8118
/// FromDate : null
/// ToDate : null
/// StaffId : 0
/// ReferredBy : "19kg Devendra"
/// SVDate : "2025-07-07T14:39:03"
/// SVType : "NC"
/// ProductId : 1
/// ItemName : "14.2 KG"
/// ItemId : 0
/// IsUndocument : false
/// ConsuDCNo : "43434"
/// ConsumerName : ""
/// CylQty : 1
/// SCRegulator : 1
/// StaffName : null
/// AmtCharges : 0.00
/// TotalAmount : 6155.50
/// AddedOn : "2025-07-07T09:09:46.283"
/// DMId : 0
/// StockStatus : "Pending"
/// GodownId : 0
/// GodownNo : null
/// ReceiptDate : null
/// ConsumerNo : null

class GetDashboardSvStockPendCtnListForMobListModel {
  GetDashboardSvStockPendCtnListForMobListModel({
      num? distributorId, 
      dynamic fromDate, 
      dynamic toDate, 
      num? staffId, 
      String? referredBy, 
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
      dynamic staffName, 
      num? amtCharges, 
      num? totalAmount, 
      String? addedOn, 
      num? dMId, 
      String? stockStatus, 
      num? godownId, 
      dynamic godownNo, 
      dynamic receiptDate, 
      dynamic consumerNo,}){
    _distributorId = distributorId;
    _fromDate = fromDate;
    _toDate = toDate;
    _staffId = staffId;
    _referredBy = referredBy;
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
    _staffName = staffName;
    _amtCharges = amtCharges;
    _totalAmount = totalAmount;
    _addedOn = addedOn;
    _dMId = dMId;
    _stockStatus = stockStatus;
    _godownId = godownId;
    _godownNo = godownNo;
    _receiptDate = receiptDate;
    _consumerNo = consumerNo;
}

  GetDashboardSvStockPendCtnListForMobListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _fromDate = json['FromDate'];
    _toDate = json['ToDate'];
    _staffId = json['StaffId'];
    _referredBy = json['ReferredBy'];
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
    _staffName = json['StaffName'];
    _amtCharges = json['AmtCharges'];
    _totalAmount = json['TotalAmount'];
    _addedOn = json['AddedOn'];
    _dMId = json['DMId'];
    _stockStatus = json['StockStatus'];
    _godownId = json['GodownId'];
    _godownNo = json['GodownNo'];
    _receiptDate = json['ReceiptDate'];
    _consumerNo = json['ConsumerNo'];
  }
  num? _distributorId;
  dynamic _fromDate;
  dynamic _toDate;
  num? _staffId;
  String? _referredBy;
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
  dynamic _staffName;
  num? _amtCharges;
  num? _totalAmount;
  String? _addedOn;
  num? _dMId;
  String? _stockStatus;
  num? _godownId;
  dynamic _godownNo;
  dynamic _receiptDate;
  dynamic _consumerNo;
GetDashboardSvStockPendCtnListForMobListModel copyWith({  num? distributorId,
  dynamic fromDate,
  dynamic toDate,
  num? staffId,
  String? referredBy,
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
  dynamic staffName,
  num? amtCharges,
  num? totalAmount,
  String? addedOn,
  num? dMId,
  String? stockStatus,
  num? godownId,
  dynamic godownNo,
  dynamic receiptDate,
  dynamic consumerNo,
}) => GetDashboardSvStockPendCtnListForMobListModel(  distributorId: distributorId ?? _distributorId,
  fromDate: fromDate ?? _fromDate,
  toDate: toDate ?? _toDate,
  staffId: staffId ?? _staffId,
  referredBy: referredBy ?? _referredBy,
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
  staffName: staffName ?? _staffName,
  amtCharges: amtCharges ?? _amtCharges,
  totalAmount: totalAmount ?? _totalAmount,
  addedOn: addedOn ?? _addedOn,
  dMId: dMId ?? _dMId,
  stockStatus: stockStatus ?? _stockStatus,
  godownId: godownId ?? _godownId,
  godownNo: godownNo ?? _godownNo,
  receiptDate: receiptDate ?? _receiptDate,
  consumerNo: consumerNo ?? _consumerNo,
);
  num? get distributorId => _distributorId;
  dynamic get fromDate => _fromDate;
  dynamic get toDate => _toDate;
  num? get staffId => _staffId;
  String? get referredBy => _referredBy;
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
  dynamic get staffName => _staffName;
  num? get amtCharges => _amtCharges;
  num? get totalAmount => _totalAmount;
  String? get addedOn => _addedOn;
  num? get dMId => _dMId;
  String? get stockStatus => _stockStatus;
  num? get godownId => _godownId;
  dynamic get godownNo => _godownNo;
  dynamic get receiptDate => _receiptDate;
  dynamic get consumerNo => _consumerNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['FromDate'] = _fromDate;
    map['ToDate'] = _toDate;
    map['StaffId'] = _staffId;
    map['ReferredBy'] = _referredBy;
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
    map['StaffName'] = _staffName;
    map['AmtCharges'] = _amtCharges;
    map['TotalAmount'] = _totalAmount;
    map['AddedOn'] = _addedOn;
    map['DMId'] = _dMId;
    map['StockStatus'] = _stockStatus;
    map['GodownId'] = _godownId;
    map['GodownNo'] = _godownNo;
    map['ReceiptDate'] = _receiptDate;
    map['ConsumerNo'] = _consumerNo;
    return map;
  }

}