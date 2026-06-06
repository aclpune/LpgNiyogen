/// pkId : 0
/// ReceiptId : 1
/// DistributorId : 0
/// GodownId : 1
/// GodownKeeperId : 1
/// ReceiptDate : "2024-11-26T00:00:00"
/// ReturnOn : "0001-01-01T00:00:00"
/// VehicleNo : "MH13DW58"
/// ItemId : 0
/// ItemName : null
/// FilledQty : 0
/// EMRQty : 0
/// InvoiceQty : 0
/// ItemDetails : [{"pkId":0,"ItemId":1,"ItemName":"14.2 kg..","FilledQty":250,"EMRQty":100,"InvoiceQty":350,"IsReturnSent":0,"EmptyReturnQty":0,"DefectiveReturnQty":0},{"pkId":0,"ItemId":2,"ItemName":"5kg","FilledQty":100,"EMRQty":100,"InvoiceQty":200,"IsReturnSent":0,"EmptyReturnQty":0,"DefectiveReturnQty":0}]
/// AddedBy : 4
/// Action : null

class GetItemReceiptListModel {
  GetItemReceiptListModel({
      num? pkId, 
      num? receiptId, 
      num? distributorId, 
      num? godownId, 
      num? godownKeeperId, 
      String? receiptDate, 
      String? returnOn, 
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
    _receiptId = receiptId;
    _distributorId = distributorId;
    _godownId = godownId;
    _godownKeeperId = godownKeeperId;
    _receiptDate = receiptDate;
    _returnOn = returnOn;
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

  GetItemReceiptListModel.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _receiptId = json['ReceiptId'];
    _distributorId = json['DistributorId'];
    _godownId = json['GodownId'];
    _godownKeeperId = json['GodownKeeperId'];
    _receiptDate = json['ReceiptDate'];
    _returnOn = json['ReturnOn'];
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
  num? _receiptId;
  num? _distributorId;
  num? _godownId;
  num? _godownKeeperId;
  String? _receiptDate;
  String? _returnOn;
  String? _vehicleNo;
  num? _itemId;
  dynamic _itemName;
  num? _filledQty;
  num? _eMRQty;
  num? _invoiceQty;
  List<ItemDetails>? _itemDetails;
  num? _addedBy;
  dynamic _action;
GetItemReceiptListModel copyWith({  num? pkId,
  num? receiptId,
  num? distributorId,
  num? godownId,
  num? godownKeeperId,
  String? receiptDate,
  String? returnOn,
  String? vehicleNo,
  num? itemId,
  dynamic itemName,
  num? filledQty,
  num? eMRQty,
  num? invoiceQty,
  List<ItemDetails>? itemDetails,
  num? addedBy,
  dynamic action,
}) => GetItemReceiptListModel(  pkId: pkId ?? _pkId,
  receiptId: receiptId ?? _receiptId,
  distributorId: distributorId ?? _distributorId,
  godownId: godownId ?? _godownId,
  godownKeeperId: godownKeeperId ?? _godownKeeperId,
  receiptDate: receiptDate ?? _receiptDate,
  returnOn: returnOn ?? _returnOn,
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
  num? get receiptId => _receiptId;
  num? get distributorId => _distributorId;
  num? get godownId => _godownId;
  num? get godownKeeperId => _godownKeeperId;
  String? get receiptDate => _receiptDate;
  String? get returnOn => _returnOn;
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
    map['ReceiptId'] = _receiptId;
    map['DistributorId'] = _distributorId;
    map['GodownId'] = _godownId;
    map['GodownKeeperId'] = _godownKeeperId;
    map['ReceiptDate'] = _receiptDate;
    map['ReturnOn'] = _returnOn;
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
/// ItemId : 1
/// ItemName : "14.2 kg.."
/// FilledQty : 250
/// EMRQty : 100
/// InvoiceQty : 350
/// IsReturnSent : 0
/// EmptyReturnQty : 0
/// DefectiveReturnQty : 0

class ItemDetails {
  ItemDetails({
      num? pkId, 
      num? itemId, 
      String? itemName, 
      num? filledQty, 
      num? eMRQty, 
      num? invoiceQty, 
      num? isReturnSent, 
      num? emptyReturnQty, 
      num? defectiveReturnQty,}){
    _pkId = pkId;
    _itemId = itemId;
    _itemName = itemName;
    _filledQty = filledQty;
    _eMRQty = eMRQty;
    _invoiceQty = invoiceQty;
    _isReturnSent = isReturnSent;
    _emptyReturnQty = emptyReturnQty;
    _defectiveReturnQty = defectiveReturnQty;
}

  ItemDetails.fromJson(dynamic json) {
    _pkId = json['pkId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledQty = json['FilledQty'];
    _eMRQty = json['EMRQty'];
    _invoiceQty = json['InvoiceQty'];
    _isReturnSent = json['IsReturnSent'];
    _emptyReturnQty = json['EmptyReturnQty'];
    _defectiveReturnQty = json['DefectiveReturnQty'];
  }
  num? _pkId;
  num? _itemId;
  String? _itemName;
  num? _filledQty;
  num? _eMRQty;
  num? _invoiceQty;
  num? _isReturnSent;
  num? _emptyReturnQty;
  num? _defectiveReturnQty;
ItemDetails copyWith({  num? pkId,
  num? itemId,
  String? itemName,
  num? filledQty,
  num? eMRQty,
  num? invoiceQty,
  num? isReturnSent,
  num? emptyReturnQty,
  num? defectiveReturnQty,
}) => ItemDetails(  pkId: pkId ?? _pkId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledQty: filledQty ?? _filledQty,
  eMRQty: eMRQty ?? _eMRQty,
  invoiceQty: invoiceQty ?? _invoiceQty,
  isReturnSent: isReturnSent ?? _isReturnSent,
  emptyReturnQty: emptyReturnQty ?? _emptyReturnQty,
  defectiveReturnQty: defectiveReturnQty ?? _defectiveReturnQty,
);
  num? get pkId => _pkId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledQty => _filledQty;
  num? get eMRQty => _eMRQty;
  num? get invoiceQty => _invoiceQty;
  num? get isReturnSent => _isReturnSent;
  num? get emptyReturnQty => _emptyReturnQty;
  num? get defectiveReturnQty => _defectiveReturnQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pkId'] = _pkId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledQty'] = _filledQty;
    map['EMRQty'] = _eMRQty;
    map['InvoiceQty'] = _invoiceQty;
    map['IsReturnSent'] = _isReturnSent;
    map['EmptyReturnQty'] = _emptyReturnQty;
    map['DefectiveReturnQty'] = _defectiveReturnQty;
    return map;
  }

}