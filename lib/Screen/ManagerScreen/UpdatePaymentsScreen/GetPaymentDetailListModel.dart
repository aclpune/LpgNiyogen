/// PaymentId : 709
/// DistributorId : 8118
/// VoucherNo : "EXP/000068"
/// PaymentTo : 1
/// PaymentDate : "29-05-2025"
/// StaffId : 44
/// VendorId : 0
/// VehId : 17
/// VehicleNo : "MH12PQ8949"
/// StaffName : "19kg Devendra"
/// Amount : 100.00
/// ExpHeadId : 11
/// PaymentMode : "Cash"
/// PayRemark : ""
/// TransTime : ""
/// TransationCode : ""
/// TransRemark : ""
/// ExpHeadName : "ARB Item Purchase"
/// BankId : 0
/// MappingId : 0
/// AccountNo : null

class GetPaymentDetailListModel {
  GetPaymentDetailListModel({
      num? paymentId, 
      num? distributorId, 
      String? voucherNo, 
      num? paymentTo, 
      String? paymentDate, 
      num? staffId, 
      num? vendorId, 
      num? vehId, 
      String? vehicleNo, 
      String? staffName, 
      num? amount, 
      num? expHeadId, 
      String? paymentMode, 
      String? payRemark, 
      String? transTime, 
      String? transationCode, 
      String? transRemark, 
      String? expHeadName, 
      num? bankId, 
      num? mappingId, 
      dynamic accountNo,}){
    _paymentId = paymentId;
    _distributorId = distributorId;
    _voucherNo = voucherNo;
    _paymentTo = paymentTo;
    _paymentDate = paymentDate;
    _staffId = staffId;
    _vendorId = vendorId;
    _vehId = vehId;
    _vehicleNo = vehicleNo;
    _staffName = staffName;
    _amount = amount;
    _expHeadId = expHeadId;
    _paymentMode = paymentMode;
    _payRemark = payRemark;
    _transTime = transTime;
    _transationCode = transationCode;
    _transRemark = transRemark;
    _expHeadName = expHeadName;
    _bankId = bankId;
    _mappingId = mappingId;
    _accountNo = accountNo;
}

  GetPaymentDetailListModel.fromJson(dynamic json) {
    _paymentId = json['PaymentId'];
    _distributorId = json['DistributorId'];
    _voucherNo = json['VoucherNo'];
    _paymentTo = json['PaymentTo'];
    _paymentDate = json['PaymentDate'];
    _staffId = json['StaffId'];
    _vendorId = json['VendorId'];
    _vehId = json['VehId'];
    _vehicleNo = json['VehicleNo'];
    _staffName = json['StaffName'];
    _amount = json['Amount'];
    _expHeadId = json['ExpHeadId'];
    _paymentMode = json['PaymentMode'];
    _payRemark = json['PayRemark'];
    _transTime = json['TransTime'];
    _transationCode = json['TransationCode'];
    _transRemark = json['TransRemark'];
    _expHeadName = json['ExpHeadName'];
    _bankId = json['BankId'];
    _mappingId = json['MappingId'];
    _accountNo = json['AccountNo'];
  }
  num? _paymentId;
  num? _distributorId;
  String? _voucherNo;
  num? _paymentTo;
  String? _paymentDate;
  num? _staffId;
  num? _vendorId;
  num? _vehId;
  String? _vehicleNo;
  String? _staffName;
  num? _amount;
  num? _expHeadId;
  String? _paymentMode;
  String? _payRemark;
  String? _transTime;
  String? _transationCode;
  String? _transRemark;
  String? _expHeadName;
  num? _bankId;
  num? _mappingId;
  dynamic _accountNo;
GetPaymentDetailListModel copyWith({  num? paymentId,
  num? distributorId,
  String? voucherNo,
  num? paymentTo,
  String? paymentDate,
  num? staffId,
  num? vendorId,
  num? vehId,
  String? vehicleNo,
  String? staffName,
  num? amount,
  num? expHeadId,
  String? paymentMode,
  String? payRemark,
  String? transTime,
  String? transationCode,
  String? transRemark,
  String? expHeadName,
  num? bankId,
  num? mappingId,
  dynamic accountNo,
}) => GetPaymentDetailListModel(  paymentId: paymentId ?? _paymentId,
  distributorId: distributorId ?? _distributorId,
  voucherNo: voucherNo ?? _voucherNo,
  paymentTo: paymentTo ?? _paymentTo,
  paymentDate: paymentDate ?? _paymentDate,
  staffId: staffId ?? _staffId,
  vendorId: vendorId ?? _vendorId,
  vehId: vehId ?? _vehId,
  vehicleNo: vehicleNo ?? _vehicleNo,
  staffName: staffName ?? _staffName,
  amount: amount ?? _amount,
  expHeadId: expHeadId ?? _expHeadId,
  paymentMode: paymentMode ?? _paymentMode,
  payRemark: payRemark ?? _payRemark,
  transTime: transTime ?? _transTime,
  transationCode: transationCode ?? _transationCode,
  transRemark: transRemark ?? _transRemark,
  expHeadName: expHeadName ?? _expHeadName,
  bankId: bankId ?? _bankId,
  mappingId: mappingId ?? _mappingId,
  accountNo: accountNo ?? _accountNo,
);
  num? get paymentId => _paymentId;
  num? get distributorId => _distributorId;
  String? get voucherNo => _voucherNo;
  num? get paymentTo => _paymentTo;
  String? get paymentDate => _paymentDate;
  num? get staffId => _staffId;
  num? get vendorId => _vendorId;
  num? get vehId => _vehId;
  String? get vehicleNo => _vehicleNo;
  String? get staffName => _staffName;
  num? get amount => _amount;
  num? get expHeadId => _expHeadId;
  String? get paymentMode => _paymentMode;
  String? get payRemark => _payRemark;
  String? get transTime => _transTime;
  String? get transationCode => _transationCode;
  String? get transRemark => _transRemark;
  String? get expHeadName => _expHeadName;
  num? get bankId => _bankId;
  num? get mappingId => _mappingId;
  dynamic get accountNo => _accountNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['PaymentId'] = _paymentId;
    map['DistributorId'] = _distributorId;
    map['VoucherNo'] = _voucherNo;
    map['PaymentTo'] = _paymentTo;
    map['PaymentDate'] = _paymentDate;
    map['StaffId'] = _staffId;
    map['VendorId'] = _vendorId;
    map['VehId'] = _vehId;
    map['VehicleNo'] = _vehicleNo;
    map['StaffName'] = _staffName;
    map['Amount'] = _amount;
    map['ExpHeadId'] = _expHeadId;
    map['PaymentMode'] = _paymentMode;
    map['PayRemark'] = _payRemark;
    map['TransTime'] = _transTime;
    map['TransationCode'] = _transationCode;
    map['TransRemark'] = _transRemark;
    map['ExpHeadName'] = _expHeadName;
    map['BankId'] = _bankId;
    map['MappingId'] = _mappingId;
    map['AccountNo'] = _accountNo;
    return map;
  }

}