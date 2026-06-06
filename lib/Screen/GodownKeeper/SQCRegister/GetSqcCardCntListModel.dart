/// TodayTruckIn : 0
/// TodaySQCDone : 2
/// TodayNotDone : -2
/// TodayBodyLeak : 2
/// TodayLessQtyCyls : 0
/// MonthTruckIn : 4
/// MonthSQCDone : 17
/// MonthNotDone : -13
/// MonthBodyLeak : 15
/// MonthLessQtyCyls : 0
/// VehicleNo : ""
/// SQCStatus : ""

class GetSqcCardCntListModel {
  GetSqcCardCntListModel({
    num? todayTruckIn,
    num? todaySQCDone,
    num? todayNotDone,
    num? todayBodyLeak,
    num? todayLessQtyCyls,
    num? monthTruckIn,
    num? monthSQCDone,
    num? monthNotDone,
    num? monthBodyLeak,
    num? monthLessQtyCyls,
    String? vehicleNo,
    String? sQCStatus,}){
    _todayTruckIn = todayTruckIn;
    _todaySQCDone = todaySQCDone;
    _todayNotDone = todayNotDone;
    _todayBodyLeak = todayBodyLeak;
    _todayLessQtyCyls = todayLessQtyCyls;
    _monthTruckIn = monthTruckIn;
    _monthSQCDone = monthSQCDone;
    _monthNotDone = monthNotDone;
    _monthBodyLeak = monthBodyLeak;
    _monthLessQtyCyls = monthLessQtyCyls;
    _vehicleNo = vehicleNo;
    _sQCStatus = sQCStatus;
  }

  GetSqcCardCntListModel.fromJson(dynamic json) {
    _todayTruckIn = json['TodayTruckIn'];
    _todaySQCDone = json['TodaySQCDone'];
    _todayNotDone = json['TodayNotDone'];
    _todayBodyLeak = json['TodayBodyLeak'];
    _todayLessQtyCyls = json['TodayLessQtyCyls'];
    _monthTruckIn = json['MonthTruckIn'];
    _monthSQCDone = json['MonthSQCDone'];
    _monthNotDone = json['MonthNotDone'];
    _monthBodyLeak = json['MonthBodyLeak'];
    _monthLessQtyCyls = json['MonthLessQtyCyls'];
    _vehicleNo = json['VehicleNo'];
    _sQCStatus = json['SQCStatus'];
  }
  num? _todayTruckIn;
  num? _todaySQCDone;
  num? _todayNotDone;
  num? _todayBodyLeak;
  num? _todayLessQtyCyls;
  num? _monthTruckIn;
  num? _monthSQCDone;
  num? _monthNotDone;
  num? _monthBodyLeak;
  num? _monthLessQtyCyls;
  String? _vehicleNo;
  String? _sQCStatus;
  GetSqcCardCntListModel copyWith({  num? todayTruckIn,
    num? todaySQCDone,
    num? todayNotDone,
    num? todayBodyLeak,
    num? todayLessQtyCyls,
    num? monthTruckIn,
    num? monthSQCDone,
    num? monthNotDone,
    num? monthBodyLeak,
    num? monthLessQtyCyls,
    String? vehicleNo,
    String? sQCStatus,
  }) => GetSqcCardCntListModel(  todayTruckIn: todayTruckIn ?? _todayTruckIn,
    todaySQCDone: todaySQCDone ?? _todaySQCDone,
    todayNotDone: todayNotDone ?? _todayNotDone,
    todayBodyLeak: todayBodyLeak ?? _todayBodyLeak,
    todayLessQtyCyls: todayLessQtyCyls ?? _todayLessQtyCyls,
    monthTruckIn: monthTruckIn ?? _monthTruckIn,
    monthSQCDone: monthSQCDone ?? _monthSQCDone,
    monthNotDone: monthNotDone ?? _monthNotDone,
    monthBodyLeak: monthBodyLeak ?? _monthBodyLeak,
    monthLessQtyCyls: monthLessQtyCyls ?? _monthLessQtyCyls,
    vehicleNo: vehicleNo ?? _vehicleNo,
    sQCStatus: sQCStatus ?? _sQCStatus,
  );
  num? get todayTruckIn => _todayTruckIn;
  num? get todaySQCDone => _todaySQCDone;
  num? get todayNotDone => _todayNotDone;
  num? get todayBodyLeak => _todayBodyLeak;
  num? get todayLessQtyCyls => _todayLessQtyCyls;
  num? get monthTruckIn => _monthTruckIn;
  num? get monthSQCDone => _monthSQCDone;
  num? get monthNotDone => _monthNotDone;
  num? get monthBodyLeak => _monthBodyLeak;
  num? get monthLessQtyCyls => _monthLessQtyCyls;
  String? get vehicleNo => _vehicleNo;
  String? get sQCStatus => _sQCStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['TodayTruckIn'] = _todayTruckIn;
    map['TodaySQCDone'] = _todaySQCDone;
    map['TodayNotDone'] = _todayNotDone;
    map['TodayBodyLeak'] = _todayBodyLeak;
    map['TodayLessQtyCyls'] = _todayLessQtyCyls;
    map['MonthTruckIn'] = _monthTruckIn;
    map['MonthSQCDone'] = _monthSQCDone;
    map['MonthNotDone'] = _monthNotDone;
    map['MonthBodyLeak'] = _monthBodyLeak;
    map['MonthLessQtyCyls'] = _monthLessQtyCyls;
    map['VehicleNo'] = _vehicleNo;
    map['SQCStatus'] = _sQCStatus;
    return map;
  }

}