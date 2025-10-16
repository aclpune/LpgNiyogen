/// DistributorId : 8118
/// ItemId : 1
/// ItemName : "14.2 KG"
/// FilledDiff : 1503
/// EmptyDiff : 278
/// DefectiveDiff : 6
/// TodayImbQty : 0
/// AsOfDateImbQty : 172

class GetDashSummaryItemWiseForMgrModel {
  GetDashSummaryItemWiseForMgrModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? filledDiff, 
      num? emptyDiff, 
      num? defectiveDiff, 
      num? todayImbQty, 
      num? asOfDateImbQty,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _filledDiff = filledDiff;
    _emptyDiff = emptyDiff;
    _defectiveDiff = defectiveDiff;
    _todayImbQty = todayImbQty;
    _asOfDateImbQty = asOfDateImbQty;
}

  GetDashSummaryItemWiseForMgrModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledDiff = json['FilledDiff'];
    _emptyDiff = json['EmptyDiff'];
    _defectiveDiff = json['DefectiveDiff'];
    _todayImbQty = json['TodayImbQty'];
    _asOfDateImbQty = json['AsOfDateImbQty'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _filledDiff;
  num? _emptyDiff;
  num? _defectiveDiff;
  num? _todayImbQty;
  num? _asOfDateImbQty;
GetDashSummaryItemWiseForMgrModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? filledDiff,
  num? emptyDiff,
  num? defectiveDiff,
  num? todayImbQty,
  num? asOfDateImbQty,
}) => GetDashSummaryItemWiseForMgrModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledDiff: filledDiff ?? _filledDiff,
  emptyDiff: emptyDiff ?? _emptyDiff,
  defectiveDiff: defectiveDiff ?? _defectiveDiff,
  todayImbQty: todayImbQty ?? _todayImbQty,
  asOfDateImbQty: asOfDateImbQty ?? _asOfDateImbQty,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledDiff => _filledDiff;
  num? get emptyDiff => _emptyDiff;
  num? get defectiveDiff => _defectiveDiff;
  num? get todayImbQty => _todayImbQty;
  num? get asOfDateImbQty => _asOfDateImbQty;

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
    return map;
  }

}