/// CashHandoverId : 0
/// DistributorId : 8118
/// TotalAmt : 416183.00
/// StaffIds : null
/// CashHandoverTo_ID : 0
/// IsCashHandover : 0
/// AddedBy : 0
/// CashCollDate : "2025-03-28T00:00:00"
/// StaffId : 4
/// StaffName : "LPG Gas Dealer"
/// CashInHand : 0.0
/// CollAmt : 0.0
/// PaidAmt : 0.0
/// Date : "0001-01-01T00:00:00"
/// HeaderNameStr : "Cash In Hand"
/// BankId : 0
/// MappingId : 0

class ManagerDsrReoprtCashFlowSummaryMode {
  ManagerDsrReoprtCashFlowSummaryMode({
      num? cashHandoverId, 
      num? distributorId, 
      num? totalAmt, 
      dynamic staffIds, 
      num? cashHandoverToID, 
      num? isCashHandover, 
      num? addedBy, 
      String? cashCollDate, 
      num? staffId, 
      String? staffName, 
      num? cashInHand, 
      num? collAmt, 
      num? paidAmt, 
      String? date, 
      String? headerNameStr, 
      num? bankId, 
      num? mappingId,}){
    _cashHandoverId = cashHandoverId;
    _distributorId = distributorId;
    _totalAmt = totalAmt;
    _staffIds = staffIds;
    _cashHandoverToID = cashHandoverToID;
    _isCashHandover = isCashHandover;
    _addedBy = addedBy;
    _cashCollDate = cashCollDate;
    _staffId = staffId;
    _staffName = staffName;
    _cashInHand = cashInHand;
    _collAmt = collAmt;
    _paidAmt = paidAmt;
    _date = date;
    _headerNameStr = headerNameStr;
    _bankId = bankId;
    _mappingId = mappingId;
}

  ManagerDsrReoprtCashFlowSummaryMode.fromJson(dynamic json) {
    _cashHandoverId = json['CashHandoverId'];
    _distributorId = json['DistributorId'];
    _totalAmt = json['TotalAmt'];
    _staffIds = json['StaffIds'];
    _cashHandoverToID = json['CashHandoverTo_ID'];
    _isCashHandover = json['IsCashHandover'];
    _addedBy = json['AddedBy'];
    _cashCollDate = json['CashCollDate'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _cashInHand = json['CashInHand'];
    _collAmt = json['CollAmt'];
    _paidAmt = json['PaidAmt'];
    _date = json['Date'];
    _headerNameStr = json['HeaderNameStr'];
    _bankId = json['BankId'];
    _mappingId = json['MappingId'];
  }
  num? _cashHandoverId;
  num? _distributorId;
  num? _totalAmt;
  dynamic _staffIds;
  num? _cashHandoverToID;
  num? _isCashHandover;
  num? _addedBy;
  String? _cashCollDate;
  num? _staffId;
  String? _staffName;
  num? _cashInHand;
  num? _collAmt;
  num? _paidAmt;
  String? _date;
  String? _headerNameStr;
  num? _bankId;
  num? _mappingId;
ManagerDsrReoprtCashFlowSummaryMode copyWith({  num? cashHandoverId,
  num? distributorId,
  num? totalAmt,
  dynamic staffIds,
  num? cashHandoverToID,
  num? isCashHandover,
  num? addedBy,
  String? cashCollDate,
  num? staffId,
  String? staffName,
  num? cashInHand,
  num? collAmt,
  num? paidAmt,
  String? date,
  String? headerNameStr,
  num? bankId,
  num? mappingId,
}) => ManagerDsrReoprtCashFlowSummaryMode(  cashHandoverId: cashHandoverId ?? _cashHandoverId,
  distributorId: distributorId ?? _distributorId,
  totalAmt: totalAmt ?? _totalAmt,
  staffIds: staffIds ?? _staffIds,
  cashHandoverToID: cashHandoverToID ?? _cashHandoverToID,
  isCashHandover: isCashHandover ?? _isCashHandover,
  addedBy: addedBy ?? _addedBy,
  cashCollDate: cashCollDate ?? _cashCollDate,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  cashInHand: cashInHand ?? _cashInHand,
  collAmt: collAmt ?? _collAmt,
  paidAmt: paidAmt ?? _paidAmt,
  date: date ?? _date,
  headerNameStr: headerNameStr ?? _headerNameStr,
  bankId: bankId ?? _bankId,
  mappingId: mappingId ?? _mappingId,
);
  num? get cashHandoverId => _cashHandoverId;
  num? get distributorId => _distributorId;
  num? get totalAmt => _totalAmt;
  dynamic get staffIds => _staffIds;
  num? get cashHandoverToID => _cashHandoverToID;
  num? get isCashHandover => _isCashHandover;
  num? get addedBy => _addedBy;
  String? get cashCollDate => _cashCollDate;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get cashInHand => _cashInHand;
  num? get collAmt => _collAmt;
  num? get paidAmt => _paidAmt;
  String? get date => _date;
  String? get headerNameStr => _headerNameStr;
  num? get bankId => _bankId;
  num? get mappingId => _mappingId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CashHandoverId'] = _cashHandoverId;
    map['DistributorId'] = _distributorId;
    map['TotalAmt'] = _totalAmt;
    map['StaffIds'] = _staffIds;
    map['CashHandoverTo_ID'] = _cashHandoverToID;
    map['IsCashHandover'] = _isCashHandover;
    map['AddedBy'] = _addedBy;
    map['CashCollDate'] = _cashCollDate;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['CashInHand'] = _cashInHand;
    map['CollAmt'] = _collAmt;
    map['PaidAmt'] = _paidAmt;
    map['Date'] = _date;
    map['HeaderNameStr'] = _headerNameStr;
    map['BankId'] = _bankId;
    map['MappingId'] = _mappingId;
    return map;
  }

}