/// DistributorId : 8118
/// TransId : 107
/// TransCode : "134"
/// StaffName : "Rahul"
/// TransTime : ""
/// TransDate : "2025-04-15T00:00:00"
/// Amount : 805.50
/// TransFor : "Daily Sales"
/// Remark : ""

class GetDashboardPostpaidVarifiPendCntLstForMobListModel {
  GetDashboardPostpaidVarifiPendCntLstForMobListModel({
      num? distributorId, 
      num? transId, 
      String? transCode, 
      String? staffName, 
      String? transTime, 
      String? transDate, 
      num? amount, 
      String? transFor, 
      String? remark,
    DateTime? selectedDate,
    bool? isChecked,// Store the selected date for each item
    String? bankName,// Store the selected date for each item
    String? accountNo,// Store the selected date for each item
  }){
    _distributorId = distributorId;
    _transId = transId;
    _transCode = transCode;
    _staffName = staffName;
    _transTime = transTime;
    _transDate = transDate;
    _amount = amount;
    _transFor = transFor;
    _remark = remark;
    _selectedDate = selectedDate;
    _isChecked = isChecked;
    _bankName = bankName;
    _accountNo = accountNo;
}

  GetDashboardPostpaidVarifiPendCntLstForMobListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _transId = json['TransId'];
    _transCode = json['TransCode'];
    _staffName = json['StaffName'];
    _transTime = json['TransTime'];
    _transDate = json['TransDate'];
    _amount = json['Amount'];
    _transFor = json['TransFor'];
    _remark = json['Remark'];
    _selectedDate = json['selectedDate'];
    _isChecked = json['isChecked'];
    _bankName = json['bankName'];
    _accountNo = json['accountNo'];
  }
  num? _distributorId;
  num? _transId;
  String? _transCode;
  String? _staffName;
  String? _transTime;
  String? _transDate;
  num? _amount;
  String? _transFor;
  String? _remark;
  DateTime? _selectedDate;
  bool? _isChecked;
  String? _bankName;
  String? _accountNo;

GetDashboardPostpaidVarifiPendCntLstForMobListModel copyWith({  num? distributorId,
  num? transId,
  String? transCode,
  String? staffName,
  String? transTime,
  String? transDate,
  num? amount,
  String? transFor,
  String? remark,
  DateTime? selectedDate,
  bool? isChecked,
  String? bankName,
  String? accountNo,
}) => GetDashboardPostpaidVarifiPendCntLstForMobListModel(  distributorId: distributorId ?? _distributorId,
  transId: transId ?? _transId,
  transCode: transCode ?? _transCode,
  staffName: staffName ?? _staffName,
  transTime: transTime ?? _transTime,
  transDate: transDate ?? _transDate,
  amount: amount ?? _amount,
  transFor: transFor ?? _transFor,
  remark: remark ?? _remark,
  selectedDate: selectedDate ?? _selectedDate,
  isChecked: isChecked ?? _isChecked,
  bankName: bankName ?? _bankName,
  accountNo: accountNo ?? _accountNo,
);
  num? get distributorId => _distributorId;
  num? get transId => _transId;
  String? get transCode => _transCode;
  String? get staffName => _staffName;
  String? get transTime => _transTime;
  String? get transDate => _transDate;
  num? get amount => _amount;
  String? get transFor => _transFor;
  String? get remark => _remark;
  DateTime? get selectedDate => _selectedDate;
  bool? get isChecked => _isChecked;
  String? get bankName => _bankName;
  String? get accountNo => _accountNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['TransId'] = _transId;
    map['TransCode'] = _transCode;
    map['StaffName'] = _staffName;
    map['TransTime'] = _transTime;
    map['TransDate'] = _transDate;
    map['Amount'] = _amount;
    map['TransFor'] = _transFor;
    map['Remark'] = _remark;
    map['selectedDate'] = _selectedDate;
    map['isChecked'] = _isChecked;
    map['bankName'] = _bankName;
    map['accountNo'] = _accountNo;
    return map;
  }
  // Getter

  // Setter
  set selectedDate(DateTime? value) {
    _selectedDate = value;
  }
  set isChecked(bool? value) {
    _isChecked = value;
  }
  set bankName(String? value) {
    _bankName = value;
  }
  set accountNo(String? value) {
    _accountNo = value;
  }
}