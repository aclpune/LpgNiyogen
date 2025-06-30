/// StaffId : 308
/// StaffNo : "SN/041"
/// DistributorId : 8118
/// StaffName : "Staff1"
/// VehicleNo : null
/// StaffAddress : ""
/// ContactPhone1 : "9756446665"
/// StaffType : 0
/// Salary : 0.00
/// DelRate : 0.00
/// StaffStatus : 1
/// Designation : 2
/// DesignationName : "Delivery Men"
/// AddedBy : 0
/// RefNo : "0"
/// Action : null
/// RoleName : ""
/// StaffEmail : null
/// StaffTypeText : "Salaried"
/// OTP : null
/// IsOnBording : 0
/// DebitAmt : 0.0
/// CreditAmt : 0.0

class GetStaffDetailsListModel {
  GetStaffDetailsListModel({
      num? staffId, 
      String? staffNo, 
      num? distributorId, 
      String? staffName, 
      dynamic vehicleNo, 
      String? staffAddress, 
      String? contactPhone1, 
      num? staffType, 
      num? salary, 
      num? delRate, 
      num? staffStatus, 
      num? designation, 
      String? designationName, 
      num? addedBy, 
      String? refNo, 
      dynamic action, 
      String? roleName, 
      dynamic staffEmail, 
      String? staffTypeText, 
      dynamic otp, 
      num? isOnBording, 
      num? debitAmt, 
      num? creditAmt,}){
    _staffId = staffId;
    _staffNo = staffNo;
    _distributorId = distributorId;
    _staffName = staffName;
    _vehicleNo = vehicleNo;
    _staffAddress = staffAddress;
    _contactPhone1 = contactPhone1;
    _staffType = staffType;
    _salary = salary;
    _delRate = delRate;
    _staffStatus = staffStatus;
    _designation = designation;
    _designationName = designationName;
    _addedBy = addedBy;
    _refNo = refNo;
    _action = action;
    _roleName = roleName;
    _staffEmail = staffEmail;
    _staffTypeText = staffTypeText;
    _otp = otp;
    _isOnBording = isOnBording;
    _debitAmt = debitAmt;
    _creditAmt = creditAmt;
}

  GetStaffDetailsListModel.fromJson(dynamic json) {
    _staffId = json['StaffId'];
    _staffNo = json['StaffNo'];
    _distributorId = json['DistributorId'];
    _staffName = json['StaffName'];
    _vehicleNo = json['VehicleNo'];
    _staffAddress = json['StaffAddress'];
    _contactPhone1 = json['ContactPhone1'];
    _staffType = json['StaffType'];
    _salary = json['Salary'];
    _delRate = json['DelRate'];
    _staffStatus = json['StaffStatus'];
    _designation = json['Designation'];
    _designationName = json['DesignationName'];
    _addedBy = json['AddedBy'];
    _refNo = json['RefNo'];
    _action = json['Action'];
    _roleName = json['RoleName'];
    _staffEmail = json['StaffEmail'];
    _staffTypeText = json['StaffTypeText'];
    _otp = json['OTP'];
    _isOnBording = json['IsOnBording'];
    _debitAmt = json['DebitAmt'];
    _creditAmt = json['CreditAmt'];
  }
  num? _staffId;
  String? _staffNo;
  num? _distributorId;
  String? _staffName;
  dynamic _vehicleNo;
  String? _staffAddress;
  String? _contactPhone1;
  num? _staffType;
  num? _salary;
  num? _delRate;
  num? _staffStatus;
  num? _designation;
  String? _designationName;
  num? _addedBy;
  String? _refNo;
  dynamic _action;
  String? _roleName;
  dynamic _staffEmail;
  String? _staffTypeText;
  dynamic _otp;
  num? _isOnBording;
  num? _debitAmt;
  num? _creditAmt;
GetStaffDetailsListModel copyWith({  num? staffId,
  String? staffNo,
  num? distributorId,
  String? staffName,
  dynamic vehicleNo,
  String? staffAddress,
  String? contactPhone1,
  num? staffType,
  num? salary,
  num? delRate,
  num? staffStatus,
  num? designation,
  String? designationName,
  num? addedBy,
  String? refNo,
  dynamic action,
  String? roleName,
  dynamic staffEmail,
  String? staffTypeText,
  dynamic otp,
  num? isOnBording,
  num? debitAmt,
  num? creditAmt,
}) => GetStaffDetailsListModel(  staffId: staffId ?? _staffId,
  staffNo: staffNo ?? _staffNo,
  distributorId: distributorId ?? _distributorId,
  staffName: staffName ?? _staffName,
  vehicleNo: vehicleNo ?? _vehicleNo,
  staffAddress: staffAddress ?? _staffAddress,
  contactPhone1: contactPhone1 ?? _contactPhone1,
  staffType: staffType ?? _staffType,
  salary: salary ?? _salary,
  delRate: delRate ?? _delRate,
  staffStatus: staffStatus ?? _staffStatus,
  designation: designation ?? _designation,
  designationName: designationName ?? _designationName,
  addedBy: addedBy ?? _addedBy,
  refNo: refNo ?? _refNo,
  action: action ?? _action,
  roleName: roleName ?? _roleName,
  staffEmail: staffEmail ?? _staffEmail,
  staffTypeText: staffTypeText ?? _staffTypeText,
  otp: otp ?? _otp,
  isOnBording: isOnBording ?? _isOnBording,
  debitAmt: debitAmt ?? _debitAmt,
  creditAmt: creditAmt ?? _creditAmt,
);
  num? get staffId => _staffId;
  String? get staffNo => _staffNo;
  num? get distributorId => _distributorId;
  String? get staffName => _staffName;
  dynamic get vehicleNo => _vehicleNo;
  String? get staffAddress => _staffAddress;
  String? get contactPhone1 => _contactPhone1;
  num? get staffType => _staffType;
  num? get salary => _salary;
  num? get delRate => _delRate;
  num? get staffStatus => _staffStatus;
  num? get designation => _designation;
  String? get designationName => _designationName;
  num? get addedBy => _addedBy;
  String? get refNo => _refNo;
  dynamic get action => _action;
  String? get roleName => _roleName;
  dynamic get staffEmail => _staffEmail;
  String? get staffTypeText => _staffTypeText;
  dynamic get otp => _otp;
  num? get isOnBording => _isOnBording;
  num? get debitAmt => _debitAmt;
  num? get creditAmt => _creditAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StaffId'] = _staffId;
    map['StaffNo'] = _staffNo;
    map['DistributorId'] = _distributorId;
    map['StaffName'] = _staffName;
    map['VehicleNo'] = _vehicleNo;
    map['StaffAddress'] = _staffAddress;
    map['ContactPhone1'] = _contactPhone1;
    map['StaffType'] = _staffType;
    map['Salary'] = _salary;
    map['DelRate'] = _delRate;
    map['StaffStatus'] = _staffStatus;
    map['Designation'] = _designation;
    map['DesignationName'] = _designationName;
    map['AddedBy'] = _addedBy;
    map['RefNo'] = _refNo;
    map['Action'] = _action;
    map['RoleName'] = _roleName;
    map['StaffEmail'] = _staffEmail;
    map['StaffTypeText'] = _staffTypeText;
    map['OTP'] = _otp;
    map['IsOnBording'] = _isOnBording;
    map['DebitAmt'] = _debitAmt;
    map['CreditAmt'] = _creditAmt;
    return map;
  }

}