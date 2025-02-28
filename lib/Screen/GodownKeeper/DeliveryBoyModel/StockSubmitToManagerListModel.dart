/// SaleGKId : 17
/// DistributorId : 8118
/// DeliveryDate : "2024-12-19T00:00:00"
/// DMId : 25
/// VehicleId : 25
/// Remark : "aaaa"
/// DailySaleStatus : 0
/// StaffNo : "SN/024"
/// StaffName : "Virendra Surwase"
/// VehicleNo : "MH45AB5342"
/// StatusStr : null
/// AddedOn : "2024-12-19T04:51:21.227"
/// AddedByNo : null
/// AddedByName : null
/// ItemList : [{"ItemId":4,"ItemName":"2 kg","FilledSaleQty":20,"SVQty":1,"TVQty":1,"EmptyRetQty":18,"DeffQty":1,"LessEmptyQty":1,"Remark":null,"ClosingFilled":0,"ClosingEmpty":0,"ClosingDef":0,"SVConsStr":null},{"ItemId":4,"ItemName":"2 kg","FilledSaleQty":20,"SVQty":1,"TVQty":1,"EmptyRetQty":18,"DeffQty":1,"LessEmptyQty":1,"Remark":null,"ClosingFilled":0,"ClosingEmpty":0,"ClosingDef":0,"SVConsStr":null}]
/// AddedBy : 4
/// Action : null

class StockSubmitToManagerListModel {
  StockSubmitToManagerListModel({
      num? saleGKId,
      num? distributorId,
      String? deliveryDate,
      num? dMId,
      num? vehicleId,
      num? dailySaleStatus,
      String? staffNo,
      String? staffName,
      String? vehicleNo,
      String? statusStr,
      String? addedOn,
       String? addedByNo,
      String? addedByName,
      List<ItemList>? itemList,
      num? addedBy,
     String? action,}){
    _saleGKId = saleGKId;
    _distributorId = distributorId;
    _deliveryDate = deliveryDate;
    _dMId = dMId;
    _vehicleId = vehicleId;
    _dailySaleStatus = dailySaleStatus;
    _staffNo = staffNo;
    _staffName = staffName;
    _vehicleNo = vehicleNo;
    _statusStr = statusStr;
    _addedOn = addedOn;
    _addedByNo = addedByNo;
    _addedByName = addedByName;
    _itemList = itemList;
    _addedBy = addedBy;
    _action = action;

}

  StockSubmitToManagerListModel.fromJson(dynamic json) {
    _saleGKId = json['SaleGKId'];
    _distributorId = json['DistributorId'];
    _deliveryDate = json['DeliveryDate'];
    _dMId = json['DMId'];
    _vehicleId = json['VehicleId'];
    _dailySaleStatus = json['DailySaleStatus'];
    _staffNo = json['StaffNo'];
    _staffName = json['StaffName'];
    _vehicleNo = json['VehicleNo'];
    _statusStr = json['StatusStr'];
    _addedOn = json['AddedOn'];
    _addedByNo = json['AddedByNo'];
    _addedByName = json['AddedByName'];
    if (json['ItemList'] != null) {
      _itemList = [];
      json['ItemList'].forEach((v) {
        _itemList?.add(ItemList.fromJson(v));
      });
    }
    _addedBy = json['AddedBy'];
    _action = json['Action'];
  }
  num? _saleGKId;
  num? _distributorId;
  String? _deliveryDate;
  num? _dMId;
  num? _vehicleId;
  num? _dailySaleStatus;
  String? _staffNo;
  String? _staffName;
  String? _vehicleNo;
  String? _statusStr;
  String? _addedOn;
  String? _addedByNo;
  String? _addedByName;
  List<ItemList>? _itemList;
  num? _addedBy;
  String? _action;
StockSubmitToManagerListModel copyWith({  num? saleGKId,
  num? distributorId,
  String? deliveryDate,
  num? dMId,
  num? vehicleId,
  num? dailySaleStatus,
  String? staffNo,
  String? staffName,
  String? vehicleNo,
  String? statusStr,
  String? addedOn,
  String? addedByNo,
  String? addedByName,
  List<ItemList>? itemList,
  num? addedBy,
  String? action,
}) => StockSubmitToManagerListModel(  saleGKId: saleGKId ?? _saleGKId,
  distributorId: distributorId ?? _distributorId,
  deliveryDate: deliveryDate ?? _deliveryDate,
  dMId: dMId ?? _dMId,
  vehicleId: vehicleId ?? _vehicleId,
  dailySaleStatus: dailySaleStatus ?? _dailySaleStatus,
  staffNo: staffNo ?? _staffNo,
  staffName: staffName ?? _staffName,
  vehicleNo: vehicleNo ?? _vehicleNo,
  statusStr: statusStr ?? _statusStr,
  addedOn: addedOn ?? _addedOn,
  addedByNo: addedByNo ?? _addedByNo,
  addedByName: addedByName ?? _addedByName,
  itemList: itemList ?? _itemList,
  addedBy: addedBy ?? _addedBy,
  action: action ?? _action,
);
  num? get saleGKId => _saleGKId;
  num? get distributorId => _distributorId;
  String? get deliveryDate => _deliveryDate;
  num? get dMId => _dMId;
  num? get vehicleId => _vehicleId;
  num? get dailySaleStatus => _dailySaleStatus;
  String? get staffNo => _staffNo;
  String? get staffName => _staffName;
  String? get vehicleNo => _vehicleNo;
  String? get statusStr => _statusStr;
  String? get addedOn => _addedOn;
  String? get addedByNo => _addedByNo;
  String? get addedByName => _addedByName;
  List<ItemList>? get itemList => _itemList;
  num? get addedBy => _addedBy;
  String? get action => _action;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SaleGKId'] = _saleGKId;
    map['DistributorId'] = _distributorId;
    map['DeliveryDate'] = _deliveryDate;
    map['DMId'] = _dMId;
    map['VehicleId'] = _vehicleId;
    map['DailySaleStatus'] = _dailySaleStatus;
    map['StaffNo'] = _staffNo;
    map['StaffName'] = _staffName;
    map['VehicleNo'] = _vehicleNo;
    map['StatusStr'] = _statusStr;
    map['AddedOn'] = _addedOn;
    map['AddedByNo'] = _addedByNo;
    map['AddedByName'] = _addedByName;
    if (_itemList != null) {
      map['ItemList'] = _itemList?.map((v) => v.toJson()).toList();
    }
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    return map;
  }

}

/// ItemId : 4
/// ItemName : "2 kg"
/// FilledSaleQty : 20
/// SVQty : 1
/// TVQty : 1
/// EmptyRetQty : 18
/// DeffQty : 1
/// LessEmptyQty : 1
/// Remark : null
/// ClosingFilled : 0
/// ClosingEmpty : 0
/// ClosingDef : 0
/// SVConsStr : null

class ItemList {
  ItemList({
      num? SaleGKItemId,
      num? itemId,
      String? itemName,
      num? filledSaleQty,
      num? sVQty,
      num? tVQty,
      num? emptyRetQty,
      num? deffQty,
      num? lessEmptyQty,
      String? remark,
      num? closingFilled,
      num? closingEmpty,
      num? closingDef,
    String? sVConsStr,
    String? TVConsStr,
  String? FlagColumnUpdate,}){
    _SaleGKItemId = SaleGKItemId;
    _itemId = itemId;
    _itemName = itemName;
    _filledSaleQty = filledSaleQty;
    _sVQty = sVQty;
    _tVQty = tVQty;
    _emptyRetQty = emptyRetQty;
    _deffQty = deffQty;
    _lessEmptyQty = lessEmptyQty;
    _remark = remark;
    _closingFilled = closingFilled;
    _closingEmpty = closingEmpty;
    _closingDef = closingDef;
    _sVConsStr = sVConsStr;
    _TVConsStr = TVConsStr;
    _FlagColumnUpdate = FlagColumnUpdate;
}

  ItemList.fromJson(dynamic json) {
    _SaleGKItemId = json['SaleGKItemId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledSaleQty = json['FilledSaleQty'];
    _sVQty = json['SVQty'];
    _tVQty = json['TVQty'];
    _emptyRetQty = json['EmptyRetQty'];
    _deffQty = json['DeffQty'];
    _lessEmptyQty = json['LessEmptyQty'];
    _remark = json['Remark'];
    _closingFilled = json['ClosingFilled'];
    _closingEmpty = json['ClosingEmpty'];
    _closingDef = json['ClosingDef'];
    _sVConsStr = json['SVConsStr'];
    _TVConsStr = json['TVConsStr'];
    _FlagColumnUpdate = json['FlagColumnUpdate'];
  }
  num? _itemId;
  num? _SaleGKItemId;
  String? _itemName;
  num? _filledSaleQty;
  num? _sVQty;
  num? _tVQty;
  num? _emptyRetQty;
  num? _deffQty;
  num? _lessEmptyQty;
  String? _remark;
  num? _closingFilled;
  num? _closingEmpty;
  num? _closingDef;
  String? _sVConsStr;
  String? _TVConsStr;
  String? _FlagColumnUpdate;
ItemList copyWith({
  num? SaleGKItemId,
  num? itemId,
  String? itemName,
  num? filledSaleQty,
  num? sVQty,
  num? tVQty,
  num? emptyRetQty,
  num? deffQty,
  num? lessEmptyQty,
  String? remark,
  num? closingFilled,
  num? closingEmpty,
  num? closingDef,
  String? sVConsStr,
  String? TVConsStr,
  String? FlagColumnUpdate,
}) => ItemList(
  SaleGKItemId: SaleGKItemId ?? _SaleGKItemId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledSaleQty: filledSaleQty ?? _filledSaleQty,
  sVQty: sVQty ?? _sVQty,
  tVQty: tVQty ?? _tVQty,
  emptyRetQty: emptyRetQty ?? _emptyRetQty,
  deffQty: deffQty ?? _deffQty,
  lessEmptyQty: lessEmptyQty ?? _lessEmptyQty,
  remark: remark ?? _remark,
  closingFilled: closingFilled ?? _closingFilled,
  closingEmpty: closingEmpty ?? _closingEmpty,
  closingDef: closingDef ?? _closingDef,
  sVConsStr: sVConsStr ?? _sVConsStr,
  TVConsStr: TVConsStr ?? _TVConsStr,
  FlagColumnUpdate: FlagColumnUpdate ?? _FlagColumnUpdate,
);
  num? get SaleGKItemId => _SaleGKItemId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledSaleQty => _filledSaleQty;
  num? get sVQty => _sVQty;
  num? get tVQty => _tVQty;
  num? get emptyRetQty => _emptyRetQty;
  num? get deffQty => _deffQty;
  num? get lessEmptyQty => _lessEmptyQty;
  String? get remark => _remark;
  num? get closingFilled => _closingFilled;
  num? get closingEmpty => _closingEmpty;
  num? get closingDef => _closingDef;
  String? get sVConsStr => _sVConsStr;
  String? get TVConsStr => _TVConsStr;
  String? get FlagColumnUpdate => _FlagColumnUpdate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['SaleGKItemId'] = _SaleGKItemId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledSaleQty'] = _filledSaleQty;
    map['SVQty'] = _sVQty;
    map['TVQty'] = _tVQty;
    map['EmptyRetQty'] = _emptyRetQty;
    map['DeffQty'] = _deffQty;
    map['LessEmptyQty'] = _lessEmptyQty;
    map['Remark'] = _remark;
    map['ClosingFilled'] = _closingFilled;
    map['ClosingEmpty'] = _closingEmpty;
    map['ClosingDef'] = _closingDef;
    map['SVConsStr'] = _sVConsStr;
    map['TVConsStr'] = _TVConsStr;
    map['FlagColumnUpdate'] = _FlagColumnUpdate;
    return map;
  }

}