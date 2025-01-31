/// DistributorId : 8118
/// VendorId : 1
/// VendorName : "Jambhulkar"
/// ContactNumber : "9881525279"
/// isActive : 0
/// AddedBy : 0
/// Action : null

class GetVendorDetailListModel {
  GetVendorDetailListModel({
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

  GetVendorDetailListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _vendorId = json['VendorId'];
    _vendorName = json['VendorName'];
    _contactNumber = json['ContactNumber'];
    _isActive = json['isActive'];
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
GetVendorDetailListModel copyWith({  num? distributorId,
  num? vendorId,
  String? vendorName,
  String? contactNumber,
  num? isActive,
  num? addedBy,
  dynamic action,
}) => GetVendorDetailListModel(  distributorId: distributorId ?? _distributorId,
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
    map['isActive'] = _isActive;
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    return map;
  }

}