/// Date : "0001-01-01T00:00:00"
/// DistributorId : 0
/// TotalDtls : [{"DSRId":0,"cashTotal":5000.0,"bankTotal":0.00,"creditTotal":0.0,"unsettledTotal":0.00,"settledTotal":0.00}]
/// IncDtls : [{"DistributorId":0,"IncomeId":0,"TransCate":"Receipt","Quantity":0.0,"UnsettQty":0,"SettQty":0,"Mode":"","Amount":5000.00,"ItemName":"Staff - Abhi","ItemId":0,"Date":"0001-01-01T00:00:00"},{"DistributorId":0,"IncomeId":0,"TransCate":"Receipt","Quantity":0.0,"UnsettQty":0,"SettQty":0,"Mode":"Cash -","Amount":5000.00,"ItemName":"","ItemId":0,"Date":"0001-01-01T00:00:00"}]
/// expDtls : [{"DistributorId":0,"IncomeId":0,"TransCate":"Office Expense","Quantity":0.0,"ExpHeadId":0,"PHId":0,"Mode":"","ExpenseAmount":1000.00,"ExpenseItemName":"ARB Item Purchase Paymt","categoryName":"Office Expense","PHName":null,"Date":"0001-01-01T00:00:00"},{"DistributorId":0,"IncomeId":0,"TransCate":"Office Expense","Quantity":0.0,"ExpHeadId":0,"PHId":0,"Mode":"Cash -","ExpenseAmount":1000.00,"ExpenseItemName":"","categoryName":"Office Expense","PHName":null,"Date":"0001-01-01T00:00:00"}]
/// handoverDtls : [{"DSRId":0,"StaffId":0,"StaffName":"Lpg","CollAmt":5000.00,"PaidAmt":1000.00,"TotalAmt":4000.00,"CashStatus":0}]
/// CashDenomDtls : [{"DSRId":0,"NoteId":1,"NoteType":500.00,"Qty":8,"Amount":4000.00},{"DSRId":0,"NoteId":2,"NoteType":200.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":3,"NoteType":100.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":4,"NoteType":50.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":5,"NoteType":20.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":6,"NoteType":10.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":7,"NoteType":5.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":8,"NoteType":2.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":9,"NoteType":1.00,"Qty":0,"Amount":0.00},{"DSRId":0,"NoteId":10,"NoteType":0.50,"Qty":0,"Amount":0.00}]

class ManagerDsrReportSavedDataFetchModel {
  ManagerDsrReportSavedDataFetchModel({
      String? date, 
      num? distributorId, 
      List<TotalDtls>? totalDtls, 
      List<IncDtls>? incDtls, 
      List<ExpDtls>? expDtls, 
      List<HandoverDtls>? handoverDtls, 
      List<CashDenomDtls>? cashDenomDtls,}){
    _date = date;
    _distributorId = distributorId;
    _totalDtls = totalDtls;
    _incDtls = incDtls;
    _expDtls = expDtls;
    _handoverDtls = handoverDtls;
    _cashDenomDtls = cashDenomDtls;
}

  ManagerDsrReportSavedDataFetchModel.fromJson(dynamic json) {
    _date = json['Date'];
    _distributorId = json['DistributorId'];
    if (json['TotalDtls'] != null) {
      _totalDtls = [];
      json['TotalDtls'].forEach((v) {
        _totalDtls?.add(TotalDtls.fromJson(v));
      });
    }
    if (json['IncDtls'] != null) {
      _incDtls = [];
      json['IncDtls'].forEach((v) {
        _incDtls?.add(IncDtls.fromJson(v));
      });
    }
    if (json['expDtls'] != null) {
      _expDtls = [];
      json['expDtls'].forEach((v) {
        _expDtls?.add(ExpDtls.fromJson(v));
      });
    }
    if (json['handoverDtls'] != null) {
      _handoverDtls = [];
      json['handoverDtls'].forEach((v) {
        _handoverDtls?.add(HandoverDtls.fromJson(v));
      });
    }
    if (json['CashDenomDtls'] != null) {
      _cashDenomDtls = [];
      json['CashDenomDtls'].forEach((v) {
        _cashDenomDtls?.add(CashDenomDtls.fromJson(v));
      });
    }
  }
  String? _date;
  num? _distributorId;
  List<TotalDtls>? _totalDtls;
  List<IncDtls>? _incDtls;
  List<ExpDtls>? _expDtls;
  List<HandoverDtls>? _handoverDtls;
  List<CashDenomDtls>? _cashDenomDtls;
ManagerDsrReportSavedDataFetchModel copyWith({  String? date,
  num? distributorId,
  List<TotalDtls>? totalDtls,
  List<IncDtls>? incDtls,
  List<ExpDtls>? expDtls,
  List<HandoverDtls>? handoverDtls,
  List<CashDenomDtls>? cashDenomDtls,
}) => ManagerDsrReportSavedDataFetchModel(  date: date ?? _date,
  distributorId: distributorId ?? _distributorId,
  totalDtls: totalDtls ?? _totalDtls,
  incDtls: incDtls ?? _incDtls,
  expDtls: expDtls ?? _expDtls,
  handoverDtls: handoverDtls ?? _handoverDtls,
  cashDenomDtls: cashDenomDtls ?? _cashDenomDtls,
);
  String? get date => _date;
  num? get distributorId => _distributorId;
  List<TotalDtls>? get totalDtls => _totalDtls;
  List<IncDtls>? get incDtls => _incDtls;
  List<ExpDtls>? get expDtls => _expDtls;
  List<HandoverDtls>? get handoverDtls => _handoverDtls;
  List<CashDenomDtls>? get cashDenomDtls => _cashDenomDtls;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Date'] = _date;
    map['DistributorId'] = _distributorId;
    if (_totalDtls != null) {
      map['TotalDtls'] = _totalDtls?.map((v) => v.toJson()).toList();
    }
    if (_incDtls != null) {
      map['IncDtls'] = _incDtls?.map((v) => v.toJson()).toList();
    }
    if (_expDtls != null) {
      map['expDtls'] = _expDtls?.map((v) => v.toJson()).toList();
    }
    if (_handoverDtls != null) {
      map['handoverDtls'] = _handoverDtls?.map((v) => v.toJson()).toList();
    }
    if (_cashDenomDtls != null) {
      map['CashDenomDtls'] = _cashDenomDtls?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// DSRId : 0
/// NoteId : 1
/// NoteType : 500.00
/// Qty : 8
/// Amount : 4000.00

class CashDenomDtls {
  CashDenomDtls({
      num? dSRId, 
      num? noteId, 
      num? noteType, 
      num? qty, 
      num? amount,}){
    _dSRId = dSRId;
    _noteId = noteId;
    _noteType = noteType;
    _qty = qty;
    _amount = amount;
}

  CashDenomDtls.fromJson(dynamic json) {
    _dSRId = json['DSRId'];
    _noteId = json['NoteId'];
    _noteType = json['NoteType'];
    _qty = json['Qty'];
    _amount = json['Amount'];
  }
  num? _dSRId;
  num? _noteId;
  num? _noteType;
  num? _qty;
  num? _amount;
CashDenomDtls copyWith({  num? dSRId,
  num? noteId,
  num? noteType,
  num? qty,
  num? amount,
}) => CashDenomDtls(  dSRId: dSRId ?? _dSRId,
  noteId: noteId ?? _noteId,
  noteType: noteType ?? _noteType,
  qty: qty ?? _qty,
  amount: amount ?? _amount,
);
  num? get dSRId => _dSRId;
  num? get noteId => _noteId;
  num? get noteType => _noteType;
  num? get qty => _qty;
  num? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DSRId'] = _dSRId;
    map['NoteId'] = _noteId;
    map['NoteType'] = _noteType;
    map['Qty'] = _qty;
    map['Amount'] = _amount;
    return map;
  }

}

/// DSRId : 0
/// StaffId : 0
/// StaffName : "Lpg"
/// CollAmt : 5000.00
/// PaidAmt : 1000.00
/// TotalAmt : 4000.00
/// CashStatus : 0

class HandoverDtls {
  HandoverDtls({
      num? dSRId, 
      num? staffId, 
      String? staffName, 
      num? collAmt, 
      num? paidAmt, 
      num? totalAmt, 
      num? cashStatus,}){
    _dSRId = dSRId;
    _staffId = staffId;
    _staffName = staffName;
    _collAmt = collAmt;
    _paidAmt = paidAmt;
    _totalAmt = totalAmt;
    _cashStatus = cashStatus;
}

  HandoverDtls.fromJson(dynamic json) {
    _dSRId = json['DSRId'];
    _staffId = json['StaffId'];
    _staffName = json['StaffName'];
    _collAmt = json['CollAmt'];
    _paidAmt = json['PaidAmt'];
    _totalAmt = json['TotalAmt'];
    _cashStatus = json['CashStatus'];
  }
  num? _dSRId;
  num? _staffId;
  String? _staffName;
  num? _collAmt;
  num? _paidAmt;
  num? _totalAmt;
  num? _cashStatus;
HandoverDtls copyWith({  num? dSRId,
  num? staffId,
  String? staffName,
  num? collAmt,
  num? paidAmt,
  num? totalAmt,
  num? cashStatus,
}) => HandoverDtls(  dSRId: dSRId ?? _dSRId,
  staffId: staffId ?? _staffId,
  staffName: staffName ?? _staffName,
  collAmt: collAmt ?? _collAmt,
  paidAmt: paidAmt ?? _paidAmt,
  totalAmt: totalAmt ?? _totalAmt,
  cashStatus: cashStatus ?? _cashStatus,
);
  num? get dSRId => _dSRId;
  num? get staffId => _staffId;
  String? get staffName => _staffName;
  num? get collAmt => _collAmt;
  num? get paidAmt => _paidAmt;
  num? get totalAmt => _totalAmt;
  num? get cashStatus => _cashStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DSRId'] = _dSRId;
    map['StaffId'] = _staffId;
    map['StaffName'] = _staffName;
    map['CollAmt'] = _collAmt;
    map['PaidAmt'] = _paidAmt;
    map['TotalAmt'] = _totalAmt;
    map['CashStatus'] = _cashStatus;
    return map;
  }

}

/// DistributorId : 0
/// IncomeId : 0
/// TransCate : "Office Expense"
/// Quantity : 0.0
/// ExpHeadId : 0
/// PHId : 0
/// Mode : ""
/// ExpenseAmount : 1000.00
/// ExpenseItemName : "ARB Item Purchase Paymt"
/// categoryName : "Office Expense"
/// PHName : null
/// Date : "0001-01-01T00:00:00"

class ExpDtls {
  ExpDtls({
      num? distributorId, 
      num? incomeId, 
      String? transCate, 
      num? quantity, 
      num? expHeadId, 
      num? pHId, 
      String? mode, 
      num? expenseAmount, 
      String? expenseItemName, 
      String? categoryName, 
      dynamic pHName, 
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

  ExpDtls.fromJson(dynamic json) {
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
  String? _categoryName;
  dynamic _pHName;
  String? _date;
ExpDtls copyWith({  num? distributorId,
  num? incomeId,
  String? transCate,
  num? quantity,
  num? expHeadId,
  num? pHId,
  String? mode,
  num? expenseAmount,
  String? expenseItemName,
  String? categoryName,
  dynamic pHName,
  String? date,
}) => ExpDtls(  distributorId: distributorId ?? _distributorId,
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
  String? get categoryName => _categoryName;
  dynamic get pHName => _pHName;
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

/// DistributorId : 0
/// IncomeId : 0
/// TransCate : "Receipt"
/// Quantity : 0.0
/// UnsettQty : 0
/// SettQty : 0
/// Mode : ""
/// Amount : 5000.00
/// ItemName : "Staff - Abhi"
/// ItemId : 0
/// Date : "0001-01-01T00:00:00"

class IncDtls {
  IncDtls({
      num? distributorId, 
      num? incomeId, 
      String? transCate, 
      num? quantity, 
      num? unsettQty, 
      num? settQty, 
      String? mode, 
      num? amount, 
      String? itemName, 
      num? itemId, 
      String? date,}){
    _distributorId = distributorId;
    _incomeId = incomeId;
    _transCate = transCate;
    _quantity = quantity;
    _unsettQty = unsettQty;
    _settQty = settQty;
    _mode = mode;
    _amount = amount;
    _itemName = itemName;
    _itemId = itemId;
    _date = date;
}

  IncDtls.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _incomeId = json['IncomeId'];
    _transCate = json['TransCate'];
    _quantity = json['Quantity'];
    _unsettQty = json['UnsettQty'];
    _settQty = json['SettQty'];
    _mode = json['Mode'];
    _amount = json['Amount'];
    _itemName = json['ItemName'];
    _itemId = json['ItemId'];
    _date = json['Date'];
  }
  num? _distributorId;
  num? _incomeId;
  String? _transCate;
  num? _quantity;
  num? _unsettQty;
  num? _settQty;
  String? _mode;
  num? _amount;
  String? _itemName;
  num? _itemId;
  String? _date;
IncDtls copyWith({  num? distributorId,
  num? incomeId,
  String? transCate,
  num? quantity,
  num? unsettQty,
  num? settQty,
  String? mode,
  num? amount,
  String? itemName,
  num? itemId,
  String? date,
}) => IncDtls(  distributorId: distributorId ?? _distributorId,
  incomeId: incomeId ?? _incomeId,
  transCate: transCate ?? _transCate,
  quantity: quantity ?? _quantity,
  unsettQty: unsettQty ?? _unsettQty,
  settQty: settQty ?? _settQty,
  mode: mode ?? _mode,
  amount: amount ?? _amount,
  itemName: itemName ?? _itemName,
  itemId: itemId ?? _itemId,
  date: date ?? _date,
);
  num? get distributorId => _distributorId;
  num? get incomeId => _incomeId;
  String? get transCate => _transCate;
  num? get quantity => _quantity;
  num? get unsettQty => _unsettQty;
  num? get settQty => _settQty;
  String? get mode => _mode;
  num? get amount => _amount;
  String? get itemName => _itemName;
  num? get itemId => _itemId;
  String? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['IncomeId'] = _incomeId;
    map['TransCate'] = _transCate;
    map['Quantity'] = _quantity;
    map['UnsettQty'] = _unsettQty;
    map['SettQty'] = _settQty;
    map['Mode'] = _mode;
    map['Amount'] = _amount;
    map['ItemName'] = _itemName;
    map['ItemId'] = _itemId;
    map['Date'] = _date;
    return map;
  }

}

/// DSRId : 0
/// cashTotal : 5000.0
/// bankTotal : 0.00
/// creditTotal : 0.0
/// unsettledTotal : 0.00
/// settledTotal : 0.00

class TotalDtls {
  TotalDtls({
      num? dSRId, 
      num? cashTotal, 
      num? bankTotal, 
      num? creditTotal, 
      num? unsettledTotal, 
      num? settledTotal,}){
    _dSRId = dSRId;
    _cashTotal = cashTotal;
    _bankTotal = bankTotal;
    _creditTotal = creditTotal;
    _unsettledTotal = unsettledTotal;
    _settledTotal = settledTotal;
}

  TotalDtls.fromJson(dynamic json) {
    _dSRId = json['DSRId'];
    _cashTotal = json['cashTotal'];
    _bankTotal = json['bankTotal'];
    _creditTotal = json['creditTotal'];
    _unsettledTotal = json['unsettledTotal'];
    _settledTotal = json['settledTotal'];
  }
  num? _dSRId;
  num? _cashTotal;
  num? _bankTotal;
  num? _creditTotal;
  num? _unsettledTotal;
  num? _settledTotal;
TotalDtls copyWith({  num? dSRId,
  num? cashTotal,
  num? bankTotal,
  num? creditTotal,
  num? unsettledTotal,
  num? settledTotal,
}) => TotalDtls(  dSRId: dSRId ?? _dSRId,
  cashTotal: cashTotal ?? _cashTotal,
  bankTotal: bankTotal ?? _bankTotal,
  creditTotal: creditTotal ?? _creditTotal,
  unsettledTotal: unsettledTotal ?? _unsettledTotal,
  settledTotal: settledTotal ?? _settledTotal,
);
  num? get dSRId => _dSRId;
  num? get cashTotal => _cashTotal;
  num? get bankTotal => _bankTotal;
  num? get creditTotal => _creditTotal;
  num? get unsettledTotal => _unsettledTotal;
  num? get settledTotal => _settledTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DSRId'] = _dSRId;
    map['cashTotal'] = _cashTotal;
    map['bankTotal'] = _bankTotal;
    map['creditTotal'] = _creditTotal;
    map['unsettledTotal'] = _unsettledTotal;
    map['settledTotal'] = _settledTotal;
    return map;
  }

}