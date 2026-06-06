/// DistributorId : 0
/// UserId : 69
/// StaffId : 214
/// StaffNo : "SN/035"
/// StaffName : "Snehal"
/// OwnerAddress : null
/// ContactPhone : null
/// Ownerstatus : 1

class GetStaffDetailsListUserIsMadeModel {
  GetStaffDetailsListUserIsMadeModel({
      num? distributorId, 
      num? userId, 
      num? staffId, 
      String? staffNo, 
      String? staffName, 
      dynamic ownerAddress, 
      dynamic contactPhone, 
      num? ownerstatus,}){
    _distributorId = distributorId;
    _userId = userId;
    _staffId = staffId;
    _staffNo = staffNo;
    _staffName = staffName;
    _ownerAddress = ownerAddress;
    _contactPhone = contactPhone;
    _ownerstatus = ownerstatus;
}

  GetStaffDetailsListUserIsMadeModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _userId = json['UserId'];
    _staffId = json['StaffId'];
    _staffNo = json['StaffNo'];
    _staffName = json['StaffName'];
    _ownerAddress = json['OwnerAddress'];
    _contactPhone = json['ContactPhone'];
    _ownerstatus = json['Ownerstatus'];
  }
  num? _distributorId;
  num? _userId;
  num? _staffId;
  String? _staffNo;
  String? _staffName;
  dynamic _ownerAddress;
  dynamic _contactPhone;
  num? _ownerstatus;
GetStaffDetailsListUserIsMadeModel copyWith({  num? distributorId,
  num? userId,
  num? staffId,
  String? staffNo,
  String? staffName,
  dynamic ownerAddress,
  dynamic contactPhone,
  num? ownerstatus,
}) => GetStaffDetailsListUserIsMadeModel(  distributorId: distributorId ?? _distributorId,
  userId: userId ?? _userId,
  staffId: staffId ?? _staffId,
  staffNo: staffNo ?? _staffNo,
  staffName: staffName ?? _staffName,
  ownerAddress: ownerAddress ?? _ownerAddress,
  contactPhone: contactPhone ?? _contactPhone,
  ownerstatus: ownerstatus ?? _ownerstatus,
);
  num? get distributorId => _distributorId;
  num? get userId => _userId;
  num? get staffId => _staffId;
  String? get staffNo => _staffNo;
  String? get staffName => _staffName;
  dynamic get ownerAddress => _ownerAddress;
  dynamic get contactPhone => _contactPhone;
  num? get ownerstatus => _ownerstatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['UserId'] = _userId;
    map['StaffId'] = _staffId;
    map['StaffNo'] = _staffNo;
    map['StaffName'] = _staffName;
    map['OwnerAddress'] = _ownerAddress;
    map['ContactPhone'] = _contactPhone;
    map['Ownerstatus'] = _ownerstatus;
    return map;
  }

}