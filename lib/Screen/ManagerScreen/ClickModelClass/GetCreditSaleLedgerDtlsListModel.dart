/// DistributorId : 8118
/// CustomerId : 0
/// CustomerName : null
/// CollRcptDate : "2025-02-04T00:00:00"
/// TotalCredit : 150628.50
/// TotalReceipt : 322860.00
/// TotalOutstanding : -172231.50
/// PendingSinceDays : 218.0

class GetCreditSaleLedgerDtlsListModel {
  GetCreditSaleLedgerDtlsListModel({
      num? distributorId, 
      num? customerId, 
      dynamic customerName, 
      String? collRcptDate, 
      num? totalCredit, 
      num? totalReceipt, 
      num? totalOutstanding, 
      num? pendingSinceDays,}){
    _distributorId = distributorId;
    _customerId = customerId;
    _customerName = customerName;
    _collRcptDate = collRcptDate;
    _totalCredit = totalCredit;
    _totalReceipt = totalReceipt;
    _totalOutstanding = totalOutstanding;
    _pendingSinceDays = pendingSinceDays;
}

  GetCreditSaleLedgerDtlsListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _customerId = json['CustomerId'];
    _customerName = json['CustomerName'];
    _collRcptDate = json['CollRcptDate'];
    _totalCredit = json['TotalCredit'];
    _totalReceipt = json['TotalReceipt'];
    _totalOutstanding = json['TotalOutstanding'];
    _pendingSinceDays = json['PendingSinceDays'];
  }
  num? _distributorId;
  num? _customerId;
  dynamic _customerName;
  String? _collRcptDate;
  num? _totalCredit;
  num? _totalReceipt;
  num? _totalOutstanding;
  num? _pendingSinceDays;
GetCreditSaleLedgerDtlsListModel copyWith({  num? distributorId,
  num? customerId,
  dynamic customerName,
  String? collRcptDate,
  num? totalCredit,
  num? totalReceipt,
  num? totalOutstanding,
  num? pendingSinceDays,
}) => GetCreditSaleLedgerDtlsListModel(  distributorId: distributorId ?? _distributorId,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  collRcptDate: collRcptDate ?? _collRcptDate,
  totalCredit: totalCredit ?? _totalCredit,
  totalReceipt: totalReceipt ?? _totalReceipt,
  totalOutstanding: totalOutstanding ?? _totalOutstanding,
  pendingSinceDays: pendingSinceDays ?? _pendingSinceDays,
);
  num? get distributorId => _distributorId;
  num? get customerId => _customerId;
  dynamic get customerName => _customerName;
  String? get collRcptDate => _collRcptDate;
  num? get totalCredit => _totalCredit;
  num? get totalReceipt => _totalReceipt;
  num? get totalOutstanding => _totalOutstanding;
  num? get pendingSinceDays => _pendingSinceDays;

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
    return map;
  }

}