/// VehicleId : 35
/// DistributorId : 8118
/// StaffId : 24
/// VehicleNo : "MH12GH0001"
/// AddedBy : 0
/// IsActive : 1

class VehicleNumberGetModel {
  VehicleNumberGetModel({
      dynamic vehicleId, 
      dynamic distributorId, 
      dynamic staffId, 
      String? vehicleNo, 
      dynamic addedBy, 
      dynamic isActive,}){
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
  dynamic _vehicleId;
  dynamic _distributorId;
  dynamic _staffId;
  String? _vehicleNo;
  dynamic _addedBy;
  dynamic _isActive;
 VehicleNumberGetModel copyWith({  dynamic vehicleId,
   dynamic distributorId,
   dynamic staffId,
  String? vehicleNo,
   dynamic addedBy,
   dynamic isActive,
}) => VehicleNumberGetModel(  vehicleId: vehicleId ?? _vehicleId,
  distributorId: distributorId ?? _distributorId,
  staffId: staffId ?? _staffId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  addedBy: addedBy ?? _addedBy,
  isActive: isActive ?? _isActive,
);
  dynamic get vehicleId => _vehicleId;
  dynamic get distributorId => _distributorId;
  dynamic get staffId => _staffId;
  String? get vehicleNo => _vehicleNo;
  dynamic get addedBy => _addedBy;
  dynamic get isActive => _isActive;

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