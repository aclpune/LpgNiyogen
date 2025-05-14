/// authToken : {"StaffId":19,"DistributorId":8118,"StaffName":"Christina Alotkar","MobileNo":"8983099288","RoleId":3,"GodownId":0,"GodownKeeperId":0,"OTP":"1458","DistributorCode":"41015336","StaffStatus":1,"Status":"Success","Token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJDaHJpc3RpbmEgQWxvdGthciIsImp0aSI6ImFkY2NjNjkwLTNlMmYtNDhlMS04ODA4LWI3YmU2MmQxNzliMCIsIm5hbWVpZCI6IkNocmlzdGluYSBBbG90a2FyIiwicm9sZSI6IjAiLCJMb2dnZWRPbiI6IjUvNy8yMDI1IDQ6MzI6NTQgUE0iLCJEaXNwbGF5TmFtZSI6IkNocmlzdGluYSBBbG90a2FyIiwibmJmIjoxNzQ2NjE1Nzc0LCJleHAiOjE3NDY3MjM3NzQsImlhdCI6MTc0NjYxNTc3NCwiaXNzIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5IiwiYXVkIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5In0.PL2R87FEE6qzcU-sPVtcoSuPbkOe5jEPogj7qsTsi8Y","expiration":"2025-05-08T17:02:54Z","refresh_token":"07f40198a2bb4db89b28599999b53e17","RoleName":"Manager","DistributorName":"SHREE RENUKA GAS SUPPLY COMPANY","UserId":42}

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

/// StaffId : 19
/// DistributorId : 8118
/// StaffName : "Christina Alotkar"
/// MobileNo : "8983099288"
/// RoleId : 3
/// GodownId : 0
/// GodownKeeperId : 0
/// OTP : "1458"
/// DistributorCode : "41015336"
/// StaffStatus : 1
/// Status : "Success"
/// Token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJDaHJpc3RpbmEgQWxvdGthciIsImp0aSI6ImFkY2NjNjkwLTNlMmYtNDhlMS04ODA4LWI3YmU2MmQxNzliMCIsIm5hbWVpZCI6IkNocmlzdGluYSBBbG90a2FyIiwicm9sZSI6IjAiLCJMb2dnZWRPbiI6IjUvNy8yMDI1IDQ6MzI6NTQgUE0iLCJEaXNwbGF5TmFtZSI6IkNocmlzdGluYSBBbG90a2FyIiwibmJmIjoxNzQ2NjE1Nzc0LCJleHAiOjE3NDY3MjM3NzQsImlhdCI6MTc0NjYxNTc3NCwiaXNzIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5IiwiYXVkIjoiTXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5In0.PL2R87FEE6qzcU-sPVtcoSuPbkOe5jEPogj7qsTsi8Y"
/// expiration : "2025-05-08T17:02:54Z"
/// refresh_token : "07f40198a2bb4db89b28599999b53e17"
/// RoleName : "Manager"
/// DistributorName : "SHREE RENUKA GAS SUPPLY COMPANY"
/// UserId : 42

class AuthToken {
  AuthToken({
      num? staffId, 
      num? distributorId, 
      String? staffName, 
      String? mobileNo, 
      num? roleId, 
      num? godownId, 
      num? godownKeeperId, 
      String? otp, 
      String? distributorCode, 
      num? staffStatus, 
      String? status, 
      String? token, 
      String? expiration, 
      String? refreshToken, 
      String? roleName, 
      String? distributorName, 
      num?  userId,
      String? MgrEmail,
      String? OwnerEmail,
      num? IsAlreadyLogin
  }){
    _staffId = staffId;
    _distributorId = distributorId;
    _staffName = staffName;
    _mobileNo = mobileNo;
    _roleId = roleId;
    _godownId = godownId;
    _godownKeeperId = godownKeeperId;
    _otp = otp;
    _distributorCode = distributorCode;
    _staffStatus = staffStatus;
    _status = status;
    _token = token;
    _expiration = expiration;
    _refreshToken = refreshToken;
    _roleName = roleName;
    _distributorName = distributorName;
    _userId = userId;
    _MgrEmail = MgrEmail;
    _OwnerEmail = OwnerEmail;
    _IsAlreadyLogin = IsAlreadyLogin;
}

  AuthToken.fromJson(dynamic json) {
    _staffId = json['StaffId'];
    _distributorId = json['DistributorId'];
    _staffName = json['StaffName'];
    _mobileNo = json['MobileNo'];
    _roleId = json['RoleId'];
    _godownId = json['GodownId'];
    _godownKeeperId = json['GodownKeeperId'];
    _otp = json['OTP'];
    _distributorCode = json['DistributorCode'];
    _staffStatus = json['StaffStatus'];
    _status = json['Status'];
    _token = json['Token'];
    _expiration = json['expiration'];
    _refreshToken = json['refresh_token'];
    _roleName = json['RoleName'];
    _distributorName = json['DistributorName'];
    _userId = json['UserId'];
    _MgrEmail = json['MgrEmail'];
    _OwnerEmail = json['OwnerEmail'];
    _IsAlreadyLogin = json['IsAlreadyLogin'];
  }
  num? _staffId;
  num? _distributorId;
  String? _staffName;
  String? _mobileNo;
  num? _roleId;
  num? _godownId;
  num? _godownKeeperId;
  String? _otp;
  String? _distributorCode;
  num? _staffStatus;
  String? _status;
  String? _token;
  String? _expiration;
  String? _refreshToken;
  String? _roleName;
  String? _distributorName;
  num? _userId;
  String? _MgrEmail;
  String? _OwnerEmail;
  num? _IsAlreadyLogin;
AuthToken copyWith({  num? staffId,
  num? distributorId,
  String? staffName,
  String? mobileNo,
  num? roleId,
  num? godownId,
  num? godownKeeperId,
  String? otp,
  String? distributorCode,
  num? staffStatus,
  String? status,
  String? token,
  String? expiration,
  String? refreshToken,
  String? roleName,
  String? distributorName,
  num? userId,
  String? MgrEmail,
  String? OwnerEmail,
  num? IsAlreadyLogin,
}) => AuthToken(  staffId: staffId ?? _staffId,
  distributorId: distributorId ?? _distributorId,
  staffName: staffName ?? _staffName,
  mobileNo: mobileNo ?? _mobileNo,
  roleId: roleId ?? _roleId,
  godownId: godownId ?? _godownId,
  godownKeeperId: godownKeeperId ?? _godownKeeperId,
  otp: otp ?? _otp,
  distributorCode: distributorCode ?? _distributorCode,
  staffStatus: staffStatus ?? _staffStatus,
  status: status ?? _status,
  token: token ?? _token,
  expiration: expiration ?? _expiration,
  refreshToken: refreshToken ?? _refreshToken,
  roleName: roleName ?? _roleName,
  distributorName: distributorName ?? _distributorName,
  userId: userId ?? _userId,
  MgrEmail: MgrEmail ?? _MgrEmail,
  OwnerEmail: OwnerEmail ?? _OwnerEmail,
  IsAlreadyLogin: IsAlreadyLogin ?? _IsAlreadyLogin,
);
  num? get staffId => _staffId;
  num? get distributorId => _distributorId;
  String? get staffName => _staffName;
  String? get mobileNo => _mobileNo;
  num? get roleId => _roleId;
  num? get godownId => _godownId;
  num? get godownKeeperId => _godownKeeperId;
  String? get otp => _otp;
  String? get distributorCode => _distributorCode;
  num? get staffStatus => _staffStatus;
  String? get status => _status;
  String? get token => _token;
  String? get expiration => _expiration;
  String? get refreshToken => _refreshToken;
  String? get roleName => _roleName;
  String? get distributorName => _distributorName;
  num? get userId => _userId;
  String? get MgrEmail => _MgrEmail;
  String? get OwnerEmail => _OwnerEmail;
  num? get IsAlreadyLogin => _IsAlreadyLogin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StaffId'] = _staffId;
    map['DistributorId'] = _distributorId;
    map['StaffName'] = _staffName;
    map['MobileNo'] = _mobileNo;
    map['RoleId'] = _roleId;
    map['GodownId'] = _godownId;
    map['GodownKeeperId'] = _godownKeeperId;
    map['OTP'] = _otp;
    map['DistributorCode'] = _distributorCode;
    map['StaffStatus'] = _staffStatus;
    map['Status'] = _status;
    map['Token'] = _token;
    map['expiration'] = _expiration;
    map['refresh_token'] = _refreshToken;
    map['RoleName'] = _roleName;
    map['DistributorName'] = _distributorName;
    map['UserId'] = _userId;
    map['MgrEmail'] = _MgrEmail;
    map['OwnerEmail'] = _OwnerEmail;
    map['IsAlreadyLogin'] = _IsAlreadyLogin;
    return map;
  }

}