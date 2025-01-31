/// DistributorId : 8118
/// GodownId : 1
/// StockDate : "2025-01-10T00:00:00"
/// ItemId : 1
/// ItemName : "14.2 kg"
/// FilledOpeningStk : 400
/// EmptyOpeningStk : 220
/// DefOpeningStk : 15
/// TotalOpeningStk : 635

class TodaysOpeningStockDataModel {
  TodaysOpeningStockDataModel({
      num? distributorId, 
      num? godownId, 
      String? stockDate, 
      num? itemId, 
      String? itemName, 
      num? filledOpeningStk, 
      num? emptyOpeningStk, 
      num? defOpeningStk, 
      num? totalOpeningStk,}){
    _distributorId = distributorId;
    _godownId = godownId;
    _stockDate = stockDate;
    _itemId = itemId;
    _itemName = itemName;
    _filledOpeningStk = filledOpeningStk;
    _emptyOpeningStk = emptyOpeningStk;
    _defOpeningStk = defOpeningStk;
    _totalOpeningStk = totalOpeningStk;
}

  TodaysOpeningStockDataModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _godownId = json['GodownId'];
    _stockDate = json['StockDate'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _filledOpeningStk = json['FilledOpeningStk'];
    _emptyOpeningStk = json['EmptyOpeningStk'];
    _defOpeningStk = json['DefOpeningStk'];
    _totalOpeningStk = json['TotalOpeningStk'];
  }
  num? _distributorId;
  num? _godownId;
  String? _stockDate;
  num? _itemId;
  String? _itemName;
  num? _filledOpeningStk;
  num? _emptyOpeningStk;
  num? _defOpeningStk;
  num? _totalOpeningStk;
TodaysOpeningStockDataModel copyWith({  num? distributorId,
  num? godownId,
  String? stockDate,
  num? itemId,
  String? itemName,
  num? filledOpeningStk,
  num? emptyOpeningStk,
  num? defOpeningStk,
  num? totalOpeningStk,
}) => TodaysOpeningStockDataModel(  distributorId: distributorId ?? _distributorId,
  godownId: godownId ?? _godownId,
  stockDate: stockDate ?? _stockDate,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  filledOpeningStk: filledOpeningStk ?? _filledOpeningStk,
  emptyOpeningStk: emptyOpeningStk ?? _emptyOpeningStk,
  defOpeningStk: defOpeningStk ?? _defOpeningStk,
  totalOpeningStk: totalOpeningStk ?? _totalOpeningStk,
);
  num? get distributorId => _distributorId;
  num? get godownId => _godownId;
  String? get stockDate => _stockDate;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get filledOpeningStk => _filledOpeningStk;
  num? get emptyOpeningStk => _emptyOpeningStk;
  num? get defOpeningStk => _defOpeningStk;
  num? get totalOpeningStk => _totalOpeningStk;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['GodownId'] = _godownId;
    map['StockDate'] = _stockDate;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['FilledOpeningStk'] = _filledOpeningStk;
    map['EmptyOpeningStk'] = _emptyOpeningStk;
    map['DefOpeningStk'] = _defOpeningStk;
    map['TotalOpeningStk'] = _totalOpeningStk;
    return map;
  }

}