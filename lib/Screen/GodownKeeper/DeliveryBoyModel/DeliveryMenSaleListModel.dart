/// DMId : 7
/// StaffNo : "SN/007"
/// DistributorId : 8118
/// StaffName : "Ashok Chavan"
/// VehicleId : 0
/// VehicleNo : null
/// StaffStatus : 1
/// FilledSaleQty : 150

class DeliveryMenSaleListModel {
  DeliveryMenSaleListModel({
      num? dMId, 
      String? staffNo, 
      num? distributorId, 
      String? staffName, 
      num? vehicleId, 
      dynamic vehicleNo, 
      num? staffStatus, 
      num? filledSaleQty,}){
    _dMId = dMId;
    _staffNo = staffNo;
    _distributorId = distributorId;
    _staffName = staffName;
    _vehicleId = vehicleId;
    _vehicleNo = vehicleNo;
    _staffStatus = staffStatus;
    _filledSaleQty = filledSaleQty;
}

  DeliveryMenSaleListModel.fromJson(dynamic json) {
    _dMId = json['DMId'];
    _staffNo = json['StaffNo'];
    _distributorId = json['DistributorId'];
    _staffName = json['StaffName'];
    _vehicleId = json['VehicleId'];
    _vehicleNo = json['VehicleNo'];
    _staffStatus = json['StaffStatus'];
    _filledSaleQty = json['FilledSaleQty'];
  }
  num? _dMId;
  String? _staffNo;
  num? _distributorId;
  String? _staffName;
  num? _vehicleId;
  dynamic _vehicleNo;
  num? _staffStatus;
  num? _filledSaleQty;
DeliveryMenSaleListModel copyWith({  num? dMId,
  String? staffNo,
  num? distributorId,
  String? staffName,
  num? vehicleId,
  dynamic vehicleNo,
  num? staffStatus,
  num? filledSaleQty,
}) => DeliveryMenSaleListModel(  dMId: dMId ?? _dMId,
  staffNo: staffNo ?? _staffNo,
  distributorId: distributorId ?? _distributorId,
  staffName: staffName ?? _staffName,
  vehicleId: vehicleId ?? _vehicleId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  staffStatus: staffStatus ?? _staffStatus,
  filledSaleQty: filledSaleQty ?? _filledSaleQty,
);
  num? get dMId => _dMId;
  String? get staffNo => _staffNo;
  num? get distributorId => _distributorId;
  String? get staffName => _staffName;
  num? get vehicleId => _vehicleId;
  dynamic get vehicleNo => _vehicleNo;
  num? get staffStatus => _staffStatus;
  num? get filledSaleQty => _filledSaleQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DMId'] = _dMId;
    map['StaffNo'] = _staffNo;
    map['DistributorId'] = _distributorId;
    map['StaffName'] = _staffName;
    map['VehicleId'] = _vehicleId;
    map['VehicleNo'] = _vehicleNo;
    map['StaffStatus'] = _staffStatus;
    map['FilledSaleQty'] = _filledSaleQty;
    return map;
  }

}