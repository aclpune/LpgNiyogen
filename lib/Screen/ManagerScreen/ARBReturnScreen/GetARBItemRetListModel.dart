/// ARBRetId : 11
/// ARBRetIdDtls : 0
/// RetQty : 2
/// DistributorId : 0
/// VendorId : 17
/// VendorName : "wer"
/// ReturnDate : "2025-07-04T00:00:00"
/// RetQtySum : 2
/// TotalAmount : 200.00
/// Amount : 200.00
/// Remark : ""
/// CNNo : null
/// CNAmt : 0.0
/// CNRemark : null
/// DayEnd : 0
/// ItemDetails : [{"pkId":0,"ItemId":14,"ItemName":"DGCC Book","Rate":100.00,"RetQty":2,"Reason":"defective","Amount":200.00}]

class GetArbItemRetListModel {
  GetArbItemRetListModel({
      num? aRBRetId, 
      num? aRBRetIdDtls, 
      num? retQty, 
      num? distributorId, 
      num? vendorId, 
      String? vendorName, 
      String? returnDate, 
      num? retQtySum, 
      num? totalAmount, 
      num? amount, 
      String? remark, 
      dynamic cNNo, 
      num? cNAmt, 
      dynamic cNRemark, 
      num? dayEnd, 
      List<ItemDetails>? itemDetails,}){
    _aRBRetId = aRBRetId;
    _aRBRetIdDtls = aRBRetIdDtls;
    _retQty = retQty;
    _distributorId = distributorId;
    _vendorId = vendorId;
    _vendorName = vendorName;
    _returnDate = returnDate;
    _retQtySum = retQtySum;
    _totalAmount = totalAmount;
    _amount = amount;
    _remark = remark;
    _cNNo = cNNo;
    _cNAmt = cNAmt;
    _cNRemark = cNRemark;
    _dayEnd = dayEnd;
    _itemDetails = itemDetails;
}

  GetArbItemRetListModel.fromJson(dynamic json) {
    _aRBRetId = json['ARBRetId'];
    _aRBRetIdDtls = json['ARBRetIdDtls'];
    _retQty = json['RetQty'];
    _distributorId = json['DistributorId'];
    _vendorId = json['VendorId'];
    _vendorName = json['VendorName'];
    _returnDate = json['ReturnDate'];
    _retQtySum = json['RetQtySum'];
    _totalAmount = json['TotalAmount'];
    _amount = json['Amount'];
    _remark = json['Remark'];
    _cNNo = json['CNNo'];
    _cNAmt = json['CNAmt'];
    _cNRemark = json['CNRemark'];
    _dayEnd = json['DayEnd'];
    if (json['ItemDetails'] != null) {
      _itemDetails = [];
      json['ItemDetails'].forEach((v) {
        _itemDetails?.add(ItemDetails.fromJson(v));
      });
    }
  }
  num? _aRBRetId;
  num? _aRBRetIdDtls;
  num? _retQty;
  num? _distributorId;
  num? _vendorId;
  String? _vendorName;
  String? _returnDate;
  num? _retQtySum;
  num? _totalAmount;
  num? _amount;
  String? _remark;
  dynamic _cNNo;
  num? _cNAmt;
  dynamic _cNRemark;
  num? _dayEnd;
  List<ItemDetails>? _itemDetails;
GetArbItemRetListModel copyWith({  num? aRBRetId,
  num? aRBRetIdDtls,
  num? retQty,
  num? distributorId,
  num? vendorId,
  String? vendorName,
  String? returnDate,
  num? retQtySum,
  num? totalAmount,
  num? amount,
  String? remark,
  dynamic cNNo,
  num? cNAmt,
  dynamic cNRemark,
  num? dayEnd,
  List<ItemDetails>? itemDetails,
}) => GetArbItemRetListModel(  aRBRetId: aRBRetId ?? _aRBRetId,
  aRBRetIdDtls: aRBRetIdDtls ?? _aRBRetIdDtls,
  retQty: retQty ?? _retQty,
  distributorId: distributorId ?? _distributorId,
  vendorId: vendorId ?? _vendorId,
  vendorName: vendorName ?? _vendorName,
  returnDate: returnDate ?? _returnDate,
  retQtySum: retQtySum ?? _retQtySum,
  totalAmount: totalAmount ?? _totalAmount,
  amount: amount ?? _amount,
  remark: remark ?? _remark,
  cNNo: cNNo ?? _cNNo,
  cNAmt: cNAmt ?? _cNAmt,
  cNRemark: cNRemark ?? _cNRemark,
  dayEnd: dayEnd ?? _dayEnd,
  itemDetails: itemDetails ?? _itemDetails,
);
  num? get aRBRetId => _aRBRetId;
  num? get aRBRetIdDtls => _aRBRetIdDtls;
  num? get retQty => _retQty;
  num? get distributorId => _distributorId;
  num? get vendorId => _vendorId;
  String? get vendorName => _vendorName;
  String? get returnDate => _returnDate;
  num? get retQtySum => _retQtySum;
  num? get totalAmount => _totalAmount;
  num? get amount => _amount;
  String? get remark => _remark;
  dynamic get cNNo => _cNNo;
  num? get cNAmt => _cNAmt;
  dynamic get cNRemark => _cNRemark;
  num? get dayEnd => _dayEnd;
  List<ItemDetails>? get itemDetails => _itemDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ARBRetId'] = _aRBRetId;
    map['ARBRetIdDtls'] = _aRBRetIdDtls;
    map['RetQty'] = _retQty;
    map['DistributorId'] = _distributorId;
    map['VendorId'] = _vendorId;
    map['VendorName'] = _vendorName;
    map['ReturnDate'] = _returnDate;
    map['RetQtySum'] = _retQtySum;
    map['TotalAmount'] = _totalAmount;
    map['Amount'] = _amount;
    map['Remark'] = _remark;
    map['CNNo'] = _cNNo;
    map['CNAmt'] = _cNAmt;
    map['CNRemark'] = _cNRemark;
    map['DayEnd'] = _dayEnd;
    if (_itemDetails != null) {
      map['ItemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// pkId : 0
/// ItemId : 14
/// ItemName : "DGCC Book"
/// Rate : 100.00
/// RetQty : 2
/// Reason : "defective"
/// Amount : 200.00

class ItemDetails {
  ItemDetails({
      num? pkId, 
      num? itemId, 
      String? itemName, 
      num? rate, 
      num? retQty, 
      String? reason, 
      num? amount,}){
    _pkId = pkId;
    _itemId = itemId;
    _itemName = itemName;
    _rate = rate;
    _retQty = retQty;
    _reason = reason;
    _amount = amount;
}

  ItemDetails.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _rate = json['Rate'];
    _retQty = json['RetQty'];
    _reason = json['Reason'];
    _amount = json['Amount'];
  }
  num? _pkId;
  num? _itemId;
  String? _itemName;
  num? _rate;
  num? _retQty;
  String? _reason;
  num? _amount;
ItemDetails copyWith({  num? pkId,
  num? itemId,
  String? itemName,
  num? rate,
  num? retQty,
  String? reason,
  num? amount,
}) => ItemDetails(  pkId: pkId ?? _pkId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  rate: rate ?? _rate,
  retQty: retQty ?? _retQty,
  reason: reason ?? _reason,
  amount: amount ?? _amount,
);
  num? get pkId => _pkId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rate => _rate;
  num? get retQty => _retQty;
  String? get reason => _reason;
  num? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['Rate'] = _rate;
    map['RetQty'] = _retQty;
    map['Reason'] = _reason;
    map['Amount'] = _amount;
    return map;
  }

}