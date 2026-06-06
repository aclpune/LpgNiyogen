/// DistributorId : 8118
/// Date : null
/// expensehead : "TV Refund"
/// Cash : 0.00
/// Bank : 100.00
/// StaffId : 44
/// StaffName : "19kg Devendra"
/// ExpHeadId : 0
/// ExpenseAmount : 0.0
/// Flag : null
/// Qty : 1

class GetexpensepopupListModel {
  GetexpensepopupListModel({
      num? distributorId, 
      dynamic date, 
      String? expensehead, 
      num? cash, 
      num? bank, 
      num? staffId, 
      String? staffName, 
      num? expHeadId, 
      num? expenseAmount, 
      dynamic flag, 
      num? qty,}){
    _distributorId = distributorId;
    _date = date;
    _expensehead = expensehead;
    _cash = cash;
    _bank = bank;
    _staffId = staffId;
    _staffName = staffName;
    _expHeadId = expHeadId;
    _expenseAmount = expenseAmount;
    _flag = flag;
    _qty = qty;
}

  GetexpensepopupListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _date = json['Date'];
    _expensehead = json['expensehead'];
    _cash = json['Cash'];
    _bank = json['Bank'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _expHeadId = json['ExpHeadId'];
    _expenseAmount = json['ExpenseAmount'];
    _flag = json['Flag'];
    _qty = json['Qty'];
  }
  num? _distributorId;
  dynamic _date;
  String? _expensehead;
  num? _cash;
  num? _bank;
  num? _staffId;
  String? _staffName;
  num? _expHeadId;
  num? _expenseAmount;
  dynamic _flag;
  num? _qty;
GetexpensepopupListModel copyWith({  num? distributorId,
  dynamic date,
  String? expensehead,
  num? cash,
  num? bank,
  num? staffId,
  String? staffName,
  num? expHeadId,
  num? expenseAmount,
  dynamic flag,
  num? qty,
}) => GetexpensepopupListModel(  distributorId: distributorId ?? _distributorId,
  date: date ?? _date,
  expensehead: expensehead ?? _expensehead,
  cash: cash ?? _cash,
  bank: bank ?? _bank,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  expHeadId: expHeadId ?? _expHeadId,
  expenseAmount: expenseAmount ?? _expenseAmount,
  flag: flag ?? _flag,
  qty: qty ?? _qty,
);
  num? get distributorId => _distributorId;
  dynamic get date => _date;
  String? get expensehead => _expensehead;
  num? get cash => _cash;
  num? get bank => _bank;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get expHeadId => _expHeadId;
  num? get expenseAmount => _expenseAmount;
  dynamic get flag => _flag;
  num? get qty => _qty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['Date'] = _date;
    map['expensehead'] = _expensehead;
    map['Cash'] = _cash;
    map['Bank'] = _bank;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['ExpHeadId'] = _expHeadId;
    map['ExpenseAmount'] = _expenseAmount;
    map['Flag'] = _flag;
    map['Qty'] = _qty;
    return map;
  }

}