/// ExpId : 46
/// ExpHeadId : 2
/// ExpHeadName : "Acc Settle"
/// DistributorId : 8118
/// VehicleId : 0
/// ExpDate : "0001-01-01T00:00:00"
/// StaffId : 21
/// DSCollMgrId : 148
/// ExpAmount : 100.00
/// Remark : ""
/// AddedOn : "0001-01-01T00:00:00"
/// ExpenseFrom : null
/// ExpStatus : "Settled"
/// Action : null
/// AddedBy : 0

class GetExpenseDetailListModel {
  GetExpenseDetailListModel({
      num? expId, 
      num? expHeadId, 
      String? expHeadName, 
      num? distributorId, 
      num? vehicleId, 
      String? expDate, 
      num? staffId, 
      num? dSCollMgrId, 
      num? expAmount, 
      String? remark, 
      String? addedOn, 
      dynamic expenseFrom, 
      String? expStatus, 
      dynamic action, 
      num? addedBy,}){
    _expId = expId;
    _expHeadId = expHeadId;
    _expHeadName = expHeadName;
    _distributorId = distributorId;
    _vehicleId = vehicleId;
    _expDate = expDate;
    _staffId = staffId;
    _dSCollMgrId = dSCollMgrId;
    _expAmount = expAmount;
    _remark = remark;
    _addedOn = addedOn;
    _expenseFrom = expenseFrom;
    _expStatus = expStatus;
    _action = action;
    _addedBy = addedBy;
}

  GetExpenseDetailListModel.fromJson(dynamic json) {
    _expId = json['ExpId'];
    _expHeadId = json['ExpHeadId'];
    _expHeadName = json['ExpHeadName'];
    _distributorId = json['DistributorId'];
    _vehicleId = json['VehicleId'];
    _expDate = json['ExpDate'];
    _staffId = json['StaffId'];
    _dSCollMgrId = json['DSCollMgrId'];
    _expAmount = json['ExpAmount'];
    _remark = json['Remark'];
    _addedOn = json['AddedOn'];
    _expenseFrom = json['ExpenseFrom'];
    _expStatus = json['ExpStatus'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
  }
  num? _expId;
  num? _expHeadId;
  String? _expHeadName;
  num? _distributorId;
  num? _vehicleId;
  String? _expDate;
  num? _staffId;
  num? _dSCollMgrId;
  num? _expAmount;
  String? _remark;
  String? _addedOn;
  dynamic _expenseFrom;
  String? _expStatus;
  dynamic _action;
  num? _addedBy;
GetExpenseDetailListModel copyWith({  num? expId,
  num? expHeadId,
  String? expHeadName,
  num? distributorId,
  num? vehicleId,
  String? expDate,
  num? staffId,
  num? dSCollMgrId,
  num? expAmount,
  String? remark,
  String? addedOn,
  dynamic expenseFrom,
  String? expStatus,
  dynamic action,
  num? addedBy,
}) => GetExpenseDetailListModel(  expId: expId ?? _expId,
  expHeadId: expHeadId ?? _expHeadId,
  expHeadName: expHeadName ?? _expHeadName,
  distributorId: distributorId ?? _distributorId,
  vehicleId: vehicleId ?? _vehicleId,
  expDate: expDate ?? _expDate,
  staffId: staffId ?? _staffId,
  dSCollMgrId: dSCollMgrId ?? _dSCollMgrId,
  expAmount: expAmount ?? _expAmount,
  remark: remark ?? _remark,
  addedOn: addedOn ?? _addedOn,
  expenseFrom: expenseFrom ?? _expenseFrom,
  expStatus: expStatus ?? _expStatus,
  action: action ?? _action,
  addedBy: addedBy ?? _addedBy,
);
  num? get expId => _expId;
  num? get expHeadId => _expHeadId;
  String? get expHeadName => _expHeadName;
  num? get distributorId => _distributorId;
  num? get vehicleId => _vehicleId;
  String? get expDate => _expDate;
  num? get staffId => _staffId;
  num? get dSCollMgrId => _dSCollMgrId;
  num? get expAmount => _expAmount;
  String? get remark => _remark;
  String? get addedOn => _addedOn;
  dynamic get expenseFrom => _expenseFrom;
  String? get expStatus => _expStatus;
  dynamic get action => _action;
  num? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ExpId'] = _expId;
    map['ExpHeadId'] = _expHeadId;
    map['ExpHeadName'] = _expHeadName;
    map['DistributorId'] = _distributorId;
    map['VehicleId'] = _vehicleId;
    map['ExpDate'] = _expDate;
    map['StaffId'] = _staffId;
    map['DSCollMgrId'] = _dSCollMgrId;
    map['ExpAmount'] = _expAmount;
    map['Remark'] = _remark;
    map['AddedOn'] = _addedOn;
    map['ExpenseFrom'] = _expenseFrom;
    map['ExpStatus'] = _expStatus;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    return map;
  }

}