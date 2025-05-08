/// HandoverId : 0
/// DistributorId : 8118
/// TotalAmount : 0.0
/// HandoverFromId : null
/// HandoverToType : 0
/// IsCashHandover : 0
/// AddedBy : 0
/// DenomDtList : null
/// HandoverDate : "0001-01-01T00:00:00"
/// Date : null
/// StaffId : 4
/// StaffName : "Shamika Joshi"
/// CollAmt : 554077.00
/// PaidAmt : 2200.00
/// CashCollDate : "2025-04-10T00:00:00"
/// HandoverToId : 0
/// HandoverAmt : null
/// TotalAmt : 551877.00
/// AcceptedById : 0
/// HandoverStatus : 0
/// TotalHandoverAmt : 0.0

class GetCashHandOverDtlsModel {
  GetCashHandOverDtlsModel({
      num? handoverId, 
      num? distributorId, 
      num? totalAmount, 
      dynamic handoverFromId, 
      num? handoverToType, 
      num? isCashHandover, 
      num? addedBy, 
      dynamic denomDtList, 
      String? handoverDate, 
      dynamic date, 
      num? staffId, 
      String? staffName, 
      num? collAmt, 
      num? paidAmt, 
      String? cashCollDate, 
      num? handoverToId, 
      dynamic handoverAmt, 
      num? totalAmt, 
      num? acceptedById, 
      num? handoverStatus, 
      num? totalHandoverAmt,}){
    _handoverId = handoverId;
    _distributorId = distributorId;
    _totalAmount = totalAmount;
    _handoverFromId = handoverFromId;
    _handoverToType = handoverToType;
    _isCashHandover = isCashHandover;
    _addedBy = addedBy;
    _denomDtList = denomDtList;
    _handoverDate = handoverDate;
    _date = date;
    _staffId = staffId;
    _staffName = staffName;
    _collAmt = collAmt;
    _paidAmt = paidAmt;
    _cashCollDate = cashCollDate;
    _handoverToId = handoverToId;
    _handoverAmt = handoverAmt;
    _totalAmt = totalAmt;
    _acceptedById = acceptedById;
    _handoverStatus = handoverStatus;
    _totalHandoverAmt = totalHandoverAmt;
}

  GetCashHandOverDtlsModel.fromJson(dynamic json) {
    _handoverId = json['HandoverId'];
    _distributorId = json['DistributorId'];
    _totalAmount = json['TotalAmount'];
    _handoverFromId = json['HandoverFromId'];
    _handoverToType = json['HandoverToType'];
    _isCashHandover = json['IsCashHandover'];
    _addedBy = json['AddedBy'];
    _denomDtList = json['DenomDtList'];
    _handoverDate = json['HandoverDate'];
    _date = json['Date'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _collAmt = json['CollAmt'];
    _paidAmt = json['PaidAmt'];
    _cashCollDate = json['CashCollDate'];
    _handoverToId = json['HandoverToId'];
    _handoverAmt = json['HandoverAmt'];
    _totalAmt = json['TotalAmt'];
    _acceptedById = json['AcceptedById'];
    _handoverStatus = json['HandoverStatus'];
    _totalHandoverAmt = json['TotalHandoverAmt'];
  }
  num? _handoverId;
  num? _distributorId;
  num? _totalAmount;
  dynamic _handoverFromId;
  num? _handoverToType;
  num? _isCashHandover;
  num? _addedBy;
  dynamic _denomDtList;
  String? _handoverDate;
  dynamic _date;
  num? _staffId;
  String? _staffName;
  num? _collAmt;
  num? _paidAmt;
  String? _cashCollDate;
  num? _handoverToId;
  dynamic _handoverAmt;
  num? _totalAmt;
  num? _acceptedById;
  num? _handoverStatus;
  num? _totalHandoverAmt;
GetCashHandOverDtlsModel copyWith({  num? handoverId,
  num? distributorId,
  num? totalAmount,
  dynamic handoverFromId,
  num? handoverToType,
  num? isCashHandover,
  num? addedBy,
  dynamic denomDtList,
  String? handoverDate,
  dynamic date,
  num? staffId,
  String? staffName,
  num? collAmt,
  num? paidAmt,
  String? cashCollDate,
  num? handoverToId,
  dynamic handoverAmt,
  num? totalAmt,
  num? acceptedById,
  num? handoverStatus,
  num? totalHandoverAmt,
}) => GetCashHandOverDtlsModel(  handoverId: handoverId ?? _handoverId,
  distributorId: distributorId ?? _distributorId,
  totalAmount: totalAmount ?? _totalAmount,
  handoverFromId: handoverFromId ?? _handoverFromId,
  handoverToType: handoverToType ?? _handoverToType,
  isCashHandover: isCashHandover ?? _isCashHandover,
  addedBy: addedBy ?? _addedBy,
  denomDtList: denomDtList ?? _denomDtList,
  handoverDate: handoverDate ?? _handoverDate,
  date: date ?? _date,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  collAmt: collAmt ?? _collAmt,
  paidAmt: paidAmt ?? _paidAmt,
  cashCollDate: cashCollDate ?? _cashCollDate,
  handoverToId: handoverToId ?? _handoverToId,
  handoverAmt: handoverAmt ?? _handoverAmt,
  totalAmt: totalAmt ?? _totalAmt,
  acceptedById: acceptedById ?? _acceptedById,
  handoverStatus: handoverStatus ?? _handoverStatus,
  totalHandoverAmt: totalHandoverAmt ?? _totalHandoverAmt,
);
  num? get handoverId => _handoverId;
  num? get distributorId => _distributorId;
  num? get totalAmount => _totalAmount;
  dynamic get handoverFromId => _handoverFromId;
  num? get handoverToType => _handoverToType;
  num? get isCashHandover => _isCashHandover;
  num? get addedBy => _addedBy;
  dynamic get denomDtList => _denomDtList;
  String? get handoverDate => _handoverDate;
  dynamic get date => _date;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get collAmt => _collAmt;
  num? get paidAmt => _paidAmt;
  String? get cashCollDate => _cashCollDate;
  num? get handoverToId => _handoverToId;
  dynamic get handoverAmt => _handoverAmt;
  num? get totalAmt => _totalAmt;
  num? get acceptedById => _acceptedById;
  num? get handoverStatus => _handoverStatus;
  num? get totalHandoverAmt => _totalHandoverAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['HandoverId'] = _handoverId;
    map['DistributorId'] = _distributorId;
    map['TotalAmount'] = _totalAmount;
    map['HandoverFromId'] = _handoverFromId;
    map['HandoverToType'] = _handoverToType;
    map['IsCashHandover'] = _isCashHandover;
    map['AddedBy'] = _addedBy;
    map['DenomDtList'] = _denomDtList;
    map['HandoverDate'] = _handoverDate;
    map['Date'] = _date;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['CollAmt'] = _collAmt;
    map['PaidAmt'] = _paidAmt;
    map['CashCollDate'] = _cashCollDate;
    map['HandoverToId'] = _handoverToId;
    map['HandoverAmt'] = _handoverAmt;
    map['TotalAmt'] = _totalAmt;
    map['AcceptedById'] = _acceptedById;
    map['HandoverStatus'] = _handoverStatus;
    map['TotalHandoverAmt'] = _totalHandoverAmt;
    return map;
  }

}