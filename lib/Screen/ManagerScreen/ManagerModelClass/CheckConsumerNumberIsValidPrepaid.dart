/// DistributorId : 8118
/// OrderRefNo : 5250811800071846.0
/// OrderNo : "597338"
/// OrderDate : "2025-05-03T10:10:58"
/// CashDate : null
/// ConsumerNo : "614075"
/// ConsumerName : "Bhatia Arun"
/// PaymentStatus : "Credited"
/// ConsumerRemark : "Punched In cDCMS"
/// PayDate : "2025-05-03T10:16:46"
/// DeliveryDate : "2025-05-05T11:01:12.29"
/// SettDate : "2025-05-03T12:00:00"
/// NiyojanDel : 0
/// cDCMSDel : 1
/// InCorrectStatus : 0
/// UnAccVerified : 0
/// BypassOn : 0
/// Isvalid : 1
/// AddedBy : 0

class CheckConsumerNumberIsValidPrepaid {
  CheckConsumerNumberIsValidPrepaid({
      num? distributorId, 
      num? orderRefNo, 
      String? orderNo, 
      String? orderDate, 
      dynamic cashDate, 
      String? consumerNo, 
      String? consumerName, 
      String? paymentStatus, 
      String? consumerRemark, 
      String? payDate, 
      String? deliveryDate, 
      String? settDate, 
      num? niyojanDel, 
      num? cDCMSDel, 
      num? inCorrectStatus, 
      num? unAccVerified, 
      num? bypassOn, 
      num? isvalid, 
      num? addedBy,}){
    _distributorId = distributorId;
    _orderRefNo = orderRefNo;
    _orderNo = orderNo;
    _orderDate = orderDate;
    _cashDate = cashDate;
    _consumerNo = consumerNo;
    _consumerName = consumerName;
    _paymentStatus = paymentStatus;
    _consumerRemark = consumerRemark;
    _payDate = payDate;
    _deliveryDate = deliveryDate;
    _settDate = settDate;
    _niyojanDel = niyojanDel;
    _cDCMSDel = cDCMSDel;
    _inCorrectStatus = inCorrectStatus;
    _unAccVerified = unAccVerified;
    _bypassOn = bypassOn;
    _isvalid = isvalid;
    _addedBy = addedBy;
}

  CheckConsumerNumberIsValidPrepaid.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _orderRefNo = json['OrderRefNo'];
    _orderNo = json['OrderNo'];
    _orderDate = json['OrderDate'];
    _cashDate = json['CashDate'];
    _consumerNo = json['ConsumerNo'];
    _consumerName = json['ConsumerName'];
    _paymentStatus = json['PaymentStatus'];
    _consumerRemark = json['ConsumerRemark'];
    _payDate = json['PayDate'];
    _deliveryDate = json['DeliveryDate'];
    _settDate = json['SettDate'];
    _niyojanDel = json['NiyojanDel'];
    _cDCMSDel = json['cDCMSDel'];
    _inCorrectStatus = json['InCorrectStatus'];
    _unAccVerified = json['UnAccVerified'];
    _bypassOn = json['BypassOn'];
    _isvalid = json['Isvalid'];
    _addedBy = json['AddedBy'];
  }
  num? _distributorId;
  num? _orderRefNo;
  String? _orderNo;
  String? _orderDate;
  dynamic _cashDate;
  String? _consumerNo;
  String? _consumerName;
  String? _paymentStatus;
  String? _consumerRemark;
  String? _payDate;
  String? _deliveryDate;
  String? _settDate;
  num? _niyojanDel;
  num? _cDCMSDel;
  num? _inCorrectStatus;
  num? _unAccVerified;
  num? _bypassOn;
  num? _isvalid;
  num? _addedBy;
CheckConsumerNumberIsValidPrepaid copyWith({  num? distributorId,
  num? orderRefNo,
  String? orderNo,
  String? orderDate,
  dynamic cashDate,
  String? consumerNo,
  String? consumerName,
  String? paymentStatus,
  String? consumerRemark,
  String? payDate,
  String? deliveryDate,
  String? settDate,
  num? niyojanDel,
  num? cDCMSDel,
  num? inCorrectStatus,
  num? unAccVerified,
  num? bypassOn,
  num? isvalid,
  num? addedBy,
}) => CheckConsumerNumberIsValidPrepaid(  distributorId: distributorId ?? _distributorId,
  orderRefNo: orderRefNo ?? _orderRefNo,
  orderNo: orderNo ?? _orderNo,
  orderDate: orderDate ?? _orderDate,
  cashDate: cashDate ?? _cashDate,
  consumerNo: consumerNo ?? _consumerNo,
  consumerName: consumerName ?? _consumerName,
  paymentStatus: paymentStatus ?? _paymentStatus,
  consumerRemark: consumerRemark ?? _consumerRemark,
  payDate: payDate ?? _payDate,
  deliveryDate: deliveryDate ?? _deliveryDate,
  settDate: settDate ?? _settDate,
  niyojanDel: niyojanDel ?? _niyojanDel,
  cDCMSDel: cDCMSDel ?? _cDCMSDel,
  inCorrectStatus: inCorrectStatus ?? _inCorrectStatus,
  unAccVerified: unAccVerified ?? _unAccVerified,
  bypassOn: bypassOn ?? _bypassOn,
  isvalid: isvalid ?? _isvalid,
  addedBy: addedBy ?? _addedBy,
);
  num? get distributorId => _distributorId;
  num? get orderRefNo => _orderRefNo;
  String? get orderNo => _orderNo;
  String? get orderDate => _orderDate;
  dynamic get cashDate => _cashDate;
  String? get consumerNo => _consumerNo;
  String? get consumerName => _consumerName;
  String? get paymentStatus => _paymentStatus;
  String? get consumerRemark => _consumerRemark;
  String? get payDate => _payDate;
  String? get deliveryDate => _deliveryDate;
  String? get settDate => _settDate;
  num? get niyojanDel => _niyojanDel;
  num? get cDCMSDel => _cDCMSDel;
  num? get inCorrectStatus => _inCorrectStatus;
  num? get unAccVerified => _unAccVerified;
  num? get bypassOn => _bypassOn;
  num? get isvalid => _isvalid;
  num? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['OrderRefNo'] = _orderRefNo;
    map['OrderNo'] = _orderNo;
    map['OrderDate'] = _orderDate;
    map['CashDate'] = _cashDate;
    map['ConsumerNo'] = _consumerNo;
    map['ConsumerName'] = _consumerName;
    map['PaymentStatus'] = _paymentStatus;
    map['ConsumerRemark'] = _consumerRemark;
    map['PayDate'] = _payDate;
    map['DeliveryDate'] = _deliveryDate;
    map['SettDate'] = _settDate;
    map['NiyojanDel'] = _niyojanDel;
    map['cDCMSDel'] = _cDCMSDel;
    map['InCorrectStatus'] = _inCorrectStatus;
    map['UnAccVerified'] = _unAccVerified;
    map['BypassOn'] = _bypassOn;
    map['Isvalid'] = _isvalid;
    map['AddedBy'] = _addedBy;
    return map;
  }

}