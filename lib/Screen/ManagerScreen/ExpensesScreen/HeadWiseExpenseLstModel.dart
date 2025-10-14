/// DistributorId : 8118
/// ParentExpHeadId : 1
/// ParentExpHeadName : "Office Expense"
/// TotExpAmt : 95201.00

class HeadWiseExpenseLstModel {
  HeadWiseExpenseLstModel({
      num? distributorId, 
      num? parentExpHeadId, 
      String? parentExpHeadName, 
      num? totExpAmt,}){
    _distributorId = distributorId;
    _parentExpHeadId = parentExpHeadId;
    _parentExpHeadName = parentExpHeadName;
    _totExpAmt = totExpAmt;
}

  HeadWiseExpenseLstModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _parentExpHeadId = json['ParentExpHeadId'];
    _parentExpHeadName = json['ParentExpHeadName'];
    _totExpAmt = json['TotExpAmt'];
  }
  num? _distributorId;
  num? _parentExpHeadId;
  String? _parentExpHeadName;
  num? _totExpAmt;
HeadWiseExpenseLstModel copyWith({  num? distributorId,
  num? parentExpHeadId,
  String? parentExpHeadName,
  num? totExpAmt,
}) => HeadWiseExpenseLstModel(  distributorId: distributorId ?? _distributorId,
  parentExpHeadId: parentExpHeadId ?? _parentExpHeadId,
  parentExpHeadName: parentExpHeadName ?? _parentExpHeadName,
  totExpAmt: totExpAmt ?? _totExpAmt,
);
  num? get distributorId => _distributorId;
  num? get parentExpHeadId => _parentExpHeadId;
  String? get parentExpHeadName => _parentExpHeadName;
  num? get totExpAmt => _totExpAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ParentExpHeadId'] = _parentExpHeadId;
    map['ParentExpHeadName'] = _parentExpHeadName;
    map['TotExpAmt'] = _totExpAmt;
    return map;
  }

}