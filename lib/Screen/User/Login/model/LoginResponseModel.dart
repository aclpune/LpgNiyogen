/// authToken : {"UserInfo":{"DisplayName":"Lpg Gas Dealer","MobileNo":null,"CustomerId":null,"CustomerCode":null,"CustomerName":null,"RefNo":"8118","UserName":"41015336","UserId":4,"RoleId":3,"RoleName":"Manager","ActiveStatus":"Y","LastUpdatedDate":"18-11-2024","CustomerAddress":null,"GSTNO":null,"Email":null,"Source":null,"GodownId":1,"GodownKeeperId":1,"DistributorId":8118},"Token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIiLCJqdGkiOiJmYjY4OTZiMS1kMTA1LTQyMTItOGI4MS01Yzg3M2Y1YTE3ZTkiLCJuYW1laWQiOiIiLCJyb2xlIjoiMCIsIkxvZ2dlZE9uIjoiMTgtMTEtMjAyNCAxNzoyNTo0MiIsIkRpc3BsYXlOYW1lIjoiTHBnIEdhcyBEZWFsZXIiLCJSZWZObyI6IjgxMTgiLCJSb2xlSWQiOiIwIiwibmJmIjoxNzMxOTMwOTQyLCJleHAiOjE3MzIwMzg5NDIsImlhdCI6MTczMTkzMDk0MiwiaXNzIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5IiwiYXVkIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5In0.v0AWeyZxmgrjaDFKglVgL5msGheRa18GMQ58vkyqIUk","expiration":"2024-11-19T17:55:42Z","refresh_token":"3208b297e3bd45b7b491a8c28008ff96","XSRF_token":null,"Status":null,"ExMsg":null}

class LoginResponseModel {
  LoginResponseModel({
      AuthToken? authToken,}){
    _authToken = authToken;
}

  LoginResponseModel.fromJson(dynamic json) {
    _authToken = json['authToken'] != null ? AuthToken.fromJson(json['authToken']) : null;
  }
  AuthToken? _authToken;
LoginResponseModel copyWith({  AuthToken? authToken,
}) => LoginResponseModel(  authToken: authToken ?? _authToken,
);
  AuthToken? get authToken => _authToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_authToken != null) {
      map['authToken'] = _authToken?.toJson();
    }
    return map;
  }

}

/// UserInfo : {"DisplayName":"Lpg Gas Dealer","MobileNo":null,"CustomerId":null,"CustomerCode":null,"CustomerName":null,"RefNo":"8118","UserName":"41015336","UserId":4,"RoleId":3,"RoleName":"Manager","ActiveStatus":"Y","LastUpdatedDate":"18-11-2024","CustomerAddress":null,"GSTNO":null,"Email":null,"Source":null,"GodownId":1,"GodownKeeperId":1,"DistributorId":8118}
/// Token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIiLCJqdGkiOiJmYjY4OTZiMS1kMTA1LTQyMTItOGI4MS01Yzg3M2Y1YTE3ZTkiLCJuYW1laWQiOiIiLCJyb2xlIjoiMCIsIkxvZ2dlZE9uIjoiMTgtMTEtMjAyNCAxNzoyNTo0MiIsIkRpc3BsYXlOYW1lIjoiTHBnIEdhcyBEZWFsZXIiLCJSZWZObyI6IjgxMTgiLCJSb2xlSWQiOiIwIiwibmJmIjoxNzMxOTMwOTQyLCJleHAiOjE3MzIwMzg5NDIsImlhdCI6MTczMTkzMDk0MiwiaXNzIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5IiwiYXVkIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5In0.v0AWeyZxmgrjaDFKglVgL5msGheRa18GMQ58vkyqIUk"
/// expiration : "2024-11-19T17:55:42Z"
/// refresh_token : "3208b297e3bd45b7b491a8c28008ff96"
/// XSRF_token : null
/// Status : null
/// ExMsg : null

class AuthToken {
  AuthToken({
      UserInfo? userInfo, 
      String? token, 
      String? expiration, 
      String? refreshToken, 
      dynamic xSRFToken, 
      dynamic status, 
      dynamic exMsg,}){
    _userInfo = userInfo;
    _token = token;
    _expiration = expiration;
    _refreshToken = refreshToken;
    _xSRFToken = xSRFToken;
    _status = status;
    _exMsg = exMsg;
}

  AuthToken.fromJson(dynamic json) {
    _userInfo = json['UserInfo'] != null ? UserInfo.fromJson(json['UserInfo']) : null;
    _token = json['Token'];
    _expiration = json['expiration'];
    _refreshToken = json['refresh_token'];
    _xSRFToken = json['XSRF_token'];
    _status = json['Status'];
    _exMsg = json['ExMsg'];
  }
  UserInfo? _userInfo;
  String? _token;
  String? _expiration;
  String? _refreshToken;
  dynamic _xSRFToken;
  dynamic _status;
  dynamic _exMsg;
AuthToken copyWith({  UserInfo? userInfo,
  String? token,
  String? expiration,
  String? refreshToken,
  dynamic xSRFToken,
  dynamic status,
  dynamic exMsg,
}) => AuthToken(  userInfo: userInfo ?? _userInfo,
  token: token ?? _token,
  expiration: expiration ?? _expiration,
  refreshToken: refreshToken ?? _refreshToken,
  xSRFToken: xSRFToken ?? _xSRFToken,
  status: status ?? _status,
  exMsg: exMsg ?? _exMsg,
);
  UserInfo? get userInfo => _userInfo;
  String? get token => _token;
  String? get expiration => _expiration;
  String? get refreshToken => _refreshToken;
  dynamic get xSRFToken => _xSRFToken;
  dynamic get status => _status;
  dynamic get exMsg => _exMsg;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_userInfo != null) {
      map['UserInfo'] = _userInfo?.toJson();
    }
    map['Token'] = _token;
    map['expiration'] = _expiration;
    map['refresh_token'] = _refreshToken;
    map['XSRF_token'] = _xSRFToken;
    map['Status'] = _status;
    map['ExMsg'] = _exMsg;
    return map;
  }

}

/// DisplayName : "Lpg Gas Dealer"
/// MobileNo : null
/// CustomerId : null
/// CustomerCode : null
/// CustomerName : null
/// RefNo : "8118"
/// UserName : "41015336"
/// UserId : 4
/// RoleId : 3
/// RoleName : "Manager"
/// ActiveStatus : "Y"
/// LastUpdatedDate : "18-11-2024"
/// CustomerAddress : null
/// GSTNO : null
/// Email : null
/// Source : null
/// GodownId : 1
/// GodownKeeperId : 1
/// DistributorId : 8118

class UserInfo {
  UserInfo({
      String? displayName, 
      dynamic mobileNo, 
      dynamic customerId, 
      dynamic customerCode, 
      dynamic customerName, 
      String? refNo, 
      String? userName, 
      num? userId, 
      num? roleId, 
      String? roleName, 
      String? activeStatus, 
      String? lastUpdatedDate, 
      dynamic customerAddress, 
      dynamic gstno, 
      dynamic email, 
      dynamic source, 
      num? godownId, 
      num? godownKeeperId, 
      num? distributorId,}){
    _displayName = displayName;
    _mobileNo = mobileNo;
    _customerId = customerId;
    _customerCode = customerCode;
    _customerName = customerName;
    _refNo = refNo;
    _userName = userName;
    _userId = userId;
    _roleId = roleId;
    _roleName = roleName;
    _activeStatus = activeStatus;
    _lastUpdatedDate = lastUpdatedDate;
    _customerAddress = customerAddress;
    _gstno = gstno;
    _email = email;
    _source = source;
    _godownId = godownId;
    _godownKeeperId = godownKeeperId;
    _distributorId = distributorId;
}

  UserInfo.fromJson(dynamic json) {
    _displayName = json['DisplayName'];
    _mobileNo = json['MobileNo'];
    _customerId = json['CustomerId'];
    _customerCode = json['CustomerCode'];
    _customerName = json['CustomerName'];
    _refNo = json['RefNo'];
    _userName = json['UserName'];
    _userId = json['UserId'];
    _roleId = json['RoleId'];
    _roleName = json['RoleName'];
    _activeStatus = json['ActiveStatus'];
    _lastUpdatedDate = json['LastUpdatedDate'];
    _customerAddress = json['CustomerAddress'];
    _gstno = json['GSTNO'];
    _email = json['Email'];
    _source = json['Source'];
    _godownId = json['GodownId'];
    _godownKeeperId = json['GodownKeeperId'];
    _distributorId = json['DistributorId'];
  }
  String? _displayName;
  dynamic _mobileNo;
  dynamic _customerId;
  dynamic _customerCode;
  dynamic _customerName;
  String? _refNo;
  String? _userName;
  num? _userId;
  num? _roleId;
  String? _roleName;
  String? _activeStatus;
  String? _lastUpdatedDate;
  dynamic _customerAddress;
  dynamic _gstno;
  dynamic _email;
  dynamic _source;
  num? _godownId;
  num? _godownKeeperId;
  num? _distributorId;
UserInfo copyWith({  String? displayName,
  dynamic mobileNo,
  dynamic customerId,
  dynamic customerCode,
  dynamic customerName,
  String? refNo,
  String? userName,
  num? userId,
  num? roleId,
  String? roleName,
  String? activeStatus,
  String? lastUpdatedDate,
  dynamic customerAddress,
  dynamic gstno,
  dynamic email,
  dynamic source,
  num? godownId,
  num? godownKeeperId,
  num? distributorId,
}) => UserInfo(  displayName: displayName ?? _displayName,
  mobileNo: mobileNo ?? _mobileNo,
  customerId: customerId ?? _customerId,
  customerCode: customerCode ?? _customerCode,
  customerName: customerName ?? _customerName,
  refNo: refNo ?? _refNo,
  userName: userName ?? _userName,
  userId: userId ?? _userId,
  roleId: roleId ?? _roleId,
  roleName: roleName ?? _roleName,
  activeStatus: activeStatus ?? _activeStatus,
  lastUpdatedDate: lastUpdatedDate ?? _lastUpdatedDate,
  customerAddress: customerAddress ?? _customerAddress,
  gstno: gstno ?? _gstno,
  email: email ?? _email,
  source: source ?? _source,
  godownId: godownId ?? _godownId,
  godownKeeperId: godownKeeperId ?? _godownKeeperId,
  distributorId: distributorId ?? _distributorId,
);
  String? get displayName => _displayName;
  dynamic get mobileNo => _mobileNo;
  dynamic get customerId => _customerId;
  dynamic get customerCode => _customerCode;
  dynamic get customerName => _customerName;
  String? get refNo => _refNo;
  String? get userName => _userName;
  num? get userId => _userId;
  num? get roleId => _roleId;
  String? get roleName => _roleName;
  String? get activeStatus => _activeStatus;
  String? get lastUpdatedDate => _lastUpdatedDate;
  dynamic get customerAddress => _customerAddress;
  dynamic get gstno => _gstno;
  dynamic get email => _email;
  dynamic get source => _source;
  num? get godownId => _godownId;
  num? get godownKeeperId => _godownKeeperId;
  num? get distributorId => _distributorId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DisplayName'] = _displayName;
    map['MobileNo'] = _mobileNo;
    map['CustomerId'] = _customerId;
    map['CustomerCode'] = _customerCode;
    map['CustomerName'] = _customerName;
    map['RefNo'] = _refNo;
    map['UserName'] = _userName;
    map['UserId'] = _userId;
    map['RoleId'] = _roleId;
    map['RoleName'] = _roleName;
    map['ActiveStatus'] = _activeStatus;
    map['LastUpdatedDate'] = _lastUpdatedDate;
    map['CustomerAddress'] = _customerAddress;
    map['GSTNO'] = _gstno;
    map['Email'] = _email;
    map['Source'] = _source;
    map['GodownId'] = _godownId;
    map['GodownKeeperId'] = _godownKeeperId;
    map['DistributorId'] = _distributorId;
    return map;
  }

}