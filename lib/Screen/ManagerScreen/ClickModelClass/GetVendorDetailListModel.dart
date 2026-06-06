/// ARBPurId : 14
/// DistributorId : 8118
/// InvoiceNo : "123"
/// InvoiceDate : "2025-07-03T15:40:49"
/// VendorId : 78
/// VendorName : "Sagar parmar"
/// ItemId : 0
/// ItemName : null
/// PurchaseAmount : 60054.00
/// TotalPaid : 0.00
/// PendingAmount : 60054.00

class GetVendorDetailListModel {
  GetVendorDetailListModel({
      num? aRBPurId, 
      num? distributorId, 
      String? invoiceNo, 
      String? invoiceDate, 
      num? vendorId, 
      String? vendorName, 
      num? itemId, 
      dynamic itemName, 
      num? purchaseAmount, 
      num? totalPaid, 
      num? pendingAmount,}){
    _aRBPurId = aRBPurId;
    _distributorId = distributorId;
    _invoiceNo = invoiceNo;
    _invoiceDate = invoiceDate;
    _vendorId = vendorId;
    _vendorName = vendorName;
    _itemId = itemId;
    _itemName = itemName;
    _purchaseAmount = purchaseAmount;
    _totalPaid = totalPaid;
    _pendingAmount = pendingAmount;
}

  GetVendorDetailListModel.fromJson(dynamic json) {
    _aRBPurId = json['ARBPurId'];
    _distributorId = json['DistributorId'];
    _invoiceNo = json['InvoiceNo'];
    _invoiceDate = json['InvoiceDate'];
    _vendorId = json['VendorId'];
    _vendorName = json['VendorName'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _purchaseAmount = json['PurchaseAmount'];
    _totalPaid = json['TotalPaid'];
    _pendingAmount = json['PendingAmount'];
  }
  num? _aRBPurId;
  num? _distributorId;
  String? _invoiceNo;
  String? _invoiceDate;
  num? _vendorId;
  String? _vendorName;
  num? _itemId;
  dynamic _itemName;
  num? _purchaseAmount;
  num? _totalPaid;
  num? _pendingAmount;
GetVendorDetailListModel copyWith({  num? aRBPurId,
  num? distributorId,
  String? invoiceNo,
  String? invoiceDate,
  num? vendorId,
  String? vendorName,
  num? itemId,
  dynamic itemName,
  num? purchaseAmount,
  num? totalPaid,
  num? pendingAmount,
}) => GetVendorDetailListModel(  aRBPurId: aRBPurId ?? _aRBPurId,
  distributorId: distributorId ?? _distributorId,
  invoiceNo: invoiceNo ?? _invoiceNo,
  invoiceDate: invoiceDate ?? _invoiceDate,
  vendorId: vendorId ?? _vendorId,
  vendorName: vendorName ?? _vendorName,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  purchaseAmount: purchaseAmount ?? _purchaseAmount,
  totalPaid: totalPaid ?? _totalPaid,
  pendingAmount: pendingAmount ?? _pendingAmount,
);
  num? get aRBPurId => _aRBPurId;
  num? get distributorId => _distributorId;
  String? get invoiceNo => _invoiceNo;
  String? get invoiceDate => _invoiceDate;
  num? get vendorId => _vendorId;
  String? get vendorName => _vendorName;
  num? get itemId => _itemId;
  dynamic get itemName => _itemName;
  num? get purchaseAmount => _purchaseAmount;
  num? get totalPaid => _totalPaid;
  num? get pendingAmount => _pendingAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ARBPurId'] = _aRBPurId;
    map['DistributorId'] = _distributorId;
    map['InvoiceNo'] = _invoiceNo;
    map['InvoiceDate'] = _invoiceDate;
    map['VendorId'] = _vendorId;
    map['VendorName'] = _vendorName;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['PurchaseAmount'] = _purchaseAmount;
    map['TotalPaid'] = _totalPaid;
    map['PendingAmount'] = _pendingAmount;
    return map;
  }

}