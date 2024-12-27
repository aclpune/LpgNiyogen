/// VehicleId : 35
/// DistributorId : 8118
/// StaffId : 24
/// VehicleNo : "MH12GH0001"
/// AddedBy : 0
/// IsActive : 1

class VehicleNumberGetModel {
  VehicleNumberGetModel({
      num? vehicleId, 
      num? distributorId, 
      num? staffId, 
      String? vehicleNo, 
      num? addedBy, 
      num? isActive,}){
    _vehicleId = vehicleId;
    _distributorId = distributorId;
    _staffId = staffId;
    _vehicleNo = vehicleNo;
    _addedBy = addedBy;
    _isActive = isActive;
}

  VehicleNumberGetModel.fromJson(dynamic json) {
    _vehicleId = json['VehicleId'];
    _distributorId = json['DistributorId'];
    _staffId = json['StaffId'];
    _vehicleNo = json['VehicleNo'];
    _addedBy = json['AddedBy'];
    _isActive = json['IsActive'];
  }
  num? _vehicleId;
  num? _distributorId;
  num? _staffId;
  String? _vehicleNo;
  num? _addedBy;
  num? _isActive;
VehicleNumberGetModel copyWith({  num? vehicleId,
  num? distributorId,
  num? staffId,
  String? vehicleNo,
  num? addedBy,
  num? isActive,
}) => VehicleNumberGetModel(  vehicleId: vehicleId ?? _vehicleId,
  distributorId: distributorId ?? _distributorId,
  staffId: staffId ?? _staffId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  addedBy: addedBy ?? _addedBy,
  isActive: isActive ?? _isActive,
);
  num? get vehicleId => _vehicleId;
  num? get distributorId => _distributorId;
  num? get staffId => _staffId;
  String? get vehicleNo => _vehicleNo;
  num? get addedBy => _addedBy;
  num? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['VehicleId'] = _vehicleId;
    map['DistributorId'] = _distributorId;
    map['StaffId'] = _staffId;
    map['VehicleNo'] = _vehicleNo;
    map['AddedBy'] = _addedBy;
    map['IsActive'] = _isActive;
    return map;
  }

}