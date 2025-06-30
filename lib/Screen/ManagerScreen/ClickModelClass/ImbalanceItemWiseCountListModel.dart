/// DistributorId : 8118
/// DelDate : "0001-01-01T00:00:00"
/// DMId : 19
/// StaffName : "CHRISTINA ALOTKAR"
/// ItemId : 3
/// ItemName : "19 KG"
/// ImbalanceQty : 20
/// ImbRecQty : 0
/// StaffId : 0

class ImbalanceItemWiseCountListModel {
  ImbalanceItemWiseCountListModel({
      num? distributorId, 
      String? delDate, 
      num? dMId, 
      String? staffName, 
      num? itemId, 
      String? itemName, 
      num? imbalanceQty, 
      num? imbRecQty, 
      num? staffId,}){
    _distributorId = distributorId;
    _delDate = delDate;
    _dMId = dMId;
    _staffName = staffName;
    _itemId = itemId;
    _itemName = itemName;
    _imbalanceQty = imbalanceQty;
    _imbRecQty = imbRecQty;
    _staffId = staffId;
}

  ImbalanceItemWiseCountListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _delDate = json['DelDate'];
    _dMId = json['DMId'];
    _staffName = json['StaffName'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _imbalanceQty = json['ImbalanceQty'];
    _imbRecQty = json['ImbRecQty'];
    _staffId = json['StaffId'];
  }
  num? _distributorId;
  String? _delDate;
  num? _dMId;
  String? _staffName;
  num? _itemId;
  String? _itemName;
  num? _imbalanceQty;
  num? _imbRecQty;
  num? _staffId;
ImbalanceItemWiseCountListModel copyWith({  num? distributorId,
  String? delDate,
  num? dMId,
  String? staffName,
  num? itemId,
  String? itemName,
  num? imbalanceQty,
  num? imbRecQty,
  num? staffId,
}) => ImbalanceItemWiseCountListModel(  distributorId: distributorId ?? _distributorId,
  delDate: delDate ?? _delDate,
  dMId: dMId ?? _dMId,
  staffName: staffName ?? _staffName,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  imbalanceQty: imbalanceQty ?? _imbalanceQty,
  imbRecQty: imbRecQty ?? _imbRecQty,
  staffId: staffId ?? _staffId,
);
  num? get distributorId => _distributorId;
  String? get delDate => _delDate;
  num? get dMId => _dMId;
  String? get staffName => _staffName;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get imbalanceQty => _imbalanceQty;
  num? get imbRecQty => _imbRecQty;
  num? get staffId => _staffId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['DelDate'] = _delDate;
    map['DMId'] = _dMId;
    map['StaffName'] = _staffName;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['ImbalanceQty'] = _imbalanceQty;
    map['ImbRecQty'] = _imbRecQty;
    map['StaffId'] = _staffId;
    return map;
  }

}