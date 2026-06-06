/// PkId : 87
/// CustomerId : 57
/// CustomerName : "Eternia"
/// DistributorId : 8118
/// ItemId : 1
/// ItemName : "14.2 KG"
/// RSP_Price : 855.50
/// Discount : 10.00
/// EffectiveDate : "2025-09-15T05:51:32.237"

class GetConsumerDiscountDetailCredit {
  GetConsumerDiscountDetailCredit({
    num? pkId,
    num? customerId,
    String? customerName,
    num? distributorId,
    num? itemId,
    String? itemName,
    num? rSPPrice,
    num? discount,
    String? effectiveDate,}){
    _pkId = pkId;
    _customerId = customerId;
    _customerName = customerName;
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _rSPPrice = rSPPrice;
    _discount = discount;
    _effectiveDate = effectiveDate;
  }

  GetConsumerDiscountDetailCredit.fromJson(dynamic json) {
    _pkId = json['PkId'];
    _customerId = json['CustomerId'];
    _customerName = json['CustomerName'];
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _rSPPrice = json['RSP_Price'];
    _discount = json['Discount'];
    _effectiveDate = json['EffectiveDate'];
  }
  num? _pkId;
  num? _customerId;
  String? _customerName;
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _rSPPrice;
  num? _discount;
  String? _effectiveDate;
  GetConsumerDiscountDetailCredit copyWith({  num? pkId,
    num? customerId,
    String? customerName,
    num? distributorId,
    num? itemId,
    String? itemName,
    num? rSPPrice,
    num? discount,
    String? effectiveDate,
  }) => GetConsumerDiscountDetailCredit(  pkId: pkId ?? _pkId,
    customerId: customerId ?? _customerId,
    customerName: customerName ?? _customerName,
    distributorId: distributorId ?? _distributorId,
    itemId: itemId ?? _itemId,
    itemName: itemName ?? _itemName,
    rSPPrice: rSPPrice ?? _rSPPrice,
    discount: discount ?? _discount,
    effectiveDate: effectiveDate ?? _effectiveDate,
  );
  num? get pkId => _pkId;
  num? get customerId => _customerId;
  String? get customerName => _customerName;
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get rSPPrice => _rSPPrice;
  num? get discount => _discount;
  String? get effectiveDate => _effectiveDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PkId'] = _pkId;
    map['CustomerId'] = _customerId;
    map['CustomerName'] = _customerName;
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['RSP_Price'] = _rSPPrice;
    map['Discount'] = _discount;
    map['EffectiveDate'] = _effectiveDate;
    return map;
  }

}