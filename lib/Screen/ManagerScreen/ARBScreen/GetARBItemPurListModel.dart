/// ARBPurId : 28
/// ARBPurIdDtls : 0
/// PurQty : 2
/// DistributorId : 0
/// InvoiceNo : "hhccgzs"
/// VendorId : 17
/// VendorName : "wer"
/// InvoiceDate : "2025-06-24T00:00:00"
/// TotalAmount : 1650.00
/// PaidAmount : 0.00
/// BalanceAmount : 1650.00
/// NetAmount : 1650.00
/// Remark : ""
/// ItemDetails : [{"pkId":0,"ItemId":11,"ItemName":"Safety Campaign Hose","Rate":800.00,"PurQty":2,"BasicAmount":1600.00,"TaxAmount":50.00,"NetAmount":1650.00}]
/// TransactionCode : null
/// DayEnd : 0

class GetArbItemPurListModel {
  GetArbItemPurListModel({
      num? aRBPurId, 
      num? aRBPurIdDtls, 
      num? purQty, 
      num? distributorId, 
      String? invoiceNo, 
      num? vendorId, 
      String? vendorName, 
      String? invoiceDate, 
      num? totalAmount, 
      num? paidAmount, 
      num? balanceAmount, 
      num? netAmount, 
      String? remark, 
      List<ItemDetails>? itemDetails, 
      dynamic transactionCode, 
      num? dayEnd,}){
    _aRBPurId = aRBPurId;
    _aRBPurIdDtls = aRBPurIdDtls;
    _purQty = purQty;
    _distributorId = distributorId;
    _invoiceNo = invoiceNo;
    _vendorId = vendorId;
    _vendorName = vendorName;
    _invoiceDate = invoiceDate;
    _totalAmount = totalAmount;
    _paidAmount = paidAmount;
    _balanceAmount = balanceAmount;
    _netAmount = netAmount;
    _remark = remark;
    _itemDetails = itemDetails;
    _transactionCode = transactionCode;
    _dayEnd = dayEnd;
}

  GetArbItemPurListModel.fromJson(dynamic json) {
    _aRBPurId = json['ARBPurId'];
    _aRBPurIdDtls = json['ARBPurIdDtls'];
    _purQty = json['PurQty'];
    _distributorId = json['DistributorId'];
    _invoiceNo = json['InvoiceNo'];
    _vendorId = json['VendorId'];
    _vendorName = json['VendorName'];
    _invoiceDate = json['InvoiceDate'];
    _totalAmount = json['TotalAmount'];
    _paidAmount = json['PaidAmount'];
    _balanceAmount = json['BalanceAmount'];
    _netAmount = json['NetAmount'];
    _remark = json['Remark'];
    if (json['ItemDetails'] != null) {
      _itemDetails = [];
      json['ItemDetails'].forEach((v) {
        _itemDetails?.add(ItemDetails.fromJson(v));
      });
    }
    _transactionCode = json['TransactionCode'];
    _dayEnd = json['DayEnd'];
  }
  num? _aRBPurId;
  num? _aRBPurIdDtls;
  num? _purQty;
  num? _distributorId;
  String? _invoiceNo;
  num? _vendorId;
  String? _vendorName;
  String? _invoiceDate;
  num? _totalAmount;
  num? _paidAmount;
  num? _balanceAmount;
  num? _netAmount;
  String? _remark;
  List<ItemDetails>? _itemDetails;
  dynamic _transactionCode;
  num? _dayEnd;
GetArbItemPurListModel copyWith({  num? aRBPurId,
  num? aRBPurIdDtls,
  num? purQty,
  num? distributorId,
  String? invoiceNo,
  num? vendorId,
  String? vendorName,
  String? invoiceDate,
  num? totalAmount,
  num? paidAmount,
  num? balanceAmount,
  num? netAmount,
  String? remark,
  List<ItemDetails>? itemDetails,
  dynamic transactionCode,
  num? dayEnd,
}) => GetArbItemPurListModel(  aRBPurId: aRBPurId ?? _aRBPurId,
  aRBPurIdDtls: aRBPurIdDtls ?? _aRBPurIdDtls,
  purQty: purQty ?? _purQty,
  distributorId: distributorId ?? _distributorId,
  invoiceNo: invoiceNo ?? _invoiceNo,
  vendorId: vendorId ?? _vendorId,
  vendorName: vendorName ?? _vendorName,
  invoiceDate: invoiceDate ?? _invoiceDate,
  totalAmount: totalAmount ?? _totalAmount,
  paidAmount: paidAmount ?? _paidAmount,
  balanceAmount: balanceAmount ?? _balanceAmount,
  netAmount: netAmount ?? _netAmount,
  remark: remark ?? _remark,
  itemDetails: itemDetails ?? _itemDetails,
  transactionCode: transactionCode ?? _transactionCode,
  dayEnd: dayEnd ?? _dayEnd,
);
  num? get aRBPurId => _aRBPurId;
  num? get aRBPurIdDtls => _aRBPurIdDtls;
  num? get purQty => _purQty;
  num? get distributorId => _distributorId;
  String? get invoiceNo => _invoiceNo;
  num? get vendorId => _vendorId;
  String? get vendorName => _vendorName;
  String? get invoiceDate => _invoiceDate;
  num? get totalAmount => _totalAmount;
  num? get paidAmount => _paidAmount;
  num? get balanceAmount => _balanceAmount;
  num? get netAmount => _netAmount;
  String? get remark => _remark;
  List<ItemDetails>? get itemDetails => _itemDetails;
  dynamic get transactionCode => _transactionCode;
  num? get dayEnd => _dayEnd;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ARBPurId'] = _aRBPurId;
    map['ARBPurIdDtls'] = _aRBPurIdDtls;
    map['PurQty'] = _purQty;
    map['DistributorId'] = _distributorId;
    map['InvoiceNo'] = _invoiceNo;
    map['VendorId'] = _vendorId;
    map['VendorName'] = _vendorName;
    map['InvoiceDate'] = _invoiceDate;
    map['TotalAmount'] = _totalAmount;
    map['PaidAmount'] = _paidAmount;
    map['BalanceAmount'] = _balanceAmount;
    map['NetAmount'] = _netAmount;
    map['Remark'] = _remark;
    if (_itemDetails != null) {
      map['ItemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    map['TransactionCode'] = _transactionCode;
    map['DayEnd'] = _dayEnd;
    return map;
  }

}

/// pkId : 0
/// ItemId : 11
/// ItemName : "Safety Campaign Hose"
/// Rate : 800.00
/// PurQty : 2
/// BasicAmount : 1600.00
/// TaxAmount : 50.00
/// NetAmount : 1650.00

class ItemDetails {
  ItemDetails({
      num? pkId, 
      num? itemId, 
      String? itemName, 
      num? rate, 
      num? purQty, 
      num? basicAmount, 
      num? taxAmount, 
      num? netAmount,}){
    _pkId = pkId;
    _itemId = itemId;
    _itemName = itemName;
    _rate = rate;
    _purQty = purQty;
    _basicAmount = basicAmount;
    _taxAmount = taxAmount;
    _netAmount = netAmount;
}

  ItemDetails.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _rate = json['Rate'];
    _purQty = json['PurQty'];
    _basicAmount = json['BasicAmount'];
    _taxAmount = json['TaxAmount'];
    _netAmount = json['NetAmount'];
  }
  num? _pkId;
  num? _itemId;
  String? _itemName;
  num? _rate;
  num? _purQty;
  num? _basicAmount;
  num? _taxAmount;
  num? _netAmount;
ItemDetails copyWith({  num? pkId,
  num? itemId,
  String? itemName,
  num? rate,
  num? purQty,
  num? basicAmount,
  num? taxAmount,
  num? netAmount,
}) => ItemDetails(  pkId: pkId ?? _pkId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  rate: rate ?? _rate,
  purQty: purQty ?? _purQty,
  basicAmount: basicAmount ?? _basicAmount,
  taxAmount: taxAmount ?? _taxAmount,
  netAmount: netAmount ?? _netAmount,
);
  num? get pkId => _pkId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rate => _rate;
  num? get purQty => _purQty;
  num? get basicAmount => _basicAmount;
  num? get taxAmount => _taxAmount;
  num? get netAmount => _netAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['Rate'] = _rate;
    map['PurQty'] = _purQty;
    map['BasicAmount'] = _basicAmount;
    map['TaxAmount'] = _taxAmount;
    map['NetAmount'] = _netAmount;
    return map;
  }

}