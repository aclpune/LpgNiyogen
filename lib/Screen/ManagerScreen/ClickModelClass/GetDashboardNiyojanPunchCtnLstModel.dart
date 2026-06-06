/// PkId : 1
/// DistributorId : 8118
/// TodayDate : "2025-04-16T00:00:00"
/// StaffId : 21
/// StaffName : "Rathod"
/// NiyojanPunQty : 1
/// SettlementQty : 0
/// PendingSttlQty : 1
/// ConsumerDetails : [{"ConsumerNo":"668326","ConsumerName":"Mrs. Pallavi K Patil","OrderDate":"11-04-2025","CashMemoDate":"11-04-2025","SettlementDate":"null","DeliveryDate":"null","TodayDate2":"2025-04-16T00:00:00","Remark":"Punching Pending In cDCMS"}]

class GetDashboardNiyojanPunchCtnLstModel {
  GetDashboardNiyojanPunchCtnLstModel({
      num? pkId, 
      num? distributorId, 
      String? todayDate, 
      num? staffId, 
      String? staffName, 
      num? niyojanPunQty, 
      num? settlementQty, 
      num? pendingSttlQty, 
      List<ConsumerDetails>? consumerDetails,}){
    _pkId = pkId;
    _distributorId = distributorId;
    _todayDate = todayDate;
    _staffId = staffId;
    _staffName = staffName;
    _niyojanPunQty = niyojanPunQty;
    _settlementQty = settlementQty;
    _pendingSttlQty = pendingSttlQty;
    _consumerDetails = consumerDetails;
}

  GetDashboardNiyojanPunchCtnLstModel.fromJson(dynamic json) {
    _pkId = json['PkId'];
    _distributorId = json['DistributorId'];
    _todayDate = json['TodayDate'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _niyojanPunQty = json['NiyojanPunQty'];
    _settlementQty = json['SettlementQty'];
    _pendingSttlQty = json['PendingSttlQty'];
    if (json['ConsumerDetails'] != null) {
      _consumerDetails = [];
      json['ConsumerDetails'].forEach((v) {
        _consumerDetails?.add(ConsumerDetails.fromJson(v));
      });
    }
  }
  num? _pkId;
  num? _distributorId;
  String? _todayDate;
  num? _staffId;
  String? _staffName;
  num? _niyojanPunQty;
  num? _settlementQty;
  num? _pendingSttlQty;
  List<ConsumerDetails>? _consumerDetails;
GetDashboardNiyojanPunchCtnLstModel copyWith({  num? pkId,
  num? distributorId,
  String? todayDate,
  num? staffId,
  String? staffName,
  num? niyojanPunQty,
  num? settlementQty,
  num? pendingSttlQty,
  List<ConsumerDetails>? consumerDetails,
}) => GetDashboardNiyojanPunchCtnLstModel(  pkId: pkId ?? _pkId,
  distributorId: distributorId ?? _distributorId,
  todayDate: todayDate ?? _todayDate,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  niyojanPunQty: niyojanPunQty ?? _niyojanPunQty,
  settlementQty: settlementQty ?? _settlementQty,
  pendingSttlQty: pendingSttlQty ?? _pendingSttlQty,
  consumerDetails: consumerDetails ?? _consumerDetails,
);
  num? get pkId => _pkId;
  num? get distributorId => _distributorId;
  String? get todayDate => _todayDate;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get niyojanPunQty => _niyojanPunQty;
  num? get settlementQty => _settlementQty;
  num? get pendingSttlQty => _pendingSttlQty;
  List<ConsumerDetails>? get consumerDetails => _consumerDetails;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PkId'] = _pkId;
    map['DistributorId'] = _distributorId;
    map['TodayDate'] = _todayDate;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['NiyojanPunQty'] = _niyojanPunQty;
    map['SettlementQty'] = _settlementQty;
    map['PendingSttlQty'] = _pendingSttlQty;
    if (_consumerDetails != null) {
      map['ConsumerDetails'] = _consumerDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// ConsumerNo : "668326"
/// ConsumerName : "Mrs. Pallavi K Patil"
/// OrderDate : "11-04-2025"
/// CashMemoDate : "11-04-2025"
/// SettlementDate : "null"
/// DeliveryDate : "null"
/// TodayDate2 : "2025-04-16T00:00:00"
/// Remark : "Punching Pending In cDCMS"

class ConsumerDetails {
  ConsumerDetails({
      String? consumerNo, 
      String? consumerName, 
      String? orderDate, 
      String? cashMemoDate, 
      String? settlementDate, 
      String? deliveryDate, 
      String? todayDate2, 
      String? remark,}){
    _consumerNo = consumerNo;
    _consumerName = consumerName;
    _orderDate = orderDate;
    _cashMemoDate = cashMemoDate;
    _settlementDate = settlementDate;
    _deliveryDate = deliveryDate;
    _todayDate2 = todayDate2;
    _remark = remark;
}

  ConsumerDetails.fromJson(dynamic json) {
    _consumerNo = json['ConsumerNo'];
    _consumerName = json['ConsumerName'];
    _orderDate = json['OrderDate'];
    _cashMemoDate = json['CashMemoDate'];
    _settlementDate = json['SettlementDate'];
    _deliveryDate = json['DeliveryDate'];
    _todayDate2 = json['TodayDate2'];
    _remark = json['Remark'];
  }
  String? _consumerNo;
  String? _consumerName;
  String? _orderDate;
  String? _cashMemoDate;
  String? _settlementDate;
  String? _deliveryDate;
  String? _todayDate2;
  String? _remark;
ConsumerDetails copyWith({  String? consumerNo,
  String? consumerName,
  String? orderDate,
  String? cashMemoDate,
  String? settlementDate,
  String? deliveryDate,
  String? todayDate2,
  String? remark,
}) => ConsumerDetails(  consumerNo: consumerNo ?? _consumerNo,
  consumerName: consumerName ?? _consumerName,
  orderDate: orderDate ?? _orderDate,
  cashMemoDate: cashMemoDate ?? _cashMemoDate,
  settlementDate: settlementDate ?? _settlementDate,
  deliveryDate: deliveryDate ?? _deliveryDate,
  todayDate2: todayDate2 ?? _todayDate2,
  remark: remark ?? _remark,
);
  String? get consumerNo => _consumerNo;
  String? get consumerName => _consumerName;
  String? get orderDate => _orderDate;
  String? get cashMemoDate => _cashMemoDate;
  String? get settlementDate => _settlementDate;
  String? get deliveryDate => _deliveryDate;
  String? get todayDate2 => _todayDate2;
  String? get remark => _remark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ConsumerNo'] = _consumerNo;
    map['ConsumerName'] = _consumerName;
    map['OrderDate'] = _orderDate;
    map['CashMemoDate'] = _cashMemoDate;
    map['SettlementDate'] = _settlementDate;
    map['DeliveryDate'] = _deliveryDate;
    map['TodayDate2'] = _todayDate2;
    map['Remark'] = _remark;
    return map;
  }

}