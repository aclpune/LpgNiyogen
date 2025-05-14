/// DistributorId : 0
/// LastUploadedDatePrepaidBkg : "0001-01-01T00:00:00"
/// LastUploadedDatePrepaidBkgSettle : "0001-01-01T00:00:00"
/// BkgHrDiff : 1
/// SettHrDiff : 1

class GetLastUploadedFrileDifferenceModel {
  GetLastUploadedFrileDifferenceModel({
      num? distributorId, 
      String? lastUploadedDatePrepaidBkg, 
      String? lastUploadedDatePrepaidBkgSettle, 
      num? bkgHrDiff, 
      num? settHrDiff,}){
    _distributorId = distributorId;
    _lastUploadedDatePrepaidBkg = lastUploadedDatePrepaidBkg;
    _lastUploadedDatePrepaidBkgSettle = lastUploadedDatePrepaidBkgSettle;
    _bkgHrDiff = bkgHrDiff;
    _settHrDiff = settHrDiff;
}

  GetLastUploadedFrileDifferenceModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _lastUploadedDatePrepaidBkg = json['LastUploadedDatePrepaidBkg'];
    _lastUploadedDatePrepaidBkgSettle = json['LastUploadedDatePrepaidBkgSettle'];
    _bkgHrDiff = json['BkgHrDiff'];
    _settHrDiff = json['SettHrDiff'];
  }
  num? _distributorId;
  String? _lastUploadedDatePrepaidBkg;
  String? _lastUploadedDatePrepaidBkgSettle;
  num? _bkgHrDiff;
  num? _settHrDiff;
GetLastUploadedFrileDifferenceModel copyWith({  num? distributorId,
  String? lastUploadedDatePrepaidBkg,
  String? lastUploadedDatePrepaidBkgSettle,
  num? bkgHrDiff,
  num? settHrDiff,
}) => GetLastUploadedFrileDifferenceModel(  distributorId: distributorId ?? _distributorId,
  lastUploadedDatePrepaidBkg: lastUploadedDatePrepaidBkg ?? _lastUploadedDatePrepaidBkg,
  lastUploadedDatePrepaidBkgSettle: lastUploadedDatePrepaidBkgSettle ?? _lastUploadedDatePrepaidBkgSettle,
  bkgHrDiff: bkgHrDiff ?? _bkgHrDiff,
  settHrDiff: settHrDiff ?? _settHrDiff,
);
  num? get distributorId => _distributorId;
  String? get lastUploadedDatePrepaidBkg => _lastUploadedDatePrepaidBkg;
  String? get lastUploadedDatePrepaidBkgSettle => _lastUploadedDatePrepaidBkgSettle;
  num? get bkgHrDiff => _bkgHrDiff;
  num? get settHrDiff => _settHrDiff;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['LastUploadedDatePrepaidBkg'] = _lastUploadedDatePrepaidBkg;
    map['LastUploadedDatePrepaidBkgSettle'] = _lastUploadedDatePrepaidBkgSettle;
    map['BkgHrDiff'] = _bkgHrDiff;
    map['SettHrDiff'] = _settHrDiff;
    return map;
  }

}