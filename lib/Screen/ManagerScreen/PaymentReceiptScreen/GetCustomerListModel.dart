/// CustomerId : 193
/// CustTypeId : 1
/// DistributorId : 8118
/// CustomerType : "Exempted"
/// CustomerName : "consumer1"
/// CustAddress : ""
/// ContactNo : "9874563212"
/// CustomerEmail : "vrush@gmail.com"
/// CustomerGSTNo : ""
/// SVQty : 0
/// IsActive : 1
/// IsAlertMessage : 0
/// AlertInterval : ""
/// AddedBy : 0
/// AddedOn : "0001-01-01T00:00:00"
/// Action : null
/// CreditAmt : 0.0
/// DebitAmt : 0.0
/// OnbordingFlag : 0
/// PkId : 0
/// Type : null
/// TypeId : 0
/// OpBalDate : "0001-01-01T00:00:00"

class GetCustomerListModel {
  GetCustomerListModel({
      num? customerId, 
      num? custTypeId, 
      num? distributorId, 
      String? customerType, 
      String? customerName, 
      String? custAddress, 
      String? contactNo, 
      String? customerEmail, 
      String? customerGSTNo, 
      num? sVQty, 
      num? isActive, 
      num? isAlertMessage, 
      String? alertInterval, 
      num? addedBy, 
      String? addedOn, 
      dynamic action, 
      num? creditAmt, 
      num? debitAmt, 
      num? onbordingFlag, 
      num? pkId, 
      dynamic type, 
      num? typeId, 
      String? opBalDate,}){
    _customerId = customerId;
    _custTypeId = custTypeId;
    _distributorId = distributorId;
    _customerType = customerType;
    _customerName = customerName;
    _custAddress = custAddress;
    _contactNo = contactNo;
    _customerEmail = customerEmail;
    _customerGSTNo = customerGSTNo;
    _sVQty = sVQty;
    _isActive = isActive;
    _isAlertMessage = isAlertMessage;
    _alertInterval = alertInterval;
    _addedBy = addedBy;
    _addedOn = addedOn;
    _action = action;
    _creditAmt = creditAmt;
    _debitAmt = debitAmt;
    _onbordingFlag = onbordingFlag;
    _pkId = pkId;
    _type = type;
    _typeId = typeId;
    _opBalDate = opBalDate;
}

  GetCustomerListModel.fromJson(dynamic json) {
    _customerId = json['CustomerId'];
    _custTypeId = json['CustTypeId'];
    _distributorId = json['DistributorId'];
    _customerType = json['CustomerType'];
    _customerName = json['CustomerName'];
    _custAddress = json['CustAddress'];
    _contactNo = json['ContactNo'];
    _customerEmail = json['CustomerEmail'];
    _customerGSTNo = json['CustomerGSTNo'];
    _sVQty = json['SVQty'];
    _isActive = json['IsActive'];
    _isAlertMessage = json['IsAlertMessage'];
    _alertInterval = json['AlertInterval'];
    _addedBy = json['AddedBy'];
    _addedOn = json['AddedOn'];
    _action = json['Action'];
    _creditAmt = json['CreditAmt'];
    _debitAmt = json['DebitAmt'];
    _onbordingFlag = json['OnbordingFlag'];
    _pkId = json['PkId'];
    _type = json['Type'];
    _typeId = json['TypeId'];
    _opBalDate = json['OpBalDate'];
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
  num? _sVQty;
  num? _isActive;
  num? _isAlertMessage;
  String? _alertInterval;
  num? _addedBy;
  String? _addedOn;
  dynamic _action;
  num? _creditAmt;
  num? _debitAmt;
  num? _onbordingFlag;
  num? _pkId;
  dynamic _type;
  num? _typeId;
  String? _opBalDate;
GetCustomerListModel copyWith({  num? customerId,
  num? custTypeId,
  num? distributorId,
  String? customerType,
  String? customerName,
  String? custAddress,
  String? contactNo,
  String? customerEmail,
  String? customerGSTNo,
  num? sVQty,
  num? isActive,
  num? isAlertMessage,
  String? alertInterval,
  num? addedBy,
  String? addedOn,
  dynamic action,
  num? creditAmt,
  num? debitAmt,
  num? onbordingFlag,
  num? pkId,
  dynamic type,
  num? typeId,
  String? opBalDate,
}) => GetCustomerListModel(  customerId: customerId ?? _customerId,
  custTypeId: custTypeId ?? _custTypeId,
  distributorId: distributorId ?? _distributorId,
  customerType: customerType ?? _customerType,
  customerName: customerName ?? _customerName,
  custAddress: custAddress ?? _custAddress,
  contactNo: contactNo ?? _contactNo,
  customerEmail: customerEmail ?? _customerEmail,
  customerGSTNo: customerGSTNo ?? _customerGSTNo,
  sVQty: sVQty ?? _sVQty,
  isActive: isActive ?? _isActive,
  isAlertMessage: isAlertMessage ?? _isAlertMessage,
  alertInterval: alertInterval ?? _alertInterval,
  addedBy: addedBy ?? _addedBy,
  addedOn: addedOn ?? _addedOn,
  action: action ?? _action,
  creditAmt: creditAmt ?? _creditAmt,
  debitAmt: debitAmt ?? _debitAmt,
  onbordingFlag: onbordingFlag ?? _onbordingFlag,
  pkId: pkId ?? _pkId,
  type: type ?? _type,
  typeId: typeId ?? _typeId,
  opBalDate: opBalDate ?? _opBalDate,
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
  num? get sVQty => _sVQty;
  num? get isActive => _isActive;
  num? get isAlertMessage => _isAlertMessage;
  String? get alertInterval => _alertInterval;
  num? get addedBy => _addedBy;
  String? get addedOn => _addedOn;
  dynamic get action => _action;
  num? get creditAmt => _creditAmt;
  num? get debitAmt => _debitAmt;
  num? get onbordingFlag => _onbordingFlag;
  num? get pkId => _pkId;
  dynamic get type => _type;
  num? get typeId => _typeId;
  String? get opBalDate => _opBalDate;

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
    map['SVQty'] = _sVQty;
    map['IsActive'] = _isActive;
    map['IsAlertMessage'] = _isAlertMessage;
    map['AlertInterval'] = _alertInterval;
    map['AddedBy'] = _addedBy;
    map['AddedOn'] = _addedOn;
    map['Action'] = _action;
    map['CreditAmt'] = _creditAmt;
    map['DebitAmt'] = _debitAmt;
    map['OnbordingFlag'] = _onbordingFlag;
    map['PkId'] = _pkId;
    map['Type'] = _type;
    map['TypeId'] = _typeId;
    map['OpBalDate'] = _opBalDate;
    return map;
  }

}