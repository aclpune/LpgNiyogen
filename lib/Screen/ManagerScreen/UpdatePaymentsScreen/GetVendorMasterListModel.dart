/// DistributorId : 8118
/// VendorId : 27
/// VendorName : "vendor1"
/// ContactNumber : "9999999999"
/// IsActive : 1
/// AddedBy : 0
/// Action : null

class GetVendorMasterListModel {
  GetVendorMasterListModel({
      num? distributorId, 
      num? vendorId, 
      String? vendorName, 
      String? contactNumber, 
      num? isActive, 
      num? addedBy, 
      dynamic action,}){
    _distributorId = distributorId;
    _vendorId = vendorId;
    _vendorName = vendorName;
    _contactNumber = contactNumber;
    _isActive = isActive;
    _addedBy = addedBy;
    _action = action;
}

  GetVendorMasterListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _vendorId = json['VendorId'];
    _vendorName = json['VendorName'];
    _contactNumber = json['ContactNumber'];
    _isActive = json['IsActive'];
    _addedBy = json['AddedBy'];
    _action = json['Action'];
  }
  num? _distributorId;
  num? _vendorId;
  String? _vendorName;
  String? _contactNumber;
  num? _isActive;
  num? _addedBy;
  dynamic _action;
GetVendorMasterListModel copyWith({  num? distributorId,
  num? vendorId,
  String? vendorName,
  String? contactNumber,
  num? isActive,
  num? addedBy,
  dynamic action,
}) => GetVendorMasterListModel(  distributorId: distributorId ?? _distributorId,
  vendorId: vendorId ?? _vendorId,
  vendorName: vendorName ?? _vendorName,
  contactNumber: contactNumber ?? _contactNumber,
  isActive: isActive ?? _isActive,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
);
  num? get distributorId => _distributorId;
  num? get vendorId => _vendorId;
  String? get vendorName => _vendorName;
  String? get contactNumber => _contactNumber;
  num? get isActive => _isActive;
  num? get addedBy => _addedBy;
  dynamic get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['VendorId'] = _vendorId;
    map['VendorName'] = _vendorName;
    map['ContactNumber'] = _contactNumber;
    map['IsActive'] = _isActive;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    return map;
  }

}