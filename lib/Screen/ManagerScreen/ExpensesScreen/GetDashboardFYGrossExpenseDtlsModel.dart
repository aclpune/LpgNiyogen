/// April : 0.00
/// May : 0.00
/// June : 0.00
/// July : 0.00
/// August : 0.00
/// September : 0.00
/// October : 0.00
/// November : 0.00
/// December : 0.00
/// January : 0.00
/// February : 90593.00
/// March : 140314.00

class GetDashboardFyGrossExpenseDtlsModel {
  GetDashboardFyGrossExpenseDtlsModel({
      num? april, 
      num? may, 
      num? june, 
      num? july, 
      num? august, 
      num? september, 
      num? october, 
      num? november, 
      num? december, 
      num? january, 
      num? february, 
      num? march,}){
    _april = april;
    _may = may;
    _june = june;
    _july = july;
    _august = august;
    _september = september;
    _october = october;
    _november = november;
    _december = december;
    _january = january;
    _february = february;
    _march = march;
}

  GetDashboardFyGrossExpenseDtlsModel.fromJson(dynamic json) {
    _april = json['April'];
    _may = json['May'];
    _june = json['June'];
    _july = json['July'];
    _august = json['August'];
    _september = json['September'];
    _october = json['October'];
    _november = json['November'];
    _december = json['December'];
    _january = json['January'];
    _february = json['February'];
    _march = json['March'];
  }
  num? _april;
  num? _may;
  num? _june;
  num? _july;
  num? _august;
  num? _september;
  num? _october;
  num? _november;
  num? _december;
  num? _january;
  num? _february;
  num? _march;
GetDashboardFyGrossExpenseDtlsModel copyWith({  num? april,
  num? may,
  num? june,
  num? july,
  num? august,
  num? september,
  num? october,
  num? november,
  num? december,
  num? january,
  num? february,
  num? march,
}) => GetDashboardFyGrossExpenseDtlsModel(  april: april ?? _april,
  may: may ?? _may,
  june: june ?? _june,
  july: july ?? _july,
  august: august ?? _august,
  september: september ?? _september,
  october: october ?? _october,
  november: november ?? _november,
  december: december ?? _december,
  january: january ?? _january,
  february: february ?? _february,
  march: march ?? _march,
);
  num? get april => _april;
  num? get may => _may;
  num? get june => _june;
  num? get july => _july;
  num? get august => _august;
  num? get september => _september;
  num? get october => _october;
  num? get november => _november;
  num? get december => _december;
  num? get january => _january;
  num? get february => _february;
  num? get march => _march;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['April'] = _april;
    map['May'] = _may;
    map['June'] = _june;
    map['July'] = _july;
    map['August'] = _august;
    map['September'] = _september;
    map['October'] = _october;
    map['November'] = _november;
    map['December'] = _december;
    map['January'] = _january;
    map['February'] = _february;
    map['March'] = _march;
    return map;
  }

}