/// DefId : 8
/// DistributorId : 8118
/// DefDate : "2025-03-20T12:45:00"
/// ItemId : 1
/// DefQty : 2
/// Remark : "Test Defective"
/// Action : null
/// ItemName : "14.2 kg"
/// AddedBy : 0
/// GodownId : 1

// class GetDefectiveStockListModel {
//   GetDefectiveStockListModel({
//       num? defId,
//       num? distributorId,
//       String? defDate,
//       num? itemId,
//       num? defQty,
//       String? remark,
//       dynamic action,
//       String? itemName,
//       num? addedBy,
//       num? godownId,}){
//     _defId = defId;
//     _distributorId = distributorId;
//     _defDate = defDate;
//     _itemId = itemId;
//     _defQty = defQty;
//     _remark = remark;
//     _action = action;
//     _itemName = itemName;
//     _addedBy = addedBy;
//     _godownId = godownId;
// }
//
//   GetDefectiveStockListModel.fromJson(dynamic json) {
//     _defId = json['DefId'];
//     _distributorId = json['DistributorId'];
//     _defDate = json['DefDate'];
//     _itemId = json['ItemId'];
//     _defQty = json['DefQty'];
//     _remark = json['Remark'];
//     _action = json['Action'];
//     _itemName = json['ItemName'];
//     _addedBy = json['AddedBy'];
//     _godownId = json['GodownId'];
//   }
//   num? _defId;
//   num? _distributorId;
//   String? _defDate;
//   num? _itemId;
//   num? _defQty;
//   String? _remark;
//   dynamic _action;
//   String? _itemName;
//   num? _addedBy;
//   num? _godownId;
// GetDefectiveStockListModel copyWith({  num? defId,
//   num? distributorId,
//   String? defDate,
//   num? itemId,
//   num? defQty,
//   String? remark,
//   dynamic action,
//   String? itemName,
//   num? addedBy,
//   num? godownId,
// }) => GetDefectiveStockListModel(  defId: defId ?? _defId,
//   distributorId: distributorId ?? _distributorId,
//   defDate: defDate ?? _defDate,
//   itemId: itemId ?? _itemId,
//   defQty: defQty ?? _defQty,
//   remark: remark ?? _remark,
//   action: action ?? _action,
//   itemName: itemName ?? _itemName,
//   addedBy: addedBy ?? _addedBy,
//   godownId: godownId ?? _godownId,
// );
//   num? get defId => _defId;
//   num? get distributorId => _distributorId;
//   String? get defDate => _defDate;
//   num? get itemId => _itemId;
//   num? get defQty => _defQty;
//   String? get remark => _remark;
//   dynamic get action => _action;
//   String? get itemName => _itemName;
//   num? get addedBy => _addedBy;
//   num? get godownId => _godownId;
//
//   Map<String, dynamic> toJson() {
//     final map = <String, dynamic>{};
//     map['DefId'] = _defId;
//     map['DistributorId'] = _distributorId;
//     map['DefDate'] = _defDate;
//     map['ItemId'] = _itemId;
//     map['DefQty'] = _defQty;
//     map['Remark'] = _remark;
//     map['Action'] = _action;
//     map['ItemName'] = _itemName;
//     map['AddedBy'] = _addedBy;
//     map['GodownId'] = _godownId;
//     return map;
//   }
//
// }

class GetDefectiveStockListModel {
  // `defId` is dynamic because the API may return it as num OR String.
  // All other numeric fields are typed as num? for safety (int + double).
  dynamic defId;
  num? distributorId;
  String? defDate;
  num? itemId;
  num? defQty;
  String? remark;
  String? action;
  String? itemName;
  num? addedBy;
  num? godownId;

  GetDefectiveStockListModel({
    this.defId,
    this.distributorId,
    this.defDate,
    this.itemId,
    this.defQty,
    this.remark,
    this.action,
    this.itemName,
    this.addedBy,
    this.godownId,
  });

  factory GetDefectiveStockListModel.fromJson(Map<String, dynamic> json) {
    return GetDefectiveStockListModel(
      // Store as-is: could be num or String depending on API response.
      defId: json['DefId'],
      distributorId: json['DistributorId'] as num?,
      defDate: json['DefDate'] as String?,
      itemId: json['ItemId'] as num?,
      defQty: json['DefQty'] as num?,
      remark: json['Remark'] as String?,
      action: json['Action'] as String?,
      itemName: json['ItemName'] as String?,
      addedBy: json['AddedBy'] as num?,
      godownId: json['GodownId'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DefId': defId,
      'DistributorId': distributorId,
      'DefDate': defDate,
      'ItemId': itemId,
      'DefQty': defQty,
      'Remark': remark,
      'Action': action,
      'ItemName': itemName,
      'AddedBy': addedBy,
      'GodownId': godownId,
    };
  }

  GetDefectiveStockListModel copyWith({
    dynamic defId,
    num? distributorId,
    String? defDate,
    num? itemId,
    num? defQty,
    String? remark,
    String? action,
    String? itemName,
    num? addedBy,
    num? godownId,
  }) {
    return GetDefectiveStockListModel(
      defId: defId ?? this.defId,
      distributorId: distributorId ?? this.distributorId,
      defDate: defDate ?? this.defDate,
      itemId: itemId ?? this.itemId,
      defQty: defQty ?? this.defQty,
      remark: remark ?? this.remark,
      action: action ?? this.action,
      itemName: itemName ?? this.itemName,
      addedBy: addedBy ?? this.addedBy,
      godownId: godownId ?? this.godownId,
    );
  }
}