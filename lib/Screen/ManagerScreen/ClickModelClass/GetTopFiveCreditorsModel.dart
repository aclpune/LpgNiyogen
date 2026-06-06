/// DistributorId : 8118
/// CustomerId : 4
/// CustomerName : null
/// CollRcptDate : "0001-01-01T00:00:00"
/// TotalCredit : 3281490.00
/// TotalReceipt : 281410.00
/// TotalOutstanding : 3000080.00
/// PendingSinceDays : 0.0
/// CustTypeId : 0
/// CustomerType : null

class GetTopFiveCreditorsModel {
  GetTopFiveCreditorsModel({
      num? distributorId, 
      num? customerId, 
      dynamic customerName, 
      String? collRcptDate, 
      num? totalCredit, 
      num? totalReceipt, 
      num? totalOutstanding, 
      num? pendingSinceDays, 
      num? custTypeId, 
      dynamic customerType,}){
    _distributorId = distributorId;
    _customerId = customerId;
    _customerName = customerName;
    _collRcptDate = collRcptDate;
    _totalCredit = totalCredit;
    _totalReceipt = totalReceipt;
    _totalOutstanding = totalOutstanding;
    _pendingSinceDays = pendingSinceDays;
    _custTypeId = custTypeId;
    _customerType = customerType;
}

  GetTopFiveCreditorsModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _customerId = json['CustomerId'];
    _customerName = json['CustomerName'];
    _collRcptDate = json['CollRcptDate'];
    _totalCredit = json['TotalCredit'];
    _totalReceipt = json['TotalReceipt'];
    _totalOutstanding = json['TotalOutstanding'];
    _pendingSinceDays = json['PendingSinceDays'];
    _custTypeId = json['CustTypeId'];
    _customerType = json['CustomerType'];
  }
  num? _distributorId;
  num? _customerId;
  dynamic _customerName;
  String? _collRcptDate;
  num? _totalCredit;
  num? _totalReceipt;
  num? _totalOutstanding;
  num? _pendingSinceDays;
  num? _custTypeId;
  dynamic _customerType;
GetTopFiveCreditorsModel copyWith({  num? distributorId,
  num? customerId,
  dynamic customerName,
  String? collRcptDate,
  num? totalCredit,
  num? totalReceipt,
  num? totalOutstanding,
  num? pendingSinceDays,
  num? custTypeId,
  dynamic customerType,
}) => GetTopFiveCreditorsModel(  distributorId: distributorId ?? _distributorId,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  collRcptDate: collRcptDate ?? _collRcptDate,
  totalCredit: totalCredit ?? _totalCredit,
  totalReceipt: totalReceipt ?? _totalReceipt,
  totalOutstanding: totalOutstanding ?? _totalOutstanding,
  pendingSinceDays: pendingSinceDays ?? _pendingSinceDays,
  custTypeId: custTypeId ?? _custTypeId,
  customerType: customerType ?? _customerType,
);
  num? get distributorId => _distributorId;
  num? get customerId => _customerId;
  dynamic get customerName => _customerName;
  String? get collRcptDate => _collRcptDate;
  num? get totalCredit => _totalCredit;
  num? get totalReceipt => _totalReceipt;
  num? get totalOutstanding => _totalOutstanding;
  num? get pendingSinceDays => _pendingSinceDays;
  num? get custTypeId => _custTypeId;
  dynamic get customerType => _customerType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['CustomerId'] = _customerId;
    map['CustomerName'] = _customerName;
    map['CollRcptDate'] = _collRcptDate;
    map['TotalCredit'] = _totalCredit;
    map['TotalReceipt'] = _totalReceipt;
    map['TotalOutstanding'] = _totalOutstanding;
    map['PendingSinceDays'] = _pendingSinceDays;
    map['CustTypeId'] = _custTypeId;
    map['CustomerType'] = _customerType;
    return map;
  }

}