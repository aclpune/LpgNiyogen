/// DistributorId : 0
/// FromDate : null
/// ToDate : null
/// StaffId : 0
/// StaffName : null
/// TVDate : "2025-04-16T00:00:00"
/// ItemId : 1
/// ItemName : "14.2 KG"
/// ConsumerNo : "213213"
/// ConsumerName : "sss"
/// ClyHoldQty : 1
/// ClyReceivedQty : 1
/// IsRegulator : "Yes"
/// DepositAmt : 0.00
/// RefillGasAmt : 0.00
/// PaidAmt : 100.00
/// PaymentMode : "Cash"
/// RecieptDate : null
/// GodownId : 0
/// GodownNo : null
/// StockStatus : "Pending"

class GetDashboardTvStockPendCtnListForMob {
  GetDashboardTvStockPendCtnListForMob({
      num? distributorId, 
      dynamic fromDate, 
      dynamic toDate, 
      num? staffId, 
      dynamic staffName, 
      String? tVDate, 
      num? itemId, 
      String? itemName, 
      String? consumerNo, 
      String? consumerName, 
      num? clyHoldQty, 
      num? clyReceivedQty, 
      String? isRegulator, 
      num? depositAmt, 
      num? refillGasAmt, 
      num? paidAmt, 
      String? paymentMode, 
      dynamic recieptDate, 
      num? godownId, 
      dynamic godownNo, 
      String? stockStatus,}){
    _distributorId = distributorId;
    _fromDate = fromDate;
    _toDate = toDate;
    _staffId = staffId;
    _staffName = staffName;
    _tVDate = tVDate;
    _itemId = itemId;
    _itemName = itemName;
    _consumerNo = consumerNo;
    _consumerName = consumerName;
    _clyHoldQty = clyHoldQty;
    _clyReceivedQty = clyReceivedQty;
    _isRegulator = isRegulator;
    _depositAmt = depositAmt;
    _refillGasAmt = refillGasAmt;
    _paidAmt = paidAmt;
    _paymentMode = paymentMode;
    _recieptDate = recieptDate;
    _godownId = godownId;
    _godownNo = godownNo;
    _stockStatus = stockStatus;
}

  GetDashboardTvStockPendCtnListForMob.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _fromDate = json['FromDate'];
    _toDate = json['ToDate'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _tVDate = json['TVDate'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _consumerNo = json['ConsumerNo'];
    _consumerName = json['ConsumerName'];
    _clyHoldQty = json['ClyHoldQty'];
    _clyReceivedQty = json['ClyReceivedQty'];
    _isRegulator = json['IsRegulator'];
    _depositAmt = json['DepositAmt'];
    _refillGasAmt = json['RefillGasAmt'];
    _paidAmt = json['PaidAmt'];
    _paymentMode = json['PaymentMode'];
    _recieptDate = json['RecieptDate'];
    _godownId = json['GodownId'];
    _godownNo = json['GodownNo'];
    _stockStatus = json['StockStatus'];
  }
  num? _distributorId;
  dynamic _fromDate;
  dynamic _toDate;
  num? _staffId;
  dynamic _staffName;
  String? _tVDate;
  num? _itemId;
  String? _itemName;
  String? _consumerNo;
  String? _consumerName;
  num? _clyHoldQty;
  num? _clyReceivedQty;
  String? _isRegulator;
  num? _depositAmt;
  num? _refillGasAmt;
  num? _paidAmt;
  String? _paymentMode;
  dynamic _recieptDate;
  num? _godownId;
  dynamic _godownNo;
  String? _stockStatus;
GetDashboardTvStockPendCtnListForMob copyWith({  num? distributorId,
  dynamic fromDate,
  dynamic toDate,
  num? staffId,
  dynamic staffName,
  String? tVDate,
  num? itemId,
  String? itemName,
  String? consumerNo,
  String? consumerName,
  num? clyHoldQty,
  num? clyReceivedQty,
  String? isRegulator,
  num? depositAmt,
  num? refillGasAmt,
  num? paidAmt,
  String? paymentMode,
  dynamic recieptDate,
  num? godownId,
  dynamic godownNo,
  String? stockStatus,
}) => GetDashboardTvStockPendCtnListForMob(  distributorId: distributorId ?? _distributorId,
  fromDate: fromDate ?? _fromDate,
  toDate: toDate ?? _toDate,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  tVDate: tVDate ?? _tVDate,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  consumerNo: consumerNo ?? _consumerNo,
  consumerName: consumerName ?? _consumerName,
  clyHoldQty: clyHoldQty ?? _clyHoldQty,
  clyReceivedQty: clyReceivedQty ?? _clyReceivedQty,
  isRegulator: isRegulator ?? _isRegulator,
  depositAmt: depositAmt ?? _depositAmt,
  refillGasAmt: refillGasAmt ?? _refillGasAmt,
  paidAmt: paidAmt ?? _paidAmt,
  paymentMode: paymentMode ?? _paymentMode,
  recieptDate: recieptDate ?? _recieptDate,
  godownId: godownId ?? _godownId,
  godownNo: godownNo ?? _godownNo,
  stockStatus: stockStatus ?? _stockStatus,
);
  num? get distributorId => _distributorId;
  dynamic get fromDate => _fromDate;
  dynamic get toDate => _toDate;
  num? get staffId => _staffId;
  dynamic get staffName => _staffName;
  String? get tVDate => _tVDate;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  String? get consumerNo => _consumerNo;
  String? get consumerName => _consumerName;
  num? get clyHoldQty => _clyHoldQty;
  num? get clyReceivedQty => _clyReceivedQty;
  String? get isRegulator => _isRegulator;
  num? get depositAmt => _depositAmt;
  num? get refillGasAmt => _refillGasAmt;
  num? get paidAmt => _paidAmt;
  String? get paymentMode => _paymentMode;
  dynamic get recieptDate => _recieptDate;
  num? get godownId => _godownId;
  dynamic get godownNo => _godownNo;
  String? get stockStatus => _stockStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['FromDate'] = _fromDate;
    map['ToDate'] = _toDate;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['TVDate'] = _tVDate;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ConsumerNo'] = _consumerNo;
    map['ConsumerName'] = _consumerName;
    map['ClyHoldQty'] = _clyHoldQty;
    map['ClyReceivedQty'] = _clyReceivedQty;
    map['IsRegulator'] = _isRegulator;
    map['DepositAmt'] = _depositAmt;
    map['RefillGasAmt'] = _refillGasAmt;
    map['PaidAmt'] = _paidAmt;
    map['PaymentMode'] = _paymentMode;
    map['RecieptDate'] = _recieptDate;
    map['GodownId'] = _godownId;
    map['GodownNo'] = _godownNo;
    map['StockStatus'] = _stockStatus;
    return map;
  }

}