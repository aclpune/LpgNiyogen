/// DistributorId : 0
/// IncomeId : 0
/// TransCate : "Other Expense"
/// Quantity : 0.0
/// ExpHeadId : 6
/// PHId : 5
/// Mode : ""
/// ExpenseAmount : 1000.00
/// ExpenseItemName : "Miscellaneous"
/// categoryName : null
/// PHName : "Other Expense"
/// Date : "0001-01-01T00:00:00"

class ManagerDsrReportExpenseDetailListModel {
  ManagerDsrReportExpenseDetailListModel({
      num? distributorId, 
      num? incomeId, 
      String? transCate, 
      num? quantity, 
      num? expHeadId, 
      num? pHId, 
      String? mode, 
      num? expenseAmount, 
      String? expenseItemName, 
      dynamic categoryName, 
      String? pHName, 
      String? date,}){
    _distributorId = distributorId;
    _incomeId = incomeId;
    _transCate = transCate;
    _quantity = quantity;
    _expHeadId = expHeadId;
    _pHId = pHId;
    _mode = mode;
    _expenseAmount = expenseAmount;
    _expenseItemName = expenseItemName;
    _categoryName = categoryName;
    _pHName = pHName;
    _date = date;
}

  ManagerDsrReportExpenseDetailListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _incomeId = json['IncomeId'];
    _transCate = json['TransCate'];
    _quantity = json['Quantity'];
    _expHeadId = json['ExpHeadId'];
    _pHId = json['PHId'];
    _mode = json['Mode'];
    _expenseAmount = json['ExpenseAmount'];
    _expenseItemName = json['ExpenseItemName'];
    _categoryName = json['categoryName'];
    _pHName = json['PHName'];
    _date = json['Date'];
  }
  num? _distributorId;
  num? _incomeId;
  String? _transCate;
  num? _quantity;
  num? _expHeadId;
  num? _pHId;
  String? _mode;
  num? _expenseAmount;
  String? _expenseItemName;
  dynamic _categoryName;
  String? _pHName;
  String? _date;
ManagerDsrReportExpenseDetailListModel copyWith({  num? distributorId,
  num? incomeId,
  String? transCate,
  num? quantity,
  num? expHeadId,
  num? pHId,
  String? mode,
  num? expenseAmount,
  String? expenseItemName,
  dynamic categoryName,
  String? pHName,
  String? date,
}) => ManagerDsrReportExpenseDetailListModel(  distributorId: distributorId ?? _distributorId,
  incomeId: incomeId ?? _incomeId,
  transCate: transCate ?? _transCate,
  quantity: quantity ?? _quantity,
  expHeadId: expHeadId ?? _expHeadId,
  pHId: pHId ?? _pHId,
  mode: mode ?? _mode,
  expenseAmount: expenseAmount ?? _expenseAmount,
  expenseItemName: expenseItemName ?? _expenseItemName,
  categoryName: categoryName ?? _categoryName,
  pHName: pHName ?? _pHName,
  date: date ?? _date,
);
  num? get distributorId => _distributorId;
  num? get incomeId => _incomeId;
  String? get transCate => _transCate;
  num? get quantity => _quantity;
  num? get expHeadId => _expHeadId;
  num? get pHId => _pHId;
  String? get mode => _mode;
  num? get expenseAmount => _expenseAmount;
  String? get expenseItemName => _expenseItemName;
  dynamic get categoryName => _categoryName;
  String? get pHName => _pHName;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['IncomeId'] = _incomeId;
    map['TransCate'] = _transCate;
    map['Quantity'] = _quantity;
    map['ExpHeadId'] = _expHeadId;
    map['PHId'] = _pHId;
    map['Mode'] = _mode;
    map['ExpenseAmount'] = _expenseAmount;
    map['ExpenseItemName'] = _expenseItemName;
    map['categoryName'] = _categoryName;
    map['PHName'] = _pHName;
    map['Date'] = _date;
    return map;
  }

}