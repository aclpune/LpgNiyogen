/// DistributorId : 8118
/// SVGrossRevenue : 472.00
/// ARBGrossRevenue : 27147.00
/// ARBGrossProfit : -43553.00
/// RefillGrossRevenue : 191342.50
/// RefillGrossProfit : 27875.00

class GetSvarbManagerDashboardCountModel {
  GetSvarbManagerDashboardCountModel({
      num? distributorId, 
      num? sVGrossRevenue, 
      num? aRBGrossRevenue, 
      num? aRBGrossProfit, 
      num? refillGrossRevenue, 
      num? refillGrossProfit,}){
    _distributorId = distributorId;
    _sVGrossRevenue = sVGrossRevenue;
    _aRBGrossRevenue = aRBGrossRevenue;
    _aRBGrossProfit = aRBGrossProfit;
    _refillGrossRevenue = refillGrossRevenue;
    _refillGrossProfit = refillGrossProfit;
}

  GetSvarbManagerDashboardCountModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _sVGrossRevenue = json['SVGrossRevenue'];
    _aRBGrossRevenue = json['ARBGrossRevenue'];
    _aRBGrossProfit = json['ARBGrossProfit'];
    _refillGrossRevenue = json['RefillGrossRevenue'];
    _refillGrossProfit = json['RefillGrossProfit'];
  }
  num? _distributorId;
  num? _sVGrossRevenue;
  num? _aRBGrossRevenue;
  num? _aRBGrossProfit;
  num? _refillGrossRevenue;
  num? _refillGrossProfit;
GetSvarbManagerDashboardCountModel copyWith({  num? distributorId,
  num? sVGrossRevenue,
  num? aRBGrossRevenue,
  num? aRBGrossProfit,
  num? refillGrossRevenue,
  num? refillGrossProfit,
}) => GetSvarbManagerDashboardCountModel(  distributorId: distributorId ?? _distributorId,
  sVGrossRevenue: sVGrossRevenue ?? _sVGrossRevenue,
  aRBGrossRevenue: aRBGrossRevenue ?? _aRBGrossRevenue,
  aRBGrossProfit: aRBGrossProfit ?? _aRBGrossProfit,
  refillGrossRevenue: refillGrossRevenue ?? _refillGrossRevenue,
  refillGrossProfit: refillGrossProfit ?? _refillGrossProfit,
);
  num? get distributorId => _distributorId;
  num? get sVGrossRevenue => _sVGrossRevenue;
  num? get aRBGrossRevenue => _aRBGrossRevenue;
  num? get aRBGrossProfit => _aRBGrossProfit;
  num? get refillGrossRevenue => _refillGrossRevenue;
  num? get refillGrossProfit => _refillGrossProfit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['SVGrossRevenue'] = _sVGrossRevenue;
    map['ARBGrossRevenue'] = _aRBGrossRevenue;
    map['ARBGrossProfit'] = _aRBGrossProfit;
    map['RefillGrossRevenue'] = _refillGrossRevenue;
    map['RefillGrossProfit'] = _refillGrossProfit;
    return map;
  }

}