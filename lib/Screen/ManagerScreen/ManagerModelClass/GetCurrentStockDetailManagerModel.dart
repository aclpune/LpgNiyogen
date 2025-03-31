/// DistributorId : 0
/// ItemId : 1
/// ItemName : "14.2 KG"
/// CurrentStkFilled : 0
/// CurrentStkEmpty : 0
/// FilledCnt : 324
/// TotalInvoiceCnt : 324
/// FilledEMRCnt : 0
/// EmptyTVCnt : 0
/// DefectivCnt : 101
/// DefectivFromDate : "2025-03-24T00:00:00"
/// EmptyCRDCnt : 324
/// EmptyDefectivCnt : 0
/// NCCnt : 0
/// DBCCnt : 0
/// RCCnt : 0
/// RefillSaleCnt : 826
/// ImbalanceCnt : 0
/// EmptyCnt : 0
/// TVQty : 0
/// SVQty : 6
/// DeffQty : 101
/// FilledOpeningStk : 2000
/// EmptyOpeningStk : 1200
/// DeffOpeningStk : 0
/// FilledCurrentStk : 2112
/// EmptyCurrentStk : 2676
/// DeffCurrentStk : 101

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
      num? deffQty, 
      num? filledOpeningStk, 
      num? emptyOpeningStk, 
      num? deffOpeningStk, 
      num? filledCurrentStk, 
      num? emptyCurrentStk, 
      num? deffCurrentStk,}){
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
    _filledOpeningStk = filledOpeningStk;
    _emptyOpeningStk = emptyOpeningStk;
    _deffOpeningStk = deffOpeningStk;
    _filledCurrentStk = filledCurrentStk;
    _emptyCurrentStk = emptyCurrentStk;
    _deffCurrentStk = deffCurrentStk;
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
    _filledOpeningStk = json['FilledOpeningStk'];
    _emptyOpeningStk = json['EmptyOpeningStk'];
    _deffOpeningStk = json['DeffOpeningStk'];
    _filledCurrentStk = json['FilledCurrentStk'];
    _emptyCurrentStk = json['EmptyCurrentStk'];
    _deffCurrentStk = json['DeffCurrentStk'];
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
  num? _filledOpeningStk;
  num? _emptyOpeningStk;
  num? _deffOpeningStk;
  num? _filledCurrentStk;
  num? _emptyCurrentStk;
  num? _deffCurrentStk;
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
  num? filledOpeningStk,
  num? emptyOpeningStk,
  num? deffOpeningStk,
  num? filledCurrentStk,
  num? emptyCurrentStk,
  num? deffCurrentStk,
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
  filledOpeningStk: filledOpeningStk ?? _filledOpeningStk,
  emptyOpeningStk: emptyOpeningStk ?? _emptyOpeningStk,
  deffOpeningStk: deffOpeningStk ?? _deffOpeningStk,
  filledCurrentStk: filledCurrentStk ?? _filledCurrentStk,
  emptyCurrentStk: emptyCurrentStk ?? _emptyCurrentStk,
  deffCurrentStk: deffCurrentStk ?? _deffCurrentStk,
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
  num? get filledOpeningStk => _filledOpeningStk;
  num? get emptyOpeningStk => _emptyOpeningStk;
  num? get deffOpeningStk => _deffOpeningStk;
  num? get filledCurrentStk => _filledCurrentStk;
  num? get emptyCurrentStk => _emptyCurrentStk;
  num? get deffCurrentStk => _deffCurrentStk;

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
    map['FilledOpeningStk'] = _filledOpeningStk;
    map['EmptyOpeningStk'] = _emptyOpeningStk;
    map['DeffOpeningStk'] = _deffOpeningStk;
    map['FilledCurrentStk'] = _filledCurrentStk;
    map['EmptyCurrentStk'] = _emptyCurrentStk;
    map['DeffCurrentStk'] = _deffCurrentStk;
    return map;
  }

}