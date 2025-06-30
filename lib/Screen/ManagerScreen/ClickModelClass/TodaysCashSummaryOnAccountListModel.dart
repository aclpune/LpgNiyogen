/// DistributorId : 8118
/// StaffId : 44
/// StaffName : "19kg Devendra"
/// StaffOnAccToday : 0.00
/// StaffOnAccAsOf : 117720.00

class TodaysCashSummaryOnAccountListModel {
  TodaysCashSummaryOnAccountListModel({
      num? distributorId, 
      num? staffId, 
      String? staffName, 
      num? staffOnAccToday, 
      num? staffOnAccAsOf,}){
    _distributorId = distributorId;
    _staffId = staffId;
    _staffName = staffName;
    _staffOnAccToday = staffOnAccToday;
    _staffOnAccAsOf = staffOnAccAsOf;
}

  TodaysCashSummaryOnAccountListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _staffOnAccToday = json['StaffOnAccToday'];
    _staffOnAccAsOf = json['StaffOnAccAsOf'];
  }
  num? _distributorId;
  num? _staffId;
  String? _staffName;
  num? _staffOnAccToday;
  num? _staffOnAccAsOf;
TodaysCashSummaryOnAccountListModel copyWith({  num? distributorId,
  num? staffId,
  String? staffName,
  num? staffOnAccToday,
  num? staffOnAccAsOf,
}) => TodaysCashSummaryOnAccountListModel(  distributorId: distributorId ?? _distributorId,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  staffOnAccToday: staffOnAccToday ?? _staffOnAccToday,
  staffOnAccAsOf: staffOnAccAsOf ?? _staffOnAccAsOf,
);
  num? get distributorId => _distributorId;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get staffOnAccToday => _staffOnAccToday;
  num? get staffOnAccAsOf => _staffOnAccAsOf;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['StaffOnAccToday'] = _staffOnAccToday;
    map['StaffOnAccAsOf'] = _staffOnAccAsOf;
    return map;
  }

}