/// StaffId : 31
/// StaffNo : "SN/030"
/// DistributorId : 8118
/// StaffInitials : "SJ"
/// StaffName : "Suresh Jadhav"
/// VehicleNo : null
/// StaffAddress : "Baner"
/// ContactPhone1 : "919665709402"
/// JoiningDate : "2024-12-17T00:00:00"
/// Salary : 500000
/// StaffStatus : 1
/// Designation : 2
/// DesignationName : "Delivery Men"
/// AddedBy : 0
/// RefNo : "31"
/// Action : null
/// RoleName : "Manager"
/// StaffEmail : "anilshinde@aadyamconsultant.com"

class DeliveryBoyInfoModel {
  DeliveryBoyInfoModel({
      num? staffId, 
      String? staffNo, 
      num? distributorId, 
      String? staffInitials, 
      String? staffName, 
      dynamic vehicleNo, 
      String? staffAddress, 
      String? contactPhone1, 
      String? joiningDate, 
      num? salary, 
      num? staffStatus, 
      num? designation, 
      String? designationName, 
      num? addedBy, 
      String? refNo, 
      dynamic action, 
      String? roleName, 
      String? staffEmail,}){
    _staffId = staffId;
    _staffNo = staffNo;
    _distributorId = distributorId;
    _staffInitials = staffInitials;
    _staffName = staffName;
    _vehicleNo = vehicleNo;
    _staffAddress = staffAddress;
    _contactPhone1 = contactPhone1;
    _joiningDate = joiningDate;
    _salary = salary;
    _staffStatus = staffStatus;
    _designation = designation;
    _designationName = designationName;
    _addedBy = addedBy;
    _refNo = refNo;
    _action = action;
    _roleName = roleName;
    _staffEmail = staffEmail;
}

  DeliveryBoyInfoModel.fromJson(dynamic json) {
    _staffId = json['StaffId'];
    _staffNo = json['StaffNo'];
    _distributorId = json['DistributorId'];
    _staffInitials = json['StaffInitials'];
    _staffName = json['StaffName'];
    _vehicleNo = json['VehicleNo'];
    _staffAddress = json['StaffAddress'];
    _contactPhone1 = json['ContactPhone1'];
    _joiningDate = json['JoiningDate'];
    _salary = json['Salary'];
    _staffStatus = json['StaffStatus'];
    _designation = json['Designation'];
    _designationName = json['DesignationName'];
    _addedBy = json['AddedBy'];
    _refNo = json['RefNo'];
    _action = json['Action'];
    _roleName = json['RoleName'];
    _staffEmail = json['StaffEmail'];
  }
  num? _staffId;
  String? _staffNo;
  num? _distributorId;
  String? _staffInitials;
  String? _staffName;
  dynamic _vehicleNo;
  String? _staffAddress;
  String? _contactPhone1;
  String? _joiningDate;
  num? _salary;
  num? _staffStatus;
  num? _designation;
  String? _designationName;
  num? _addedBy;
  String? _refNo;
  dynamic _action;
  String? _roleName;
  String? _staffEmail;
DeliveryBoyInfoModel copyWith({  num? staffId,
  String? staffNo,
  num? distributorId,
  String? staffInitials,
  String? staffName,
  dynamic vehicleNo,
  String? staffAddress,
  String? contactPhone1,
  String? joiningDate,
  num? salary,
  num? staffStatus,
  num? designation,
  String? designationName,
  num? addedBy,
  String? refNo,
  dynamic action,
  String? roleName,
  String? staffEmail,
}) => DeliveryBoyInfoModel(  staffId: staffId ?? _staffId,
  staffNo: staffNo ?? _staffNo,
  distributorId: distributorId ?? _distributorId,
  staffInitials: staffInitials ?? _staffInitials,
  staffName: staffName ?? _staffName,
  vehicleNo: vehicleNo ?? _vehicleNo,
  staffAddress: staffAddress ?? _staffAddress,
  contactPhone1: contactPhone1 ?? _contactPhone1,
  joiningDate: joiningDate ?? _joiningDate,
  salary: salary ?? _salary,
  staffStatus: staffStatus ?? _staffStatus,
  designation: designation ?? _designation,
  designationName: designationName ?? _designationName,
  addedBy: addedBy ?? _addedBy,
  refNo: refNo ?? _refNo,
  action: action ?? _action,
  roleName: roleName ?? _roleName,
  staffEmail: staffEmail ?? _staffEmail,
);
  num? get staffId => _staffId;
  String? get staffNo => _staffNo;
  num? get distributorId => _distributorId;
  String? get staffInitials => _staffInitials;
  String? get staffName => _staffName;
  dynamic get vehicleNo => _vehicleNo;
  String? get staffAddress => _staffAddress;
  String? get contactPhone1 => _contactPhone1;
  String? get joiningDate => _joiningDate;
  num? get salary => _salary;
  num? get staffStatus => _staffStatus;
  num? get designation => _designation;
  String? get designationName => _designationName;
  num? get addedBy => _addedBy;
  String? get refNo => _refNo;
  dynamic get action => _action;
  String? get roleName => _roleName;
  String? get staffEmail => _staffEmail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['StaffId'] = _staffId;
    map['StaffNo'] = _staffNo;
    map['DistributorId'] = _distributorId;
    map['StaffInitials'] = _staffInitials;
    map['StaffName'] = _staffName;
    map['VehicleNo'] = _vehicleNo;
    map['StaffAddress'] = _staffAddress;
    map['ContactPhone1'] = _contactPhone1;
    map['JoiningDate'] = _joiningDate;
    map['Salary'] = _salary;
    map['StaffStatus'] = _staffStatus;
    map['Designation'] = _designation;
    map['DesignationName'] = _designationName;
    map['AddedBy'] = _addedBy;
    map['RefNo'] = _refNo;
    map['Action'] = _action;
    map['RoleName'] = _roleName;
    map['StaffEmail'] = _staffEmail;
    return map;
  }

}