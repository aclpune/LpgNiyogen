/// RegDefRcptId : 11
/// DistributorId : 8118
/// RegDefRcptDate : "2025-09-23T10:39:12"
/// StaffId : 34
/// StaffName : "Dattatray Nanaware"
/// ConsumerNo : "423455"
/// ConsumerName : "Fgdh"
/// ItemId : 6
/// ItemName : "SC REGULATOR"
/// RegDefRcptQty : 1
/// ReplacementCharge : 1
/// PaidAmt : 250.00
/// PaymentMode : "Cash"
/// TransactionCode : ""
/// TransactionTime : ""
/// TransactionRemark : ""
/// BankId : 0
/// BankMappingId : 0
/// Remark : ""
/// AddedBy : 0
/// Action : null
/// DenomRegDefList : null

class GetRegDefReceiptDetailsModel {
  GetRegDefReceiptDetailsModel({
      num? regDefRcptId, 
      num? distributorId, 
      String? regDefRcptDate, 
      num? staffId, 
      String? staffName, 
      String? consumerNo, 
      String? consumerName, 
      num? itemId, 
      String? itemName, 
      num? regDefRcptQty, 
      num? replacementCharge, 
      num? paidAmt, 
      String? paymentMode, 
      String? transactionCode, 
      String? transactionTime, 
      String? transactionRemark, 
      num? bankId, 
      num? bankMappingId, 
      String? remark, 
      num? addedBy, 
      dynamic action, 
      dynamic denomRegDefList,}){
    _regDefRcptId = regDefRcptId;
    _distributorId = distributorId;
    _regDefRcptDate = regDefRcptDate;
    _staffId = staffId;
    _staffName = staffName;
    _consumerNo = consumerNo;
    _consumerName = consumerName;
    _itemId = itemId;
    _itemName = itemName;
    _regDefRcptQty = regDefRcptQty;
    _replacementCharge = replacementCharge;
    _paidAmt = paidAmt;
    _paymentMode = paymentMode;
    _transactionCode = transactionCode;
    _transactionTime = transactionTime;
    _transactionRemark = transactionRemark;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
    _remark = remark;
    _addedBy = addedBy;
    _action = action;
    _denomRegDefList = denomRegDefList;
}

  GetRegDefReceiptDetailsModel.fromJson(dynamic json) {
    _regDefRcptId = json['RegDefRcptId'];
    _distributorId = json['DistributorId'];
    _regDefRcptDate = json['RegDefRcptDate'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _consumerNo = json['ConsumerNo'];
    _consumerName = json['ConsumerName'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _regDefRcptQty = json['RegDefRcptQty'];
    _replacementCharge = json['ReplacementCharge'];
    _paidAmt = json['PaidAmt'];
    _paymentMode = json['PaymentMode'];
    _transactionCode = json['TransactionCode'];
    _transactionTime = json['TransactionTime'];
    _transactionRemark = json['TransactionRemark'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
    _remark = json['Remark'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
    _denomRegDefList = json['DenomRegDefList'];
  }
  num? _regDefRcptId;
  num? _distributorId;
  String? _regDefRcptDate;
  num? _staffId;
  String? _staffName;
  String? _consumerNo;
  String? _consumerName;
  num? _itemId;
  String? _itemName;
  num? _regDefRcptQty;
  num? _replacementCharge;
  num? _paidAmt;
  String? _paymentMode;
  String? _transactionCode;
  String? _transactionTime;
  String? _transactionRemark;
  num? _bankId;
  num? _bankMappingId;
  String? _remark;
  num? _addedBy;
  dynamic _action;
  dynamic _denomRegDefList;
GetRegDefReceiptDetailsModel copyWith({  num? regDefRcptId,
  num? distributorId,
  String? regDefRcptDate,
  num? staffId,
  String? staffName,
  String? consumerNo,
  String? consumerName,
  num? itemId,
  String? itemName,
  num? regDefRcptQty,
  num? replacementCharge,
  num? paidAmt,
  String? paymentMode,
  String? transactionCode,
  String? transactionTime,
  String? transactionRemark,
  num? bankId,
  num? bankMappingId,
  String? remark,
  num? addedBy,
  dynamic action,
  dynamic denomRegDefList,
}) => GetRegDefReceiptDetailsModel(  regDefRcptId: regDefRcptId ?? _regDefRcptId,
  distributorId: distributorId ?? _distributorId,
  regDefRcptDate: regDefRcptDate ?? _regDefRcptDate,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  consumerNo: consumerNo ?? _consumerNo,
  consumerName: consumerName ?? _consumerName,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  regDefRcptQty: regDefRcptQty ?? _regDefRcptQty,
  replacementCharge: replacementCharge ?? _replacementCharge,
  paidAmt: paidAmt ?? _paidAmt,
  paymentMode: paymentMode ?? _paymentMode,
  transactionCode: transactionCode ?? _transactionCode,
  transactionTime: transactionTime ?? _transactionTime,
  transactionRemark: transactionRemark ?? _transactionRemark,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
  remark: remark ?? _remark,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
  denomRegDefList: denomRegDefList ?? _denomRegDefList,
);
  num? get regDefRcptId => _regDefRcptId;
  num? get distributorId => _distributorId;
  String? get regDefRcptDate => _regDefRcptDate;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  String? get consumerNo => _consumerNo;
  String? get consumerName => _consumerName;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get regDefRcptQty => _regDefRcptQty;
  num? get replacementCharge => _replacementCharge;
  num? get paidAmt => _paidAmt;
  String? get paymentMode => _paymentMode;
  String? get transactionCode => _transactionCode;
  String? get transactionTime => _transactionTime;
  String? get transactionRemark => _transactionRemark;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;
  String? get remark => _remark;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  dynamic get denomRegDefList => _denomRegDefList;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RegDefRcptId'] = _regDefRcptId;
    map['DistributorId'] = _distributorId;
    map['RegDefRcptDate'] = _regDefRcptDate;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['ConsumerNo'] = _consumerNo;
    map['ConsumerName'] = _consumerName;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['RegDefRcptQty'] = _regDefRcptQty;
    map['ReplacementCharge'] = _replacementCharge;
    map['PaidAmt'] = _paidAmt;
    map['PaymentMode'] = _paymentMode;
    map['TransactionCode'] = _transactionCode;
    map['TransactionTime'] = _transactionTime;
    map['TransactionRemark'] = _transactionRemark;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    map['Remark'] = _remark;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    map['DenomRegDefList'] = _denomRegDefList;
    return map;
  }

}