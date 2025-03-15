/// pkId : 0
/// ReturnId : 1
/// DistributorId : 0
/// GodownId : 1
/// GodownKeeperId : 61
/// ReturnDate : "2025-03-12T00:00:00"
/// ReceiptOn : "0001-01-01T00:00:00"
/// IsReceipt : 0
/// VehicleNo : "Fhyk98"
/// ItemId : 0
/// ItemName : null
/// FilledQty : 0
/// EMRQty : 0
/// InvoiceQty : 0
/// ItemDetails : [{"pkId":0,"ItemId":2,"ItemName":"19 kg","FilledQty":0,"EXMIQty":110,"EmptyReturnQty":20,"EmptyEMR":10}]
/// AddedBy : 61
/// Action : null

class GetExmiListModel {
  GetExmiListModel({
      num? pkId, 
      num? returnId, 
      num? distributorId, 
      num? godownId, 
      num? godownKeeperId, 
      String? returnDate, 
      String? receiptOn, 
      num? isReceipt, 
      String? vehicleNo, 
      num? itemId, 
      dynamic itemName, 
      num? filledQty, 
      num? eMRQty, 
      num? invoiceQty, 
      List<ItemDetails>? itemDetails, 
      num? addedBy, 
      dynamic action,}){
    _pkId = pkId;
    _returnId = returnId;
    _distributorId = distributorId;
    _godownId = godownId;
    _godownKeeperId = godownKeeperId;
    _returnDate = returnDate;
    _receiptOn = receiptOn;
    _isReceipt = isReceipt;
    _vehicleNo = vehicleNo;
    _itemId = itemId;
    _itemName = itemName;
    _filledQty = filledQty;
    _eMRQty = eMRQty;
    _invoiceQty = invoiceQty;
    _itemDetails = itemDetails;
    _addedBy = addedBy;
    _action = action;
}

  GetExmiListModel.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _returnId = json['ReturnId'];
    _distributorId = json['DistributorId'];
    _godownId = json['GodownId'];
    _godownKeeperId = json['GodownKeeperId'];
    _returnDate = json['ReturnDate'];
    _receiptOn = json['ReceiptOn'];
    _isReceipt = json['IsReceipt'];
    _vehicleNo = json['VehicleNo'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledQty = json['FilledQty'];
    _eMRQty = json['EMRQty'];
    _invoiceQty = json['InvoiceQty'];
    if (json['ItemDetails'] != null) {
      _itemDetails = [];
      json['ItemDetails'].forEach((v) {
        _itemDetails?.add(ItemDetails.fromJson(v));
      });
    }
    _addedBy = json['AddedBy'];
    _action = json['Action'];
  }
  num? _pkId;
  num? _returnId;
  num? _distributorId;
  num? _godownId;
  num? _godownKeeperId;
  String? _returnDate;
  String? _receiptOn;
  num? _isReceipt;
  String? _vehicleNo;
  num? _itemId;
  dynamic _itemName;
  num? _filledQty;
  num? _eMRQty;
  num? _invoiceQty;
  List<ItemDetails>? _itemDetails;
  num? _addedBy;
  dynamic _action;
GetExmiListModel copyWith({  num? pkId,
  num? returnId,
  num? distributorId,
  num? godownId,
  num? godownKeeperId,
  String? returnDate,
  String? receiptOn,
  num? isReceipt,
  String? vehicleNo,
  num? itemId,
  dynamic itemName,
  num? filledQty,
  num? eMRQty,
  num? invoiceQty,
  List<ItemDetails>? itemDetails,
  num? addedBy,
  dynamic action,
}) => GetExmiListModel(  pkId: pkId ?? _pkId,
  returnId: returnId ?? _returnId,
  distributorId: distributorId ?? _distributorId,
  godownId: godownId ?? _godownId,
  godownKeeperId: godownKeeperId ?? _godownKeeperId,
  returnDate: returnDate ?? _returnDate,
  receiptOn: receiptOn ?? _receiptOn,
  isReceipt: isReceipt ?? _isReceipt,
  vehicleNo: vehicleNo ?? _vehicleNo,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledQty: filledQty ?? _filledQty,
  eMRQty: eMRQty ?? _eMRQty,
  invoiceQty: invoiceQty ?? _invoiceQty,
  itemDetails: itemDetails ?? _itemDetails,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
);
  num? get pkId => _pkId;
  num? get returnId => _returnId;
  num? get distributorId => _distributorId;
  num? get godownId => _godownId;
  num? get godownKeeperId => _godownKeeperId;
  String? get returnDate => _returnDate;
  String? get receiptOn => _receiptOn;
  num? get isReceipt => _isReceipt;
  String? get vehicleNo => _vehicleNo;
  num? get itemId => _itemId;
  dynamic get itemName => _itemName;
  num? get filledQty => _filledQty;
  num? get eMRQty => _eMRQty;
  num? get invoiceQty => _invoiceQty;
  List<ItemDetails>? get itemDetails => _itemDetails;
  num? get addedBy => _addedBy;
  dynamic get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['ReturnId'] = _returnId;
    map['DistributorId'] = _distributorId;
    map['GodownId'] = _godownId;
    map['GodownKeeperId'] = _godownKeeperId;
    map['ReturnDate'] = _returnDate;
    map['ReceiptOn'] = _receiptOn;
    map['IsReceipt'] = _isReceipt;
    map['VehicleNo'] = _vehicleNo;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledQty'] = _filledQty;
    map['EMRQty'] = _eMRQty;
    map['InvoiceQty'] = _invoiceQty;
    if (_itemDetails != null) {
      map['ItemDetails'] = _itemDetails?.map((v) => v.toJson()).toList();
    }
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    return map;
  }

}

/// pkId : 0
/// ItemId : 2
/// ItemName : "19 kg"
/// FilledQty : 0
/// EXMIQty : 110
/// EmptyReturnQty : 20
/// EmptyEMR : 10

class ItemDetails {
  ItemDetails({
      num? pkId, 
      num? itemId, 
      String? itemName, 
      num? filledQty, 
      num? eXMIQty, 
      num? emptyReturnQty, 
      num? emptyEMR,}){
    _pkId = pkId;
    _itemId = itemId;
    _itemName = itemName;
    _filledQty = filledQty;
    _eXMIQty = eXMIQty;
    _emptyReturnQty = emptyReturnQty;
    _emptyEMR = emptyEMR;
}

  ItemDetails.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledQty = json['FilledQty'];
    _eXMIQty = json['EXMIQty'];
    _emptyReturnQty = json['EmptyReturnQty'];
    _emptyEMR = json['EmptyEMR'];
  }
  num? _pkId;
  num? _itemId;
  String? _itemName;
  num? _filledQty;
  num? _eXMIQty;
  num? _emptyReturnQty;
  num? _emptyEMR;
ItemDetails copyWith({  num? pkId,
  num? itemId,
  String? itemName,
  num? filledQty,
  num? eXMIQty,
  num? emptyReturnQty,
  num? emptyEMR,
}) => ItemDetails(  pkId: pkId ?? _pkId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledQty: filledQty ?? _filledQty,
  eXMIQty: eXMIQty ?? _eXMIQty,
  emptyReturnQty: emptyReturnQty ?? _emptyReturnQty,
  emptyEMR: emptyEMR ?? _emptyEMR,
);
  num? get pkId => _pkId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledQty => _filledQty;
  num? get eXMIQty => _eXMIQty;
  num? get emptyReturnQty => _emptyReturnQty;
  num? get emptyEMR => _emptyEMR;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledQty'] = _filledQty;
    map['EXMIQty'] = _eXMIQty;
    map['EmptyReturnQty'] = _emptyReturnQty;
    map['EmptyEMR'] = _emptyEMR;
    return map;
  }

}