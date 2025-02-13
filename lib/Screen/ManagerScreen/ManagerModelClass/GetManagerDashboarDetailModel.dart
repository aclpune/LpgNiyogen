/// DistributorId : 8118
/// ItemId : 1
/// ItemName : "14.2 kg"
/// FilledDiff : 2148
/// EmptyDiff : 914
/// DefectiveDiff : 193
/// TodayImbQty : 0
/// AsOfDateImbQty : 5
/// DMCount : 3
/// TotalAmount : 202500.00
/// TotalIncome : 2000.00
/// TotalExp : 1000.00
/// StaffOnAccToday : 0.00
/// StaffOnAccAsOf : 7001.09

class GetManagerDashboarDetailModel {
  GetManagerDashboarDetailModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? filledDiff, 
      num? emptyDiff, 
      num? defectiveDiff, 
      num? todayImbQty, 
      num? asOfDateImbQty, 
      num? dMCount, 
      num? totalAmount, 
      num? totalIncome, 
      num? totalExp, 
      num? staffOnAccToday, 
      num? staffOnAccAsOf,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _filledDiff = filledDiff;
    _emptyDiff = emptyDiff;
    _defectiveDiff = defectiveDiff;
    _todayImbQty = todayImbQty;
    _asOfDateImbQty = asOfDateImbQty;
    _dMCount = dMCount;
    _totalAmount = totalAmount;
    _totalIncome = totalIncome;
    _totalExp = totalExp;
    _staffOnAccToday = staffOnAccToday;
    _staffOnAccAsOf = staffOnAccAsOf;
}

  GetManagerDashboarDetailModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledDiff = json['FilledDiff'];
    _emptyDiff = json['EmptyDiff'];
    _defectiveDiff = json['DefectiveDiff'];
    _todayImbQty = json['TodayImbQty'];
    _asOfDateImbQty = json['AsOfDateImbQty'];
    _dMCount = json['DMCount'];
    _totalAmount = json['TotalAmount'];
    _totalIncome = json['TotalIncome'];
    _totalExp = json['TotalExp'];
    _staffOnAccToday = json['StaffOnAccToday'];
    _staffOnAccAsOf = json['StaffOnAccAsOf'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _filledDiff;
  num? _emptyDiff;
  num? _defectiveDiff;
  num? _todayImbQty;
  num? _asOfDateImbQty;
  num? _dMCount;
  num? _totalAmount;
  num? _totalIncome;
  num? _totalExp;
  num? _staffOnAccToday;
  num? _staffOnAccAsOf;
GetManagerDashboarDetailModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? filledDiff,
  num? emptyDiff,
  num? defectiveDiff,
  num? todayImbQty,
  num? asOfDateImbQty,
  num? dMCount,
  num? totalAmount,
  num? totalIncome,
  num? totalExp,
  num? staffOnAccToday,
  num? staffOnAccAsOf,
}) => GetManagerDashboarDetailModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledDiff: filledDiff ?? _filledDiff,
  emptyDiff: emptyDiff ?? _emptyDiff,
  defectiveDiff: defectiveDiff ?? _defectiveDiff,
  todayImbQty: todayImbQty ?? _todayImbQty,
  asOfDateImbQty: asOfDateImbQty ?? _asOfDateImbQty,
  dMCount: dMCount ?? _dMCount,
  totalAmount: totalAmount ?? _totalAmount,
  totalIncome: totalIncome ?? _totalIncome,
  totalExp: totalExp ?? _totalExp,
  staffOnAccToday: staffOnAccToday ?? _staffOnAccToday,
  staffOnAccAsOf: staffOnAccAsOf ?? _staffOnAccAsOf,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledDiff => _filledDiff;
  num? get emptyDiff => _emptyDiff;
  num? get defectiveDiff => _defectiveDiff;
  num? get todayImbQty => _todayImbQty;
  num? get asOfDateImbQty => _asOfDateImbQty;
  num? get dMCount => _dMCount;
  num? get totalAmount => _totalAmount;
  num? get totalIncome => _totalIncome;
  num? get totalExp => _totalExp;
  num? get staffOnAccToday => _staffOnAccToday;
  num? get staffOnAccAsOf => _staffOnAccAsOf;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledDiff'] = _filledDiff;
    map['EmptyDiff'] = _emptyDiff;
    map['DefectiveDiff'] = _defectiveDiff;
    map['TodayImbQty'] = _todayImbQty;
    map['AsOfDateImbQty'] = _asOfDateImbQty;
    map['DMCount'] = _dMCount;
    map['TotalAmount'] = _totalAmount;
    map['TotalIncome'] = _totalIncome;
    map['TotalExp'] = _totalExp;
    map['StaffOnAccToday'] = _staffOnAccToday;
    map['StaffOnAccAsOf'] = _staffOnAccAsOf;
    return map;
  }

}