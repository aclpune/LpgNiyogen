/// CustomerId : 27
/// CustTypeId : 2
/// DistributorId : 8118
/// CustomerType : "ND"
/// CustomerName : "Amit"
/// CustAddress : "Pune"
/// ContactNo : "8765432123"
/// CustomerEmail : "amit@gmail.com"
/// CustomerGSTNo : "123456789"
/// ItemStr : null
/// DiscountStr : null
/// SVQty : 2
/// IsActive : 1
/// IsAlertMessage : 1
/// AlertInterval : "Monthly"
/// AddedBy : 0
/// AddedOn : "0001-01-01T00:00:00"
/// Action : null

class GetConsumerDetailsCredit {
  GetConsumerDetailsCredit({
      num? customerId, 
      num? custTypeId, 
      num? distributorId, 
      String? customerType, 
      String? customerName, 
      String? custAddress, 
      String? contactNo, 
      String? customerEmail, 
      String? customerGSTNo, 
      dynamic itemStr, 
      dynamic discountStr, 
      num? sVQty, 
      num? isActive, 
      num? isAlertMessage, 
      String? alertInterval, 
      num? addedBy, 
      String? addedOn, 
      dynamic action,}){
    _customerId = customerId;
    _custTypeId = custTypeId;
    _distributorId = distributorId;
    _customerType = customerType;
    _customerName = customerName;
    _custAddress = custAddress;
    _contactNo = contactNo;
    _customerEmail = customerEmail;
    _customerGSTNo = customerGSTNo;
    _itemStr = itemStr;
    _discountStr = discountStr;
    _sVQty = sVQty;
    _isActive = isActive;
    _isAlertMessage = isAlertMessage;
    _alertInterval = alertInterval;
    _addedBy = addedBy;
    _addedOn = addedOn;
    _action = action;
}

  GetConsumerDetailsCredit.fromJson(dynamic json) {
    _customerId = json['CustomerId'];
    _custTypeId = json['CustTypeId'];
    _distributorId = json['DistributorId'];
    _customerType = json['CustomerType'];
    _customerName = json['CustomerName'];
    _custAddress = json['CustAddress'];
    _contactNo = json['ContactNo'];
    _customerEmail = json['CustomerEmail'];
    _customerGSTNo = json['CustomerGSTNo'];
    _itemStr = json['ItemStr'];
    _discountStr = json['DiscountStr'];
    _sVQty = json['SVQty'];
    _isActive = json['IsActive'];
    _isAlertMessage = json['IsAlertMessage'];
    _alertInterval = json['AlertInterval'];
    _addedBy = json['AddedBy'];
    _addedOn = json['AddedOn'];
    _action = json['Action'];
  }
  num? _customerId;
  num? _custTypeId;
  num? _distributorId;
  String? _customerType;
  String? _customerName;
  String? _custAddress;
  String? _contactNo;
  String? _customerEmail;
  String? _customerGSTNo;
  dynamic _itemStr;
  dynamic _discountStr;
  num? _sVQty;
  num? _isActive;
  num? _isAlertMessage;
  String? _alertInterval;
  num? _addedBy;
  String? _addedOn;
  dynamic _action;
GetConsumerDetailsCredit copyWith({  num? customerId,
  num? custTypeId,
  num? distributorId,
  String? customerType,
  String? customerName,
  String? custAddress,
  String? contactNo,
  String? customerEmail,
  String? customerGSTNo,
  dynamic itemStr,
  dynamic discountStr,
  num? sVQty,
  num? isActive,
  num? isAlertMessage,
  String? alertInterval,
  num? addedBy,
  String? addedOn,
  dynamic action,
}) => GetConsumerDetailsCredit(  customerId: customerId ?? _customerId,
  custTypeId: custTypeId ?? _custTypeId,
  distributorId: distributorId ?? _distributorId,
  customerType: customerType ?? _customerType,
  customerName: customerName ?? _customerName,
  custAddress: custAddress ?? _custAddress,
  contactNo: contactNo ?? _contactNo,
  customerEmail: customerEmail ?? _customerEmail,
  customerGSTNo: customerGSTNo ?? _customerGSTNo,
  itemStr: itemStr ?? _itemStr,
  discountStr: discountStr ?? _discountStr,
  sVQty: sVQty ?? _sVQty,
  isActive: isActive ?? _isActive,
  isAlertMessage: isAlertMessage ?? _isAlertMessage,
  alertInterval: alertInterval ?? _alertInterval,
  addedBy: addedBy ?? _addedBy,
  addedOn: addedOn ?? _addedOn,
  action: action ?? _action,
);
  num? get customerId => _customerId;
  num? get custTypeId => _custTypeId;
  num? get distributorId => _distributorId;
  String? get customerType => _customerType;
  String? get customerName => _customerName;
  String? get custAddress => _custAddress;
  String? get contactNo => _contactNo;
  String? get customerEmail => _customerEmail;
  String? get customerGSTNo => _customerGSTNo;
  dynamic get itemStr => _itemStr;
  dynamic get discountStr => _discountStr;
  num? get sVQty => _sVQty;
  num? get isActive => _isActive;
  num? get isAlertMessage => _isAlertMessage;
  String? get alertInterval => _alertInterval;
  num? get addedBy => _addedBy;
  String? get addedOn => _addedOn;
  dynamic get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustomerId'] = _customerId;
    map['CustTypeId'] = _custTypeId;
    map['DistributorId'] = _distributorId;
    map['CustomerType'] = _customerType;
    map['CustomerName'] = _customerName;
    map['CustAddress'] = _custAddress;
    map['ContactNo'] = _contactNo;
    map['CustomerEmail'] = _customerEmail;
    map['CustomerGSTNo'] = _customerGSTNo;
    map['ItemStr'] = _itemStr;
    map['DiscountStr'] = _discountStr;
    map['SVQty'] = _sVQty;
    map['IsActive'] = _isActive;
    map['IsAlertMessage'] = _isAlertMessage;
    map['AlertInterval'] = _alertInterval;
    map['AddedBy'] = _addedBy;
    map['AddedOn'] = _addedOn;
    map['Action'] = _action;
    return map;
  }

}