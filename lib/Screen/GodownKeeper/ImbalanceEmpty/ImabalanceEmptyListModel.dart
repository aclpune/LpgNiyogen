/// SaleGKId : 4
/// DistributorId : 8118
/// ImbDate : "2025-01-08T00:00:00"
/// DMId : 7
/// StaffNo : "SN/007"
/// StaffName : "Ashok Chavan"
/// ItemImbDtls : [{"SaleGKItemId":6,"ItemId":3,"ItemName":"5 kg","LessEmptyQty":2,"ImbQty":1,"Balance":1}]

class ImabalanceEmptyListModel {
  ImabalanceEmptyListModel({
      int? saleGKId,
      int? distributorId,
      String? imbDate, 
      int? dMId,
      String? staffNo, 
      String? staffName, 
      List<ItemImbDtls>? itemImbDtls,}){
    _saleGKId = saleGKId;
    _distributorId = distributorId;
    _imbDate = imbDate;
    _dMId = dMId;
    _staffNo = staffNo;
    _staffName = staffName;
    _itemImbDtls = itemImbDtls;
}

  // ImabalanceEmptyListModel.fromJson(dynamic json) {
  //   _saleGKId = json['SaleGKId'];
  //   _distributorId = json['DistributorId'];
  //   _imbDate = json['ImbDate'];
  //   _dMId = json['DMId'];
  //   _staffNo = json['StaffNo'];
  //   _staffName = json['StaffName'];
  //   if (json['ItemImbDtls'] != null) {
  //     _itemImbDtls = [];
  //     json['ItemImbDtls'].forEach((v) {
  //       _itemImbDtls?.add(ItemImbDtls.fromJson(v));
  //     });
  //   }
  // }
  ImabalanceEmptyListModel.fromJson(dynamic json) {
    _saleGKId = _parseInt(json['SaleGKId']);
    _distributorId = _parseInt(json['DistributorId']);
    _imbDate = json['ImbDate'];
    _dMId = _parseInt(json['DMId']);
    _staffNo = json['StaffNo'];
    _staffName = json['StaffName'];
    if (json['ItemImbDtls'] != null) {
      _itemImbDtls = [];
      json['ItemImbDtls'].forEach((v) {
        _itemImbDtls?.add(ItemImbDtls.fromJson(v));
      });
    }
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  int? _saleGKId;
  int? _distributorId;
  String? _imbDate;
  int? _dMId;
  String? _staffNo;
  String? _staffName;
  List<ItemImbDtls>? _itemImbDtls;
ImabalanceEmptyListModel copyWith({  int? saleGKId,
  int? distributorId,
  String? imbDate,
  int? dMId,
  String? staffNo,
  String? staffName,
  List<ItemImbDtls>? itemImbDtls,
}) => ImabalanceEmptyListModel(  saleGKId: saleGKId ?? _saleGKId,
  distributorId: distributorId ?? _distributorId,
  imbDate: imbDate ?? _imbDate,
  dMId: dMId ?? _dMId,
  staffNo: staffNo ?? _staffNo,
  staffName: staffName ?? _staffName,
  itemImbDtls: itemImbDtls ?? _itemImbDtls,
);
  num? get saleGKId => _saleGKId;
  num? get distributorId => _distributorId;
  String? get imbDate => _imbDate;
  num? get dMId => _dMId;
  String? get staffNo => _staffNo;
  String? get staffName => _staffName;
  List<ItemImbDtls>? get itemImbDtls => _itemImbDtls;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SaleGKId'] = _saleGKId;
    map['DistributorId'] = _distributorId;
    map['ImbDate'] = _imbDate;
    map['DMId'] = _dMId;
    map['StaffNo'] = _staffNo;
    map['StaffName'] = _staffName;
    if (_itemImbDtls != null) {
      map['ItemImbDtls'] = _itemImbDtls?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// SaleGKItemId : 6
/// ItemId : 3
/// ItemName : "5 kg"
/// LessEmptyQty : 2
/// ImbQty : 1
/// Balance : 1

class ItemImbDtls {
  ItemImbDtls({
      num? saleGKItemId, 
      num? itemId, 
      String? itemName, 
      num? lessEmptyQty, 
      num? imbQty, 
      num? balance,}){
    _saleGKItemId = saleGKItemId;
    _itemId = itemId;
    _itemName = itemName;
    _lessEmptyQty = lessEmptyQty;
    _imbQty = imbQty;
    _balance = balance;
}

  ItemImbDtls.fromJson(dynamic json) {
    _saleGKItemId = json['SaleGKItemId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _lessEmptyQty = json['LessEmptyQty'];
    _imbQty = json['ImbQty'];
    _balance = json['Balance'];
  }
  num? _saleGKItemId;
  num? _itemId;
  String? _itemName;
  num? _lessEmptyQty;
  num? _imbQty;
  num? _balance;
ItemImbDtls copyWith({  num? saleGKItemId,
  num? itemId,
  String? itemName,
  num? lessEmptyQty,
  num? imbQty,
  num? balance,
}) => ItemImbDtls(  saleGKItemId: saleGKItemId ?? _saleGKItemId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  lessEmptyQty: lessEmptyQty ?? _lessEmptyQty,
  imbQty: imbQty ?? _imbQty,
  balance: balance ?? _balance,
);
  num? get saleGKItemId => _saleGKItemId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get lessEmptyQty => _lessEmptyQty;
  num? get imbQty => _imbQty;
  num? get balance => _balance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SaleGKItemId'] = _saleGKItemId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['LessEmptyQty'] = _lessEmptyQty;
    map['ImbQty'] = _imbQty;
    map['Balance'] = _balance;
    return map;
  }

}