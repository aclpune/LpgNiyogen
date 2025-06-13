/// CustTypeId : 5
/// CustomerType : "Other"
/// IsActive : 1

class GetCustTypeListModel {
  GetCustTypeListModel({
      num? custTypeId, 
      String? customerType, 
      num? isActive,}){
    _custTypeId = custTypeId;
    _customerType = customerType;
    _isActive = isActive;
}

  GetCustTypeListModel.fromJson(dynamic json) {
    _custTypeId = json['CustTypeId'];
    _customerType = json['CustomerType'];
    _isActive = json['IsActive'];
  }
  num? _custTypeId;
  String? _customerType;
  num? _isActive;
GetCustTypeListModel copyWith({  num? custTypeId,
  String? customerType,
  num? isActive,
}) => GetCustTypeListModel(  custTypeId: custTypeId ?? _custTypeId,
  customerType: customerType ?? _customerType,
  isActive: isActive ?? _isActive,
);
  num? get custTypeId => _custTypeId;
  String? get customerType => _customerType;
  num? get isActive => _isActive;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustTypeId'] = _custTypeId;
    map['CustomerType'] = _customerType;
    map['IsActive'] = _isActive;
    return map;
  }

}