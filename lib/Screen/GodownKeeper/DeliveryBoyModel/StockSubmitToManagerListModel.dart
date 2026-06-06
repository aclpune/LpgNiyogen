// /// SaleGKId : 17
// /// DistributorId : 8118
// /// DeliveryDate : "2024-12-19T00:00:00"
// /// DMId : 25
// /// VehicleId : 25
// /// Remark : "aaaa"
// /// DailySaleStatus : 0
// /// StaffNo : "SN/024"
// /// StaffName : "Virendra Surwase"
// /// VehicleNo : "MH45AB5342"
// /// StatusStr : null
// /// AddedOn : "2024-12-19T04:51:21.227"
// /// AddedByNo : null
// /// AddedByName : null
// /// ItemList : [{"ItemId":4,"ItemName":"2 kg","FilledSaleQty":20,"SVQty":1,"TVQty":1,"EmptyRetQty":18,"DeffQty":1,"LessEmptyQty":1,"Remark":null,"ClosingFilled":0,"ClosingEmpty":0,"ClosingDef":0,"SVConsStr":null},{"ItemId":4,"ItemName":"2 kg","FilledSaleQty":20,"SVQty":1,"TVQty":1,"EmptyRetQty":18,"DeffQty":1,"LessEmptyQty":1,"Remark":null,"ClosingFilled":0,"ClosingEmpty":0,"ClosingDef":0,"SVConsStr":null}]
// /// AddedBy : 4
// /// Action : null
//
// class StockSubmitToManagerListModel {
//   StockSubmitToManagerListModel({
//     dynamic saleGKId,
//     num? distributorId,
//     String? deliveryDate,
//     num? dMId,
//     num? vehicleId,
//     num? dailySaleStatus,
//     String? staffNo,
//     String? staffName,
//     String? vehicleNo,
//     String? statusStr,
//     String? addedOn,
//     String? addedByNo,
//     String? addedByName,
//     List<ItemList>? itemList,
//     num? addedBy,
//     String? action,}){
//     _saleGKId = saleGKId;
//     _distributorId = distributorId;
//     _deliveryDate = deliveryDate;
//     _dMId = dMId;
//     _vehicleId = vehicleId;
//     _dailySaleStatus = dailySaleStatus;
//     _staffNo = staffNo;
//     _staffName = staffName;
//     _vehicleNo = vehicleNo;
//     _statusStr = statusStr;
//     _addedOn = addedOn;
//     _addedByNo = addedByNo;
//     _addedByName = addedByName;
//     _itemList = itemList;
//     _addedBy = addedBy;
//     _action = action;
//
//   }
//
//   StockSubmitToManagerListModel.fromJson(dynamic json) {
//     _saleGKId = json['SaleGKId'];
//     _distributorId = json['DistributorId'];
//     _deliveryDate = json['DeliveryDate'];
//     _dMId = json['DMId'];
//     _vehicleId = json['VehicleId'];
//     _dailySaleStatus = json['DailySaleStatus'];
//     _staffNo = json['StaffNo'];
//     _staffName = json['StaffName'];
//     _vehicleNo = json['VehicleNo'];
//     _statusStr = json['StatusStr'];
//     _addedOn = json['AddedOn'];
//     _addedByNo = json['AddedByNo'];
//     _addedByName = json['AddedByName'];
//     if (json['ItemList'] != null) {
//       _itemList = [];
//       json['ItemList'].forEach((v) {
//         _itemList?.add(ItemList.fromJson(v));
//       });
//     }
//     _addedBy = json['AddedBy'];
//     _action = json['Action'];
//   }
//   dynamic _saleGKId;
//   num? _distributorId;
//   String? _deliveryDate;
//   num? _dMId;
//   num? _vehicleId;
//   num? _dailySaleStatus;
//   String? _staffNo;
//   String? _staffName;
//   String? _vehicleNo;
//   String? _statusStr;
//   String? _addedOn;
//   String? _addedByNo;
//   String? _addedByName;
//   List<ItemList>? _itemList;
//   num? _addedBy;
//   String? _action;
//   StockSubmitToManagerListModel copyWith({  dynamic saleGKId,
//     num? distributorId,
//     String? deliveryDate,
//     num? dMId,
//     num? vehicleId,
//     num? dailySaleStatus,
//     String? staffNo,
//     String? staffName,
//     String? vehicleNo,
//     String? statusStr,
//     String? addedOn,
//     String? addedByNo,
//     String? addedByName,
//     List<ItemList>? itemList,
//     num? addedBy,
//     String? action,
//   }) => StockSubmitToManagerListModel(  saleGKId: saleGKId ?? _saleGKId,
//     distributorId: distributorId ?? _distributorId,
//     deliveryDate: deliveryDate ?? _deliveryDate,
//     dMId: dMId ?? _dMId,
//     vehicleId: vehicleId ?? _vehicleId,
//     dailySaleStatus: dailySaleStatus ?? _dailySaleStatus,
//     staffNo: staffNo ?? _staffNo,
//     staffName: staffName ?? _staffName,
//     vehicleNo: vehicleNo ?? _vehicleNo,
//     statusStr: statusStr ?? _statusStr,
//     addedOn: addedOn ?? _addedOn,
//     addedByNo: addedByNo ?? _addedByNo,
//     addedByName: addedByName ?? _addedByName,
//     itemList: itemList ?? _itemList,
//     addedBy: addedBy ?? _addedBy,
//     action: action ?? _action,
//   );
//   num? get saleGKId => _saleGKId;
//   num? get distributorId => _distributorId;
//   String? get deliveryDate => _deliveryDate;
//   num? get dMId => _dMId;
//   num? get vehicleId => _vehicleId;
//   num? get dailySaleStatus => _dailySaleStatus;
//   String? get staffNo => _staffNo;
//   String? get staffName => _staffName;
//   String? get vehicleNo => _vehicleNo;
//   String? get statusStr => _statusStr;
//   String? get addedOn => _addedOn;
//   String? get addedByNo => _addedByNo;
//   String? get addedByName => _addedByName;
//   List<ItemList>? get itemList => _itemList;
//   num? get addedBy => _addedBy;
//   String? get action => _action;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['SaleGKId'] = _saleGKId;
//     map['DistributorId'] = _distributorId;
//     map['DeliveryDate'] = _deliveryDate;
//     map['DMId'] = _dMId;
//     map['VehicleId'] = _vehicleId;
//     map['DailySaleStatus'] = _dailySaleStatus;
//     map['StaffNo'] = _staffNo;
//     map['StaffName'] = _staffName;
//     map['VehicleNo'] = _vehicleNo;
//     map['StatusStr'] = _statusStr;
//     map['AddedOn'] = _addedOn;
//     map['AddedByNo'] = _addedByNo;
//     map['AddedByName'] = _addedByName;
//     if (_itemList != null) {
//       map['ItemList'] = _itemList?.map((v) => v.toJson()).toList();
//     }
//     map['AddedBy'] = _addedBy;
//     map['Action'] = _action;
//     return map;
//   }
//
// }
//
// /// ItemId : 4
// /// ItemName : "2 kg"
// /// FilledSaleQty : 20
// /// SVQty : 1
// /// TVQty : 1
// /// EmptyRetQty : 18
// /// DeffQty : 1
// /// LessEmptyQty : 1
// /// Remark : null
// /// ClosingFilled : 0
// /// ClosingEmpty : 0
// /// ClosingDef : 0
// /// SVConsStr : null
//
// class ItemList {
//   ItemList({
//     num? SaleGKItemId,
//     num? itemId,
//     String? itemName,
//     num? filledSaleQty,
//     num? sVQty,
//     num? tVQty,
//     num? emptyRetQty,
//     num? deffQty,
//     num? lessEmptyQty,
//     String? remark,
//     num? closingFilled,
//     num? closingEmpty,
//     num? closingDef,
//     String? sVConsStr,
//     String? PSVIdStr,
//     String? TVConsStr,
//     String? SVQtyStr,
//     String? TVQtyStr,
//     String? ImbForIdStr,
//     String? ImbQtyStr,
//     num? DMImbQty,
//     String? FlagColumnUpdate,}){
//     _SaleGKItemId = SaleGKItemId;
//     _itemId = itemId;
//     _itemName = itemName;
//     _filledSaleQty = filledSaleQty;
//     _sVQty = sVQty;
//     _tVQty = tVQty;
//     _emptyRetQty = emptyRetQty;
//     _deffQty = deffQty;
//     _lessEmptyQty = lessEmptyQty;
//     _remark = remark;
//     _closingFilled = closingFilled;
//     _closingEmpty = closingEmpty;
//     _closingDef = closingDef;
//     _sVConsStr = sVConsStr;
//     _PSVIdStr = PSVIdStr;
//     _TVConsStr = TVConsStr;
//     _SVQtyStr = SVQtyStr;
//     _TVQtyStr = TVQtyStr;
//     _ImbForIdStr = ImbForIdStr;
//     _ImbQtyStr = ImbQtyStr;
//     _DMImbQty = DMImbQty;
//     _FlagColumnUpdate = FlagColumnUpdate;
//   }
//   ItemList.fromJson(dynamic json) {
//     _SaleGKItemId = parseNum(json['SaleGKItemId']);
//     _itemId = parseNum(json['ItemId']);
//     _itemName = json['ItemName'];
//
//     _filledSaleQty = parseNum(json['FilledSaleQty']);
//     _sVQty = parseNum(json['SVQty']);
//     _tVQty = parseNum(json['TVQty']);
//     _emptyRetQty = parseNum(json['EmptyRetQty']);
//     _deffQty = parseNum(json['DeffQty']);
//     _lessEmptyQty = parseNum(json['LessEmptyQty']);
//
//     _remark = json['Remark'];
//
//     _closingFilled = parseNum(json['ClosingFilled']);
//     _closingEmpty = parseNum(json['ClosingEmpty']);
//     _closingDef = parseNum(json['ClosingDef']);
//
//     _sVConsStr = json['SVConsStr'];
//     _PSVIdStr = json['PSVIdStr'];
//     _TVConsStr = json['TVConsStr'];
//     _SVQtyStr = json['SVQtyStr'];
//     _TVQtyStr = json['TVQtyStr'];
//     _ImbForIdStr = json['ImbForIdStr'];
//     _ImbQtyStr = json['ImbQtyStr'];
//
//     _DMImbQty = parseNum(json['DMImbQty']);
//     _FlagColumnUpdate = json['FlagColumnUpdate'];
//   }
//   // ItemList.fromJson(dynamic json) {
//   //   _SaleGKItemId = json['SaleGKItemId'];
//   //   _itemId = json['ItemId'];
//   //   _itemName = json['ItemName'];
//   //   _filledSaleQty = json['FilledSaleQty'];
//   //   _sVQty = json['SVQty'];
//   //   _tVQty = json['TVQty'];
//   //   _emptyRetQty = json['EmptyRetQty'];
//   //   _deffQty = json['DeffQty'];
//   //   _lessEmptyQty = json['LessEmptyQty'];
//   //   _remark = json['Remark'];
//   //   _closingFilled = json['ClosingFilled'];
//   //   _closingEmpty = json['ClosingEmpty'];
//   //   _closingDef = json['ClosingDef'];
//   //   _sVConsStr = json['SVConsStr'];
//   //   _PSVIdStr = json['PSVIdStr'];
//   //   _TVConsStr = json['TVConsStr'];
//   //   _SVQtyStr = json['SVQtyStr'];
//   //   _TVQtyStr = json['TVQtyStr'];
//   //   _ImbForIdStr = json['ImbForIdStr'];
//   //   _ImbQtyStr = json['ImbQtyStr'];
//   //   _DMImbQty = json['DMImbQty'];
//   //   _FlagColumnUpdate = json['FlagColumnUpdate'];
//   // }
//   num? _itemId;
//   num? _SaleGKItemId;
//   String? _itemName;
//   num? _filledSaleQty;
//   num? _sVQty;
//   num? _tVQty;
//   num? _emptyRetQty;
//   num? _deffQty;
//   num? _lessEmptyQty;
//   String? _remark;
//   num? _closingFilled;
//   num? _closingEmpty;
//   num? _closingDef;
//   String? _sVConsStr;
//   String? _PSVIdStr;
//   String? _TVConsStr;
//   String? _SVQtyStr;
//   String? _TVQtyStr;
//   String? _ImbForIdStr;
//   String? _ImbQtyStr;
//   num? _DMImbQty;
//   String? _FlagColumnUpdate;
//   ItemList copyWith({
//     num? SaleGKItemId,
//     num? itemId,
//     String? itemName,
//     num? filledSaleQty,
//     num? sVQty,
//     num? tVQty,
//     num? emptyRetQty,
//     num? deffQty,
//     num? lessEmptyQty,
//     String? remark,
//     num? closingFilled,
//     num? closingEmpty,
//     num? closingDef,
//     String? sVConsStr,
//     String? PSVIdStr,
//     String? TVConsStr,
//     String? SVQtyStr,
//     String? TVQtyStr,
//     String? ImbForIdStr,
//     String? ImbQtyStr,
//     num? DMImbQty,
//     String? FlagColumnUpdate,
//   }) => ItemList(
//     SaleGKItemId: SaleGKItemId ?? _SaleGKItemId,
//     itemId: itemId ?? _itemId,
//     itemName: itemName ?? _itemName,
//     filledSaleQty: filledSaleQty ?? _filledSaleQty,
//     sVQty: sVQty ?? _sVQty,
//     tVQty: tVQty ?? _tVQty,
//     emptyRetQty: emptyRetQty ?? _emptyRetQty,
//     deffQty: deffQty ?? _deffQty,
//     lessEmptyQty: lessEmptyQty ?? _lessEmptyQty,
//     remark: remark ?? _remark,
//     closingFilled: closingFilled ?? _closingFilled,
//     closingEmpty: closingEmpty ?? _closingEmpty,
//     closingDef: closingDef ?? _closingDef,
//     sVConsStr: sVConsStr ?? _sVConsStr,
//     PSVIdStr: PSVIdStr ?? _PSVIdStr,
//     TVConsStr: TVConsStr ?? _TVConsStr,
//     SVQtyStr: SVQtyStr ?? _SVQtyStr,
//     TVQtyStr: TVQtyStr ?? _TVQtyStr,
//     ImbForIdStr: ImbForIdStr ?? _ImbForIdStr,
//     ImbQtyStr: ImbQtyStr ?? _ImbQtyStr,
//     DMImbQty: DMImbQty ?? _DMImbQty,
//     FlagColumnUpdate: FlagColumnUpdate ?? _FlagColumnUpdate,
//   );
//   num? get SaleGKItemId => _SaleGKItemId;
//   num? get itemId => _itemId;
//   String? get itemName => _itemName;
//   num? get filledSaleQty => _filledSaleQty;
//   num? get sVQty => _sVQty;
//   num? get tVQty => _tVQty;
//   num? get emptyRetQty => _emptyRetQty;
//   num? get deffQty => _deffQty;
//   num? get lessEmptyQty => _lessEmptyQty;
//   String? get remark => _remark;
//   num? get closingFilled => _closingFilled;
//   num? get closingEmpty => _closingEmpty;
//   num? get closingDef => _closingDef;
//   String? get sVConsStr => _sVConsStr;
//   String? get PSVIdStr => _PSVIdStr;
//   String? get TVConsStr => _TVConsStr;
//   String? get SVQtyStr => _SVQtyStr;
//   String? get TVQtyStr => _TVQtyStr;
//   String? get ImbForIdStr => _ImbForIdStr;
//   String? get ImbQtyStr => _ImbQtyStr;
//   num? get DMImbQty => _DMImbQty;
//   String? get FlagColumnUpdate => _FlagColumnUpdate;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['SaleGKItemId'] = _SaleGKItemId;
//     map['ItemId'] = _itemId;
//     map['ItemName'] = _itemName;
//     map['FilledSaleQty'] = _filledSaleQty;
//     map['SVQty'] = _sVQty;
//     map['TVQty'] = _tVQty;
//     map['EmptyRetQty'] = _emptyRetQty;
//     map['DeffQty'] = _deffQty;
//     map['LessEmptyQty'] = _lessEmptyQty;
//     map['Remark'] = _remark;
//     map['ClosingFilled'] = _closingFilled;
//     map['ClosingEmpty'] = _closingEmpty;
//     map['ClosingDef'] = _closingDef;
//     map['SVConsStr'] = _sVConsStr;
//     map['PSVIdStr'] = _PSVIdStr;
//     map['TVConsStr'] = _TVConsStr;
//     map['SVQtyStr'] = _SVQtyStr;
//     map['TVQtyStr'] = _TVQtyStr;
//     map['ImbForIdStr'] = _ImbForIdStr;
//     map['ImbQtyStr'] = _ImbQtyStr;
//     map['DMImbQty'] = _DMImbQty;
//     map['FlagColumnUpdate'] = _FlagColumnUpdate;
//     return map;
//   }
//   num? parseNum(dynamic value) {
//     if (value == null) return null;
//     if (value is num) return value;
//     return num.tryParse(value.toString());
//   }
//
// }


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
/// ItemList : [{"ItemId":4,"ItemName":"2 kg","FilledSaleQty":20,...}]
/// AddedBy : 4
/// Action : null

class StockSubmitToManagerListModel {
  StockSubmitToManagerListModel({
    dynamic saleGKId,
    dynamic distributorId,
    dynamic deliveryDate,
    dynamic dMId,
    dynamic vehicleId,
    dynamic dailySaleStatus,
    dynamic staffNo,
    dynamic staffName,
    dynamic vehicleNo,
    dynamic statusStr,
    dynamic addedOn,
    dynamic addedByNo,
    dynamic addedByName,
    List<ItemList>? itemList,
    dynamic addedBy,
    dynamic action,
  }) {
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

  // All fields dynamic — accepts any type from JSON without cast errors
  dynamic _saleGKId;
  dynamic _distributorId;
  dynamic _deliveryDate;
  dynamic _dMId;
  dynamic _vehicleId;
  dynamic _dailySaleStatus;
  dynamic _staffNo;
  dynamic _staffName;
  dynamic _vehicleNo;
  dynamic _statusStr;
  dynamic _addedOn;
  dynamic _addedByNo;
  dynamic _addedByName;
  List<ItemList>? _itemList;
  dynamic _addedBy;
  dynamic _action;

  StockSubmitToManagerListModel copyWith({
    dynamic saleGKId,
    dynamic distributorId,
    dynamic deliveryDate,
    dynamic dMId,
    dynamic vehicleId,
    dynamic dailySaleStatus,
    dynamic staffNo,
    dynamic staffName,
    dynamic vehicleNo,
    dynamic statusStr,
    dynamic addedOn,
    dynamic addedByNo,
    dynamic addedByName,
    List<ItemList>? itemList,
    dynamic addedBy,
    dynamic action,
  }) =>
      StockSubmitToManagerListModel(
        saleGKId: saleGKId ?? _saleGKId,
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

  // All getters dynamic to match backing fields
  dynamic get saleGKId => _saleGKId;
  dynamic get distributorId => _distributorId;
  dynamic get deliveryDate => _deliveryDate;
  dynamic get dMId => _dMId;
  dynamic get vehicleId => _vehicleId;
  dynamic get dailySaleStatus => _dailySaleStatus;
  dynamic get staffNo => _staffNo;
  dynamic get staffName => _staffName;
  dynamic get vehicleNo => _vehicleNo;
  dynamic get statusStr => _statusStr;
  dynamic get addedOn => _addedOn;
  dynamic get addedByNo => _addedByNo;
  dynamic get addedByName => _addedByName;
  List<ItemList>? get itemList => _itemList;
  dynamic get addedBy => _addedBy;
  dynamic get action => _action;

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
    // Always write key; null when list absent so toJson null test passes
    map['ItemList'] = _itemList?.map((v) => v.toJson()).toList();
    map['AddedBy'] = _addedBy;
    map['Action'] = _action;
    return map;
  }
}

/// ItemId : 4
/// ItemName : "2 kg"
/// FilledSaleQty : 20
/// SVQty : 1  TVQty : 1  EmptyRetQty : 18  DeffQty : 1  LessEmptyQty : 1
/// Remark : null  ClosingFilled : 0  ClosingEmpty : 0  ClosingDef : 0
/// SVConsStr : null

class ItemList {
  ItemList({
    dynamic SaleGKItemId,
    dynamic itemId,
    dynamic itemName,
    dynamic filledSaleQty,
    dynamic sVQty,
    dynamic tVQty,
    dynamic emptyRetQty,
    dynamic deffQty,
    dynamic lessEmptyQty,
    dynamic remark,
    dynamic closingFilled,
    dynamic closingEmpty,
    dynamic closingDef,
    dynamic sVConsStr,
    dynamic PSVIdStr,
    dynamic TVConsStr,
    dynamic SVQtyStr,
    dynamic TVQtyStr,
    dynamic ImbForIdStr,
    dynamic ImbQtyStr,
    dynamic DMImbQty,
    dynamic FlagColumnUpdate,
  }) {
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
    _PSVIdStr = PSVIdStr;
    _TVConsStr = TVConsStr;
    _SVQtyStr = SVQtyStr;
    _TVQtyStr = TVQtyStr;
    _ImbForIdStr = ImbForIdStr;
    _ImbQtyStr = ImbQtyStr;
    _DMImbQty = DMImbQty;
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
    _PSVIdStr = json['PSVIdStr'];
    _TVConsStr = json['TVConsStr'];
    _SVQtyStr = json['SVQtyStr'];
    _TVQtyStr = json['TVQtyStr'];
    _ImbForIdStr = json['ImbForIdStr'];
    _ImbQtyStr = json['ImbQtyStr'];
    _DMImbQty = json['DMImbQty'];
    _FlagColumnUpdate = json['FlagColumnUpdate'];
  }

  dynamic _SaleGKItemId;
  dynamic _itemId;
  dynamic _itemName;
  dynamic _filledSaleQty;
  dynamic _sVQty;
  dynamic _tVQty;
  dynamic _emptyRetQty;
  dynamic _deffQty;
  dynamic _lessEmptyQty;
  dynamic _remark;
  dynamic _closingFilled;
  dynamic _closingEmpty;
  dynamic _closingDef;
  dynamic _sVConsStr;
  dynamic _PSVIdStr;
  dynamic _TVConsStr;
  dynamic _SVQtyStr;
  dynamic _TVQtyStr;
  dynamic _ImbForIdStr;
  dynamic _ImbQtyStr;
  dynamic _DMImbQty;
  dynamic _FlagColumnUpdate;

  ItemList copyWith({
    dynamic SaleGKItemId,
    dynamic itemId,
    dynamic itemName,
    dynamic filledSaleQty,
    dynamic sVQty,
    dynamic tVQty,
    dynamic emptyRetQty,
    dynamic deffQty,
    dynamic lessEmptyQty,
    dynamic remark,
    dynamic closingFilled,
    dynamic closingEmpty,
    dynamic closingDef,
    dynamic sVConsStr,
    dynamic PSVIdStr,
    dynamic TVConsStr,
    dynamic SVQtyStr,
    dynamic TVQtyStr,
    dynamic ImbForIdStr,
    dynamic ImbQtyStr,
    dynamic DMImbQty,
    dynamic FlagColumnUpdate,
  }) =>
      ItemList(
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
        PSVIdStr: PSVIdStr ?? _PSVIdStr,
        TVConsStr: TVConsStr ?? _TVConsStr,
        SVQtyStr: SVQtyStr ?? _SVQtyStr,
        TVQtyStr: TVQtyStr ?? _TVQtyStr,
        ImbForIdStr: ImbForIdStr ?? _ImbForIdStr,
        ImbQtyStr: ImbQtyStr ?? _ImbQtyStr,
        DMImbQty: DMImbQty ?? _DMImbQty,
        FlagColumnUpdate: FlagColumnUpdate ?? _FlagColumnUpdate,
      );

  dynamic get SaleGKItemId => _SaleGKItemId;
  dynamic get itemId => _itemId;
  dynamic get itemName => _itemName;
  dynamic get filledSaleQty => _filledSaleQty;
  dynamic get sVQty => _sVQty;
  dynamic get tVQty => _tVQty;
  dynamic get emptyRetQty => _emptyRetQty;
  dynamic get deffQty => _deffQty;
  dynamic get lessEmptyQty => _lessEmptyQty;
  dynamic get remark => _remark;
  dynamic get closingFilled => _closingFilled;
  dynamic get closingEmpty => _closingEmpty;
  dynamic get closingDef => _closingDef;
  dynamic get sVConsStr => _sVConsStr;
  dynamic get PSVIdStr => _PSVIdStr;
  dynamic get TVConsStr => _TVConsStr;
  dynamic get SVQtyStr => _SVQtyStr;
  dynamic get TVQtyStr => _TVQtyStr;
  dynamic get ImbForIdStr => _ImbForIdStr;
  dynamic get ImbQtyStr => _ImbQtyStr;
  dynamic get DMImbQty => _DMImbQty;
  dynamic get FlagColumnUpdate => _FlagColumnUpdate;

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
    map['PSVIdStr'] = _PSVIdStr;
    map['TVConsStr'] = _TVConsStr;
    map['SVQtyStr'] = _SVQtyStr;
    map['TVQtyStr'] = _TVQtyStr;
    map['ImbForIdStr'] = _ImbForIdStr;
    map['ImbQtyStr'] = _ImbQtyStr;
    map['DMImbQty'] = _DMImbQty;
    map['FlagColumnUpdate'] = _FlagColumnUpdate;
    return map;
  }

  num? parseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    return num.tryParse(value.toString());
  }
}