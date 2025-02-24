/// DistributorId : 8118
/// GodownId : 0
/// Date : "0001-01-01T00:00:00"
/// ItemId : 1
/// ItemName : "14.2 KG"
/// Action : null
/// AddedBy : 0
/// CurrentStkFilled : 1545
/// CurrentStkEmpty : 2146
/// StkUpdateDate : "0001-01-01T00:00:00"
/// CurrentStkDefective : 4
/// FilledCD : 1547
/// EmptyCD : 1545
/// DefectiveCD : 4
/// FilledDiff : -2
/// EmptyDiff : 601
/// DefectiveDiff : 0
/// Total : 599
/// StockUpdatedOn : "17/02/2025 17:13"

  class ManagerDsrReportCdcmsListModel {
    ManagerDsrReportCdcmsListModel({
        num? distributorId,
        num? godownId,
        String? date,
        num? itemId,
        String? itemName,
        dynamic action,
        num? addedBy,
        num? currentStkFilled,
        num? currentStkEmpty,
        String? stkUpdateDate,
        num? currentStkDefective,
        num? filledCD,
        num? emptyCD,
        num? defectiveCD,
        num? filledDiff,
        num? emptyDiff,
        num? defectiveDiff,
        num? total,
        String? stockUpdatedOn,}){
      _distributorId = distributorId;
      _godownId = godownId;
      _date = date;
      _itemId = itemId;
      _itemName = itemName;
      _action = action;
      _addedBy = addedBy;
      _currentStkFilled = currentStkFilled;
      _currentStkEmpty = currentStkEmpty;
      _stkUpdateDate = stkUpdateDate;
      _currentStkDefective = currentStkDefective;
      _filledCD = filledCD;
      _emptyCD = emptyCD;
      _defectiveCD = defectiveCD;
      _filledDiff = filledDiff;
      _emptyDiff = emptyDiff;
      _defectiveDiff = defectiveDiff;
      _total = total;
      _stockUpdatedOn = stockUpdatedOn;
  }

    ManagerDsrReportCdcmsListModel.fromJson(dynamic json) {
      _distributorId = json['DistributorId'];
      _godownId = json['GodownId'];
      _date = json['Date'];
      _itemId = json['ItemId'];
      _itemName = json['ItemName'];
      _action = json['Action'];
      _addedBy = json['AddedBy'];
      _currentStkFilled = json['CurrentStkFilled'];
      _currentStkEmpty = json['CurrentStkEmpty'];
      _stkUpdateDate = json['StkUpdateDate'];
      _currentStkDefective = json['CurrentStkDefective'];
      _filledCD = json['FilledCD'];
      _emptyCD = json['EmptyCD'];
      _defectiveCD = json['DefectiveCD'];
      _filledDiff = json['FilledDiff'];
      _emptyDiff = json['EmptyDiff'];
      _defectiveDiff = json['DefectiveDiff'];
      _total = json['Total'];
      _stockUpdatedOn = json['StockUpdatedOn'];
    }
    num? _distributorId;
    num? _godownId;
    String? _date;
    num? _itemId;
    String? _itemName;
    dynamic _action;
    num? _addedBy;
    num? _currentStkFilled;
    num? _currentStkEmpty;
    String? _stkUpdateDate;
    num? _currentStkDefective;
    num? _filledCD;
    num? _emptyCD;
    num? _defectiveCD;
    num? _filledDiff;
    num? _emptyDiff;
    num? _defectiveDiff;
    num? _total;
    String? _stockUpdatedOn;
  ManagerDsrReportCdcmsListModel copyWith({  num? distributorId,
    num? godownId,
    String? date,
    num? itemId,
    String? itemName,
    dynamic action,
    num? addedBy,
    num? currentStkFilled,
    num? currentStkEmpty,
    String? stkUpdateDate,
    num? currentStkDefective,
    num? filledCD,
    num? emptyCD,
    num? defectiveCD,
    num? filledDiff,
    num? emptyDiff,
    num? defectiveDiff,
    num? total,
    String? stockUpdatedOn,
  }) => ManagerDsrReportCdcmsListModel(  distributorId: distributorId ?? _distributorId,
    godownId: godownId ?? _godownId,
    date: date ?? _date,
    itemId: itemId ?? _itemId,
    itemName: itemName ?? _itemName,
    action: action ?? _action,
    addedBy: addedBy ?? _addedBy,
    currentStkFilled: currentStkFilled ?? _currentStkFilled,
    currentStkEmpty: currentStkEmpty ?? _currentStkEmpty,
    stkUpdateDate: stkUpdateDate ?? _stkUpdateDate,
    currentStkDefective: currentStkDefective ?? _currentStkDefective,
    filledCD: filledCD ?? _filledCD,
    emptyCD: emptyCD ?? _emptyCD,
    defectiveCD: defectiveCD ?? _defectiveCD,
    filledDiff: filledDiff ?? _filledDiff,
    emptyDiff: emptyDiff ?? _emptyDiff,
    defectiveDiff: defectiveDiff ?? _defectiveDiff,
    total: total ?? _total,
    stockUpdatedOn: stockUpdatedOn ?? _stockUpdatedOn,
  );
    num? get distributorId => _distributorId;
    num? get godownId => _godownId;
    String? get date => _date;
    num? get itemId => _itemId;
    String? get itemName => _itemName;
    dynamic get action => _action;
    num? get addedBy => _addedBy;
    num? get currentStkFilled => _currentStkFilled;
    num? get currentStkEmpty => _currentStkEmpty;
    String? get stkUpdateDate => _stkUpdateDate;
    num? get currentStkDefective => _currentStkDefective;
    num? get filledCD => _filledCD;
    num? get emptyCD => _emptyCD;
    num? get defectiveCD => _defectiveCD;
    num? get filledDiff => _filledDiff;
    num? get emptyDiff => _emptyDiff;
    num? get defectiveDiff => _defectiveDiff;
    num? get total => _total;
    String? get stockUpdatedOn => _stockUpdatedOn;

    Map<String, dynamic> toJson() {
      final map = <String, dynamic>{};
      map['DistributorId'] = _distributorId;
      map['GodownId'] = _godownId;
      map['Date'] = _date;
      map['ItemId'] = _itemId;
      map['ItemName'] = _itemName;
      map['Action'] = _action;
      map['AddedBy'] = _addedBy;
      map['CurrentStkFilled'] = _currentStkFilled;
      map['CurrentStkEmpty'] = _currentStkEmpty;
      map['StkUpdateDate'] = _stkUpdateDate;
      map['CurrentStkDefective'] = _currentStkDefective;
      map['FilledCD'] = _filledCD;
      map['EmptyCD'] = _emptyCD;
      map['DefectiveCD'] = _defectiveCD;
      map['FilledDiff'] = _filledDiff;
      map['EmptyDiff'] = _emptyDiff;
      map['DefectiveDiff'] = _defectiveDiff;
      map['Total'] = _total;
      map['StockUpdatedOn'] = _stockUpdatedOn;
      return map;
    }

  }