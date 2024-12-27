/// authToken : {"StaffId":29,"DistributorId":8118,"StaffName":"  Ajay Devgan","MobileNo":"919999999999","RoleId":0,"GodownId":1,"GodownKeeperId":11,"OTP":"1516","DistributorCode":"41015336","StaffStatus":1,"Status":"Success","Token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIiLCJqdGkiOiI3MjhmMmNhNC02MzBlLTQ4YjgtOTc1NS1jYzIwYzk1ZDJjNWMiLCJuYW1laWQiOiIiLCJyb2xlIjoiMCIsIkxvZ2dlZE9uIjoiMTYtMTItMjAyNCAxNDoxMjo1NSIsIkRpc3BsYXlOYW1lIjoiICBBamF5IERldmdhbiIsIm5iZiI6MTczNDMzODU3NSwiZXhwIjoxNzM0NDQ2NTc1LCJpYXQiOjE3MzQzMzg1NzUsImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9.mg7KzhvTCN3BV9GTBqRLZIehjNHJrqvnV9iYPwCKjuA","expiration":"2024-12-17T14:42:55Z","refresh_token":"cf77b4355fde4cd3997fb163adfb2102"}

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

/// StaffId : 29
/// DistributorId : 8118
/// StaffName : "  Ajay Devgan"
/// MobileNo : "919999999999"
/// RoleId : 0
/// GodownId : 1
/// GodownKeeperId : 11
/// OTP : "1516"
/// DistributorCode : "41015336"
/// StaffStatus : 1
/// Status : "Success"
/// Token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIiLCJqdGkiOiI3MjhmMmNhNC02MzBlLTQ4YjgtOTc1NS1jYzIwYzk1ZDJjNWMiLCJuYW1laWQiOiIiLCJyb2xlIjoiMCIsIkxvZ2dlZE9uIjoiMTYtMTItMjAyNCAxNDoxMjo1NSIsIkRpc3BsYXlOYW1lIjoiICBBamF5IERldmdhbiIsIm5iZiI6MTczNDMzODU3NSwiZXhwIjoxNzM0NDQ2NTc1LCJpYXQiOjE3MzQzMzg1NzUsImlzcyI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSIsImF1ZCI6Ik15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleU15U3VwZXJLZXlNeVN1cGVyS2V5TXlTdXBlcktleSJ9.mg7KzhvTCN3BV9GTBqRLZIehjNHJrqvnV9iYPwCKjuA"
/// expiration : "2024-12-17T14:42:55Z"
/// refresh_token : "cf77b4355fde4cd3997fb163adfb2102"

class AuthToken {
  AuthToken({
      num?    staffId,
      num?    distributorId,
      String? staffName, 
      String? mobileNo, 
      num?    roleId,
      num?    godownId,
      num?    godownKeeperId,
      String? otp, 
      String? distributorCode, 
      num?    staffStatus,
      String? status, 
      String? token, 
      String? expiration, 
      String? refreshToken,}){
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
    return map;
  }

}