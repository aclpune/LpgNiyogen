/// CustomerId : 60
/// DistributorId : 8118
/// ItemId : 3
/// ItemName : "19 KG"
/// Discount : 20.00
/// EffectiveDate : "2025-05-19T14:21:57"

class GetConsumerCurrentDiscountDetailForCredtModel {
  GetConsumerCurrentDiscountDetailForCredtModel({
      num? customerId, 
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? discount, 
      String? effectiveDate,}){
    _customerId = customerId;
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _discount = discount;
    _effectiveDate = effectiveDate;
}

  GetConsumerCurrentDiscountDetailForCredtModel.fromJson(dynamic json) {
    _customerId = json['CustomerId'];
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _discount = json['Discount'];
    _effectiveDate = json['EffectiveDate'];
  }
  num? _customerId;
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _discount;
  String? _effectiveDate;
GetConsumerCurrentDiscountDetailForCredtModel copyWith({  num? customerId,
  num? distributorId,
  num? itemId,
  String? itemName,
  num? discount,
  String? effectiveDate,
}) => GetConsumerCurrentDiscountDetailForCredtModel(  customerId: customerId ?? _customerId,
  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  discount: discount ?? _discount,
  effectiveDate: effectiveDate ?? _effectiveDate,
);
  num? get customerId => _customerId;
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get discount => _discount;
  String? get effectiveDate => _effectiveDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['CustomerId'] = _customerId;
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['Discount'] = _discount;
    map['EffectiveDate'] = _effectiveDate;
    return map;
  }

}