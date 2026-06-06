/// MappingId : 19
/// DistributorId : 8118
/// BankId : 14
/// BankName : "ICICI"
/// AccountNo : "7777005279799"
/// IFSCCode : "ICICI00005"
/// IsActive : 1
/// AddedBy : 4
/// AddedOn : "2025-03-24T12:21:09.75"
/// Action : null



class GetBankMappingDetailsListModel {
  GetBankMappingDetailsListModel({
      num? mappingId, 
      num? distributorId, 
      num? bankId, 
      String? bankName, 
      String? accountNo, 
      String? iFSCCode, 
      num? isActive, 
      num? addedBy, 
      String? addedOn, 
      dynamic action,}){
    _mappingId = mappingId;
    _distributorId = distributorId;
    _bankId = bankId;
    _bankName = bankName;
    _accountNo = accountNo;
    _iFSCCode = iFSCCode;
    _isActive = isActive;
    _addedBy = addedBy;
    _addedOn = addedOn;
    _action = action;
}

  GetBankMappingDetailsListModel.fromJson(dynamic json) {
    _mappingId = json['MappingId'];
    _distributorId = json['DistributorId'];
    _bankId = json['BankId'];
    _bankName = json['BankName'];
    _accountNo = json['AccountNo'];
    _iFSCCode = json['IFSCCode'];
    _isActive = json['IsActive'];
    _addedBy = json['AddedBy'];
    _addedOn = json['AddedOn'];
    _action = json['Action'];
  }
  num? _mappingId;
  num? _distributorId;
  num? _bankId;
  String? _bankName;
  String? _accountNo;
  String? _iFSCCode;
  num? _isActive;
  num? _addedBy;
  String? _addedOn;
  dynamic _action;
GetBankMappingDetailsListModel copyWith({  num? mappingId,
  num? distributorId,
  num? bankId,
  String? bankName,
  String? accountNo,
  String? iFSCCode,
  num? isActive,
  num? addedBy,
  String? addedOn,
  dynamic action,
}) => GetBankMappingDetailsListModel(  mappingId: mappingId ?? _mappingId,
  distributorId: distributorId ?? _distributorId,
  bankId: bankId ?? _bankId,
  bankName: bankName ?? _bankName,
  accountNo: accountNo ?? _accountNo,
  iFSCCode: iFSCCode ?? _iFSCCode,
  isActive: isActive ?? _isActive,
  addedBy: addedBy ?? _addedBy,
  addedOn: addedOn ?? _addedOn,
  action: action ?? _action,
);
  num? get mappingId => _mappingId;
  num? get distributorId => _distributorId;
  num? get bankId => _bankId;
  String? get bankName => _bankName;
  String? get accountNo => _accountNo;
  String? get iFSCCode => _iFSCCode;
  num? get isActive => _isActive;
  num? get addedBy => _addedBy;
  String? get addedOn => _addedOn;
  dynamic get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['MappingId'] = _mappingId;
    map['DistributorId'] = _distributorId;
    map['BankId'] = _bankId;
    map['BankName'] = _bankName;
    map['AccountNo'] = _accountNo;
    map['IFSCCode'] = _iFSCCode;
    map['IsActive'] = _isActive;
    map['AddedBy'] = _addedBy;
    map['AddedOn'] = _addedOn;
    map['Action'] = _action;
    return map;
  }

}