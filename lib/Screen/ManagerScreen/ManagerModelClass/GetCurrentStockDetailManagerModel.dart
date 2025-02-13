/// DistributorId : 0
/// ItemId : 1
/// ItemName : "14.2 kg"
/// CurrentStkFilled : 0
/// CurrentStkEmpty : 0
/// FilledCnt : 0
/// TotalInvoiceCnt : 0
/// FilledEMRCnt : 0
/// EmptyTVCnt : 0
/// DefectivCnt : 7
/// DefectivFromDate : "2025-02-06T00:00:00"
/// EmptyCRDCnt : 0
/// EmptyDefectivCnt : 0
/// NCCnt : 0
/// DBCCnt : 0
/// RCCnt : 0
/// RefillSaleCnt : 0
/// ImbalanceCnt : 0
/// EmptyCnt : 0
/// TVQty : 0
/// SVQty : 0
/// DeffQty : 7

class GetCurrentStockDetailManagerModel {
  GetCurrentStockDetailManagerModel({
      num? distributorId, 
      num? itemId, 
      String? itemName, 
      num? currentStkFilled, 
      num? currentStkEmpty, 
      num? filledCnt, 
      num? totalInvoiceCnt, 
      num? filledEMRCnt, 
      num? emptyTVCnt, 
      num? defectivCnt, 
      String? defectivFromDate, 
      num? emptyCRDCnt, 
      num? emptyDefectivCnt, 
      num? nCCnt, 
      num? dBCCnt, 
      num? rCCnt, 
      num? refillSaleCnt, 
      num? imbalanceCnt, 
      num? emptyCnt, 
      num? tVQty, 
      num? sVQty, 
      num? deffQty,}){
    _distributorId = distributorId;
    _itemId = itemId;
    _itemName = itemName;
    _currentStkFilled = currentStkFilled;
    _currentStkEmpty = currentStkEmpty;
    _filledCnt = filledCnt;
    _totalInvoiceCnt = totalInvoiceCnt;
    _filledEMRCnt = filledEMRCnt;
    _emptyTVCnt = emptyTVCnt;
    _defectivCnt = defectivCnt;
    _defectivFromDate = defectivFromDate;
    _emptyCRDCnt = emptyCRDCnt;
    _emptyDefectivCnt = emptyDefectivCnt;
    _nCCnt = nCCnt;
    _dBCCnt = dBCCnt;
    _rCCnt = rCCnt;
    _refillSaleCnt = refillSaleCnt;
    _imbalanceCnt = imbalanceCnt;
    _emptyCnt = emptyCnt;
    _tVQty = tVQty;
    _sVQty = sVQty;
    _deffQty = deffQty;
}

  GetCurrentStockDetailManagerModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _itemId = json['ItemId'];
    _itemName = json['ItemName'];
    _currentStkFilled = json['CurrentStkFilled'];
    _currentStkEmpty = json['CurrentStkEmpty'];
    _filledCnt = json['FilledCnt'];
    _totalInvoiceCnt = json['TotalInvoiceCnt'];
    _filledEMRCnt = json['FilledEMRCnt'];
    _emptyTVCnt = json['EmptyTVCnt'];
    _defectivCnt = json['DefectivCnt'];
    _defectivFromDate = json['DefectivFromDate'];
    _emptyCRDCnt = json['EmptyCRDCnt'];
    _emptyDefectivCnt = json['EmptyDefectivCnt'];
    _nCCnt = json['NCCnt'];
    _dBCCnt = json['DBCCnt'];
    _rCCnt = json['RCCnt'];
    _refillSaleCnt = json['RefillSaleCnt'];
    _imbalanceCnt = json['ImbalanceCnt'];
    _emptyCnt = json['EmptyCnt'];
    _tVQty = json['TVQty'];
    _sVQty = json['SVQty'];
    _deffQty = json['DeffQty'];
  }
  num? _distributorId;
  num? _itemId;
  String? _itemName;
  num? _currentStkFilled;
  num? _currentStkEmpty;
  num? _filledCnt;
  num? _totalInvoiceCnt;
  num? _filledEMRCnt;
  num? _emptyTVCnt;
  num? _defectivCnt;
  String? _defectivFromDate;
  num? _emptyCRDCnt;
  num? _emptyDefectivCnt;
  num? _nCCnt;
  num? _dBCCnt;
  num? _rCCnt;
  num? _refillSaleCnt;
  num? _imbalanceCnt;
  num? _emptyCnt;
  num? _tVQty;
  num? _sVQty;
  num? _deffQty;
GetCurrentStockDetailManagerModel copyWith({  num? distributorId,
  num? itemId,
  String? itemName,
  num? currentStkFilled,
  num? currentStkEmpty,
  num? filledCnt,
  num? totalInvoiceCnt,
  num? filledEMRCnt,
  num? emptyTVCnt,
  num? defectivCnt,
  String? defectivFromDate,
  num? emptyCRDCnt,
  num? emptyDefectivCnt,
  num? nCCnt,
  num? dBCCnt,
  num? rCCnt,
  num? refillSaleCnt,
  num? imbalanceCnt,
  num? emptyCnt,
  num? tVQty,
  num? sVQty,
  num? deffQty,
}) => GetCurrentStockDetailManagerModel(  distributorId: distributorId ?? _distributorId,
  itemId: itemId ?? _itemId,
  itemName: itemName ?? _itemName,
  currentStkFilled: currentStkFilled ?? _currentStkFilled,
  currentStkEmpty: currentStkEmpty ?? _currentStkEmpty,
  filledCnt: filledCnt ?? _filledCnt,
  totalInvoiceCnt: totalInvoiceCnt ?? _totalInvoiceCnt,
  filledEMRCnt: filledEMRCnt ?? _filledEMRCnt,
  emptyTVCnt: emptyTVCnt ?? _emptyTVCnt,
  defectivCnt: defectivCnt ?? _defectivCnt,
  defectivFromDate: defectivFromDate ?? _defectivFromDate,
  emptyCRDCnt: emptyCRDCnt ?? _emptyCRDCnt,
  emptyDefectivCnt: emptyDefectivCnt ?? _emptyDefectivCnt,
  nCCnt: nCCnt ?? _nCCnt,
  dBCCnt: dBCCnt ?? _dBCCnt,
  rCCnt: rCCnt ?? _rCCnt,
  refillSaleCnt: refillSaleCnt ?? _refillSaleCnt,
  imbalanceCnt: imbalanceCnt ?? _imbalanceCnt,
  emptyCnt: emptyCnt ?? _emptyCnt,
  tVQty: tVQty ?? _tVQty,
  sVQty: sVQty ?? _sVQty,
  deffQty: deffQty ?? _deffQty,
);
  num? get distributorId => _distributorId;
  num? get itemId => _itemId;
  String? get itemName => _itemName;
  num? get currentStkFilled => _currentStkFilled;
  num? get currentStkEmpty => _currentStkEmpty;
  num? get filledCnt => _filledCnt;
  num? get totalInvoiceCnt => _totalInvoiceCnt;
  num? get filledEMRCnt => _filledEMRCnt;
  num? get emptyTVCnt => _emptyTVCnt;
  num? get defectivCnt => _defectivCnt;
  String? get defectivFromDate => _defectivFromDate;
  num? get emptyCRDCnt => _emptyCRDCnt;
  num? get emptyDefectivCnt => _emptyDefectivCnt;
  num? get nCCnt => _nCCnt;
  num? get dBCCnt => _dBCCnt;
  num? get rCCnt => _rCCnt;
  num? get refillSaleCnt => _refillSaleCnt;
  num? get imbalanceCnt => _imbalanceCnt;
  num? get emptyCnt => _emptyCnt;
  num? get tVQty => _tVQty;
  num? get sVQty => _sVQty;
  num? get deffQty => _deffQty;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['ItemId'] = _itemId;
    map['ItemName'] = _itemName;
    map['CurrentStkFilled'] = _currentStkFilled;
    map['CurrentStkEmpty'] = _currentStkEmpty;
    map['FilledCnt'] = _filledCnt;
    map['TotalInvoiceCnt'] = _totalInvoiceCnt;
    map['FilledEMRCnt'] = _filledEMRCnt;
    map['EmptyTVCnt'] = _emptyTVCnt;
    map['DefectivCnt'] = _defectivCnt;
    map['DefectivFromDate'] = _defectivFromDate;
    map['EmptyCRDCnt'] = _emptyCRDCnt;
    map['EmptyDefectivCnt'] = _emptyDefectivCnt;
    map['NCCnt'] = _nCCnt;
    map['DBCCnt'] = _dBCCnt;
    map['RCCnt'] = _rCCnt;
    map['RefillSaleCnt'] = _refillSaleCnt;
    map['ImbalanceCnt'] = _imbalanceCnt;
    map['EmptyCnt'] = _emptyCnt;
    map['TVQty'] = _tVQty;
    map['SVQty'] = _sVQty;
    map['DeffQty'] = _deffQty;
    return map;
  }

}