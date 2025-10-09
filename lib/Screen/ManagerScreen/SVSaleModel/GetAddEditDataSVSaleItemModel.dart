/// PSVId : 905
/// DistributorId : 8118
/// SVDate : "2025-05-26T14:17:43"
/// ReferredById : 48
/// ReferredByName : "Anopa"
/// OtherName : ""
/// ProductId : 5
/// ProductName : "2 KG FTL"
/// IsUndocument : true
/// SVType : "NC"
/// CylQty : 2
/// SCRegulator : 0
/// DepositCyl : 1300.00
/// CylRefillRSP : 500.00
/// RegulatorDeposit : 250.00
/// StampDuty : 100.0
/// FTLRegulator : 1
/// BasicAmt : 2140.00
/// ConsuDCNo : "876522"
/// ConsumerName : ""
/// ConsuContactNo : ""
/// TotalAmount : 2140.00
/// ReceiptAmt : 2140.00
/// PaymentMode : "Bank"
/// TransactionCode : "4"
/// TransactionTime : ""
/// TransactionRemark : ""
/// AddedBy : 0
/// Action : null
/// ItemId : 0
/// ItemName : null
/// Rate : 0.00
/// ItemQty : 0
/// DiscountAmt : 0.00
/// ARBAmount : 0.00
/// ItemDataList : null
/// DenomDtList : null
/// ItemDetails : [{"PSVId":0,"DistributorId":0,"SVDate":null,"ReferredById":0,"ReferredByName":null,"OtherName":null,"ProductId":0,"ProductName":null,"IsUndocument":false,"SVType":null,"CylQty":0,"SCRegulator":0,"DepositCyl":0.0,"CylRefillRSP":0.0,"RegulatorDeposit":0.0,"StampDuty":0.0,"FTLRegulator":0,"BasicAmt":0.0,"ConsuDCNo":null,"ConsumerName":null,"ConsuContactNo":null,"TotalAmount":0.0,"ReceiptAmt":0.0,"PaymentMode":null,"TransactionCode":null,"TransactionTime":null,"TransactionRemark":null,"AddedBy":0,"Action":null,"ItemId":0,"ItemName":null,"Rate":0.00,"ItemQty":0,"DiscountAmt":0.00,"ARBAmount":0.00,"ItemDataList":null,"DenomDtList":null,"ItemDetails":null,"AmtCharges":0.0,"CategoryName":"","BankId":0,"BankMappingId":0,"AccountNo":null,"BankName":null,"IsExemptReti":0,"SVDiscountAmt":0.0}]
/// AmtCharges : 0.00
/// CategoryName : ""
/// BankId : 14
/// BankMappingId : 19
/// AccountNo : "7777005279799"
/// BankName : "ICICI"
/// IsExemptReti : 0
/// SVDiscountAmt : 10.00

class GetAddEditDataSvSaleItemModel {
  GetAddEditDataSvSaleItemModel({
      num? pSVId, 
      num? distributorId, 
      String? sVDate, 
      num? referredById, 
      String? referredByName, 
      String? otherName, 
      num? productId, 
      String? productName, 
      bool? isUndocument, 
      String? sVType, 
      num? cylQty, 
      num? sCRegulator, 
      num? depositCyl, 
      num? cylRefillRSP, 
      num? regulatorDeposit, 
      num? stampDuty, 
      num? fTLRegulator, 
      num? basicAmt, 
      String? consuDCNo, 
      String? consumerName, 
      String? consuContactNo, 
      num? totalAmount, 
      num? receiptAmt, 
      num? qrReceiptAmt,
      String? paymentMode,
      String? transactionCode, 
      String? transactionTime, 
      String? transactionRemark, 
      num? addedBy, 
      dynamic action, 
      num? itemId, 
      dynamic itemName, 
      num? rate, 
      num? itemQty, 
      num? discountAmt, 
      num? aRBAmount, 
      dynamic itemDataList, 
      dynamic denomDtList, 
      List<ItemDetails>? itemDetails, 
      num? amtCharges, 
      String? categoryName, 
      num? bankId, 
      num? bankMappingId, 
      String? accountNo, 
      String? bankName, 
      num? isExemptReti, 
      num? sVDiscountAmt,}){
    _pSVId = pSVId;
    _distributorId = distributorId;
    _sVDate = sVDate;
    _referredById = referredById;
    _referredByName = referredByName;
    _otherName = otherName;
    _productId = productId;
    _productName = productName;
    _isUndocument = isUndocument;
    _sVType = sVType;
    _cylQty = cylQty;
    _sCRegulator = sCRegulator;
    _depositCyl = depositCyl;
    _cylRefillRSP = cylRefillRSP;
    _regulatorDeposit = regulatorDeposit;
    _stampDuty = stampDuty;
    _fTLRegulator = fTLRegulator;
    _basicAmt = basicAmt;
    _consuDCNo = consuDCNo;
    _consumerName = consumerName;
    _consuContactNo = consuContactNo;
    _totalAmount = totalAmount;
    _receiptAmt = receiptAmt;
    _qrReceiptAmt = qrReceiptAmt;
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
    _amtCharges = amtCharges;
    _categoryName = categoryName;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
    _accountNo = accountNo;
    _bankName = bankName;
    _isExemptReti = isExemptReti;
    _sVDiscountAmt = sVDiscountAmt;
}

  GetAddEditDataSvSaleItemModel.fromJson(dynamic json) {
    _pSVId = json['PSVId'];
    _distributorId = json['DistributorId'];
    _sVDate = json['SVDate'];
    _referredById = json['ReferredById'];
    _referredByName = json['ReferredByName'];
    _otherName = json['OtherName'];
    _productId = json['ProductId'];
    _productName = json['ProductName'];
    _isUndocument = json['IsUndocument'];
    _sVType = json['SVType'];
    _cylQty = json['CylQty'];
    _sCRegulator = json['SCRegulator'];
    _depositCyl = json['DepositCyl'];
    _cylRefillRSP = json['CylRefillRSP'];
    _regulatorDeposit = json['RegulatorDeposit'];
    _stampDuty = json['StampDuty'];
    _fTLRegulator = json['FTLRegulator'];
    _basicAmt = json['BasicAmt'];
    _consuDCNo = json['ConsuDCNo'];
    _consumerName = json['ConsumerName'];
    _consuContactNo = json['ConsuContactNo'];
    _totalAmount = json['TotalAmount'];
    _receiptAmt = json['ReceiptAmt'];
    _qrReceiptAmt = json['QRReceiptAmt'];
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
    _amtCharges = json['AmtCharges'];
    _categoryName = json['CategoryName'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
    _accountNo = json['AccountNo'];
    _bankName = json['BankName'];
    _isExemptReti = json['IsExemptReti'];
    _sVDiscountAmt = json['SVDiscountAmt'];
  }
  num? _pSVId;
  num? _distributorId;
  String? _sVDate;
  num? _referredById;
  String? _referredByName;
  String? _otherName;
  num? _productId;
  String? _productName;
  bool? _isUndocument;
  String? _sVType;
  num? _cylQty;
  num? _sCRegulator;
  num? _depositCyl;
  num? _cylRefillRSP;
  num? _regulatorDeposit;
  num? _stampDuty;
  num? _fTLRegulator;
  num? _basicAmt;
  String? _consuDCNo;
  String? _consumerName;
  String? _consuContactNo;
  num? _totalAmount;
  num? _receiptAmt;
  num? _qrReceiptAmt;
  String? _paymentMode;
  String? _transactionCode;
  String? _transactionTime;
  String? _transactionRemark;
  num? _addedBy;
  dynamic _action;
  num? _itemId;
  dynamic _itemName;
  num? _rate;
  num? _itemQty;
  num? _discountAmt;
  num? _aRBAmount;
  dynamic _itemDataList;
  dynamic _denomDtList;
  List<ItemDetails>? _itemDetails;
  num? _amtCharges;
  String? _categoryName;
  num? _bankId;
  num? _bankMappingId;
  String? _accountNo;
  String? _bankName;
  num? _isExemptReti;
  num? _sVDiscountAmt;
GetAddEditDataSvSaleItemModel copyWith({  num? pSVId,
  num? distributorId,
  String? sVDate,
  num? referredById,
  String? referredByName,
  String? otherName,
  num? productId,
  String? productName,
  bool? isUndocument,
  String? sVType,
  num? cylQty,
  num? sCRegulator,
  num? depositCyl,
  num? cylRefillRSP,
  num? regulatorDeposit,
  num? stampDuty,
  num? fTLRegulator,
  num? basicAmt,
  String? consuDCNo,
  String? consumerName,
  String? consuContactNo,
  num? totalAmount,
  num? receiptAmt,
  num? qrReceiptAmt,
  String? paymentMode,
  String? transactionCode,
  String? transactionTime,
  String? transactionRemark,
  num? addedBy,
  dynamic action,
  num? itemId,
  dynamic itemName,
  num? rate,
  num? itemQty,
  num? discountAmt,
  num? aRBAmount,
  dynamic itemDataList,
  dynamic denomDtList,
  List<ItemDetails>? itemDetails,
  num? amtCharges,
  String? categoryName,
  num? bankId,
  num? bankMappingId,
  String? accountNo,
  String? bankName,
  num? isExemptReti,
  num? sVDiscountAmt,
}) => GetAddEditDataSvSaleItemModel(  pSVId: pSVId ?? _pSVId,
  distributorId: distributorId ?? _distributorId,
  sVDate: sVDate ?? _sVDate,
  referredById: referredById ?? _referredById,
  referredByName: referredByName ?? _referredByName,
  otherName: otherName ?? _otherName,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  isUndocument: isUndocument ?? _isUndocument,
  sVType: sVType ?? _sVType,
  cylQty: cylQty ?? _cylQty,
  sCRegulator: sCRegulator ?? _sCRegulator,
  depositCyl: depositCyl ?? _depositCyl,
  cylRefillRSP: cylRefillRSP ?? _cylRefillRSP,
  regulatorDeposit: regulatorDeposit ?? _regulatorDeposit,
  stampDuty: stampDuty ?? _stampDuty,
  fTLRegulator: fTLRegulator ?? _fTLRegulator,
  basicAmt: basicAmt ?? _basicAmt,
  consuDCNo: consuDCNo ?? _consuDCNo,
  consumerName: consumerName ?? _consumerName,
  consuContactNo: consuContactNo ?? _consuContactNo,
  totalAmount: totalAmount ?? _totalAmount,
  receiptAmt: receiptAmt ?? _receiptAmt,
  qrReceiptAmt: qrReceiptAmt ?? _qrReceiptAmt,
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
  amtCharges: amtCharges ?? _amtCharges,
  categoryName: categoryName ?? _categoryName,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
  accountNo: accountNo ?? _accountNo,
  bankName: bankName ?? _bankName,
  isExemptReti: isExemptReti ?? _isExemptReti,
  sVDiscountAmt: sVDiscountAmt ?? _sVDiscountAmt,
);
  num? get pSVId => _pSVId;
  num? get distributorId => _distributorId;
  String? get sVDate => _sVDate;
  num? get referredById => _referredById;
  String? get referredByName => _referredByName;
  String? get otherName => _otherName;
  num? get productId => _productId;
  String? get productName => _productName;
  bool? get isUndocument => _isUndocument;
  String? get sVType => _sVType;
  num? get cylQty => _cylQty;
  num? get sCRegulator => _sCRegulator;
  num? get depositCyl => _depositCyl;
  num? get cylRefillRSP => _cylRefillRSP;
  num? get regulatorDeposit => _regulatorDeposit;
  num? get stampDuty => _stampDuty;
  num? get fTLRegulator => _fTLRegulator;
  num? get basicAmt => _basicAmt;
  String? get consuDCNo => _consuDCNo;
  String? get consumerName => _consumerName;
  String? get consuContactNo => _consuContactNo;
  num? get totalAmount => _totalAmount;
  num? get receiptAmt => _receiptAmt;
  num? get qrReceiptAmt => _qrReceiptAmt;
  String? get paymentMode => _paymentMode;
  String? get transactionCode => _transactionCode;
  String? get transactionTime => _transactionTime;
  String? get transactionRemark => _transactionRemark;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  num? get itemId => _itemId;
  dynamic get itemName => _itemName;
  num? get rate => _rate;
  num? get itemQty => _itemQty;
  num? get discountAmt => _discountAmt;
  num? get aRBAmount => _aRBAmount;
  dynamic get itemDataList => _itemDataList;
  dynamic get denomDtList => _denomDtList;
  List<ItemDetails>? get itemDetails => _itemDetails;
  num? get amtCharges => _amtCharges;
  String? get categoryName => _categoryName;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;
  String? get accountNo => _accountNo;
  String? get bankName => _bankName;
  num? get isExemptReti => _isExemptReti;
  num? get sVDiscountAmt => _sVDiscountAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PSVId'] = _pSVId;
    map['DistributorId'] = _distributorId;
    map['SVDate'] = _sVDate;
    map['ReferredById'] = _referredById;
    map['ReferredByName'] = _referredByName;
    map['OtherName'] = _otherName;
    map['ProductId'] = _productId;
    map['ProductName'] = _productName;
    map['IsUndocument'] = _isUndocument;
    map['SVType'] = _sVType;
    map['CylQty'] = _cylQty;
    map['SCRegulator'] = _sCRegulator;
    map['DepositCyl'] = _depositCyl;
    map['CylRefillRSP'] = _cylRefillRSP;
    map['RegulatorDeposit'] = _regulatorDeposit;
    map['StampDuty'] = _stampDuty;
    map['FTLRegulator'] = _fTLRegulator;
    map['BasicAmt'] = _basicAmt;
    map['ConsuDCNo'] = _consuDCNo;
    map['ConsumerName'] = _consumerName;
    map['ConsuContactNo'] = _consuContactNo;
    map['TotalAmount'] = _totalAmount;
    map['ReceiptAmt'] = _receiptAmt;
    map['QRReceiptAmt'] = _qrReceiptAmt;
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
    map['AmtCharges'] = _amtCharges;
    map['CategoryName'] = _categoryName;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    map['AccountNo'] = _accountNo;
    map['BankName'] = _bankName;
    map['IsExemptReti'] = _isExemptReti;
    map['SVDiscountAmt'] = _sVDiscountAmt;
    return map;
  }

}

/// PSVId : 0
/// DistributorId : 0
/// SVDate : null
/// ReferredById : 0
/// ReferredByName : null
/// OtherName : null
/// ProductId : 0
/// ProductName : null
/// IsUndocument : false
/// SVType : null
/// CylQty : 0
/// SCRegulator : 0
/// DepositCyl : 0.0
/// CylRefillRSP : 0.0
/// RegulatorDeposit : 0.0
/// StampDuty : 0.0
/// FTLRegulator : 0
/// BasicAmt : 0.0
/// ConsuDCNo : null
/// ConsumerName : null
/// ConsuContactNo : null
/// TotalAmount : 0.0
/// ReceiptAmt : 0.0
/// PaymentMode : null
/// TransactionCode : null
/// TransactionTime : null
/// TransactionRemark : null
/// AddedBy : 0
/// Action : null
/// ItemId : 0
/// ItemName : null
/// Rate : 0.00
/// ItemQty : 0
/// DiscountAmt : 0.00
/// ARBAmount : 0.00
/// ItemDataList : null
/// DenomDtList : null
/// ItemDetails : null
/// AmtCharges : 0.0
/// CategoryName : ""
/// BankId : 0
/// BankMappingId : 0
/// AccountNo : null
/// BankName : null
/// IsExemptReti : 0
/// SVDiscountAmt : 0.0

class ItemDetails {
  ItemDetails({
      num? pSVId, 
      num? distributorId, 
      dynamic sVDate, 
      num? referredById, 
      dynamic referredByName, 
      dynamic otherName, 
      num? productId, 
      dynamic productName, 
      bool? isUndocument, 
      dynamic sVType, 
      num? cylQty, 
      num? sCRegulator, 
      num? depositCyl, 
      num? cylRefillRSP, 
      num? regulatorDeposit, 
      num? stampDuty, 
      num? fTLRegulator, 
      num? basicAmt, 
      dynamic consuDCNo, 
      dynamic consumerName, 
      dynamic consuContactNo, 
      num? totalAmount, 
      num? receiptAmt, 
      num? qrReceiptAmt,
      dynamic paymentMode,
      dynamic transactionCode, 
      dynamic transactionTime, 
      dynamic transactionRemark, 
      num? addedBy, 
      dynamic action, 
      num? itemId, 
      dynamic itemName, 
      num? rate, 
      num? itemQty, 
      num? discountAmt, 
      num? aRBAmount, 
      dynamic itemDataList, 
      dynamic denomDtList, 
      dynamic itemDetails, 
      num? amtCharges, 
      String? categoryName, 
      num? bankId, 
      num? bankMappingId, 
      dynamic accountNo, 
      dynamic bankName, 
      num? isExemptReti, 
      num? sVDiscountAmt,}){
    _pSVId = pSVId;
    _distributorId = distributorId;
    _sVDate = sVDate;
    _referredById = referredById;
    _referredByName = referredByName;
    _otherName = otherName;
    _productId = productId;
    _productName = productName;
    _isUndocument = isUndocument;
    _sVType = sVType;
    _cylQty = cylQty;
    _sCRegulator = sCRegulator;
    _depositCyl = depositCyl;
    _cylRefillRSP = cylRefillRSP;
    _regulatorDeposit = regulatorDeposit;
    _stampDuty = stampDuty;
    _fTLRegulator = fTLRegulator;
    _basicAmt = basicAmt;
    _consuDCNo = consuDCNo;
    _consumerName = consumerName;
    _consuContactNo = consuContactNo;
    _totalAmount = totalAmount;
    _receiptAmt = receiptAmt;
    _qrReceiptAmt = qrReceiptAmt;
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
    _amtCharges = amtCharges;
    _categoryName = categoryName;
    _bankId = bankId;
    _bankMappingId = bankMappingId;
    _accountNo = accountNo;
    _bankName = bankName;
    _isExemptReti = isExemptReti;
    _sVDiscountAmt = sVDiscountAmt;
}

  ItemDetails.fromJson(dynamic json) {
    _pSVId = json['PSVId'];
    _distributorId = json['DistributorId'];
    _sVDate = json['SVDate'];
    _referredById = json['ReferredById'];
    _referredByName = json['ReferredByName'];
    _otherName = json['OtherName'];
    _productId = json['ProductId'];
    _productName = json['ProductName'];
    _isUndocument = json['IsUndocument'];
    _sVType = json['SVType'];
    _cylQty = json['CylQty'];
    _sCRegulator = json['SCRegulator'];
    _depositCyl = json['DepositCyl'];
    _cylRefillRSP = json['CylRefillRSP'];
    _regulatorDeposit = json['RegulatorDeposit'];
    _stampDuty = json['StampDuty'];
    _fTLRegulator = json['FTLRegulator'];
    _basicAmt = json['BasicAmt'];
    _consuDCNo = json['ConsuDCNo'];
    _consumerName = json['ConsumerName'];
    _consuContactNo = json['ConsuContactNo'];
    _totalAmount = json['TotalAmount'];
    _receiptAmt = json['ReceiptAmt'];
    _qrReceiptAmt = json['QRReceiptAmt'];
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
    _amtCharges = json['AmtCharges'];
    _categoryName = json['CategoryName'];
    _bankId = json['BankId'];
    _bankMappingId = json['BankMappingId'];
    _accountNo = json['AccountNo'];
    _bankName = json['BankName'];
    _isExemptReti = json['IsExemptReti'];
    _sVDiscountAmt = json['SVDiscountAmt'];
  }
  num? _pSVId;
  num? _distributorId;
  dynamic _sVDate;
  num? _referredById;
  dynamic _referredByName;
  dynamic _otherName;
  num? _productId;
  dynamic _productName;
  bool? _isUndocument;
  dynamic _sVType;
  num? _cylQty;
  num? _sCRegulator;
  num? _depositCyl;
  num? _cylRefillRSP;
  num? _regulatorDeposit;
  num? _stampDuty;
  num? _fTLRegulator;
  num? _basicAmt;
  dynamic _consuDCNo;
  dynamic _consumerName;
  dynamic _consuContactNo;
  num? _totalAmount;
  num? _receiptAmt;
  num? _qrReceiptAmt;
  dynamic _paymentMode;
  dynamic _transactionCode;
  dynamic _transactionTime;
  dynamic _transactionRemark;
  num? _addedBy;
  dynamic _action;
  num? _itemId;
  dynamic _itemName;
  num? _rate;
  num? _itemQty;
  num? _discountAmt;
  num? _aRBAmount;
  dynamic _itemDataList;
  dynamic _denomDtList;
  dynamic _itemDetails;
  num? _amtCharges;
  String? _categoryName;
  num? _bankId;
  num? _bankMappingId;
  dynamic _accountNo;
  dynamic _bankName;
  num? _isExemptReti;
  num? _sVDiscountAmt;
ItemDetails copyWith({  num? pSVId,
  num? distributorId,
  dynamic sVDate,
  num? referredById,
  dynamic referredByName,
  dynamic otherName,
  num? productId,
  dynamic productName,
  bool? isUndocument,
  dynamic sVType,
  num? cylQty,
  num? sCRegulator,
  num? depositCyl,
  num? cylRefillRSP,
  num? regulatorDeposit,
  num? stampDuty,
  num? fTLRegulator,
  num? basicAmt,
  dynamic consuDCNo,
  dynamic consumerName,
  dynamic consuContactNo,
  num? totalAmount,
  num? receiptAmt,
  num? qrReceiptAmt,
  dynamic paymentMode,
  dynamic transactionCode,
  dynamic transactionTime,
  dynamic transactionRemark,
  num? addedBy,
  dynamic action,
  num? itemId,
  dynamic itemName,
  num? rate,
  num? itemQty,
  num? discountAmt,
  num? aRBAmount,
  dynamic itemDataList,
  dynamic denomDtList,
  dynamic itemDetails,
  num? amtCharges,
  String? categoryName,
  num? bankId,
  num? bankMappingId,
  dynamic accountNo,
  dynamic bankName,
  num? isExemptReti,
  num? sVDiscountAmt,
}) => ItemDetails(  pSVId: pSVId ?? _pSVId,
  distributorId: distributorId ?? _distributorId,
  sVDate: sVDate ?? _sVDate,
  referredById: referredById ?? _referredById,
  referredByName: referredByName ?? _referredByName,
  otherName: otherName ?? _otherName,
  productId: productId ?? _productId,
  productName: productName ?? _productName,
  isUndocument: isUndocument ?? _isUndocument,
  sVType: sVType ?? _sVType,
  cylQty: cylQty ?? _cylQty,
  sCRegulator: sCRegulator ?? _sCRegulator,
  depositCyl: depositCyl ?? _depositCyl,
  cylRefillRSP: cylRefillRSP ?? _cylRefillRSP,
  regulatorDeposit: regulatorDeposit ?? _regulatorDeposit,
  stampDuty: stampDuty ?? _stampDuty,
  fTLRegulator: fTLRegulator ?? _fTLRegulator,
  basicAmt: basicAmt ?? _basicAmt,
  consuDCNo: consuDCNo ?? _consuDCNo,
  consumerName: consumerName ?? _consumerName,
  consuContactNo: consuContactNo ?? _consuContactNo,
  totalAmount: totalAmount ?? _totalAmount,
  receiptAmt: receiptAmt ?? _receiptAmt,
  qrReceiptAmt: qrReceiptAmt ?? _qrReceiptAmt,
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
  amtCharges: amtCharges ?? _amtCharges,
  categoryName: categoryName ?? _categoryName,
  bankId: bankId ?? _bankId,
  bankMappingId: bankMappingId ?? _bankMappingId,
  accountNo: accountNo ?? _accountNo,
  bankName: bankName ?? _bankName,
  isExemptReti: isExemptReti ?? _isExemptReti,
  sVDiscountAmt: sVDiscountAmt ?? _sVDiscountAmt,
);
  num? get pSVId => _pSVId;
  num? get distributorId => _distributorId;
  dynamic get sVDate => _sVDate;
  num? get referredById => _referredById;
  dynamic get referredByName => _referredByName;
  dynamic get otherName => _otherName;
  num? get productId => _productId;
  dynamic get productName => _productName;
  bool? get isUndocument => _isUndocument;
  dynamic get sVType => _sVType;
  num? get cylQty => _cylQty;
  num? get sCRegulator => _sCRegulator;
  num? get depositCyl => _depositCyl;
  num? get cylRefillRSP => _cylRefillRSP;
  num? get regulatorDeposit => _regulatorDeposit;
  num? get stampDuty => _stampDuty;
  num? get fTLRegulator => _fTLRegulator;
  num? get basicAmt => _basicAmt;
  dynamic get consuDCNo => _consuDCNo;
  dynamic get consumerName => _consumerName;
  dynamic get consuContactNo => _consuContactNo;
  num? get totalAmount => _totalAmount;
  num? get receiptAmt => _receiptAmt;
  num? get qrReceiptAmt => _qrReceiptAmt;
  dynamic get paymentMode => _paymentMode;
  dynamic get transactionCode => _transactionCode;
  dynamic get transactionTime => _transactionTime;
  dynamic get transactionRemark => _transactionRemark;
  num? get addedBy => _addedBy;
  dynamic get action => _action;
  num? get itemId => _itemId;
  dynamic get itemName => _itemName;
  num? get rate => _rate;
  num? get itemQty => _itemQty;
  num? get discountAmt => _discountAmt;
  num? get aRBAmount => _aRBAmount;
  dynamic get itemDataList => _itemDataList;
  dynamic get denomDtList => _denomDtList;
  dynamic get itemDetails => _itemDetails;
  num? get amtCharges => _amtCharges;
  String? get categoryName => _categoryName;
  num? get bankId => _bankId;
  num? get bankMappingId => _bankMappingId;
  dynamic get accountNo => _accountNo;
  dynamic get bankName => _bankName;
  num? get isExemptReti => _isExemptReti;
  num? get sVDiscountAmt => _sVDiscountAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PSVId'] = _pSVId;
    map['DistributorId'] = _distributorId;
    map['SVDate'] = _sVDate;
    map['ReferredById'] = _referredById;
    map['ReferredByName'] = _referredByName;
    map['OtherName'] = _otherName;
    map['ProductId'] = _productId;
    map['ProductName'] = _productName;
    map['IsUndocument'] = _isUndocument;
    map['SVType'] = _sVType;
    map['CylQty'] = _cylQty;
    map['SCRegulator'] = _sCRegulator;
    map['DepositCyl'] = _depositCyl;
    map['CylRefillRSP'] = _cylRefillRSP;
    map['RegulatorDeposit'] = _regulatorDeposit;
    map['StampDuty'] = _stampDuty;
    map['FTLRegulator'] = _fTLRegulator;
    map['BasicAmt'] = _basicAmt;
    map['ConsuDCNo'] = _consuDCNo;
    map['ConsumerName'] = _consumerName;
    map['ConsuContactNo'] = _consuContactNo;
    map['TotalAmount'] = _totalAmount;
    map['ReceiptAmt'] = _receiptAmt;
    map['QRReceiptAmt'] = _qrReceiptAmt;
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
    map['AmtCharges'] = _amtCharges;
    map['CategoryName'] = _categoryName;
    map['BankId'] = _bankId;
    map['BankMappingId'] = _bankMappingId;
    map['AccountNo'] = _accountNo;
    map['BankName'] = _bankName;
    map['IsExemptReti'] = _isExemptReti;
    map['SVDiscountAmt'] = _sVDiscountAmt;
    return map;
  }

}