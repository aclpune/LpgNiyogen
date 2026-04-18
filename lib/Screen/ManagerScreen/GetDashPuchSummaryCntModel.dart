/// DistributorId : 0
/// PunchManToday : 0
/// PunchManAsOf : 7051
/// PunchDACToday : 0
/// PunchDACAsOf : 8911
/// BkgManToday : 0
/// BkgManAsOf : 6
/// BkgOnlineToday : 0
/// BkgOnlineAsOf : 932
/// DeliveryDate : "2026-01-01T00:00:00"
/// OrderDate : "2025-02-07T00:00:00"
/// PunchManTodayPct : 0.0
/// PunchManAsOfPct : 44.17
/// PunchDACTodayPct : 0.0
/// PunchDACAsOfPct : 55.83
/// BkgManTodayPct : 0.0
/// BkgManAsOfPct : 0.64
/// BkgOnlineTodayPct : 0.0
/// BkgOnlineAsOfPct : 99.36

class GetDashPunchSummaryCntModel {
  GetDashPunchSummaryCntModel({
    num? distributorId,
    num? punchManToday,
    num? punchManAsOf,
    num? punchDACToday,
    num? punchDACAsOf,
    num? bkgManToday,
    num? bkgManAsOf,
    num? bkgOnlineToday,
    num? bkgOnlineAsOf,
    String? deliveryDate,
    String? orderDate,
    num? punchManTodayPct,
    num? punchManAsOfPct,
    num? punchDACTodayPct,
    num? punchDACAsOfPct,
    num? bkgManTodayPct,
    num? bkgManAsOfPct,
    num? bkgOnlineTodayPct,
    num? bkgOnlineAsOfPct,}){
    _distributorId = distributorId;
    _punchManToday = punchManToday;
    _punchManAsOf = punchManAsOf;
    _punchDACToday = punchDACToday;
    _punchDACAsOf = punchDACAsOf;
    _bkgManToday = bkgManToday;
    _bkgManAsOf = bkgManAsOf;
    _bkgOnlineToday = bkgOnlineToday;
    _bkgOnlineAsOf = bkgOnlineAsOf;
    _deliveryDate = deliveryDate;
    _orderDate = orderDate;
    _punchManTodayPct = punchManTodayPct;
    _punchManAsOfPct = punchManAsOfPct;
    _punchDACTodayPct = punchDACTodayPct;
    _punchDACAsOfPct = punchDACAsOfPct;
    _bkgManTodayPct = bkgManTodayPct;
    _bkgManAsOfPct = bkgManAsOfPct;
    _bkgOnlineTodayPct = bkgOnlineTodayPct;
    _bkgOnlineAsOfPct = bkgOnlineAsOfPct;
  }

  GetDashPunchSummaryCntModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _punchManToday = json['PunchManToday'];
    _punchManAsOf = json['PunchManAsOf'];
    _punchDACToday = json['PunchDACToday'];
    _punchDACAsOf = json['PunchDACAsOf'];
    _bkgManToday = json['BkgManToday'];
    _bkgManAsOf = json['BkgManAsOf'];
    _bkgOnlineToday = json['BkgOnlineToday'];
    _bkgOnlineAsOf = json['BkgOnlineAsOf'];
    _deliveryDate = json['DeliveryDate'];
    _orderDate = json['OrderDate'];
    _punchManTodayPct = json['PunchManTodayPct'];
    _punchManAsOfPct = json['PunchManAsOfPct'];
    _punchDACTodayPct = json['PunchDACTodayPct'];
    _punchDACAsOfPct = json['PunchDACAsOfPct'];
    _bkgManTodayPct = json['BkgManTodayPct'];
    _bkgManAsOfPct = json['BkgManAsOfPct'];
    _bkgOnlineTodayPct = json['BkgOnlineTodayPct'];
    _bkgOnlineAsOfPct = json['BkgOnlineAsOfPct'];
  }
  num? _distributorId;
  num? _punchManToday;
  num? _punchManAsOf;
  num? _punchDACToday;
  num? _punchDACAsOf;
  num? _bkgManToday;
  num? _bkgManAsOf;
  num? _bkgOnlineToday;
  num? _bkgOnlineAsOf;
  String? _deliveryDate;
  String? _orderDate;
  num? _punchManTodayPct;
  num? _punchManAsOfPct;
  num? _punchDACTodayPct;
  num? _punchDACAsOfPct;
  num? _bkgManTodayPct;
  num? _bkgManAsOfPct;
  num? _bkgOnlineTodayPct;
  num? _bkgOnlineAsOfPct;
  GetDashPunchSummaryCntModel copyWith({  num? distributorId,
    num? punchManToday,
    num? punchManAsOf,
    num? punchDACToday,
    num? punchDACAsOf,
    num? bkgManToday,
    num? bkgManAsOf,
    num? bkgOnlineToday,
    num? bkgOnlineAsOf,
    String? deliveryDate,
    String? orderDate,
    num? punchManTodayPct,
    num? punchManAsOfPct,
    num? punchDACTodayPct,
    num? punchDACAsOfPct,
    num? bkgManTodayPct,
    num? bkgManAsOfPct,
    num? bkgOnlineTodayPct,
    num? bkgOnlineAsOfPct,
  }) => GetDashPunchSummaryCntModel(  distributorId: distributorId ?? _distributorId,
    punchManToday: punchManToday ?? _punchManToday,
    punchManAsOf: punchManAsOf ?? _punchManAsOf,
    punchDACToday: punchDACToday ?? _punchDACToday,
    punchDACAsOf: punchDACAsOf ?? _punchDACAsOf,
    bkgManToday: bkgManToday ?? _bkgManToday,
    bkgManAsOf: bkgManAsOf ?? _bkgManAsOf,
    bkgOnlineToday: bkgOnlineToday ?? _bkgOnlineToday,
    bkgOnlineAsOf: bkgOnlineAsOf ?? _bkgOnlineAsOf,
    deliveryDate: deliveryDate ?? _deliveryDate,
    orderDate: orderDate ?? _orderDate,
    punchManTodayPct: punchManTodayPct ?? _punchManTodayPct,
    punchManAsOfPct: punchManAsOfPct ?? _punchManAsOfPct,
    punchDACTodayPct: punchDACTodayPct ?? _punchDACTodayPct,
    punchDACAsOfPct: punchDACAsOfPct ?? _punchDACAsOfPct,
    bkgManTodayPct: bkgManTodayPct ?? _bkgManTodayPct,
    bkgManAsOfPct: bkgManAsOfPct ?? _bkgManAsOfPct,
    bkgOnlineTodayPct: bkgOnlineTodayPct ?? _bkgOnlineTodayPct,
    bkgOnlineAsOfPct: bkgOnlineAsOfPct ?? _bkgOnlineAsOfPct,
  );
  num? get distributorId => _distributorId;
  num? get punchManToday => _punchManToday;
  num? get punchManAsOf => _punchManAsOf;
  num? get punchDACToday => _punchDACToday;
  num? get punchDACAsOf => _punchDACAsOf;
  num? get bkgManToday => _bkgManToday;
  num? get bkgManAsOf => _bkgManAsOf;
  num? get bkgOnlineToday => _bkgOnlineToday;
  num? get bkgOnlineAsOf => _bkgOnlineAsOf;
  String? get deliveryDate => _deliveryDate;
  String? get orderDate => _orderDate;
  num? get punchManTodayPct => _punchManTodayPct;
  num? get punchManAsOfPct => _punchManAsOfPct;
  num? get punchDACTodayPct => _punchDACTodayPct;
  num? get punchDACAsOfPct => _punchDACAsOfPct;
  num? get bkgManTodayPct => _bkgManTodayPct;
  num? get bkgManAsOfPct => _bkgManAsOfPct;
  num? get bkgOnlineTodayPct => _bkgOnlineTodayPct;
  num? get bkgOnlineAsOfPct => _bkgOnlineAsOfPct;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['PunchManToday'] = _punchManToday;
    map['PunchManAsOf'] = _punchManAsOf;
    map['PunchDACToday'] = _punchDACToday;
    map['PunchDACAsOf'] = _punchDACAsOf;
    map['BkgManToday'] = _bkgManToday;
    map['BkgManAsOf'] = _bkgManAsOf;
    map['BkgOnlineToday'] = _bkgOnlineToday;
    map['BkgOnlineAsOf'] = _bkgOnlineAsOf;
    map['DeliveryDate'] = _deliveryDate;
    map['OrderDate'] = _orderDate;
    map['PunchManTodayPct'] = _punchManTodayPct;
    map['PunchManAsOfPct'] = _punchManAsOfPct;
    map['PunchDACTodayPct'] = _punchDACTodayPct;
    map['PunchDACAsOfPct'] = _punchDACAsOfPct;
    map['BkgManTodayPct'] = _bkgManTodayPct;
    map['BkgManAsOfPct'] = _bkgManAsOfPct;
    map['BkgOnlineTodayPct'] = _bkgOnlineTodayPct;
    map['BkgOnlineAsOfPct'] = _bkgOnlineAsOfPct;
    return map;
  }

}