/// DistributorId : 8118
/// StampDuty : 100.0

class GetDistStampDutyModel {
  GetDistStampDutyModel({
      num? distributorId, 
      num? stampDuty,}){
    _distributorId = distributorId;
    _stampDuty = stampDuty;
}

  GetDistStampDutyModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _stampDuty = json['StampDuty'];
  }
  num? _distributorId;
  num? _stampDuty;
GetDistStampDutyModel copyWith({  num? distributorId,
  num? stampDuty,
}) => GetDistStampDutyModel(  distributorId: distributorId ?? _distributorId,
  stampDuty: stampDuty ?? _stampDuty,
);
  num? get distributorId => _distributorId;
  num? get stampDuty => _stampDuty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['StampDuty'] = _stampDuty;
    return map;
  }

}