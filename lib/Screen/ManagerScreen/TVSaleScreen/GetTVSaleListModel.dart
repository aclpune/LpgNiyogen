/// TVId : 2
/// DistributorId : 8118
/// TVDate : "2025-06-21T00:00:00"
/// StaffId : 44
/// StaffName : "19kg Devendra"
/// ConsumerNo : "100002"
/// ClyReceivedQty : 2
/// IsRegulator : "Yes"
/// DepositAmt : 1500.00
/// RefillGasAmt : 1000.00
/// PaidAmt : 1500.00
/// Remark : "Test TV Details"
/// AddedBy : 4
/// Action : null
/// ClyHoldQty : 2
/// PaymentMode : "Cash"
/// TransactionCode : ""
/// TransactionTime : ""
/// TransactionRemark : ""
/// DenomTVList : null
/// ConsumerName : "Pravin"
/// ItemId : 3
/// ItemName : "19 KG"
/// BankId : 0
/// BankMappingId : 0

class GetTvSaleListModel {
  GetTvSaleListModel({
      num? tVId, 
      num? distributorId, 
      String? tVDate, 
      num? staffId, 
      String? staffName, 
      String? consumerNo, 
      num? clyReceivedQty, 
      String? isRegulator, 
      num? depositAmt, 
      num? refillGasAmt, 
      num? paidAmt, 
      String? remark, 
      num? addedBy, 
      dynamic action, 
      num? clyHoldQty, 
      String? paymentMode, 
      String? transactionCode, 
      String? transactionTime, 
      String? transactionRemark, 
      dynamic denomTVList, 
      String? consumerName, 
      num? itemId, 
      String? itemName, 
      num? bankId, 
      num? bankMappingId,}){
    _tVId = tVId;
    _distributorId = distributorId;
    _tVDate = tVDate;
    _staffId = staffId;
    _staffName = staffName;
    _consumerNo = consumerNo;
    _clyReceivedQty = clyReceivedQty;
    _isRegulator = isRegulator;
    _depositAmt = depositAmt;
    _refillGasAmt = refillGasAmt;
    _paidAmt = paidAmt;
    _remark = remark;
    _addedBy = addedBy;
    _action = action;
    _clyHoldQty = clyHoldQty;
    _paymentMode = paymentMode;
    _transactionCode = transactionCode;
    _transactionTime = transactionTime;
    _transactionRemark = transactionRemark;
    _denomTVList = denomTVList;
    _consumerName = consumerName;
    _itemId = itemId;
    _itemName = itemName;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
}

  GetTvSaleListModel.fromJson(dynamic json) {
    _tVId = json['TVId'];
    _distributorId = json['DistributorId'];
    _tVDate = json['TVDate'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _consumerNo = json['ConsumerNo'];
    _clyReceivedQty = json['ClyReceivedQty'];
    _isRegulator = json['IsRegulator'];
    _depositAmt = json['DepositAmt'];
    _refillGasAmt = json['RefillGasAmt'];
    _paidAmt = json['PaidAmt'];
    _remark = json['Remark'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
    _clyHoldQty = json['ClyHoldQty'];
    _paymentMode = json['PaymentMode'];
    _transactionCode = json['TransactionCode'];
    _transactionTime = json['TransactionTime'];
    _transactionRemark = json['TransactionRemark'];
    _denomTVList = json['DenomTVList'];
    _consumerName = json['ConsumerName'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
  }
  num? _tVId;
  num? _distributorId;
  String? _tVDate;
  num? _staffId;
  String? _staffName;
  String? _consumerNo;
  num? _clyReceivedQty;
  String? _isRegulator;
  num? _depositAmt;
  num? _refillGasAmt;
  num? _paidAmt;
  String? _remark;
  num? _addedBy;
  dynamic _action;
  num? _clyHoldQty;
  String? _paymentMode;
  String? _transactionCode;
  String? _transactionTime;
  String? _transactionRemark;
  dynamic _denomTVList;
  String? _consumerName;
  num? _itemId;
  String? _itemName;
  num? _bankId;
  num? _bankMappingId;
GetTvSaleListModel copyWith({  num? tVId,
  num? distributorId,
  String? tVDate,
  num? staffId,
  String? staffName,
  String? consumerNo,
  num? clyReceivedQty,
  String? isRegulator,
  num? depositAmt,
  num? refillGasAmt,
  num? paidAmt,
  String? remark,
  num? addedBy,
  dynamic action,
  num? clyHoldQty,
  String? paymentMode,
  String? transactionCode,
  String? transactionTime,
  String? transactionRemark,
  dynamic denomTVList,
  String? consumerName,
  num? itemId,
  String? itemName,
  num? bankId,
  num? bankMappingId,
}) => GetTvSaleListModel(  tVId: tVId ?? _tVId,
  distributorId: distributorId ?? _distributorId,
  tVDate: tVDate ?? _tVDate,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  consumerNo: consumerNo ?? _consumerNo,
  clyReceivedQty: clyReceivedQty ?? _clyReceivedQty,
  isRegulator: isRegulator ?? _isRegulator,
  depositAmt: depositAmt ?? _depositAmt,
  refillGasAmt: refillGasAmt ?? _refillGasAmt,
  paidAmt: paidAmt ?? _paidAmt,
  remark: remark ?? _remark,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
  clyHoldQty: clyHoldQty ?? _clyHoldQty,
  paymentMode: paymentMode ?? _paymentMode,
  transactionCode: transactionCode ?? _transactionCode,
  transactionTime: transactionTime ?? _transactionTime,
  transactionRemark: transactionRemark ?? _transactionRemark,
  denomTVList: denomTVList ?? _denomTVList,
  consumerName: consumerName ?? _consumerName,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
);
  num? get tVId => _tVId;
  num? get distributorId => _distributorId;
  String? get tVDate => _tVDate;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  String? get consumerNo => _consumerNo;
  num? get clyReceivedQty => _clyReceivedQty;
  String? get isRegulator => _isRegulator;
  num? get depositAmt => _depositAmt;
  num? get refillGasAmt => _refillGasAmt;
  num? get paidAmt => _paidAmt;
  String? get remark => _remark;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  num? get clyHoldQty => _clyHoldQty;
  String? get paymentMode => _paymentMode;
  String? get transactionCode => _transactionCode;
  String? get transactionTime => _transactionTime;
  String? get transactionRemark => _transactionRemark;
  dynamic get denomTVList => _denomTVList;
  String? get consumerName => _consumerName;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TVId'] = _tVId;
    map['DistributorId'] = _distributorId;
    map['TVDate'] = _tVDate;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['ConsumerNo'] = _consumerNo;
    map['ClyReceivedQty'] = _clyReceivedQty;
    map['IsRegulator'] = _isRegulator;
    map['DepositAmt'] = _depositAmt;
    map['RefillGasAmt'] = _refillGasAmt;
    map['PaidAmt'] = _paidAmt;
    map['Remark'] = _remark;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    map['ClyHoldQty'] = _clyHoldQty;
    map['PaymentMode'] = _paymentMode;
    map['TransactionCode'] = _transactionCode;
    map['TransactionTime'] = _transactionTime;
    map['TransactionRemark'] = _transactionRemark;
    map['DenomTVList'] = _denomTVList;
    map['ConsumerName'] = _consumerName;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    return map;
  }

}