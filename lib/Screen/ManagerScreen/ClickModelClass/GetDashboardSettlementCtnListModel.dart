/// DistributorId : 8118
/// ConsumerNo : "660990"
/// ConsumerName : "Mr. Priyabrata Mondal"
/// OrderDate : "05-04-2025"
/// DeliveryDate : "null"
/// PaymentDate : "05-04-2025"
/// SettlementDate : "09-04-2025"

class GetDashboardSettlementCtnListModel {
  GetDashboardSettlementCtnListModel({
      num? distributorId, 
      String? consumerNo, 
      String? consumerName, 
      String? orderDate, 
      String? deliveryDate, 
      String? paymentDate, 
      String? settlementDate,}){
    _distributorId = distributorId;
    _consumerNo = consumerNo;
    _consumerName = consumerName;
    _orderDate = orderDate;
    _deliveryDate = deliveryDate;
    _paymentDate = paymentDate;
    _settlementDate = settlementDate;
}

  GetDashboardSettlementCtnListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _consumerNo = json['ConsumerNo'];
    _consumerName = json['ConsumerName'];
    _orderDate = json['OrderDate'];
    _deliveryDate = json['DeliveryDate'];
    _paymentDate = json['PaymentDate'];
    _settlementDate = json['SettlementDate'];
  }
  num? _distributorId;
  String? _consumerNo;
  String? _consumerName;
  String? _orderDate;
  String? _deliveryDate;
  String? _paymentDate;
  String? _settlementDate;
GetDashboardSettlementCtnListModel copyWith({  num? distributorId,
  String? consumerNo,
  String? consumerName,
  String? orderDate,
  String? deliveryDate,
  String? paymentDate,
  String? settlementDate,
}) => GetDashboardSettlementCtnListModel(  distributorId: distributorId ?? _distributorId,
  consumerNo: consumerNo ?? _consumerNo,
  consumerName: consumerName ?? _consumerName,
  orderDate: orderDate ?? _orderDate,
  deliveryDate: deliveryDate ?? _deliveryDate,
  paymentDate: paymentDate ?? _paymentDate,
  settlementDate: settlementDate ?? _settlementDate,
);
  num? get distributorId => _distributorId;
  String? get consumerNo => _consumerNo;
  String? get consumerName => _consumerName;
  String? get orderDate => _orderDate;
  String? get deliveryDate => _deliveryDate;
  String? get paymentDate => _paymentDate;
  String? get settlementDate => _settlementDate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ConsumerNo'] = _consumerNo;
    map['ConsumerName'] = _consumerName;
    map['OrderDate'] = _orderDate;
    map['DeliveryDate'] = _deliveryDate;
    map['PaymentDate'] = _paymentDate;
    map['SettlementDate'] = _settlementDate;
    return map;
  }

}