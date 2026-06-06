/// DistributorId : 0
/// FromDate : null
/// ToDate : null
/// SQCId : 2
/// GodownId : 1
/// ReceiptDate : "2026-03-13T00:00:00"
/// VehicleNo : "Mh15kh5681"
/// ItemId : 5
/// TareWt : 6.00
/// GrossWt : 8.00
/// ObservedWt : 8.10
/// Variation : -0.10
/// DPTDate : "S-25"
/// SealingCond : "Y"
/// LeakyBdy : 20
/// SerialNo : "SRL536"
/// Remarks : "okayn.,mn,mn,m"
/// AddedBy : null
/// AddedOn : null
/// UploadFileName : "2_8118_20260313174912.png"
/// LastUpdatedOn : null
/// ItemName : "2 KG FTL"
/// Action : null
/// Leakage : "Y"
/// Platform : null
/// UpdatedBy : 0
/// LeakName : "Underweight"
/// UploadFilePath : "https://aadyaminfotech.com/lpgniyojanuatapi/SQCFile/2_8118_20260313174912.png"

class GetSqcFilledCylListModel {
  GetSqcFilledCylListModel({
    num? distributorId,
    dynamic fromDate,
    dynamic toDate,
    num? sQCId,
    num? godownId,
    String? receiptDate,
    String? vehicleNo,
    num? itemId,
    num? tareWt,
    num? grossWt,
    num? observedWt,
    num? variation,
    String? dPTDate,
    String? sealingCond,
    num? leakyBdy,
    String? serialNo,
    String? remarks,
    dynamic addedBy,
    dynamic addedOn,
    String? uploadFileName,
    dynamic lastUpdatedOn,
    String? itemName,
    dynamic action,
    String? leakage,
    dynamic platform,
    num? updatedBy,
    String? leakName,
    String? uploadFilePath,}){
    _distributorId = distributorId;
    _fromDate = fromDate;
    _toDate = toDate;
    _sQCId = sQCId;
    _godownId = godownId;
    _receiptDate = receiptDate;
    _vehicleNo = vehicleNo;
    _itemId = itemId;
    _tareWt = tareWt;
    _grossWt = grossWt;
    _observedWt = observedWt;
    _variation = variation;
    _dPTDate = dPTDate;
    _sealingCond = sealingCond;
    _leakyBdy = leakyBdy;
    _serialNo = serialNo;
    _remarks = remarks;
    _addedBy = addedBy;
    _addedOn = addedOn;
    _uploadFileName = uploadFileName;
    _lastUpdatedOn = lastUpdatedOn;
    _itemName = itemName;
    _action = action;
    _leakage = leakage;
    _platform = platform;
    _updatedBy = updatedBy;
    _leakName = leakName;
    _uploadFilePath = uploadFilePath;
  }

  GetSqcFilledCylListModel.fromJson(dynamic json) {
    _distributorId = json['DistributorId'];
    _fromDate = json['FromDate'];
    _toDate = json['ToDate'];
    _sQCId = json['SQCId'];
    _godownId = json['GodownId'];
    _receiptDate = json['ReceiptDate'];
    _vehicleNo = json['VehicleNo'];
    _itemId = json['ItemId'];
    _tareWt = json['TareWt'];
    _grossWt = json['GrossWt'];
    _observedWt = json['ObservedWt'];
    _variation = json['Variation'];
    _dPTDate = json['DPTDate'];
    _sealingCond = json['SealingCond'];
    _leakyBdy = json['LeakyBdy'];
    _serialNo = json['SerialNo'];
    _remarks = json['Remarks'];
    _addedBy = json['AddedBy'];
    _addedOn = json['AddedOn'];
    _uploadFileName = json['UploadFileName'];
    _lastUpdatedOn = json['LastUpdatedOn'];
    _itemName = json['ItemName'];
    _action = json['Action'];
    _leakage = json['Leakage'];
    _platform = json['Platform'];
    _updatedBy = json['UpdatedBy'];
    _leakName = json['LeakName'];
    _uploadFilePath = json['UploadFilePath'];
  }
  num? _distributorId;
  dynamic _fromDate;
  dynamic _toDate;
  num? _sQCId;
  num? _godownId;
  String? _receiptDate;
  String? _vehicleNo;
  num? _itemId;
  num? _tareWt;
  num? _grossWt;
  num? _observedWt;
  num? _variation;
  String? _dPTDate;
  String? _sealingCond;
  num? _leakyBdy;
  String? _serialNo;
  String? _remarks;
  dynamic _addedBy;
  dynamic _addedOn;
  String? _uploadFileName;
  dynamic _lastUpdatedOn;
  String? _itemName;
  dynamic _action;
  String? _leakage;
  dynamic _platform;
  num? _updatedBy;
  String? _leakName;
  String? _uploadFilePath;
  GetSqcFilledCylListModel copyWith({  num? distributorId,
    dynamic fromDate,
    dynamic toDate,
    num? sQCId,
    num? godownId,
    String? receiptDate,
    String? vehicleNo,
    num? itemId,
    num? tareWt,
    num? grossWt,
    num? observedWt,
    num? variation,
    String? dPTDate,
    String? sealingCond,
    num? leakyBdy,
    String? serialNo,
    String? remarks,
    dynamic addedBy,
    dynamic addedOn,
    String? uploadFileName,
    dynamic lastUpdatedOn,
    String? itemName,
    dynamic action,
    String? leakage,
    dynamic platform,
    num? updatedBy,
    String? leakName,
    String? uploadFilePath,
  }) => GetSqcFilledCylListModel(  distributorId: distributorId ?? _distributorId,
    fromDate: fromDate ?? _fromDate,
    toDate: toDate ?? _toDate,
    sQCId: sQCId ?? _sQCId,
    godownId: godownId ?? _godownId,
    receiptDate: receiptDate ?? _receiptDate,
    vehicleNo: vehicleNo ?? _vehicleNo,
    itemId: itemId ?? _itemId,
    tareWt: tareWt ?? _tareWt,
    grossWt: grossWt ?? _grossWt,
    observedWt: observedWt ?? _observedWt,
    variation: variation ?? _variation,
    dPTDate: dPTDate ?? _dPTDate,
    sealingCond: sealingCond ?? _sealingCond,
    leakyBdy: leakyBdy ?? _leakyBdy,
    serialNo: serialNo ?? _serialNo,
    remarks: remarks ?? _remarks,
    addedBy: addedBy ?? _addedBy,
    addedOn: addedOn ?? _addedOn,
    uploadFileName: uploadFileName ?? _uploadFileName,
    lastUpdatedOn: lastUpdatedOn ?? _lastUpdatedOn,
    itemName: itemName ?? _itemName,
    action: action ?? _action,
    leakage: leakage ?? _leakage,
    platform: platform ?? _platform,
    updatedBy: updatedBy ?? _updatedBy,
    leakName: leakName ?? _leakName,
    uploadFilePath: uploadFilePath ?? _uploadFilePath,
  );
  num? get distributorId => _distributorId;
  dynamic get fromDate => _fromDate;
  dynamic get toDate => _toDate;
  num? get sQCId => _sQCId;
  num? get godownId => _godownId;
  String? get receiptDate => _receiptDate;
  String? get vehicleNo => _vehicleNo;
  num? get itemId => _itemId;
  num? get tareWt => _tareWt;
  num? get grossWt => _grossWt;
  num? get observedWt => _observedWt;
  num? get variation => _variation;
  String? get dPTDate => _dPTDate;
  String? get sealingCond => _sealingCond;
  num? get leakyBdy => _leakyBdy;
  String? get serialNo => _serialNo;
  String? get remarks => _remarks;
  dynamic get addedBy => _addedBy;
  dynamic get addedOn => _addedOn;
  String? get uploadFileName => _uploadFileName;
  dynamic get lastUpdatedOn => _lastUpdatedOn;
  String? get itemName => _itemName;
  dynamic get action => _action;
  String? get leakage => _leakage;
  dynamic get platform => _platform;
  num? get updatedBy => _updatedBy;
  String? get leakName => _leakName;
  String? get uploadFilePath => _uploadFilePath;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['DistributorId'] = _distributorId;
    map['FromDate'] = _fromDate;
    map['ToDate'] = _toDate;
    map['SQCId'] = _sQCId;
    map['GodownId'] = _godownId;
    map['ReceiptDate'] = _receiptDate;
    map['VehicleNo'] = _vehicleNo;
    map['ItemId'] = _itemId;
    map['TareWt'] = _tareWt;
    map['GrossWt'] = _grossWt;
    map['ObservedWt'] = _observedWt;
    map['Variation'] = _variation;
    map['DPTDate'] = _dPTDate;
    map['SealingCond'] = _sealingCond;
    map['LeakyBdy'] = _leakyBdy;
    map['SerialNo'] = _serialNo;
    map['Remarks'] = _remarks;
    map['AddedBy'] = _addedBy;
    map['AddedOn'] = _addedOn;
    map['UploadFileName'] = _uploadFileName;
    map['LastUpdatedOn'] = _lastUpdatedOn;
    map['ItemName'] = _itemName;
    map['Action'] = _action;
    map['Leakage'] = _leakage;
    map['Platform'] = _platform;
    map['UpdatedBy'] = _updatedBy;
    map['LeakName'] = _leakName;
    map['UploadFilePath'] = _uploadFilePath;
    return map;
  }

}