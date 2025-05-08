/// DSCollMgrId : 0
/// SaleGKId : 0
/// SaleGKItemId : 0
/// DistributorId : 0
/// CashDenomDtls : [{"Id":1,"NoteType":500.00,"Quantity":16,"TotalAmt":8000.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":2,"NoteType":200.00,"Quantity":5,"TotalAmt":1000.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":3,"NoteType":100.00,"Quantity":6,"TotalAmt":600.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":4,"NoteType":50.00,"Quantity":10,"TotalAmt":500.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":5,"NoteType":20.00,"Quantity":0,"TotalAmt":0.00,"RetNoteQty":5,"RetNoteAmt":100.00},{"Id":6,"NoteType":10.00,"Quantity":0,"TotalAmt":0.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":7,"NoteType":5.00,"Quantity":0,"TotalAmt":0.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":8,"NoteType":2.00,"Quantity":0,"TotalAmt":0.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":9,"NoteType":1.00,"Quantity":0,"TotalAmt":0.00,"RetNoteQty":0,"RetNoteAmt":0.00},{"Id":10,"NoteType":0.50,"Quantity":0,"TotalAmt":0.00,"RetNoteQty":0,"RetNoteAmt":0.00}]
/// consumerDtls : [{"ConsId":0,"DistributorId":0,"StaffId":0,"ItemId":0,"ConsumerNo":"665535","OrderNo":"","OrderRefNo":1250811800057098.0,"OrderDate":null,"CashDate":null,"ConsumerName":"Mr. Kishor Prakash Ghole","PaymentStatus":"Credited","ConsumerRemark":"Punched In cDCMS","PayDate":"2025/04/05 12:07:41","DeliveryDate":"2025/04/05 01:18:36","SettDate":"2025/04/09 12:00:00","NiyojanDel":1,"cDCMSDel":1,"InCorrectStatus":1,"AddedOn":"0001-01-01T00:00:00","Action":null,"AddedBy":0}]
/// PostpaidDtls : [{"TransId":0,"DistributorId":0,"StaffId":0,"ItemId":0,"TransactionCode":"td45677","TransTime":"","Remark":"","AddedOn":"0001-01-01T00:00:00","Action":null,"AddedBy":0}]
/// ReticulatedDtls : [{"RetId":0,"DistributorId":0,"StaffId":0,"ItemId":0,"PaymentMode":"Credit","Quantity":1,"Amount":855.50,"DiscountAmt":0.00,"CustomerId":58,"CustomerName":"Vasantam","ReticulatedRemark":"","AddedOn":"0001-01-01T00:00:00","Action":null,"AddedBy":0}]

class GetUpdateSaleDataForEditModel {
  GetUpdateSaleDataForEditModel({
      num? dSCollMgrId, 
      num? saleGKId, 
      num? saleGKItemId, 
      num? distributorId, 
      List<CashDenomDtls>? cashDenomDtls, 
      List<ConsumerDtls>? consumerDtls, 
      List<PostpaidDtls>? postpaidDtls, 
      List<ReticulatedDtls>? reticulatedDtls,}){
    _dSCollMgrId = dSCollMgrId;
    _saleGKId = saleGKId;
    _saleGKItemId = saleGKItemId;
    _distributorId = distributorId;
    _cashDenomDtls = cashDenomDtls;
    _consumerDtls = consumerDtls;
    _postpaidDtls = postpaidDtls;
    _reticulatedDtls = reticulatedDtls;
}

  GetUpdateSaleDataForEditModel.fromJson(dynamic json) {
    _dSCollMgrId = json['DSCollMgrId'];
    _saleGKId = json['SaleGKId'];
    _saleGKItemId = json['SaleGKItemId'];
    _distributorId = json['DistributorId'];
    if (json['CashDenomDtls'] != null) {
      _cashDenomDtls = [];
      json['CashDenomDtls'].forEach((v) {
        _cashDenomDtls?.add(CashDenomDtls.fromJson(v));
      });
    }
    if (json['consumerDtls'] != null) {
      _consumerDtls = [];
      json['consumerDtls'].forEach((v) {
        _consumerDtls?.add(ConsumerDtls.fromJson(v));
      });
    }
    if (json['PostpaidDtls'] != null) {
      _postpaidDtls = [];
      json['PostpaidDtls'].forEach((v) {
        _postpaidDtls?.add(PostpaidDtls.fromJson(v));
      });
    }
    if (json['ReticulatedDtls'] != null) {
      _reticulatedDtls = [];
      json['ReticulatedDtls'].forEach((v) {
        _reticulatedDtls?.add(ReticulatedDtls.fromJson(v));
      });
    }
  }
  num? _dSCollMgrId;
  num? _saleGKId;
  num? _saleGKItemId;
  num? _distributorId;
  List<CashDenomDtls>? _cashDenomDtls;
  List<ConsumerDtls>? _consumerDtls;
  List<PostpaidDtls>? _postpaidDtls;
  List<ReticulatedDtls>? _reticulatedDtls;
GetUpdateSaleDataForEditModel copyWith({  num? dSCollMgrId,
  num? saleGKId,
  num? saleGKItemId,
  num? distributorId,
  List<CashDenomDtls>? cashDenomDtls,
  List<ConsumerDtls>? consumerDtls,
  List<PostpaidDtls>? postpaidDtls,
  List<ReticulatedDtls>? reticulatedDtls,
}) => GetUpdateSaleDataForEditModel(  dSCollMgrId: dSCollMgrId ?? _dSCollMgrId,
  saleGKId: saleGKId ?? _saleGKId,
  saleGKItemId: saleGKItemId ?? _saleGKItemId,
  distributorId: distributorId ?? _distributorId,
  cashDenomDtls: cashDenomDtls ?? _cashDenomDtls,
  consumerDtls: consumerDtls ?? _consumerDtls,
  postpaidDtls: postpaidDtls ?? _postpaidDtls,
  reticulatedDtls: reticulatedDtls ?? _reticulatedDtls,
);
  num? get dSCollMgrId => _dSCollMgrId;
  num? get saleGKId => _saleGKId;
  num? get saleGKItemId => _saleGKItemId;
  num? get distributorId => _distributorId;
  List<CashDenomDtls>? get cashDenomDtls => _cashDenomDtls;
  List<ConsumerDtls>? get consumerDtls => _consumerDtls;
  List<PostpaidDtls>? get postpaidDtls => _postpaidDtls;
  List<ReticulatedDtls>? get reticulatedDtls => _reticulatedDtls;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DSCollMgrId'] = _dSCollMgrId;
    map['SaleGKId'] = _saleGKId;
    map['SaleGKItemId'] = _saleGKItemId;
    map['DistributorId'] = _distributorId;
    if (_cashDenomDtls != null) {
      map['CashDenomDtls'] = _cashDenomDtls?.map((v) => v.toJson()).toList();
    }
    if (_consumerDtls != null) {
      map['consumerDtls'] = _consumerDtls?.map((v) => v.toJson()).toList();
    }
    if (_postpaidDtls != null) {
      map['PostpaidDtls'] = _postpaidDtls?.map((v) => v.toJson()).toList();
    }
    if (_reticulatedDtls != null) {
      map['ReticulatedDtls'] = _reticulatedDtls?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// RetId : 0
/// DistributorId : 0
/// StaffId : 0
/// ItemId : 0
/// PaymentMode : "Credit"
/// Quantity : 1
/// Amount : 855.50
/// DiscountAmt : 0.00
/// CustomerId : 58
/// CustomerName : "Vasantam"
/// ReticulatedRemark : ""
/// AddedOn : "0001-01-01T00:00:00"
/// Action : null
/// AddedBy : 0

class ReticulatedDtls {
  ReticulatedDtls({
      num? retId, 
      num? distributorId, 
      num? staffId, 
      num? itemId, 
      String? paymentMode, 
      num? quantity, 
      num? amount, 
      num? discountAmt, 
      num? customerId, 
      String? customerName, 
      String? reticulatedRemark, 
      String? addedOn, 
      dynamic action, 
      num? addedBy,}){
    _retId = retId;
    _distributorId = distributorId;
    _staffId = staffId;
    _itemId = itemId;
    _paymentMode = paymentMode;
    _quantity = quantity;
    _amount = amount;
    _discountAmt = discountAmt;
    _customerId = customerId;
    _customerName = customerName;
    _reticulatedRemark = reticulatedRemark;
    _addedOn = addedOn;
    _action = action;
    _addedBy = addedBy;
}

  ReticulatedDtls.fromJson(dynamic json) {
    _retId = json['RetId'];
    _distributorId = json['DistributorId'];
    _staffId = json['StaffId'];
    _itemId = json['ItemId'];
    _paymentMode = json['PaymentMode'];
    _quantity = json['Quantity'];
    _amount = json['Amount'];
    _discountAmt = json['DiscountAmt'];
    _customerId = json['CustomerId'];
    _customerName = json['CustomerName'];
    _reticulatedRemark = json['ReticulatedRemark'];
    _addedOn = json['AddedOn'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
  }
  num? _retId;
  num? _distributorId;
  num? _staffId;
  num? _itemId;
  String? _paymentMode;
  num? _quantity;
  num? _amount;
  num? _discountAmt;
  num? _customerId;
  String? _customerName;
  String? _reticulatedRemark;
  String? _addedOn;
  dynamic _action;
  num? _addedBy;
ReticulatedDtls copyWith({  num? retId,
  num? distributorId,
  num? staffId,
  num? itemId,
  String? paymentMode,
  num? quantity,
  num? amount,
  num? discountAmt,
  num? customerId,
  String? customerName,
  String? reticulatedRemark,
  String? addedOn,
  dynamic action,
  num? addedBy,
}) => ReticulatedDtls(  retId: retId ?? _retId,
  distributorId: distributorId ?? _distributorId,
  staffId: staffId ?? _staffId,
  itemId: itemId ?? _itemId,
  paymentMode: paymentMode ?? _paymentMode,
  quantity: quantity ?? _quantity,
  amount: amount ?? _amount,
  discountAmt: discountAmt ?? _discountAmt,
  customerId: customerId ?? _customerId,
  customerName: customerName ?? _customerName,
  reticulatedRemark: reticulatedRemark ?? _reticulatedRemark,
  addedOn: addedOn ?? _addedOn,
  action: action ?? _action,
  addedBy: addedBy ?? _addedBy,
);
  num? get retId => _retId;
  num? get distributorId => _distributorId;
  num? get staffId => _staffId;
  num? get itemId => _itemId;
  String? get paymentMode => _paymentMode;
  num? get quantity => _quantity;
  num? get amount => _amount;
  num? get discountAmt => _discountAmt;
  num? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get reticulatedRemark => _reticulatedRemark;
  String? get addedOn => _addedOn;
  dynamic get action => _action;
  num? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['RetId'] = _retId;
    map['DistributorId'] = _distributorId;
    map['StaffId'] = _staffId;
    map['ItemId'] = _itemId;
    map['PaymentMode'] = _paymentMode;
    map['Quantity'] = _quantity;
    map['Amount'] = _amount;
    map['DiscountAmt'] = _discountAmt;
    map['CustomerId'] = _customerId;
    map['CustomerName'] = _customerName;
    map['ReticulatedRemark'] = _reticulatedRemark;
    map['AddedOn'] = _addedOn;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    return map;
  }

}

/// TransId : 0
/// DistributorId : 0
/// StaffId : 0
/// ItemId : 0
/// TransactionCode : "td45677"
/// TransTime : ""
/// Remark : ""
/// AddedOn : "0001-01-01T00:00:00"
/// Action : null
/// AddedBy : 0

class PostpaidDtls {
  PostpaidDtls({
      num? transId, 
      num? distributorId, 
      num? staffId, 
      num? itemId, 
      String? transactionCode, 
      String? transTime, 
      String? remark, 
      String? addedOn, 
      dynamic action, 
      num? addedBy,}){
    _transId = transId;
    _distributorId = distributorId;
    _staffId = staffId;
    _itemId = itemId;
    _transactionCode = transactionCode;
    _transTime = transTime;
    _remark = remark;
    _addedOn = addedOn;
    _action = action;
    _addedBy = addedBy;
}

  PostpaidDtls.fromJson(dynamic json) {
    _transId = json['TransId'];
    _distributorId = json['DistributorId'];
    _staffId = json['StaffId'];
    _itemId = json['ItemId'];
    _transactionCode = json['TransactionCode'];
    _transTime = json['TransTime'];
    _remark = json['Remark'];
    _addedOn = json['AddedOn'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
  }
  num? _transId;
  num? _distributorId;
  num? _staffId;
  num? _itemId;
  String? _transactionCode;
  String? _transTime;
  String? _remark;
  String? _addedOn;
  dynamic _action;
  num? _addedBy;
PostpaidDtls copyWith({  num? transId,
  num? distributorId,
  num? staffId,
  num? itemId,
  String? transactionCode,
  String? transTime,
  String? remark,
  String? addedOn,
  dynamic action,
  num? addedBy,
}) => PostpaidDtls(  transId: transId ?? _transId,
  distributorId: distributorId ?? _distributorId,
  staffId: staffId ?? _staffId,
  itemId: itemId ?? _itemId,
  transactionCode: transactionCode ?? _transactionCode,
  transTime: transTime ?? _transTime,
  remark: remark ?? _remark,
  addedOn: addedOn ?? _addedOn,
  action: action ?? _action,
  addedBy: addedBy ?? _addedBy,
);
  num? get transId => _transId;
  num? get distributorId => _distributorId;
  num? get staffId => _staffId;
  num? get itemId => _itemId;
  String? get transactionCode => _transactionCode;
  String? get transTime => _transTime;
  String? get remark => _remark;
  String? get addedOn => _addedOn;
  dynamic get action => _action;
  num? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TransId'] = _transId;
    map['DistributorId'] = _distributorId;
    map['StaffId'] = _staffId;
    map['ItemId'] = _itemId;
    map['TransactionCode'] = _transactionCode;
    map['TransTime'] = _transTime;
    map['Remark'] = _remark;
    map['AddedOn'] = _addedOn;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    return map;
  }

}

/// ConsId : 0
/// DistributorId : 0
/// StaffId : 0
/// ItemId : 0
/// ConsumerNo : "665535"
/// OrderNo : ""
/// OrderRefNo : 1250811800057098.0
/// OrderDate : null
/// CashDate : null
/// ConsumerName : "Mr. Kishor Prakash Ghole"
/// PaymentStatus : "Credited"
/// ConsumerRemark : "Punched In cDCMS"
/// PayDate : "2025/04/05 12:07:41"
/// DeliveryDate : "2025/04/05 01:18:36"
/// SettDate : "2025/04/09 12:00:00"
/// NiyojanDel : 1
/// cDCMSDel : 1
/// InCorrectStatus : 1
/// AddedOn : "0001-01-01T00:00:00"
/// Action : null
/// AddedBy : 0

class ConsumerDtls {
  ConsumerDtls({
      num? consId, 
      num? distributorId, 
      num? staffId, 
      num? itemId, 
      String? consumerNo, 
      String? orderNo, 
      num? orderRefNo, 
      dynamic orderDate, 
      dynamic cashDate, 
      String? consumerName, 
      String? paymentStatus, 
      String? consumerRemark, 
      String? payDate, 
      String? deliveryDate, 
      String? settDate, 
      num? niyojanDel, 
      num? cDCMSDel, 
      num? inCorrectStatus, 
      String? addedOn, 
      dynamic action, 
      num? addedBy,}){
    _consId = consId;
    _distributorId = distributorId;
    _staffId = staffId;
    _itemId = itemId;
    _consumerNo = consumerNo;
    _orderNo = orderNo;
    _orderRefNo = orderRefNo;
    _orderDate = orderDate;
    _cashDate = cashDate;
    _consumerName = consumerName;
    _paymentStatus = paymentStatus;
    _consumerRemark = consumerRemark;
    _payDate = payDate;
    _deliveryDate = deliveryDate;
    _settDate = settDate;
    _niyojanDel = niyojanDel;
    _cDCMSDel = cDCMSDel;
    _inCorrectStatus = inCorrectStatus;
    _addedOn = addedOn;
    _action = action;
    _addedBy = addedBy;
}

  ConsumerDtls.fromJson(dynamic json) {
    _consId = json['ConsId'];
    _distributorId = json['DistributorId'];
    _staffId = json['StaffId'];
    _itemId = json['ItemId'];
    _consumerNo = json['ConsumerNo'];
    _orderNo = json['OrderNo'];
    _orderRefNo = json['OrderRefNo'];
    _orderDate = json['OrderDate'];
    _cashDate = json['CashDate'];
    _consumerName = json['ConsumerName'];
    _paymentStatus = json['PaymentStatus'];
    _consumerRemark = json['ConsumerRemark'];
    _payDate = json['PayDate'];
    _deliveryDate = json['DeliveryDate'];
    _settDate = json['SettDate'];
    _niyojanDel = json['NiyojanDel'];
    _cDCMSDel = json['cDCMSDel'];
    _inCorrectStatus = json['InCorrectStatus'];
    _addedOn = json['AddedOn'];
    _action = json['Action'];
    _addedBy = json['AddedBy'];
  }
  num? _consId;
  num? _distributorId;
  num? _staffId;
  num? _itemId;
  String? _consumerNo;
  String? _orderNo;
  num? _orderRefNo;
  dynamic _orderDate;
  dynamic _cashDate;
  String? _consumerName;
  String? _paymentStatus;
  String? _consumerRemark;
  String? _payDate;
  String? _deliveryDate;
  String? _settDate;
  num? _niyojanDel;
  num? _cDCMSDel;
  num? _inCorrectStatus;
  String? _addedOn;
  dynamic _action;
  num? _addedBy;
ConsumerDtls copyWith({  num? consId,
  num? distributorId,
  num? staffId,
  num? itemId,
  String? consumerNo,
  String? orderNo,
  num? orderRefNo,
  dynamic orderDate,
  dynamic cashDate,
  String? consumerName,
  String? paymentStatus,
  String? consumerRemark,
  String? payDate,
  String? deliveryDate,
  String? settDate,
  num? niyojanDel,
  num? cDCMSDel,
  num? inCorrectStatus,
  String? addedOn,
  dynamic action,
  num? addedBy,
}) => ConsumerDtls(  consId: consId ?? _consId,
  distributorId: distributorId ?? _distributorId,
  staffId: staffId ?? _staffId,
  itemId: itemId ?? _itemId,
  consumerNo: consumerNo ?? _consumerNo,
  orderNo: orderNo ?? _orderNo,
  orderRefNo: orderRefNo ?? _orderRefNo,
  orderDate: orderDate ?? _orderDate,
  cashDate: cashDate ?? _cashDate,
  consumerName: consumerName ?? _consumerName,
  paymentStatus: paymentStatus ?? _paymentStatus,
  consumerRemark: consumerRemark ?? _consumerRemark,
  payDate: payDate ?? _payDate,
  deliveryDate: deliveryDate ?? _deliveryDate,
  settDate: settDate ?? _settDate,
  niyojanDel: niyojanDel ?? _niyojanDel,
  cDCMSDel: cDCMSDel ?? _cDCMSDel,
  inCorrectStatus: inCorrectStatus ?? _inCorrectStatus,
  addedOn: addedOn ?? _addedOn,
  action: action ?? _action,
  addedBy: addedBy ?? _addedBy,
);
  num? get consId => _consId;
  num? get distributorId => _distributorId;
  num? get staffId => _staffId;
  num? get itemId => _itemId;
  String? get consumerNo => _consumerNo;
  String? get orderNo => _orderNo;
  num? get orderRefNo => _orderRefNo;
  dynamic get orderDate => _orderDate;
  dynamic get cashDate => _cashDate;
  String? get consumerName => _consumerName;
  String? get paymentStatus => _paymentStatus;
  String? get consumerRemark => _consumerRemark;
  String? get payDate => _payDate;
  String? get deliveryDate => _deliveryDate;
  String? get settDate => _settDate;
  num? get niyojanDel => _niyojanDel;
  num? get cDCMSDel => _cDCMSDel;
  num? get inCorrectStatus => _inCorrectStatus;
  String? get addedOn => _addedOn;
  dynamic get action => _action;
  num? get addedBy => _addedBy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ConsId'] = _consId;
    map['DistributorId'] = _distributorId;
    map['StaffId'] = _staffId;
    map['ItemId'] = _itemId;
    map['ConsumerNo'] = _consumerNo;
    map['OrderNo'] = _orderNo;
    map['OrderRefNo'] = _orderRefNo;
    map['OrderDate'] = _orderDate;
    map['CashDate'] = _cashDate;
    map['ConsumerName'] = _consumerName;
    map['PaymentStatus'] = _paymentStatus;
    map['ConsumerRemark'] = _consumerRemark;
    map['PayDate'] = _payDate;
    map['DeliveryDate'] = _deliveryDate;
    map['SettDate'] = _settDate;
    map['NiyojanDel'] = _niyojanDel;
    map['cDCMSDel'] = _cDCMSDel;
    map['InCorrectStatus'] = _inCorrectStatus;
    map['AddedOn'] = _addedOn;
    map['Action'] = _action;
    map['AddedBy'] = _addedBy;
    return map;
  }

}

/// Id : 1
/// NoteType : 500.00
/// Quantity : 16
/// TotalAmt : 8000.00
/// RetNoteQty : 0
/// RetNoteAmt : 0.00

class CashDenomDtls {
  CashDenomDtls({
      num? id, 
      num? noteType, 
      num? quantity, 
      num? totalAmt, 
      num? retNoteQty, 
      num? retNoteAmt,}){
    _id = id;
    _noteType = noteType;
    _quantity = quantity;
    _totalAmt = totalAmt;
    _retNoteQty = retNoteQty;
    _retNoteAmt = retNoteAmt;
}

  CashDenomDtls.fromJson(dynamic json) {
    _id = json['Id'];
    _noteType = json['NoteType'];
    _quantity = json['Quantity'];
    _totalAmt = json['TotalAmt'];
    _retNoteQty = json['RetNoteQty'];
    _retNoteAmt = json['RetNoteAmt'];
  }
  num? _id;
  num? _noteType;
  num? _quantity;
  num? _totalAmt;
  num? _retNoteQty;
  num? _retNoteAmt;
CashDenomDtls copyWith({  num? id,
  num? noteType,
  num? quantity,
  num? totalAmt,
  num? retNoteQty,
  num? retNoteAmt,
}) => CashDenomDtls(  id: id ?? _id,
  noteType: noteType ?? _noteType,
  quantity: quantity ?? _quantity,
  totalAmt: totalAmt ?? _totalAmt,
  retNoteQty: retNoteQty ?? _retNoteQty,
  retNoteAmt: retNoteAmt ?? _retNoteAmt,
);
  num? get id => _id;
  num? get noteType => _noteType;
  num? get quantity => _quantity;
  num? get totalAmt => _totalAmt;
  num? get retNoteQty => _retNoteQty;
  num? get retNoteAmt => _retNoteAmt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Id'] = _id;
    map['NoteType'] = _noteType;
    map['Quantity'] = _quantity;
    map['TotalAmt'] = _totalAmt;
    map['RetNoteQty'] = _retNoteQty;
    map['RetNoteAmt'] = _retNoteAmt;
    return map;
  }

}