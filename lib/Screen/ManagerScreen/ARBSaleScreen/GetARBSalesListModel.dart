/// ARBSalesId : 193
/// DistributorId : 8118
/// SaleDate : "2025-07-16T11:55:52"
/// StaffId : 45
/// StaffName : "19kg Gopal"
/// ConsumerNo : "546878"
/// ConsumerName : ""
/// TotalAmount : 2750.0
/// PaymentMode : "Bank"
/// TransactionCode : "fgdfg"
/// TransactionTime : ""
/// TransactionRemark : ""
/// AddedBy : 0
/// Action : null
/// ItemId : 5
/// ItemName : "2 Burner Delux"
/// Rate : 2750.0
/// ItemQty : 1
/// DiscountAmt : 0.0
/// ARBAmount : 2750.0
/// ItemDataList : [{"ARBSalesId":0,"ItemId":5,"ItemName":"2 Burner Delux","Rate":2750.0,"ItemQty":1,"DiscountAmt":0.0,"ARBAmount":2750.0}]
/// DenomDtList : null
/// BankId : 14
/// BankMappingId : 19
/// UpdatedFrom : null

class GetArbSalesListModel {
  GetArbSalesListModel({
      num? aRBSalesId, 
      num? distributorId, 
      String? saleDate, 
      num? staffId, 
      String? staffName, 
      String? consumerNo, 
      String? consumerName, 
      num? totalAmount, 
      String? paymentMode, 
      String? transactionCode, 
      String? transactionTime, 
      String? transactionRemark, 
      num? addedBy, 
      dynamic action, 
      num? itemId, 
      String? itemName, 
      num? rate, 
      num? itemQty, 
      num? discountAmt, 
      num? aRBAmount, 
      List<ItemDataList>? itemDataList, 
      dynamic denomDtList, 
      num? bankId, 
      num? bankMappingId, 
      dynamic updatedFrom,}){
    _aRBSalesId = aRBSalesId;
    _distributorId = distributorId;
    _saleDate = saleDate;
    _staffId = staffId;
    _staffName = staffName;
    _consumerNo = consumerNo;
    _consumerName = consumerName;
    _totalAmount = totalAmount;
    _paymentMode = paymentMode;
    _transactionCode = transactionCode;
    _transactionTime = transactionTime;
    _transactionRemark = transactionRemark;
    _addedBy = addedBy;
    _action = action;
    _itemId = itemId;
    _itemName = itemName;
    _rate = rate;
    _itemQty = itemQty;
    _discountAmt = discountAmt;
    _aRBAmount = aRBAmount;
    _itemDataList = itemDataList;
    _denomDtList = denomDtList;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
    _updatedFrom = updatedFrom;
}

  GetArbSalesListModel.fromJson(dynamic json) {
    _aRBSalesId = json['ARBSalesId'];
    _distributorId = json['DistributorId'];
    _saleDate = json['SaleDate'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _consumerNo = json['ConsumerNo'];
    _consumerName = json['ConsumerName'];
    _totalAmount = json['TotalAmount'];
    _paymentMode = json['PaymentMode'];
    _transactionCode = json['TransactionCode'];
    _transactionTime = json['TransactionTime'];
    _transactionRemark = json['TransactionRemark'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _rate = json['Rate'];
    _itemQty = json['ItemQty'];
    _discountAmt = json['DiscountAmt'];
    _aRBAmount = json['ARBAmount'];
    if (json['ItemDataList'] != null) {
      _itemDataList = [];
      json['ItemDataList'].forEach((v) {
        _itemDataList?.add(ItemDataList.fromJson(v));
      });
    }
    _denomDtList = json['DenomDtList'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
    _updatedFrom = json['UpdatedFrom'];
  }
  num? _aRBSalesId;
  num? _distributorId;
  String? _saleDate;
  num? _staffId;
  String? _staffName;
  String? _consumerNo;
  String? _consumerName;
  num? _totalAmount;
  String? _paymentMode;
  String? _transactionCode;
  String? _transactionTime;
  String? _transactionRemark;
  num? _addedBy;
  dynamic _action;
  num? _itemId;
  String? _itemName;
  num? _rate;
  num? _itemQty;
  num? _discountAmt;
  num? _aRBAmount;
  List<ItemDataList>? _itemDataList;
  dynamic _denomDtList;
  num? _bankId;
  num? _bankMappingId;
  dynamic _updatedFrom;
GetArbSalesListModel copyWith({  num? aRBSalesId,
  num? distributorId,
  String? saleDate,
  num? staffId,
  String? staffName,
  String? consumerNo,
  String? consumerName,
  num? totalAmount,
  String? paymentMode,
  String? transactionCode,
  String? transactionTime,
  String? transactionRemark,
  num? addedBy,
  dynamic action,
  num? itemId,
  String? itemName,
  num? rate,
  num? itemQty,
  num? discountAmt,
  num? aRBAmount,
  List<ItemDataList>? itemDataList,
  dynamic denomDtList,
  num? bankId,
  num? bankMappingId,
  dynamic updatedFrom,
}) => GetArbSalesListModel(  aRBSalesId: aRBSalesId ?? _aRBSalesId,
  distributorId: distributorId ?? _distributorId,
  saleDate: saleDate ?? _saleDate,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  consumerNo: consumerNo ?? _consumerNo,
  consumerName: consumerName ?? _consumerName,
  totalAmount: totalAmount ?? _totalAmount,
  paymentMode: paymentMode ?? _paymentMode,
  transactionCode: transactionCode ?? _transactionCode,
  transactionTime: transactionTime ?? _transactionTime,
  transactionRemark: transactionRemark ?? _transactionRemark,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  rate: rate ?? _rate,
  itemQty: itemQty ?? _itemQty,
  discountAmt: discountAmt ?? _discountAmt,
  aRBAmount: aRBAmount ?? _aRBAmount,
  itemDataList: itemDataList ?? _itemDataList,
  denomDtList: denomDtList ?? _denomDtList,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
  updatedFrom: updatedFrom ?? _updatedFrom,
);
  num? get aRBSalesId => _aRBSalesId;
  num? get distributorId => _distributorId;
  String? get saleDate => _saleDate;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  String? get consumerNo => _consumerNo;
  String? get consumerName => _consumerName;
  num? get totalAmount => _totalAmount;
  String? get paymentMode => _paymentMode;
  String? get transactionCode => _transactionCode;
  String? get transactionTime => _transactionTime;
  String? get transactionRemark => _transactionRemark;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rate => _rate;
  num? get itemQty => _itemQty;
  num? get discountAmt => _discountAmt;
  num? get aRBAmount => _aRBAmount;
  List<ItemDataList>? get itemDataList => _itemDataList;
  dynamic get denomDtList => _denomDtList;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;
  dynamic get updatedFrom => _updatedFrom;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ARBSalesId'] = _aRBSalesId;
    map['DistributorId'] = _distributorId;
    map['SaleDate'] = _saleDate;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['ConsumerNo'] = _consumerNo;
    map['ConsumerName'] = _consumerName;
    map['TotalAmount'] = _totalAmount;
    map['PaymentMode'] = _paymentMode;
    map['TransactionCode'] = _transactionCode;
    map['TransactionTime'] = _transactionTime;
    map['TransactionRemark'] = _transactionRemark;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['Rate'] = _rate;
    map['ItemQty'] = _itemQty;
    map['DiscountAmt'] = _discountAmt;
    map['ARBAmount'] = _aRBAmount;
    if (_itemDataList != null) {
      map['ItemDataList'] = _itemDataList?.map((v) => v.toJson()).toList();
    }
    map['DenomDtList'] = _denomDtList;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    map['UpdatedFrom'] = _updatedFrom;
    return map;
  }

}

/// ARBSalesId : 0
/// ItemId : 5
/// ItemName : "2 Burner Delux"
/// Rate : 2750.0
/// ItemQty : 1
/// DiscountAmt : 0.0
/// ARBAmount : 2750.0

class ItemDataList {
  ItemDataList({
      num? aRBSalesId, 
      num? itemId, 
      String? itemName, 
      num? rate, 
      num? itemQty, 
      num? discountAmt, 
      num? aRBAmount,}){
    _aRBSalesId = aRBSalesId;
    _itemId = itemId;
    _itemName = itemName;
    _rate = rate;
    _itemQty = itemQty;
    _discountAmt = discountAmt;
    _aRBAmount = aRBAmount;
}

  ItemDataList.fromJson(dynamic json) {
    _aRBSalesId = json['ARBSalesId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _rate = json['Rate'];
    _itemQty = json['ItemQty'];
    _discountAmt = json['DiscountAmt'];
    _aRBAmount = json['ARBAmount'];
  }
  num? _aRBSalesId;
  num? _itemId;
  String? _itemName;
  num? _rate;
  num? _itemQty;
  num? _discountAmt;
  num? _aRBAmount;
ItemDataList copyWith({  num? aRBSalesId,
  num? itemId,
  String? itemName,
  num? rate,
  num? itemQty,
  num? discountAmt,
  num? aRBAmount,
}) => ItemDataList(  aRBSalesId: aRBSalesId ?? _aRBSalesId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  rate: rate ?? _rate,
  itemQty: itemQty ?? _itemQty,
  discountAmt: discountAmt ?? _discountAmt,
  aRBAmount: aRBAmount ?? _aRBAmount,
);
  num? get aRBSalesId => _aRBSalesId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rate => _rate;
  num? get itemQty => _itemQty;
  num? get discountAmt => _discountAmt;
  num? get aRBAmount => _aRBAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ARBSalesId'] = _aRBSalesId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['Rate'] = _rate;
    map['ItemQty'] = _itemQty;
    map['DiscountAmt'] = _discountAmt;
    map['ARBAmount'] = _aRBAmount;
    return map;
  }

}