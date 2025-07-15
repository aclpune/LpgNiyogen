/// ARBSalesId : 198
/// DistributorId : 8118
/// SaleDate : "2025-07-09T07:12:40.393"
/// StaffId : 45
/// StaffName : "19kg Gopal"
/// ConsumerNo : "685368"
/// ConsumerName : "jvhfh"
/// TotalAmount : 8950.0
/// PaymentMode : "Cash"
/// TransactionCode : ""
/// TransactionTime : ""
/// TransactionRemark : ""
/// AddedBy : 0
/// Action : null
/// ItemId : 8
/// ItemName : "4 Burner GT"
/// Rate : 4500.0
/// ItemQty : 2
/// DiscountAmt : 50.0
/// ARBAmount : 8950.0
/// ItemDataList : null
/// DenomDtList : null
/// ItemDetails : [{"ARBSalesId":0,"DistributorId":0,"SaleDate":null,"StaffId":0,"StaffName":null,"ConsumerNo":null,"ConsumerName":null,"TotalAmount":0.0,"PaymentMode":null,"TransactionCode":null,"TransactionTime":null,"TransactionRemark":null,"AddedBy":0,"Action":null,"ItemId":8,"ItemName":"4 Burner GT","Rate":4500.0,"ItemQty":2,"DiscountAmt":50.0,"ARBAmount":8950.0,"ItemDataList":null,"DenomDtList":null,"ItemDetails":null,"BankId":0,"BankMappingId":0}]
/// BankId : 0
/// BankMappingId : 0

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
      dynamic itemDataList, 
      dynamic denomDtList, 
      List<ItemDetails>? itemDetails, 
      num? bankId, 
      num? bankMappingId,}){
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
    _itemDetails = itemDetails;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
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
    _itemDataList = json['ItemDataList'];
    _denomDtList = json['DenomDtList'];
    if (json['ItemDetails'] != null) {
      _itemDetails = [];
      json['ItemDetails'].forEach((v) {
        _itemDetails?.add(ItemDetails.fromJson(v));
      });
    }
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
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
  dynamic _itemDataList;
  dynamic _denomDtList;
  List<ItemDetails>? _itemDetails;
  num? _bankId;
  num? _bankMappingId;
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
  dynamic itemDataList,
  dynamic denomDtList,
  List<ItemDetails>? itemDetails,
  num? bankId,
  num? bankMappingId,
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
  itemDetails: itemDetails ?? _itemDetails,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
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
  dynamic get itemDataList => _itemDataList;
  dynamic get denomDtList => _denomDtList;
  List<ItemDetails>? get itemDetails => _itemDetails;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;

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
    map['ItemDataList'] = _itemDataList;
    map['DenomDtList'] = _denomDtList;
    if (_itemDetails != null) {
      map['ItemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    return map;
  }

}

/// ARBSalesId : 0
/// DistributorId : 0
/// SaleDate : null
/// StaffId : 0
/// StaffName : null
/// ConsumerNo : null
/// ConsumerName : null
/// TotalAmount : 0.0
/// PaymentMode : null
/// TransactionCode : null
/// TransactionTime : null
/// TransactionRemark : null
/// AddedBy : 0
/// Action : null
/// ItemId : 8
/// ItemName : "4 Burner GT"
/// Rate : 4500.0
/// ItemQty : 2
/// DiscountAmt : 50.0
/// ARBAmount : 8950.0
/// ItemDataList : null
/// DenomDtList : null
/// ItemDetails : null
/// BankId : 0
/// BankMappingId : 0

class ItemDetails {
  ItemDetails({
      num? aRBSalesId, 
      num? distributorId, 
      dynamic saleDate, 
      num? staffId, 
      dynamic staffName, 
      dynamic consumerNo, 
      dynamic consumerName, 
      num? totalAmount, 
      dynamic paymentMode, 
      dynamic transactionCode, 
      dynamic transactionTime, 
      dynamic transactionRemark, 
      num? addedBy, 
      dynamic action, 
      num? itemId, 
      String? itemName, 
      num? rate, 
      num? itemQty, 
      num? discountAmt, 
      num? aRBAmount, 
      dynamic itemDataList, 
      dynamic denomDtList, 
      dynamic itemDetails, 
      num? bankId, 
      num? bankMappingId,}){
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
    _itemDetails = itemDetails;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
}

  ItemDetails.fromJson(dynamic json) {
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
    _itemDataList = json['ItemDataList'];
    _denomDtList = json['DenomDtList'];
    _itemDetails = json['ItemDetails'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
  }
  num? _aRBSalesId;
  num? _distributorId;
  dynamic _saleDate;
  num? _staffId;
  dynamic _staffName;
  dynamic _consumerNo;
  dynamic _consumerName;
  num? _totalAmount;
  dynamic _paymentMode;
  dynamic _transactionCode;
  dynamic _transactionTime;
  dynamic _transactionRemark;
  num? _addedBy;
  dynamic _action;
  num? _itemId;
  String? _itemName;
  num? _rate;
  num? _itemQty;
  num? _discountAmt;
  num? _aRBAmount;
  dynamic _itemDataList;
  dynamic _denomDtList;
  dynamic _itemDetails;
  num? _bankId;
  num? _bankMappingId;
ItemDetails copyWith({  num? aRBSalesId,
  num? distributorId,
  dynamic saleDate,
  num? staffId,
  dynamic staffName,
  dynamic consumerNo,
  dynamic consumerName,
  num? totalAmount,
  dynamic paymentMode,
  dynamic transactionCode,
  dynamic transactionTime,
  dynamic transactionRemark,
  num? addedBy,
  dynamic action,
  num? itemId,
  String? itemName,
  num? rate,
  num? itemQty,
  num? discountAmt,
  num? aRBAmount,
  dynamic itemDataList,
  dynamic denomDtList,
  dynamic itemDetails,
  num? bankId,
  num? bankMappingId,
}) => ItemDetails(  aRBSalesId: aRBSalesId ?? _aRBSalesId,
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
  itemDetails: itemDetails ?? _itemDetails,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
);
  num? get aRBSalesId => _aRBSalesId;
  num? get distributorId => _distributorId;
  dynamic get saleDate => _saleDate;
  num? get staffId => _staffId;
  dynamic get staffName => _staffName;
  dynamic get consumerNo => _consumerNo;
  dynamic get consumerName => _consumerName;
  num? get totalAmount => _totalAmount;
  dynamic get paymentMode => _paymentMode;
  dynamic get transactionCode => _transactionCode;
  dynamic get transactionTime => _transactionTime;
  dynamic get transactionRemark => _transactionRemark;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rate => _rate;
  num? get itemQty => _itemQty;
  num? get discountAmt => _discountAmt;
  num? get aRBAmount => _aRBAmount;
  dynamic get itemDataList => _itemDataList;
  dynamic get denomDtList => _denomDtList;
  dynamic get itemDetails => _itemDetails;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;

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
    map['ItemDataList'] = _itemDataList;
    map['DenomDtList'] = _denomDtList;
    map['ItemDetails'] = _itemDetails;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    return map;
  }

}